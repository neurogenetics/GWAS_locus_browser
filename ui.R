library(shiny)
library(DT)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyanimate)
library(shinyWidgets)
library(plotly)
library(shinyhelper)
#logo
dbHeader <- dashboardHeaderPlus(
  title = actionLink("wrapperLogo", img(src = "IDPGC-locusbrowser.wrapper.png", id = "wrapperLogo", width = "100%"))
)

#move tabs to top right of page
dbHeader$children[[3]]$children[[5]] <- tagList(
  div(
    #span("ALPHA RELEASE", class="VersionText"),
    HTML("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"),
    actionBttn('tab-data', "Data", style = "minimal"),
    actionBttn('tab-about', "About", style = "minimal"),
    style = "text-align:right"
  )
)
help
shinyUI(tagList(
  useShinyjs(),
  withAnim(),
  #include code for google analytics
  tags$head(tags$script(async=NULL, src="https://www.googletagmanager.com/gtag/js?id=UA-155922190-1")),
  tags$head(includeScript("www/google-analytics.js")),
  
  #include javascript code 
  tags$script(src = "clickdetect.js"),
  #include locus zoom javascript code
  tags$script(src = "locus_zoom/locuszoom.vendor.min.js"),
  tags$script(src = "locus_zoom/locuszoom.app.js"),
  tags$script(src = "locus_zoom/lz-dynamic-urls.min.js"),
  tags$head(includeCSS("www/locus_zoom/locuszoom.css")),

  #include css file
  tags$head(includeCSS("www/theme.css")),
  div(
    id = "splashPage",
    hidden(img(src = "IDPGC-locusbrowser.wrapper.png", id = "splashLogo"))
  ),
  #this will contain the url to the json files to be used for the interactive locus zoom
  hidden(tags$a(href='interactive_stats/rs114138760_locus.json',target="_blank", id='interactive_ref_link','sample')),
  hidden(
    div(
    id = "uiPage",
    dashboardPagePlus(title = "GWAS Locus Browser",
                      dbHeader,
                  dashboardSidebar(
                    width = 425,
                    #searchbar
                    fluidRow(
                      column(12,
                             span(textInput(inputId = "searchBar", label = NULL, placeholder = "locus1, rs114138760, chr1, 1:154898185, PMVK, etc", width = "325px"), style = "display:inline-block;"),
                             span(actionButton(inputId = "submitButton", label = "Search"), style = "display:inline-block;")
                      )
                    ),
                    fluidRow(
                      column(div(h3("META5 Loci (Nalls et al. 2019):")), width = 12, offset=1)
                    ),
                    fluidRow(
                      column(div(dataTableOutput("META5Table"), style = "font-size:80%"), width = 12)
                    ),
                    fluidRow(
                      column(div(h3("Progression Loci (Iwaki et al. 2019):")), width = 12, offset=1)
                    ),
                    fluidRow(
                      column(div(dataTableOutput("ProgTable"), style = "font-size:80%"), width = 12)
                    ),
                    fluidRow(
                      column(div(selectInput("navSelect", choices = c(0),label = "Jump to Section:")), width = 12)
                      #column(div(dataTableOutput("navTable")),width = 12)
                    )
                    
                  ),
                  sidebar_fullCollapse = TRUE,
                  dashboardBody(
                    
                    
                    #remove the extra scrollbar 
                    tags$head(tags$style(
                      HTML('.wrapper {height: auto !important; position:relative; overflow-x:hidden; overflow-y:hidden}')
                    )),
                    tabsetPanel(id = "tabSetID",
                      tabPanel("Data",
                               value = "Data",
                               
                               id = "mainpanelID",

                               
                               hidden(htmlOutput("geneSearchOutput")),
                               div(htmlOutput("variantOutput")),
                               div(htmlOutput("rsOutput")),

                              
                               #include a blank and hidden accordion to overcome the automatic collapse of the first 
                               #accordion whenever the second one is collapsed/expanded (kind of hacky but oh well)
                               accordion(hidden = TRUE,
                                         accordionItem(
                                           id=0,
                                           title = 'blank accordion',
                                           collapsed = FALSE
                                         )
                               ),

                               accordion(
                                 accordionItem(
                                   id = 1,
                                   title = "Interactive Locus Zoom Plot:",
                                   collapsed = FALSE,
                                   fluidRow(
                                     column(div(id="lz-plot",class="lz-container-responsive"), width = 12)
                                     
                                   ),
                                   
                                 )
                               
                                         
                               
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "InteractiveLocusZoom", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),

                               accordion(
                                 accordionItem(
                                   id = 2,
                                   title = "Static Locus Zoom Plot:",
                                   collapsed = TRUE,
                                  div(id = "LocusZoomId"),
                                  fluidRow(
                                    column(align = "center", htmlOutput("locusZoomHeader"), width = 12)
                                  ),
                                  div(imageOutput("locusZoomPlot", width = "auto", height = "auto") %>% helper(icon = "question-circle", type = "inline", title = "help", content = c("### this is a help message"), buttonLabel = "done", easyClose = F, fade = T, size = "m"))
                                 )
                               
                               
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "StaticLocusZoom", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),

                               accordion(
                                 accordionItem(
                                   id = 3,
                                   title = "Summary Statistics:",
                                   collapsed = FALSE,
                                   
                                   br(),
                                   fluidRow(
                                     column(
                                       div(htmlOutput("sumstatsVariantOutput")),
                                       div(htmlOutput("sumstatsRSOutput")),
                                       div(htmlOutput("nearGeneOutput")), 
                                       div(htmlOutput("locusOutput")),
                                       div(htmlOutput("UCSClinkOutput")),
                                       br(),
                                       div(htmlOutput("locusSpecialTextOutput")),
                                       width = 4),
                                     column(
                                       htmlOutput("studyOutput"),
                                       dataTableOutput("snpStatsTable"),
                                       width = 4),
                                     column(
                                       dataTableOutput("freqTable"),
                                       width = 4
                                     )
                                     
                                     
                                   ),
                                   div(id="otherstats",
                                       fluidRow(
                                         column(
                                           h4("Age of Onset Summary Stats (Blauwendraat et al. 2019):"),
                                           dataTableOutput("aooStatsTable"), width = 6),
                                         column(
                                           h4("GBA Age of Onset Summary Stats (Blauwendraat et al. 2020):"),
                                           dataTableOutput("gba_aooStatsTable"), width = 6)
                                         
                                       ),
                                       fluidRow(
                                         column(
                                           h4("GBA Risk Modifier Summary Stats (Blauwendraat et al. 2020):"),
                                           dataTableOutput("gbaStatsTable"), width = 6),
                                         column(
                                           h4("LRRK2 Risk Modifier Summary Stats (Iwaki et al. 2020):"),
                                           dataTableOutput("lrrk2StatsTable"), width = 6)
                                       )
                                   )
                                 )
                               
                               
                               
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "SummaryStats", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                               accordion(
                                 accordionItem(
                                   id = 4,
                                   title = "Best Candidate:",
                                   collapsed = FALSE,
                                   fluidRow(
                                     column(htmlOutput("guessOutput"), width = 12)
                                   )
                                 
                                 )
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "BestCandidate", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                               

                               accordion(
                                 accordionItem(
                                   id = 5,
                                   title = "Evidence Per Gene:",
                                   collapsed = FALSE,
                                   fluidRow(
                                     column(selectInput("evidenceSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                   ),
                                   fluidRow(
                                     column(
    
    
                                       h4("Weights:"),
                                       span(sliderInput("META5Slider", label = "Nominated by META5", min = 0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
                                       span(sliderInput("qtlBrainSlider",label = "QTL-Brain",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"), 
                                       span(sliderInput("qtlBloodSlider",label = "QTL-Blood",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
                                       span(sliderInput("qtlCorrelSlider",label = "QTL-Correl",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
                                       span(sliderInput("burdenSlider",label = "Burden",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("brainExpSlider",label = "Brain Expression",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("nigraExpSlider",label = "Nigra Expression",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("SNDaExpSlider",label = "SN-Dop. Neuron Expression",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("litSearchSlider",label = "Literature Search",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("constraintSlider",label = "Variant Intolerant",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("pdGeneSlider",label = "PD Gene",  min=0, max = 4, step = 1, value = 1, ticks= F) , style = "display:inline-block; width:8%"),
                                       span(sliderInput("diseaseGeneSlider",label = "Disease Gene",  min=0, max = 4, step = 1, value = 1, ticks = F), style = "display:inline-block; width:8%"),
                                       
                                       
                                       br(),

    
                                       width = 12
                                     ),
                                     column(
                                       h4("Hide/Show Columns:"),
                                       checkboxGroupButtons(
                                         inputId = "evidenceColButtons",
                                         choices = c("Nominated by META5","QTL-brain","QTL-blood","QTL-correl","Burden","Brain Expression","Nigra Expression","SN-Dop. Neuron Expression","Literature Search","Variant Intolerant","PD Gene","Disease Gene"),
                                         justified = TRUE,
                                         individual = TRUE,
                                         width = '100%'
                                       ),
                                       width = 12
                                     ),
                                     
                                     column(
                                       dataTableOutput("evidenceTable"),
                                       
                                       width = 12
                                     )
                                   )
                                 )
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "EvidencePerGene", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                               accordion(
                                 accordionItem(
                                   id = 6,
                                   title = "QTL Evidence:",
                                   collapsed = FALSE,
 
                                   div(id = "qtlSection",
                                      fluidRow(
                                        column(selectInput("qtlSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                      ),
                                      fluidRow(
                                        column(align = "center", h4("Qi et al. Brain eQTL Locus Compare Plot"), width = 6),
                                        column(align = "center", h4("Vosa et al. Blood eQTL Locus Compare Plot"), width = 6)
                                      ),
                                      fluidRow(
                                        column(id = "brainQTLPlotdiv", align = "center", imageOutput("brainQTLPlot", width = "100%", height = "auto"), width = 6),
                                        column(id = "bloodQTLPlotdiv", align = "center", imageOutput("bloodQTLPlot", width = "100%", height = "auto"), width = 6)
                                      ),
                                      fluidRow(
                                        column(width = 2, offset = 6, selectInput("isoQTLSelect",label = "Choose an isoform", choices = c(0)))
                                      ),
                                      fluidRow(
                                        column(align = "center", h4("Psychencode Brain eQTL Locus Compare Plot"), width = 6),
                                        column(align = "center", h4("Psychencode Brain isoQTL Locus Compare Plot"), width = 6)
                                      ),
                                      fluidRow(
                                        column(id = "psychencode_eQTLPlotdiv", align = "center", imageOutput("pe_eQTLPlot", width = "100%", height = "auto"), width = 6),
                                        column(id = "psychencode_isoQTLPlotdiv", align = "center",
                                               imageOutput("pe_isoQTLPlot", width = "100%", height = "auto"), 
                                               width = 6
                                               )
                                      )
                                   )
                                 )
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "QTL", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 7,
                                  title = "Coding Variants:",
                                  collapsed = FALSE,
                                  

                                  div(
                                    fluidRow(
                                      column(dataTableOutput("codingTable"), width = 12)
                                    )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "CodingVariant", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 8,
                                  title = "Associated Variant Phenotypes:",
                                  collapsed = FALSE,
                                  div(
                                    fluidRow(
                                      column(dataTableOutput("phenotypeTable"), width = 12)
                                    )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "PhenotypeVariant", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 9,
                                  title = "Burden Evidence:",
                                  collapsed = FALSE,

                                  div(id = "burdenSection",
                                      fluidRow(
                                        column(selectInput("burdenSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                      ),
                                      fluidRow(
                                        column(dataTableOutput("burdenTable"), width = 5)
                                      )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Burden", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                 accordionItem(
                                   id = 10,
                                   title = "Expression Data:",
                                   collapsed = FALSE,
                                   
                                   div(id = "expSection",
                                       fluidRow(
                                         column(selectInput("expressionSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                       ),
                                       fluidRow(
                                         column(dataTableOutput("expressionTable"), width = 12)
                                       )
                                   )
                                 )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Expression", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 11,
                                  title = "Gene Single Cell Expression Plot:",
                                  collapsed = FALSE,
                                  
                                  fluidRow(
                                    column(selectInput("SingleCellSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                  ),
                                  fluidRow(
                                    column(imageOutput("SingleCellPlot", width = "30%", height = "auto"), width = 12)
                                  )
                                )
                              ),
                              accordion(
                                accordionItem(
                                  id = 12,
                                  title = "Gene Tissue Expression Plot:",
                                  collapsed = FALSE,
                                  
                                  fluidRow(
                                    column(selectInput("GTEXSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                  ),
                                  fluidRow(
                                    column(align = "center", h4("GTEX Expression Plot"), width = 8)

                                  ),
                                  fluidRow(
                                    column( align = "center", imageOutput("GTEXPlot", width = "100%", height = "auto"), width = 8)
                                  )
                                  
                                )
                              ),
                              
                              accordion(
                                 accordionItem(
                                   id = 13,
                                   title = "Constraint Values:",
                                   collapsed = FALSE,
                                  div(id="constraintSection",
                                       fluidRow(
                                         column(selectInput("constraintSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                       ),
                                       fluidRow(
                                         column(dataTableOutput("constraintTable"), width = 12)
                                       )
                                   )
                                 )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Constraint", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 14,
                                  title = "Disease Genes:",
                                  collapsed = FALSE,
   
                                  div(
                                      fluidRow(
                                        column(selectInput("diseaseSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                      ),
                                      fluidRow(
                                        column(dataTableOutput("diseaseTable"), width = 12)
                                      )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "DiseaseGene", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 15,
                                  title = "Fine-Mapping of Locus:",
                                  collapsed = FALSE,
                                  fluidRow(
                                    column(dataTableOutput("fineMappingTable"), width = 12)
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "FineMapping", buttonLabel = "Done", easyClose = F, fade = T, size = "l"),
                              
                              accordion(
                                 accordionItem(
                                   id = 16,

                                   title = "Literature:",
                                   collapsed = FALSE,
                                   
                                   div(id="litSection",

                                       fluidRow(
                                         column(selectInput("litGeneSelect",label = "Choose a gene", choices = c(0)), width = 2)
                                       ),
                                       fluidRow(

                                         
                                       ),
                                       fluidRow(
                                         column(
                                           fluidRow(
                                             column(h4("GeneCards Description") ,align="center",width = 12),
                                             column(htmlOutput("litOutput"), width = 12)
                                           ),
                                           width = 6

                                           
                                           ),
                                         column(
                                           fluidRow(
                                             column(h4("Word Cloud"), width = 12,align="center"),
                                             column(imageOutput("wordCloud", width = "75%", height = "auto"), width = 12, align = "center")
                                           ),
                                           width = 6

                                           
                                           )
                                       ),
                                       br(),
                                       fluidRow(
                                         column(plotlyOutput("pubMedHitPlot"), width = 6),
                                         column(plotlyOutput("geneHitPlot"), width = 6)
                                       )
                                   )
                                 )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Literature", buttonLabel = "Done", easyClose = F, fade = T, size = "l")
                              
                      ),
                      tabPanel(
                        "About",
                        value = "About",
                        htmlOutput("aboutOutput")
                      ),
                      selected = "About"
                    )
                    
                  )
        )
      )
    )
  )
)