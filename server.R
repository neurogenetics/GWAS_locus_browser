
shinyServer(function(input, output,session) {
  drive_deauth()
  

  tutorialLogic(session,input,output)
  source("about.R", local = T)
  
  shinyjs::show("splashLogo")
  startAnim(session,
            id = "splashLogo",
            type = "flipInX")
  
  output$logoImage <- renderImage({
    list(src = "IDPGC-locusbrowser.wrapper.png", contentType = 'image/png', width = '100%')
  }, deleteFile = FALSE)
  
  
  #get list of titles and ids to create the "jump to section" dropdown 
  section_titles <- {
    titles <- c()
    for(section in sections){
      titles <- append(titles,section$title)
    }
    titles
  }
  nav_ids <- {
    ids <- c()
    for(section in sections){
      ids <- append(ids,paste0("#collapse_",section$id,"_1"))
    }
    ids
  }
  nav_df <- data.frame(s = section_titles, id = nav_ids)
  updateSelectInput(session, inputId = "navSelect", label = "Jump to Section:", choices = section_titles)
  
  observe_helpers(session = session, help_dir = "www/help_files")

  reactives <- list()
  #this hold the row from the gwas_data dataframe containing the selected variant in the browser. This is used to update data in the browser
  reactives$selRiskVariant <- reactiveVal(gwas_data[1,])
  #this contains the searched gene (forced to uppercase) if the user searched for a gene that exists in the browser's gene list (list taken from the full evidence table dataframe)
  reactives$searchedGene <- reactiveVal("")
  #this contains whatever was searched for in the searchbar. This is set to the contents of the search bar when the search bar is clicked, but it is reset to "" when the user selects a new gwas, clicks a new varian, or clicks the logo
  reactives$searchInputValue <- reactiveVal("")

  #call sidebar code
  sideBarLogic(session,input,output,reactives)

  
  #call the serverLogic functions for all the sections
  for(section in sections)
  {
    section$serverLogic(input,output,session,reactives)
  }
  
  
  delay(1000,
        {
          shinyjs::show("uiPage")
          shinyjs::hide("splashPage")
          shinyjs::hide("tabSetID")
        }
  )
  
  
  observeEvent(input$`tab-data`,{
    updateTabsetPanel(session, "tabSetID", "Data")
    removeTutorialDataHighlights(input)
    
  })
  
  observeEvent(input$`tab-about`,{
    updateTabsetPanel(session, "tabSetID", "About")
  })
  
  #call javascript function to navigate to section selected in the dropdown
  observeEvent(input$navSelect,
               {
                 if(input$tabSetID=="Data")
                 {
                   runjs(paste0("jumpToSection('",nav_df[which(nav_df$s == input$navSelect),]$id,"')"))
                 }

               })
})

