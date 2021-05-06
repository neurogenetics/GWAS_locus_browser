### Function to automatically add accordions and help buttons to the section UIs in the browser. Input is the section's list
accordionFormatUIObj <- function(object){
    accordion(inputId = paste0(object$id),
        accordionItem(
            title = span(paste0(object$title,":"),class="accordionheader"),
            collapsed = FALSE,
            color = "primary",
            #call the function that generates the UI 
            object$generateUI()
            
        )
        #helper file name should match the section's id
    ) %>% helper(icon = "question-circle", type = "markdown", content = object$id, buttonLabel = "X", easyClose = T, fade = T, size = "l")
    
}

#header with the logo, tutorial button and nav dropdown
dbHeader <- dashboardHeaderPlus(
    title = tagList(actionLink("wrapperLogo", span(img(src = "logos/IDPGC-locusbrowser.wrapper.png", id = "wrapperLogo", width = "79%"),h4(paste0("v",version),style="display: inline; position: relative; top: 26px; color: #0a3a87")))),
    titleWidth = '300px',
    left_menu = tagList(
        
        fluidRow(
            column(         
                div(prettyToggle(
                    inputId = "tutorial.activate",
                    icon_on = icon("question"),
                    icon_off = icon("question"),
                    animation = "pulse",
                    status_off = "primary",
                    status_on = "success",
                    label_on = "Turn off tutorial",
                    label_off = "Turn on tutorial",
                    outline = TRUE,
                    plain = TRUE,
                    inline = T,
                    bigger = T
                ),id="tutorialDiv"),
                width = 6),
            column(div(selectInput("navSelect", choices = c(0),label = "Jump to Section:"),id = "navSelectDiv"), width = 6)
            
        )
    )
    
)

#move tabs to top right of page
dbHeader$children[[3]]$children[[5]] <- tagList(
    
    div(
        HTML("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"),
        actionBttn('tab-data', "Data", style = "minimal"),
        actionBttn('tab-about', "About", style = "minimal"),
        style = "text-align:right"
    )
)



shinyUI(
    tagList(
        useShinyjs(),
        
        
        withAnim(),
        tags$script(src = 'javascript/jquery-ui.min-draggable+position.js'),
        #include code for google analytics
        tags$head(tags$script(async=NULL, src="https://www.googletagmanager.com/gtag/js?id=UA-155922190-1")),
        tags$head(includeScript("www/javascript/google-analytics.js")),
        
        
        
        
        #javascript used to call the interactive locus zoom tool
        tags$script(src = "javascript/call_locus_zoom.js"),
        #javascript used for tutorial mode
        tags$script(src = "javascript/tutorial.js"),
        #javascript used to navigate between sections
        tags$script(src = "javascript/navigate.js"),
        
        #get incteractive locus zoom code via CDN (Content Delivery Network) links
        tags$head(tags$script(src = "https://cdn.jsdelivr.net/npm/d3@^5.16.0",type = "text/javascript")),
        tags$head(tags$script(src = "https://cdn.jsdelivr.net/npm/locuszoom@0.12.2",type = "text/javascript")),
        tags$head(includeCSS("https://cdn.jsdelivr.net/npm/locuszoom@0.12.2/dist/locuszoom.css")),

        
        tags$head(includeCSS("www/css/theme.css")),
        div(
            id = "splashPage",
            hidden(img(src = "logos/IDPGC-locusbrowser.wrapper.png", id = "splashLogo"))
        ),
        #this will contain the url to the json files to be used for the interactive locus zoom
        hidden(tags$a(href='locuszoom/interactive_stats/rs114138760_locus.json',target="_blank", id='interactive_ref_link','sample')),
        hidden(
            div(
                id = "uiPage",
                
                dashboardPagePlus(title = "GWAS Locus Browser", skin = "black",
                                  dbHeader,
                                  
                                  dashboardSidebar(
                                      width = 475,
                                      
                                      sideBarUI
                                      
                                      
                                  ),
                                  sidebar_fullCollapse = TRUE,
                                  dashboardBody(
                                      
                                      hidden(
                                          absolutePanel(
                                              boxPlus(
                                                  title = "Hold me to move me around!",
                                                  uiOutput("tutorial"),
                                                  width = 12,
                                                  closable = F,
                                                  status = "success",
                                                  solidHeader = T
                                              ),
                                              class = "draggable",
                                              width = '30%',
                                              style='position: fixed;',
                                              id = "draggable-top-tutorial",
                                              class = "draggable-tutorial"
                                          )
                                      ),
                                      #remove the extra scrollbar 
                                      tags$head(tags$style(
                                          HTML('.wrapper {height: auto !important; position:relative; overflow-x:hidden; overflow-y:hidden}')
                                      )),
                                      
                                      tabsetPanel(id = "tabSetID", type="pills",
                                                  tabPanel("Data",
                                                           value = "Data",
                                                           
                                                           id = "mainpanelID",
                                                           #generate the section UIs
                                                           {
                                                               uis <- c()
                                                               for (section in sections)
                                                               {
                                                                   uis <- append(uis,accordionFormatUIObj(section))
                                                               }
                                                               uis
                                                           }

                                                           ),
                                                  tabPanel(
                                                      "About",
                                                      value = "About",
                                                      fluidRow(
                                                          column(id = "aboutBox",
                                                                 boxPlus(htmlOutput("aboutOutput") ,width = 12,status="navy"),
                                                                 width =12)
                                                      )
                                                      
                                                      
                                                  ),
                                                  selected = "About"
                                      )
                                      
                                      
                                  ))
            )
            
        )
        


    )


)
