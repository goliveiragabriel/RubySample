# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $("#review_anonymous").change ->
  	picture = $("div#review_anonymous_picture")
  	if $("#review_anonymous").is ":checked" then picture.show() else picture.hide()