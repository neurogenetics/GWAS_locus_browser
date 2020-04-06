# GWAS Locus Browser Burden Script
- **Author** - Frank Grenn
- **Date Started** - June 2019
- **Quick Description:** get the minimum burden p value for each gene of interest for imputed and exome burden tests. Bonferroni correct p-values by number of genes in test and assign significance scores to each gene.
- **Data:** 
input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- burden
|   |   |-- ReadBurdenValuesScript.R
|   |   |-- Burden results
|   |   |   |-- Burden_Exome
|   |   |   |   |-- meta_casecontrol_Lof_GRANVIL_0.01.tab
|   |   |   |   |-- meta_casecontrol_Lof_GRANVIL_0.05.tab
|   |   |   |   |-- ...
|   |   |   |-- Burden_GWAS
|   |   |   |   |-- burden_SKAT_0_01_extra_cov.SkatO.assoc
|   |   |   |   |-- burden_SKAT_normal_extra_cov.SkatO.assoc
|   |   |   |   |-- ...
|   |-- results
|   |   |-- BurdenPValueData.csv
|   |-- evidence
|   |   |-- evidence_burden.csv
```

## Run
* locally or biowulf 
* `Rscript burden/ReadBurdenValuesScript.R`

## Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
* a `Burden_Exome` folder containing .tab files for the burden exome results. Each file needs a `gene.name.out` and `p.value.out` column
* a `Burden_GWAS` folder containing .assoc files for the burden imputation results. Each file needs a `Gene` and `Pvalue` column

## Output
* a `BurdenPValueData.csv` file in the `results` folder containing the imputed and exome data minimum p-values for each gene
* a `evidence_burden.csv` file in the `evidence` folder containing the significant burden score for each gene