import pandas as pd
import numpy as np
import os

def makeOMIMLink(pheno, gene, id):
	return ("<a href='https://omim.org/entry/"+id+"?search="+gene+"' target='_blank'>"+pheno+"</a>")
	
def makeHGMDString(gene):
	gene_pheno = hgmd.loc[(hgmd['GENE']==gene)]
	phenotypes = gene_pheno["PHENO"].tolist()
	HGMD_String = '; '.join(phenotypes)
	return HGMD_String
	
def makeOMIMString(gene):
	gene_pheno = omim.loc[(omim['GENE']==gene)]
	phenotype_links = gene_pheno["link"].tolist()
	OMIM_String = '; '.join(phenotype_links)
	return OMIM_String
	

hgmd = pd.read_csv("diseasegene/HGMD_gene_pheno.csv")

hgmd_genes = hgmd["GENE"].unique()

omim = pd.read_csv("diseasegene/OMIM_gene_pheno.csv")
omim_genes = omim["GENE"].unique()

omim['link'] = omim.apply(lambda x: makeOMIMLink(x.PHENO,x.GENE,x.OMIM),axis=1)

comb_genes = hgmd_genes.tolist() + omim_genes.tolist()

genes = np.unique(comb_genes)

disease_data = pd.DataFrame(data={'Gene': genes})

disease_data['HGMD']=disease_data.apply(lambda x: makeHGMDString(x.Gene),axis=1)

disease_data['OMIM']=disease_data.apply(lambda x: makeOMIMString(x.Gene),axis=1)

disease_data.to_csv("results/DiseaseGeneData.txt", index = False, sep='\t')


#add new Disease Gene column set to 1 for all genes
disease_data['Disease Gene'] = [1] * len(disease_data.index)
disease_data = disease_data[['Gene','Disease Gene']]

#read evidence genes
evidence = pd.read_csv("genes_by_locus.csv")

#merge evidence genes and disease genes
evidence_diseasegenes = pd.merge(evidence, disease_data, how='left', on=['Gene'])

#fill in NAs with 0
evidence_diseasegenes.fillna(0, inplace=True)

evidence_diseasegenes.to_csv("evidence/evidence_diseasegenes.csv", index=False)


	

