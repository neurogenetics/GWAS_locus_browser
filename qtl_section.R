#get mapping of features from qtl_info to feature title names for the Tabs
getQTLFeatureTitles <- function()
{
  qtl_feature_title <- list()
  
  qtl_feature_title[['brain']] <- 'Qi et al. Brain eQTL'
  qtl_feature_title[['blood']] <- 'Vosa et al. Blood eQTL'
  qtl_feature_title[['i_pe']] <- 'PsychENCODE isoQTL'
  qtl_feature_title[['e_pe']] <- 'PsychENCODE eQTL'
  qtl_feature_title
}


#get gene list for the qtl drop down. match by rsid if it's not NA
getQTLDropDownGenes <- function(rsid=NA)
{
  if(!is.na(rsid))
  {
    geneList <- sort(unique(qtl_info[(qtl_info$RSID == (rsid) & qtl_info$has_plot==TRUE),]$GENE))
  }
  else
  {
    geneList <- sort(unique(qtl_info[(qtl_info$RSID == (isolate(reactives$selRow$RSID)) & qtl_info$has_plot==TRUE),]$GENE))
  }

  
  if(length(geneList)==0)
  {
    geneList <- c("NA")
  }
  geneList
}

renderQTLPlotTable <- function()
{
  
  output$qtlPlotTable <- renderDT({
    
    #construct and modify a dataframe that holds info for plots for the selected gene
    risk_var_data<- updateQTLEvidence()

    tableData <- risk_var_data[ risk_var_data$has_plot==TRUE & risk_var_data$GENE==input$qtlSelect,]

    tableData$Plot <- paste(unlist(getQTLFeatureTitles()[tableData$feature]))
    
    #if(!is.null(input$qtltabsetPanel))
    {
      brain_proxy_bold_index = (tableData$feature == 'brain' | tableData$feature == 'e_pe' | tableData$feature == 'i_pe') & tableData$has_plot
      blood_proxy_bold_index = tableData$feature == 'blood' & tableData$has_plot
  
      tableData$forced_lead_variant[brain_proxy_bold_index] <- paste0("<b>",tableData$forced_lead_variant[brain_proxy_bold_index],"</b>")
      tableData$forced_lead_variant[blood_proxy_bold_index] <- paste0("<b>",tableData$forced_lead_variant[blood_proxy_bold_index],"</b>")
      

      brain_count_bold_index = (tableData$feature == 'brain' | tableData$feature == 'e_pe' | tableData$feature == 'i_pe') & tableData$has_plot
      blood_count_bold_index = tableData$feature == 'blood' & tableData$has_plot
  
      
      tableData$num_snps[brain_count_bold_index] <- paste0("<b>",tableData$num_snps[brain_count_bold_index],"</b>")
      tableData$num_snps[blood_count_bold_index] <- paste0("<b>",tableData$num_snps[blood_count_bold_index],"</b>")
      
      corr_bold_index = (tableData$correlation!='NA') & (abs(as.numeric(tableData$correlation)) > input$qtl_correl_cutoff)
      
      tableData$correlation[tableData$correlation!='NA'] <- signif(as.numeric(tableData$correlation[tableData$correlation!='NA']),4)
      
      tableData$correlation[corr_bold_index] <- paste0("<b>",tableData$correlation[corr_bold_index],"</b>")
      
      tableData <- tableData[,c("Plot","GENE","TRANSCRIPT","RSID","forced_lead_variant","forced_lead_variant_r2","num_snps","correlation","QTL-brain","QTL-blood","QTL-correl")]
      colnames(tableData) <- c("Plot", "Gene", "Transcript", "Risk Variant", "Proxy Variant", "Proxy Variant r2", "SNPs In Plot", "Correlation","QTL-brain Score","QTL-blood Score","QTL-correl Score")
      
      tableData$helper <- FALSE
      if(!is.null(input$qtltabsetPanel))
      {
        #add a bool column to indicate if we selected that column in the tabs. for isoQTL we need to check for transcripts in addition to the selected tab
        if(input$qtltabsetPanel!="PsychENCODE isoQTL" )
        {
          tableData$helper <- ifelse( tableData$Plot==input$qtltabsetPanel,TRUE,FALSE)
        }
        else
        {
          tableData$helper <- ifelse( tableData$Plot==input$qtltabsetPanel & tableData$Transcript==input$isoQTLSelect_tab,TRUE,FALSE)
        }
      }

  
      datatable(tableData, rownames = F, escape=F, options = list(order = list(0, 'desc'),processing = F, searching = F, paginate = F, dom = 't', scrollY =  "200px", scrollX = T,columnDefs = list(
        list(
          visible=FALSE,
          targets=which(colnames(tableData)=='helper')-1   
        ),
        list(
          className = 'dt-right',
          targets = c(1:ncol(tableData)-1),
          render = JS(
            "function(data, type, row, meta) {",
            "return (data==null) ? 'NA' : data;",
            "}"
          )
  
        )
      ))) %>% formatStyle('helper', target='row',
                          backgroundColor = styleEqual(TRUE,'#337ab7'),
                          color = styleEqual(TRUE, '#fff')) 

    }
    
  })
}

