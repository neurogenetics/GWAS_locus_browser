constraint<-list()
constraint$id <- "constraint"
constraint$title <- "Constraint Values"

constraint$loadData<- function(){
  #read the constraint values for all the genes
  constraintData <<- fread("www/constraint/ConstraintData.csv")
}

constraint$generateUI<- function(){
  div(id="constraintSection",
      fluidRow(
        column(div(uiOutput('constraintSelectUI'),class="geneselect"),width =2)
      ),
      fluidRow(
        column(dataTableOutput("constraintTable"), width = 12)
      )
  )
}

constraint$serverLogic <- function(input,output,session,reactives)
{
  
  
  #populate the dropdown using the reactive value
  output$constraintSelectUI <- renderUI({
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
    
    selectInput("constraintSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  
  #load the constraint data table
  output$constraintTable <- renderDT({
    
    tableData <- NULL
    
    #by default assume 'All Genes' option is selected
    if(is.null(input$constraintSelect))
    {
      tableData <- constraintData[constraintData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRiskVariant()$LOC_NUM) & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      if(input$constraintSelect=="All Genes")
      {
        tableData <- constraintData[constraintData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRiskVariant()$LOC_NUM) & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
        scrollYVal <- 300
      }
      else
      {
        tableData <- constraintData[constraintData$GENE == input$constraintSelect,]
        scrollYVal <- 50
      }
    }

    colnames(tableData)[colnames(tableData)=='GENE']<-'Gene'
    datatable(tableData, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY =  paste0(scrollYVal,"px"), scrollX = T,
                                                      columnDefs = list(list(
                                                        targets = c(1:6),
                                                        render = JS(
                                                          "function(data, type, row, meta) {",
                                                          "return (data==null) ? 'NA' : data;",
                                                          "}"
                                                        )))
    ))
  })
}