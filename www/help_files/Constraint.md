# Constraint
Constraint data was obtained from [gnomAD](https://gnomad.broadinstitute.org/) for each gene. These scores describe how tolerant genes are to different types of variation. 

Positive z scores show increased intolerance to sequence variation, or constraint, and that gene transcript has fewer variants than expected. 
Probability of being loss of function intolerant (pLI) scores closer to 1 mean the gene transcript is more intolerant to loss of function (LOF) variants. 

Observed/expected (o/e) for each variant type measures the number of variants observed in each gene compared to the number expected based on gene size and mutation frequencies how tolerant the gene is to the variant type. Genes with low o/e values are considered to be under stronger selection for that class of variation than a gene with a higher o/e value. Genes with an o/e 90% confidence interval (CI) upper limit less than 0.35 are considered to have significant intolerance. Genes with significant intolerance were scored with 1 in the `Variant Intolerant` column in the evidence table. 

## Column Definitions:
* `mis z` - Missense variant z score
* `mis o/e` - Missense variant observed/expected score and its 90% confidence interval. The upper limit of the CI is used to determine significance
* `syn z` - Synonymous variant z score
* `syn o/e` - Synonymous variant observed/expected score and its 90% confidence interval. The upper limit of the CI is used to determine significance
* `pLI` - Probability of being loss-of-function intolerant (pLI) score 
* `lof o/e` - Loss of function variant observed/expected score and its 90% confidence interval. The upper limit of the CI is used to determine significance