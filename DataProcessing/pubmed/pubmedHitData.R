#RUN LOCALLY
#nohup R CMD BATCH pubmed/pubmedHitData.R pubmed/output_pubmedhitdata.log &
#check progress with "jobs"
#get jobid with "ps -ef | grep HitData"
#and kill with "kill [PID]"

library(data.table)#to store the search results and other data in data tables
library (dplyr)#to select specific columns from data frames
library(rentrez)#to search pubmed

#get the list of genes we are searching for and their loci
genes_by_locus <- fread("genes_by_locus.csv")
#store the names separately
geneNames <- genes_by_locus$GENE


#search_hits stores the number of search results for each gene
search_hits <- genes_by_locus
search_hits$'Pubmed hits' <- 0
search_hits$'Pubmed hits gene only' <- 0

#create directories if needed
dir.create(file.path("results"), showWarnings = FALSE)
dir.create(file.path("evidence"), showWarnings = FALSE)

#do a pubmed search for each gene of interest
for(i in 1:nrow(search_hits))
{
  
  pubmed_ids <- entrez_search(db="pubmed", term=paste0(geneNames[i], "[Title/Abstract] AND Parkinson's[Title/Abstract]"))
  #ids <- get_pubmed_ids(paste0(geneNames[i], " AND Parkinson's"))
  search_hits$'Pubmed hits'[i] <- as.numeric(pubmed_ids$count)
  
  
  pubmed_gene_ids <- entrez_search(db="pubmed", term=paste0(geneNames[i], "[Title/Abstract]"))
  search_hits$'Pubmed hits gene only'[i] <- as.numeric(pubmed_gene_ids$count)
  
  
  print(paste0(i, " ", geneNames[i]))
  #close extra connections to keep the loop going
  if(length(getAllConnections())>3)
    close.connection(getConnection(3))
}


#write the hit results to a file
write.csv(search_hits %>% select("GWAS","LOC_NUM", "GENE", "Pubmed hits", "Pubmed hits gene only"), file = "results/PubmedHitsData.csv", row.names = FALSE)



#if there are five or more hits set the new "Literature Search" column to 1
search_hits$'Literature Search' <- ifelse(as.numeric(search_hits$'Pubmed hits') >= 5, 1, 0)

#reselect the columns of search_hits to get the evidence data
evidenceDF <- search_hits %>% select("GENE","GWAS", "LOC_NUM", "Literature Search")

#write evidence to file
write.csv(evidenceDF, file = "evidence/evidence_literature.csv", row.names = FALSE)
