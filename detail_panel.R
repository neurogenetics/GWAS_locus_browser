#code for literature section
source("literature_section.R", local = T)
 
#render everything in the detail panel 
renderDetailPanel <- function(){


  #show searched gene and include link to the exome browser
  output$geneSearchOutput <- renderUI({
    # link <- a(isolate(reactives$searchedGene), href = paste0("https://pdgenetics.shinyapps.io/ExomeBrowser/?gene=", isolate(reactives$searchedGene)), target = "_blank")
    tagList(
      HTML(
        #paste0("<h1><b>Data for <i>", link, "</i></b></h1>" )
        paste0("<h1><b> Data for <i>", isolate(reactives$searchedGene), "</i></b></h1>")
        )
      )
    }
  )
  
  
  #update variant chr:bp:ref:alt at top
  output$variantOutput <- renderUI(HTML(paste0("<h1><b>Variant: </b>", (reactives$selRow$CHR), ":", as.numeric(gsub("\\,", "", (reactives$selRow$BP))), ":", toupper((reactives$selRow$REF)), ":", toupper((reactives$selRow$ALT)), "</h1>")))
  #update variant chr:bp:ref:alt at summary stats section
  output$sumstatsVariantOutput <- renderUI(HTML(paste0("<h2><b>Variant: </b>", (reactives$selRow$CHR), ":", as.numeric(gsub("\\,", "", (reactives$selRow$BP))), ":", toupper((reactives$selRow$REF)), ":", toupper((reactives$selRow$ALT)), "</h2>")))
  
  #update rsid text at top
  output$rsOutput <- renderUI(HTML(paste0("<h2>",  (reactives$selRow$'SNP'), "</h2>")))
  #update rsid text at summary stats section
  output$sumstatsRSOutput <- renderUI(HTML(paste0("<h3>", (reactives$selRow$'SNP'), "</h3>")))
  
   #show nearest gene
   output$nearGeneOutput <- renderUI({
     # link <- a((reactives$selRow$'Nearest Gene'), href = paste0("https://pdgenetics.shinyapps.io/ExomeBrowser/?gene=", (reactives$selRow$'Nearest Gene')), target = "_blank")
     tagList(
       HTML(
         # paste0("<h3>Nearest Gene: <i>", link, "</i></h3>")
         paste0("<h3>Nearest Gene: <i>", reactives$selRow$'Nearest Gene', "</i></h3>")
         )
     )
   })
   output$locusOutput <- renderUI(HTML(paste0("<h3>Locus: ",  (reactives$selRow$'Locus Number'), "</h3>")))
   
   output$UCSClinkOutput <- renderUI({
     link_row <- UCSC_links[UCSC_links$'SNP' == reactives$selRow$'SNP',]
     if(nrow(link_row)!=0)
     {
       link <- a("UCSC Genomic View", href = link_row$'UCSC map link', target = "_blank")
       HTML(paste0("<h3>",link,"</h3>"))
     }
     else
     {
       HTML("<p></p>")
     }
   })
   
   output$locusSpecialTextOutput <- renderUI(
     {
       text <- locus_text[locus_text$'Locus Number' == reactives$selRow$"Locus Number",]
       if(nrow(text)!=0)
       {
         HTML(paste0("<h3>Locus Info:</h3><h5><p>",text$Text,"</p></h5>"))
       }
       else
       {
         HTML("<p></p>")
       }
     }
   )
   
   #render the studyOutput for study reference
   output$studyOutput <- renderUI(
     if(isolate(reactives$selRow$'Locus Number')!="prog1" && isolate(reactives$selRow$'Locus Number')!="prog2")
     {
       HTML("<h4>Meta5 Loci Summary Statistics (Nalls et al. 2019)</h4>")
     }
     else
     {
       HTML("<h4>Progression Loci Summary Statistics (Iwaki et al. 2019)</h4>")
     }
   )
   
   #render the snp statistics table
   output$snpStatsTable <- renderDataTable({
     #if the locus isn't from the progression study
     data <- reactives$selRow
     
     if(isolate(data$'Locus Number')!="prog1" && isolate(data$'Locus Number')!="prog2")
     {
       
       df <- data.frame("<b>Beta</b>"= signif(data$Beta,4),"<b>Odds Ratio</b>"= signif(data$'Odds Ratio',4), "<b>Effect Allele Frequency</b>"= signif(data$'Effect allele frequency',4),"<b>Standard Error</b>"= signif(data$SE,4), "<b>P Value</b>"= signif(data$P,4), "<b>P Conditional and Joint Analysis</b>"= signif(data$'P_COJO',4), check.names = F)
       beta_label <- paste0('<b>Beta [',data$"Effect allele",']</b>')
       
       shinyjs::show(id = "otherstats")
     }
     else
     {
       df <- data.frame("<b>Beta</b>"= signif(data$Beta,4),"<b>Odds Ratio</b>"= signif(data$'Odds Ratio',4), "<b>Effect Allele Frequency</b>"= signif(data$MAF,4),"<b>Standard Error</b>"= signif(data$SE,4), "<b>P Value</b>"= signif(data$P,4), check.names = F)
       beta_label <- paste0('<b>Beta [',data$ALT,']</b>')
       
       #hide the other study stats if viewing a progression locus
       shinyjs::hide(id = "otherstats")
     }
     #assign the beta_label to the beta columns
     names(df)[names(df) == "<b>Beta</b>"] <- beta_label
     
     
     #call javascript code for the interactive locuszoom
     BP <- as.numeric(gsub("\\,", "", isolate(reactives$selRow$BP)))
     formatsnp <- paste0(isolate(reactives$selRow$CHR),":",BP,"_",toupper(isolate(reactives$selRow$'REF')),"/",toupper(isolate(reactives$selRow$'ALT')))
     jsstring <- paste0("do_locuszoom_stuff('",isolate(reactives$selRow$SNP),"',",isolate(reactives$selRow$CHR),",",BP,",'",formatsnp,"')")
     runjs(jsstring)
     

     df <- t(df)
   }, colnames = "", escape = F,options = list(searching = F, paginate = F, ordering = F, dom = 't'))
   
   #render the population frequency table
   output$freqTable <- renderDataTable(
     {
       if(isolate(reactives$selRow$'Locus Number')!="prog1" && isolate(reactives$selRow$'Locus Number')!="prog2")
       {
         freqRow <- meta5_freq[which(paste0(meta5_freq$CHR,":",meta5_freq$BP)==reactives$selRow$"CHR:BP"),]
         
       }
       else
       {
         freqRow <- prog_freq[which(paste0(prog_freq$CHR,":",prog_freq$BP)==reactives$selRow$"CHR:BP"),]
       }
       

       freqRow <- freqRow[,!c("A1","A2","CHR","BP")]
       colnames(freqRow) <- paste0("<b>",colnames(freqRow),"</b>")
       
       freqRow <- t(freqRow)
       freqRow <- na.omit(freqRow,colnames(freqRow))
       freqRow
       
     }, colnames="", escape=F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
   )
   
   #render the summary stats for the other gwas studies
   output$aooStatsTable <- renderDataTable(
     {
       row <- aoo_stats[which(aoo_stats$SNP==reactives$selRow$SNP),]
       row[,-which(names(row) %in% c("SNP","CHR_BP","Effect allele","Other allele"))]
     }, escape=F,rownames = F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
   )
   output$gba_aooStatsTable <- renderDataTable(
     {
       row <- gba_aoo_stats[which(gba_aoo_stats$SNP==reactives$selRow$SNP),]
       row[,-which(names(row) %in% c("SNP","CHR_BP","Effect allele","Other allele"))]
     }, escape=F,rownames = F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
   )
   output$gbaStatsTable <- renderDataTable(
     {
       row <- gba_stats[which(gba_stats$SNP==reactives$selRow$SNP),]
       row[,-which(names(row) %in% c("SNP","MarkerName","Effect allele","Other allele"))]
     }, escape=F,rownames = F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
   )
   output$lrrk2StatsTable <- renderDataTable(
     {
       row <- lrrk2_stats[which(lrrk2_stats$SNP==reactives$selRow$SNP),]
       row[,-which(names(row) %in% c("SNP","CHR_BP","Effect allele","Other allele"))]
     }, escape=F,rownames = F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
   )
   
  output$fineMappingTable <- renderDataTable(
    {
      finemap_subset <- finemapping[which(finemapping$'Locus Number'==reactives$selRow$'Locus Number')]
      finemap_subset <- finemap_subset %>% select(-c("Locus Number"))
    }, escape=F, rownames = F, options = list(searching = F, paginate = F, dom = 't', scrollY = "300px", columnDefs = list(list(
      className = 'dt-right', 
      targets = c(1:ncol(finemapping)-2),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data;",
        "}"
      ))))
  )
   
   output$locusZoomHeader <- renderUI(HTML(paste0("<h2>Locus ",reactives$selRow$'Locus Number'," Locus Zoom for ",reactives$selRow$'SNP',"</h2>")))
   #update static locus zoom plot
   output$locusZoomPlot <- renderImage({
    

     list(src = paste0("www/LocusZoomPngs/",  (reactives$selRow$SNP), ".png"), contentType = 'image/png', width = '100%')
   }, deleteFile = FALSE)
   
   #render the weighted evidence table
   renderUserEvidenceTable()
  
   #render the coding and phenotype variants separately because they won't be searched by gene
   renderCodingVariantTable()
   renderPhenotypeVariantTable()
   
   #if the search button has been clicked and the gene exists then select data by the gene
   if(searchClicked && !is.null(isolate(reactives$searchedGene)))
   {
     renderDataByGene()
   }
   else
   {
     renderDataByLocus()
   }
   
   #update the literature section
   renderLiterature()
   
   #update the guesstimate section
   renderGuesstimate()
  
}


