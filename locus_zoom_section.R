renderLocusZooms <- function()
{
  output$staticLZHeader <- renderUI(HTML(paste0("<h2>Locus ",reactives$selRow$LOC_NUM," Locus Zoom for ",reactives$selRow$RSID,"</h2>")))
  
  output$interactiveLZHeader <- renderUI(HTML(paste0("<h2>Locus ",reactives$selRow$LOC_NUM," Locus Zoom for ",reactives$selRow$RSID,"</h2>")))
  
  #update static locus zoom plot
  output$locusZoomPlot <- renderImage({
    #return the image for the static plot
    list(src = paste0("www/locuszoom/locuszoom_plots/",  (reactives$selRow$RSID), ".png"), contentType = 'image/png', width = '100%')
  }, deleteFile = FALSE)
  
  #call javascript code for the interactive locuszoom
  output$'interactiveLZ' <- renderUI({
    
    
    BP <- as.numeric(gsub("\\,", "", (reactives$selRow$BP)))
    formatsnp <- paste0((reactives$selRow$CHR),":",BP,"_",toupper((reactives$selRow$REF)),"/",toupper((reactives$selRow$ALT)))
    if(gwas_id_string=="Asian")
    {
      jsstring <- paste0("do_locuszoom_stuff('",(reactives$selRow$RSID),"',",(reactives$selRow$CHR),",",BP,",'",formatsnp,  "','",'EAS',"')")
    }
    else
    {

      jsstring <- paste0("do_locuszoom_stuff('",(reactives$selRow$RSID),"',",(reactives$selRow$CHR),",",BP,",'",formatsnp,  "','",'EUR',"')")
    
    }
    runjs(jsstring)
  })
}