# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	if $("#proposal_vendor_name").length > 0
	  $("#proposal_vendor_name").autocomplete(
	    minLength: 3
	  ,
	    source: $("#proposal_vendor_name").data("autocomplete-source")
	    select: (event, ui) ->
	      $("#proposal_vendor_name").val ui.item.name
	      $("#proposal_vendor_id").val ui.item.id
	      $("#proposal_vendor_email").val ui.item.email
	      false
	  ).data("autocomplete")._renderItem = (ul, item) ->
	    $("<li>").data("item.autocomplete", item).append("<a>" + item.name + "</a>").appendTo ul
    