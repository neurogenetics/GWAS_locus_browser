codingVars<-list()
codingVars$id <- "codingvariant"
codingVars$title <- "Coding Variants"

codingVars$loadData<- function(){
  
  #read in coding variant data
  coding_ld <<- fread("www/codingvars/CodingVariantLD.csv")
  coding_variants <<- fread("www/codingvars/CodingVariants.csv")
  
  #read in coding variant data generated from LDLink
  coding_variants_ldlink <<- fread("www/codingvars/CodingVariantsLDLink.csv")
}

codingVars$generateUI<- function(){
  fluidRow(
    column(tabsetPanel(type="pills",
                       tabPanel("HRC Coding Variants", 
                                fluidRow(
                                  column(dataTableOutput("codingTable"), width = 12)
                                )
                       ),
                       tabPanel("LDLink Coding Variants", 
                                fluidRow(
                                  column(dataTableOutput("codingLDLinkTable"), width = 12)
                                )
                       ),
                       selected = "HRC Coding Variants"
    )
    ,width = 12)
  )
}



codingVars$serverLogic <- function(input,output,session,reactives)
{
  output$codingTable <- renderDT({
    
    #get coding variant data
    data <- coding_variants[coding_variants$locnum == (reactives$selRiskVariant()$LOC_NUM) & coding_variants$GWAS == reactives$selRiskVariant()$GWAS]
    
    #get LD data for the selected variant (some loci have multiple variants, so multiple LD values as well)
    ld <- coding_ld[coding_ld$'rsid1' == (reactives$selRiskVariant()$RSID)]
    
    coding_data <- merge(data, ld, all.x =T, by.x = 'ID', by.y = 'rsid2')
    coding_data <- coding_data %>% select("ID", "CHRBP_REFALT", "locnum","r2","dprime", "freq_nfe", "Gene.refGene", "AA Change", "cadd_phred" )
    
    #if the table's RSID is the same as the selected RSID then set r2 and dprime to 1 (instead of NA because it's in LD with itself in this case)
    coding_data[coding_data$ID==reactives$selRiskVariant()$RSID,]$r2 = 1.0
    coding_data[coding_data$ID==reactives$selRiskVariant()$RSID,]$dprime = 1.0
    
    coding_data$'AA Change' <- gsub(',','\n',coding_data$'AA Change')
    
    colnames(coding_data) <- c("SNP", "Chr:BP:Ref:Alt", "Locus Number", "LD (rsquared)", "LD (D')", "Frequency (Non-Finnish European)", "Gene", "AA Change","CADD (phred)")
    scrollYVal <- 300
    datatable(coding_data, rownames = F, option=list(processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal, "px"), scrollX = T, columnDefs = list(list(
      targets = c(3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(3);",
        "}"
      )))))
  })
  
  output$codingLDLinkTable <- renderDT({

    #get coding variant ldlink data
    data <- coding_variants_ldlink[coding_variants_ldlink$LOC_NUM == (reactives$selRiskVariant()$LOC_NUM) & coding_variants_ldlink$GWAS == reactives$selRiskVariant()$GWAS]
    
    data$'AAChange.refGene' <- gsub(',','\n',data$'AAChange.refGene')
    coding_data <- data %>% select("RS_Number", "chrbprefalt", "LOC_NUM","R2","Dprime", "MAF", "Gene.refGene", "AAChange.refGene", "cadd_phred" )
    colnames(coding_data) <- c("SNP", "Chr:BP:Ref:Alt", "Locus Number", "LD (rsquared)", "LD (D')", "Minor Allele Frequency", "Gene", "AA Change","CADD (phred)")
    scrollYVal <- 300
    datatable(coding_data, rownames = F, option=list(processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal, "px"), scrollX = T, columnDefs = list(list(
      targets = c(3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(3);",
        "}"
      )))))
  })
  
}