
phenoVars<-list()
phenoVars$id <- "phenovariant"
phenoVars$title <- "Associated Variant Phenotypes"

phenoVars$loadData<- function(){
  
  #read in phenotype variant data
  phenotype_ld <<- fread("www/phenovars/PhenotypeVariantLD.csv")
  phenotype_variants <<- fread("www/phenovars/PhenotypeVariantData.csv")
  phenotype_variants$`P-VALUE` <<- as.numeric(as.character(phenotype_variants$`P-VALUE`))
}

phenoVars$generateUI<- function(){
  fluidRow(
    column(dataTableOutput("phenotypeTable"), width = 12)
  )
}  

phenoVars$serverLogic <- function(input,output,session,reactives)
{
  output$phenotypeTable <- renderDT({
    #get phenotype variant data
    data <- phenotype_variants[phenotype_variants$locnum == (reactives$selRiskVariant()$LOC_NUM) & phenotype_variants$GWAS == reactives$selRiskVariant()$GWAS]
    
    #get LD data for the selected variant (some loci have multiple variants, so multiple LD values as well)
    ld <- phenotype_ld[phenotype_ld$'rsid1' == (reactives$selRiskVariant()$RSID)]
    
    pheno_data <- merge(data, ld, all.x = T, by.x = 'ID' , by.y = 'rsid2')
    pheno_data <- pheno_data %>% select("ID", "CHRBP_REFALT", "locnum", "r2", "dprime","freq_nfe", "other associated disease", "P-VALUE", "PMID")
    
    #if the table's RSID is the same as the selected RSID then set r2 and dprime to 1 (instead of NA because it's in LD with itself in this case)
    pheno_data[pheno_data$ID==reactives$selRiskVariant()$RSID,]$r2 = 1.0
    pheno_data[pheno_data$ID==reactives$selRiskVariant()$RSID,]$dprime = 1.0
    
    colnames(pheno_data) <- c("SNP", "Chr:BP:Ref:Alt", "Locus Number", "LD (rsquared)", "LD (D')", "Frequency (Non-Finnish European)", "Other Associated Disease", "P-value", "PMID")
    
    #pheno_data <- na.omit(pheno_data)
    scrollYVal <- min(50 * nrow(pheno_data), 300)
    datatable(pheno_data, rownames = F, escape = F, option=list(order = list(7, 'asc'), processing = F, searching = F, paginate = F, dom = 't', scrollY = paste0(scrollYVal, "px"), scrollX = T, columnDefs = list(list(
      targets = c(3,4,5),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data.toPrecision(3);",
        "}"
      )))
    ))
  })
}