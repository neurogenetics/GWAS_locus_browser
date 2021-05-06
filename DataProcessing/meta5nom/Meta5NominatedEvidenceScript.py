# # GWAS Locus Browser META5 Nominated Genes Script
# - **Author** - Frank Grenn
# - **Date Started** - October 2019
# - **Quick Description:** get the list of meta5 nominated genes and give them an evidence score
# - **Data:** 
#   meta5 nominated genes obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)


import pandas as pd
import os

#get pd genes
meta5nom = pd.read_csv("meta5nom/meta5nomgene.csv")

meta5nom_genes = meta5nom[['META5_NOM_GENE']]
meta5nom_genes.columns = ['GENE']

meta5nom_genes['Nominated by META5'] = [1] * len(meta5nom_genes.index)
print(meta5nom_genes)


meta5nom_genes = meta5nom_genes[['GENE','Nominated by META5']].drop_duplicates()

evidence = pd.read_csv("genes_by_locus.csv")

evidence_meta5nom = pd.merge(evidence, meta5nom_genes, how='left', on=['GENE'])

evidence_meta5nom.fillna(0, inplace=True)

evidence_meta5nom.to_csv("evidence/evidence_meta5nom.csv", index=False)

