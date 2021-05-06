
coexpression<-list()
coexpression$id <- "coexpression"
coexpression$title <- "Co-Expression Data"

coexpression$loadData<- function(){

  coexpressionData <<- fread("www/coexpression/coExpressionData.csv")

}

coexpression$generateUI<- function(){
  div(
    fluidRow(
      column(div(uiOutput('coExpSelectUI'),class="geneselect"),width =2)
    ),
    fluidRow(
      column(dataTableOutput("coExpTable"), width = 12)
    )
  )
}  

coexpression$serverLogic <- function(input,output,session,reactives)
{
  
  #populate the dropdown using the reactive value
  output$coExpSelectUI <- renderUI({
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
    
    selectInput("coExpSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  #load the disease gene table
  output$coExpTable <- renderDT({
    
    tableData <- NULL
    
    if(is.null(input$coExpSelect))
    {
      tableData <- coexpressionData[coexpressionData$GENE %in% (evidence[evidence$LOC_NUM== reactives$selRiskVariant()$LOC_NUM & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      if(input$coExpSelect=="All Genes")
      {
        tableData <- coexpressionData[coexpressionData$GENE %in% (evidence[evidence$LOC_NUM== reactives$selRiskVariant()$LOC_NUM & evidence$GWAS == reactives$selRiskVariant()$GWAS,]$GENE),]
        scrollYVal <- 300
      }
      else
      {
        tableData <- coexpressionData[coexpressionData$GENE == input$coExpSelect,]
        scrollYVal <- 300
      }
    }
    tableData <- tableData[,!c("GWAS","LOC_NUM")]
    colnames(tableData)[colnames(tableData)=='GENE']<-'Gene'
    datatable(tableData, rownames = F, escape = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY =  paste0(scrollYVal,"px"), scrollX = T,
                                                                  columnDefs = list(list(
                                                                    render = JS(
                                                                      "function(data, type, row, meta) {",
                                                                      "return (data==='') ? 'none' : data;",
                                                                      "}"
                                                                    ),
                                                                    width = '40%',
                                                                    targets = c(1,2,3)))))
  })
}