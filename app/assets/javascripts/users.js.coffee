# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

	# Height and Padding on Favourite Dreess Section
	$(".row a.more").each ->
	  $(this).css
	    height: parseInt($(this).closest("div").height() / 2) + 16 + "px"
	    "padding-top": parseInt($(this).closest("div").height() / 2) + 16 + "px"

	$(".group h3").click(->
	  if $(this).hasClass("active")
	    $(".active").addClass("collapsed").removeClass("active").next("div").slideUp "fast"
	  else
	    $(".active").addClass("collapsed").removeClass("active").next("div").slideUp "fast"
	    $(this).addClass("active").removeClass("collapsed").next("div").slideDown "fast"
	  false
	).filter(":eq(0)").click()

	$(".lightbox_profile_edit").fancybox
	  titleShow: false
	  overlayOpacity: 0.5
	  overlayColor: "#000"
	  centerOnScroll: true
	  padding: 0
	  type: "iframe"
	  width: 568
	  height: 600
	  showNavArrows: false
	  onCleanup: ->
	    window.location.reload()

	if $("#wedding_line").length > 0
     $().timelinr
      orientation: 'horizontal',
      containerDiv: '#wedding-line',
      datesDiv: '#dates',
      datesSelectedClass: 'clicked',
      datesSpeed: 'normal',
      issuesDiv : '#issues',
      issuesSelectedClass: 'clicked',
      issuesSpeed: 'fast',
      issuesTransparency: 0,
      issuesTransparencySpeed: 500,
      prevButton: '#prev',
      nextButton: '#next',
      arrowKeys: 'false',
      startAt: 1,
      autoPlay: 'false',
      autoPlayDirection: 'forward',
      autoPlayPause: 2000
  
