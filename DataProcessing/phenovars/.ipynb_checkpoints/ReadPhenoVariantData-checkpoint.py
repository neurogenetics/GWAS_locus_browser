## GWAS Locus Browser Coding Variants Script
#- **Author** - Frank Grenn and Cornelis Blauwendraat
#- **Date Started** - December 2019
#- **Quick Description:** scripts to get phenotype variant data including PMIDs, LD values and frequencies.

import pandas as pd
import numpy as np
import re

def generatePMIDLink(link):
	id = re.split("/", link)[2]
	return ("<a href='https://"+link+"' target='_blank'>"+id+"</a>")
	
def formatCHRBPREFALT(chr,bp,ref,alt):
	return str(chr)+":"+str(bp)+":"+str(ref)+":"+str(alt)
	
def getNFE(frequencies):
	freq = re.split(",", frequencies)[6]
	return freq

variants = pd.read_csv("phenovars/Variant in other GWAS - Sheet1.csv")

catalog = pd.read_csv("phenovars/GWAS_catalogv1.0.2-associations.txt", sep="\t")

#array for frequency df column names since annovar doesn't generate column names
names = ["db", "freq", "chr", "start", "end", "ref", "alt"]
frequencies = pd.read_csv("phenovars/phenovars.avinput.hg19_gnomad_genome_dropped", sep="\s", names = names)

frequencies['freq_nfe']=frequencies.apply(lambda x: getNFE(x.freq), axis = 1)

#give frequencies df a CHRBP_REFALT to give it a unique key to merge with later
frequencies['CHRBP_REFALT']=frequencies.apply(lambda x: formatCHRBPREFALT(x.chr, x.start, x.ref, x.alt), axis = 1)

merge = pd.merge(variants, catalog, how='left', left_on='ID',right_on='SNPS')

merge['PMID']=merge.apply(lambda x: generatePMIDLink(x.LINK),axis=1)
merge['CHRBP_REFALT']=merge.apply(lambda x: formatCHRBPREFALT(x.Chr, x.Start, x.Ref, x.Alt), axis = 1)

merge_freq=pd.merge(merge,frequencies, how = 'left', on = "CHRBP_REFALT")

pheno_data = merge_freq[['ID', 'CHRBP_REFALT','locus number','freq_nfe', 'DISEASE/TRAIT', 'P-VALUE', 'PMID']]
pheno_data = pheno_data.rename(columns={"DISEASE/TRAIT": "other associated disease"})

pheno_data = pheno_data.drop_duplicates()

pheno_data.to_csv("results/PhenotypeVariantData.csv", index = False)
