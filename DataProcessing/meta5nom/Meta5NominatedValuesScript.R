# # GWAS Locus Browser META5 Nominated Genes Script
# - **Author** - Frank Grenn
# - **Date Started** - October 2019
# - **Quick Description:** get the list of meta5 nominated genes and give them an evidence score
# - **Data:** 
#   meta5 nominated genes obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)


library(dplyr)
library(data.table)
evidence <- fread("genes_by_locus.csv")

#
loci <- fread("GWAS_loci_overview.csv")

evidence$'Nominated by META5' <- ifelse(evidence$Gene %in% loci$'META5 QTL Nominated Gene (nearest QTL)', 1, 0)

write.csv(evidence, file = "evidence/evidence_meta5nom.csv", row.names = FALSE)