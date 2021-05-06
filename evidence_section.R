evidence_section<-list()
evidence_section$id <- "evidence"
evidence_section$title <- "Evidence Per Gene"

evidence_section$loadData<- function(){
  
  ######create a dataframe to hold the conclusion values. This will need to contain extra info for genes on loci with multiple risk snps (like locus 1) which is why we merge with the rsids

  evidenceDF <- fread("www/evidence/evidence_per_gene.csv")
  names(evidenceDF)[names(evidenceDF) == 'Variant_Intolerant'] <- 'Variant Intolerant'
  evidenceQTL <- fread("www/evidence/evidence_qtl.csv")
  
  #get all the risk variants
  variant_data <- gwas_risk_variants %>% select("LOC_NUM","RSID", "GWAS")
  
  
  
  #merge the original evidence df with the risk variants
  evidence_with_rsid <- merge(x=evidenceDF, y = variant_data, by.x=c("LOC_NUM","GWAS"), by.y = c("LOC_NUM","GWAS"), all.x = TRUE, allow.cartesian = TRUE)
  
  #merge the evidence df containing rsids with the qtl evidence scores, which can change depending on the risk variant we wan for the gene
  evidence_full <- merge(x=evidence_with_rsid, y=evidenceQTL, by.x = c("GENE","LOC_NUM","RSID","GWAS"), by.y = c("GENE","LOC_NUM","RSID","GWAS"), all.x = TRUE, allow.cartesian = TRUE)
  
  #add conclusion column and default to 0
  evidence_full$Conclusion <- 0
  
  setcolorder(evidence_full, c("GENE", "LOC_NUM", "RSID", "Conclusion", "Nominated by META5", "QTL-brain", "QTL-blood", "QTL-correl","Burden", "Brain Expression", "Nigra Expression", "SN-Dop. Neuron Expression", "Literature Search", "Variant Intolerant", "PD Gene", "Disease Gene"))
  
  evidence <<- evidence_full
  
  
}

