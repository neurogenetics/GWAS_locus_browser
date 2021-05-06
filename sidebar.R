sideBarLoadData <- function(){
  #Load basic gwas data for sidebar
  gwas_risk_variants <<- fread("www/summarystats/gwas_risk_variants.csv")
  
  
  #gwas_id_string <- "META5"
  
  gwas_info <<- fread("www/summarystats/gwasInfo.csv")
  
  #build the gwas_list that will hold names and values for the "Choose a GWAS" drop down
  gwases <<- split(paste0(gwas_info$ID," GWAS"), seq(nrow(gwas_info)))
  gwases <<- setNames(split(gwas_info$ID, seq(nrow(gwas_info))),paste0(gwas_info$SHORT_REF," ", gwas_info$ID, " GWAS"))
  
  #load 90 meta5 loci
  meta5_gwas_data <<- fread("www/summarystats/META5Loci.csv")
  meta5_gwas_data$GWAS <<- "META5"
  
  
  #load the 2 progression loci
  prog_gwas_data <<- fread("www/summarystats/ProgressionLoci.csv")
  prog_gwas_data$GWAS <<- "Progression"
  
  #load the 2 asian gwas loci
  asian_gwas_data <<- fread("www/summarystats/AsianLoci.csv")
  asian_gwas_data$GWAS <<- "Asian"
  
  #variable that holds the current selected gwas data
  gwas_data <<- rbind(meta5_gwas_data,prog_gwas_data,asian_gwas_data,fill=TRUE)
}

sideBarUI <- tagList(
  boxPlus(
    width = 12,
    status="orange",
    #searchbar
    fluidRow(
      column(div(searchInput("searchInputBar", placeholder = "locus1, rs114138760, chr1, 1:154898185, PMVK, etc",btnSearch = icon("search"),width = "425px"),id="searchDiv"), width = 12)
    ),
    hr(),
    fluidRow(
      column(div(uiOutput("gwasSelectUI"),id="gwasSelectDiv"),width = 12)
    ),
    
    fluidRow(
      column(div(htmlOutput("gwasOutput")), width = 12)
    ),
    fluidRow(
      column(div(dataTableOutput("gwasLociTable"), style = "font-size:80%"), width = 12)
    )
  )
)



