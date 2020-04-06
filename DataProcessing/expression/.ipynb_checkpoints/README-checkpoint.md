# GWAS Locus Browser Expression Scripts
- **Author(s)** - Frank Grenn and Anastasia Illarionova
- **Date Started** - June 2019
- **Quick Description:** scripts to average expression data per gene and generate plots from data
- **Data:** 
input files obtained from: [Single Cell SN Data](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE140231), [GTEX Data](https://www.gtexportal.org/home/datasets)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- expression
|   |   |-- ReadExpressionValuesScript.R
|   |   |-- generateSingleCellPlots.R
|   |   |-- GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct
|   |   |-- GTEX_sample_names_v8.txt
|   |   |-- Nigra_Mean_Cell_GABA_type.txt
|   |   |-- Nigra_Samples_v8.txt
|   |   |-- GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt
|   |   |-- exp_violin_plots.R
|   |   |-- GTEx_barplots_gwas_genes.R
|   |   |-- gtex_gwas_tissue.csv
|   |-- results
|   |   |-- ExpressionData.csv
|   |   |-- plots
|   |   |   |-- expression
|   |   |   |   |-- AADAC_sc_expression.png
|   |   |   |   |-- ...
|   |-- evidence
|   |   |-- evidence_expression.csv
```
## 1) Get expression averages per gene and score

### Run
* on biowulf 
* `Rscript expression/ReadExpressionValuesScript.R`

### Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
* a `GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct` containing GTEX expression data
* a `GTEX_sample_names_v8.txt` file containing sample names and tissue types
* a `Nigra_Mean_Cell_GABA_type.txt` file containing single cell data for the genes
* a `Nigra_Samples_v8.txt` file containing sample names of substantia nigra tissues (obtained by using grep with "nigra" on `GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt` to get the nigra samples)

### Output
* a `ExpressionData.csv` file in the `results` folder containing the average expression data for genes
* a `evidence_expression.csv` file in the `evidence` folder containing the gene expression scores

## 2) Generate Single Cell Expression Plots

### Run
* locally or biowulf
* `Rscript expression/generateSingleCellPlots.R`

### Input
* a `Nigra_Mean_Cell_GABA_type.txt` file containing single cell data for the genes

### Output
* plots per gene in the `results/plots/expression` folder

## 3) GTEX Violin Plot Scripts

### Run
* locally
* run `exp_violin_plots.R` or `GTEx_barplots_gwas_genes.R`
   * may need to modify code in scripts

### Input
* a `gtex_gwas_tissue.csv` file containing single cell data for the genes

### Output
* violin plots per gene