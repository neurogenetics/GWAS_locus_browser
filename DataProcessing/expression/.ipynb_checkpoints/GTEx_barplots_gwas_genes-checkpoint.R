##########################################################
gtex_exp <- function(a, cn, rn){
  plot <- ggplot(data=as.data.frame(a), aes(x=rn, y=a, fill="orange")) +
    geom_bar(stat="identity") +
    coord_flip()+labs(x ="", y = "Median GTEx8 expression, tpm")+guides(fill=FALSE) + theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.background=element_rect(fill = "white"),
      panel.background = element_rect(fill = 'white')
    )
  ggsave(filename = paste(cn,"_gtex8_expression.png", sep = ""),
         plot = plot,
         width = 150, height = 195, units = "mm")
}
#############################################################




for (i in 1:ncol(gtex_gwas_genes2)){
  gtex_exp(gtex_gwas_genes2[,i], colnames(gtex_gwas_genes2)[i], rownames(gtex_gwas_genes2))
}