sideBarLogic <- function(session,input,output,reactives){
  
  #populate the dropdown using the reactive value
  output$gwasSelectUI <- renderUI({
    selected <- gwases[which(gwases %in% reactives$selRiskVariant()$GWAS)]
    selectInput("gwasSelect",label = "Choose a GWAS", choices = gwases,selected = selected)
  })
  
  #when logo is clicked go to the data tab and reset to first locus
  observeEvent(input$wrapperLogo, 
               {
                 updateTextInput(session, inputId = "searchInputBar",value = "")
                 runjs("Shiny.setInputValue('clickedID', 'rs114138760')")
                 runjs("Shiny.setInputValue('varClick', Math.random())")
               })
  
  #when a variant hyperlink is clicked
  observeEvent({input$varClick
  }, 
  {
    reactives$searchInputValue("")
    reactives$selRiskVariant(gwas_data[gwas_data$RSID == input$clickedID,])
    reactives$searchedGene("")
    updateTabsetPanel(session, "tabSetID", selected = "Data")
    removeTutorialDataHighlights(input)
  })
  
  #when a new gwas is selected
  observeEvent({input$gwasSelect},
               {
                 reactives$searchInputValue("")
               })
  
  
  
  #search when submit button clicked
  observeEvent( input$searchInputBar_search,
                {
                  
                  if(input$searchInputBar!="")
                  {
                    reactives$searchInputValue(input$searchInputBar)
                  }
                  #if nothing entered in the search bar and we try to search then reset the searchInputValue to trigger the sidebar table to reset
                  else
                  {
                    reactives$searchInputValue("")
                  }

                })
  
  renderLociTable <- function()
  {
    renderDT({
      gwas_id_string <-  gsub(" GWAS","",input$gwasSelect)
      
      #create the link to the paper 
      link <- a(paste0(gwas_info[gwas_info$ID==gwas_id_string,]$SHORT_REF," ",gwas_id_string), href = gwas_info[gwas_info$ID==gwas_id_string,]$LINK, target = "_blank")
      output$gwasOutput <- renderUI(HTML(paste0("<h4>", link," GWAS Loci:</h4>")))
      
      #if searched something, then try searching
      if(reactives$searchInputValue() !="")
      {
        df <- searchTable(reactives$searchInputValue())
      }
      #else just list loci by the selected gwas
      else
      {
        #subset the loci data by the selected gwas
        gwas_specific_loci <- gwas_risk_variants[which(gwas_risk_variants$GWAS == gwas_id_string)]
        
        df <- gwas_specific_loci
      }
      

      
      
      df <- df %>% select("LOC_NUM", "RSID", "CHR", "BP", "NEAR_GENE")
      #rename the RSID_Link to RSID
      colnames(df) <- c("Locus Number", "Risk Variant", "Chr", "BP", "Nearest Gene")
      
      
      df$helper <- FALSE
      if(reactives$selRiskVariant()$RSID %in% df$'Risk Variant')
      {
        df$helper <- ifelse( df$'Risk Variant'==reactives$selRiskVariant()$RSID,TRUE,FALSE)
      }
      datatable(df, selection=list(mode="single"), escape = F, rownames= F,
                callback = JS("table.on('click.dt','td', function() {
                              var row_=table.cell(this).index().row;
                              var rowData = table.rows( { selected: true } ).data()[row_]; 
                              Shiny.setInputValue('clickedID', rowData[1]);
                              Shiny.setInputValue('varClick', Math.random());
                          });"),
                options = list( order = list(5, 'desc'), searching = F, paginate = F, dom = 't', scrollCollapse = T, scrollY = "30vh",columnDefs=list(
                  list(
                    visible=FALSE,
                    targets=which(colnames(df)=='helper')-1   
                  )
                )))%>% formatStyle('helper', target='row',
                                   backgroundColor = styleEqual(TRUE, '#337ab7'),
                                   color = styleEqual(TRUE, '#fff')) 
      
    })
    
    
  }
  
  
  output$gwasLociTable <- renderLociTable()
  
  
  #render the GWAS output string in the sidebar. Updates when the dropdown changes
  output$gwasOutput <- renderUI({
    gwas_id_string <-  gsub(" GWAS","",input$gwasSelect)
    link <- a(paste0(gwas_info[gwas_info$ID==gwas_id_string,]$SHORT_REF," ",gwas_id_string), href = gwas_info[gwas_info$ID==gwas_id_string,]$LINK, target = "_blank")
    HTML(paste0("<h4>", link," GWAS Loci:</h4>"))
    })
  
  #search the table based on the searchString
  searchTable <- function(searchString)
  {
    if(grepl("^\\d+:\\d*$", searchString, ignore.case = T))
    {
      searchSwitch <- "chrbp"
    }
    else if (grepl("^locus\\w+", searchString, ignore.case = T))
    {
      searchSwitch <- "locus"
    }
    else if (grepl("^rs\\d*", searchString, ignore.case = T))
    {
      searchSwitch <- "rsID"
    }
    else if (grepl("^chr\\d+$", searchString, ignore.case = T))
    {
      searchSwitch <- "chr"
    }
    else
    {
      searchSwitch <- "gene"
    }
    searchResults <- switch(
      searchSwitch,
      #search for the locus number
      locus = gwas_risk_variants[grepl(gsub("^locus(\\w+)", "\\1", searchString, ignore.case = T), gwas_risk_variants$`LOC_NUM`, ignore.case = T)],
      #search for the rsID searchString
      rsID = gwas_risk_variants[grepl(searchString, gwas_risk_variants$RSID, ignore.case = T)],
      #search for the chr searchString
      chr = gwas_risk_variants[grepl(gsub("^chr(\\d+)", "\\1", searchString, ignore.case = T), gwas_risk_variants$CHR, ignore.case = T)],
      #search for the chr:bp searchString
      chrbp = subset(gwas_risk_variants, 
                     #search by bp
                     grepl(gsub("^\\d+:(\\d+)$", "\\1", searchString, ignore.case = T), gsub(",","",gwas_risk_variants$BP), ignore.case = T) & 
                       #and search by chr
                       grepl(gsub("^(\\d+):.*$", "\\1", searchString, ignore.case = T), gwas_risk_variants$CHR, ignore.case = T)),
      #search for the gene name searchString in all of the genes
      gene = {
        #get the matching rsid of the locus the gene is in. get the first rsid if there are multiple
        geneRSID <- evidence[ toupper(evidence$GENE) %in% toupper(searchString) , ]$RSID[1]
        #change the searchedGene reactive value
        reactives$searchedGene(toupper(searchString))
        
        temp_selRiskVar <- gwas_data[gwas_data$RSID == geneRSID,]
        
        #if the gene is actually in our list then set the reactive riskVariant variable to select a new row in the sidebar table
        if(toupper(searchString) %in%  toupper(evidence$GENE))
        {
          reactives$selRiskVariant(temp_selRiskVar)
        }
        
        #the return the rows to populate the sidebar table
        loci_with_gene <- evidence[toupper(evidence$GENE) %in% toupper(searchString)]$LOC_NUM
        gwas_id_string <-  temp_selRiskVar$GWAS
        retval <- gwas_risk_variants[(gwas_risk_variants$'LOC_NUM' %in% loci_with_gene & (gwas_risk_variants$GWAS==gwas_id_string))]
        retval
      }
      
      
      
    )
    
    searchResults
  }
  
  getLocusByGene <- function(geneName)
  {
    retval <- NULL
    #try with geneName as is and with forced uppercase
    if(input$searchInputBar %in% evidence$GENE)
    {
      retval <- evidence[evidence$GENE %in% input$searchInputBar]$LOC_NUM
    }
    
    if(toupper(input$searchInputBar) %in% evidence$GENE)
    {
      retval <- evidence[evidence$GENE %in% toupper(input$searchInputBar)]$LOC_NUM
    }
    retval
  }
  
}

