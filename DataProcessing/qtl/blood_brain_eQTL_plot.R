# # GWAS Locus Browser QTL Locus Compare Plots Scripts
# - **Author** - Frank Grenn and Hirotaka Iwaki
# - **Date Started** - October 2019
# - **Quick Description:** code to make locus compare plots from eQTL and GWAS data


#nohup R CMD BATCH blood_brain_eQTL_plot.R output.log &
#check progress with "jobs"
#get jobid with "ps -ef | grep eQTL"
#and kill with "kill [PID]"

library(locuscomparer)
library(data.table)
library(dplyr)

setwd("$PATH1/QTLPlotCheckScript")

plots_to_plot <- fread("$PATH2/plots_to_plot.csv")
plots_to_plot$plot_status <- ""
plots_to_plot$correlation <- 0
#load the genes and their locus numbers
evidence <- fread("$PATH1/genes_by_locus.csv")

#list of the genes
evidence_genes <- evidence$Gene

#read files that have locusnumbers and associated index variant rsids
meta5_data <- fread("$PATH3/GWAS loci overview.csv")
meta5_data <- meta5_data %>% select("Locus Number", "SNP")
prog_data <- fread("$PATH3/ProgressionLoci.csv")
prog_data <- prog_data %>% select("Locus Number", "RSID")
colnames(prog_data) <- c("Locus Number", "SNP")

#combine all the rsids to one df
variant_data <- rbind(meta5_data, prog_data)


evidence_merged$Locusnumber <- as.character(evidence_merged$Locusnumber)
variant_data$Locusnumber <- as.character(variant_data$Locusnumber)

#merge the evidence df with the variant df
#this is done to account for loci with multiple snps
evidence_merged <- merge(x=evidence, y=variant_data, by.x = "Locusnumber", by.y = "Locus Number", all.x = TRUE, allow.cartesian = TRUE)

#column that will be set to 1 if a plot exists, and 0 otherwise
evidence_merged$'QTL-brain' <- 0
evidence_merged$'QTL-blood' <- 0

evidence_merged$'QTL-brain' <- as.numeric(evidence_merged$'QTL-brain')
evidence_merged$'QTL-blood' <- as.numeric(evidence_merged$'QTL-blood')

#column that will be set to 1 if either plot has a significant correlation. 0 if not and NA if no plots to check
evidence_merged$'QTL-correl' <- NA
evidence_merged$'QTL-correl' <- as.numeric(evidence_merged$'QTL-correl')

#columns that will hold the actual correlation values
evidence_merged$'QTL-brain corrval' <- NA
evidence_merged$'QTL-blood corrval' <- NA

evidence_merged$'QTL-brain corrval' <- as.numeric(evidence_merged$'QTL-brain corrval')
evidence_merged$'QTL-blood corrval' <- as.numeric(evidence_merged$'QTL-blood corrval')

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
  gene <- row$Gene
  locus <- row$Locusnumber
  snp <- row$SNP
  
  print(paste0(gene, " ", feature))
  
  #get file path strings
  gwas_fn = paste0('$PATH1/tsv/', gene, '_',feature,'_gwas.tsv')
  
  eqtl_fn = paste0('$PATH1/tsv/', gene, '_',feature,'_eqtl.tsv')
  
  
  
  g = read.table(gwas_fn, header = T)
  e = read.table(eqtl_fn, header = T)
  
  
  
  df = merge(g, e, by = 'rsid')
  
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
    if(feature == "blood")
    {
      evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-blood corrval' <- correlation

    }
    if(feature == "brain")
    {
      evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-brain corrval' <- correlation

    }
  }
  
  #generate plots
  if(generatePlots)
  {
    plot_file <- ""
    if(feature == "blood")
    {
      
      plot_file <- paste0('$PATH1/eBlood/', gene, '_', snp, '.png')
      k = try(locuscompare(in_fn1 = eqtl_fn, in_fn2 = gwas_fn, snp=row$forced_lead_variant, 
                           title = paste0('Blood eQTL, ',gene), title2 = 'GWAS'),
              silent = T)
      
      if(inherits(k, 'try-error')){
        print(paste0(gene, " failed"))
        print(k)
        fail <-fail+1
        row$plot_status <- paste0('failed: ', k)
        evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-blood' <- 0
        
      }
      else
      {
        png(plot_file, width=1000, height=700)
        success <- success + 1
        row$plot_status <- paste0('plotted')
        evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-blood' <- 1
        
        plot(k)
        dev.off()
      }
      
    }
    if(feature == "brain")
    {
      plot_file <- paste0('$PATH1/eBrain/', gene, '_', snp, '.png')
      k = try(locuscompare(in_fn1 = eqtl_fn, in_fn2 = gwas_fn, snp=row$forced_lead_variant, 
                           title = paste0('Brain eQTL, ',gene), title2 = 'GWAS'),
              silent = T)
      if(inherits(k, 'try-error')){
        print(paste0(gene, " failed"))
        print(k)
        fail <-fail+1
        row$plot_status <- paste0('failed: ', k)
        evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-brain' <- 0
        
        
      }
      else
      {
        png(plot_file, width=1000, height=700)
        success <- success + 1
        row$plot_status <- paste0('plotted')
        evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-brain' <- 1
        
        plot(k)
        dev.off()
      }
      
    }
  
    
    
    
    
  }
  
  
  
  
  
  
  hasPlots <- ((evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-blood'==1) || (evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-brain'==1))
  bloodCorrel <- evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-blood corrval'
  brainCorrel <- evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-brain corrval'
  if(!is.na(bloodCorrel) && !is.na(brainCorrel))
  {
    evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-correl' <- ifelse((bloodCorrel < -.3 || bloodCorrel > .3) || (brainCorrel < -.3 || brainCorrel > .3), 1, 0)
  }
  if(!is.na(bloodCorrel) && is.na(brainCorrel))
  {
    evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-correl' <- ifelse((bloodCorrel < -.3 || bloodCorrel > .3), 1, 0)
  }
  if(is.na(bloodCorrel) && !is.na(brainCorrel))
  {
    evidence_merged[which(evidence_merged$Gene == gene & evidence_merged$Locusnumber == locus & evidence_merged$SNP == snp),]$'QTL-correl' <- ifelse((brainCorrel < -.3 || brainCorrel > .3), 1, 0)
  }
  if((is.na(bloodCorrel) && is.na(brainCorrel)) || !(hasPlots))
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
write.csv(plots_to_plot, file = "plot_info.csv", row.names = FALSE)