#update the weighted user evidence table whenever one of the sliders changes or when one of the column buttons is clicked
observeEvent(ignoreNULL=F, {input$META5Slider
              input$qtlBrainSlider
              input$qtlBloodSlider
              input$qtlCorrelSlider
              input$burdenSlider
              input$brainExpSlider
              input$nigraExpSlider
              input$SNDaExpSlider
              input$litSearchSlider
              input$constraintSlider
              input$pdGeneSlider
              input$diseaseGeneSlider
              input$evidenceColButtons}, {
                
  #multiply the columns by their weight taken from the slider
  userEvidence$'Nominated by META5' <<- (as.numeric(evidence$'Nominated by META5') * input$META5Slider)
  userEvidence$'QTL-brain' <<- (as.numeric(evidence$'QTL-brain') * input$qtlBrainSlider)
  userEvidence$'QTL-blood' <<- (as.numeric(evidence$'QTL-blood') * input$qtlBloodSlider)
  userEvidence$'QTL-correl' <<- (as.numeric(evidence$'QTL-correl') * input$qtlCorrelSlider)
  userEvidence$'Burden' <<- (as.numeric(evidence$'Burden') * input$burdenSlider)
  userEvidence$'Brain Expression' <<- (as.numeric(evidence$'Brain Expression') * input$brainExpSlider)
  userEvidence$'Nigra Expression' <<- (as.numeric(evidence$'Nigra Expression') * input$nigraExpSlider)
  userEvidence$'SN-Dop. Neuron Expression' <<- (as.numeric(evidence$'SN-Dop. Neuron Expression') * input$SNDaExpSlider)
  userEvidence$'Literature Search' <<- (as.numeric(evidence$'Literature Search') * input$litSearchSlider)
  userEvidence$'Variant Intolerant' <<- (as.numeric(evidence$'Variant Intolerant') * input$constraintSlider)
  userEvidence$'PD Gene' <<- (as.numeric(evidence$'PD Gene') * input$pdGeneSlider)
  userEvidence$'Disease Gene' <<- (as.numeric(evidence$'Disease Gene') * input$diseaseGeneSlider)
  
  #find which columns we want to keep based on which column buttons have been clicked
  columns <- names(evidence)[!names(evidence) %in% input$evidenceColButtons]
  #subset the columns we want 
  userEvidence <<- subset(userEvidence,select=columns)
  
  #calculate the conclusion value
  if(ncol(userEvidence[,!c("Gene", "Locusnumber", "Conclusion", "SNP")]) != 0)
  {
    userEvidence$Conclusion <<- rowSums(userEvidence[,!c("Gene", "Locusnumber", "SNP", "Conclusion")], na.rm = T)
  }
  else
  {
    userEvidence$Conclusion <<- 0
  }
  
  #reload the table
  renderUserEvidenceTable()
})


