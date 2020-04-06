
#render the text from the googledrive
renderGuesstimate <- function(){
  
  output$guessOutput <- renderUI({
    #need to authenticate since not looking up by ids
    token_name <- "authentication_token.rds"
    drive_auth(token = readRDS(token_name))
    localfilename <- paste0("Locus",reactives$selRow$'Locus Number',"_Literature.html")
    litFile <- drive_get(path = paste0("Locus ", reactives$selRow$'Locus Number'))
    
    data <- drive_download(litFile, path = localfilename, overwrite = T, verbose = F)
    
    filelines <- readLines(localfilename)
    file.remove(localfilename)
    drive_deauth()
    
    HTML(filelines)
    
    
  })
}
#render all output in the literature section
renderLiterature <- function(){
  
  #load the geneCard description for the gene
  output$litOutput <- renderUI({
    
      description <- genecards[genecards$Gene==input$litGeneSelect,]$Description
      HTML(description)

  })
  
  
  #render the pubmed search bar plots for "Parkinson's and [Gene]" searches in title/abstract
  output$pubMedHitPlot <- renderPlotly({
    subsetgenes <- pubmedhits[pubmedhits$Locusnumber==reactives$selRow$'Locus Number',]
    
    genefreq <- subsetgenes %>% select("Gene", "Pubmed hits")
    
    #remove rows with zero hits for gene only search
    genefreq <- genefreq[genefreq$"Pubmed hits" !=0, ]
    
    genefreq$Gene <- factor(genefreq$Gene, levels = unique(genefreq$Gene)[order(genefreq$"Pubmed hits", decreasing = TRUE)])

    title <- paste0("Pubmed Hits for Locus ", reactives$selRow$'Locus Number', "\n Genes and Parkinson's Disease")
    p <- plot_ly(data = genefreq,y = genefreq$"Pubmed hits", x = genefreq$Gene, type = "bar") %>% layout(title = ~title, xaxis = list(tickangle = -45))
    p
    
    
  })
  #render the pubmed search bar plots for "[Gene]" searches in title/abstract
  output$geneHitPlot <- renderPlotly({
    subsetgenes <- pubmedhits[pubmedhits$Locusnumber==reactives$selRow$'Locus Number',]
    
    genefreq <- subsetgenes %>% select("Gene", "Pubmed hits gene only")
    
    #remove rows with zero hits for gene only search
    genefreq <- genefreq[genefreq$"Pubmed hits gene only" !=0, ]
    
    
    genefreq$Gene <- factor(genefreq$Gene, levels = unique(genefreq$Gene)[order(genefreq$"Pubmed hits gene only", decreasing = TRUE)])

    title <- paste0("Pubmed Hits for Locus ", reactives$selRow$'Locus Number', " Genes")
    p <- plot_ly(data = genefreq,y = genefreq$"Pubmed hits gene only", x = genefreq$Gene, type = "bar") %>% layout(title = ~title, xaxis = list(tickangle = -45))
    p

  })
  

  #load the pre-generated word cloud images
  output$wordCloud <- renderImage({
     wordcloud_name <- paste0("www/wordcloud/", input$litGeneSelect, "_wordcloud", ".png")
  
  
     list(src = wordcloud_name, contentType = 'image/png', width = '100%', alt = "No Word Cloud")
  
   }, deleteFile = FALSE)
  
}

