# Data Processing
* each folder is loosely associated with a section in the browser
* each folder contains data and scripts to run locally or on biowulf
* output of most scripts will go to the `results` folder
* output for most evidence scores will go to the `evidence` folder
* Most scripts use at least one of these two files:
  * `genes_by_locus.csv` - contains all the genes 1Mb up and downstream of each risk variant in the browser.
  * `gwas_risk_variants.csv` - contains all of the risk variants used in the browser.