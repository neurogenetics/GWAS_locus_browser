# GWAS Locus Browser META5 Nominated Genes Script
- **Author** - Frank Grenn
- **Date Started** - October 2019
- **Quick Description:** get the list of meta5 nominated genes and give them an evidence score
- **Data:** 
meta5 nominated genes obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- GWAS_loci_overview.csv
|   |-- meta5nom
|   |   |-- Meta5NominatedValulesScript.R
|   |-- evidence
|   |   |-- evidence_meta5nom.csv
```

## Run
* locally or biowulf 
* `Rscript meta5nom/Meta5NominatedValulesScript.R`

## Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
* a `GWAS_loci_overview.csv` file containing the meta5 nominated genes for the risk variants

## Output
* a `evidence_meta5nom.csv` file in the `evidence` folder containing all the genes and with meta5 nominated genes marked with one