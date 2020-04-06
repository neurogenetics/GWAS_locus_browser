import pandas as pd
import numpy as np
import re

def formatCHRBPREFALT(chr,bp,ref,alt):
	return str(chr)+":"+str(bp)+":"+str(ref)+":"+str(alt)
	
def getNFE(frequencies):
	freq = re.split(",", frequencies)[6]
	return freq
	
def getFirstAAChange(AAchanges):
	return re.split(",", AAchanges)[0]

def getFirstGene(genes):
	return re.split(";", genes)[0]

#separate raw and phred cadd scores, and return phred score
def getCADDPhred(cadd):
    caddphred = re.split(",", cadd)[1]
    return caddphred

variants = pd.read_csv("codingvars/CodingVariant.csv")

variants['CHRBP_REFALT']=variants.apply(lambda x: formatCHRBPREFALT(x.Chr, x.Start, x.REF, x.ALT), axis = 1)

#array for frequency df column names since annovar doesn't generate column names
names = ["db", "freq", "chr", "start", "end", "ref", "alt"]
frequencies = pd.read_csv("codingvars/codingvars.avinput.hg19_gnomad_genome_dropped", sep="\s", names = names)

frequencies['freq_nfe']=frequencies.apply(lambda x: getNFE(x.freq), axis = 1)

#give frequencies df a CHRBP_REFALT to give it a unique key to merge with later
frequencies['CHRBP_REFALT']=frequencies.apply(lambda x: formatCHRBPREFALT(x.chr, x.start, x.ref, x.alt), axis = 1)



merge=pd.merge(variants,frequencies, how = 'left', on = "CHRBP_REFALT")

merge = merge[['ID', 'CHRBP_REFALT','locus number','Gene.refGene','freq_nfe','AAChange.refGene']]



names = ["db", "cadd", "chr", "start", "end", "ref", "alt"]
cadd = pd.read_csv("codingvars/codingvars.avinput.hg19_cadd_dropped", sep="\s", names = names)

cadd['cadd_phred'] = cadd.apply(lambda x: getCADDPhred(x.cadd), axis = 1)

#give cadd df a CHRBP_REFALT to give it a unique key to merge with later
cadd['CHRBP_REFALT']=cadd.apply(lambda x: formatCHRBPREFALT(x.chr, x.start, x.ref, x.alt), axis = 1)

merge_final = pd.merge(merge, cadd, how = 'left', on = "CHRBP_REFALT")

merge_final['AA Change']=merge_final.apply(lambda x: getFirstAAChange(x['AAChange.refGene']), axis = 1)

merge_final['Gene.refGene'] = merge_final.apply(lambda x: getFirstGene(x['Gene.refGene']), axis = 1)


coding_data = merge_final[['ID', 'CHRBP_REFALT','locus number','Gene.refGene','AA Change','freq_nfe','cadd_phred']]

coding_data.to_csv("results/CodingVariants.csv", index = False)
