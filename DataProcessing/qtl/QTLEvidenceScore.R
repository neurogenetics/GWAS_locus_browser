# # GWAS Locus Browser QTL Locus Compare Plots Scripts
# - **Author** - Frank Grenn
# - **Date Started** - March 2020
# - **Quick Description:** code to score all eQTL data for evidence table in app

library(data.table)
library(dplyr)

setwd("$PATH1")

blood_brain_eqtl_info <- fread("$PATH1/plot_info.csv")
pe_isoqtl_info <- fread("$PATH1/psychencode_isoqtl_plot_info.csv")
pe_eqtl_info <- fread("$PATH1/psychencode_eqtl_plot_info.csv")


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
evidence_merged$'QTL-brain' <- 0
evidence_merged$'QTL-blood' <- 0

evidence_merged$'QTL-brain' <- as.numeric(evidence_merged$'QTL-brain')
evidence_merged$'QTL-blood' <- as.numeric(evidence_merged$'QTL-blood')


#column that will be set to 1 if either plot has a significant correlation. 0 if not and NA if no plots to check
evidence_merged$'QTL-correl' <- 'NA'
evidence_merged$'QTL-correl' <- as.numeric(evidence_merged$'QTL-correl')


for(i in 1:nrow(evidence_merged))
{
  
  
  row <- evidence_merged[i,]
  print(paste0(i, " ", row$Gene, " " , row$SNP))
  blood_subset <- blood_brain_eqtl_info %>% filter(feature=="blood") %>% filter(Gene == row$Gene) %>% filter(SNP == row$SNP) %>% select(num_snps,plot_status, correlation)
  brain_subset <- blood_brain_eqtl_info %>% filter(feature=="brain") %>% filter(Gene == row$Gene) %>% filter(SNP == row$SNP) %>% select(num_snps,plot_status, correlation)
  
  pe_eqtl_subset <- pe_eqtl_info %>% filter(Gene ==row$Gene) %>% filter(SNP==row$SNP) %>% select(num_snps,plot_status, correlation)
  pe_isoqtl_subset <- pe_isoqtl_info %>% filter(gene ==row$Gene) %>% filter(SNP==row$SNP) %>% select(num_snps,plot_status, correlation)
  
  ####break the scoring into separate if statements to account for cases with no data
  
  #blood-qtl score
  if(nrow(blood_subset)==0)
  {
    row$`QTL-blood` <- 0
  }
  else
  {
    if(blood_subset$plot_status=="plotted" && blood_subset$num_snps>=30)
    {
      row$`QTL-blood` <- 1
    }
    else
    {
      row$`QTL-blood` <- 0
    }
  }
  
  #brain-qtl score
  all_brain <- rbind(brain_subset,pe_eqtl_subset,pe_isoqtl_subset)
  
  if(nrow(all_brain)==0)
  {
    row$`QTL-brain` <- 0
  }
  else
  {
    if(all_brain$plot_status=="plotted" && all_brain$num_snps>=30)
    {
      row$`QTL-brain` <- 1
    }
    else
    {
      row$`QTL-brain` <- 0
    }
  }

  #correlation score
  if(nrow(all_brain)==0 && nrow(blood_subset)==0)
  {
    row$`QTL-correl` <- NA
  }
  else if (row$`QTL-brain` == 0 && row$`QTL-blood` == 0 )
  {
    row$`QTL-correl` <- NA
  }
  else if(nrow(all_brain)!=0 && nrow(blood_subset)==0)
  {
    if(abs(all_brain$correlation > 0.3))
    {
      row$`QTL-correl` <- 1
    }
    else
    {
      row$`QTL-correl` <- 0
    }
  }
  else if(nrow(all_brain)==0 && nrow(blood_subset)!=0)
  {
    if(abs(blood_subset$correlation > 0.3))
    {
      row$`QTL-correl` <- 1
    }
    else
    {
      row$`QTL-correl` <- 0
    }
  }
  else if(nrow(all_brain)!=0 && nrow(blood_subset)!=0)
  {
    if (abs(blood_subset$correlation) > 0.3 || abs(all_brain$correlation > 0.3))
    {
      row$`QTL-correl` <- 1
    }
    else
    {
      row$`QTL-correl` <- 0
    }
  }
  
  

  evidence_merged[i,] <- row
  
  
}


evidence_merged <- evidence_merged %>% select("Gene", "Locusnumber", "SNP", "QTL-brain", "QTL-blood", "QTL-correl")

write.csv(evidence_merged, file = "evidence_qtl.csv", row.names = FALSE)
