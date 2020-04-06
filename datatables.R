

#load 90 meta5 loci
meta5_gwas_data <- read.xlsx(xlsxFile="www/sumstats_for_browser_Feb62020.xlsx",sheet="META5",colNames=TRUE,sep.names=" ")
setDT(meta5_gwas_data)

#data for the side bar table
meta5_loci <- meta5_gwas_data %>% select("Locus Number", "SNP", "CHR", "BP", "Nearest Gene")

#load the 2 progression loci
prog_gwas_data <- fread("www/ProgressionLoci.csv")
colnames(prog_gwas_data) <- c("CHR:BP", "SNP", "CHR", "BP", "REF","ALT", "MAF", "Beta", "SE", "P", "N", "NSTUDY", "Isq", "FUNC", "Nearest Gene", "Odds Ratio", "Locus Number", "flip" )

#data for the side bar table
prog_loci <- prog_gwas_data %>% select("Locus Number", "SNP" , "CHR", "BP", "Nearest Gene")

#other study summary statistics
aoo_stats <- read.xlsx(xlsxFile="www/sumstats_for_browser_Feb62020.xlsx",sheet="AAO",colNames=TRUE,sep.names=" ")
aoo_stats$Beta <- signif(aoo_stats$Beta,4)
aoo_stats$'Effect allele frequency' <- signif(aoo_stats$'Effect allele frequency',4)
aoo_stats$SE <- signif(aoo_stats$SE,4)
aoo_stats$P <- signif(aoo_stats$P,4)

gba_aoo_stats <- read.xlsx(xlsxFile="www/sumstats_for_browser_Feb62020.xlsx",sheet="GBA_AAO",colNames=TRUE,sep.names=" ")
gba_aoo_stats$Beta <- signif(gba_aoo_stats$Beta,4)
gba_aoo_stats$'Effect allele frequency' <- signif(gba_aoo_stats$'Effect allele frequency',4)
gba_aoo_stats$SE <- signif(gba_aoo_stats$SE,4)
gba_aoo_stats$P <- signif(gba_aoo_stats$P,4)

gba_stats <- read.xlsx(xlsxFile="www/sumstats_for_browser_Feb62020.xlsx",sheet="GBA_mod",colNames=TRUE,sep.names=" ")
gba_stats$Beta <- signif(gba_stats$Beta,4)
gba_stats$'Effect allele frequency' <- signif(gba_stats$'Effect allele frequency',4)
gba_stats$SE <- signif(gba_stats$SE,4)
gba_stats$P <- signif(gba_stats$P,4)

lrrk2_stats <- read.xlsx(xlsxFile="www/sumstats_for_browser_Feb62020.xlsx",sheet="LRRK2",colNames=TRUE,sep.names=" ")
lrrk2_stats$Beta <- signif(lrrk2_stats$Beta,4)
lrrk2_stats$'Effect allele frequency' <- signif(lrrk2_stats$'Effect allele frequency',4)
lrrk2_stats$SE <- signif(lrrk2_stats$SE,4)
lrrk2_stats$P <- signif(lrrk2_stats$P,4)

#geneCards descriptions
genecards <- fread("www/GeneCardDescriptions.txt",sep="\t")



#read the minimum p values for allburden tests for all the genes
burdenData <- fread("www/BurdenPValueData.csv")

#read the constraint values for all the genes
constraintData <- fread("www/ConstraintData.csv")

#read the average expression data for the brain and substantia nigra and single cell data
expressionData <- fread("www/ExpressionData.csv")
colnames(expressionData) <- c("Gene","GTEX_BRAIN_all","GTEX_nigra","SN Astrocyte","SN-Dop. Neuron","SN Endothelial","SN-GABA Neuron","SN Microglia","SN ODC","SN OPC")

#apply links for sidebar
for (i in 1:nrow(meta5_loci))
{
  meta5_loci$SNP[i] <- paste0('<a id="', meta5_loci$SNP[i], '" href="javascript:;" onclick="tableClick(this.id)">', meta5_loci$SNP[i], '</a>')
  
  #and remove commas if we want
  meta5_loci$BP[i] <- as.numeric(gsub("\\,", "", meta5_loci$BP[i]))
}
for (i in 1:nrow(prog_loci))
{
  prog_loci$SNP[i] <- paste0('<a id="', prog_loci$SNP[i], '" href="javascript:;" onclick="tableClick(this.id)">', prog_loci$SNP[i], '</a>')
  
  #and remove commas if we want
  prog_loci$BP[i] <- as.numeric(gsub("\\,", "", prog_loci$BP[i]))
}

