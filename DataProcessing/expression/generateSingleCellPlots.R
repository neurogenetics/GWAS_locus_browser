library(data.table)
library(dplyr)
library(ggplot2)

genes <- fread("genes_by_locus.csv")

scdata <- fread("expression/Nigra_Mean_Cell_GABA_type.txt")

merge <- merge(x = genes, y = scdata, by.x = "GENE",by.y = "Gene", all.x = TRUE)

final <- merge[complete.cases(merge),]
final <- final %>% select("GENE","Astrocyte","DaN","Endothelial",  "GABA", "Microglia", "ODC", "OPC")

names <- c("Astrocyte","DaN","Endothelial",  "GABA", "Microglia", "ODC", "OPC")

#gwas we want to make plots for
gwases <- c("Asian")#c("META5", "Progression", "Asian")

#for(gene in final$Gene)
{
    #data <- final[which(final$Gene == gene),]


    #data <- t(data)

    #data <- data[2:8]

    #png(paste0('results/plots/expression/',gene,'_expression.png'))
    #bp <- barplot(as.numeric(data), ylab="Transcripts Per Million (TMP)", xlab="Cell Type")
    #text(x=bp[,1], y=0, adj=c(1,1), names, cex = 1, srt = 45, xpd = TRUE)
    #dev.off()
}

for(gene in final$GENE)
{
    if(genes$GWAS[genes$GENE==gene] %in% gwases)
    {

        row <- final[which(final$GENE==gene),]
        row <- row[1,]
        print(gene)
        print(row)
        cells <- colnames(row)[2:8]
        tpm <- as.numeric(row[,2:8])
        df <- data.frame(cell=cells, tpm=tpm)

        plot <- ggplot(data=df, aes(x=cell, y=tpm)) + geom_col(width=0.4, color="darkred", fill='#A4A4A4') + coord_flip() + labs(x="",y="Gene expression (tpm)")+ ggtitle(paste0(gene, " Single Cell Expression")) + theme_minimal() + theme(
        text = element_text(size=20),
        #axis.text.x = element_text(hjust=3),
        #panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.background=element_rect(fill = "white"),
        panel.background = element_rect(fill = 'white'),
        plot.title = element_text(hjust=0.5)
        )
        ggsave(filename = paste0("results/plots/expression/",gene,"_sc_expression.png"),plot=plot,width = 300,height=300,units="mm",dpi=300)
    }

}