#hide or show panels depending on data available
updateQTLTabsets <- function()
{
  #get the rows for the selected genes
  gene_qtl_plots <- qtl_info[(qtl_info$GENE == input$qtlSelect) & (qtl_info$RSID ==isolate(reactives$selRow$RSID)) & (qtl_info$has_plot==TRUE) ,]
  #get a list of all possible features
  all_features <- names(getQTLFeatureTitles())
  #get the features from gene_qtl_plots that we will want to show
  gene_plot_features <- unique(gene_qtl_plots$feature)
  
  #go through all features
  for (feature in all_features)
  {
    title <- getQTLFeatureTitles()[[feature]]
    #if the gene has data for that feature then show the tab
    if(feature %in% gene_plot_features)
    {
      showTab("qtltabsetPanel",title) 
    }
    #if the gene has no data for that feature then hide the tab
    else
    {
      hideTab("qtltabsetPanel",title) 
    }
  }
  

  
}



observeEvent(input$qtlSelect,
             {
               updateQTLTabsets()
               iso_plots <- list.files("www/qtl/i_pe_plots")
               
               isoforms <- str_extract(iso_plots, paste0("^", input$qtlSelect, "_(\\w+)_", isolate(reactives$selRow$RSID), ".png"))
               isoforms <- isoforms[!is.na(isoforms)]
               
               isoforms <- sub(paste0("^", input$qtlSelect, "_(\\w+)_", isolate(reactives$selRow$RSID), ".png"), "\\1", isoforms)
               
               updateSelectInput(session, "isoQTLSelect_tab", choices = isoforms, selected=isoforms[1])
               renderQTLPlotTable()
               renderQTLPlots()
             })

