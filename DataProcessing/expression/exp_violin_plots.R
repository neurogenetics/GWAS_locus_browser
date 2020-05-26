library(ggplot2)
library(data.table)
library(dplyr)

#gwases we want to make plots for
gwases <- c("Asian","Progression")# c("META5","Progression", "Asian")

genes_by_locus <- fread("genes_by_locus.csv") 
gwas_genes_df <- unique(genes_by_locus %>% filter(GWAS%in% gwases) %>% select(GENE))

gwas_genes_list <- genes_by_locus$GENE[genes_by_locus$GWAS %in% gwases]
print(length(gwas_genes_list))

#read the expression data
gtex_data <- fread("expression/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct")


gtex_data <- gtex_data[ , -c("Name")]

#then merge by the genes we want
gtex_data <- merge(x = gwas_genes_df, y = gtex_data, by.x = "GENE", by.y = "Description")

print(dim(gtex_data))
gtex_data_t <- t(gtex_data)


write.table(gtex_data_t,"expression/gtex_data_transposed.csv",col.names=FALSE,sep=',')

gtex_data_t <- fread("expression/gtex_data_transposed.csv")
colnames(gtex_data_t)[colnames(gtex_data_t)=="GENE"] <- "Sample"


#read the tissue data
gtex_samples <- fread("expression/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
gtex_samples <- gtex_samples[,c("SAMPID", "SMTSD")]

gtex <- merge(x = gtex_data_t, y = gtex_samples, by.x = "Sample", by.y = "SAMPID")




gtex <- gtex %>% select("Sample", "SMTSD",colnames(gtex)[1:(length(colnames(gtex))-1)])
write.csv(gtex,"expression/gtex_gwas_data_temp.csv", row.names=FALSE)


gtex_gwas_tissue <- gtex



#############################################################
gtex_exp <- function(a, cn, rn){
  print("    plot")
    print(length(a))
    print(length(rn))
  plot <- ggplot(data=as.data.frame(a), aes(x=reorder(rn, a), y=a)) + 
    geom_violin(trim=FALSE, fill='#A4A4A4', color="darkred")+
    geom_boxplot(width=0.2, outlier.size = 0.3) + theme_minimal() + coord_flip() + labs(x ="", y = "Gene expression (GTEx v8), tpm")+guides(fill=FALSE) + theme(
      text = element_text(size=20),
      axis.text.x = element_text(hjust=3),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.background=element_rect(fill = "white"),
      panel.background = element_rect(fill = 'white')
    )
  print("   plot done")
    print(cn)
  ggsave(filename = paste("results/plots/expression_violin/",cn,"_gtex8_expression.png", sep = ""),
         plot = plot,
         width = 300, height = 390, units = "mm", dpi = 300)
  print("   plot saved")
}
#############################################################



for (i in 3:ncol(gtex_gwas_tissue)){
    print(i)
    gene <- colnames(gtex_gwas_tissue)[i]
    print(gene)
    values <- as.numeric(unlist(as.list(gtex_gwas_tissue %>% select(colnames(gtex_gwas_tissue)[i]))))
    
    if(Reduce("+",values)!=0)
    {
        if(gene %in% gwas_genes_list)
        {


          print(gtex_gwas_tissue %>% select(colnames(gtex_gwas_tissue)[i]))
          gtex_exp(values, colnames(gtex_gwas_tissue)[i], gtex_gwas_tissue$SMTSD)
        }
    }

  
}