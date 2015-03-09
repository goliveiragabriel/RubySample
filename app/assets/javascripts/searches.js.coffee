# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateValuesChanged = (event, ui, changing) ->
  displayValues ui.label, ui.values  unless changing
  
updateValuesChanging = (event, ui, changing) ->
  displayValues ui.label, ui.values  if changing
  
displayValues = (slider, values) ->
  tempSelector = undefined
  tempSelector = $(slider).attr("id")
  $("form input.slider-" + tempSelector + "-min").val Math.round(values.min)
  $("form input.slider-" + tempSelector + "-max").val Math.round(values.max)
  ranges = Math.round(values.min) + "-" + Math.round(values.max)
  $("form input." + "capacity-range").val ranges
  
makeSlider = (selector, options) ->
  slider = $(selector).rangeSlider(options).bind("valuesChanging", (event, ui) ->
    updateValuesChanging event, ui, changing
  ).bind("valuesChanged", (event, ui) ->
    updateValuesChanged event, ui, changing
  ).addClass("ui-rangeSlider-dev")
  displayValues slider, slider.rangeSlider("values")
  
changing = true

jQuery ->

	$(".remove").click ->
	  filter = $(this).attr("filter-remove")
	  if filter
	    if filter == "name"
	      $("#search_name").val("")
	    else if filter == "address"
	      $("#search_address").val("")
	      $("#search_sort_by").val("number_reviews DESC")
	    else if filter == "service_type"
	      $("#search_service_type").val("")
	      $("#search-filter-details").remove();
	    else if filter == "price"
	      $("#search-filter-price input:checked").prop('checked', false)
	      $("#search_price_qualquer").prop('checked', true)
	    else
	    	filter_id = "#filter_" + filter
	    	$(filter_id).remove();
	    $("#search-filter-form").submit()
	  
	#$(".search-sort").click (e) ->
	#  #$("u#search-sort-selected").children().unwrap()
	#  $("#search-results").append "<div class=\"progress\"><img src=\"/assets/progress_large.gif\" width=\"25\" height=\"25\" alt=\"\" /></div>"
	#  #$(this).wrap('<u id="search-sort-selected" />')
	#  $.getScript @href
	#  e.preventDefault()
	  
	#$(".service-menu a").click ->
	#  $("#search_service_type").val($(this).attr("data-service"))
	#  $("#service_menu_submit").val("1")
	#  $("#search-form").submit()
	  
	makeSlider "#range",

	  bounds:
	    min: 0
	    max: 1500

	  defaultValues:
	    min: $(".slider-range-min").val()
	    max: $(".slider-range-max").val()

	  formatter: (value) ->
	    step = 50
	    Math.floor(value / step) * step
