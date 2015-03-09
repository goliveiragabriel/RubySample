# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# dwIMageProtector
# http://davidwalsh.name/image-protector-plugin-for-jquery
jQuery.fn.protectImage = (settings) ->
  settings = jQuery.extend(
    image: "/assets/images/blank.gif"
    zIndex: 10
  , settings)
  @each ->
    position = $(this).position()
    height = $(this).height()
    width = $(this).width()
    $("<img />").attr(
      width: width
      height: height
      src: settings.image
    ).css(
      top: position.top
      left: position.left
      position: "absolute"
      zIndex: settings.zIndex
    ).appendTo "#gallery .galleria-images"

jQuery ->
	$(document).on('ajax:complete', 'a', (xhr, status) ->  
		$(this).parent().parent().parent().parent().replaceWith(status.responseText))

	$(".expand").live "click", (e) ->
	  e.preventDefault()
	  $(this).closest("section").animate
	    height: "100%", 
	    "medium"
	  $(this).addClass("hide").removeClass("expand").text "Ocultar detalhes «"
	  $.getScript(this.href);
	
	$(".hide").live "click", (e) ->
	  e.preventDefault()
	  $(this).closest("section").animate
	    height: "75px", 
	    "medium"
	  $(this).addClass("expand").removeClass("hide").text "Ler mais »"
	  
	if $("#gallery")
	  $(window).bind "load", ->
	    $("#gallery .galleria-images img").first().addClass("protect")
	    $("img.protect").protectImage()
	    $(".galleria-image-nav").css('zIndex', 9999)

	$("#unhide_telephone").live "click", (e) ->
	  e.preventDefault()
	  $.getScript(this.href);

# $('#off input').change ->
#	if $('#off-reason #invitation_active_false:checked')
#		$("#off-reason").toggle("slow");
#	if $('#off-reason #invitation_active_true:checked')
#		$('#off-reason textarea').val('');