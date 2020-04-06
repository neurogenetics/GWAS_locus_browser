#!/bin/bash

#Frank Grenn
#January 2020



module load annovar

#made the input file containing the variants we want (chr, start, end, ref, alt)
awk -F"," '{print $2,$3,$4,$6,$7}' 'CodingVariant.csv' > codingvars.avinput

#use  annovar to get the frequencies
annotate_variation.pl --filter --build hg19 --dbtype cadd --buildver hg19 --otherinfo codingvars.avinput $ANNOVAR_DATA/hg19
