sumStats <- list()
sumStats$id <- "sumstats"
sumStats$title <- "Summary Statistics"
sumStats$loadData<- function(){
  
  
  #dataframe holding links for the other summary stats table
  other_gwas_info <<- data.table(ID=c("aoo","gba_aoo","gba_mod","lrrk2","asian","META5","ad","als","latam","male","female","lbd"),
                                LINK=c("https://pubmed.ncbi.nlm.nih.gov/30957308/",
                                       "https://pubmed.ncbi.nlm.nih.gov/31755958/",
                                       "https://pubmed.ncbi.nlm.nih.gov/31755958/",
                                       "https://pubmed.ncbi.nlm.nih.gov/31958187/",
                                       "https://pubmed.ncbi.nlm.nih.gov/32310270/",
                                       "https://pubmed.ncbi.nlm.nih.gov/31701892/",
                                       "https://pubmed.ncbi.nlm.nih.gov/30617256/",
                                       "https://pubmed.ncbi.nlm.nih.gov/29566793/",
                                       "https://www.medrxiv.org/content/10.1101/2020.11.09.20227124v1",
                                       "https://www.medrxiv.org/content/10.1101/2021.02.09.21250262v1",
                                       "https://www.medrxiv.org/content/10.1101/2021.02.09.21250262v1",
                                       "https://pubmed.ncbi.nlm.nih.gov/33589841/"),
                                SHORT_REF=c("Blauwendraat et al. 2019 Age of Onset",
                                            "Blauwendraat et al. 2020 GBA Age of Onset",
                                            "Blauwendraat et al. 2020 GBA Risk Modifier", 
                                            "Iwaki et al. 2020 LRRK2 Risk Modifier", 
                                            "Foo et al. 2020 Asian",
                                            "Nalls et al. 2019 META5",
                                            "Jansen et al. 2019 Alzheimer's Disease",
                                            "Nicolas et al. 2018 Amyotrophic Lateral Sclerosis",
                                            "Loesch et al. 2020 Latin America",
                                            "Blauwendraat et al. 2021 Male Specific",
                                            "Blauwendraat et al. 2021 Female Specific",
                                            "Chia et al. 2021 Lewy Body Dementia"))
  
  
  #other study summary statistics
  aoo_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="AAO",colNames=TRUE,sep.names=" ")
  aoo_stats$GWAS <<- "aoo"
  
  gba_aoo_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="GBA_AAO",colNames=TRUE,sep.names=" ")
  gba_aoo_stats$GWAS <<- "gba_aoo"
  
  gba_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="GBA_mod",colNames=TRUE,sep.names=" ")
  gba_stats$GWAS <<- "gba_mod"
  
  lrrk2_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="LRRK2",colNames=TRUE,sep.names=" ")
  lrrk2_stats$GWAS <<- "lrrk2"
  
  asian_gwas_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="Asian_GWAS",colNames=TRUE,sep.names=" ")
  asian_gwas_stats$GWAS <<- "asian"
  
  meta5_gwas_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="META5",colNames=TRUE,sep.names=" ")
  meta5_gwas_stats$GWAS <<- "META5"
  
  ad_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="AD",colNames=TRUE,sep.names=" ")
  ad_stats$GWAS <<- "ad"
  
  als_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="ALS",colNames=TRUE,sep.names=" ")
  als_stats$GWAS <<- "als"
  
  latam_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="Latam_GWAS",colNames=TRUE,sep.names=" ")
  latam_stats$GWAS <<- "latam"
  
  male_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="Male_GWAS",colNames=TRUE,sep.names=" ")
  male_stats$GWAS <<- "male"
  
  female_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="Female_GWAS",colNames=TRUE,sep.names=" ")
  female_stats$GWAS <<- "female"
  
  lbd_stats <<- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="LBD",colNames=TRUE,sep.names=" ")
  lbd_stats$GWAS <<- "lbd"
  
  #each gwas is going to have a different set of other summary statistics to show
  other_sum_stats_for_meta5_gwas <<- rbind(aoo_stats,gba_aoo_stats,gba_stats,lrrk2_stats,asian_gwas_stats,ad_stats,als_stats,latam_stats,male_stats,female_stats,lbd_stats)
  other_sum_stats_for_prog_gwas <<- rbind(aoo_stats,gba_aoo_stats,gba_stats,lrrk2_stats,asian_gwas_stats,meta5_gwas_stats,ad_stats,als_stats,latam_stats,male_stats,female_stats,lbd_stats)
  other_sum_stats_for_asian_gwas <<- rbind(aoo_stats,gba_aoo_stats,gba_stats,lrrk2_stats,meta5_gwas_stats,ad_stats,als_stats,latam_stats,male_stats,female_stats,lbd_stats)
  
  
  
  freqs <<- fread("www/summarystats/risk_variant_pop_freqs.csv")
  
  
  #ucsc links
  UCSC_links <<- fread("www/summarystats/UCSC_links.csv")
  
  #file containing special text for progression loci
  locus_text <<- fread("www/summarystats/Locus_Special_Text.txt")
  
}
sumStats$generateUI<- function(){

  div(

    br(),
    fluidRow(
      column(
        div(htmlOutput("sumstatsVariantOutput")),
        div(htmlOutput("sumstatsRSOutput")),
        div(htmlOutput("nearGeneOutput")), 
        div(htmlOutput("locusOutput")),
        div(htmlOutput("UCSClinkOutput")),
        br(),
        div(htmlOutput("locusSpecialTextOutput")),
        width = 4),
      column(
        htmlOutput("studyOutput"),
        dataTableOutput("snpStatsTable"),
        width = 4),
      column(
        dataTableOutput("freqTable"),
        width = 4
      )
      
      
    ),
    hr(),
    
    div(id="otherstats",
        fluidRow(
          column(
            h3("Summary Statistics from Other GWASes:"),
            dataTableOutput("otherSumStatsTable"),
            width = 12
          )
        )
        
        
        
    )

  )




}

