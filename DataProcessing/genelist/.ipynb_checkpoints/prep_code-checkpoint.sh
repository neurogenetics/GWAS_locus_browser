# # GWAS Locus Browser Gene List Scripts (WIP)
# - **Author** - Cornelis Blauwendraat
# - **Date Started** - June 2019
# - **Quick Description:** get all genes 1 Mb up and downstream of each risk variant. also includes code to get summary stats (including rsids) for risk variants.
# - **Data:** 
# input files obtained from: [META5](https://www.ncbi.nlm.nih.gov/pubmed/31701892)


#### check number of genes per GWAS locus

refFlat_HG19.txt
cut -f 3,5,6 refFlat_HG19.txt > part1.txt
cut -f 1,2 refFlat_HG19.txt > part2.txt
paste part1.txt part2.txt > refFlat_HG19.bed 

GWAS.bed 
file from META5 each locus with 1Mb + and 1Mb -

# biowulf
module load bedtools

cd $PATH1

intersectBed -a GWAS.bed -b refFlat_HG19.bed -wb > META5_genes.txt

# to get number of genes per locus
awk '$5 == 1' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 2' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 3' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 4' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 5' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 6' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 7' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 8' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 9' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 10' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 11' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 12' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 13' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 14' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 15' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 16' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 17' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 18' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 19' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 20' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 21' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 22' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 23' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 24' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 25' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 26' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 27' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 28' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 29' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 30' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 31' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 32' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 33' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 34' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 35' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 36' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 37' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 38' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 39' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 40' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 41' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 42' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 43' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 44' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 45' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 46' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 47' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 48' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 49' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 50' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 51' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 52' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 53' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 54' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 55' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 56' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 57' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 58' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 59' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 60' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 61' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 62' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 63' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 64' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 65' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 66' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 67' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 68' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 69' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 70' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 71' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 72' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 73' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 74' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 75' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 76' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 77' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp
awk '$5 == 78' META5_genes.txt | cut -f 9 | sort -u | wc -l >> temp


# to get actual genes per locus
awk '$5 == 1' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 2' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 3' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 4' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 5' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 6' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 7' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 8' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 9' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 10' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 11' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 12' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 13' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 14' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 15' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 16' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 17' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 18' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 19' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 20' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 21' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 22' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 23' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 24' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 25' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 26' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 27' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 28' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 29' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 30' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 31' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 32' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 33' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 34' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 35' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 36' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 37' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 38' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 39' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 40' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 41' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 42' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 43' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 44' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 45' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 46' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 47' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 48' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 49' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 50' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 51' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 52' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 53' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 54' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 55' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 56' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 57' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 58' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 59' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 60' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 61' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 62' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 63' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 64' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 65' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 66' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 67' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 68' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 69' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 70' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 71' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 72' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 73' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 74' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 75' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 76' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 77' META5_genes.txt | cut -f 5,9 | sort -u  >> temp
awk '$5 == 78' META5_genes.txt | cut -f 5,9 | sort -u  >> temp



# prep sumstats
module load R
cd $PATH2/summary_stats/
require("data.table")
data <- fread("META5_no23.tbl.gz")
newdata <- subset(data, Freq1 > 0.01 & HetDf > 6)
data2 <- fread("$PATH3/HRC_RS_conversion_final_with_CHR.txt")
MM = merge(newdata,data2,by.x='MarkerName',by.y='CHR:POS',all.x = TRUE)
dim(data)
dim(data2)
dim(MM)
write.table(MM, file="META5_no23_with_rsids.txt", quote=FALSE,row.names=F,sep="\t")
q()
n
cut -f 1-15,17 META5_no23_with_rsids.txt > META5_no23_with_rsids2.txt
rm META5_no23_with_rsids.txt












