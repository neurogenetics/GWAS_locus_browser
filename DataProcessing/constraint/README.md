# GWAS Locus Browser Constraint Script
- **Author** - Frank Grenn
- **Date Started** - November 2019
- **Quick Description:** format constraint gene data for app
- **Data:** 
input files obtained from: [gnomAD](https://gnomad.broadinstitute.org/downloads)

## Layout
```
|-- AppDataProcessing
|   |-- genes_by_locus.csv
|   |-- constraint
|   |   |-- ReadConstraintValuesScript.py
|   |   |-- gnomad.v2.1.1.lof_metrics.by_gene.txt
|   |-- results
|   |   |-- ConstraintData.csv
|   |-- evidence
|   |   |-- evidence_constraint.csv
```

## Run
* locally or biowulf 
* `python constraint/ReadConstraintValuesScript.py`

## Input
* a `genes_by_locus.csv` file in the parent directory containing all genes of interest and their locus number
* a `gnomad.v2.1.1.lof_metrics.by_gene.txt` containing constraint/intolerance statistics from gnomAD

## Output
* a `ConstraintData.csv` file in the `results` folder containing z scores, pLi, o/e values, and o/e CIs for all genes of interest
* a `evidence_constraint.csv` file in the `evidence` folder that marks genes with a upper limit CI < 0.35 as one