# GWAS Locus Browser QTL Locus Compare Plots Scripts (WIP)
- **Author** - Frank Grenn and and Hirotaka Iwaki
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
```

---

## )1 Generate data and plots for Qi et al. and Vosa et al. eQTL data

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
