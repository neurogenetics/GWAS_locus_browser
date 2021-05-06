finemap<-list()
finemap$id <- "finemap"
finemap$title <- "Fine-Mapping of Locus"

finemap$loadData<- function(){
  #finemapping data
  finemapping <<- fread("www/finemapping/fineMappingFilteredData.csv")
  
  colnames(finemapping) <<- c("Locus Number", "SNP", "Chr", "BP", "Ref", "Alt", "Frequency", "P-value", "Prob", "log10bf", "Function", "Exonic Function", "AA Change")
  finemapping$`AA Change` <<- gsub(",","\n", finemapping$`AA Change`)
  finemapping$Frequency <<- signif(finemapping$Frequency,4)
  finemapping$"P-value" <<- signif(finemapping$"P-value",4)
  finemapping$Prob <<- signif(finemapping$Prob,4)
  finemapping$log10bf <<- signif(finemapping$log10bf,4)
}

finemap$generateUI<- function(){
  fluidRow(
    column(dataTableOutput("fineMappingTable"), width = 12)
  )
}


finemap$serverLogic <- function(input,output,session,reactives)
{

  output$fineMappingTable <- renderDataTable(
    {
      if(reactives$selRiskVariant()$GWAS=="META5")
      {
        finemap_subset <- finemapping[which(finemapping$'Locus Number'==reactives$selRiskVariant()$LOC_NUM)]
        finemap_subset <- finemap_subset %>% select(-c("Locus Number"))
        finemap_subset
      }
      else
      {
        finemap_subset <- finemapping[which(finemapping$'Locus Number'==reactives$selRiskVariant()$LOC_NUM)]
        finemap_subset <- finemap_subset %>% select(-c("Locus Number"))
        finemap_subset[0,]
      }
      
    }, escape=F, rownames = F, options = list(searching = F, paginate = F, dom = 't', scrollY = "300px", columnDefs = list(list(
      className = 'dt-right', 
      targets = c(1:ncol(finemapping)-2),
      render = JS(
        "function(data, type, row, meta) {",
        "return (data==null) ? 'NA' : data;",
        "}"
      ))))
  )
}