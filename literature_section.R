
#render the text from the googledrive
renderGuesstimate <- function(){
  
  output$guessOutput <- renderUI({
    
    #gwas_id_string <- gsub(" GWAS","",isolate(input$gwasSelect))
    #gwas_id_string <- ifelse(gwas_id_string=="META5","",gwas_id_string)
    #need to authenticate since not looking up by ids
    token_name <- "authentication_token.rds"
    drive_auth(token = readRDS(token_name))
    
    drive_filename <- paste0("Locus ", ifelse(gwas_id_string=="META5","",gwas_id_string),reactives$selRow$LOC_NUM)
    
    localfilename <- paste0(gsub(" ","_",drive_filename),"_Literature.html")

    litFile <- drive_get(path = drive_filename)
    

    
    data <- drive_download(litFile, path = localfilename, overwrite = T, verbose = F)
    
    filelines <- readLines(localfilename,warn=FALSE)
    file.remove(localfilename)
    drive_deauth()
    
    HTML(filelines)
    
    
  })
}
#render all output in the literature section
renderLiterature <- function(){
  
  
  output$wordCloudHeader <- renderUI(
    HTML(paste0("<h4><i>",input$litGeneSelect,"</i> Word Cloud</h4>"))
  )
  #load the geneCard description for the gene
  output$litOutput <- renderUI({
    
      description <- genecards[genecards$Gene==input$litGeneSelect,]$Description
      HTML(description)

  })
  
  output$pubMedHitHeader <- renderUI(
    HTML(paste0("<h4>PubMed Hits for Locus ", reactives$selRow$LOC_NUM, " Genes and Parkinson's</h4>"))
  )
  #render the pubmed search bar plots for "Parkinson's and [Gene]" searches in title/abstract
  output$pubMedHitPlot <- renderPlotly({
  
    subsetgenes <- pubmedhits[pubmedhits$LOC_NUM==reactives$selRow$'LOC_NUM' & pubmedhits$GWAS==gwas_id_string,]

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

    p <- plot_ly(data = genefreq,y = genefreq$"Pubmed hits", x = genefreq$GENE, type = "bar", customdata = genefreq$url, text = ~paste('Click bar to search:'," (Parkinson's[Title/Abstract]) AND \n",genefreq$GENE,"[Title/Abstract]" )) %>% layout(xaxis = list(tickangle = -45)) %>% onRender(js) %>% config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d","pan2d","select2d","lasso2d","toggleSpikelines","autoScale2d"),displaylogo=FALSE)
    p
    
    
  })
  
  output$geneHitHeader <- renderUI(
    HTML(paste0("<h4>PubMed Hits for Locus ", reactives$selRow$LOC_NUM, " Genes</h4>"))
  )
  #render the pubmed search bar plots for "[Gene]" searches in title/abstract
  output$geneHitPlot <- renderPlotly({
    subsetgenes <- pubmedhits[pubmedhits$LOC_NUM==reactives$selRow$'LOC_NUM'  & pubmedhits$GWAS==gwas_id_string,]

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
    
    p <- plot_ly(data = genefreq,y = genefreq$"Pubmed hits gene only", x = genefreq$GENE, type = "bar", customdata = genefreq$url, text = ~paste('Click bar to search: ',genefreq$GENE,"[Title/Abstract]")) %>% layout(xaxis = list(tickangle = -45) ) %>% onRender(js) %>% config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d","pan2d","select2d","lasso2d","toggleSpikelines","autoScale2d"),displaylogo=FALSE)


  })


  #load the pre-generated word cloud images
  output$wordCloud <- renderImage({
     wordcloud_name <- paste0("www/pubmed/wordcloud/", input$litGeneSelect, "_wordcloud", ".png")
  
  
     list(src = wordcloud_name, contentType = 'image/png', width = '100%', alt = "No Word Cloud")
  
   }, deleteFile = FALSE)
  
}

