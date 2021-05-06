library(data.table)
library(dplyr)
library(LDlinkR)


args = commandArgs(trailingOnly=TRUE)


if (length(args)==0) {
  stop("enter path to a file with columns 'RSID' and 'POP' (EUR, EAS, ALL, etc) for each variant you want proxies for, and then the r2 cutoff value", call.=FALSE)
} else if (length(args)==1) {
  file = args[1]
  r2 <- NULL
} else {
  file = args[1]
  r2 <- args[2]
}

print(file)
print(r2)
variant_file <- fread(file)
dim(variant_file)
head(variant_file)



for( row in 1:nrow(variant_file))
{
    snp <- variant_file[row, "RSID"]
    pop <- variant_file[row, "POP"]
  print(paste0(snp," for ", pop, " populations"))
    
  proxies <- LDproxy(snp=snp,pop=pop,r2d="r2",token="1b308e35a979")
  

  print(paste0("  ",nrow(proxies), " proxies total"))
  if(is.null(r2))
  {
    write.csv(proxies,paste0("$PATH/AppDataProcessing/codingvars/proxy_snps/",snp,"_proxies.csv"),row.names=F,sep=",")
  }
  else
  {
    high_r2_proxies <- proxies[which(proxies$R2>as.numeric(r2)),]
    print(paste0("  ",nrow(high_r2_proxies), " proxies total with R2 > ", as.numeric(r2)))
    write.csv(high_r2_proxies,paste0("$PATH/AppDataProcessing/codingvars/proxy_snps/",snp,"_proxies.csv"),row.names=F,sep=",")
  }

}