//To pick up changes to this you may need to clear cached files in the browser

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
/*
function setTutorialActivate(active)
{
  Shiny.setInputValue('tutorial.activate',active)
}*/


