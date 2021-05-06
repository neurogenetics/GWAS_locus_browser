# GWAS_locus_browser
* updated 5/6/2021

## Contributors
* Main Developers: Francis P. Grenn, Jonggeol J. Kim, Mary B. Makarious
* Design and Concept: Francis P. Grenn, Jonggeol J. Kim, Mary B. Makarious, Cornelis Blauwendraat, Andrew B. Singleton

## File Overview
* ui.R - code for user interface layout.
* server.R - code for server logic.
* global.R - library imports and code to call other R files. Make changes to this file if you are adding a new section to the browser.
* sidebar.R - code for the sidebar and header elements. Contains logic for the searchbar.
* tutorial.R - code for the tutorial mode.
* about.R - code for the about tab. 
* [name]_section.R - code for a section in the browser. 
* appManifest.txt - list of files and folders that will be deployed to the server for the public version of the app
   * typically includes: all .R files, the www/ folder
* DataProcessing - contains all scripts used to filter and clean the data for the app
* www - contains all the data (tables and images) that will be displayed in the app


## Making Changes

Some general steps to follow if you are adding new data to the browser.

* #### 1) Adding a new section (one of the collapseable/expandable parts with tables, images, etc) to the data tab of the browser.
* #### 2) Adding new variants from an exisitng GWAS. (WIP)
* #### 3) Adding new data to the evidence per gene table. (WIP)


### 1) Adding a New Section to the Data Tab
#### a) Make a New Section R File
Make a new R file (something like [name]_section.R).

Some simple examples are `burden_section.R`,`pheno_vars_section.R`,etc...

The R file will need the following for it to work in the browser:

  * ##### (i) start with a list that will contain variables and functions for the new section.
    * (ii)-(vii) must all be added to this list
    ```R
    newSection<-list()
    ```
  * ##### (ii) add an `id` to the list
    * this will be used to identify the section when using the "jump to section" drop down.
    * this will also be used to identify the correct help markdown file for the section.
    ```R
    newSection$id <- "newsection"
    ```
  * ##### (iii) add a `title` to the list
    * this is the title that will be displayed for the section in the browser.
    ```R
    newSection$title <- "New Section Title"
    ```
  * ##### (iv) add a `loadData` function to the list
    * this function should contain code to read data and create dataframes. Variable, dataframes, etc, that will be displayed in the browser should be initilized using `<<-` (not `<-`). 
    * Input: None.
    * Output: No return values needed.
    ```R
    newSection$loadData<- function(){
      new_section_data <<- fread("www/newSectionDataFile.csv")
    }
    ```
  * ##### (v) add a `generateUI` function to the list
    * this function will create the user interface for the section, excluding the accordion and help button. 
    * Input: None.
    * Output: Return all of the user interface code in a div, fluidRow, etc.
    ```R
    newSections$generateUI<- function(){
      fluidRow(
        column(dataTableOutput("newSectionTable"), width = 12)
      )
    }
    ```
  * ##### (vi) add a `serverLogic` function to the list
    * this function will contain all server logic code. This is where the outputs are rendered and changes to inputs are observed.
    * Input: input, output and session objects from the server
    * Output: None.
    ```R
    newSection$serverLogic <- function(input,output,session)
    {
      #code here to render outputs, observe inputs, etc...
    }
    ```
  * ##### (vii) can add other functions if necessary
    * `qtl_section.R`, for example, has extra functions added to its lists to allow it to communicate with the `evidence_section.R` code.
    
#### b) Add the New Section File to `global.R`
  * add code to reference the new R file 
  
  ```R
  source("new_section.R",local=T)
  ```
  * add the list from the R file to the `sections` list 
  
  ```R
  sections <- list(locusZoom=locusZoom,newSection=newSection)
  ```

#### c) Add a Help Markdown File
  * must be named after the section's id
  * the help markdowns go in `www/help_files/`
  
#### d) Update Documentation
  * update the version number in `global.R`
  * update the version and document the changes in the file used in the about tab.

#### e) Update `appManifest.txt`
  * add new R files to the `appManifest.txt` so they will be picked up when deploying the app.
  
### 2) Adding New Variants from an Exisitng GWAS. (WIP)
* See the `DataProcessing` directory for steps on which scripts to run.
  