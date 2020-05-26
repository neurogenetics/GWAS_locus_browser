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
|   |   |-- QTL_Generate_Data_Psychencode.ipynb
|   |   |-- QTL_Proxy_SNPs_And_Plot_Info.ipynb
|   |   |-- getRiskSNPProxies.R
|   |   |-- plot_qtl_locuscompare.R
|   |   |-- plots_to_plot.csv
|   |   |-- all_qtl_info.csv
|   |   |-- script
|   |   |   |-- generate_brain_eqtl.swarm
|   |   |   |-- swarm_50209006_0.o
|   |   |   |-- swarm_50209006_0.e
|   |   |   |-- ...
|   |   |-- tsv
|   |   |   |-- META5
|   |   |   |   |-- ADAM15_brain_gwas.tsv
|   |   |   |   |-- ADAM15_brain_eqtl.tsv
|   |   |   |   |-- ...
|   |   |   |-- Progression
|   |   |   |   |-- ...
|   |   |   |-- Asian
|   |   |   |   |-- ...
|   |   |-- proxy_snps
|   |   |   |-- rs382940_proxies.csv
|   |   |   |-- ...

```

---

## 1) Generate data for plots from Qi et al. and Vosa et al. eQTL data

### Run
* on biowulf
* run code in `QTL_Generate_Data.ipynb`
    * notebook has code to generate data for only one gene, like cases where the gwas gene name doesn't match up with the eqtl gene name
* Note: this needs to be modified and run for each GWAS. Details should be in the notebook

### Input
* see the notebook

### Output
* a tsv file per gene and feature in the `tsv` folder

---

## 2) Generate data for plots from the PsychENCODE data

### Run
* on biowulf
* run code in `QTL_Generate_Data_Psychencode.ipynb`
    * notebook has code to generate data for only one gene, like cases where the gwas gene name doesn't match up with the eqtl gene name
* Note: this needs to be modified and run for each GWAS. Details should be in the notebook

### Input
* see the notebook

### Output
* a tsv file per gene and feature in the `tsv` folder

---

## 3) Idenitfy what plots can be made with the data we have

### Run
* on biowulf
* run code in `QTL_Proxy_SNPs_And_Plot_Info.ipynb`
   * this will run `getRiskSNPProxies.R` to create a list of possible proxy snps for the risk variants
      * Note: this R script uses the LDlinkR library which needs a token to run. Can be obtained here: https://ldlink.nci.nih.gov/?tab=apiaccess

### Input
* a see the notebook

### Output
* multiple `all_qtl_info.csv` files containing data for the plots that can be made
* proxy snp files in the `proxy_snps` folder

---

## 4) Generate the plots

### Run
* locally 
* `nohup R CMD BATCH plot_qtl_locuscompare.R output.log &`
* Note: some plots fail even after the attempted QC in 1), 2), and 3) because locuscomapreR reports that some plots have data for snps on different chromosomes (see the `output.log` after running)

### Input
* a `all_qtl_info.csv` file listing the plots to create and the lead snps for each plot
* a `genes_by_locus.csv` file containing all genes of interest and their locus number
* a `gwas_risk_variants.csv` file containing all risk variants
* the `tsv` folder and all the gene tsv files

### Output
* all of the plots in in files separated by dataset
* a `all_qtl_info_new.csv` containing data about the plots that were generated. This will be displayed in the app

---