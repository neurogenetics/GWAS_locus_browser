# GWAS Locus Browser Other Summary Stats Script
- **Author** - Frank Grenn
- **Date Started** - January 2020
- **Quick Description:** organize the summary statistics from other relevant GWAS studies into files for the app.
- **Data:** 
input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892), [Age at onset GWAS](https://www.ncbi.nlm.nih.gov/pubmed/30957308), [GBA modifier GWAS](https://www.ncbi.nlm.nih.gov/pubmed/31755958), [LRRK2 modifier GWAS](https://onlinelibrary.wiley.com/doi/full/10.1002/mds.27974)  
final statistics curated by Cornelis Blauwendraat

## Layout
```
|-- AppDataProcessing
|   |-- GWAS_loci_overview.csv
|   |-- othersummarystats
|   |   |-- collect_other_summary_stats.ipynb
|   |   |-- sumstats_for_browser_Feb62020.xlsx
|   |-- results
|   |   |-- aoo_stats.csv
|   |   |-- gba_aoo_stats.csv
|   |   |-- gba_stats.csv
|   |   |-- lrrk2_stats.csv
```

## Run
* locally or biowulf 
* see `collect_other_summary_stats.ipynb`

## Input
* a `GWAS_loci_overview.csv` containing the risk variants
* see `collect_other_summary_stats.ipynb`

## Output
* a `[study identifier]_stats.csv` file for each study containing summary stats for all the risk variants

# NOTE
* output from the jupyter notebook was manually checked and modified to ensure effect allele frequencies corresponded to the same allele across all datasets. 
* Beta and odds ratio values were recalculated if a variant's effect allele frequency was flipped.
* The resulting modified data was combined into `sumstats_for_browser_Feb62020.xlsx`, containing a sheet for each study. 