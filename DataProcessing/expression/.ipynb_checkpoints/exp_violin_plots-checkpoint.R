library(ggplot2)
library(data.table)
gtex_gwas_tissue <- fread("/Users/grennfp/Documents/Rfiles/GWASLocusBrowserProject/test_violin/gtex_gwas_tissue.csv")

#############################################################
gtex_exp <- function(a, cn, rn){
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
  ggsave(filename = paste(cn,"_gtex8_expression.png", sep = ""),
         plot = plot,
         width = 300, height = 390, units = "mm", dpi = 300)
}
#############################################################
gtex_exp(gtex_gwas_tissue[, 4], colnames(gtex_gwas_tissue)[4], gtex_gwas_tissue$SMTSD)
for (i in 3:ncol(gtex_gwas_tissue)){
  gtex_exp(gtex_gwas_tissue[, i], colnames(gtex_gwas_tissue)[i], gtex_gwas_tissue$SMTSD)
}


exp_data <- fread("/Users/grennfp/Documents/Rfiles/GWASLocusBrowserProject/ExpressionScript/Nigra_Mean_Cell_type.txt")
row <- exp_data[which(exp_data$Gene=="A1BG")]


cells <- colnames(row)[2:7]
tpm <- as.numeric(row[,2:7])
df <- data.frame(cell=cells,tpm=tpm)

plot <- ggplot(data=df, aes(x=cell, y=tpm)) + geom_col(width=0.4, color="darkred", fill='#A4A4A4') + coord_flip() + labs(x="",y="Gene expression (tpm)")+ ggtitle("A1BG Single Cell Expression") + theme_minimal() + theme(
  text = element_text(size=20),
  #axis.text.x = element_text(hjust=3),
  #panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  plot.background=element_rect(fill = "white"),
  panel.background = element_rect(fill = 'white'),
  plot.title = element_text(hjust=0.5)
) 

ggsave(filename = paste0("A1BG","_sc_expression.png"),plot=plot,width = 300,height=300,units="mm",dpi=300)
print(plot)
