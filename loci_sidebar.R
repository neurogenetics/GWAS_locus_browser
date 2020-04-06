


#render the sidebar tables
renderLociTable <- function(df)
{
  renderDT({datatable(df, escape = F, rownames= F, options = list(order = list(0, 'asc'), searching = F, paginate = F, dom = 't', scrollCollapse = T, scrollY = "20vh")) %>% 
      formatStyle(columns=colnames(df)
      )})
  
}

updateSelectInput(session, inputId = "navSelect", label = "Jump to Section:", choices = section_ids)

observeEvent(input$navSelect,
             {
               runjs(paste0("jumpToSection('",nav_df[which(nav_df$s == input$navSelect),]$id,"')"))
             })
# renderNavTable <- function()
# {
#   sections <- c("Interactive Locus Zoom", "Static Locus Zoom", "Summary Statistics", "Best Candidate", "Evidence Per Gene", "QTL Evidence", "Coding Variants", "Associated Variant Phenotypes", "Burden Evidence", "Expression Data", "Gene Single Cell Expression Plot", "Gene Tissue Expression Plot", "Constraint Values", "Disease Genes", "Fine-Mapping of Locus", "Literature")
#   ids <- sprintf("#collapse%d",seq(1:length(sections)))
# 
#     
#     sectiondf <- data.frame(s = sections, id = ids)
#     
#     sectiondf <- sectiondf %>% mutate(s = paste0("<a id=\"", s, "\" href=\"javascript:;\" onclick=\"jumpToSection('",id,"')\">", s, "</a>"))  %>% mutate("Table of Contents" = s)%>% select("Table of Contents")
# 
# 
# 
#     renderDT({datatable(sectiondf, escape = F, rownames= F, options = list(ordering = F, searching = F, paginate = F, dom = 't', scrollCollapse = T, scrollY = "20vh")) %>% 
#         formatStyle(columns=colnames(sectiondf)
#         )})
# }


 
#search when submit button clicked
observeEvent( input$submitButton,
             {
               searchClicked <<- T
               
               #find the new snp data
               reactives$selRow <- getSelectedRow()
               
               searchTable(searchString = input$searchBar)

               if(is.null(reactives$searchedGene))
               {
                 shinyjs::hide(id = "geneSearchOutput")
               }
               else
               {
                 shinyjs::show(id = "geneSearchOutput")
               }
               
               #jump to data tab
               updateTabsetPanel(session, "tabSetID", selected = "Data")
               
               #update the detail panel
               renderDetailPanel()
               
               geneList <- evidence[which((evidence$Locusnumber == reactives$selRow$'Locus Number' & evidence$SNP == reactives$selRow$SNP) & (evidence$"QTL-blood"==1 | evidence$"QTL-brain"==1)),]
 
               geneList<- geneList$Gene
               updateSelectInput(session, "qtlSelect", choices = geneList)
               #if a gene has been searched only show plots for that gene
               if(searchClicked && !is.null(isolate(reactives$searchedGene)) && isolate(reactives$searchedGene) %in% geneList)
               {
                 updateSelectInput(session, "qtlSelect", choices = geneList, selected=isolate(reactives$searchedGene))
               }
               #if there are no genes on the locus with plots then show NA as default
               else
               {
                 geneList <- append(geneList,c("NA"))
                 updateSelectInput(session, "qtlSelect", choices = geneList, selected="NA")
               }
               
               #get gene list for the section dropdowns
               dropDownGenes <- (evidence[evidence$Locusnumber == isolate(reactives$selRow$'Locus Number'),]$Gene)
               #don't include an "All Genes" option for the GTEX dropdown
               updateSelectInput(session, "GTEXSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
               updateSelectInput(session, "SingleCellSelect", choices = dropDownGenes, selected=isolate(reactives$searchedGene))
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
meta5_proxy = dataTableProxy('META5Table')
prog_proxy = dataTableProxy('ProgTable')

#when a variant hyperlink is clicked
observeEvent(input$varClick, 
             {
               searchClicked <<- F
               
               #find the new snp data
               reactives$selRow <- getSelectedRow()
               
               updateTabsetPanel(session, "tabSetID", selected = "Data")
               
               #deselect all the rows
               meta5_proxy %>% selectRows(NULL)
               prog_proxy %>% selectRows(NULL)
               
               #update the detail panel now that a new snp has been selected
               renderDetailPanel()
               
               shinyjs::hide(id = "geneSearchOutput")
               
               
               geneList <- evidence[which((evidence$Locusnumber == reactives$selRow$'Locus Number' & evidence$SNP == reactives$selRow$SNP) & (evidence$"QTL-blood"==1 | evidence$"QTL-brain"==1)),]

               geneList<- geneList$Gene
               updateSelectInput(session, "qtlSelect", choices = geneList)
               #if there are no genes on the locus with plots then show NA as default
               if(length(geneList)==0)
               {
                 geneList <- c("NA")
               }
               
               updateSelectInput(session, "qtlSelect", choices = geneList)
               
               
               #get gene list for the section dropdowns
               dropDownGenes <- (evidence[evidence$Locusnumber == isolate(reactives$selRow$'Locus Number'),]$Gene)
               #don't include an "All Genes" option for the GTEX dropdown
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
             })


#when logo is clicked go to the data tab and reset to first locus
observeEvent(input$wrapperLogo, 
             {
               searchClicked <<- F
               updateTextInput(session, inputId = "searchBar",value = "")
               
               reactives$selRow <- meta5_gwas_data[which(meta5_gwas_data$'Nearest Gene' == "PMVK")]
               
               searchTable(searchString = "")
               
               updateTabsetPanel(session, "tabSetID", selected = "Data")
               
               renderDetailPanel()
               
               shinyjs::hide(id = "geneSearchOutput")
               
               geneList <- evidence[which((evidence$Locusnumber == reactives$selRow$'Locus Number' & evidence$SNP == reactives$selRow$SNP) & (evidence$"QTL-blood"==1 | evidence$"QTL-brain"==1)),]

               geneList<- geneList$Gene
               updateSelectInput(session, "qtlSelect", choices = geneList)
               
               #get gene list for the section dropdowns
               dropDownGenes <- (evidence[evidence$Locusnumber == isolate(reactives$selRow$'Locus Number'),]$Gene)
               #don't include an "All Genes" option for the GTEX dropdown
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
  meta5_searchResults <- switch(
    searchSwitch,
    #search for the locus number
    locus = meta5_loci[grepl(gsub("^locus(\\w+)", "\\1", searchString, ignore.case = T), meta5_loci$`Locus Number`, ignore.case = T)],
    #search for the rsID searchString
    rsID = meta5_loci[grepl(searchString, meta5_loci$SNP, ignore.case = T)],
    #search for the chr searchString
    chr = meta5_loci[grepl(gsub("^chr(\\d+)", "\\1", searchString, ignore.case = T), meta5_loci$CHR, ignore.case = T)],
    #search for the chr:bp searchString
    chrbp = subset(meta5_loci, 
                   #search by bp
                   grepl(gsub("^\\d+:(\\d+)$", "\\1", searchString, ignore.case = T), gsub(",","",meta5_loci$BP), ignore.case = T) & 
                     #and search by chr
                     grepl(gsub("^(\\d+):.*$", "\\1", searchString, ignore.case = T), meta5_loci$CHR, ignore.case = T)),
    #search for the gene name searchString in all of the genes
    gene = meta5_loci[(meta5_loci$'Locus Number' %in% getLocusByGene(searchString))]
  )
  
  prog_searchResults <- switch(
    searchSwitch,
    #search for the locus number
    locus = prog_loci[grepl(gsub("^locus(\\w+)", "\\1", searchString, ignore.case = T), prog_loci$`Locus Number`, ignore.case = T)],
    #search for the rsID searchString
    rsID = prog_loci[grepl(searchString, prog_loci$SNP, ignore.case = T)],
    #search for the chr searchString
    chr = prog_loci[grepl(gsub("^chr(\\d+)", "\\1", searchString, ignore.case = T), prog_loci$CHR, ignore.case = T)],
    #search for the chr:bp searchString
    chrbp = subset(prog_loci, 
                   #search by bp
                   grepl(gsub("^\\d+:(\\d+)$", "\\1", searchString, ignore.case = T), gsub(",","",prog_loci$BP), ignore.case = T) & 
                     #and search by chr
                     grepl(gsub("^(\\d+):.*$", "\\1", searchString, ignore.case = T), prog_loci$CHR, ignore.case = T)),
    #search for the gene name searchString in all of the genes
    gene = prog_loci[prog_loci$'Locus Number' %in% getLocusByGene(searchString)]
  )
  
  #if there is nothing in the searchBox then remove filter and show the whole table
  if(searchString == "")
  {
    prog_searchResults = prog_loci
    meta5_searchResults = meta5_loci
  }
  output$META5Table <-  renderLociTable(meta5_searchResults)
  output$ProgTable <-  renderLociTable(prog_searchResults)
}

getLocusByGene <- function(geneName)
{
  retval <- NULL
  #try with geneName as is and with forced uppercase
  if(input$searchBar %in% evidence$Gene)
  {
    retval <- evidence[evidence$Gene %in% input$searchBar]$Locusnumber
  }
  
  if(toupper(input$searchBar) %in% evidence$Gene)
  {
    retval <- evidence[evidence$Gene %in% toupper(input$searchBar)]$Locusnumber
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