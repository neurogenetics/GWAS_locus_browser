# GWAS Locus Browser Other Summary Stats Script
- **Author** - Frank Grenn and Cornelis Blauwendraat
- **Date Started** - January 2020
- **Quick Description:** code to organize the summary statistics from other relevant GWAS studies into files for the app. Also includes code to collect population frequencies from gnomAD
- **Data:** 
input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892), [Age at onset GWAS](https://www.ncbi.nlm.nih.gov/pubmed/30957308), [GBA modifier GWAS](https://www.ncbi.nlm.nih.gov/pubmed/31755958), [LRRK2 modifier GWAS](https://onlinelibrary.wiley.com/doi/full/10.1002/mds.27974), [Asian GWAS](https://jamanetwork.com/journals/jamaneurology/fullarticle/2764340)  

## Layout
```
|-- AppDataProcessing
|   |-- META5Loci.csv
|   |-- ProgressionLoci.csv
|   |-- AsianLoci.csv
|   |-- gwas_risk_variants.csv
|   |-- othersummarystats
|   |   |-- collect_other_summary_stats.ipynb
|   |   |-- risk_variant_pop_freq.ipynb
|   |   |-- other_sum_stats.xlsx
|   |-- results
|   |   |-- aoo_stats.csv
|   |   |-- gba_aoo_stats.csv
|   |   |-- gba_stats.csv
|   |   |-- lrrk2_stats.csv
|   |   |-- ...
```

## 1) collect summary statistics from other GWASes for all risk variants

This includes code to swap allele frequencies to match the minor allele of the risk variants

### Run
* locally or biowulf 
* see `collect_other_summary_stats.ipynb`

### Input
* risk variants csv file containing risk variants from all GWASes included in the browser
* see `collect_other_summary_stats.ipynb`

### Output
* a `other_sum_stats.xlsx` file for each study containing summary stats for all the risk variants

## 2) collect population frequencies for all risk variants

This also includes code to swap allele frequencies to match the minor allele of the risk variants

### Run
* locally or biowulf 
* see `risk_variant_pop_freq.ipynb`

### Input
* `gwas_risk_variants.csv` containing all risk variants for the browser
* see `risk_variant_pop_freq.ipynb`

### Output
* a `risk_variant_pop_freqs.csv` file containing population frequencies matching the minor allele for all risk variants