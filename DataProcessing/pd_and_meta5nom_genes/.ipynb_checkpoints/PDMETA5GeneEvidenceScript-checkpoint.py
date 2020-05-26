# # GWAS Locus Browser PD Genes Script
# - **Author** - Frank Grenn
# - **Date Started** - October 2019
# - **Quick Description:** get the list of known PD genes and give them an evidence score
# - **Data:** 
# list of PD genes obtained by Cornelis Blauwendraat
# MDS Genes from https://www.mdsgene.org/g4d


import pandas as pd
import os

pdgenes = pd.read_csv("/path/to/pd_and_meta5nom_genes/PD_Genes.csv", header = None)
pdgenes.columns = ['GENE']



#get MDS genes
mdsgenes = pd.read_csv("/path/to/pd_and_meta5nom_genes/MDSGenes.csv")

pd_gene_final = pd.merge(left = pdgenes, right = mdsgenes, on = 'GENE', how = 'outer')


#set disease to 'Parkinsonism' if no disease assigned by MDS
pd_gene_final = pd_gene_final.fillna('Parkinsonism')

#get meta5 nominated genes
meta5nomgenes = pd.read_csv("/path/to/pd_and_meta5nom_genes/meta5nomgene.csv")


meta5 = meta5nomgenes.dropna(axis=0)
meta5 = meta5[['LOC_NUM','RSID','META5_NOM_GENE']]
meta5.columns = ['META5 Associated Locus Number', 'META5 Associated Variant','META5_NOM_GENE']

pd_meta5 = pd.merge(left = pd_gene_final, right = meta5, left_on = 'GENE', right_on = 'META5_NOM_GENE', how = 'outer')

pd_meta5['GENE']=pd_meta5['GENE'].fillna(pd_meta5['META5_NOM_GENE'],axis=0)

pd_meta5 = pd_meta5.drop('META5_NOM_GENE',axis = 1)

pd_meta5.to_csv("/path/to/pd_and_meta5nom_genes/pd_genes_for_app.csv",index=None)