sumStats$serverLogic <- function(input,output,session,reactives){
  #update variant chr:bp:ref:alt at summary stats section
  output$sumstatsVariantOutput <- renderUI(HTML(paste0("<h2><b>Variant: </b>", (reactives$selRiskVariant()$CHR), ":", as.numeric(gsub("\\,", "", (reactives$selRiskVariant()$BP))), ":", toupper((reactives$selRiskVariant()$REF)), ":", toupper((reactives$selRiskVariant()$ALT)), "</h2>")))  
  
  
  #update rsid text at summary stats section
  output$sumstatsRSOutput <- renderUI(HTML(paste0("<h3>", (reactives$selRiskVariant()$RSID), "</h3>")))
  
  #show nearest gene
  output$nearGeneOutput <- renderUI({
    # link <- a((reactives$selRow$'Nearest Gene'), href = paste0("https://pdgenetics.shinyapps.io/ExomeBrowser/?gene=", (reactives$selRow$'Nearest Gene')), target = "_blank")
    tagList(
      HTML(
        # paste0("<h3>Nearest Gene: <i>", link, "</i></h3>")
        paste0("<h3>Nearest Gene: <i>", reactives$selRiskVariant()$'NEAR_GENE', "</i></h3>")
      )
    )
  })
  output$locusOutput <- renderUI(HTML(paste0("<h3>Locus: ",  (reactives$selRiskVariant()$LOC_NUM), "</h3>")))
  
  output$UCSClinkOutput <- renderUI({
    link_row <- UCSC_links[UCSC_links$'SNP' == reactives$selRiskVariant()$RSID,]
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
      
      text <- locus_text[which(locus_text$'Locus Number' == reactives$selRiskVariant()$"LOC_NUM" & locus_text$GWAS == reactives$selRiskVariant()$GWAS),]
      
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
    
    
    
    HTML(paste0("<h4>",reactives$selRiskVariant()$GWAS, " Loci Summary Statistics (",a(gwas_info[gwas_info$ID==reactives$selRiskVariant()$GWAS,]$SHORT_REF, href = gwas_info[gwas_info$ID==reactives$selRiskVariant()$GWAS,]$LINK, target = "_blank"),")</h4>"))#gwas_info[gwas_info$ID==reactives$selRiskVariant()$GWAS,]$SHORT_REF, ")</h4>" ))
    
    
  })
  
  #render the snp statistics table
  output$snpStatsTable <- renderDataTable({
    #if the locus isn't from the progression study
    
    data <- reactives$selRiskVariant()
    
    if(reactives$selRiskVariant()$GWAS=="META5")
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
  }, colnames = "", selection=list(mode="none"), escape = F,options = list(searching = F, paginate = F, ordering = F, dom = 't'))
  
  
  
  #render the population frequency table
  output$freqTable <- renderDataTable(
    {
      freqRow <- freqs[which(freqs$RSID==reactives$selRiskVariant()$RSID),]
      freqRow <- freqRow[,!c("GWAS","LOC_NUM","RSID")]
      if(reactives$selRiskVariant()$GWAS!="META5")
      {
        freqRow <- freqRow[,!c("Frequency_PD","Frequency_control","AFF","UNAFF")]
      }
      
      colnames(freqRow) <- paste0("<b>",colnames(freqRow),"</b>")
      
      freqRow <- t(freqRow)
      freqRow <- na.omit(freqRow,colnames(freqRow))
      freqRow
      
    }, colnames="", selection=list(mode="none"),escape=F, options = list(searching = F, paginate = F, ordering = F, dom = 't')
  )
  
  output$otherSumStatsTable <- renderDataTable(
    {
      statsData<-NULL
      if(reactives$selRiskVariant()$GWAS=="META5")
      {
        statsData <- other_sum_stats_for_meta5_gwas[which(other_sum_stats_for_meta5_gwas$RSID == reactives$selRiskVariant()$RSID),]
        
      }
      else if(reactives$selRiskVariant()$GWAS=="Progression")
      {
        statsData <- other_sum_stats_for_prog_gwas[which(other_sum_stats_for_prog_gwas$RSID == reactives$selRiskVariant()$RSID),]
        
      }
      else if(reactives$selRiskVariant()$GWAS=="Asian")
      {
        statsData <- other_sum_stats_for_asian_gwas[which(other_sum_stats_for_asian_gwas$RSID == reactives$selRiskVariant()$RSID),]
        
      }
      other_gwas_info_sub <- other_gwas_info[which(other_gwas_info$ID %in% statsData$GWAS),]
      
      statsData$STUDY <- paste0("<a href='",other_gwas_info_sub[other_gwas_info_sub$ID==statsData$GWAS,]$LINK, "' target = '_blank'>",other_gwas_info_sub[other_gwas_info_sub$ID==statsData$GWAS,]$SHORT_REF," GWAS</a>")
      
      statsData <- statsData %>% select("STUDY","RSID","EFFECT_FREQ","BETA","SE","P")
      colnames(statsData) <- c("GWAS", "Risk Variant", "Effect Allele Frequency", "Beta", "SE","P-value")
      
      statsData
      
    },selection=list(mode="none"),escape=F,rownames = F, options = list(searching = F, paginate = F, dom = 't', columnDefs = list(list(
      className = 'dt-right', 
      targets = c(2,3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : parseFloat(data).toPrecision(3);",
        "}"
      ))))
  )
}
