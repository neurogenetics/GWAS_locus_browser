#https://www.genenetwork.nl/
pathways<-list()
pathways$id <- "pathways"
pathways$title <- "Gene Network Pathway Data"
pathways$loadData<- function(){
  
}

pathways$generateUI<- function(){
  div(id = "pathwaysSection",
      
      fluidRow(
        column(div(uiOutput('pathwaysSelectUI'),class="geneselect"),width =2)
      ),
      fluidRow(
        column(tabsetPanel(type="pills",
                           tabPanel("Reactome Pathways", 
                                    fluidRow(
                                      column(dataTableOutput("pathwaysReactomeTable"), width = 8)
                                    )
                           ),
                           tabPanel("KEGG Pathways", 
                                    fluidRow(
                                      column(dataTableOutput("pathwaysKEGGTable"), width = 8)
                                    )
                           ),
                           tabPanel("Coregulated Genes", 
                                    fluidRow(
                                      column(dataTableOutput("coregTable"), width = 8)
                                    )
                           ),
                           selected = "Reactome Pathways"
        )
        ,width = 12)
      )
  )
}


pathways$serverLogic <- function(input,output,session,reactives)
{
  #populate the dropdown using the reactive value
  output$pathwaysSelectUI <- renderUI({
    dropDownGenes <- (evidence[(evidence$RSID == reactives$selRiskVariant()$RSID & (evidence$GWAS == reactives$selRiskVariant()$GWAS)),]$GENE)
    
    #default selected to the first in the list
    selected_gene <- dropDownGenes[1]
    #if there was a searched gene, select that
    if(reactives$searchedGene()!="")
    {
      selected_gene <-dropDownGenes[match(toupper(reactives$searchedGene()), toupper(as.vector(dropDownGenes)))] 
    }
    
    selectInput("pathwaysSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  
  
  output$pathwaysReactomeTable <- renderDT({
    
    if(!is.null(input$pathwaysSelect))
    {
      
      pathwaydf <- tryCatch(
        {
          
          response <- httr::GET(paste0("https://www.genenetwork.nl/api/v1/gene/",input$pathwaysSelect,"?db=REACTOME&verbose"), timeout(5))
          responsedf <- content(response)
          pathwaydf <- data.frame(Pathway=sapply(lapply(responsedf$pathways$predicted, `[[`, "term"),"[[","name"),'P-value'=sapply(responsedf$pathways$predicted, `[[`, "pValue"),'Z-score'=sapply(responsedf$pathways$predicted, `[[`, "zScore"), check.names = FALSE)
        }, error = function(err) {
          data.frame(Pathway=c(),'P-value'=c(),'Z-score'=c(), check.names = FALSE)
        })

      datatable(pathwaydf, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY = '300px', scrollX = T, columnDefs = list(list(
        className = 'dt-right', 
        targets = c(1,2),
        render = JS(
          "function(data, type, row, meta) {",
          "return (data==null) ? 'NA' : parseFloat(data).toPrecision(3);",
          "}"
        )))))
    }

    
  })
  
  output$pathwaysKEGGTable <- renderDT({
    
    
    if(!is.null(input$pathwaysSelect))
    {
      
      pathwaydf <- tryCatch(
        {
          response <- httr::GET(paste0("https://www.genenetwork.nl/api/v1/gene/",input$pathwaysSelect,"?db=KEGG&verbose"), timeout(5))
          responsedf <- content(response)
          pathwaydf <- data.frame(Pathway=sapply(lapply(responsedf$pathways$predicted, `[[`, "term"),"[[","name"),'P-value'=sapply(responsedf$pathways$predicted, `[[`, "pValue"),'Z-score'=sapply(responsedf$pathways$predicted, `[[`, "zScore"), check.names = FALSE)
        }, error = function(err) {
          data.frame(Pathway=c(),'P-value'=c(),'Z-score'=c(), check.names = FALSE)
        })
      

      datatable(pathwaydf, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY = '300px', scrollX = T, columnDefs = list(list(
        className = 'dt-right', 
        targets = c(1,2),
        render = JS(
          "function(data, type, row, meta) {",
          "return (data==null) ? 'NA' : parseFloat(data).toPrecision(3);",
          "}"
        )))))
    }
  })
  
  output$coregTable <- renderDT({
    
    if(!is.null(input$pathwaysSelect))
    {
      
      coregdf <- tryCatch(
        {
          response <- httr::GET(paste0("https://www.genenetwork.nl/api/v1/coregulation/",input$pathwaysSelect,"?verbose"), timeout(5))
          responsedf <- content(response)
          coregdf <- data.frame(Gene=sapply(lapply(responsedf$data, `[[`, "gene"),"[[","name"),'P-value'=sapply(responsedf$data, `[[`, "pValue"), check.names = FALSE)
        }, error = function(err) {
          data.frame(Gene=c(),'P-value'=c(), check.names = FALSE)
        })
      
      datatable(coregdf, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY = '300px', scrollX = T, columnDefs = list(list(
        className = 'dt-right', 
        targets = c(1),
        render = JS(
          "function(data, type, row, meta) {",
          "return (data==null) ? 'NA' : parseFloat(data).toPrecision(3);",
          "}"
        )))))
    }
  })
}