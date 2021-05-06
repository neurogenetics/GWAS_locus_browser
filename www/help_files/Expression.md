# Expression
Expression data was included from the [GTEx portal](https://www.gtexportal.org/home/datasets) and from single cell substantia nigra (SN) expression data ([GSE140231](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE140231), [Agarwal et al. 2020](https://www.biorxiv.org/content/10.1101/2020.04.29.067587v1.full)). Expression is measured in transcripts per million (TPM) in all datasets. GTEx data was averaged across all brain tissues and all substantia nigra tissues for each gene. The single cell RNA sequencing expression data was included for SN astrocytes, SN dopaminergic neurons, SN endothelial cells, SN GABAergic cells, SN microglial cells, SN oligodendrocyte cells (ODC) and SN oligodendrocyte progenitor cells (OPC). 

We chose a cutoff value of 5 TPM to determine significant expression for genes. Genes with greater than 5 TPM in GTEx brain, GTEx SN, or single cell dopaminergic neuron data were given a value of 1 in the evidence per gene table (in the `Brain Expression`, `Nigra Expression` and `SN-Dop. Neuron Expression` columns respectively). Genes are given a value of 0 if less than 5 TPM, or NA if no data was available. High expression in the brain and substantia nigra (SN) could be interpreted as causal evidence because Parkinson's is considered a neurological disease. 

We also included barplots for the single cell data and violin plots for GTEx data in different tissues. 

## Column Definitions:
* `GTEX_BRAIN_all` - The average TPM across all brain tissues (including SN) for the gene in GTEx v8 data.
* `GTEX_nigra` - The average TPM across all SN tissues for the gene in GTEx v8 data. 
* `SN Astrocyte` - The average TPM expression in the single cell data for SN astrocytes. 
* `SN-Dop. Neuron` - The average TPM expression in single cell data for dopaminergic SN neurons.
* `SN Endothelial` - The average TPM expression in the single cell data for SN endothelial cells. 
* `SN-GABA Neuron` - The average TPM expression in the single cell data for SN GABAergic neurons. 
* `SN Microglia` - The average TPM expression in the single cell data for SN microglia. 
* `SN ODC` - The average TPM expression in the single cell data for SN oligodendrocyte cells. 
* `SN OPC` - The average TPM expression in the single cell data for SN oligodendrocyte progenitor cells. 
