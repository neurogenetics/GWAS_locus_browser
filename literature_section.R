literature<-list()
literature$id <- "literature"
literature$title <- "Literature"

literature$loadData<- function(){
  pubmedhits <<- fread("www/pubmed/PubmedHitsData.csv")
  #geneCards descriptions
  genecards <<- fread("www/pubmed/GeneCardDescriptions.txt",sep="\t")
}
literature$generateUI<- function(){
  
  div(id="litSection",
      
      
      fluidRow(
        column(div(uiOutput('litGeneSelectUI'),class="geneselect"),width =2)
      ),
      boxPlus(
        title = "GeneCards Description",
        closable = FALSE,
        width = 12,
        status = "primary",
        htmlOutput("litOutput"),
        solidHeader = TRUE
      ),
      hr(),
      boxPlus(
        title= htmlOutput("pubMedHitHeader"),
        closable=FALSE,
        footer=HTML(paste0("<p>Number of PubMed articles from search term '(Parkinson's[Title/Abstract]) AND GENE_NAME[Title/Abstract]' for each gene as of ", literature_search_date,".</p><p>Click bars to open PubMed search for gene in a new tab.</p>")),
        width = 4,
        status="primary",
        plotlyOutput("pubMedHitPlot"),
        solidHeader=TRUE
      ),
      boxPlus(
        title= htmlOutput("geneHitHeader"),
        closable=FALSE,
        footer=HTML(paste0("<p>Number of PubMed articles from search term 'GENE_NAME[Title/Abstract]' for each gene as of ",literature_search_date,".</p><p>Click bars to open PubMed search for gene in a new tab.</p>")),
        width = 4,
        status="primary",
        plotlyOutput("geneHitPlot"),
        solidHeader=TRUE
      ),
      boxPlus(
        title= htmlOutput("wordCloudHeader"),
        closable=FALSE,
        footer=paste0("Word cloud for common words found in PubMed abstracts for the selected gene as of ",literature_search_date,"."),
        width = 4,
        status="primary",
        imageOutput("wordCloud", width = "100%", height = "auto"),
        solidHeader=TRUE
      )
  )
}


literature$serverLogic <- function(input,output,session,reactives)
{
  
  #populate the dropdown using the reactive value
  output$litGeneSelectUI <- renderUI({
    dropDownGenes <- (evidence[(evidence$RSID == reactives$selRiskVariant()$RSID & (evidence$GWAS == reactives$selRiskVariant()$GWAS)),]$GENE)
    
    #default selected to the first in the list
    selected_gene <- dropDownGenes[1]
    #if there was a searched gene, select that
    if(reactives$searchedGene()!="")
    {
      selected_gene <-dropDownGenes[match(toupper(reactives$searchedGene()), toupper(as.vector(dropDownGenes)))] 
    }
    
    selectInput("litGeneSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  
  output$wordCloudHeader <- renderUI(
    HTML(paste0("<h4><i>",input$litGeneSelect,"</i> Word Cloud</h4>"))
  )
  #load the geneCard description for the gene
  output$litOutput <- renderUI({
    
    description <- genecards[genecards$Gene==input$litGeneSelect,]$Description
    HTML(description)
    
  })
  
  output$pubMedHitHeader <- renderUI(
    HTML(paste0("<h4>PubMed Hits for Locus ", reactives$selRiskVariant()$LOC_NUM, " Genes and Parkinson's</h4>"))
  )
  #render the pubmed search bar plots for "Parkinson's and [Gene]" searches in title/abstract
  output$pubMedHitPlot <- renderPlotly({
    
    subsetgenes <- pubmedhits[pubmedhits$LOC_NUM==reactives$selRiskVariant()$'LOC_NUM' & pubmedhits$GWAS==reactives$selRiskVariant()$GWAS,]
    
    genefreq <- subsetgenes %>% select("GENE", "Pubmed hits")
    
    #remove rows with zero hits for gene only search
    genefreq <- genefreq[genefreq$"Pubmed hits" !=0, ]
    
    genefreq$GENE <- factor(genefreq$GENE, levels = unique(genefreq$GENE)[order(genefreq$"Pubmed hits", decreasing = TRUE)])
    
    genefreq$url <- paste0("https://www.ncbi.nlm.nih.gov/pubmed?term=(Parkinson%27s%5BTitle%2FAbstract%5D)%20AND%20",genefreq$GENE,"%5BTitle%2FAbstract%5D")
    
    js <- "
    function(el, x) {
      el.on('plotly_click', function(d) {
        var point = d.points[0];
        var url = point.data.customdata[point.pointIndex];
        window.open(url,'_blank');
      });
    }"
    
    p <- plot_ly(data = genefreq,y = genefreq$"Pubmed hits", x = genefreq$GENE, type = "bar", customdata = genefreq$url, text = ~paste('Click bar to search:'," (Parkinson's[Title/Abstract]) AND \n",genefreq$GENE,"[Title/Abstract]" )) %>% layout(xaxis = list(tickangle = -45)) %>% onRender(js) %>% plotly::config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d","pan2d","select2d","lasso2d","toggleSpikelines","autoScale2d"),displaylogo=FALSE)
    p
    
    
  })
  
  output$geneHitHeader <- renderUI(
    HTML(paste0("<h4>PubMed Hits for Locus ", reactives$selRiskVariant()$LOC_NUM, " Genes</h4>"))
  )
  #render the pubmed search bar plots for "[Gene]" searches in title/abstract
  output$geneHitPlot <- renderPlotly({
    subsetgenes <- pubmedhits[pubmedhits$LOC_NUM==reactives$selRiskVariant()$'LOC_NUM'  & pubmedhits$GWAS==reactives$selRiskVariant()$GWAS,]
    
    genefreq <- subsetgenes %>% select("GENE", "Pubmed hits gene only")
    
    #remove rows with zero hits for gene only search
    genefreq <- genefreq[genefreq$"Pubmed hits gene only" !=0, ]
    
    
    genefreq$GENE <- factor(genefreq$GENE, levels = unique(genefreq$GENE)[order(genefreq$"Pubmed hits gene only", decreasing = TRUE)])
    
    genefreq$url <- paste0("https://www.ncbi.nlm.nih.gov/pubmed/?term=",genefreq$GENE,"%5BTitle%2FAbstract%5D")
    
    js <- "
    function(el, x) {
      el.on('plotly_click', function(d) {
        var point = d.points[0];
        var url = point.data.customdata[point.pointIndex];
        window.open(url,'_blank');
      });
    }"
    
    p <- plot_ly(data = genefreq,y = genefreq$"Pubmed hits gene only", x = genefreq$GENE, type = "bar", customdata = genefreq$url, text = ~paste('Click bar to search: ',genefreq$GENE,"[Title/Abstract]")) %>% layout(xaxis = list(tickangle = -45) ) %>% onRender(js) %>% plotly::config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d","pan2d","select2d","lasso2d","toggleSpikelines","autoScale2d"),displaylogo=FALSE)
    
    
  })
  
  
  #load the pre-generated word cloud images
  output$wordCloud <- renderImage({
    wordcloud_name <- paste0("www/pubmed/wordcloud/", input$litGeneSelect, "_wordcloud", ".png")
    
    
    list(src = wordcloud_name, contentType = 'image/png', width = '100%', alt = "No Word Cloud")
    
  }, deleteFile = FALSE)
  
}