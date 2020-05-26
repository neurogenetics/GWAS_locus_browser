# GWAS_locus_browser
* updated 05/26/2020

## Contributors
* Main Developers: Francis P. Grenn, Jonggeol J. Kim, Mary B. Makarious
* Design and Concept: Francis P. Grenn, Jonggeol J. Kim, Mary B. Makarious, Cornelis Blauwendraat, Andrew B. Singleton

## File Overview
* ui.R - code for app user interface layout
* server.R - main script that calls the following R files used for user interaction and data loading
* loci_sidebar.R - code for the sidebar and header inputs. Contains logic for the searchbar
* datatables.R - code to load all the data files in the "www/" folder
* qtl_section.R - code for the QTL Evidence section in the app
* locus_zoom_section.R - code for the interactive and static locus zoom plots
* tutorial.R - code for the tutorial mode
* literature_section.R - code to load the figures and text in the literature section
   * this will require authentication to run
* detail_panel.R - renders all the data in the data tab page based on user input
* About.R - code for the "about" tab
   * this will require authentication to run
* appManifest.txt - list of files and folders that will be deployed to the server for the public version of the app
   * typically includes: all .R files, the www/ folder
* DataProcessing - contains all scripts used to filter and clean the data for the app
* www - contains all the data, css and javascript files used in the app


## Making Changes
* When pushing updates to the code/data be sure to update the version number and version history in the "About" document for the "About" tab in the app.
* Make sure any new files are added to `appManifest.txt`