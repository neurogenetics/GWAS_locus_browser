locusZoom<-list()
locusZoom$id <- "locuszoom"
locusZoom$title <- "Locus Zoom"

locusZoom$loadData<- function(){
  
}

locusZoom$generateUI<- function(){
      fluidRow(
        column(tabsetPanel(type="pills",
                           tabPanel("Interactive", 
                                    fluidRow(
                                      #htmlOutput for reactivity and div for the plot target. Combining both breaks it.
                                      column(
                                        fluidRow(
                                          column(align = "center", htmlOutput("interactiveLZHeader"), width = 12)
                                        ),
                                        htmlOutput("interactiveLZ"),
                                        div(id="lz-plot",class="lz-container-responsive"),width = 12)
                                    )
                           ),
                           tabPanel("Static", 
                                    div(id = "LocusZoomId"),
                                    fluidRow(
                                      column(align = "center", htmlOutput("staticLZHeader"), width = 12)
                                    ),
                                    div(imageOutput("locusZoomPlot", width = "auto", height = "auto"))
                           ),
                           selected = "Interactive"
        )
        ,width = 12)
      )

}

locusZoom$serverLogic <- function(input,output,session,reactives)
{
  output$staticLZHeader <- renderUI(HTML(paste0("<h2>Locus ",reactives$selRiskVariant()$LOC_NUM," Locus Zoom for ",reactives$selRiskVariant()$RSID,"</h2>")))
  
  output$interactiveLZHeader <- renderUI(HTML(paste0("<h2>Locus ",reactives$selRiskVariant()$LOC_NUM," Locus Zoom for ",reactives$selRiskVariant()$RSID,"</h2>")))
  
  #update static locus zoom plot
  output$locusZoomPlot <- renderImage({
    #return the image for the static plot
    list(src = paste0("www/locuszoom/locuszoom_plots/",  reactives$selRiskVariant()$RSID, ".png"), contentType = 'image/png', width = '100%')
  }, deleteFile = FALSE)
  
  #call javascript code for the interactive locuszoom
  output$'interactiveLZ' <- renderUI({
    
    BP <- as.numeric(gsub("\\,", "", reactives$selRiskVariant()$BP))
    formatsnp <- paste0(reactives$selRiskVariant()$CHR,":",BP,"_",toupper(reactives$selRiskVariant()$REF),"/",toupper(reactives$selRiskVariant()$ALT))
    if(reactives$selRiskVariant()$GWAS=="Asian")
    {
      jsstring <- paste0("do_locuszoom_stuff('",(reactives$selRiskVariant()$RSID),"',",(reactives$selRiskVariant()$CHR),",",BP,",'",formatsnp,  "','",'EAS',"')")
    }
    else
    {
      
      jsstring <- paste0("do_locuszoom_stuff('",(reactives$selRiskVariant()$RSID),"',",(reactives$selRiskVariant()$CHR),",",BP,",'",formatsnp,  "','",'EUR',"')")
      
    }
    runjs(jsstring)
  })
}