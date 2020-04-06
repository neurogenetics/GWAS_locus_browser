# GWAS Locus Browser Locus Zoom Scripts
- **Author** - Frank Grenn
- **Date Started** - June 2019
- **Quick Description:** scripts to generate locus zoom pdf and convert them to pngs. Also contains code to generate json files for interactive locus zoom.
- **Data:** 
input files obtained from:   
[META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892) and [PD Progression](https://movementdisorders.onlinelibrary.wiley.com/doi/full/10.1002/mds.27845)  
tools:  
[Static Locus Zoom](http://locuszoom.org/)  
[Interactive Locus Zoom](https://github.com/statgen/locuszoom/wiki)  

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- GWAS_loci_overview.csv
|   |-- locuszoom
|   |   |-- make_interactive_stats.ipynb
|   |   |-- PdfMagick.sh
|   |   |-- hitSpec_1MB_flank.txt
|   |   |-- resultsForSmr_filtered.tab
|   |   |-- reference.txt
|   |   |-- surv_HY3.txt
|   |   |-- base_INS.txt
|   |   |-- reference.txt
|   |   |-- interactive_stats
|   |   |   |-- rs123456789_locus.json
|   |   |   |-- ...
|   |   |-- LocusZoomPdfs
|   |   |   |-- 191010_rs123456789.pdf
|   |   |   |-- ...
|   |   |-- LocusZoomPngs
|   |   |   |-- rs123456789.png
|   |   |   |-- ...
```

---

## 1) Generate Static Locus Zoom Pdfs

### Run
* biowulf
* load the locuszoom module
* can run using (a) their server, (b) as a batch job, (c) or one plot at a time.

#### (a) Locus Zoom Server (can be unreliable)
* need to generate a hitspec file (`hitSpec_1MB_flank.txt`) containing locus zoom parameters 
    * see [the wiki](https://genome.sph.umich.edu/wiki/LocusZoom) and [the command descriptions](https://genome.sph.umich.edu/wiki/LocusZoom_Standalone#Plotting_options) for options
* [submit data here](http://locuszoom.org/genform.php?type=hitspecdata)
   * for Plot Data use something like `resultsForSmr_filtered.tab.gz`
   * p value and marker column names must match the column names in the Plot Data file

#### (b) Batch Job
* need to generate a hitspec file (`hitSpec_1MB_flank.txt`) containing locus zoom parameters 
    * see [the wiki](https://genome.sph.umich.edu/wiki/LocusZoom) and [the command descriptions](https://genome.sph.umich.edu/wiki/LocusZoom_Standalone#Plotting_options) for options
* then run a job containing something similar to `locuszoom --metal resultsForSmr_filtered.tab.gz --pvalcol p --markercol SNP --hitspec hitSpec_500kb_flank.txt --pop EUR --build hg19 --source 1000G_March2012 --plotonly`

#### (c) Single Plot
* run a job containing something similar to `locuszoom --metal LocusZoom/resultsForSmr_filtered.tab.gz --pvalcol p --markercol SNP --refsnp rs114138760 --flank 500kb --pop EUR --build hg19 --source 1000G_March2012 --plotonly height=10 rfrows=20 showRecomb=TRUE geneFontSize=.4`

### Input
* a `resultsForSmr_filtered.tab` containing the snps and loci we want to plot
* a `hitSpec_1MB_flank.txt` file containing parameters for locus zoom plot generation

### Output
* pdfs of locus zoom plots

---

## 2) Convert Locus Zoom Pdfs to Pngs (pngs easier to display in R shiny apps)

### Run
* biowulf
* `sbatch PdfMagick.sh`

### Input
* a `LocusZoomPdfs` folder containing all of the pdfs we want to convert to pngs

### Output
* all the pdfs converted to pngs placed in the `LocusZoomPngs` folder

---

## 3) Prep jsons for Interactive Locus Zoom Input

### Run
* biowulf 
* see `make_interactive_stats.ipynb`

### Input
* a `resultsForSmr_filtered.tab` containing the snps and loci data we want to reformat
* a `GWAS_loci_overview.csv` containing the risk variant rsids and basepair positions of the risk variants we will create jsons for to eventually plot with interactive locus zoom. 
* data for other risk variants to plot, like the progression loci (`reference.txt`, `base_INS.txt`, and `surv_HY3.txt`)

### Output
* json files in the `interactive_stats` folder