renderUserEvidenceTable <- function()
{
  #if we have searched for a gene then select that gene in the evidence table drop down
  if(searchClicked && !is.null(isolate(reactives$searchedGene)))
  {
    updateSelectInput(session, input$evidenceSelect, selected = isolate(reactives$searchedGene))
  }

    #render the evidence table
   output$evidenceTable <- renderDT({
     scrollYVal <- 0


       evdata <- NULL
       #by all genes
       if (input$evidenceSelect=="All Genes")
       {
         evdata <- userEvidence[which(userEvidence$Locusnumber == isolate(reactives$selRow$'Locus Number') & userEvidence$SNP == isolate(reactives$selRow$'SNP')),] 
         scrollYVal <- 300
       }
       #by gene selected in drop down
       else
       {
         evdata <- userEvidence[which(userEvidence$Gene == input$evidenceSelect & userEvidence$SNP == isolate(reactives$selRow$'SNP')),]
         
         #if searched for a gene that shows up in multiple loci (like ACBD4) then only get the first row (both rows should be identical, will only have different locus numbers)
         if(nrow(evdata)!=1)
         {
           evdata <- evdata[1,]
         }
         scrollYVal <- 50
       }
       
       #remove 'Locusnumber' column from table
       evdata <- evdata[,!c("Locusnumber", "SNP")]
       
       #only reorder if at least one column is not hidden (prevents error in table when all columns hidden)
       if(ncol(evdata)>3)
       {
         #reorder columns to place the 'Conclusion' column second
          setcolorder(evdata, c("Gene", "Conclusion", names(evdata)[3:(length(evdata)-1)]))
       }
       
       datatable(evdata, extensions = 'Buttons', rownames = F, options = list(order = list(1, 'desc'), searching = F, paginate = F, 
                                                                                                   dom = 't', scrollY = paste0(scrollYVal,"px"), scrollX = T, columnDefs = list(list(
        className = 'dt-right', 
        targets = c(1:ncol(evdata)-1),
         render = JS(
           "function(data, type, row, meta) {",
           "return (data==null) ? 'NA' : data;",
           "}"
         )))))
       


     
     })


}

