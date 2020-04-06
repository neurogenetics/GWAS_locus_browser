# # GWAS Locus Browser QTL Locus Compare Plots Scripts
# - **Author** - Frank Grenn
# - **Date Started** - March 2020
# - **Quick Description:** code to make locus compare plots from psychENCODE isoQTL data

#nohup R CMD BATCH psychencode_isoQTL_plot.R output.log &
#check progress with "jobs"
#get jobid with "ps -ef | grep psychencode"
#and kill with "kill [PID]"

library(locuscomparer)
library(data.table)
library(dplyr)

setwd("$PATH1")

plots_to_plot <- fread("$PATH1/isoqtl_plots_to_plot.csv")
plots_to_plot$plot_status <- ""
plots_to_plot$correlation <- 0
#load the genes and their locus numbers
evidence <- fread("$PATH2/genes_by_locus.csv")

#list of the genes
evidence_genes <- evidence$Gene

#read files that have locusnumbers and associated index variant rsids
meta5_data <- fread("$PATH2/GWAS loci overview.csv")
meta5_data <- meta5_data %>% select("Locus Number", "SNP")
prog_data <- fread("$PATH2/ProgressionLoci.csv")
prog_data <- prog_data %>% select("Locus Number", "RSID")
colnames(prog_data) <- c("Locus Number", "SNP")

#combine all the rsids to one df
variant_data <- rbind(meta5_data, prog_data)


evidence$Locusnumber <- as.character(evidence$Locusnumber)
variant_data$Locusnumber <- as.character(variant_data$Locusnumber)

#merge the evidence df with the variant df
#this is done to account for loci with multiple snps
evidence_merged <- merge(x=evidence, y=variant_data, by.x = "Locusnumber", by.y = "Locus Number", all.x = TRUE, allow.cartesian = TRUE)

#column that will be set to 1 if a plot exists, and 0 otherwise
evidence_merged$'isoQTL' <- 0

evidence_merged$'isoQTL' <- as.numeric(evidence_merged$'isoQTL')

#column that will be set to 1 if either plot has a significant correlation. 0 if not and NA if no plots to check
evidence_merged$'QTL-correl' <- NA
evidence_merged$'QTL-correl' <- as.numeric(evidence_merged$'QTL-correl')

#columns that will hold the actual correlation values
evidence_merged$'isoQTL corrval' <- NA

evidence_merged$'isoQTL corrval' <- as.numeric(evidence_merged$'isoQTL corrval')

#boolean for generating the plots or not
generatePlots <- TRUE

evidence_merged$rowcount <- 0

i <- 0

success <-0
fail <-0
#loops over all the genes
for(rownum in  1:nrow(plots_to_plot))
{
  
  print(i)
  row <- plots_to_plot[rownum,]
  
  feature <- row$feature
  gene <- row$gene
  locus <- row$Locusnumber
  snp <- row$SNP
  gwas <- row$gwas
  transcript <- row$transcript
  
  
  print(paste0(gene, " ", feature))
  isoQTL_tsv_dir <- '$PATH1/isoqtl_tsv'
  if(gwas == "meta5")
  {
    tsv_dir <- paste0(isoQTL_tsv_dir,"/meta5")

  }
  if(gwas == "prog1")
  {
    tsv_dir <- paste0(isoQTL_tsv_dir,"/prog1")

  }
  if(gwas == "prog2")
  {
    tsv_dir <- paste0(isoQTL_tsv_dir,"/prog2")

  }
  gwas_fn = paste0(tsv_dir, '/', gene, '_', transcript, '_gwas.tsv')
  qtl_fn = paste0(tsv_dir, '/', gene, '_', transcript, '_isoqtl.tsv')
  
  
  g = read.table(gwas_fn, header = T)
  e = read.table(qtl_fn, header = T)
  
  
  
  df = merge(g, e, by = 'var_id')
  
  # Replace df$pval.y == 0 with the smallest pval.y of non0 with some random devider
  if(length(which(df$pval.y==0))!=0){
    vector_pvaly0 = which(df$pval.y==0)
    minp = min(df$pval.y[-vector_pvaly0])
    randomdevider = runif(n = length(vector_pvaly0), min = 1, max = 100)
    df$pval.y[vector_pvaly0] = minp/randomdevider
  }
  
  
  
  df$nlog10Pgwas = -log10(df$pval.x)
  df$nlog10Pqtls = -log10(df$pval.y)
  evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$rowcount <- nrow(df)
  
  row$num_snps <- nrow(df)
  #want at least 30 samples when checking for correlation
  if(nrow(df)>=30)
  {
    correlation <- cor.test(df$nlog10Pgwas, df$nlog10Pqtls)$estimate
    row$correlation <- correlation
    if(feature == "isoqtl")
    {
      evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'isoQTL corrval' <- correlation
      
    }
  }
  
  #generate plots
  if(generatePlots)
  {
    plot_file <- ""
    if(feature == "isoqtl")
    {
      
      plot_file <- paste0('$PATH1/p_isoQTL/', gene,'_',transcript, '_', snp, '.png')
      k = try(locuscompare(in_fn1 = qtl_fn, in_fn2 = gwas_fn, snp=row$forced_lead_variant, 
                           title = paste0('Psychencode isoQTL, ',gene, ' ', transcript), title2 = 'GWAS'),
              silent = T)
      
      if(inherits(k, 'try-error')){
        print(paste0(gene, " failed"))
        print(k)
        fail <-fail+1
        row$plot_status <- paste0('failed: ', k)
        evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'isoQTL' <- 0
        
      }
      else
      {
        png(plot_file, width=1000, height=700)
        success <- success + 1
        row$plot_status <- paste0('plotted')
        evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'isoQTL' <- 1
        
        plot(k)
        dev.off()
      }
      
    }
    
    
    
    
    
    
  }
  
  
  
  
  
  
  
  
  hasPlots <- (evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'isoQTL'==1)
  isoQTLCorrel <- evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'isoQTL corrval'
  
  if(!is.na(isoQTLCorrel))
  {
    evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-correl' <- ifelse((isoQTLCorrel < -.3 || isoQTLCorrel > .3), 1, 0)
  }
  if(is.na(isoQTLCorrel) || !(hasPlots))
  {
    evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-correl' <- NA
  }
  i=i+1
  
  plots_to_plot[rownum,] <- row
}
if(generatePlots)
{
  print(paste0(fail , " plots failed to be made"))
  print(paste0(success, " plots were successfully made"))
}

#write file with the correlation data
write.csv(plots_to_plot, file = "psychencode_isoQTL_plot_info.csv", row.names = FALSE)
