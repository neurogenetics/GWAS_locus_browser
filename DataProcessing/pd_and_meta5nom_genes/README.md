# GWAS Locus Browser PD Genes and META5 Nominated Genes Scripts
- **Author** - Frank Grenn
- **Date Started** - October 2019
- **Quick Description:** get the list of known PD genes and give them an evidence score. Also score the genes nominated as potentially causal in the Nalls et al. 2019 PD Risk GWAS. 
- **Data:** 
list of PD genes obtained by Cornelis Blauwendraat. Movement disorder genes obtained from https://www.mdsgene.org/g4d.

## Layout
```
|-- AppDataProcessing
|   |-- pd_and_meta5nom_genes
|   |   |-- PDMETA5GeneEvidenceScript.py
|   |   |-- PD_Genes.csv
|   |   |-- MDSGenes.csv
|   |   |-- meta5nomgene.csv
|   |   |-- pd_genes_for_app.csv
```

## Run
* locally or biowulf 
* `python pd_and_meta5nom_genes/PDMETA5GeneEvidenceScript.py`

## Input
* a `MDSGenes.csv` file containing all the Movement Disorder genes and their disorders
* a `meta5nomgene.csv` file containing all the Nalls et al. 2019 META5 nominated genes
* a `PD_Genes.csv` file containing all the PD genes we want to score

## Output
* a `pd_genes_for_app.csv` file listing the META5 nominated genes and PD genes