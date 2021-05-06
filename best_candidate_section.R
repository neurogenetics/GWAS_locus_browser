bestCandidate<-list()
bestCandidate$id <- "bestcandidate"
bestCandidate$title <- "Best Candidate"

bestCandidate$loadData<- function(){
  
}

bestCandidate$generateUI<- function(){
  fluidRow(
    column(htmlOutput("bestCandidateOutput"), width = 12)
  )
}


bestCandidate$serverLogic <- function(input,output,session,reactives)
{
  output$bestCandidateOutput <- renderUI({
    
    token_name <- "authentication_token.rds"
    drive_auth(token = readRDS(token_name))
    
    drive_filename <- paste0("Locus ", ifelse(reactives$selRiskVariant()$GWAS=="META5","",reactives$selRiskVariant()$GWAS),reactives$selRiskVariant()$LOC_NUM)
    
    localfilename <- paste0(gsub(" ","_",drive_filename),"_Literature.html")
    
    litFile <- drive_get(path = drive_filename)
    
    
    
    data <- drive_download(litFile, path = localfilename, overwrite = T, verbose = F)
    
    filelines <- readLines(localfilename,warn=FALSE)
    file.remove(localfilename)
    drive_deauth()
    
    HTML(filelines)
    
    
  })
}