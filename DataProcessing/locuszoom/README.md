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
|   |-- locuszoom
|   |   |-- make_interactive_stats.ipynb
|   |   |-- static_locus_zoom_plots.ipynb
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

## 1) Generate Static Locus Zoom Plots

### Run
* biowulf
* `static_locus_zoom_plots.ipynb`
  * may need to change code if using different GWAS data

### Input
* GWAS summary statistics. see notebook

### Output
* pdfs and pngs of locus zoom plots

---

## 2) Prep jsons for Interactive Locus Zoom Input

### Run
* biowulf 
* see `make_interactive_stats.ipynb`

### Input
* GWAS summary statistics. see notebook

### Output
* json files in the `interactive_stats` folder