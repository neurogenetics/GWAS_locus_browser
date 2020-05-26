//To pick up changes to this you may need to clear cached files in the browser

/*function tableClick(clicked_id)
{
  Shiny.setInputValue('clickedID', clicked_id);
  Shiny.setInputValue('varClick', Math.random());
}*/

function jumpToSection(sectionId)
{

  var scrolltop = document.documentElement.scrollTop;


  var b = document.querySelector(sectionId).parentElement; 


  
  var r   = b.getBoundingClientRect();


  window.scrollTo(0,r.top+scrolltop-115);
}

$(document).ready(function(){
	
	// Attach the jquery.ui draggable.
	//var containmentTop = $(".content-wrapper").position().top;
  $(".draggable").draggable({ 
		cursor: "move",
		handle: ".box-header",
        cancel: ".box-body",
        //containment: [,containmentTop,,]
  });

  //setup mouseover events for tutorial mode
  $('#tab-about').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"About");
    }

  })
  $('#tab-data').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"Data");
    }
  })
  $('.shinyhelper-icon').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"Help");
    }
  })
  $('.accordionheader').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"Accordion")
    }
  })
  $('#searchDiv').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"Search")
    }
  })
  $('#navSelectDiv').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"Navigate")
    }
  })/*.next(".selectize-control").children(".selectize-input")*/
  $('#gwasSelectDiv').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"GWASSelect")
    }
  })
  $('#gwasLociTable').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"GWASTable")
    }
  })
  $('.sidebar-toggle').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"SideBarToggle")
    }
  })
  $('.logo').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"Logo")
    }
  })
  $('.geneselect').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"GeneSelect")
    }
  })
  $('.slider').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"EvidenceSlider")
    }
  })
  $('#evidenceColButtons').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"EvidenceButton")
    }
  })
  $('.qtlcutoff').mouseover( function(){ 
    if($(this).hasClass('tutorial-highlight'))
    {
      $('.tutorial-selected').removeClass('tutorial-selected');
      $(this).addClass('tutorial-selected');
      Shiny.setInputValue('tutorial.select',"QTLCutoff")
    }
  })
});




function setTutorialSelect(select)
{
  Shiny.setInputValue('tutorial.select',select);
}

//Start, Header, Sidebar, Data
function setTutorialPage(page)
{
  Shiny.setInputValue('tutorial.page',page);
}

function setTutorialActivate(active)
{
  Shiny.setInputValue('tutorial.activate',active)
}



function do_locuszoom_stuff(input_snp, input_chr, input_bp, input_formatsnp,population)
{
  console.log(input_snp)
  console.log(input_chr);
  console.log(input_bp);
  console.log(input_formatsnp);
        // First, tell the plot how to find each kind of data it will use. By default, it fetches a specific dataset
      //   from a UMich API, using a set of data sources that obey a specific URL format and payload structure.
      // If your API has different URL syntax, or needs to reformat data from the server before giving it to LZ.js,
      //   you can write a custom datasource.
      var apiBase = "https://portaldev.sph.umich.edu/api/v1/";
      
      //console.log(document.getElementById("interactive_ref_link").href);
      
      //get the href value from the link created in ui.R
      full_interactive_ref_link = document.getElementById("interactive_ref_link").href;
      //remove the specific file reference
      interactive_ref_link = full_interactive_ref_link.replace("rs114138760_locus.json", "")
      
      //console.log(interactive_ref_link);
      
      
      var ourdata = interactive_ref_link+input_snp+"_locus.json/"
      //var ourdata = "https://pdgenetics.shinyapps.io/GWASBrowser/_w_619d378c/interactive_stats/"+input_snp+"_locus.json/"
      //var ourdata = "http://127.0.0.1:6415//interactive_stats/"+input_snp+"_locus.json/"//"http://127.0.0.1:5103/rs114138760_locus.json/" 
      

      var data_sources = new LocusZoom.DataSources()
        .add("assoc", ["AssociationLZ", {url: ourdata, params: { id_field: "variant" }}])
        .add("ld", ["LDLZ2", { url: "https://portaldev.sph.umich.edu/ld/" }])
        .add("gene", ["GeneLZ", { url: apiBase + "annotation/genes/" }])
        .add("recomb", ["RecombLZ", { url: apiBase + "annotation/recomb/results/" }]);

        
        
        
      // Second, specify what kind of information to display. This demo uses a pre-defined set of panels with common
      //   display options, and tells all annotation tracks to auto-select data for a specific build
      var layout = LocusZoom.Layouts.get("plot", "standard_association", { state: { genome_build: 'GRCh37',ld_pop:population, chr:input_chr, start: input_bp-1000000, end: input_bp+1000000, ldrefvar: input_formatsnp}});

      var pop_layout = LocusZoom.Layouts.get("dashboard_components", "ldlz2_pop_selector");

      var new_layout = LocusZoom.Layouts.merge(layout, pop_layout);
      // Last, draw the plot in the div created in the HTML above.
      //   Using window.x ensures that a reference to the plot is available via the JS console for debugging
      window.plot = LocusZoom.populate("#lz-plot", data_sources, new_layout);

      
}