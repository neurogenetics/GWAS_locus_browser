
#Load basic gwas data for sidebar
gwas_risk_variants <- fread("www/summarystats/gwas_risk_variants.csv")





gwas_id_string <- "META5"

gwas_info <- fread("www/summarystats/gwasInfo.csv")

#build the gwas_list that will hold names and values for the "Choose a GWAS" drop down
gwases <- split(paste0(gwas_info$ID," GWAS"), seq(nrow(gwas_info)))
gwases <- setNames(split(gwas_info$ID, seq(nrow(gwas_info))),paste0(gwas_info$SHORT_REF," ", gwas_info$ID, " GWAS"))

#load 90 meta5 loci
meta5_gwas_data <- fread("www/summarystats/META5Loci.csv")
meta5_gwas_data$GWAS <- "META5"


#load the 2 progression loci
prog_gwas_data <- fread("www/summarystats/ProgressionLoci.csv")
prog_gwas_data$GWAS <- "Progression"

#load the 2 asian gwas loci
asian_gwas_data <- fread("www/summarystats/AsianLoci.csv")
asian_gwas_data$GWAS <- "Asian"

#variable that holds the current selected gwas data
gwas_data <- rbind(meta5_gwas_data,prog_gwas_data,asian_gwas_data,fill=TRUE)

#dataframe holding links for the other summary stats table
other_gwas_info <- data.table(ID=c("aoo","gba_aoo","gba_mod","lrrk2","asian","META5"),
                              LINK=c("https://onlinelibrary.wiley.com/doi/abs/10.1002/mds.27659",
                                     "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6935749/",
                                     "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6935749/",
                                     "https://onlinelibrary.wiley.com/doi/full/10.1002/mds.27974",
                                     "https://jamanetwork.com/journals/jamaneurology/fullarticle/2764340",
                                     "https://www.sciencedirect.com/science/article/pii/S1474442219303205?via%3Dihub"),
                              SHORT_REF=c("Blauwendraat et al. 2019 Age of Onset",
                                          "Blauwendraat et al. 2020 GBA Age of Onset",
                                          "Blauwendraat et al. 2020 GBA Risk Modifier", 
                                          "Iwaki et al. 2020 LRRK2 Risk Modifier", 
                                          "Foo et al. 2020 Asian",
                                          "Nalls et al. 2019 META5"))


#other study summary statistics
aoo_stats <- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="AAO",colNames=TRUE,sep.names=" ")
aoo_stats$GWAS <- "aoo"

gba_aoo_stats <- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="GBA_AAO",colNames=TRUE,sep.names=" ")
gba_aoo_stats$GWAS <- "gba_aoo"

gba_stats <- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="GBA_mod",colNames=TRUE,sep.names=" ")
gba_stats$GWAS <- "gba_mod"

lrrk2_stats <- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="LRRK2",colNames=TRUE,sep.names=" ")
lrrk2_stats$GWAS <- "lrrk2"

asian_gwas_stats <- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="Asian_GWAS",colNames=TRUE,sep.names=" ")
asian_gwas_stats$GWAS <- "asian"

meta5_gwas_stats <- read.xlsx(xlsxFile="www/summarystats/other_sum_stats.xlsx",sheet="META5",colNames=TRUE,sep.names=" ")
meta5_gwas_stats$GWAS <- "META5"

#each gwas is going to have a different set of other summary statistics to show
other_sum_stats_for_meta5_gwas <- rbind(aoo_stats,gba_aoo_stats,gba_stats,lrrk2_stats,asian_gwas_stats)
other_sum_stats_for_prog_gwas <- rbind(aoo_stats,gba_aoo_stats,gba_stats,lrrk2_stats,asian_gwas_stats,meta5_gwas_stats)
other_sum_stats_for_asian_gwas <- rbind(aoo_stats,gba_aoo_stats,gba_stats,lrrk2_stats,meta5_gwas_stats)


#geneCards descriptions
genecards <- fread("www/pubmed/GeneCardDescriptions.txt",sep="\t")



#read the minimum p values for allburden tests for all the genes
burdenData <- fread("www/burden/BurdenPValueData.csv")

