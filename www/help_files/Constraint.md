# Constraint
Constraint data was obtained from [gnomAD](https://gnomad.broadinstitute.org/) for each gene. This was included to measure how tolerant genes are to different types of variation. 

Positive z scores indicate increased tolerance to variation, or constraint, and that gene transcript has fewer variants than expected. The closer the probability of being loss of function intolerant (pLI) is to 1, the more intolerant the gene transcript appears to be. A lower observed/expected (o/e) value implies stronger selection against that type of variant. 

Genes with a 90% confidence interval (CI) upper limit less than 0.35 were deemed to have significant intolerance. Genes with significant intolerance were scored with 1 in the `Variant Intolerant` column in the evidence table. 

## Column Definitions
* `mis z` - Missense variant z score.
* `mis o/e` - Missense variant observed/expected score and its 90% confidence interval. The upper limit of the CI is used to determine significance.
* `syn z` - synonymous variant z score.
* `syn o/e` - synonymous variant observed/expected score and its 90% confidence interval. The upper limit of the CI is used to determine significance.
* `pLI` - Probability of being loss-of-function intolerant (pLI) score. 
* `lof o/e` - loss of function variant observed/expected score and its 90% confidence interval. The upper limit of the CI is used to determine significance.