# # GWAS Locus Browser Burden Script
# - **Author** - Frank Grenn
# - **Date Started** - June 2019
# - **Quick Description:** get the minimum burden p value for each gene of interest for imputed and exome burden tests. Bonferroni correct p-values by number of genes in test and assign significance scores to each gene.
# - **Data:** 
#   input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)

library(data.table)#to store the search results and other data in dataframes
library (dplyr)#to select specific columns from data frames

#get gene list 
evidenceDF <- fread("genes_by_locus.csv") 
evidenceGenes <- evidenceDF$GENE

#remove duplicate genes from evidence table gene names
evidenceGenes <- unique(evidenceGenes)

genes <- data.frame("GENE" = evidenceGenes)


###Burden Exome Data
filenames <- list.files("burden/Burden results/Burden_Exome", pattern="*.tab")


#initialize the exome burden table we will be joining to
burdenExomeTable <- data.frame("gene.name.out" = evidenceGenes)

for(i in 1:length(filenames))
{
  #get the file data in a dataframe
  df <- fread(paste0("burden/Burden results/Burden_Exome/",filenames[i]))
  
  #select the gene and pval cols and rename the pval col
  df <- df %>% select("gene.name.out", "p.value.out")
  colnames(df)[2] <- filenames[i]
  
  #left join the burdenExomeTable and current file's dataframe
  burdenExomeTable <- merge(x = burdenExomeTable, y = df, by = "gene.name.out", all.x = TRUE)
  
}

#get the smallest value from each row
burdenExomeTable$"Pval Exome" <- apply(burdenExomeTable[2:length(filenames)], 1, function(x) min(x, na.rm = TRUE))
burdenExomeMins <- burdenExomeTable %>% select("gene.name.out", "Pval Exome")

#replace "Inf" with NA
burdenExomeMins <- do.call(data.frame, lapply(burdenExomeMins, function(x) replace(x, is.infinite(x), NA)))


#Bonferroni correction calculations
num_exome <- sum(!is.na(burdenExomeMins$Pval.Exome))

print(paste0(num_exome, " genes with p values for exome burden tests"))

alpha <- .05

bonP <- alpha/num_exome

burdenExomeMins$BonExome <- ifelse(burdenExomeMins$Pval.Exome < bonP, 1, 0)








###Burden Imputation Data

burdenImputeTable <- data.frame("gene.name.out" = evidenceGenes)

#get data from the two imputation result files
burden01 <- fread("burden/Burden results/Burden_GWAS/burden_SKAT_0_01_extra_cov.SkatO.assoc")
burdenNormal <- fread("burden/Burden results/Burden_GWAS/burden_SKAT_normal_extra_cov.SkatO.assoc")

#select and merge the results of the first file to the imputeTable
burden01 <- burden01 %>% select("Gene", "Pvalue")
colnames(burden01) <- c("gene.name.out", "burden_SKAT_0_01_extra_cov.SkatO.assoc")
burdenImputeTable <- merge(x = burdenImputeTable, y = burden01, by = "gene.name.out", all.x = TRUE)

#select and merge the results of the second file to the imputeTable
burdenNormal <- burdenNormal %>% select("Gene", "Pvalue")
colnames(burdenNormal)<- c("gene.name.out", "burden_SKAT_normal_extra_cov.SkatO.assoc")
burdenImputeTable <- merge(x = burdenImputeTable, y = burdenNormal, by = "gene.name.out", all.x = TRUE)

#get the smallest value from each row
burdenImputeTable$"Pval Imputed" <- apply(burdenImputeTable[2:3], 1, function(x) min(x, na.rm = TRUE))
burdenImputeMins <- burdenImputeTable %>% select("gene.name.out", "Pval Imputed")

#replace "Inf" with NA
burdenImputeMins <- do.call(data.frame, lapply(burdenImputeMins, function(x) replace(x, is.infinite(x), NA)))


#Bonferroni correction calculations
num_exome <- sum(!is.na(burdenImputeMins$Pval.Imputed))

print(paste0(num_exome, " genes with p values for imputed burden tests"))

alpha <- .05

bonP <- alpha/num_exome

burdenImputeMins$BonImpute <- ifelse(burdenImputeMins$Pval.Imputed < bonP, 1, 0)





#outer join the Imputed and Exome p value mins
burdenTable <- merge(x = burdenImputeMins, y = burdenExomeMins, by = "gene.name.out", all = TRUE)
colnames(burdenTable)[1] <- "GENE"

write.csv(burdenTable %>% select("GENE", "Pval.Imputed", "Pval.Exome"), file = "results/BurdenPValueData.csv", row.names = FALSE)

#assign 1 when either burden test is significant
burdenTable$Burden <- ifelse((burdenTable$BonImpute==1 & !is.na(burdenTable$BonImpute)) | (burdenTable$BonExome==1 & !is.na(burdenTable$BonExome)), 1, 0)

#assign NA if neither burden test has values
burdenTable$Burden <- ifelse(is.na(burdenTable$BonImpute) & is.na(burdenTable$BonExome), NA, burdenTable$Burden)

evidenceDF <- merge(evidenceDF, burdenTable %>% select("GENE", "Burden"), by = "GENE", all.x = TRUE)

write.csv(evidenceDF, file = "evidence/evidence_burden.csv", row.names = FALSE)