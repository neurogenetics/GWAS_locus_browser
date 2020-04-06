library("rvest")
library("tidyverse")
library("stringr")
library("data.table")
library("httr")


args <- commandArgs(trailingOnly = TRUE)
gene <- args[1]
cv.url <- paste0("https://www.genecards.org/cgi-bin/carddisp.pl?gene=",gene)
downloadfilename=paste0("scrapedpage",gene,".html")
GET(cv.url,user_agent("Me"),write_disk(downloadfilename,overwrite=TRUE))
content<- read_html(downloadfilename)
review<- content %>% html_nodes(css = '.gc-subsection') %>% html_text()

description <-NA
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

df <- data.frame(Gene=gene, Description=description)
#append to the csv
write.table(df, "GeneCardDescriptions.csv",sep="\t",col.names = !file.exists("GeneCardDescriptions.csv"), append=TRUE)

if (file.exists(paste0("scrapedpage",gene,".html")))
    file.remove(paste0("scrapedpage",gene,".html"))