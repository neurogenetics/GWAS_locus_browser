library(shiny)
library(DT)
library(shinyjs)
library(dplyr)
library(googledrive)
library(readr)
library(shinyanimate)
library(ggplot2)
library(plotly)
library(openxlsx)

library(rvest)
library(tidyverse)
library(stringr)
library(data.table)
library(shinyhelper)
library(htmlwidgets)


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



  source('tutorial.R', local = T)
  
  
  shinyjs::show("splashLogo")
  startAnim(session,
            id = "splashLogo",
            type = "flipInX")

  output$logoImage <- renderImage({
    list(src = "IDPGC-locusbrowser.wrapper.png", contentType = 'image/png', width = '100%')
  }, deleteFile = FALSE)
  
  #vector of the section names, in the order they are shown in the app
  section_ids<- c("Locus Zoom", "Summary Statistics", "Best Candidate", "Evidence Per Gene", "QTL Evidence", "Coding Variants", "Associated Variant Phenotypes", "Burden Evidence", "Expression Data", "Constraint Values", "Disease Genes", "Fine-Mapping of Locus", "Literature")
  nav_ids <- sprintf("#collapse%d",seq(1:length(section_ids)))
  nav_df <- data.frame(s = section_ids, id = nav_ids)
  
  #print(nav_df)
  
  observe_helpers(session = session, help_dir = "www/help_files")
  
  #flag for if the searchButton was clicked. Set to TRUE when clicked and FALSE when an rsID is clicked or the logo is clicked
  searchClicked <- F
  
    #read evidence data from the file
    evidence <- readEvidencePerGene()
    #copy the evidence to another dataframe for subseting evidence by selected locus
    locusEvidence <- evidence
    #copy the evidence to another dataframe for modifying weights
    userEvidence <- evidence
    
    #function to check if the search term is formatted and a gene and exists in the data
    getSearchedGene <- function()
    {
      retval <- NULL
      if(input$searchInputBar != "")
      {
        #use the function in loci_sidebar.R to check if the string is formatted as a gene
        if(searchStringIsGene(input$searchInputBar))
        {
          
          #check if entered gene is in the data as is or when forced uppercase (for things like C1orf189 that don't have an all uppercase gene name)
          if(input$searchInputBar %in% evidence$GENE)
          {
            retval <- input$searchInputBar
            

          }

          if(toupper(input$searchInputBar) %in% evidence$GENE)
          {
            retval <- toupper(input$searchInputBar)
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
      if( searchClicked && !is.null((reactives$searchedGene)))
      {

        geneLoci <- evidence[evidence$GENE %in% (reactives$searchedGene)]$LOC_NUM

        if(geneLoci %in% gwas_data$'LOC_NUM')
        {
          retval <- gwas_data[gwas_data$'LOC_NUM' %in% geneLoci,]

        }
        
      }
      #get the default when there is no clickedID
      else if(length(input$clickedID) == 0)
      {

        #retval <- gwas_data[which(gwas_data$'NEAR_GENE' == "PMVK")]
        retval <- gwas_data[1,]
        updateSelectInput(session, "qtlSelect", choices = getQTLDropDownGenes(retval$RSID))
        
        #get gene list for the section dropdowns
        dropDownGenes <- (evidence[(evidence$LOC_NUM == retval$LOC_NUM & (evidence$GWAS == gwas_id_string)),]$GENE)#qtlData[qtlData$Locusnumber %in% reactives$selRow$'LOC_NUM']$Gene

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

        if(input$clickedID %in% gwas_data$RSID)
        {
          retval <- gwas_data[which(gwas_data$RSID == input$clickedID)]

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
      

      #update selected gwas to match the new selected locus
      if(retval$GWAS !=gwas_id_string)
      {
        gwas_id_string <<- retval$GWAS
        updateSelectInput(session, inputId = "gwasSelect", choices = gwases, selected =  gwases[which(gwases %in% retval$GWAS)])
      }
      
      
      retval
    }
    
    
    updateSelectInput(session, inputId = "gwasSelect", choices = gwases, selected =  gwases[1])
    #code for the detail panel containing all the other data
    source("detail_panel.R", local = T)
    #reactive values for the selected row in meta5_gwas_data or prog_gwas_data, and the searched gene
    reactives <- reactiveValues()
    
    observe( reactives$selRow <- getSelectedRow())
    
    observe( reactives$searchedGene <- getSearchedGene())
    
    
    
    reactives$selRow <-gwas_data[1,]
    #code for the sidebar
    source("loci_sidebar.R", local = T)
    

    #code for the about tab
    source("About.R", local = T)

    
    renderLocusZooms()
    
    renderOtherSumStatsTable()
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
      removeTutorialDataHighlights()

    })
    
    observeEvent(input$`tab-about`,{
      updateTabsetPanel(session, "tabSetID", "About")
    })
})