pubmedhits <- fread("www/PubmedHitsData.csv")
pubmedhits <- pubmedhits %>% select("Locusnumber", "Gene", "Pubmed hits", "Pubmed hits gene only")

#read in frequency data and get sigfigs
meta5_freq <- fread("www/META5_Frequencies.csv")
meta5_freq$Frequency_PD <- signif(meta5_freq$Frequency_PD,4)
meta5_freq$Frequency_control <- signif(meta5_freq$Frequency_control,4)
meta5_freq$African <- signif(meta5_freq$African,4)
meta5_freq$'Ashkenazi Jewish' <- signif(meta5_freq$'Ashkenazi Jewish',4)
meta5_freq$'East Asian' <- signif(meta5_freq$'East Asian',4)
meta5_freq$'European (Finnish)' <- signif(meta5_freq$'European (Finnish)',4)
meta5_freq$'European (non-Finnish)' <- signif(meta5_freq$'European (non-Finnish)',4)
meta5_freq$Latino <- signif(meta5_freq$Latino,4)
meta5_freq$Other <- signif(meta5_freq$Other,4)

prog_freq <- fread("www/Prog_Frequencies.csv")
prog_freq$African <- signif(prog_freq$African,4)
prog_freq$'Ashkenazi Jewish' <- signif(prog_freq$'Ashkenazi Jewish',4)
prog_freq$'East Asian' <- signif(prog_freq$'East Asian',4)
prog_freq$'European (Finnish)' <- signif(prog_freq$'European (Finnish)',4)
prog_freq$'European (non-Finnish)' <- signif(prog_freq$'European (non-Finnish)',4)
prog_freq$Latino <- signif(prog_freq$Latino,4)
prog_freq$Other <- signif(prog_freq$Other,4)

#read in coding variant data
coding_ld <- fread("www/CodingVariantLD.csv")
coding_variants <- fread("www/CodingVariants.csv")

#read in phenotype variant data
phenotype_ld <- fread("www/PhenotypeVariantLD.csv")
phenotype_variants <- fread("www/PhenotypeVariantData.csv")
phenotype_variants$`P-VALUE` <- as.numeric(as.character(phenotype_variants$`P-VALUE`))

#red in disease gene data
diseaseData <- fread("www/DiseaseGeneData.txt")

#ucsc links
UCSC_links <- fread("www/UCSC_links.csv")

#file containing special text for progression loci
locus_text <- fread("www/Locus_Special_Text.txt")

#finemapping data
finemapping <- fread("www/fineMappingFilteredData.csv")

colnames(finemapping) <- c("Locus Number", "SNP", "Chr", "BP", "Ref", "Alt", "Frequency", "P-value", "Prob", "log10bf", "Function", "Exonic Function", "AA Change")
finemapping$`AA Change` <- gsub(",","\n", finemapping$`AA Change`)
finemapping$Frequency <- signif(finemapping$Frequency,4)
finemapping$"P-value" <- signif(finemapping$"P-value",4)
finemapping$Prob <- signif(finemapping$Prob,4)
finemapping$log10bf <- signif(finemapping$log10bf,4)


#create a dataframe to hold the conclusion values. This will need to contain extra info for genes on loci with multiple risk snps (like locus 1) which is why we merge with the rsids
readEvidencePerGene <- function()
{
  evidenceDF <- fread("www/evidence_per_gene.csv")

  evidenceQTL <- fread("www/evidence_qtl.csv")
  
  meta5_sub <- meta5_gwas_data %>% select("Locus Number", "SNP")
  prog_sub <- prog_gwas_data %>% select("Locus Number", "SNP")
  #get all the risk variants
  variant_data <- rbind(meta5_sub, prog_sub)
  
  #merge the original evidence df with the risk variants
  evidence_with_rsid <- merge(x=evidenceDF, y = variant_data, by.x="Locusnumber", by.y = "Locus Number", all.x = TRUE, allow.cartesian = TRUE)
  
  #merge the evidence df containing rsids with the qtl evidence scores, which can change depending on the risk variant we wan for the gene
  evidence_full <- merge(x=evidence_with_rsid, y=evidenceQTL, by.x = c("Gene","Locusnumber","SNP"), by.y = c("Gene","Locusnumber","SNP"), allow.cartesian = TRUE)

  #add conclusion column and default to 0
  evidence_full$Conclusion <- 0

  setcolorder(evidence_full, c("Gene", "Locusnumber", "SNP", "Conclusion", "Nominated by META5", "QTL-brain", "QTL-blood", "QTL-correl","Burden", "Brain Expression", "Nigra Expression", "SN-Dop. Neuron Expression", "Literature Search", "Variant Intolerant", "PD Gene", "Disease Gene"))

  evidence_full
}


