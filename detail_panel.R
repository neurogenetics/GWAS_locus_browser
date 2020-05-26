#code for literature section
source("literature_section.R", local = T)
#code for qtl section
source("qtl_section.R", local = T)
#code for the locus zoom section
source("locus_zoom_section.R", local = T)
 
#render everything in the detail panel 
renderDetailPanel <- function(){
  
  
  
  #update variant chr:bp:ref:alt at summary stats section
  output$sumstatsVariantOutput <- renderUI(HTML(paste0("<h2><b>Variant: </b>", (reactives$selRow$CHR), ":", as.numeric(gsub("\\,", "", (reactives$selRow$BP))), ":", toupper((reactives$selRow$REF)), ":", toupper((reactives$selRow$ALT)), "</h2>")))
  

  #update rsid text at summary stats section
  output$sumstatsRSOutput <- renderUI(HTML(paste0("<h3>", (reactives$selRow$RSID), "</h3>")))
  
   #show nearest gene
   output$nearGeneOutput <- renderUI({
     # link <- a((reactives$selRow$'Nearest Gene'), href = paste0("https://pdgenetics.shinyapps.io/ExomeBrowser/?gene=", (reactives$selRow$'Nearest Gene')), target = "_blank")
     tagList(
       HTML(
         # paste0("<h3>Nearest Gene: <i>", link, "</i></h3>")
         paste0("<h3>Nearest Gene: <i>", reactives$selRow$'NEAR_GENE', "</i></h3>")
         )
     )
   })
   output$locusOutput <- renderUI(HTML(paste0("<h3>Locus: ",  (reactives$selRow$LOC_NUM), "</h3>")))
   
   output$UCSClinkOutput <- renderUI({
     link_row <- UCSC_links[UCSC_links$'SNP' == reactives$selRow$RSID,]
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

       text <- locus_text[which(locus_text$'Locus Number' == reactives$selRow$"LOC_NUM" & locus_text$GWAS == gwas_id_string),]

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
   output$studyOutput <- renderUI({
     

     
     HTML(paste0("<h4>",isolate(input$gwasSelect), " Loci Summary Statistics (",gwas_info[gwas_info$ID==gwas_id_string,]$SHORT_REF, ")</h4>" ))
     
     
   })
   
   #render the snp statistics table
   output$snpStatsTable <- renderDataTable({
     #if the locus isn't from the progression study
     
     data <- reactives$selRow

     if(gwas_id_string=="META5")
     {
       
       df <- data.frame("<b>Beta</b>"= signif(data$BETA,4),"<b>Odds Ratio</b>"= signif(data$OR,4), "<b>Effect Allele Frequency</b>"= signif(data$EFFECT_FREQ,4),"<b>Standard Error</b>"= signif(data$SE,4), "<b>P-value</b>"= signif(data$P,4), "<b>P Conditional and Joint Analysis</b>"= signif(data$P_COJO,4), check.names = F)
       beta_label <- paste0('<b>Beta [',data$EFFECT_ALLELE,']</b>')
       

     }
     else
     {

       df <- data.frame("<b>Beta</b>"= signif(data$BETA,4),"<b>Odds Ratio</b>"= signif(data$OR,4), "<b>Effect Allele Frequency</b>"= signif(data$MAF,4),"<b>Standard Error</b>"= signif(data$SE,4), "<b>P-value</b>"= signif(data$P,4), check.names = F)
       beta_label <- paste0('<b>Beta [',data$ALT,']</b>')
       
     }
     #assign the beta_label to the beta columns
     names(df)[names(df) == "<b>Beta</b>"] <- beta_label
     
     

     df <- t(df)
   }, colnames = "", selection=list(mode="disable"), escape = F,options = list(searching = F, paginate = F, ordering = F, dom = 't'))
   

   
   #render the population frequency table
   output$freqTable <- renderDataTable(
     {
       freqRow <- freqs[which(freqs$RSID==reactives$selRow$RSID),]
       freqRow <- freqRow[,!c("GWAS","LOC_NUM","RSID")]
       if(gwas_id_string!="META5")
       {
          freqRow <- freqRow[,!c("Frequency_PD","Frequency_control","AFF","UNAFF")]
       }

       # if(isolate(reactives$selRow$'Locus Number')!="prog1" && isolate(reactives$selRow$'Locus Number')!="prog2")
       # {
       #   freqRow <- meta5_freq[which(paste0(meta5_freq$CHR,":",meta5_freq$BP)==reactives$selRow$"CHR:BP"),]
       #   
       # }
       # else
       # {
       #   freqRow <- prog_freq[which(paste0(prog_freq$CHR,":",prog_freq$BP)==reactives$selRow$"CHR:BP"),]
       # }
       

       #freqRow <- freqRow[,!c("A1","A2","CHR","BP")]
       colnames(freqRow) <- paste0("<b>",colnames(freqRow),"</b>")
       
       freqRow <- t(freqRow)
       freqRow <- na.omit(freqRow,colnames(freqRow))
       freqRow
       
     }, colnames="", selection=list(mode="disable"),escape=F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
   )

   
  output$fineMappingTable <- renderDataTable(
    {
      if(gwas_id_string=="META5")
      {
        finemap_subset <- finemapping[which(finemapping$'Locus Number'==reactives$selRow$LOC_NUM)]
        finemap_subset <- finemap_subset %>% select(-c("Locus Number"))
        finemap_subset
      }
      else
      {
        finemap_subset <- finemapping[which(finemapping$'Locus Number'==reactives$selRow$LOC_NUM)]
        finemap_subset <- finemap_subset %>% select(-c("Locus Number"))
        finemap_subset[0,]
      }

    }, escape=F, rownames = F, options = list(searching = F, paginate = F, dom = 't', scrollY = "300px", columnDefs = list(list(
      className = 'dt-right', 
      targets = c(1:ncol(finemapping)-2),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data;",
        "}"
      ))))
  )


   

  
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
   
   
   #render the weighted evidence table
   renderUserEvidenceTable()
  
}

renderOtherSumStatsTable <- function()
{
  output$otherSumStatsTable <- renderDataTable(
    {
      statsData<-NULL
      if(gwas_id_string=="META5")
      {
        statsData <- other_sum_stats_for_meta5_gwas[which(other_sum_stats_for_meta5_gwas$RSID == reactives$selRow$RSID),]

      }
      else if(gwas_id_string=="Progression")
      {
        statsData <- other_sum_stats_for_prog_gwas[which(other_sum_stats_for_prog_gwas$RSID == reactives$selRow$RSID),]

      }
      else if(gwas_id_string=="Asian")
      {
        statsData <- other_sum_stats_for_asian_gwas[which(other_sum_stats_for_asian_gwas$RSID == reactives$selRow$RSID),]

      }
      other_gwas_info_sub <- other_gwas_info[which(other_gwas_info$ID %in% statsData$GWAS),]

      statsData$STUDY <- paste0("<a href='",other_gwas_info_sub[other_gwas_info_sub$ID==statsData$GWAS,]$LINK, "' target = '_blank'>",other_gwas_info_sub[other_gwas_info_sub$ID==statsData$GWAS,]$SHORT_REF," GWAS</a>")

      statsData <- statsData %>% select("STUDY","RSID","EFFECT_FREQ","BETA","SE","P")
      colnames(statsData) <- c("GWAS", "Risk Variant", "Effect Allele Frequency", "Beta", "SE","P-value")

      statsData
      
    },selection=list(mode="disable"),escape=F,rownames = F, options = list(searching = F, paginate = F, dom = 't', columnDefs = list(list(
      className = 'dt-right', 
      targets = c(2,3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : parseFloat(data).toPrecision(3);",
        "}"
      ))))
  )
}

observe(reactives$reactEvidence <- getReactiveEvidence())

getReactiveEvidence <- function()
{

  base_evidence <- evidence[,!c("QTL-brain","QTL-blood","QTL-correl","PD Gene","Nominated by META5")]
  base_evidence <- base_evidence[base_evidence$RSID==reactives$selRow$RSID,]
  qtl_evidence <- NULL

  #temp workaround for null checkbox values at start
  # if(is.null((input$qtl_blood_snp_checkbox)))
  # {
  #   qtl_evidence <- base_evidence %>% select(GENE,LOC_NUM,RSID)
  #   qtl_evidence$'QTL-brain' <- 0
  #   qtl_evidence$'QTL-blood' <- 0
  #   qtl_evidence$'QTL-correl' <- NA
  # }
  # else
  {
    qtl_evidence <- getQTLEvidence()
  }
  merged_evidence <- merge(base_evidence,qtl_evidence,all.x=TRUE, by=c("GENE","LOC_NUM","RSID"))
  
  #now merge pd gene and meta5 scores onto the df
  pd_meta5_evidence <- getPDGeneAndMeta5NomEvidence()
  
  merged_evidence <- merge(merged_evidence,pd_meta5_evidence, all.x = TRUE,by = c("GENE","LOC_NUM", "RSID"))
  
  

  weightEvidence<- merged_evidence
  
  weightEvidence$'Nominated by META5' <- (as.numeric(merged_evidence$'Nominated by META5') * input$META5Slider)
  weightEvidence$'QTL-brain' <- (as.numeric(merged_evidence$'QTL-brain') * input$qtlBrainSlider)
  weightEvidence$'QTL-blood' <- (as.numeric(merged_evidence$'QTL-blood') * input$qtlBloodSlider)
  weightEvidence$'QTL-correl' <- (as.numeric(merged_evidence$'QTL-correl') * input$qtlCorrelSlider)
  weightEvidence$'Burden' <- (as.numeric(merged_evidence$'Burden') * input$burdenSlider)
  weightEvidence$'Brain Expression' <- (as.numeric(merged_evidence$'Brain Expression') * input$brainExpSlider)
  weightEvidence$'Nigra Expression' <- (as.numeric(merged_evidence$'Nigra Expression') * input$nigraExpSlider)
  weightEvidence$'SN-Dop. Neuron Expression' <- (as.numeric(merged_evidence$'SN-Dop. Neuron Expression') * input$SNDaExpSlider)
  weightEvidence$'Literature Search' <- (as.numeric(merged_evidence$'Literature Search') * input$litSearchSlider)
  weightEvidence$'Variant Intolerant' <- (as.numeric(merged_evidence$'Variant Intolerant') * input$constraintSlider)
  weightEvidence$'PD Gene' <- (as.numeric(merged_evidence$'PD Gene') * input$pdGeneSlider)
  weightEvidence$'Disease Gene' <- (as.numeric(merged_evidence$'Disease Gene') * input$diseaseGeneSlider)
  setcolorder(weightEvidence,c("GWAS","GENE","LOC_NUM","RSID","Conclusion","Nominated by META5",'QTL-brain','QTL-blood','QTL-correl','Burden','Brain Expression','Nigra Expression','SN-Dop. Neuron Expression','Literature Search','Variant Intolerant','PD Gene','Disease Gene'))
  #find which columns we want to keep based on which column buttons have been clicked
  columns <- names(weightEvidence)[!names(weightEvidence) %in% input$evidenceColButtons]
  #subset the columns we want 
  weightEvidence <- subset(weightEvidence,select=columns)
  
  #calculate the conclusion value
  if(ncol(weightEvidence[,!c("GWAS","GENE", "LOC_NUM", "Conclusion", "RSID")]) != 0)
  {
    weightEvidence$Conclusion <- rowSums(weightEvidence[,!c("GWAS","GENE", "LOC_NUM", "RSID", "Conclusion")], na.rm = T)
  }
  else
  {
    weightEvidence$Conclusion <- 0
  }

  weightEvidence
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
     temp <- reactives$reactEvidence

       evdata <- NULL
       #by all genes
       if (input$evidenceSelect=="All Genes")
       {
         evdata <- temp[which(temp$LOC_NUM == isolate(reactives$selRow$LOC_NUM) & temp$RSID == isolate(reactives$selRow$RSID)),] 
         scrollYVal <- 300
       }
       #by gene selected in drop down
       else
       {
         evdata <- temp[which(temp$GENE == input$evidenceSelect & temp$RSID == isolate(reactives$selRow$RSID)),]
         
         #if searched for a gene that shows up in multiple loci (like ACBD4) then only get the first row (both rows should be identical, will only have different locus numbers)
         if(nrow(evdata)!=1)
         {
           evdata <- evdata[1,]
         }
         scrollYVal <- 50
       }

       #remove 'Locusnumber' column from table
       evdata <- evdata[,!c("LOC_NUM", "RSID","GWAS")]
       
       #only reorder if at least one column is not hidden (prevents error in table when all columns hidden)
       if(ncol(evdata)>3)
       {
         #reorder columns to place the 'Conclusion' column second
          setcolorder(evdata, c("GENE", "Conclusion", names(evdata)[3:(length(evdata)-1)]))
       }
       colnames(evdata)[colnames(evdata) == 'GENE'] <- 'Gene'
       datatable(evdata, extensions = 'Buttons', rownames = F,
                 callback=JS("
                             table.on('mouseenter','tbody td', function() {
                              var column = $(this).index();
                              var row = $(this).parent().index();
                              this.setAttribute('title','Hello!');
                             });
                             return table;
                             "),
                 options = list(order = list(1, 'desc'), searching = F, paginate = F, 
                                                                                                   dom = 't', scrollY = paste0(scrollYVal,"px"), scrollX = T, columnDefs = list(list(
        className = 'dt-right', 
        targets = c(1:ncol(evdata)-1),
         render = JS(
           "function(data, type, row, meta) {",
           "return (data==null) ? 'NA' : data;",
           "}"
         )))))
       


     
     },server=FALSE)


}

