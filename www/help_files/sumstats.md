# Summary Statistics  

Summary statistics for the selected variant from the selected GWAS. Population frequencies were obtained from [gnomAD](https://gnomad.broadinstitute.org/) using gnomAD v2.1.1 genome data. Summary statistics for selected variants were also obtained from other relevant Parkinson's Disease GWAS for comparison where data was available. 

Frequencies, beta values and odds ratios were recalculated to match the minor effect allele for each risk variant. 


## Column Definitions:
* `Frequency_PD` - generated with PLINK `--assoc` option. Gives the frequency of effect allele in cases.
* `Frequency_control` - generated with the PLINK `--assoc` option. Gives the frequency of effect allele in controls.
* `AFF` - generated with the PLINK `--model` option. Genotypic counts in cases are formatted as: Homozygous alternative/Heterozygous/Homozygous reference. 
* `UNAFF` - generated with the PLINK `--model` option. Genotypic counts in controls are formatted as: Homozygous alternative/Heterozygous/Homozygous reference. 