#read the constraint values for all the genes
constraintData <- fread("www/constraint/ConstraintData.csv")

#read the average expression data for the brain and substantia nigra and single cell data
expressionData <- fread("www/expression/ExpressionData.csv")
colnames(expressionData) <- c("GENE","GTEX_BRAIN_all","GTEX_nigra","SN Astrocyte","SN-Dop. Neuron","SN Endothelial","SN-GABA Neuron","SN Microglia","SN ODC","SN OPC")



pubmedhits <- fread("www/pubmed/PubmedHitsData.csv")

freqs <- fread("www/summarystats/risk_variant_pop_freqs.csv")

#read in coding variant data
coding_ld <- fread("www/codingvars/CodingVariantLD.csv")
coding_variants <- fread("www/codingvars/CodingVariants.csv")

#read in phenotype variant data
phenotype_ld <- fread("www/phenovars/PhenotypeVariantLD.csv")
phenotype_variants <- fread("www/phenovars/PhenotypeVariantData.csv")
phenotype_variants$`P-VALUE` <- as.numeric(as.character(phenotype_variants$`P-VALUE`))

#red in disease gene data
diseaseData <- fread("www/diseasegene/DiseaseGeneData.txt")

#ucsc links
UCSC_links <- fread("www/summarystats/UCSC_links.csv")

#file containing special text for progression loci
locus_text <- fread("www/summarystats/Locus_Special_Text.txt")


#finemapping data
finemapping <- fread("www/finemapping/fineMappingFilteredData.csv")

colnames(finemapping) <- c("Locus Number", "SNP", "Chr", "BP", "Ref", "Alt", "Frequency", "P-value", "Prob", "log10bf", "Function", "Exonic Function", "AA Change")
finemapping$`AA Change` <- gsub(",","\n", finemapping$`AA Change`)
finemapping$Frequency <- signif(finemapping$Frequency,4)
finemapping$"P-value" <- signif(finemapping$"P-value",4)
finemapping$Prob <- signif(finemapping$Prob,4)
finemapping$log10bf <- signif(finemapping$log10bf,4)

pdgenes <- fread("www/pd_and_meta5nom_genes/pd_genes_for_app.csv")

qtl_info <- fread("www/qtl/all_qtl_info_new.csv")
#create a dataframe to hold the conclusion values. This will need to contain extra info for genes on loci with multiple risk snps (like locus 1) which is why we merge with the rsids
readEvidencePerGene <- function()
{
  evidenceDF <- fread("www/evidence/evidence_per_gene.csv")
  names(evidenceDF)[names(evidenceDF) == 'Variant_Intolerant'] <- 'Variant Intolerant'
  evidenceQTL <- fread("www/evidence/evidence_qtl.csv")
  
  #get all the risk variants
  variant_data <- gwas_risk_variants %>% select("LOC_NUM","RSID", "GWAS")
  
  
  
  #merge the original evidence df with the risk variants
  evidence_with_rsid <- merge(x=evidenceDF, y = variant_data, by.x=c("LOC_NUM","GWAS"), by.y = c("LOC_NUM","GWAS"), all.x = TRUE, allow.cartesian = TRUE)
 
  #merge the evidence df containing rsids with the qtl evidence scores, which can change depending on the risk variant we wan for the gene
  evidence_full <- merge(x=evidence_with_rsid, y=evidenceQTL, by.x = c("GENE","LOC_NUM","RSID","GWAS"), by.y = c("GENE","LOC_NUM","RSID","GWAS"), all.x = TRUE, allow.cartesian = TRUE)

  #add conclusion column and default to 0
  evidence_full$Conclusion <- 0
  
  setcolorder(evidence_full, c("GENE", "LOC_NUM", "RSID", "Conclusion", "Nominated by META5", "QTL-brain", "QTL-blood", "QTL-correl","Burden", "Brain Expression", "Nigra Expression", "SN-Dop. Neuron Expression", "Literature Search", "Variant Intolerant", "PD Gene", "Disease Gene"))

  evidence_full
}


