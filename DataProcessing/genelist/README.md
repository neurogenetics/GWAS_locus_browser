# GWAS Locus Browser Gene List Scripts
- **Author** - Frank Grenn and Cornelis Blauwendraat
- **Date Started** - June 2019
- **Quick Description:** 
  - gets all genes 1 Mb up and downstream of each risk variant for all gwases
  - gathers basic summary statistics for a new gwas study
  - updates the `genes_by_locus.csv` file with new gwas genes. This file is important to other data processing scripts
  - updates the `gwas_risk_variants.csv` file with new gwas risk variants. This file is also important to other data processing scripts. 
  - also includes code to harmonize summary statistics for the different GWASes to make it easier to run the other scripts. 
- **Data:** 
input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892), [Asian GWAS](https://jamanetwork.com/journals/jamaneurology/fullarticle/2764340), [Progression GWAS](https://ng.neurology.org/content/5/4/e348)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- gwas_risk_variants.csv
|   |-- genelist
|   |   |-- Loci_Gene_List.ipynb
|   |   |-- Harmonize_Summary_Statistics.ipynb
```


## 1) Harmonize the summary statistics for the different GWASes

### Run
* `Harmonize_Summary_Statistics.ipynb`

### Input
* summary statistics files

### Output
* cleaned summary statistics files

## 2) Get Gene Lists for All Risk Loci

### Run
* on biowulf 
* see `Loci_Gene_List.ipynb`
    * may need to update script if using different GWAS files

### Input
* `refFlat_HG19.txt` containing genes from hg19 reference genome.
* gwas summary statistic files. see the notebook

### Output
* an updated `genes_by_locus.csv` file containing all the genes 1 Mb up and downstream of each risk variant for all gwases relevant to the app
* an updated `gwas_risk_variants.csv` file containing all risk variants from all relevant gwases for the app