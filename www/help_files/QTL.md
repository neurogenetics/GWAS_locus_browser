# QTL Evidence

This section combines expression quantitative trait locus (eQTL) data and genome wide association study (GWAS) data to create [locus compare](http://locuscompare.com/) plots. Variants were obtained from all available eQTL datasets for each gene. Variants also present in GWAS data were used to create locus compare plots. These plots consist of an eQTL manhattan plot (top right), a GWAS manhattan plot (bottom right), and a locus compare plot (left). Locus compare plots include eQTL data on the x-axis and GWAS data on the y-axis. A similar distribution or correlation between eQTL and GWAS data suggests causality. 

### QTL-Scoring
This section has three columns in the evidence per gene table, each scored a different way. 

#### QTL-brain
This is scored as 1 if the gene has a locus compare plot from [PsychENCODE](https://science.sciencemag.org/content/362/6420/eaat8464) eQTL data, [PsychENCODE](https://science.sciencemag.org/content/362/6420/eaat8464) isoQTL data, [Qi et al.](https://www.nature.com/articles/s41467-018-04558-1) eQTL data, or [Sieberts et al.](https://pubmed.ncbi.nlm.nih.gov/33046718/) cortex eQTL data that has 30 or more variants and includes the risk variant or a proxy variant with r2 > 0.7. The browser only includes plots that meet these criteria. 

#### eQTL-blood
This is scored as 1 if the gene has a locus compare plot from [Vosa et al.](https://www.biorxiv.org/content/10.1101/447367v1) eQTL data that has 30 or more variants and includes the risk variant or a proxy variant with r2 > 0.7. The browser only includes plots that meet these criteria.  

#### QTL-correl
This is scored as 1 if the gene has significant correlation between GWAS and eQTL/isoQTL data in any of the locus compare plots with a QTL-brain or eQTL-blood score of 1. Users may use the `Correlation Cutoff` input to use their own cutoff value. The default setting uses a Pearsons's correlation coefficient cutoff of 0.3, but this can be adjusted by the user. QTL-correl is scored as 1 if the absolute value of the correlation coefficient is greater than the assigned cutoff. 0 if less than and NA if no relevant plots exist. 

### Locus Compare Plot Data
Users may choose a gene to view locus compare plots available for the gene and statistics for the plots. Table values are bolded if they contribute to the QTL-brain score (plot has more than 30 SNPs and a risk/proxy variant), eQTL-blood score (plot has more than 30 SNPs and a risk/proxy variant), or QTL-correl score (absolute value of the correlation is greater than the input cutoff value).

#### Column Definitions:
* `Plot` - the selected plot
* `Gene` - the selected gene
* `Transcript` - the selected transcript, which only applies to isoform QTLs (isoQTL).
* `Risk Variant` - the selected risk variant. Ideally, significant plots will include this in the upper right hand corner of the locus compare plot.
* `Proxy Variant` - the rs ID of a proxy variant in linkage disequilibrium with the risk variant (with r2 > 0.7). This may include the risk variant. All plots should have a value here.
* `Proxy Variant r2` - the r2 linkage disequilibrium value for the proxy variant. This is equal to 1 if the proxy variant is the same as the risk variant. All plots should have a value here.
* `Correlation` - Pearson's correlation coefficient for the locus compare plot. Under default settings significant values of will have an absolute value that is greater than 0.3. 
* `QTL-brain Score` - Used to score the `QTL-brain` column in the evidence per gene table. 
* `eQTL-blood Score` - Used to score the `eQTL-blood` column in the evidence per gene table. 
* `QTL-correl Score` - Score for the plot from each gene based on the `Correlation Cutoff` user input. Used to score the `QTL-correl` column in the evidence per gene table. 
