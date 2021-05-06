
library(shiny)
library(shinyjs)
library(googledrive)
library(data.table)
library(shinydashboard)
library(shinydashboardPlus)
library(DT)
library(dplyr)
library(openxlsx)
library(shinyWidgets)
library(stringr)
library(htmlwidgets)
library(plotly)
library(shinyanimate)
library(shinyhelper)
library(httr)

#current version
version <- "1.7"
#date the pubmed hits and word clouds were last generated. This will be displayed in the literature section text.
literature_search_date <- "May 6, 2020"
#authentication token name
auth_token <- "myauthtoken.rds"

source('tutorial.R', local = T)

source("sidebar.R",local=T)
#load sidebar data
sideBarLoadData()

###################################
### ADD NEW SECTION FILES HERE: ###
###################################

source("locus_zoom_section.R",local=T)
source("summary_statistics_section.R",local=T)
source("best_candidate_section.R",local=T)
source("evidence_section.R", local=T)
source("qtl_section.R",local=T)
source("coding_vars_section.R",local=T)
source("pheno_vars_section.R", local = T)
source("burden_section.R",local=T)
source("expression_section.R",local=T)
source("coexpression_section.R",local = T)
source("constraint_section.R",local=T)
source("disease_gene_section.R",local=T)
source("finemap_section.R",local=T)
source("pathways_section.R", local=T)
source("literature_section.R", local=T)


############################################
### ADD LIST FROM THE SECTION FILE HERE: ###
############################################

sections <- list(locusZoom=locusZoom,sumStats=sumStats,bestCandidate=bestCandidate,evidence_section=evidence_section,qtl_section = qtl_section,codingVars = codingVars,
                 phenoVars = phenoVars,burden=burden,expression = expression,coexpression=coexpression,constraint=constraint,diseaseGene = diseaseGene, finemap = finemap, pathways = pathways, literature = literature)


#call loadData function for all sections
for(section in sections)
{
  section$loadData()
}
