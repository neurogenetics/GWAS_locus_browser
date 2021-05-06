# Coding Variants

This section lists coding variants in linkage disequilibrium with one of the risk snps on this locus. Coding variants were collected from the IPDGC internal database which included imputed data from the [Haplotype Reference Consortium](http://www.haplotype-reference-consortium.org/home). Additional coding variants were collected from  [LDLink](https://ldlink.nci.nih.gov/?tab=home). Combined Annotation Dependent Depletion (CADD) scores were obtained using ANNOVAR to score the deleteriousness of single nucleotide variants. 

## HRC Coding Variants:
These include coding variants in high LD (r2>0.5) with a risk snp. Frequencies, AA Changes, and CADD scores were obtained from ANNOVAR. 

### Column Definitions:
* `LD (rsquared)` - r2 linkage disequilibrium value with the risk snp.
* `LD (D')` - d prime linkage disequilibrium value with the risk snp.
* `Frequency (Non-Finnish European)` - frequency of the coding variant in non-Finnish European populations.
* `AA Change` - the amino acid change(s) for the coding variant.
* `CADD (phred)` - the phred scaled combined annoatation dependent depletion score for this coding variant. Explanation [here](https://cadd.gs.washington.edu/info)

## LDLink Coding Variants:
These include coding variants from LDLINK. No LD cutoff was used for these variants. Minor allele frequency (MAF) was obtained from LDLink. AA Changes and CADD scores were obtained from ANNOVAR. Nalls et al 2019 and Iwaki et al 2019 coding variants used European population data. Foo et al 2020 coding variants used Asian population data. Coding variants that had no AA Change in ANNOVAR data were excluded.

### Column Definitions:
* `LD (rsquared)` - r2 linkage disequilibrium value with the risk snp.
* `LD (D')` - d prime linkage disequilibrium value with the risk snp.
* `MAF` - Minor allele frequency of the coding variant.
* `AA Change` - the amino acid change(s) for the coding variant.
* `CADD (phred)` - the phred scaled combined annoatation dependent depletion score for this coding variant. Explanation [here](https://cadd.gs.washington.edu/info)
