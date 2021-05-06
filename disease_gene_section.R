diseaseGene<-list()
diseaseGene$id <- "diseasegene"
diseaseGene$title <- "Disease Genes"

diseaseGene$loadData<- function(){
  #read in disease gene data
  diseaseData <<- fread("www/diseasegene/DiseaseGeneData.txt")
}

diseaseGene$generateUI<- function(){
  
  div(
    fluidRow(
      column(div(uiOutput('diseaseSelectUI'),class="geneselect"),width =2)
    ),
    fluidRow(
      column(dataTableOutput("diseaseTable"), width = 12)
    )
  )
}


diseaseGene$serverLogic <- function(input,output,session,reactives)
{
  
  
  #populate the dropdown using the reactive value
  output$diseaseSelectUI <- renderUI({
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
    
    selectInput("diseaseSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  #load the disease gene table
  output$diseaseTable <- renderDT({
    
    tableData <- NULL
    
    if(is.null(input$diseaseSelect))
    {
      tableData <- diseaseData[diseaseData$GENE %in% (evidence[evidence$LOC_NUM== reactives$selRiskVariant()$LOC_NUM & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      if(input$diseaseSelect=="All Genes")
      {
        tableData <- diseaseData[diseaseData$GENE %in% (evidence[evidence$LOC_NUM== reactives$selRiskVariant()$LOC_NUM & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
        scrollYVal <- 300
      }
      else
      {
        tableData <- diseaseData[diseaseData$GENE == input$diseaseSelect,]
        scrollYVal <- 300
      }
    }

    colnames(tableData)[colnames(tableData)=='GENE']<-'Gene'
    datatable(tableData, rownames = F, escape = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY =  paste0(scrollYVal,"px"), scrollX = T,
                                                                  columnDefs = list(list(
                                                                    render = JS(
                                                                      "function(data, type, row, meta) {",
                                                                      "return (data==='') ? 'NA' : data;",
                                                                      "}"
                                                                    ),
                                                                    width = '40%',
                                                                    targets = c(1,2)))))
  })
}