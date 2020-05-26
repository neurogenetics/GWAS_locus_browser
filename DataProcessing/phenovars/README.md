# GWAS Locus Browser Associated Variant Phenotypes Scripts
- **Author** - Frank Grenn and Cornelis Blauwendraat
- **Date Started** - December 2019
- **Quick Description:** scripts to get associated variant phenotype data including LD values and frequencies.
- **Data:** - [GWAS Catalog](https://www.ebi.ac.uk/gwas/docs/file-downloads)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- gwas_risk_variants.csv
|   |-- phenovars
|   |   |-- get_pheno_vars_file.ipynb
|   |   |-- GWAS_catalogv1.0.2-associations.txt
|   |   |-- LD
|   |   |   |-- out
|   |   |   |   |-- 6:30108683_6:30139699.log
|   |   |   |   |-- 20:6006041_20:6011934.log
|   |   |   |   |-- ...
|   |   |   |-- CalculateLD.ipynb
|   |   |   |-- calculateLD.swarm
|   |   |   |-- Variants.csv
|   |   |   |-- ranges.txt
|   |   |-- phenovars.avinput
|   |   |-- phenovars.avinput.hg19_gnomad_genome_dropped
|   |   |-- phenovars.avinput.hg19_gnomad_genome_filtered
|   |   |-- ...
|   |-- results
|   |   |-- PhenotypeVariantData.csv
|   |   |-- PhenotypeVariantLD.csv
```

---


## Run
* on biowulf
* run  code in `get_pheno_vars_file.ipynb`

## Input
* `gwas_risk_variants.csv` for all risk variant info from all relevant gwas
* `GWAS_catalogv1.0.2-associations.txt` for associated disease info
* plink binaries for ld data

## Output
* `results/PhenotypeVariantData.csv` holding data for all relevant phenotype variants to be shown in the app
* `results/PhenotypeVariantLD.csv` containing LD data specific to loci variants for all phenotype variants to be shown in the app 
* multiple intermediate files, see `get_pheno_vars_file.ipynb` notebook
