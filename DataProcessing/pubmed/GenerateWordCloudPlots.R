#RUN LOCALLY
#nohup R CMD BATCH GenerateWordCloudPlots.R output_wordcloud.log &
#check progress with "jobs"
#get jobid with "ps -ef | grep WordCloud"
#and kill with "kill [PID]"

library(data.table)#to store the search results and other data in data tables
library (dplyr)#to select specific columns from data frames
library(rentrez)#to search pubmed
library(PubMedWordcloud)

#get the list of genes we are searching for and their loci
genes_by_locus <- fread("genes_by_locus.csv")
#store the names separately
geneNames <- genes_by_locus$Gene

#get the list of all the loci
locusnumbers <- unique(genes_by_locus$Locusnumber)

#search_hits stores the number of search results for each gene
search_hits <- genes_by_locus
search_hits$'Pubmed hits gene only' <- 0

#create a wordcloud directory if one doesn't exist
dir.create(file.path("wordcloud"), showWarnings = FALSE)

generatePlot <- function(gene)
{
  png(paste0("wordcloud/",gene,"_wordcloud.png"))
  
  pmid <- getPMIDsByKeyWords(keys=gene)
  abs <- getAbstracts(pmid)
  clean <- cleanAbstracts(abs)
  plotWordCloud(clean, scale = c(3,1), max.words = 50)
  dev.off()
}


#do a pubmed search for each gene of interest
for(i in 1:nrow(search_hits))
{
  #pubmed_gene_ids <- entrez_search(db="pubmed", term=paste0(geneNames[i], "[Title/Abstract]"))
  #search_hits$'Pubmed hits gene only'[i] <- as.numeric(pubmed_gene_ids$count)
  
  #skip already created plots for now
  if(!file.exists(paste0("wordcloud/",geneNames[i],"_wordcloud.png")))
  {
    
    try(generatePlot(geneNames[i])

    
    )
    #sleep to overcome the api limit
    Sys.sleep(1)
  }
  
  
  print(paste0(i, " ", geneNames[i]))
  #close extra connections to keep the loop going
  if(length(getAllConnections())>3){
    close.connection(getConnection(3))
    # if(!is.null(getConnection(4)))
    #   close.connection(getConnection(4))
    # if(!is.null(getConnection(5)))
    #   close.connection(getConnection(5))
  }
  
}

