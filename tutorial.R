tutorialLogic <- function(session,input,output){
  observeEvent(input$tutorial.activate, {
    
    if (input$tutorial.activate == T) {
      #render the popup
      output$tutorial <-renderTutorial(pageOutput,selectOutput)
      
      #set the states of the tutorial popup
      runjs("setTutorialPage('Start')")
      runjs("setTutorialSelect('Empty')")
      
      show(
        id = "draggable-top-tutorial"
      )
      runjs(
        '$(".draggable-tutorial").position({
    my: "center center+25%",
    at: "center",
    of: window,
    using: function (pos, ext) {
        $(this).animate({ top: pos.top }, 400);
    }
})'
      )
      #need to update the label because updating the value when the tutorial finishes overwrites the original pretty toggle render (which disabled the automatic label changes)
      updatePrettyToggle(session,"tutorial.activate",label=ifelse(input$tutorial.activate,"Turn off tutorial","Turn on tutorial"),value=input$tutorial.activate)
      
    } else if (input$tutorial.activate == F) {
      
      #remove all tutorial css classes to remove all highlights
      removeCssClass(id='tab-data',class="tutorial-highlight");
      removeCssClass(id='tab-about',class="tutorial-highlight");
      removeCssClass(selector=".accordionheader",class="tutorial-highlight");
      removeCssClass(selector=".shinyhelper-icon",class="tutorial-highlight");
      removeCssClass(id='searchDiv',class="tutorial-highlight");
      removeCssClass(id="navSelectDiv", class="tutorial-highlight");
      removeCssClass(id="gwasSelectDiv", class="tutorial-highlight");
      removeCssClass(id="gwasLociTable", class="tutorial-highlight");
      removeCssClass(selector=".sidebar-toggle", class="tutorial-highlight");
      removeCssClass(selector=".logo", class="tutorial-highlight");
      removeCssClass(selector=".geneselect", class="tutorial-highlight");
      removeCssClass(selector='.slider',class="tutorial-highlight");
      removeCssClass(id='evidenceColButtons',class="tutorial-highlight");
      removeCssClass(selector='.qtlcutoff',class="tutorial-highlight");
      
      #remove the selected class from the selected element to remove it's special highlight
      removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
      showNotification(
        "Deactivating tutorial mode",
        type = "message"
      )
      
      hide(
        id = "draggable-top-tutorial"
      )
      #need to update the label because updating the value when the tutorial finishes overwrites the original pretty toggle render (which disabled the automatic label changes)
      updatePrettyToggle(session,"tutorial.activate",label=ifelse(input$tutorial.activate,"Turn off tutorial","Turn on tutorial"),value=input$tutorial.activate)
    }
    
  },
  ignoreInit = T
  )
  
  #when the javascript code updates tutorial.select on mouse over, reload the UI based on the selected input
  observeEvent(
    {
      input$tutorial.select
    }, 
    {
      #default for start
      if(input$tutorial.select=="Empty")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.empty)
      }
      if(input$tutorial.select=="About")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.about)
      }
      #only show description of data tab if we aren't on the data page part of the tutorial
      if(input$tutorial.select=="Data" && input$tutorial.page!="Data")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.data)
      }
      if(input$tutorial.select=="Navigate")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.navigate)
      }
      #only show description of the logo if we aren't on the data page part of the tutorial
      if(input$tutorial.select=="Logo" && input$tutorial.page!="Data")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.logo)
      }
      if(input$tutorial.select=="SideBarToggle")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.sidebartoggle)
      }
      
      #only show description of searchbar if we aren't on the data page part of the tutorial
      if(input$tutorial.select=="Search" && input$tutorial.page!="Data")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.search)
      }
      if(input$tutorial.select=="GWASSelect")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.gwasselect)
      }
      #only show description of gwastable if we aren't on the data page part of the tutorial
      if(input$tutorial.select=="GWASTable" && input$tutorial.page!="Data")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.gwastable)
      }
      
      if(input$tutorial.select=="Accordion")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.accordion)
      }
      
      if(input$tutorial.select=="Help")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.help)
      }
      if(input$tutorial.select=="GeneSelect")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.geneselect)
      }
      if(input$tutorial.select=="EvidenceSlider")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.evidenceslider)
      }
      if(input$tutorial.select=="EvidenceButton")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.evidencebutton)
      }
      if(input$tutorial.select=="QTLCutoff")
      {
        output$tutorialSelectOutput <- renderUI(tutorial.select.qtlcutoff)
      }
      
      
    }
  )
  #when the javascript code updates tutorial.page on a click of the 'Next' link, reload the UI based on the value
  observeEvent(
    {
      input$tutorial.page
    }, 
    {
      
      if (input$tutorial.activate == T) 
      {
        show(
          id = "draggable-top-tutorial"
        )
        #on start, remove all highlights and load the start ui.
        if(input$tutorial.page=="Start")
        {
          removeCssClass(id='tab-data',class="tutorial-highlight");
          removeCssClass(id='tab-about',class="tutorial-highlight");
          removeCssClass(selector=".accordionheader",class="tutorial-highlight");
          removeCssClass(selector=".shinyhelper-icon",class="tutorial-highlight");
          removeCssClass(id='searchDiv',class="tutorial-highlight");
          removeCssClass(id="navSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasLociTable", class="tutorial-highlight");
          removeCssClass(selector=".sidebar-toggle", class="tutorial-highlight");
          removeCssClass(selector=".logo", class="tutorial-highlight");
          removeCssClass(selector=".geneselect", class="tutorial-highlight");
          removeCssClass(selector='.slider',class="tutorial-highlight");
          removeCssClass(id='evidenceColButtons',class="tutorial-highlight");
          removeCssClass(selector='.qtlcutoff',class="tutorial-highlight");
          removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
          
          output$tutorialSelectOutput <- renderUI(tutorial.select.empty)
          output$tutorialPageOutput <- renderUI(tutorial.page.start)
        }
        #highlight header inputs and reload the ui
        else if(input$tutorial.page=="Header")
        {
          addCssClass(id='tab-data',class="tutorial-highlight tutorial-input");
          addCssClass(id='tab-about',class="tutorial-highlight tutorial-input");
          addCssClass(id="navSelectDiv", class="tutorial-highlight tutorial-input");
          addCssClass(selector=".sidebar-toggle", class="tutorial-highlight tutorial-input");
          addCssClass(selector=".logo", class="tutorial-highlight tutorial-input");
          
          removeCssClass(selector=".accordionheader",class="tutorial-highlight");
          removeCssClass(selector=".shinyhelper-icon",class="tutorial-highlight");
          removeCssClass(id='searchDiv',class="tutorial-highlight");
          removeCssClass(id="gwasSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasLociTable", class="tutorial-highlight");
          removeCssClass(selector=".geneselect", class="tutorial-highlight");
          removeCssClass(selector='.slider',class="tutorial-highlight");
          removeCssClass(id='evidenceColButtons',class="tutorial-highlight");
          removeCssClass(selector='.qtlcutoff',class="tutorial-highlight");
          removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
          
          output$tutorialSelectOutput <- renderUI(tutorial.select.empty)
          output$tutorialPageOutput <- renderUI(tutorial.page.header)
        }
        #highlight sidebar inputs and reload the ui
        else if(input$tutorial.page=="Sidebar")
        {
          addCssClass(id='searchDiv',class="tutorial-highlight tutorial-input");
          addCssClass(id="gwasSelectDiv", class="tutorial-highlight tutorial-input");
          addCssClass(id="gwasLociTable", class="tutorial-highlight tutorial-input");
          
          removeCssClass(id='tab-data',class="tutorial-highlight");
          removeCssClass(id='tab-about',class="tutorial-highlight");
          removeCssClass(selector=".accordionheader",class="tutorial-highlight");
          removeCssClass(selector=".shinyhelper-icon",class="tutorial-highlight");
          removeCssClass(id="navSelectDiv", class="tutorial-highlight");
          removeCssClass(selector=".sidebar-toggle", class="tutorial-highlight");
          removeCssClass(selector=".logo", class="tutorial-highlight");
          removeCssClass(selector=".geneselect", class="tutorial-highlight");
          removeCssClass(selector='.slider',class="tutorial-highlight");
          removeCssClass(id='evidenceColButtons',class="tutorial-highlight");
          removeCssClass(selector='.qtlcutoff',class="tutorial-highlight");
          removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
          
          output$tutorialSelectOutput <- renderUI(tutorial.select.empty)
          output$tutorialPageOutput <- renderUI(tutorial.page.sidebar)
        }
        #highlight some of the data page inputs and reload the ui
        else if(input$tutorial.page=="Data")
        {
          
          addCssClass(selector=".accordionheader",class="tutorial-highlight tutorial-input");
          addCssClass(selector=".shinyhelper-icon",class="tutorial-highlight tutorial-input");
          addCssClass(selector=".geneselect", class="tutorial-highlight tutorial-input");
          addCssClass(selector='.slider',class="tutorial-highlight tutorial-input");
          addCssClass(id='evidenceColButtons',class="tutorial-highlight tutorial-input");
          addCssClass(selector='.qtlcutoff',class="tutorial-highlight tutorial-input");
          
          removeCssClass(id='tab-data',class="tutorial-highlight");
          removeCssClass(id='tab-about',class="tutorial-highlight");
          removeCssClass(id='searchDiv',class="tutorial-highlight");
          removeCssClass(id="navSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasLociTable", class="tutorial-highlight");
          removeCssClass(selector=".sidebar-toggle", class="tutorial-highlight");
          removeCssClass(selector=".logo", class="tutorial-highlight");
          removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
          
          if(input$tabSetID!="Data")
          {
            addCssClass(id='tab-data',class="tutorial-highlight tutorial-input");
            addCssClass(id='searchDiv',class="tutorial-highlight tutorial-input");
            addCssClass(id="gwasLociTable", class="tutorial-highlight tutorial-input");
            addCssClass(selector=".logo", class="tutorial-highlight tutorial-input");
          }
          
          
          output$tutorialSelectOutput <- renderUI(tutorial.select.empty)
          output$tutorialPageOutput <- renderUI(tutorial.page.data)
        }
        #remove all highlights and update ui
        else if(input$tutorial.page=="Done")
        {
          #remove all tutorial css classes to remove all highlights
          removeCssClass(id='tab-data',class="tutorial-highlight");
          removeCssClass(id='tab-about',class="tutorial-highlight");
          removeCssClass(selector=".accordionheader",class="tutorial-highlight");
          removeCssClass(selector=".shinyhelper-icon",class="tutorial-highlight");
          removeCssClass(id='searchDiv',class="tutorial-highlight");
          removeCssClass(id="navSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasSelectDiv", class="tutorial-highlight");
          removeCssClass(id="gwasLociTable", class="tutorial-highlight");
          removeCssClass(selector=".sidebar-toggle", class="tutorial-highlight");
          removeCssClass(selector=".logo", class="tutorial-highlight");
          removeCssClass(selector=".geneselect", class="tutorial-highlight");
          removeCssClass(selector='.slider',class="tutorial-highlight");
          removeCssClass(id='evidenceColButtons',class="tutorial-highlight");
          removeCssClass(selector='.qtlcutoff',class="tutorial-highlight");
          
          #remove the selected class from the selected element to remove it's special highlight
          removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
          
          output$tutorialSelectOutput <- renderUI(tutorial.select.empty)
          output$tutorialPageOutput <- renderUI(tutorial.page.done)
        }
      }
    }
  )
  observeEvent(input$tutorial.next.link,{
    
    if(input$tutorial.page=="Start")
    {
      runjs('setTutorialPage("Header")')  
    }
    else if(input$tutorial.page=="Header")
    {
      runjs('setTutorialPage("Sidebar")')  
    }
    else if(input$tutorial.page=="Sidebar")
    {
      runjs('setTutorialPage("Data")')  
    }
    else if(input$tutorial.page=="Data")
    {
      runjs('setTutorialPage("Done")')  
    }
    else if(input$tutorial.page=="Done")
    {
      #close the tutorial
      updatePrettyToggle(session,"tutorial.activate",label=ifelse(input$tutorial.activate,"Turn off tutorial","Turn on tutorial"),value=F)
    }
    
  })
  
  
  renderTutorial <- function(pageOutput,selectOutput)
  {
    renderUI(tagList(
      uiOutput("tutorialPageOutput"),
      hr(),
      uiOutput("tutorialSelectOutput"),
      actionLink("tutorial.next.link",label = h3("Next"))
    ))
  }
  tutorial.page.start <-   tagList(
    h1('Welcome to the IPDGC GWAS Locus Browser!'),
    p("You have turned on the tutorial mode.", tags$strong("As you use the tutorial, you may mouse over the inputs highlighted in green to learn more about them."), "You may click the tutorial button (\"?\") to turn off tutorial mode."),
    
    conditionalPanel(
      condition = 'input["tabSetID"] == "Data"',
      p("Click \"Next\" to move to the next part of the tutorial.")
    ),
    conditionalPanel(
      condition = 'input["tabSetID"] == "About"',
      h3("About Page"),
      p("The browser starts on the about page which gives information about the browser and its datasets."),
      p("Click \"Next\" to move to the next part of the tutorial.")
    )
  )
  
  tutorial.page.header <-   tagList(
    h1('Header'),
    p("The header contains inputs used to navigate the browser."),
    p(tags$strong("Mouse over the elements highlighted in green to learn about their function")),
    p("Click \"Next\" to move to the next part of the tutorial.")
  )
  
  tutorial.page.sidebar <-   tagList(
    h1('Sidebar'),
    p("The sidebar contains inputs used to change the data displayed in the browser."),
    p(tags$strong("Mouse over the elements highlighted in green to learn about their function")),
    p("Click \"Next\" to move to the next part of the tutorial.")
  )
  
  tutorial.page.data <-   tagList(
    h1('Data Page'),
    p("Click the data tab, click the IPDGC logo, click a row in the sidebar's GWAS loci table or search by a gene to go to the data page."),
    p("The data page lists data for the selected locus or risk variant in the sidebar's GWAS loci table."),
    p(tags$strong("Mouse over the elements highlighted in green to learn about their function")),
    p("Click \"Next\" to move to the next part of the tutorial.")
  )
  
  tutorial.page.done <-   tagList(
    h1('Tutorial Finished'),
    p("That's it! Thank you for using the tutorial."),
    p("Click \"Next\" to close the tutorial.")
  )
  
  
  tutorial.select.empty <- 
    tagList(
      p("")
    )
  
  
  tutorial.select.about <-   tagList(
    h2('About Tab'),
    p("This tab brings the user to the about page which breifly explains the purpose of this browser, lists ups and downs for the datasets included, and lists the datasources and authors.")
  )
  tutorial.select.data <-   tagList(
    h2('Data Tab'),
    p("This tab brings the user to the main page of the browser that displays data for the selected locus in the sidebar.")
  )
  tutorial.select.navigate <-   tagList(
    h2('Jump to Section Dropdown'),
    p("When on the data page, select a section in this dropdown to scroll to that section in the browser.")
  )
  tutorial.select.logo <-   tagList(
    h2('Logo'),
    p("Clicking this brings the user to the data page and selects the first GWAS and locus in the sidebar.")
  )
  tutorial.select.sidebartoggle <-   tagList(
    h2('Sidebar Toggle'),
    p("This button will hide or show the sidebar to make it easier to view other data.")
  )
  
  tutorial.select.search <-  tagList(
    h2('Search Bar'),
    p("Users may search by locus, rsid, chromosome, chr:bp, or gene"),
    h3("Searching:"),
    p("Locus Number: enter ",tags$code("locus[number]")," to filter the sidebar locus table by locus number."),
    p("RSID: enter ", tags$code("[rsid]"), " to filter the sidebar locus table by rsid."),
    p("Chromosome: enter ", tags$code("chr[number]")," to filter the sidebar locus table by chromosome."),
    p("Chr:BP: enter ", tags$code("[chromosome number]:[base pair position]"), " to filter the sidebar locus table by chr:bp."),
    p("Gene: enter ", tags$code("[gene]"), " to filter the side bar locus table by loci with the searched gene and filter all data by the searched gene. This is case insensitive.")
  )
  tutorial.select.gwasselect <-  tagList(
    h2('GWAS Dropdown'),
    p("Users may choose a GWAS using this dropdown."),
    p("The GWAS locus table shows risk variants and loci from the selected GWAS in this dropdown."),
  )
  tutorial.select.gwastable <-  tagList(
    h2('GWAS Locus Table'),
    p("Users may click a row in this table to show data for the clicked locus in the data page. "),
  )
  
  
  tutorial.select.accordion <-   tagList(
    h2('Section Header'),
    p("Users may click section headers to collapse or expand the contents of that section. "),
    p("Click the help button to learn more about the contents of this section.")
  )
  
  
  tutorial.select.help <-   tagList(
    h2('Help Button'),
    p("Click this button to learn more about the contents of this section.")
  )
  tutorial.select.geneselect <-   tagList(
    h2('Gene Select Dropdown'),
    p("Select a gene in this dropdown to filter data in this section by a gene."),
    p("Sections with tables have an \"All Genes\" option to show data for all genes on the selected locus with data.")
  )
  tutorial.select.evidenceslider <-   tagList(
    h2('Evidence Per Gene Weights'),
    p("Change these sliders to modify the weight value for the slider's column in the evidence per gene table."),
    p("This will update both the slider's column and the conclusion score column.")
  )
  tutorial.select.evidencebutton <-   tagList(
    h2('Hide/Show Evidence Column Buttons'),
    p("Click this button hide or show the button's column in the evidence per gene table."),
    p("Hidden columns are omitted from the conclusion score column calculation.")
  )
  tutorial.select.qtlcutoff <-   tagList(
    h2('QTL Cutoff'),
    p("The value in this input is the significance cutoff for the Pearson's correlation coefficient in the locus compare plots."),
    p("The locus compare plot data table will bold correlations greater than the value in this input."),
    p("Changing this input will rescore the QTL-Correl columns in the locus compare plot data table and evidence per gene table.")
  )
  
}



removeTutorialDataHighlights <- function(input)
{
  if(input$tutorial.activate && input$tutorial.page=="Data")
  {
    removeCssClass(id='tab-data',class="tutorial-highlight");
    removeCssClass(id='searchDiv',class="tutorial-highlight");
    removeCssClass(id="gwasLociTable", class="tutorial-highlight");
    removeCssClass(selector=".logo", class="tutorial-highlight");
    removeCssClass(selector='.tutorial-selected',class='tutorial-selected')
  }
}