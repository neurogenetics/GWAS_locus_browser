library(ggplot2)
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

for (i in 3:ncol(gtex_gwas_tissue)){
  gtex_exp(gtex_gwas_tissue[, i], colnames(gtex_gwas_tissue)[i], gtex_gwas_tissue$SMTSD)
}