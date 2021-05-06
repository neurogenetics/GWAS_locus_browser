//To pick up changes to this you may need to clear cached files in the browser


function jumpToSection(sectionId)
{

  var scrolltop = document.documentElement.scrollTop;


  var b = document.querySelector(sectionId).parentElement; 


  
  var r   = b.getBoundingClientRect();


  window.scrollTo(0,r.top+scrolltop-115);
}