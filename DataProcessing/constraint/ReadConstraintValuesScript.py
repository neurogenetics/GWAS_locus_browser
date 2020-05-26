import pandas as pd
import numpy as np

def isConstraintSignificant(mis, syn, lof):
	if (mis < 0.35 or syn < 0.35 or lof < 0.35):
		return 1
	else:
		return 0
		
def formatOE(oe, lower, upper):
	if (np.isnan(oe)):
		return 'NA'
	else:
		return "{0:.2f} ({1:.2f}-{2:.2f})".format(oe, lower, upper)
	
def formatZ(z):
	if (np.isnan(z)):
		return 'NA'
	else:
		return "{0:.2f}".format(z)

constraint = pd.read_csv("constraint/gnomad.v2.1.1.lof_metrics.by_gene.txt", sep = "\t")


#read evidence genes
evidence = pd.read_csv("genes_by_locus.csv")


constraint_data = pd.merge(evidence, constraint, how='left', left_on='GENE', right_on = 'gene')

#some of the genes in the constraint data file show up more than once. this removes those and keeps the first entry for the gene
constraint_data = constraint_data.drop_duplicates(subset=['GWAS','GENE','LOC_NUM'], keep='first')

#check if any of the upper limit of the CIs are less than 0.35 for significance
constraint_data['Variant_Intolerant'] = constraint_data.apply(lambda x: isConstraintSignificant(x.oe_mis_upper,x.oe_syn_upper,x.oe_lof_upper),axis=1)


evidence_constraint = constraint_data[['GWAS','GENE','LOC_NUM', 'Variant_Intolerant']]
evidence_constraint.to_csv("evidence/evidence_constraint.csv", index = False)


constraint_data['mis o/e'] = constraint_data.apply(lambda x: formatOE(x.oe_mis,x.oe_mis_lower,x.oe_mis_upper), axis=1)
constraint_data['syn o/e'] = constraint_data.apply(lambda x: formatOE(x.oe_syn,x.oe_syn_lower,x.oe_syn_upper), axis=1)
constraint_data['lof o/e'] = constraint_data.apply(lambda x: formatOE(x.oe_lof,x.oe_lof_lower,x.oe_lof_upper), axis=1)

constraint_data['mis z'] = constraint_data.apply(lambda x: formatZ(x.mis_z), axis=1)
constraint_data['syn z'] = constraint_data.apply(lambda x: formatZ(x.syn_z), axis=1)
constraint_data['pLI'] = constraint_data.apply(lambda x: formatZ(x.pLI), axis=1)

constraint_data = constraint_data[['GENE', 'mis z', 'mis o/e','syn z', 'syn o/e', 'pLI', 'lof o/e']]


constraint_data.to_csv("results/ConstraintData.csv", index=False)

