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

pdgenes.columns = ['GENE']
pdgenes.head()

pdgenes['PD Gene'] = [1] * len(pdgenes.index)

#get MDS genes
mdsgenes = pd.read_csv("pdgenes/MDSGenes.csv")

mdsgenes['PD Gene'] = [1] * len(mdsgenes.index)

mdsgenes = mdsgenes[['GENE','PD Gene']]


#append and remove duplicates
pdgenes = pdgenes.append(mdsgenes).drop_duplicates()


evidence = pd.read_csv("genes_by_locus.csv")

evidence_pdgenes = pd.merge(evidence, pdgenes, how='left', on=['GENE'])

evidence_pdgenes.fillna(0, inplace=True)

evidence_pdgenes.to_csv("evidence/evidence_pdgenes.csv", index=False)

