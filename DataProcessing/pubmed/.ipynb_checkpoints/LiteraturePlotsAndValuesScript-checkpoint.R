##########pubMedScript#########
#November 6, 2019
#Frank Grenn

##########DESCRIPTION##########
#This script was written to create pubmed search data for the GWAS Locus Browser.
#It reads in a .csv file containing a list of genes and their associated loci 
#and counts how many times the gene show up in the title/abstract of pubmed articles. 
#If a gene is in five or more articles we say it is significant and set its "Literature Search" value to 1 (default 0).
#These search results are written to new .csv files
#A histogram is created for each locus using the number of search results for each gene in the locus
##########PREREQUISITES##########
#1) a "genes_by_locus.csv" file containing columns for "Gene", "Locusnumber"
##########OUTPUT##########
#1)"evidence_literature.csv" containing columns from the genes_by_locus file and a populated "Literature Search" column
#2)"PubmedHitsData.csv" containing the Gene, Locusnumber, number of pubmed hits and number of pubmed central hits for each gene
#3)Pubmed hit histograms for each locus that had genes with at least one hit in the pubmed search

library(data.table)#to store the search results and other data in data tables
library (dplyr)#to select specific columns from data frames
library(rentrez)#to search pubmed
library(PubMedWordcloud)

#get the list of genes we are searching for and their loci
genes_by_locus <- fread("genes_by_locus.csv")
#store the names separately
geneNames <- genes_by_locus$Gene

#get the a list of all the loci
locusnumbers <- unique(genes_by_locus$Locusnumber)

#search_hits stores the number of search results for each gene
search_hits <- genes_by_locus
search_hits$'Pubmed hits' <- 0
search_hits$'Pubmed hits gene only' <- 0


#do a pubmed search for each gene of interest
for(i in 1:nrow(search_hits))
{
  
  pubmed_ids <- entrez_search(db="pubmed", term=paste0(geneNames[i], "[Title/Abstract] AND Parkinson's[Title/Abstract]"))
  #ids <- get_pubmed_ids(paste0(geneNames[i], " AND Parkinson's"))
  search_hits$'Pubmed hits'[i] <- as.numeric(pubmed_ids$count)
  
  
  pubmed_gene_ids <- entrez_search(db="pubmed", term=paste0(geneNames[i], "[Title/Abstract]"))
  search_hits$'Pubmed hits gene only'[i] <- as.numeric(pubmed_gene_ids$count)
  
  if(search_hits$'Pubmed hits gene only'[i] != 0)
  {
    png(paste0("wordcloud/",geneNames[i],"_wordcloud.png"))
    pmid <- getPMIDsByKeyWords(keys=geneNames[i])
    abs <- getAbstracts(pmid)
    clean <- cleanAbstracts(abs)
    plotWordCloud(clean, scale = c(3,1), max.words = 50)
    dev.off()
  }
  
  
  print(paste0(i, " ", geneNames[i]))
  #close extra connections to keep the loop going
  if(length(getAllConnections())>3)
    close.connection(getConnection(3))
}


#write the hit results to a file
write.csv(search_hits %>% select("Locusnumber", "Gene", "Pubmed hits", "Pubmed hits gene only"), file = "results/PubmedHitsData.csv", row.names = FALSE)



#if there are five or more hits set the new "Literature Search" column to 1
search_hits$'Literature Search' <- ifelse(as.numeric(search_hits$'Pubmed hits') >= 5, 1, 0)

#reselect the columns of search_hits to get the evidence data
evidenceDF <- search_hits %>% select("Gene", "Locusnumber", "Literature Search")

#write evidence to file
write.csv(evidenceDF, file = "evidence/evidence_literature.csv", row.names = FALSE)



#create plots for our all loci
for(locus in locusnumbers)
{
  print(paste0("Creating locus ", locus, " plot"))
  #get rows that for the current locus
  locusData <- search_hits[search_hits$Locusnumber==locus,]

  #remove rows with zero hits for pubmed search
  nonZeroLocusData_pubmed <- locusData[locusData$`Pubmed hits` !=0, ]
  #order from largest to smallest
  nonZeroLocusData_pubmed <- nonZeroLocusData_pubmed[order(-as.numeric(nonZeroLocusData_pubmed$'Pubmed hits')),]
  
  #remove rows with zero hits for gene only search
  nonZeroLocusData_pubmedgene <- locusData[locusData$`Pubmed hits gene only` !=0, ]
  #order from largest to smallest
  nonZeroLocusData_pubmedgene <- nonZeroLocusData_pubmedgene[order(-as.numeric(nonZeroLocusData_pubmedgene$'Pubmed hits gene only')),]
  
  #pubmed plot
  if(dim(nonZeroLocusData_pubmed)[1] != 0)
  {
    freq <- as.numeric(nonZeroLocusData_pubmed$`Pubmed hits`)

    labs <- nonZeroLocusData_pubmed$Gene
    png(paste0("results/plots/pubmed/Locus",locus,"Hits.png"))
    bp <- barplot(freq, ylab = "Pubmed Hits", xlab = "Gene Name", main = paste0("Pubmed Hits for Parkinson's Disease and Genes in Locus ", locus))
    text(x=bp[,1], y=0, adj=c(1,1), labs, cex = 1, srt = 45, xpd = TRUE)
    dev.off()
  }
  
  #gene only plot
  if(dim(nonZeroLocusData_pubmedgene)[1] != 0)
  {
    freq <- as.numeric(nonZeroLocusData_pubmedgene$`Pubmed hits gene only`)
    if(nrow(freq)>20)
    {
      freq <- freq[1:20,]
    }
    
    labs <- nonZeroLocusData_pubmedgene$Gene
    png(paste0("results/plots/pubmedgene/Locus",locus,"Hits.png"))
    bp <- barplot(freq, ylab = "Pubmed Hits", xlab = "Gene Name", main = paste0("Pubmed Hits for Genes in Locus ", locus))
    text(x=bp[,1], y=0, adj=c(1,1), labs, cex = 1, srt = 45, xpd = TRUE)
    dev.off()
  }
}

