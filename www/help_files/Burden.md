# Burden

Burden statistics were included from the Nalls et al. 2019 META5 PD risk GWAS and another exome sequencing study. The exome study included fourty different burden tests, and the imputed Nalls et al. 2019 META5 data included two different burden tests. These burden tests used only missense and loss-of-function variants with minor allele frequency cutoffs of 0.05 and 0.01. The minimum p-value of each test was included for each gene in the browser. These minimum p-values were Bonferroni corrected by the number of genes with data in the burden test to determine significance. Genes passing this significance test were given a value of 1 in the `Burden` column in the evidence per gene table. Insignificant genes are assigned a value of 0 and NA if they have no burden data. Genes with significant burden values may be more associated with the risk variant in either cases or controls. 

## Column Definitions
* `Pval.Imputed` - Minimum p-value of the two burden tests performed on the gene in imputed data from the Nalls et al. 2019 META5 PD risk GWAS. 
* `Pval.Exome` - Minimum p-value of the forty burden tests performed on the gene in the exome study. 