#render data for the coding variants
renderCodingVariantTable <- function()
{
  output$codingTable <- renderDT({
    
    #get coding variant data
    data <- coding_variants[coding_variants$locnum == (reactives$selRow$LOC_NUM) & coding_variants$GWAS == gwas_id_string]
    
    #get LD data for the selected variant (some loci have multiple variants, so multiple LD values as well)
    ld <- coding_ld[coding_ld$'rsid1' == (reactives$selRow$RSID)]
    
    coding_data <- merge(data, ld, all.x =T, by.x = 'ID', by.y = 'rsid2')
    coding_data <- coding_data %>% select("ID", "CHRBP_REFALT", "locnum","r2","dprime", "freq_nfe", "Gene.refGene", "AA Change", "cadd_phred" )
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
    data <- phenotype_variants[phenotype_variants$locnum == (reactives$selRow$LOC_NUM) & phenotype_variants$GWAS == gwas_id_string]
    
    #get LD data for the selected variant (some loci have multiple variants, so multiple LD values as well)
    ld <- phenotype_ld[phenotype_ld$'rsid1' == (reactives$selRow$RSID)]
    
    pheno_data <- merge(data, ld, all.x = T, by.x = 'ID' , by.y = 'rsid2')
    pheno_data <- pheno_data %>% select("ID", "CHRBP_REFALT", "locnum", "r2", "dprime","freq_nfe", "other associated disease", "P-VALUE", "PMID")
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
      tableData <- burdenData[burdenData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRow$LOC_NUM) & evidence$GWAS == gwas_id_string,]$GENE),]
      scrollYVal <- 200
    }
    else
    {
      tableData <- burdenData[burdenData$GENE == input$burdenSelect,]
      scrollYVal <- 50
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
  
  
  #render expression table using genes matching the selected locus in the evidence table
  output$expressionTable <- renderDT({
    
    tableData <- NULL
    if(input$expressionSelect=="All Genes")
    {
      tableData <- expressionData[expressionData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRow$LOC_NUM) & evidence$GWAS == gwas_id_string,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      tableData <- expressionData[expressionData$GENE == input$expressionSelect,]
      scrollYVal <- 50
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
  
  #load the single cell data plot
  output$SingleCellPlot <- renderImage({
    no_plot_str <-""
    if(input$expressionSelect!='All Genes')
    {
      no_plot_str <-paste0("No single cell expression bar plot for ", input$expressionSelect)
    }
    else
    {
      no_plot_str <- "Please select a gene"
    }

    filename <- paste0("www/expression/single_cell_plots/",input$expressionSelect,"_sc_expression.png")
    list(src = filename, contentType = 'image/png', width = '100%', alt = no_plot_str)

    # filename <- paste0("www/expression/single_cell_plots/",input$SingleCellSelect,"_sc_expression.png")
    # list(src = filename, contentType = 'image/png', width = '100%', alt = "No Plot for Gene")
  }, deleteFile = FALSE)
  
  #load the constraint data table
  output$constraintTable <- renderDT({
    
    tableData <- NULL
    if(input$constraintSelect=="All Genes")
    {
      tableData <- constraintData[constraintData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRow$LOC_NUM) & evidence$GWAS == gwas_id_string,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      tableData <- constraintData[constraintData$GENE == input$constraintSelect,]
      scrollYVal <- 50
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
  
  #load the disease gene table
  output$diseaseTable <- renderDT({
    
    tableData <- NULL
    if(input$diseaseSelect=="All Genes")
    {
      tableData <- diseaseData[diseaseData$GENE %in% (evidence[evidence$LOC_NUM== (reactives$selRow$LOC_NUM) & evidence$GWAS == gwas_id_string,]$GENE),]
      scrollYVal <- 300
    }
    else
    {
      tableData <- diseaseData[diseaseData$GENE == input$diseaseSelect,]
      scrollYVal <- 300
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

#if a gene was searched then update the dropdowns to the searched gene, which should reactively update those tables/plots
renderDataByGene <- function()
{
  
  updateSelectInput(session,input$burdenSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$expressionSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$constraintSelect,selected=isolate(reactives$searchedGene))
  
  updateSelectInput(session,input$diseaseSelect,selected=isolate(reactives$searchedGene))

}

getPDGeneAndMeta5NomEvidence <- function()
{
  evidence_gene <- evidence[evidence$RSID==reactives$selRow$RSID,] %>% select("GENE","RSID","LOC_NUM")
  
  evidence_data <- pdgenes[pdgenes$GENE %in% evidence_gene$GENE,]
  
  evidence_per_gene <- merge(evidence_gene, evidence_data, by="GENE", all.x = TRUE)
  
  evidence_per_gene$'Nominated by META5' <- ifelse(is.na(evidence_per_gene$'META5 Associated Locus Number'), 0, 1)
  evidence_per_gene$'PD Gene' <- ifelse(evidence_per_gene$'MDS_DISEASE'==""|is.na(evidence_per_gene$'MDS_DISEASE'),0,1)
  
  evidence_per_gene <- distinct(evidence_per_gene %>% select("GENE","RSID","LOC_NUM","Nominated by META5", "PD Gene"))
  
  
  
  evidence_per_gene
  
}
