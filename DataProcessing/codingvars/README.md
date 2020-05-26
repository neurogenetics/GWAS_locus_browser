# GWAS Locus Browser Coding Variants Script
- **Author** - Frank Grenn and Cornelis Blauwendraat
- **Date Started** - December 2019
- **Quick Description:** scripts to get coding variant data including CADD scores, LD values and frequencies.
- **Data:** - [GWAS Catalog](https://www.ebi.ac.uk/gwas/docs/file-downloads)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- gwas_risk_variants.csv
|   |-- codingvars
|   |   |-- get_coding_vars_file.ipynb
|   |   |-- ALL_TAGS.txt
|   |   |-- annotated_R05_tags_all_gwas.txt
|   |   |-- CodingVariant.csv
|   |   |-- LD
|   |   |   |-- out
|   |   |   |   |-- 6:30108683_6:30139699.log
|   |   |   |   |-- 20:6006041_20:6011934.log
|   |   |   |   |-- ...
|   |   |   |-- calculateLD.swarm
|   |   |   |-- ranges.txt
|   |   |-- codingvars.avinput
|   |   |-- codingvars.avinput.hg19_cadd_dropped
|   |   |-- codingvars.avinput.hg19_cadd_filtered
|   |   |-- codingvars.avinput.hg19_gnomad_genome_dropped
|   |   |-- codingvars.avinput.hg19_gnomad_genome_filtered
|   |   |-- ...
|   |-- results
|   |   |-- CodingVariants.csv
|   |   |-- CodingVariantLD.csv
|   |-- phenovars
|   |   |-- GWAS_catalogv1.0.2-associations.txt

```

---

## Run
* on biowulf
* run code in `get_coding_vars_file.ipynb`

## Input
* `gwas_risk_variants.csv` for all risk variant info from all relevant gwas
* `GWAS_catalogv1.0.2-associations.txt` for associated disease info
* plink binaries for ld data


## Output
* `results/CodingVariants.csv` holding data for all relevant coding variants to be shown in the app
* `results/CodingVariantLD.csv` containing LD data specific to loci variants for all coding variants to be shown in the app 
* multiple intermediate files, see `get_coding_vars_file.ipynb` notebook
