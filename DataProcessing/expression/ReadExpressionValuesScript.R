# 
# # GWAS Locus Browser Expression Scripts
# - **Author** - Frank Grenn
# - **Date Started** - June 2019
# - **Quick Description:** get average expression data per gene
# - **Data:** 
#   input files obtained from: [Single Cell SN Data](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE140231), [GTEX Data](https://www.gtexportal.org/home/datasets)
# 
# ## 1) Get expression averages per gene and score
# 
# ### Run
# * on biowulf 
# * `Rscript expression/ReadExpressionValuesScript.R`
# 
# ### Input
# * a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
# * a `GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct` containing GTEX expression data
# * a `GTEX_sample_names_v8.txt` file containing sample names and tissue types
# * a Nigra_Mean_Cell_GABA_type.txt` file containing single cell data for the genes
# * a `Nigra_Samples_v8.txt` file containing sample names of substantia nigra tissues (obtained by using grep with "nigra" on `GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt` to get the nigra samples)
# 
# ### Output
# * a `ExpressionData.csv` file in the `results` folder containing the average expression data for genes
# * a `evidence_expression.csv` file in the `evidence` folder containing the gene expression scores

library(data.table)#used for fread function
library (dplyr)#used to select columns from dataframes

#cut -f 1-10 $PATH/GTEX/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct | head

print("reading gct file")
gtexExpData <- fread("expression/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct")

###initialize the final expressionDF table and get the genes we want

print("reading gene list")
evidence <- fread("genes_by_locus.csv")
genes_list <- unique(evidence$GENE)
genes <- data.frame("Gene" = genes_list)

#initialize the expression dataframe with the gene names
expressionDF <- data.frame("Gene" = genes)

###GTEX_BRAIN_all

print("reading GTEX sample names")
gtexSampleNames <- fread("expression/GTEX_sample_names_v8.txt")

#get all sampleIDs for brain tissues
gtexBrainSampleNames <- gtexSampleNames[gtexSampleNames$SMTS == "Brain", ]

singleCellData <- fread("expression/Nigra_Mean_Cell_GABA_type.txt")
#get all genes of interest
gtexGeneNames <- singleCellData$Gene


print("filter for the genes we want")
#filter for only the genes we want
expressionGenes <- subset(gtexExpData, gtexExpData$Description %in% genes_list)
print("transpose")
expressionGenes <- as.data.frame(t(expressionGenes))
colnames(expressionGenes) <- unlist(expressionGenes[2,])

print("filter for the brain samples we want")
filteredData <- subset(expressionGenes, rownames(expressionGenes) %in% gtexBrainSampleNames$SAMPID)
print("transpose")
filteredData <- as.data.frame(t(filteredData))

print("find means")
filteredData$GTEX_BRAIN_all <- apply(filteredData[2:ncol(filteredData)], 1, function(x) mean(as.numeric(x), na.rm = TRUE))

gtexBrainJoinDF <- data.frame("Gene" = rownames(filteredData), "GTEX_BRAIN_all" = filteredData$GTEX_BRAIN_all)

print("join to final table")
expressionDF <- merge(x = expressionDF, y = gtexBrainJoinDF, by = "Gene", all.x = TRUE)




#calculate for substantia nigra only
#grep for "nigra" in "GTEx_v7_Annotations_SampleAttributesDS.txt" to get the nigra samples

print("finding expression data for substantia nigra samples")
nigraSamples <- fread("expression/Nigra_Samples_v8.txt")
nigraSampleNames <- nigraSamples$V1



#filter for only the genes we want
print("filter for the genes we want")
expressionGenes <- subset(gtexExpData, gtexExpData$Description %in% genes_list)
print("transpose")
expressionGenes <- as.data.frame(t(expressionGenes))
colnames(expressionGenes) <- unlist(expressionGenes[2,])

print("filter for the nigra samples we want")
filteredData <- subset(expressionGenes, rownames(expressionGenes) %in% nigraSampleNames)

print("transpose")
filteredData <- as.data.frame(t(filteredData))

print("find means")
filteredData$GTEX_nigra <- apply(filteredData[2:ncol(filteredData)], 1, function(x) mean(as.numeric(x), na.rm = TRUE))

gtexNigraJoinDF <- data.frame("Gene" = rownames(filteredData), "GTEX_nigra" = filteredData$GTEX_nigra)

print("join to final table")
expressionDF <- merge(x = expressionDF, y = gtexNigraJoinDF, by = "Gene", all.x = TRUE)



#merge with the single cell data
print("add single cell data")
expressionDF <- merge(x = expressionDF, y = singleCellData, by = "Gene", all.x = TRUE)


print("write to csv")
write.csv(expressionDF, "results/ExpressionData.csv", row.names = F)


###assign expression values for the evidence table
#if avg is > 5 then 1, else 0, and NA if no avgs
print("finding evidence values (if GTEX average > 5 then set to 1)")
evdExp <- expressionDF %>% select("Gene", "GTEX_BRAIN_all", "GTEX_nigra", "DaN")
evdExp$'Brain Expression' <- ifelse(evdExp$'GTEX_BRAIN_all' > 5, 1, 0)
evdExp$'Nigra Expression' <- ifelse(evdExp$'GTEX_nigra' > 5, 1, 0)
evdExp$'SN-Dop. Neuron Expression' <- ifelse(evdExp$'DaN' > 5, 1, 0)

evdExp <- evdExp %>% select('Gene', 'Brain Expression', 'Nigra Expression', 'SN-Dop. Neuron Expression')

evidenceDF <- merge(x = evidence, y = evdExp, by.x = "GENE",by.y="Gene", all.x = TRUE)

write.csv(evidenceDF, "evidence/evidence_expression.csv", row.names = F)