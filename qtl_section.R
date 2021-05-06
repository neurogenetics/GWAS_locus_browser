qtl_section<-list()
qtl_section$id <- "qtl"
qtl_section$title <- "QTL Evidence"

qtl_section$loadData<- function(){
  
  
  #read in the csv file containing  info about all the plots
  qtl_info <<- fread("www/qtl/all_qtl_info_new.csv")
  
  #list to map feature/dataset short names to the full feature/dataset name
  qtl_feature_title <<- {  
    feature_title_list <- list()
    feature_title_list[['brain']] <- 'Qi et al. Brain eQTL'
    feature_title_list[['blood']] <- 'Vosa et al. Blood eQTL'
    feature_title_list[['i_pe']] <- 'PsychENCODE isoQTL'
    feature_title_list[['e_pe']] <- 'PsychENCODE eQTL'
    feature_title_list[['cortex']] <- 'Sieberts et al. Cortex eQTL'
    feature_title_list
  }
}

qtl_section$generateUI<- function(){

    div(id = "qtlSection",

        fluidRow(
          column(div(uiOutput('qtlSelectUI'),class="geneselect"),width =2),
          column(div(numericInput("qtl_correl_cutoff", label = "Correlation Cutoff", value = 0.3, min = 0.00, max = 1.0,step=0.1),class="qtlcutoff"),width = 2)
        ),
        fluidRow(
          column(htmlOutput("qtl_correl_score_text"), width = 12)
        ),
        hr(),

        h3("Locus Compare Plot Data:"),
        p(HTML('The selected plot is highlighted and <b>bolded</b> values contribute to scores calculated using the above "Correlation Cutoff" input.')),
        fluidRow(
          column(dataTableOutput("qtlPlotTable"), width = 12)
        ),
        hr(),
        h3("Locus Compare Plots:"),
        fluidRow(
          column(tabsetPanel(id="qtltabsetPanel"
                             ,type="pills",
                             tabPanel('Qi et al. Brain eQTL',
                                      div(
                                        fluidRow(
                                          column(align = "center", h3("Qi et al. Brain eQTL Locus Compare Plot"), width = 12)
                                        ),
                                        fluidRow(
                                          column(id = "brainQTLPlotdiv", align = "center", imageOutput("brainQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                        ),
                                      )
     
                             ),
                             
                             tabPanel('Vosa et al. Blood eQTL',
                                      div(
                                        fluidRow(
                                          column(align = "center", h3("Vosa et al. Blood eQTL Locus Compare Plot"), width = 12)
                                        ),
                                        fluidRow(
                                          column(id = "bloodQTLPlotdiv", align = "center", imageOutput("bloodQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                        ),
                                      )
                             ),
                             tabPanel('PsychENCODE eQTL',
                                      div(
                                        fluidRow(
                                          column(align = "center", h3("PsychENCODE Brain eQTL Locus Compare Plot"), width = 12)
                                        ),
                                        fluidRow(
                                          column(id = "pe_eQTLPlotdiv", align = "center", imageOutput("pe_eQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                        ),
                                      )
                             ),
                             
                             tabPanel('PsychENCODE isoQTL',
                                      div(
                                        fluidRow(
                                          column(uiOutput('isoQTLSelect_tabUI'),width =2)
                                        ),
                                        fluidRow(
                                          column(align = "center", h3("PsychENCODE Brain isoQTL Locus Compare Plot"), width = 12)
                                        ),
                                        fluidRow(
                                          column(id = "pe_isoQTLPlotdiv", align = "center", imageOutput("pe_isoQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                        ),
                                      )
                                      
                             ),
                             tabPanel('Sieberts et al. Cortex eQTL',
                                      div(
                                        fluidRow(
                                          column(align = "center", h3("Sieberts et al. Cortex eQTL Locus Compare Plot"), width = 12)
                                        ),
                                        fluidRow(
                                          column(id = "cortexQTLPlotdiv", align = "center", imageOutput("cortexQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                        ),
                                      )
                                      
                             )
          ), width = 12)
        )

)
}

qtl_section$serverLogic <- function(input,output,session,reactives)
{

  #populate the dropdown using the reactive value
  output$qtlSelectUI <- renderUI({
    dropDownGenes <- sort(unique(qtl_info[(qtl_info$RSID == reactives$selRiskVariant()$RSID & qtl_info$has_plot==TRUE),]$GENE))
    
    #default selected to the first in the list
    selected_gene <- dropDownGenes[1]
    #if there was a searched gene, select that
    if(reactives$searchedGene()!="")
    {
      selected_gene <-dropDownGenes[match(toupper(reactives$searchedGene()), toupper(as.vector(dropDownGenes)))] 
    }
    
    if(length(dropDownGenes)==0)
    {
      dropDownGenes <- c("NA")
    }
    
    selectInput("qtlSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })
  

  #update the isoform selector
  output$isoQTLSelect_tabUI <- renderUI({
    iso_plots <- list.files("www/qtl/i_pe_plots")

    isoforms <- str_extract(iso_plots, paste0("^", input$qtlSelect, "_(\\w+)_", (reactives$selRiskVariant()$RSID), ".png"))
    isoforms <- isoforms[!is.na(isoforms)]

    isoforms <- sub(paste0("^", input$qtlSelect, "_(\\w+)_", (reactives$selRiskVariant()$RSID), ".png"), "\\1", isoforms)


    selectInput("isoQTLSelect_tab",label = "Choose an isoform", choices = isoforms, selected = isoforms[1])
  })
  
  #need to update this even when it's hidden
  outputOptions(output,"isoQTLSelect_tabUI",suspendWhenHidden = FALSE)
  
  #render the qtl Plot Table 
  output$qtlPlotTable <- renderDT({
    
    #construct and modify a dataframe that holds info for plots for the selected gene
    risk_var_data<- qtl_section$updateQTLEvidence(input,output,session,reactives)
    
    tableData <- risk_var_data[ risk_var_data$has_plot==TRUE & risk_var_data$GENE==input$qtlSelect,]
    
    tableData$Plot <- paste(unlist(qtl_feature_title[tableData$feature]))
    
    #if(!is.null(input$qtltabsetPanel))
    {
      brain_proxy_bold_index = (tableData$feature == 'brain' | tableData$feature == 'e_pe' | tableData$feature == 'i_pe' | tableData$feature == 'cortex') & tableData$has_plot
      blood_proxy_bold_index = tableData$feature == 'blood' & tableData$has_plot
      
      tableData$forced_lead_variant[brain_proxy_bold_index] <- paste0("<b>",tableData$forced_lead_variant[brain_proxy_bold_index],"</b>")
      tableData$forced_lead_variant[blood_proxy_bold_index] <- paste0("<b>",tableData$forced_lead_variant[blood_proxy_bold_index],"</b>")
      
      
      brain_count_bold_index = (tableData$feature == 'brain' | tableData$feature == 'e_pe' | tableData$feature == 'i_pe' | tableData$feature == 'cortex') & tableData$has_plot
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
  
  
  
  #load the brain QTL plot
  output$brainQTLPlot_tab <- renderImage({
    #filename for eQTL locus compare plot with index variant marked as lead snp
    rsid_plot_name <- paste0("www/qtl/brain_plots/", input$qtlSelect, "_", reactives$selRiskVariant()$RSID , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Brain LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  #load the blood QTL plot
  output$bloodQTLPlot_tab <- renderImage({
    #filename for eQTL locus compare plot with index variant marked as lead snp
    rsid_plot_name <- paste0("www/qtl/blood_plots/", input$qtlSelect, "_", reactives$selRiskVariant()$RSID , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No Blood LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  #load the psychencode eQTL plot
  output$pe_eQTLPlot_tab <- renderImage({
    
    rsid_plot_name <- paste0("www/qtl/e_pe_plots/", input$qtlSelect, "_", reactives$selRiskVariant()$RSID , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No PsychENCODE eQTL LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  #load the psychencode isoQTL plot
  output$pe_isoQTLPlot_tab <- renderImage({
    
    rsid_plot_name <- paste0("www/qtl/i_pe_plots/", input$qtlSelect, "_", input$isoQTLSelect_tab, "_", reactives$selRiskVariant()$RSID , ".png")
    
    list(src = rsid_plot_name, contentType = 'image/png', width = '100%', alt = "No PsychENCODE isoQTL LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  #load the Sieberts et al. Cortex eQTL plot
  output$cortexQTLPlot_tab <- renderImage({
    
    download_path <- paste0("GWAS BROWSER/Locuscompare plots/cortex_plots/",input$qtlSelect,"_",reactives$selRiskVariant()$RSID,".png")

    if(file.exists(auth_token)){
      print("has token")
      drive_auth(token=readRDS(auth_token))
      driveget <- drive_get(path=download_path)
    }
    else
    {
      print("no token")
    }


    if(nrow(driveget)!=0)
    {
      drive_download(driveget,path = "cortex_plot_temp.png",overwrite = TRUE)
      #may want to delete the file if no plot is found?
    }
    #rsid_plot_name <- paste0("www/qtl/cortex_plots/", input$qtlSelect, "_", reactives$selRiskVariant()$RSID , ".png")
    
    list(src = "cortex_plot_temp.png", contentType = 'image/png', width = '100%', alt = "No Sieberts et al. Cortex eQTL LocusCompare Plot")
    
  }, deleteFile = FALSE)
  
  
  
  observeEvent(input$qtlSelect,
               {
                 updateQTLTabsets()
               })
  
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
  
  
  
  
  
  
  #hide or show panels depending on data available
  updateQTLTabsets <- function()
  {
    #get the rows for the selected genes
    gene_qtl_plots <- qtl_info[(qtl_info$GENE == input$qtlSelect) & (qtl_info$RSID ==(reactives$selRiskVariant()$RSID)) & (qtl_info$has_plot==TRUE) ,]

    #get a list of all possible features
    all_features <- names(qtl_feature_title)
    #get the features from gene_qtl_plots that we will want to show
    gene_plot_features <- unique(gene_qtl_plots$feature)
    
    #go through all features
    for (feature in all_features)
    {
      title <- qtl_feature_title[[feature]]
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
  

  

  
}



qtl_section$getQTLEvidence <- function(input,output,session,reactives)
{
  temp<-qtl_section$updateQTLEvidence(input,output,session,reactives) %>% select("GENE","LOC_NUM","RSID","QTL-brain","QTL-blood","QTL-correl")
  colnames(temp) <- c("GENE","LOC_NUM","RSID","QTL_brain_score","QTL_blood_score", "QTL_correl_score")

  evidence_per_gene <-distinct(temp 
                               #group by gene because we only want one line per gene in the evidence table
                               %>% group_by(GENE) 
                               #if any QTL-brain scores are 1, then use that value
                               %>% mutate(QTL_brain = max(QTL_brain_score)) 
                               #if any QTL-blood scores are 1, then use that value
                               %>% mutate(QTL_blood = max(QTL_blood_score)) 
                               #if any QTL-correl scores are 1, then use that value
                               %>% mutate(QTL_correl = qtl_section$getMaxQTLCorrelScore(QTL_correl_score)) 
                               #%>% mutate(QTL_correl = max(QTL_correl_score[QTL_correl_score!='NA'])) 
                               #select the mutated columns and identifying columns
                               %>% select("GENE","LOC_NUM","RSID","QTL_brain","QTL_blood","QTL_correl")) 
  
  
  colnames(evidence_per_gene) <- c("GENE","LOC_NUM","RSID","QTL-brain","QTL-blood","QTL-correl")
  
  evidence_per_gene
  

}
#update the evidence scores for QTL depending on QTL scoring settings

qtl_section$updateQTLEvidence <- function(input,output,session,reactives)
{
  #get the the plot info for the risk snp the user is viewing
  qtl_evidence_subset <- qtl_info[qtl_info$RSID ==(reactives$selRiskVariant()$RSID) ,] %>% select("GENE","TRANSCRIPT","GWAS","LOC_NUM","RSID","forced_lead_variant","forced_lead_variant_r2","reason","num_snps","can_plot","has_plot","feature","correlation","plot_status")
  qtl_evidence_subset$correlation <- ifelse(is.na(qtl_evidence_subset$correlation),'NA',qtl_evidence_subset$correlation)
  
  qtl_evidence_subset$TRANSCRIPT <- ifelse(is.na(qtl_evidence_subset$TRANSCRIPT),'NA',qtl_evidence_subset$TRANSCRIPT)
  qtl_evidence_subset$has_plot <- ifelse(is.na(qtl_evidence_subset$has_plot),FALSE,qtl_evidence_subset$has_plot)
  
  qtl_brain_index = (qtl_evidence_subset$has_plot) & (qtl_evidence_subset$feature == 'brain' | qtl_evidence_subset$feature == 'e_pe' | qtl_evidence_subset$feature == 'i_pe' | qtl_evidence_subset$feature == 'cortex')
  
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

qtl_section$getMaxQTLCorrelScore <- function(scores)
{
  uniques <- unique(scores)
  
  if('1' %in% uniques)
    return('1')
  if('0' %in% uniques)
    return('0')
  if(NA %in% uniques)
    return(NA)
  
}
