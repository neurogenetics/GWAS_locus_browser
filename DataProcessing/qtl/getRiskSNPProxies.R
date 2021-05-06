library(data.table)
library(dplyr)
library(LDlinkR)

gwas_risk_variants <- fread("$PATH/AppDataProcessing/gwas_risk_variants.csv")
dim(gwas_risk_variants)
head(gwas_risk_variants)


snps <- gwas_risk_variants$RSID

for( snp in snps)
{
  print(snp)
  proxies <- LDproxy(snp=snp,pop="EUR",r2d="r2",token="sometoken")
  
  high_r2_proxies <- proxies[which(proxies$R2>0.7),]
  
  write.csv(high_r2_proxies,paste0("$PATH/AppDataProcessing/qtl/proxy_snps/",snp,"_proxies.csv"),row.names=F,sep=",")
}