renderQTLPlots <- function()
{

  #load the brain QTL plot
  output$brainQTLPlot_tab <- renderImage({
    #filename for eQTL locus compare plot with index variant marked as lead snp
    rsid_plot_name <- paste0("www/qtl/brain_plots/", input$qtlSelect, "_", isolate(reactives$selRow$RSID) , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Brain LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  #load the blood QTL plot
  output$bloodQTLPlot_tab <- renderImage({
    #filename for eQTL locus compare plot with index variant marked as lead snp
    rsid_plot_name <- paste0("www/qtl/blood_plots/", input$qtlSelect, "_", isolate(reactives$selRow$RSID) , ".png")

    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Blood LocusCompare Plot")

  }, deleteFile = FALSE)
  
  #load the psychencode eQTL plot
  output$pe_eQTLPlot_tab <- renderImage({
    
    rsid_plot_name <- paste0("www/qtl/e_pe_plots/", input$qtlSelect, "_", isolate(reactives$selRow$RSID) , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No PsychENCODE eQTL LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  #load the psychencode isoQTL plot
  output$pe_isoQTLPlot_tab <- renderImage({
    
    rsid_plot_name <- paste0("www/qtl/i_pe_plots/", input$qtlSelect, "_", input$isoQTLSelect_tab, "_", isolate(reactives$selRow$RSID) , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No PsychENCODE isoQTL LocusCompare Plot")
    
  }, deleteFile = FALSE)

}

#when any of the scoring inputs change, we need to update the scoring descriptions
observeEvent(
  {
    input$qtl_correl_cutoff
    input$qtlSelect
  },
  {
    genestr <- ""
    if(input$qtlSelect=="NA")
    {
      genestr <- "the gene"
    }
    else
    {
      genestr <- input$qtlSelect
    }
    #QTL-Correl Scoring
    output$qtl_correl_score_text <- renderUI(HTML(paste("For a QTL-Correl score of 1 ", genestr," needs the absolute value of the Pearson's Correlation Coefficient to be greater than ",input$qtl_correl_cutoff," in any of its plots with a QTL-brain or QTL-blood score of 1")))
  }
)


#update the evidence scores for QTL depending on QTL scoring settings
updateQTLEvidence <- function()
{
  #get the the plot info for the risk snp the user is viewing
  qtl_evidence_subset <- qtl_info[qtl_info$RSID ==(reactives$selRow$RSID) ,] %>% select("GENE","TRANSCRIPT","GWAS","LOC_NUM","RSID","forced_lead_variant","forced_lead_variant_r2","reason","num_snps","can_plot","has_plot","feature","correlation","plot_status")
  qtl_evidence_subset$correlation <- ifelse(is.na(qtl_evidence_subset$correlation),'NA',qtl_evidence_subset$correlation)

  qtl_evidence_subset$TRANSCRIPT <- ifelse(is.na(qtl_evidence_subset$TRANSCRIPT),'NA',qtl_evidence_subset$TRANSCRIPT)
  qtl_evidence_subset$has_plot <- ifelse(is.na(qtl_evidence_subset$has_plot),FALSE,qtl_evidence_subset$has_plot)

  qtl_brain_index = (qtl_evidence_subset$has_plot) & (qtl_evidence_subset$feature == 'brain' | qtl_evidence_subset$feature == 'e_pe' | qtl_evidence_subset$feature == 'i_pe')

  qtl_evidence_subset$'QTL-brain' <- 0
  qtl_evidence_subset$'QTL-brain'[qtl_brain_index] <- 1
  


  qtl_blood_index = (qtl_evidence_subset$has_plot) & (qtl_evidence_subset$feature == 'blood' )
    
  
  qtl_evidence_subset$'QTL-blood' <- 0
  qtl_evidence_subset$'QTL-blood'[qtl_blood_index] <- 1
  
  qtl_evidence_subset$'QTL-correl' <- NA
  #if no plot exists, or there wasn't enought data to calcuclate correlation, then 'NA'
  qtl_evidence_subset$'QTL-correl'[!qtl_evidence_subset$has_plot | qtl_evidence_subset$correlation=='NA' | (qtl_evidence_subset$'QTL-blood' == 0 & qtl_evidence_subset$'QTL-brain' ==0)] <-NA
  #if a plot exists, correlation is not 'NA' and the correlation is greater than the cutoff, then 1
  not_na_index= (qtl_evidence_subset$'QTL-blood' == 1 | qtl_evidence_subset$'QTL-brain' == 1) & qtl_evidence_subset$has_plot & qtl_evidence_subset$correlation!='NA'
  qtl_evidence_subset$'QTL-correl'[not_na_index] <- ifelse(abs(as.numeric(qtl_evidence_subset$correlation[not_na_index])) > input$qtl_correl_cutoff,1,0)


  qtl_evidence_subset
}


getMaxQTLCorrelScore <- function(scores)
{
  uniques <- unique(scores)
  
  if('1' %in% uniques)
    return('1')
  if('0' %in% uniques)
    return('0')
  if(NA %in% uniques)
    return(NA)
}

getQTLEvidence <- function()
{

  temp<-updateQTLEvidence() %>% select("GENE","LOC_NUM","RSID","QTL-brain","QTL-blood","QTL-correl")
  colnames(temp) <- c("GENE","LOC_NUM","RSID","QTL_brain_score","QTL_blood_score", "QTL_correl_score")

  evidence_per_gene <-distinct(temp 
                               #group by gene because we only want one line per gene in the evidence table
                               %>% group_by(GENE) 
                               #if any QTL-brain scores are 1, then use that value
                               %>% mutate(QTL_brain = max(QTL_brain_score)) 
                               #if any QTL-blood scores are 1, then use that value
                               %>% mutate(QTL_blood = max(QTL_blood_score)) 
                               #if any QTL-correl scores are 1, then use that value
                               %>% mutate(QTL_correl = getMaxQTLCorrelScore(QTL_correl_score)) 
                               #%>% mutate(QTL_correl = max(QTL_correl_score[QTL_correl_score!='NA'])) 
                               #select the mutated columns and identifying columns
                               %>% select("GENE","LOC_NUM","RSID","QTL_brain","QTL_blood","QTL_correl")) 


  colnames(evidence_per_gene) <- c("GENE","LOC_NUM","RSID","QTL-brain","QTL-blood","QTL-correl")


  evidence_per_gene
  
}