burden<-list()
burden$id <- "burden"
burden$title <- "Burden Evidence"

burden$loadData<- function(){
  
  
  #read the minimum p values for allburden tests for all the genes
  burdenData <<- fread("www/burden/BurdenPValueData.csv")
}

burden$generateUI<- function(){
  div(id = "burdenSection",
      
      fluidRow(
        column(div(uiOutput('burdenSelectUI'),class="geneselect"),width =2)
      ),
      fluidRow(
        column(dataTableOutput("burdenTable"), width = 5)
      )
  )
}


burden$serverLogic <- function(input,output,session,reactives)
{
  #populate the dropdown using the reactive value
  output$burdenSelectUI <- renderUI({
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
    
    selectInput("burdenSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  
  output$burdenTable <- renderDT({
    
    tableData <- NULL

    #by default assume 'All Genes' option is selected
    if(is.null(input$burdenSelect))
    {
      tableData <- burdenData[burdenData$GENE %in% (evidence[evidence$LOC_NUM== reactives$selRiskVariant()$LOC_NUM & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
      scrollYVal <- 200
    }
    else
    {
      if(input$burdenSelect=="All Genes")
      {
        tableData <- burdenData[burdenData$GENE %in% (evidence[evidence$LOC_NUM== reactives$selRiskVariant()$LOC_NUM & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
        scrollYVal <- 200
      }
      else
      {
        tableData <- burdenData[burdenData$GENE == input$burdenSelect,]
        scrollYVal <- 50
      }
    }

    colnames(tableData)[colnames(tableData)=='GENE'] <- 'Gene'
    datatable(tableData, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal,"px"), scrollX = T, columnDefs = list(list(
      targets = c(1,2),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(2);",
        "}"
      )))))
    
  })
}