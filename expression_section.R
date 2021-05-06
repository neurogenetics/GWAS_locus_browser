expression<-list()
expression$id <- "expression"
expression$title <- "Expression Data"

expression$loadData<- function(){
  
  #read the average expression data for the brain and substantia nigra and single cell data
  expressionData <<- fread("www/expression/ExpressionData.csv")
  colnames(expressionData) <<- c("GENE","GTEX_BRAIN_all","GTEX_nigra","SN Astrocyte","SN-Dop. Neuron","SN Endothelial","SN-GABA Neuron","SN Microglia","SN ODC","SN OPC")
}

expression$generateUI<- function(){
  div(
    fluidRow(
      column(div(uiOutput('expressionSelectUI'),class="geneselect"),width =2)
    ),
    fluidRow(
      column(tabsetPanel(type="pills",
                         tabPanel("Table", 
                                  fluidRow(
                                    column(dataTableOutput("expressionTable"), width = 12)
                                  )
                         ),
                         tabPanel("Single Cell Expression Bar Plot", 
                                  fluidRow(
                                    column(align = "center", plotlyOutput("SingleCellPlot"), width = 12)
                                  )
                         ),
                         tabPanel("GTEx Expression Violin Plot", 
                                  fluidRow(
                                    column(align = "center", h4("GTEx Expression Plot"), width = 12)
                                    
                                  ),
                                  fluidRow(
                                    column( align = "center", imageOutput("GTEXPlot", width = "40%", height = "auto"), width = 12)
                                  )
                         ),
                         selected = "Table"
      )
      ,width = 12)
    )
  )
}

expression$serverLogic <- function(input,output,session,reactives)
{

  #populate the dropdown using the reactive value
  output$expressionSelectUI <- renderUI({
    dropDownGenes <- (evidence[(evidence$RSID == reactives$selRiskVariant()$RSID & (evidence$GWAS == reactives$selRiskVariant()$GWAS)),]$GENE)
    
    #add "All Genes" to the list for the other drop downs
    dropDownGenes <- append(dropDownGenes, "All Genes", 0)
    
    #default selected to the first in the list
    selected_gene <- dropDownGenes[1]
    #if there was a searched gene, select that
    if(reactives$searchedGene()!="")
    {
      selected_gene <-dropDownGenes[match(toupper(reactives$searchedGene()), toupper(as.vector(dropDownGenes)))] 
    }
    
    selectInput("expressionSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  #render expression table using genes matching the selected locus in the evidence table
  output$expressionTable <- renderDT({
    
    tableData <- NULL
    
    #by default assume 'All Genes' option is selected
    if(is.null(input$expressionSelect))
    {
      tableData <- expressionData[expressionData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRiskVariant()$LOC_NUM) & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      if(input$expressionSelect=="All Genes")
      {
        tableData <- expressionData[expressionData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRiskVariant()$LOC_NUM) & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
        scrollYVal <- 300
      }
      else
      {
        tableData <- expressionData[expressionData$GENE == input$expressionSelect,]
        scrollYVal <- 50
      }
    }

    colnames(tableData)[colnames(tableData)=='GENE']<-'Gene'
    datatable(tableData, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY =  paste0(scrollYVal,"px"), scrollX = T, columnDefs = list(list(
      targets = c(1:9),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toFixed(2);",
        "}"
      )))))
  })
  
  #load the gtex plot
  output$GTEXPlot <- renderImage({
    no_plot_str <-""
    if(input$expressionSelect!='All Genes')
    {
      no_plot_str <-paste0("No GTEx violin plot for ", input$expressionSelect)
    }
    else
    {
      no_plot_str <- "Please select a gene"
    }
    filename <- paste0("www/expression/gtex_plots/",input$expressionSelect,"_gtex8_expression.png")
    list(src = filename, contentType = 'image/png', width = '100%', alt = no_plot_str)
    # filename <- paste0("www/expression/gtex_plots/",input$GTEXSelect,"_gtex8_expression.png")
    # list(src = filename, contentType = 'image/png', width = '100%', alt = "No Violin Plot for Gene")
  }, deleteFile = FALSE)
  
  
  #create plotly bar plot for single cell expression data
  output$SingleCellPlot <- renderPlotly({
    
    plotData <- NULL
    if(input$expressionSelect!="All Genes")
    {
      plotData <- expressionData[expressionData$GENE == input$expressionSelect,] %>% select("SN Astrocyte","SN-Dop. Neuron","SN Endothelial", "SN-GABA Neuron", "SN Microglia", "SN ODC" ,"SN OPC")
      colnames(plotData)<- c("Astrocyte","DaN","Endothelial", "GABA","Microglia","ODC","OPC")
      
      plotData <- setDT(as.data.frame(t(plotData)), keep.rownames = "cell_types")[]
      
      p <- plot_ly(data = plotData,x = plotData$V1, y = plotData$cell_types, type = "bar",orientation = "h") %>% layout(xaxis = list(title = "Gene Expression (TPM)") ) %>% plotly::config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d","pan2d","select2d","lasso2d","toggleSpikelines","autoScale2d"),displaylogo=FALSE)
    }
    
  })
  
}