# GWAS Locus Browser Pubmed Scripts
- **Author** - Frank Grenn
- **Date Started** - July 2019
- **Quick Description:** scripts to get pubmed literature hits per gene, generate word clouds and scrape geneCards info for each gene

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- pubmed
|   |   |-- LiteraturePlotsAndValuesScript.R
|   |   |-- GeneCardsScrape.R
|   |   |-- GeneCardDescriptions.txt
|   |   |-- GenerateWordCloudPlots.R
|   |-- results
|   |   |-- PubmedHitsData.csv
|   |   |-- plots
|   |   |   |-- wordcloud
|   |   |   |   |-- ABCB9_wordcloud.png
|   |   |   |   |-- ...
|   |-- evidence
|   |   |-- evidence_literature.csv
```

## 1) Generate pubmed hit data

### Run
* locally
* `Rscript pubmed/LiterraturePlotsAndValuesScript.R`
   * parts of script may need to be run separately 

### Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number

### Output
* a `evidence_literature.csv` file in the `evidence` containing scores for all genes
* plots in the `plots` folder
* a `PubmedHitsData.csv` containing the number of hits per gene

---

## 2) Generate word cloud plots

### Run
* locally
* `Rscript pubmed/GenerateWordCloudPlots.R`

### Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number

### Output
* word cloud plots

---

## 3) Scrape geneCards gene descriptions

### Run
* locally
* `Rscript pubmed/GeneCardsScrape.R`
   * may take a while to run for all genes

### Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number

### Output
* `GeneCardDescriptions.txt` containing the descriptions


