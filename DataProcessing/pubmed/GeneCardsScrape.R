library("rvest")
library("tidyverse")
library("stringr")
library("data.table")
library("httr")

genes <- fread("$PATH/genes_by_locus.csv")

gene_names <- unique(genes$Gene)

completed_genes <- NA
if(file.exists("GeneCardDescriptions.txt"))
{
  description_df <- fread("GeneCardDescriptions.txt",sep="\t")
  completed_genes <- description_df$Gene
}

i<-0
for(gene in gene_names) {
  downloadfilename <- paste0("scrapedpage",gene,".html")
  print(i)
  if(!gene %in% completed_genes)
  {

    #if(!file.exists(downloadfilename))
    #{
      cv.url <- paste0("https://www.genecards.org/cgi-bin/carddisp.pl?gene=",gene)
      GET(cv.url,user_agent("Me"),write_disk(downloadfilename,overwrite=TRUE))
      #download.file(cv.url, destfile=downloadfilename,quiet=TRUE)
      content<- read_html(downloadfilename)
      review<- content %>% html_nodes(css = '.gc-subsection') %>% html_text()
      description <- NA
      for(section in review)
      {
        if (grepl( "GeneCards Summary",section,fixed=TRUE))
        {
          description <- section
          break
        }
      }
      
      
      title_string <- paste0("GeneCards Summary for ", gene," Gene")
      description <- gsub(title_string, '', description)
      #print("make df")
      df <- data.frame(Gene=gene, Description=description)
      #print("bind")
      #description_df <- rbind(gene, description)
      #append to the csv
      #if(i%%10 ==0)
      {
        write.table(x=df, file="GeneCardDescriptions.txt",sep="\t",col.names = !file.exists("GeneCardDescriptions.txt"),append=TRUE,  row.names=FALSE)
      }
      
    

      if (file.exists(downloadfilename))
        file.remove(downloadfilename)

  }
  else
  {
    print("skip")
  }
  print(gene)
  
  
  i<-i+1
  
}
