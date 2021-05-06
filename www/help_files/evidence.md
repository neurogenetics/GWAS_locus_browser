# Evidence Per Gene

This section combines data from all other sections of the GWAS locus browser into one table and assigns each gene a conclusion score. Conclusion scores are the sum of all values for each row in the evidence per gene table. Users may add or remove columns using the buttons above the table. Weights may also be modified for each data type using the sliders. These will multiply value of the column by the slider weight value and will update the conclusion score. Genes with high conclusion scores are predicted to be causal for Parkinson's disease. 

## Column Definitions:
* `Conclusion` - Sum of the scores in the gene row.
* `Nominated by META5` - 1 if the gene was nominated as causal by the Nalls et al., 2019 META5 PD risk GWAS. 0 if it was not nominated in that study. 
* `QTL-brain` - 1 if the gene has a brain locus compare plot with relevant data. 0 if no relevant brain locus compare plots exist for the gene. See the `QTL Evidence` section for more information on scoring. 
* `QTL-blood` - 1 if the gene has a blood locus compare plot with relevant data. 0 if no relevant blood locus compare plots exist for the gene. See the `QTL Evidence` section for more information on scoring. 
* `QTL-correl` - 1 if the gene has a plot with significant correlation in a plot with a `QTL-blood` or `QTL-brain`score of 1. 0 if no significant correlation and NA if no relevant plots exist for the gene. Scores in this column will change as the `Correlation Cutoff` input is changed in the `QTL Evidence` section. See the `QTL Evidence` section for more information on scoring. 
* `Burden` - 1 if the gene has significant burden test results in either imputed or exome data after Bonferroni correction. 0 if not significant and NA if there was no data for the gene. See the `Burden Evidence` section for more information. 
* `Brain Expression` - 1 if the gene has over 5 transcript per million (TPM) in GTEx data averaged across all brain tissues. 0 if less than 5 TPM and NA if there was no data for the gene. See the `Expression Data` section for more information. 
* `Nigra Expression` - 1 if the gene has over 5 transcript per million (TPM) in GTEx data averaged across all substantia nigra (SN) tissues. 0 if less than 5 TPM and NA if there was no data for the gene. See the `Expression Data` section for more information. 
* `SN-Dop. Neuron Expression` - 1 if the gene has over 5 transcript per million (TPM) in dopaminergic cells from substantia nigra single cell data. 0 if less than 5 TPM and NA if there was no data for the gene. See the `Expression Data` section for more information. 
* `Literature Search` - 1 if the gene has 5 or more PubMed hits from the search term "(Parkinson's)[Title/Abstract] AND GENE_NAME[Title/Abstract]". 0 if less than 5 PubMed hits. See the `Literature` section for more information. 
* `Variant Intolerant` - 1 if the 90% CI upper limit is less than 0.35 for the gene. 0 otherwise. See the `Constraint Values` section for more information. 
* `PD Gene` - 1 if the gene is known to be associated with Parkinson's disease or other movement disorders. 0 otherwise. 
* `Disease Gene` -  1 if the gene is linked to another disease. 0 if not. See the `Disease Genes` section for more information. 