#render data for the coding variants
renderCodingVariantTable <- function()
{
  output$codingTable <- renderDT({
    
    #get coding variant data
    data <- coding_variants[coding_variants$'locus number' == (reactives$selRow$'Locus Number')]
    
    #get LD data for the selected variant (some loci have multiple variants, so multiple LD values as well)
    ld <- coding_ld[coding_ld$'rsid1' == (reactives$selRow$SNP)]
    
    coding_data <- merge(data, ld, all.x =T, by.x = 'ID', by.y = 'rsid2')
    coding_data <- coding_data %>% select("ID", "CHRBP_REFALT", "locus number","r2","dprime", "freq_nfe", "Gene.refGene", "AA Change", "cadd_phred" )
    colnames(coding_data) <- c("SNP", "Chr:BP:Ref:Alt", "Locus Number", "LD (rsquared)", "LD (D')", "Frequency (Non-Finnish European)", "Gene", "AA Change","CADD (phred)")
    scrollYVal <- min(50 * nrow(coding_data), 300)
    datatable(coding_data, rownames = F, option=list(processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal, "px"), scrollX = T, columnDefs = list(list(
      targets = c(3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(3);",
        "}"
      )))))
  })
  
}

#render data for the phenotype variants
renderPhenotypeVariantTable <- function()
{
  output$phenotypeTable <- renderDT({
    #get phenotype variant data
    data <- phenotype_variants[phenotype_variants$'locus number' == (reactives$selRow$'Locus Number')]
    
    #get LD data for the selected variant (some loci have multiple variants, so multiple LD values as well)
    ld <- phenotype_ld[phenotype_ld$'rsid1' == (reactives$selRow$SNP)]
    
    pheno_data <- merge(data, ld, all.x = T, by.x = 'ID' , by.y = 'rsid2')
    pheno_data <- pheno_data %>% select("ID", "CHRBP_REFALT", "locus number", "r2", "dprime","freq_nfe", "other associated disease", "P-VALUE", "PMID")
    colnames(pheno_data) <- c("SNP", "Chr:BP:Ref:Alt", "Locus Number", "LD (rsquared)", "LD (D')", "Frequency (Non-Finnish European)", "Other Associated Disease", "P-value", "PMID")
    
    pheno_data <- na.omit(pheno_data)
    scrollYVal <- min(50 * nrow(pheno_data), 300)
    datatable(pheno_data, rownames = F, escape = F, option=list(order = list(7, 'asc'), processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal, "px"), scrollX = T, columnDefs = list(list(
      targets = c(3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(3);",
        "}"
      )))
      ))
  })
  
}

