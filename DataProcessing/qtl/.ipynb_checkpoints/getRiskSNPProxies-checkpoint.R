# # Generate Risk SNP Proxy Data
# - **Author(s)** - Frank Grenn
# - **Date Started** - March 2020
# - **Quick Description:** create a file for each risk snp containing a list of proxy snps (snps that are in high ld with the risk snp)

library(data.table)
library(dplyr)
library(LDlinkR)

meta5_data <- fread("$PATH1/GWAS_loci_overview.csv")
meta5_data <- meta5_data %>% select("Locus Number", "SNP", "CHR")
prog_data <- fread("$PATH1/ProgressionLoci.csv")
prog_data <- prog_data %>% select("Locus Number", "RSID", "CHR")
colnames(prog_data) <- c("Locus Number", "SNP","CHR")

#combine all the rsids to one df
variant_data <- rbind(meta5_data, prog_data)

snps <- variant_data$SNP

for( snp in snps)
{
  print(snp)
  proxies <- LDproxy(snp=snp,pop="EUR",r2d="r2",token="1b308e35a979")
  
  high_r2_proxies <- proxies[which(proxies$R2>0.7),]
  
  write.csv(high_r2_proxies,paste0("$PATH1/qtl/proxy_snps/",snp,"_proxies.csv"),row.names=F,sep=",")
}