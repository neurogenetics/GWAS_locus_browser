library(shiny)
library(DT)
library(shinyjs)
library(dplyr)
library(googledrive)
library(readr)
library(shinyanimate)
library(PubMedWordcloud)
library(ggplot2)
library(plotly)
library(openxlsx)

library(rvest)
library(tidyverse)
library(stringr)
library(data.table)
library(shinyhelper)


#https://pdgenetics.shinyapps.io/GWASBrowser/

##run this in the console to check time and memory usage of app
#library(profvis)
#profvis({runApp()})


#load the data
source("datatables.R")

# #see what the authorized user has access to
# drive_auth("auth_token.rds")
# find<- drive_find()
# print(tail(find))



shinyServer(function(input, output, session)
{
  drive_deauth()
  
  
  
  shinyjs::show("splashLogo")
  startAnim(session,
            id = "splashLogo",
            type = "flipInX")
  
  
  output$logoImage <- renderImage({
    list(src = "IDPGC-locusbrowser.wrapper.png", contentType = 'image/png', width = '100%')
  }, deleteFile = FALSE)
  
  #vector of the section names, in the order they are shown in the app
  section_ids<- c("Interactive Locus Zoom", "Static Locus Zoom", "Summary Statistics", "Best Candidate", "Evidence Per Gene", "QTL Evidence", "Coding Variants", "Associated Variant Phenotypes", "Burden Evidence", "Expression Data", "Gene Single Cell Expression Plot", "Gene Tissue Expression Plot", "Constraint Values", "Disease Genes", "Fine-Mapping of Locus", "Literature")
  nav_ids <- sprintf("#collapse%d",seq(1:length(section_ids)))
  nav_df <- data.frame(s = section_ids, id = nav_ids)
  #print(nav_df)
  
  observe_helpers(session = session, help_dir = "www/help_files")
  
  #flag for if the searchButton was clicked. Set to TRUE when clicked and FALSE when an rsID is clicked or the logo is clicked
  searchClicked <- F
  
    #read evidence data from the file
    evidence <- readEvidencePerGene()
    #copy the evidence to another dataframe for modifying weights
    userEvidence <- evidence
    
    #function to check if the search term is formatted and a gene and exists in the data
    getSearchedGene <- function()
    {
      retval <- NULL
      if(input$searchBar != "")
      {
        #use the function in loci_sidebar.R to check if the string is formatted as a gene
        if(searchStringIsGene(input$searchBar))
        {
          
          #check if entered gene is in the data as is or when forced uppercase (for things like C1orf189 that don't have an all uppercase gene name)
          if(input$searchBar %in% evidence$Gene)
          {
            retval <- input$searchBar
          }

          if(toupper(input$searchBar) %in% evidence$Gene)
          {
            retval <- toupper(input$searchBar)
          }

        }

      }

      retval
    }
    
    #get the row from meta5 or progression data corresponding to a specific rsID. Row chosen depends on user input in the app
    getSelectedRow <- function()
    {
      retval <- NULL

      #get the row by gene if searchClicked and searchedGene is not null
      if( searchClicked && !is.null(isolate(reactives$searchedGene)))
      {
        
        geneLoci <- evidence[evidence$Gene %in% isolate(reactives$searchedGene)]$Locusnumber

        if(geneLoci %in% meta5_gwas_data$'Locus Number')
        {
          retval <- meta5_gwas_data[meta5_gwas_data$'Locus Number' %in% geneLoci,]
        }
        if(geneLoci %in% prog_gwas_data$'Locus Number')
        {
          retval <- prog_gwas_data[prog_gwas_data$'Locus Number' %in% geneLoci,]
        }
      }
      #get the default when there is no clickedID
      else if(length(input$clickedID) == 0)
      {
        retval <- meta5_gwas_data[which(meta5_gwas_data$'Nearest Gene' == "PMVK")]
        
        geneList <- evidence[which((evidence$Locusnumber == reactives$selRow$'Locus Number' & evidence$SNP == reactives$selRow$SNP) & (evidence$"QTL-blood"==1 | evidence$"QTL-brain"==1)),]
        geneList<- geneList$Gene
        #if there are no genes on the locus with plots then show NA as default
        if(length(geneList)==0)
        {
          geneList <- c("NA")
        }
        updateSelectInput(session, "qtlSelect", choices = geneList)
        
        #get gene list for the section dropdowns
        dropDownGenes <- (evidence[evidence$Locusnumber == isolate(reactives$selRow$'Locus Number'),]$Gene)#qtlData[qtlData$Locusnumber %in% reactives$selRow$'Locus Number']$Gene
        
        #don't include an "All Genes" option for dropdowns for image sections
        updateSelectInput(session, "GTEXSelect", choices = dropDownGenes)
        updateSelectInput(session, "SingleCellSelect", choices = dropDownGenes)
        updateSelectInput(session, "litGeneSelect", choices = dropDownGenes)
        
        #add "All Genes" to the list for the other drop downs
        dropDownGenes <- append(dropDownGenes, "All Genes", 0)
        updateSelectInput(session, "evidenceSelect", choices = dropDownGenes)
        updateSelectInput(session, "burdenSelect", choices = dropDownGenes)
        updateSelectInput(session, "expressionSelect", choices = dropDownGenes)
        updateSelectInput(session, "constraintSelect", choices = dropDownGenes)
        updateSelectInput(session, "diseaseSelect", choices = dropDownGenes)
        

      }
      
      #otherwise an rsID must have been clicked, so get the row for that rsID
      else 
      {
        if(input$clickedID %in% meta5_gwas_data$SNP)
        {
          retval <- meta5_gwas_data[which(meta5_gwas_data$SNP == input$clickedID)]
        }
        if(input$clickedID %in% prog_gwas_data$SNP)
        {
          retval <- prog_gwas_data[which(prog_gwas_data$SNP == input$clickedID)]
        }
      }
      #if the locus has multiple snps (multiple rows in retval) then default to the first one
      if(!is.null(retval))
      {
        if(nrow(retval)!=1)
        {
          retval <- retval[1,]
        }
      }
      retval
    }
    
    

    
    #reactive values for the selected row in meta5_gwas_data or prog_gwas_data, and the searched gene
    reactives <- reactiveValues()
    
    observe( reactives$selRow <- getSelectedRow())
    
    observe( reactives$searchedGene <- getSearchedGene())
    
    #code for the sidebar
    source("loci_sidebar.R", local = T)
    
    
    #initialize the side panel table
    output$META5Table <- renderLociTable(meta5_loci)
    
    output$ProgTable <- renderLociTable(prog_loci)
    
    #load the navigation table
    #output$navTable <- renderNavTable()

    #code for the detail panel containing all the other data
    source("detail_panel.R", local = T)
    
    #code for the about tab
    source("About.R", local = T)
    #initialize the detail panel
    renderDetailPanel()
    delay(1000,
                {
                  shinyjs::show("uiPage")
                  shinyjs::hide("splashPage")
                  shinyjs::hide("tabSetID")
                }
          )
    
    
    observeEvent(input$`tab-data`,{
      updateTabsetPanel(session, "tabSetID", "Data")
    })
    
    observeEvent(input$`tab-about`,{
      updateTabsetPanel(session, "tabSetID", "About")
    })
})