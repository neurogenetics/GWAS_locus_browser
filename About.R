
output$aboutOutput <- renderUI({

  
  #get the about file from google drive and then download it
  aboutFile <- drive_get(id = "1uuE9SF805HDqcCTUQCZhGJZ2IjOXlMfVaAb6B5X_2Qo")
  data <- drive_download(aboutFile, path = "about.html", overwrite = T, verbose = F)

  #read the lines from the file and format them
  filelines <- readLines("about.html")
  
  #insert "target='_blank'"  attribut to all hyperlinks in the about html so that they open in a new tab
  blankify <- gsub("<a","<a target='_blank'",filelines)
  
  HTML(blankify)
  
})