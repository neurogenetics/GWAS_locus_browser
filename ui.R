library(shiny)
library(DT)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyanimate)
library(shinyWidgets)
library(plotly)
library(shinyhelper)

#date the pubmed hits and word clouds were last generated
pubmed_search_date <-"May 6, 2020"

#logo
dbHeader <- dashboardHeaderPlus(
  title = tagList(actionLink("wrapperLogo", span(img(src = "logos/IDPGC-locusbrowser.wrapper.png", id = "wrapperLogo", width = "80%"),h4("v1.2",style="display: inline; position: relative; top: 26px; color: #0a3a87")))),
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
    #span("ALPHA RELEASE", class="VersionText"),
    HTML("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"),
    actionBttn('tab-data', "Data", style = "minimal"),
    actionBttn('tab-about', "About", style = "minimal"),
    style = "text-align:right"
  )
)
# help
shinyUI(tagList(
  useShinyjs(),
  withAnim(),
  tags$script(src = 'javascript/jquery-ui.min-draggable+position.js'),
  #include code for google analytics
  tags$head(tags$script(async=NULL, src="https://www.googletagmanager.com/gtag/js?id=UA-155922190-1")),
  tags$head(includeScript("www/javascript/google-analytics.js")),
  
  tags$script(JS("window.onscroll= function() {
  var scrolltop = document.documentElement.scrollTop;
  console.log(scrolltop-115);
                          };")),
  
  #include javascript code 
  tags$script(src = "javascript/clickdetect.js"),
  #include locus zoom javascript code
  tags$script(src = "javascript/locuszoom.vendor.min.js"),
  tags$script(src = "javascript/locuszoom.app.js"),
  tags$script(src = "javascript/lz-dynamic-urls.min.js"),
  tags$head(includeCSS("www/css/locuszoom.css")),

  #include css file
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
    dashboardPagePlus(title = "GWAS Locus Browser", skin="black",
                      dbHeader,
                  dashboardSidebar(
                    width = 475,
                    boxPlus(
                      width = 12,
                      status="orange",
                      #searchbar
                      fluidRow(
                        column(div(searchInput("searchInputBar", placeholder = "locus1, rs114138760, chr1, 1:154898185, PMVK, etc",btnSearch = icon("search"),width = "425px"),id="searchDiv"), width = 12)
                      ),
                      hr(),
                      fluidRow(
                        column(div(selectInput("gwasSelect", choices = c(0),label = "Choose a GWAS"),id="gwasSelectDiv"), width = 12)
                      ),
                      

                      fluidRow(
                        column(div(htmlOutput("gwasOutput")), width = 12)
                      ),
                      fluidRow(
                        column(div(dataTableOutput("gwasLociTable"), style = "font-size:80%"), width = 12)
                      )
                    )
                    
                  ),
                  sidebar_fullCollapse = TRUE,
                  dashboardBody(
                    
                    hidden(
                      absolutePanel(
                        boxPlus(
                          title = "Hold me to move me around!",
                          # title = actionLink( #actionBttn(
                          #   "hide.draggable.top.tutorial",
                          #   label = "",
                          #   icon = icon('times'),
                          #   class = "btn btn-box-tool"#,
                          #   #style = 'simple',
                          #   #color = 'default',
                          #   #size = 'sm'
                          # ),#"Variant",
                          uiOutput("tutorial"),
                          width = 12,
                          closable = F,
                          status = "success",
                          solidHeader = T
                        ),
                        class = "draggable",
                        # draggable = T,
                        # fixed = T,
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
                                   title = span("Locus Zoom:",class="accordionheader"),
                                   collapsed = FALSE,
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
                                 )
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "LocusZoom", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                               
                               accordion(
                                 accordionItem(
                                   id = 2,
                                   title = span("Summary Statistics:",class="accordionheader"),
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
                                   hr(),

                                   div(id="otherstats",
                                       fluidRow(
                                         column(
                                           h3("Summary Statistics from Other GWASes:"),
                                           dataTableOutput("otherSumStatsTable"),
                                           width = 12
                                         )
                                       )
                                       
                                       
                                       
                                   )
                                 )
                               
                               
                               
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "SummaryStats", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                               accordion(
                                 accordionItem(
                                   id = 3,
                                   title = span("Best Candidate:",class="accordionheader"),
                                   collapsed = FALSE,
                                   fluidRow(
                                     column(htmlOutput("guessOutput"), width = 12)
                                   )
                                 
                                 )
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "BestCandidate", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                               

                               accordion(
                                 accordionItem(
                                   id = 4,
                                   title = span("Evidence Per Gene:",class="accordionheader"),
                                   collapsed = FALSE,
                                   fluidRow(
                                     column(div(selectInput("evidenceSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2)
                                   ),
                                   fluidRow(
                                     column(
    
    
                                       h4("Weights:"),
                                       div(
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
                                       class="slider"
                                       ),
                                       
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
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "EvidencePerGene", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                               accordion(
                                 accordionItem(
                                   id = 5,
                                   title = span("QTL Evidence:",class="accordionheader"),
                                   collapsed = FALSE,
                                   div(id = "qtlSection",
                                       

                                       fluidRow(
                                         column(div(selectInput("qtlSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2),
                                         column(div(numericInput("qtl_correl_cutoff", label = "Correlation Cutoff", value = 0.3, min = 0.00, max = 1.0,step=0.1),class="qtlcutoff"),width = 2)
                                       ),
                                       fluidRow(
                                         column(htmlOutput("qtl_correl_score_text"), width = 12)
                                       ),
                                       hr(),




                                       
                                       h3("Locus Compare Plot Data:"),
                                       p(HTML('The selected plot is highlighted and <b>bolded</b> values contribute to scores calculated using the above "QTL Scoring" input.')),
                                       fluidRow(
                                         column(dataTableOutput("qtlPlotTable"), width = 12)
                                       ),
                                       hr(),
                                       h3("Locus Compare Plots:"),
                                       fluidRow(
                                         column(tabsetPanel(id="qtltabsetPanel"
                                                            ,type="pills",
                                                            tabPanel('Qi et al. Brain eQTL',
                                                                     div(
                                                                       fluidRow(
                                                                         column(align = "center", h3("Qi et al. Brain eQTL Locus Compare Plot"), width = 12)
                                                                       ),
                                                                       fluidRow(
                                                                         column(id = "brainQTLPlotdiv", align = "center", imageOutput("brainQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                                                       ),
                                                                     )
                                                                               
                                                                               
                                                                      
                                                              ),

                                                              tabPanel('Vosa et al. Blood eQTL',
                                                                       div(
                                                                         fluidRow(
                                                                           column(align = "center", h3("Vosa et al. Blood eQTL Locus Compare Plot"), width = 12)
                                                                         ),
                                                                         fluidRow(
                                                                           column(id = "bloodQTLPlotdiv", align = "center", imageOutput("bloodQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                                                         ),
                                                                       )
                                                              ),
                                                              tabPanel('PsychENCODE eQTL',
                                                                       div(
                                                                         fluidRow(
                                                                           column(align = "center", h3("PsychENCODE Brain eQTL Locus Compare Plot"), width = 12)
                                                                         ),
                                                                         fluidRow(
                                                                           column(id = "pe_eQTLPlotdiv", align = "center", imageOutput("pe_eQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                                                         ),
                                                                       )
                                                              ),

                                                              tabPanel('PsychENCODE isoQTL',
                                                                       div(
                                                                         fluidRow(
                                                                           column(width = 2, selectInput("isoQTLSelect_tab",label = "Choose an isoform", choices = c(0)))                              
                                                                         ),
                                                                         fluidRow(
                                                                           column(align = "center", h3("PsychENCODE Brain isoQTL Locus Compare Plot"), width = 12)
                                                                         ),
                                                                         fluidRow(
                                                                           column(id = "pe_isoQTLPlotdiv", align = "center", imageOutput("pe_isoQTLPlot_tab", width = "60%", height = "auto"), width = 12)
                                                                         ),
                                                                       )
                                                                       
                                                                       
                                                                        
                                                              )
                                                            ), width = 12)
                                       )

                                   )
                                 )
                               ) %>% helper(icon = "question-circle", type = "markdown", content = "QTL", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 6,
                                  title = span("Coding Variants:",class="accordionheader"),
                                  collapsed = FALSE,

                                  div(
                                    fluidRow(
                                      column(dataTableOutput("codingTable"), width = 12)
                                    )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "CodingVariant", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 7,
                                  title = span("Associated Variant Phenotypes:",class="accordionheader"),
                                  collapsed = FALSE,
                                  div(
                                    fluidRow(
                                      column(dataTableOutput("phenotypeTable"), width = 12)
                                    )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "PhenotypeVariant", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 8,
                                  title = span("Burden Evidence:",class="accordionheader"),
                                  collapsed = FALSE,

                                  div(id = "burdenSection",
                                      fluidRow(
                                        column(div(selectInput("burdenSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2)
                                      ),
                                      fluidRow(
                                        column(dataTableOutput("burdenTable"), width = 5)
                                      )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Burden", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              
                              accordion(
                                accordionItem(
                                  id = 9,
                                  title = span("Expression Data:",class="accordionheader"),
                                  collapsed = FALSE,
                                  fluidRow(
                                    column(div(selectInput("expressionSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2)
                                  ),
                                  fluidRow(
                                    column(tabsetPanel(type="pills",
                                                       tabPanel("Table", 
                                                                fluidRow(
                                                                  column(dataTableOutput("expressionTable"), width = 12)
                                                                )
                                                       ),
                                                       tabPanel("Single Cell Expression Bar Plot", 
                                                                fluidRow(
                                                                  column(align = "center", imageOutput("SingleCellPlot", width = "33%", height = "auto"), width = 12)
                                                                )
                                                       ),
                                                       tabPanel("GTEx Expression Violin Plot", 
                                                                fluidRow(
                                                                  column(align = "center", h4("GTEx Expression Plot"), width = 12)
                                                                  
                                                                ),
                                                                fluidRow(
                                                                  column( align = "center", imageOutput("GTEXPlot", width = "40%", height = "auto"), width = 12)
                                                                )
                                                       ),
                                                       selected = "Table"
                                    )
                                    ,width = 12)
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Expression", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              
                              accordion(
                                 accordionItem(
                                   id = 10,
                                   title = span("Constraint Values:",class="accordionheader"),
                                   collapsed = FALSE,
                                  div(id="constraintSection",
                                       fluidRow(
                                         column(div(selectInput("constraintSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2)
                                       ),
                                       fluidRow(
                                         column(dataTableOutput("constraintTable"), width = 12)
                                       )
                                   )
                                 )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Constraint", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 11,
                                  title = span("Disease Genes:",class="accordionheader"),
                                  collapsed = FALSE,
   
                                  div(
                                      fluidRow(
                                        column(div(selectInput("diseaseSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2)
                                      ),
                                      fluidRow(
                                        column(dataTableOutput("diseaseTable"), width = 12)
                                      )
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "DiseaseGene", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              accordion(
                                accordionItem(
                                  id = 12,
                                  title = span("Fine-Mapping of Locus:",class="accordionheader"),
                                  collapsed = FALSE,
                                  fluidRow(
                                    column(dataTableOutput("fineMappingTable"), width = 12)
                                  )
                                )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "FineMapping", buttonLabel = "X", easyClose = T, fade = T, size = "l"),
                              
                              accordion(
                                 accordionItem(
                                   id = 13,

                                   title = span("Literature:",class="accordionheader"),
                                   collapsed = FALSE,
                                   
                                   div(id="litSection",


                                       fluidRow(
                                           column(div(selectInput("litGeneSelect",label = "Choose a gene", choices = c(0)),class="geneselect"), width = 2)
                                       ),
                                       boxPlus(
                                         title = "GeneCards Description",
                                         closable = FALSE,
                                         width = 12,
                                         status = "primary",
                                         htmlOutput("litOutput"),
                                         solidHeader = TRUE
                                       ),
                                       hr(),
                                       boxPlus(
                                         title= htmlOutput("pubMedHitHeader"),
                                         closable=FALSE,
                                         footer=HTML(paste0("<p>Number of PubMed articles from search term '(Parkinson's[Title/Abstract]) AND GENE_NAME[Title/Abstract]' for each gene as of ", pubmed_search_date,".</p><p>Click bars to open PubMed search for gene in a new tab.</p>")),
                                         width = 4,
                                         status="primary",
                                         plotlyOutput("pubMedHitPlot"),
                                         solidHeader=TRUE
                                       ),
                                       boxPlus(
                                         title= htmlOutput("geneHitHeader"),
                                         closable=FALSE,
                                         footer=HTML(paste0("<p>Number of PubMed articles from search term 'GENE_NAME[Title/Abstract]' for each gene as of ",pubmed_search_date,".</p><p>Click bars to open PubMed search for gene in a new tab.</p>")),
                                         width = 4,
                                         status="primary",
                                         plotlyOutput("geneHitPlot"),
                                         solidHeader=TRUE
                                       ),
                                       boxPlus(
                                         title= htmlOutput("wordCloudHeader"),
                                         closable=FALSE,
                                         footer=paste0("Word cloud for common words found in PubMed abstracts for the selected gene as of ",pubmed_search_date,"."),
                                         width = 4,
                                         status="primary",
                                         imageOutput("wordCloud", width = "100%", height = "auto"),
                                         solidHeader=TRUE
                                       )
                                   )
                                 )
                              ) %>% helper(icon = "question-circle", type = "markdown", content = "Literature", buttonLabel = "X", easyClose = T, fade = T, size = "l")
                              
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
                    
                  )
        )
      )
    )
  )
)