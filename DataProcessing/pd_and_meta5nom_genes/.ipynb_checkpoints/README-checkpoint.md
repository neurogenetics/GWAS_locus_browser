# GWAS Locus Browser PD Genes Script
- **Author** - Frank Grenn
- **Date Started** - October 2019
- **Quick Description:** get the list of known PD genes and give them an evidence score
- **Data:** 
list of PD genes obtained by Cornelis Blauwendraat

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- pdgenes
|   |   |-- PDGeneEvidenceScript.py
|   |   |-- PD_Genes.csv
|   |-- evidence
|   |   |-- evidence_pdgenes.csv
```

## Run
* locally or biowulf 
* `python pdgenes/PDGeneEvidenceScript.py`

## Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
* a `PD_Genes.csv` file containing all the PD genes we want to score

## Output
* a `evidence_pdgenes.csv` file in the `evidence` folder containing all the genes and with PD genes marked with one