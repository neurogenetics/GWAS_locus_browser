# GWAS Locus Browser Gene List Scripts
- **Author** - Cornelis Blauwendraat
- **Date Started** - June 2019
- **Quick Description:** get all genes 1 Mb up and downstream of each risk variant. also includes code to get summary stats (including rsids) for risk variants.
- **Data:** 
input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- genelist
|   |   |-- prep_code.sh
```

## Run
* on biowulf 
* see `prep_code.sh`
    * parts of the script will need to be run separately

## Input
* `refFlat_HG19.txt` containing genes from hg19 reference genome.
* `GWAS.bed` containing data for all the meta5 risk snps.
* `META5_no23.tbl.gz` containing summary stats for the risk variants.
* `HRC_RS_conversion_final_with_CHR.txt` containing rsids for risk variants.

## Output
* a `META5_genes.txt` file containing all the genes 1 Mb up and downstream of each risk variant
* a `META5_no23_with_rsids.txt` containing summary stats with rsids for risk variants. 