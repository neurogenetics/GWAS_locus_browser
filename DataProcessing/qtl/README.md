# GWAS Locus Browser QTL Locus Compare Plots Scripts
- **Author** - Frank Grenn and Hirotaka Iwaki
- **Date Started** - October 2019
- **Quick Description:** code to generate Locus Compare eQTL plots for brain and blood tissues from various datasets
- **Data:** [brain eQTL](https://cnsgenomics.com/software/smr/#DataResource), [blood eQTL](https://www.eqtlgen.org/cis-eqtls.html), [psychENCODE](http://resource.psychencode.org/)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- qtl
|   |   |-- QTL_Generate_Data.ipynb
|   |   |-- QTL_Proxy_SNPs.ipynb
|   |   |-- getRiskSNPProxies.R
|   |   |-- blood_brain_eQTL_plot.R
|   |   |-- QTLEvidenceScore.R
|   |   |-- plots_to_plot.csv
|   |   |-- script
|   |   |   |-- generate_brain_eqtl.swarm
|   |   |   |-- swarm_50209006_0.o
|   |   |   |-- swarm_50209006_0.e
|   |   |   |-- ...
|   |   |-- tsv
|   |   |   |-- ADAM15_brain_gwas.tsv
|   |   |   |-- ADAM15_brain_eqtl.tsv
|   |   |   |-- ADAM15_blood_gwas.tsv
|   |   |   |-- ADAM15_blood_eqtl.tsv
|   |   |   |-- ...
|   |   |-- proxy_snps
|   |   |   |-- rs382940_proxies.csv
|   |   |   |-- ...
|   |   |-- eBrain
|   |   |   |-- ARIH2.png
|   |   |   |-- ...
|   |   |-- eBlood
|   |   |   |-- ARIH2.png
|   |   |   |-- ...
|   |   |-- QTL_Generate_Data_Psychencode.ipynb
|   |   |-- eQTL_Proxy_SNPs_Psychencode.ipynb
|   |   |-- isoQTL_Proxy_SNPs_Psychencode.ipynb
|   |   |-- QTL_Generate_Data_Psychencode.ipynb
|   |   |-- psychencode_eQTL_plot.R
|   |   |-- psychencode_isoQTL_plot.R
|   |   |-- psychencode
|   |   |   |-- isoqtl_plots_to_plot.csv
|   |   |   |-- eqtl_plots_to_plot.csv
|   |   |   |-- DER-08a_hg19_eQTL.significant.txt
|   |   |   |-- DER-09_hg19_cQTL.significant.txt
|   |   |   |-- DER-10b_hg19_isoQTL.FPKM5.all.txt
|   |   |   |-- DER-11_hg19_fQTL.significant.txt
|   |   |   |-- DER-12_hg19_multiQTL.list.txt
|   |   |   |-- isoqtl_tsv
|   |   |   |   |-- meta5
|   |   |   |   |   |-- ABCC5_ENST00000443497_gwas.tsv
|   |   |   |   |   |-- ABCC5_ENST00000443497_isoqtl.tsv
|   |   |   |   |   |-- ...
|   |   |   |   |-- prog1
|   |   |   |   |   |-- ...
|   |   |   |   |-- prog2
|   |   |   |   |   |-- ...
|   |   |   |-- eqtl_tsv
|   |   |   |   |-- meta5
|   |   |   |   |   |-- AADAC_eqtl.tsv
|   |   |   |   |   |-- AADAC_gwasl.tsv
|   |   |   |   |   |-- ...
|   |   |   |   |-- prog1
|   |   |   |   |   |-- ...
|   |   |   |   |-- prog2
|   |   |   |   |   |-- ...
```

---

## 1) Generate data and plots for Qi et al. and Vosa et al. eQTL data

### a) Generate TSVs for each gene of interest

#### Run
* on biowulf
* run code in `QTL_Generate_Data.ipynb`
    * notebook has code to generate data for only one gene, like cases where the gwas gene name doesn't match up with the eqtl gene name
* Note: this may need to be run a couple times to generate data for meta5 genes and progression genes separately. Details should be in the notebook

#### Input
* see the notebook

#### Output
* a tsv file per gene and feature in the `tsv` folder

---

### b) Idenitfy what plots can be made with the data we have

#### Run
* on biowulf
* run code in `QTL_Proxy_SNPs.ipynb`
   * this will run `getRiskSNPProxies.R` to create a list of possible proxy snps for the risk variants
      * Note: this R script uses the LDlinkR library which needs a token to run. Can be obtained here: https://ldlink.nci.nih.gov/?tab=apiaccess

#### Input
* a see the notebook
#### Output
* multiple `plots_....csv` files containing data for the plots that can be made
* proxy snp files in the `proxy_snps` folder

---

### c) Generate the plots

#### Run
* locally 
* `nohup R CMD BATCH blood_brain_eQTL_plot.R output.log &`
* Note: some plots fail even after the attempted QC in 1) and 2) because locuscomapreR believes some plots have data for snps on different chromosomes (see the `output.log` after running)

#### Input
* a `plots_to_plot.csv` file listing the plots to create and the lead snps for each plot
* a `genes_by_locus.csv` file containing all genes of interest and their locus number
* a `GWAS loci overview.csv` file containing rsids for the meta5 risk variants
* a `ProgressionLoci.csv` file containing rsids for the progression risk variants
* the `eBrain` folder should be made
* the `eBlood` folder should be made
* the `tsv` folder and all the gene tsv files

#### Output
* all of the plots in the `eBrain` and `eBlood` folders
* a `plot_info.csv` containing data about the plots that were generated. This will be used in a later script for scoring. 
* `output.log` for logging

---

## 2) Generate data and plots for psychENCODE data

scripts are similar to the previous QTL scripts. Main difference is code for isoQTL plots needs to subset data by isoform, in addition to gene.
### a) Generate TSVs for each gene of interest

#### Run
* on biowulf
* run code in `QTL_Generate_Data_Psychencode.ipynb`
* Note: this may need to be run a couple times to generate data for meta5 genes and progression genes separately. Output path may need to be manually changed. Details in notebook. 

#### Input
* see the notebook

#### Output
* a tsv file per gene and dataset (eQTL and isoQTL) in the `psychencode` folder and its subdirectories

---

### b) Idenitfy what psychENCODE eQTL plots can be made with the data we have

#### Run
* on biowulf
* run code in `eQTL_Proxy_SNPs_Psychencode.ipynb`
   * this will run `getRiskSNPProxies.R` to create a list of possible proxy snps for the risk variants
      * Note: this R script uses the LDlinkR library which needs a token to run. Can be obtained here: https://ldlink.nci.nih.gov/?tab=apiaccess

#### Input
* a see the notebook
#### Output
* multiple `eqtl_plots_....csv` files containing data for the plots that can be made
* proxy snp files in the `proxy_snps` folder

---

### c) Idenitfy what psychENCODE isoQTL plots can be made with the data we have

#### Run
* on biowulf
* run code in `isoQTL_Proxy_SNPs_Psychencode.ipynb`
   * this will run `getRiskSNPProxies.R` to create a list of possible proxy snps for the risk variants
      * Note: this R script uses the LDlinkR library which needs a token to run. Can be obtained here: https://ldlink.nci.nih.gov/?tab=apiaccess

#### Input
* a see the notebook
#### Output
* multiple `isoqtl_plots_....csv` files containing data for the plots that can be made
* proxy snp files in the `proxy_snps` folder

---

### d) Generate the  psychENCODE eQTL plots

#### Run
* locally 
* `nohup R CMD BATCH psychencode_eQTL_plot.R output.log &`

#### Input
* a `eqtl_plots_to_plot.csv` file listing the plots to create and the lead snps for each plot
* a `genes_by_locus.csv` file containing all genes of interest and their locus number
* a `GWAS loci overview.csv` file containing rsids for the meta5 risk variants
* a `ProgressionLoci.csv` file containing rsids for the progression risk variants
* the `p_eQTL` folder should be made
* the `psychencode/eqtl_tsv` folder and all the gene tsv files

#### Output
* all of the plots in the `p_eQTL` folder
* a `psychencode_eqtl_plot_info.csv` containing data about the plots that were generated. This will be used in a later script for scoring. 
* `output.log` for logging

---

### e) Generate the  psychENCODE isoQTL plots

#### Run
* locally 
* `nohup R CMD BATCH psychencode_isoQTL_plot.R output.log &`

#### Input
* a `isoqtl_plots_to_plot.csv` file listing the plots to create and the lead snps for each plot
* a `genes_by_locus.csv` file containing all genes of interest and their locus number
* a `GWAS loci overview.csv` file containing rsids for the meta5 risk variants
* a `ProgressionLoci.csv` file containing rsids for the progression risk variants
* the `p_isoQTL` folder should be made
* the `psychencode/isoqtl_tsv` folder and all the gene tsv files

#### Output
* all of the plots in the `p_isoQTL` folder
* a `psychencode_isoqtl_plot_info.csv` containing data about the plots that were generated. This will be used in a later script for scoring. 
* `output.log` for logging

---

## 3) Score the eQTL Data for the evidence table in the app

### Run
* locally
* run code in `QTLEvidenceScore.R`

### Input
* `plot_info.csv`
* `psychencode_isoqtl_plot_info.csv`
* `psychencode_eqtl_plot_info.csv`

### Output
* a `evidence_qtl.csv` folder containing the scores for all genes


