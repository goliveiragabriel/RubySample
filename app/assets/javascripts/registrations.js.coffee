# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $("#user_relationship_status").change ->
    flag = jQuery.inArray($("#user_relationship_status").val(), [ "In a relationship", "Engaged", "Married", "In a open relationship" ])
    other = $("div#user_significant_other")
    if flag > -1 then other.show() else other.hide()