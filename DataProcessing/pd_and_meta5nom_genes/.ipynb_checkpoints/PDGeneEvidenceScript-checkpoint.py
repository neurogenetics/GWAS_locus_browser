# # GWAS Locus Browser PD Genes Script
# - **Author** - Frank Grenn
# - **Date Started** - October 2019
# - **Quick Description:** get the list of known PD genes and give them an evidence score
# - **Data:** 
# list of PD genes obtained by Cornelis Blauwendraat


import pandas as pd
import os

#get pd genes
pdgenes = pd.read_csv("pdgenes/PD_Genes.csv", header = None)

pdgenes.columns = ['Gene']
pdgenes.head()

pdgenes['PD Gene'] = [1] * len(pdgenes.index)


evidence = pd.read_csv("genes_by_locus.csv")

evidencegenes = evidence[['Gene']]

evidence_pdgenes = pd.merge(evidence, pdgenes, how='left', on=['Gene'])

evidence_pdgenes.fillna(0, inplace=True)

evidence_pdgenes.to_csv("evidence/evidence_pdgenes.csv", index=False)

