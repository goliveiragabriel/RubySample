# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

# $("a[rel=\"gallery\"]").fancybox
#  transitionIn: "elastic"
#  transitionOut: "elastic"
#  showNavArrows: true
#  scrolling: "no"
#  titleShow: false
#  overlayOpacity: 0.5
#  overlayColor: "#000"
#  padding: 0
#  onComplete: ->
#    $("#dress-link").remove()  if $("#dress-link").length > 0
#    alert $.fancybox.pos
#    html = "<a id='dress-link' href='/vestidos/"
#    html += "413'"
#    html += " style='position:absolute;width:100%;height:100%;top:0;z-index:9999;text-indent:-9999px;' >Vestido</a>"
#    $("#fancybox-outer").prepend html

	$("a#dress-photo-gallery").fancybox
		type	: 'inline'
		transitionIn: "elastic"
		transitionOut: "elastic"
		showNavArrows: true
		scrolling: "no"
		titleShow: false
		overlayOpacity: 0.5
		overlayColor: "#000"
		padding: 0




	$(".result a.favourite").on "click", ->
		$(".result a.favourite").removeClass("last");
		$(this).toggleClass "bookmarked last"
		$.post(this.href, {_method: $(this).attr("data-method")})
		return false

	$("#search-filter-form input").on "change", ->
		$.get $("#search-filter-form").attr("action"), $("#search-filter-form").serialize(), null, "script"
		return false

	$("#search-filter-form a").on "click", ->
		$(this).prev().children("input").attr('checked', true)
		$(this).parents("ul").children("li").children("a").hide()
		$(this).parents("ul").children("li").children("span").show()
		$.get $("#search-filter-form").attr("action"), $("#search-filter-form").serialize(), null, "script"
		return false

	$("#facebook_like_button_holder iframe").on "click", ->
		url = "/vestidos/" + $(this).parent().attr("dress-id") + "/update_share"
		$.get(url)
		return false

	$(".filters-wrapper ul li a").each ->
		$(this).qtip
			content: $(this).find("span.tiptext").html()
			position:
				corner:
					target: "rightMiddle"
					tooltip: "leftMiddle"
			style:
				width: 315
				color: "#868686"
				padding: 10
				textAlign: "left"
				tip: true