#render other data tables that can be filtered by gene
renderDataByLocus <- function()
{
  
  
  #render burden table using the genes matching the selected locus in the evidence table
  output$burdenTable <- renderDT({
    
    tableData <- NULL
    if(input$burdenSelect=="All Genes")
    {
      tableData <- burdenData[burdenData$Gene %in% (evidence[evidence$Locusnumber== (reactives$selRow$'Locus Number'),]$Gene),]
      scrollYVal <- 200
    }
    else
    {
      tableData <- burdenData[burdenData$Gene == input$burdenSelect,]
      scrollYVal <- 50
    }
    datatable(tableData, rownames = F, options = list(processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal,"px"), scrollX = T, columnDefs = list(list(
      targets = c(1,2),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(2);",
        "}"
      )))))

  })
  
  
  #render expression table using genes matching the selected locus in the evidence table
  output$expressionTable <- renderDT({
    
    tableData <- NULL
    if(input$expressionSelect=="All Genes")
    {
      tableData <- expressionData[expressionData$Gene %in% (evidence[evidence$Locusnumber== (reactives$selRow$'Locus Number'),]$Gene),]
      scrollYVal <- 300
    }
    else
    {
      tableData <- expressionData[expressionData$Gene == input$expressionSelect,]
      scrollYVal <- 50
    }
    
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
    filename <- paste0("www/GTEXPlots/",input$GTEXSelect,"_gtex8_expression.png")
    list(src = filename, contentType = 'image/png', width = '100%', alt = "No Violin Plot for Gene")
  }, deleteFile = FALSE)
  
  #load the single cell data plot
  output$SingleCellPlot <- renderImage({
    filename <- paste0("www/expression/",input$SingleCellSelect,"_sc_expression.png")
    list(src = filename, contentType = 'image/png', width = '100%', alt = "No Plot for Gene")
  }, deleteFile = FALSE)
  
  #load the constraint data table
  output$constraintTable <- renderDT({
    
    tableData <- NULL
    if(input$constraintSelect=="All Genes")
    {
      tableData <- constraintData[constraintData$Gene %in% (evidence[evidence$Locusnumber== (reactives$selRow$'Locus Number'),]$Gene),]
      scrollYVal <- 300
    }
    else
    {
      tableData <- constraintData[constraintData$Gene == input$constraintSelect,]
      scrollYVal <- 50
    }
    
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
  
  #load the disease gene table
  output$diseaseTable <- renderDT({
    
    tableData <- NULL
    if(input$diseaseSelect=="All Genes")
    {
      tableData <- diseaseData[diseaseData$Gene %in% (evidence[evidence$Locusnumber== (reactives$selRow$'Locus Number'),]$Gene),]
      scrollYVal <- 300
    }
    else
    {
      tableData <- diseaseData[diseaseData$Gene == input$diseaseSelect,]
      scrollYVal <- 300
    }
    
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
  
  
  #load the brain QTL plot
  output$brainQTLPlot <- renderImage({
    #filename for eQTL locus compare plot with index variant marked as lead snp
    rsid_plot_name <- paste0("www/QTLBrainPlots/", input$qtlSelect, "_", isolate(reactives$selRow$'SNP') , ".png")

    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Brain LocusCompare Plot")
  
  }, deleteFile = FALSE)
  
  #load the blood QTL plot
  output$bloodQTLPlot <- renderImage({
    #filename for eQTL locus compare plot with index variant marked as lead snp
    rsid_plot_name <- paste0("www/QTLBloodPlots/", input$qtlSelect, "_", isolate(reactives$selRow$'SNP') , ".png")

    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Blood LocusCompare Plot")

  }, deleteFile = FALSE)

  #load the psychencode eQTL plot
  output$pe_eQTLPlot <- renderImage({

    rsid_plot_name <- paste0("www/p_eQTL/", input$qtlSelect, "_", isolate(reactives$selRow$'SNP') , ".png")

    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Psychencode eQTL LocusCompare Plot")

  }, deleteFile = FALSE)

  #load the psychencode isoQTL plot
  output$pe_isoQTLPlot <- renderImage({
    

    
    rsid_plot_name <- paste0("www/p_isoQTL/", input$qtlSelect, "_", input$isoQTLSelect, "_", isolate(reactives$selRow$'SNP') , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Psychencode isoQTL LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
}

#if a gene was searched then update the dropdowns to the searched gene, which should reactively update those tables/plots
renderDataByGene <- function()
{
  updateSelectInput(session,input$GTEXSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$SingleCellSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$burdenSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$expressionSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$constraintSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$diseaseSelect,selected=isolate(reactives$searchedGene))

}

observeEvent(input$qtlSelect,
             {
               iso_plots <- list.files("www/p_isoQTL")

               isoforms <- str_extract(iso_plots, paste0("^", input$qtlSelect, "_(\\w+)_", isolate(reactives$selRow$'SNP'), ".png"))
               isoforms <- isoforms[!is.na(isoforms)]

               isoforms <- sub(paste0("^", input$qtlSelect, "_(\\w+)_", isolate(reactives$selRow$'SNP'), ".png"), "\\1", isoforms)

               updateSelectInput(session, "isoQTLSelect", choices = isoforms, selected=isoforms[1])
             })