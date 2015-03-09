// JavaScript Document
$(document).ready(function(){
  //Galleria.loadTheme('/assets/galleria.classic.min.js');
  $('#gallery').galleria({
    width:604,
    height:400,
    showInfo: false,
    transition: 'fade',
    imageTimeout: 60000,
    debug: false
  });

  $('#gallery_no_thumbs').galleria({
    width:604,
    height:400,
    showInfo: false,
    transition: 'fade',
    thumbnails: false,
    imageTimeout: 60000,
    debug: false
  });

  $('#dress-gallery').galleria({
    width:490,
    height:580,
    showInfo: false,
    transition: 'fade',
    debug: false
  }); 

  $('#dress-gallery_no_thumbs').galleria({
    width:490,
    height:580,
    showInfo: false,
    transition: 'fade',
    thumbnails: false,
    debug: false
  });

})