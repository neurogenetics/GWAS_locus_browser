#!/bin/bash

module load annovar

#made the input file containing the variants we want (chr, start, end, ref, alt)
awk -F"," '{print $4,$5,$6,$7,$8}' 'Variant in other GWAS - Sheet1.csv' > phenovars.avinput

#use  annovar to get the frequencies
annotate_variation.pl --filter --build hg19 --dbtype gnomad_genome --buildver hg19 --otherinfo phenovars.avinput $ANNOVAR_DATA/hg19