evidence_section$generateUI <- function() { 
    div(
    fluidRow(
      column(div(uiOutput(('evidenceSelectUI')),class="geneselect"),width =2)
    ),

    fluidRow(
      column(
        
        
        h4("Weights:"),
        div(
          span(sliderInput("META5Slider", label = "Nominated by META5", min = 0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
          span(sliderInput("qtlBrainSlider",label = "QTL-Brain",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"), 
          span(sliderInput("qtlBloodSlider",label = "QTL-Blood",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
          span(sliderInput("qtlCorrelSlider",label = "QTL-Correl",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
          span(sliderInput("burdenSlider",label = "Burden",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("brainExpSlider",label = "Brain Expression",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("nigraExpSlider",label = "Nigra Expression",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("SNDaExpSlider",label = "SN-Dop. Neuron Expression",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("litSearchSlider",label = "Literature Search",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("constraintSlider",label = "Variant Intolerant",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("pdGeneSlider",label = "PD Gene",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
          span(sliderInput("diseaseGeneSlider",label = "Disease Gene",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
          class="slider"
        ),
        
        br(),
        
        
        width = 12
      ),
      column(
        h4("Hide/Show Columns:"),
        checkboxGroupButtons(
          inputId = "evidenceColButtons",
          choices = c("Nominated by META5","QTL-brain","QTL-blood","QTL-correl","Burden","Brain Expression","Nigra Expression","SN-Dop. Neuron Expression","Literature Search","Variant Intolerant","PD Gene","Disease Gene"),
          justified = TRUE,
          individual = TRUE,
          width = '100%'
        ),
        width = 12
      ),
      
      column(
        dataTableOutput("evidenceTable"),
        
        width = 12
      )
)
)
}

evidence_section$serverLogic <- function(input,output,session,reactives)
{
  
  #populate the dropdown using the reactive value
  output$evidenceSelectUI <- renderUI({
    dropDownGenes <- (evidence[(evidence$RSID == reactives$selRiskVariant()$RSID & (evidence$GWAS == reactives$selRiskVariant()$GWAS)),]$GENE)

    #add "All Genes" to the list for the other drop downs
    dropDownGenes <- append(dropDownGenes, "All Genes", 0)
    
    #default selected to the first in the list
    selected_gene <- dropDownGenes[1]
    #if there was a searched gene, select that
    if(reactives$searchedGene()!="")
    {
      selected_gene <-dropDownGenes[match(toupper(reactives$searchedGene()), toupper(as.vector(dropDownGenes)))] 
    }

    selectInput("evidenceSelect",label = "Choose a gene", choices = dropDownGenes, selected = selected_gene)
  })


  #render the evidence table
  output$evidenceTable <- renderDT({
    scrollYVal <- 0

    
    base_evidence <- evidence[,!c("QTL-brain","QTL-blood","QTL-correl")]#[,!c("QTL-brain","QTL-blood","QTL-correl","PD Gene","Nominated by META5")]
    base_evidence <- base_evidence[base_evidence$RSID==reactives$selRiskVariant()$RSID,]
    
    qtl_evidence <- qtl_section$getQTLEvidence(input,output,session,reactives)
    
    base_evidence <- merge(base_evidence,qtl_evidence,all.x=TRUE, by=c("GENE","LOC_NUM","RSID"))

    weightEvidence<- base_evidence
    
    weightEvidence$'Nominated by META5' <- (as.numeric(base_evidence$'Nominated by META5') * input$META5Slider)
    weightEvidence$'QTL-brain' <- (as.numeric(base_evidence$'QTL-brain') * input$qtlBrainSlider)
    weightEvidence$'QTL-blood' <- (as.numeric(base_evidence$'QTL-blood') * input$qtlBloodSlider)
    weightEvidence$'QTL-correl' <- (as.numeric(base_evidence$'QTL-correl') * input$qtlCorrelSlider)
    weightEvidence$'Burden' <- (as.numeric(base_evidence$'Burden') * input$burdenSlider)
    weightEvidence$'Brain Expression' <- (as.numeric(base_evidence$'Brain Expression') * input$brainExpSlider)
    weightEvidence$'Nigra Expression' <- (as.numeric(base_evidence$'Nigra Expression') * input$nigraExpSlider)
    weightEvidence$'SN-Dop. Neuron Expression' <- (as.numeric(base_evidence$'SN-Dop. Neuron Expression') * input$SNDaExpSlider)
    weightEvidence$'Literature Search' <- (as.numeric(base_evidence$'Literature Search') * input$litSearchSlider)
    weightEvidence$'Variant Intolerant' <- (as.numeric(base_evidence$'Variant Intolerant') * input$constraintSlider)
    weightEvidence$'PD Gene' <- (as.numeric(base_evidence$'PD Gene') * input$pdGeneSlider)
    weightEvidence$'Disease Gene' <- (as.numeric(base_evidence$'Disease Gene') * input$diseaseGeneSlider)
    setcolorder(weightEvidence,c("GWAS","GENE","LOC_NUM","RSID","Conclusion","Nominated by META5",'QTL-brain','QTL-blood','QTL-correl','Burden','Brain Expression','Nigra Expression','SN-Dop. Neuron Expression','Literature Search','Variant Intolerant','PD Gene','Disease Gene'))
    #find which columns we want to keep based on which column buttons have been clicked
    columns <- names(weightEvidence)[!names(weightEvidence) %in% input$evidenceColButtons]
    #subset the columns we want 
    weightEvidence <- subset(weightEvidence,select=columns)
    
    #calculate the conclusion value
    if(ncol(weightEvidence[,!c("GWAS","GENE", "LOC_NUM", "Conclusion", "RSID")]) != 0)
    {
      weightEvidence$Conclusion <- rowSums(weightEvidence[,!c("GWAS","GENE", "LOC_NUM", "RSID", "Conclusion")], na.rm = T)
    }
    else
    {
      weightEvidence$Conclusion <- 0
    }
    
    
    
    temp <- weightEvidence
    
    
    
    evdata <- NULL
    #by default assume 'All Genes' option is selected
    if(is.null(input$evidenceSelect))
    {
      evdata <- temp[which(temp$LOC_NUM == (reactives$selRiskVariant()$LOC_NUM) & temp$RSID == (reactives$selRiskVariant()$RSID)),] 
      scrollYVal <- 300
    }

    else
    {
      if (input$evidenceSelect=="All Genes")
      {
        evdata <- temp[which(temp$LOC_NUM == (reactives$selRiskVariant()$LOC_NUM) & temp$RSID == (reactives$selRiskVariant()$RSID)),] 
        scrollYVal <- 300
      }
      #by gene selected in drop down
      else
      {
        evdata <- temp[which(temp$GENE == input$evidenceSelect & temp$RSID == reactives$selRiskVariant()$RSID),]
        
        #if searched for a gene that shows up in multiple loci (like ACBD4) then only get the first row (both rows should be identical, will only have different locus numbers)
        if(nrow(evdata)!=1)
        {
          evdata <- evdata[1,]
        }
        scrollYVal <- 50
      }
    }

    
    #remove 'Locusnumber' column from table
    evdata <- evdata[,!c("LOC_NUM", "RSID","GWAS")]
    
    #only reorder if at least one column is not hidden (prevents error in table when all columns hidden)
    if(ncol(evdata)>3)
    {
      #reorder columns to place the 'Conclusion' column second
      setcolorder(evdata, c("GENE", "Conclusion", names(evdata)[3:(length(evdata)-1)]))
    }
    colnames(evdata)[colnames(evdata) == 'GENE'] <- 'Gene'
    

    

    

    datatable(evdata, extensions = 'Buttons', rownames = F,
              callback=JS("
                             table.on('mouseenter','tbody td', function() {
                              var column = $(this).index();
                              var row = $(this).parent().index();
                              this.setAttribute('title','Hello!');
                             });
                             return table;
                             "),
              options = list(order = list(1, 'desc'), searching = F, paginate = F, 
                             dom = 't', scrollY = paste0(scrollYVal,"px"), scrollX = T, columnDefs = list(list(
                               className = 'dt-right', 
                               targets = c(1:ncol(evdata)-1),
                               render = JS(
                                 "function(data, type, row, meta) {",
                                 "return (data==null) ? 'NA' : data;",
                                 "}"
                               )))))
    
    
    
    
  },server=FALSE)
}