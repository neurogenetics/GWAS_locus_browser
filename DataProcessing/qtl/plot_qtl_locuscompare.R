# # GWAS Locus Browser QTL Locus Compare Plots Scripts
# - **Author** - Frank Grenn and Hirotaka Iwaki
# - **Date Started** - October 2019
# - **Quick Description:** code to make locus compare plots from eQTL and GWAS data


#nohup R CMD BATCH plot_qtl_locuscompare.R output.log &
#check progress with "jobs"
#get jobid with "ps -ef | grep locuscompare"
#and kill with "kill [PID]"

library(locuscomparer)
library(data.table)
library(dplyr)

setwd("$PATH/Documents/Rfiles/GWASLocusBrowserProject/GWAS_locus_browser/DataProcessing/qtl")

plots_to_plot <- fread("all_qtl_info.csv")
plots_to_plot$correlation <- 0.0
plots_to_plot$plot_status <- NA

#create plot directories for each feature/plot type
features <- unique(plots_to_plot$feature)
for(f in features)
{
  dir.create(paste0(f,"_plots"), showWarnings = FALSE)
}


success <-0
fail <-0
#loops over all the genes
for(rownum in  1:nrow(plots_to_plot))
{
  
  print(rownum)
  row <- plots_to_plot[rownum,]
  
  if(row$can_plot == TRUE)
  {
    feature <- row$feature
    gene <- row$GENE
    gwas <- row$GWAS
    locus <- row$LOC_NUM
    rsid <- row$RSID
    transcript <- row$TRANSCRIPT
    
    print(paste0(gene, " ", feature))
    
    if(is.na(transcript))
    {
      #get file path strings
      gwas_fn = paste0('tsv/', gwas, '/', gene, '_',feature,'_gwas.tsv')
      eqtl_fn = paste0('tsv/', gwas, '/', gene, '_',feature,'_eqtl.tsv')
    }
    else
    {
      #get file path strings
      gwas_fn = paste0('tsv/', gwas, '/', gene,'_',transcript, '_',feature,'_gwas.tsv')
      eqtl_fn = paste0('tsv/', gwas, '/', gene,'_',transcript, '_',feature,'_isoqtl.tsv')
      
    }

    
    g = read.table(gwas_fn, header = T)
    e = read.table(eqtl_fn, header = T)
    
    
    if(feature =='blood' || feature=='brain')
    {
      df = merge(g, e, by = 'RSID')
    }
    else
    {
      df = merge(g, e, by = 'CHR_BP_REF_ALT')
    }
    
    # Replace df$pval.y == 0 with the smallest pval.y of non0 with some random devider
    if(length(which(df$P.y==0))!=0){
      vector_pvaly0 = which(df$P.y==0)
      minp = min(df$P.y[-vector_pvaly0])
      randomdevider = runif(n = length(vector_pvaly0), min = 1, max = 100)
      df$P.y[vector_pvaly0] = minp/randomdevider
    }
    
    df$nlog10Pgwas = -log10(df$P.x)
    df$nlog10Pqtls = -log10(df$P.y)
    
    #calculate correlation
    
    cor = try(cor.test(df$nlog10Pgwas, df$nlog10Pqtls)$estimate, silent = T)

    
    if(inherits(cor, 'try-error'))
    {
      row$correlation <- NA
    }
    else
    {
      row$correlation <- cor.test(df$nlog10Pgwas, df$nlog10Pqtls)$estimate
      if(rownum < 20)
      {
        print(cor)
        print("vs.")
        print(row$correlation)
      }
    }
    
    
    #now try to plot
    if(is.na(transcript))
    {
      plot_file <- paste0(feature,'_plots/',gene,'_',rsid,'.png')
    }
    else
    {
      plot_file <- paste0(feature,'_plots/',gene,'_',transcript,'_',rsid,'.png')
    }
    
    feature_axis_label <- ""
    if(feature=='brain')
    {
      feature_axis_label <- paste0('Brain eQTL, ',gene)
    }
    if(feature=='blood')
    {
      feature_axis_label <- paste0('Blood eQTL, ',gene)
    }
    if(feature=='i_pe')
    {
      feature_axis_label <- paste0('PsychENCODE isoQTL, ',gene, ' ', transcript)
    }
    if(feature=='e_pe')
    {
      feature_axis_label <- paste0('PsychENCODE eQTL, ',gene)
    }
    
    if(row$forced_lead_variant!='NA')
    {
      k = try(locuscompare(in_fn1 = eqtl_fn, in_fn2 = gwas_fn, snp=row$forced_lead_variant, 
                           title = feature_axis_label, title2 = 'GWAS',marker_col1 = "RSID", pval_col1 = "P",marker_col2 = "RSID", pval_col2 = "P"),
              silent = T)
    }
    else
    {
      k = try(locuscompare(in_fn1 = eqtl_fn, in_fn2 = gwas_fn, 
                           title = feature_axis_label, title2 = 'GWAS',marker_col1 = "RSID", pval_col1 = "P",marker_col2 = "RSID", pval_col2 = "P"),
              silent = T)
    }

    
    if(inherits(k, 'try-error')){
      print(paste0(gene, " failed"))
      print(k)
      fail <-fail+1
      row$plot_status <- paste0('failed: ', k)
      
    }
    else
    {
      png(plot_file, width=1000, height=700)
      success <- success + 1
      row$plot_status <- paste0('plotted')
      row$has_plot <- TRUE
      
      plot(k)
      dev.off()
    }
    
  }
  
  plots_to_plot[rownum,] <- row
  if(rownum < 20)
  {
    print("row")
    print(row)
    print("plots_to_plot[rownum,]")
    print(plots_to_plot[rownum,])
  }
  if(rownum %% 30 ==0)
  {
    write.csv(plots_to_plot, file = "all_qtl_info_new.csv", row.names = FALSE)
  }
}



#update the correlation data
write.csv(plots_to_plot, file = "all_qtl_info_new.csv", row.names = FALSE)


