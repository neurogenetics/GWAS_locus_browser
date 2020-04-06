# GWAS Locus Browser Disease Gene Script
- **Author** - Frank Grenn
- **Date Started** - October 2019
- **Quick Description:** format disease gene data from HGMD and OMIM for app.
- **Data:** 
obtained from: [OMIM](https://www.omim.org/) and [HGMD](http://www.hgmd.cf.ac.uk/ac/index.php)
input files organized by Cornelis Blauwendraat, Monica Diez-Fairen, Frank Grenn

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- diseasegene
|   |   |-- DiseaseGeneEvidenceScript.py
|   |   |-- HGMD_gene_pheno.csv
|   |   |-- OMIM_gene_pheno.csv
|   |-- results
|   |   |-- DiseaseGeneData.txt
|   |-- evidence
|   |   |-- evidence_diseasegenes.csv
```

## Run
* locally or biowulf 
* `python diseasegenes/DiseaseGeneEvidenceScript.py`

## Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
* a `HGMD_gene_pheno.csv` file containing `PHENO` and `GENE` columns
* a `OMIM_gene_pheno.csv` file containing `PHENO`, `GENE`, `OMIM` and `Inheritance` columns

## Output
* a `DiseaseGeneData.txt` file in the `results` folder containing combined OMIM and HGMD disease gene text for each gene of interest
* a `evidence_diseasegenes.csv` file in the `evidence` folder that marks genes with disease gene data with one