
#render the sidebar tables
renderLociTable <- function(df)
{

  renderDT({
    df <- df %>% select("LOC_NUM", "RSID", "CHR", "BP", "NEAR_GENE")
    #rename the RSID_Link to RSID
    colnames(df) <- c("Locus Number", "Risk Variant", "Chr", "BP", "Nearest Gene")
    

    df$helper <- FALSE
    if(reactives$selRow$RSID %in% df$'Risk Variant')
    {
      df$helper <- ifelse( df$'Risk Variant'==reactives$selRow$RSID,TRUE,FALSE)
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

updateSelectInput(session, inputId = "navSelect", label = "Jump to Section:", choices = section_ids)

observeEvent(input$gwasSelect,
             {
               gwas_id_string <<-  gsub(" GWAS","",input$gwasSelect)

               #create the link to the paper 
               link <- a(paste0(gwas_info[gwas_info$ID==gwas_id_string,]$SHORT_REF," ",gwas_id_string), href = gwas_info[gwas_info$ID==gwas_id_string,]$LINK, target = "_blank")
               output$gwasOutput <- renderUI(HTML(paste0("<h4>", link," GWAS Loci:</h4>")))
               
               #subset the loci data by the selected gwas
               gwas_specific_loci <- gwas_risk_variants[which(gwas_risk_variants$GWAS == gwas_id_string)]

               output$gwasLociTable <- renderLociTable(gwas_specific_loci)
               

             })

observeEvent(input$navSelect,
             {
               runjs(paste0("jumpToSection('",nav_df[which(nav_df$s == input$navSelect),]$id,"')"))
             })


 
#search when submit button clicked
observeEvent( input$searchInputBar_search,
             {
               searchClicked <<- T
               
               
               if(is.null(reactives$searchedGene))
               {
                 shinyjs::hide(id = "geneSearchOutput")
               }
               else
               {
                 searchedGene<- reactives$searchedGene
                 shinyjs::show(id = "geneSearchOutput")


                 
               }
               

               
               #find the new snp data
               reactives$selRow <- getSelectedRow()
               searchTable(searchString = input$searchInputBar)


               
               #jump to data tab
               updateTabsetPanel(session, "tabSetID", selected = "Data")
               removeTutorialDataHighlights()
               #update the detail panel
               renderDetailPanel()
               

               geneList<- getQTLDropDownGenes()
               

               #if a gene has been searched only show plots for that gene
               if(searchClicked && !is.null(isolate(reactives$searchedGene)) && isolate(reactives$searchedGene) %in% geneList)
               {
                 updateSelectInput(session, "qtlSelect", choices = geneList, selected=isolate(reactives$searchedGene))
               }
               #if there are no genes on the locus with plots then show NA as default
               else
               {

                 updateSelectInput(session, "qtlSelect", choices = geneList, selected=geneList[1])
               }

               #get gene list for the section dropdowns
               dropDownGenes <- (evidence[(evidence$LOC_NUM == isolate(reactives$selRow$'LOC_NUM') & (evidence$GWAS == gwas_id_string)),]$GENE)

               #don't include an "All Genes" option for the GTEX dropdown
               updateSelectInput(session, "litGeneSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               #add "All Genes" to the list for the other drop downs
               dropDownGenes <- append(dropDownGenes, "All Genes", 0)
               updateSelectInput(session, "evidenceSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               updateSelectInput(session, "burdenSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               updateSelectInput(session, "expressionSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               updateSelectInput(session, "constraintSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               updateSelectInput(session, "diseaseSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               

            })

#make proxy for the table to allow for row deselection
gwaslocitable_proxy = dataTableProxy('gwasLociTable')


#when a variant hyperlink is clicked
observeEvent({input$varClick
  #input$gwasLociTable_rows_selected
  }, 
             {
               searchClicked <<- F
               
               #find the new snp data
               reactives$selRow <- getSelectedRow()
               
               updateTabsetPanel(session, "tabSetID", selected = "Data")
               removeTutorialDataHighlights()
               #deselect all the rows
               gwaslocitable_proxy %>% selectRows(NULL)

               #update the detail panel now that a new snp has been selected
               renderDetailPanel()
               
               shinyjs::hide(id = "geneSearchOutput")
               

               
               updateSelectInput(session, "qtlSelect", choices = getQTLDropDownGenes())
               

               #get gene list for the section dropdowns
               dropDownGenes <- (evidence[evidence$LOC_NUM == isolate(reactives$selRow$'LOC_NUM') & evidence$GWAS == gwas_id_string,]$GENE)
               
               #don't include an "All Genes" option for the GTEX dropdown
               updateSelectInput(session, "litGeneSelect", choices = dropDownGenes)
               #add "All Genes" to the list for the other drop downs
               dropDownGenes <- append(dropDownGenes, "All Genes", 0)
               updateSelectInput(session, "evidenceSelect", choices = dropDownGenes)
               updateSelectInput(session, "burdenSelect", choices = dropDownGenes)
               updateSelectInput(session, "expressionSelect", choices = dropDownGenes)
               updateSelectInput(session, "constraintSelect", choices = dropDownGenes)
               updateSelectInput(session, "diseaseSelect", choices = dropDownGenes)
             })


#when logo is clicked go to the data tab and reset to first locus
observeEvent(input$wrapperLogo, 
             {
               searchClicked <<- F
               updateTextInput(session, inputId = "searchInputBar",value = "")
               runjs("Shiny.setInputValue('clickedID', 'rs114138760')")
               runjs("Shiny.setInputValue('varClick', Math.random())")
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
    gene = gwas_risk_variants[(gwas_risk_variants$'LOC_NUM' %in% getLocusByGene(searchString) & (gwas_risk_variants$GWAS==gwas_id_string))]
  )

  
  #if there is nothing in the searchBox then remove filter and show the whole table
  if(searchString == "")
  {
    searchResults = gwas_risk_variants
  }
  output$gwasLociTable <-  renderLociTable(searchResults)
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

searchStringIsGene <- function(searchString)
{
  if(searchString == "")#for nothing entered
  {
    FALSE
  }
  if(grepl("^\\d+:\\d*$", searchString, ignore.case = T))#for the 1:123456 format (chr:bp) 
  {
    FALSE
  }
  else if (grepl("^locus\\w+", searchString, ignore.case = T))#for the 1 format (locus number)
  {
    FALSE
  }
  else if (grepl("^rs\\d*", searchString, ignore.case = T))#for the rs1234567 format
  {
    FALSE
  }
  else if (grepl("^chr\\d+$", searchString, ignore.case = T))#for the chr1 format
  {
    FALSE
  }
  else if(grepl("^\\w+", searchString, ignore.case = T))#for a gene name
  {
    TRUE
  }
  else
  {
    FALSE
  }
}