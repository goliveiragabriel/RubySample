/* ----------------------------------
jQuery Timelinr 0.9.52
tested with jQuery v1.6+

Copyright 2011, CSSLab.cl
Free under the MIT license.
http://www.opensource.org/licenses/mit-license.php

Editor: Gabriel de Oliveira Gonçalves

instructions: http://www.csslab.cl/2011/08/18/jquery-timelinr/
---------------------------------- */

jQuery.fn.timelinr = function(options){
	// default plugin settings
	settings = jQuery.extend({
		orientation: 				'horizontal',		// value: horizontal | vertical, default to horizontal
		containerDiv: 				'#timeline',		// value: any HTML tag or #id, default to #timeline
		datesDiv: 					'#dates',			// value: any HTML tag or #id, default to #dates
		datesSelectedClass: 		'clicked',			// value: any class, default to selected
		datesSpeed: 				'normal',			// value: integer between 100 and 1000 (recommended) or 'slow', 'normal' or 'fast'; default to normal
		issuesDiv: 					'#issues',			// value: any HTML tag or #id, default to #issues
		issuesSelectedClass: 		'clicked',			// value: any class, default to selected
		issuesSpeed: 				'fast',				// value: integer between 100 and 1000 (recommended) or 'slow', 'normal' or 'fast'; default to fast
		issuesTransparency: 		0,				// value: integer between 0 and 1 (recommended), default to 0.2
		issuesTransparencySpeed: 	500,				// value: integer between 100 and 1000 (recommended), default to 500 (normal)
		prevButton: 				'#prev',			// value: any HTML tag or #id, default to #prev
		nextButton: 				'#next',			// value: any HTML tag or #id, default to #next
		arrowKeys: 					'false',			// value: true | false, default to false
		startAt: 					1,					// value: integer, default to 1 (first)
		autoPlay: 					'false',			// value: true | false, default to false
		autoPlayDirection: 			'forward',			// value: forward | backward, default to forward
		postClass:                  '.post_line', 
		autoPlayPause: 				2000				// value: integer (1000 = 1 seg), default to 2000 (2segs)
	}, options);
	$(function(){
		// setting variables... many of them
		var howManyDates = $(settings.datesDiv+' li').length;
		var howManyIssues = $(settings.issuesDiv+' li').length;
		var currentDate = $(settings.datesDiv).find('a.'+settings.datesSelectedClass);
		var currentIssue = $(settings.issuesDiv).find('li.'+settings.issuesSelectedClass);
		var widthContainer = $(settings.containerDiv).width();
		var heightContainer = $(settings.containerDiv).height();
		var widthIssues = $(settings.issuesDiv).width();
		var heightIssues = $(settings.issuesDiv).height();
		var widthIssue = $(settings.issuesDiv+' li').width();
		var heightIssue = $(settings.issuesDiv+' li').height();
		var widthDates = $(settings.datesDiv).width();
		var heightDates = $(settings.datesDiv).height();
		var widthDate = $(settings.datesDiv + " > li").outerWidth()
		var heightDate = $(settings.datesDiv+' li').height();
		var howManyPosts = $("#issues li > div").length;
		// set positions!
		if(settings.orientation == 'horizontal') {	
			$(settings.issuesDiv).width(howManyIssues*widthIssue);
			$.each( $(settings.issuesDiv+" li"), function(i,value){
				$(value).css("left", i*widthIssue);
			});
			$.each( $(settings.datesDiv+" li"),function(i,value){
				$(value).css("left",i*widthDate);
			});
			// Gerar pontos aleatorios
			// $.each( $(".post_line"), function(i, value){
			// 	var maxVerticalPosition = $(value).parent().height();
			// 	var maxHorizontalPosition = $(value).parent().width();
			// 	$(value).css("left", Math.random()*maxHorizontalPosition);
			// 	$(value).css("top", Math.random()*maxVerticalPosition);
			// })
			$(settings.datesDiv).css('width', howManyDates*$("#dates > li").outerWidth());
			widthDate = $(settings.datesDiv).width();
			$(settings.issuesDiv + " #" + $("." + settings.issuesSelectedClass).attr("id")).css("opacity",1);
		} else if(settings.orientation == 'vertical') {
			$(settings.issuesDiv).height(heightIssue*howManyIssues);
			$(settings.datesDiv).height(heightDate*howManyDates).css('marginTop',heightContainer/2-heightDate/2);
			var defaultPositionDates = parseInt($(settings.datesDiv).css('marginTop').substring(0,$(settings.datesDiv).css('marginTop').indexOf('px')));
		}
		$(settings.containerDiv).ready(function(){

			$(".post_line").click( function(event){
				event.preventDefault();
				// first vars
				var whichIssue = $(this).text();
				var currentIndex = $(this).parent().prevAll().length;

				var clickedPost = $(settings.datesDiv + " ." + settings.datesSelectedClass );
				var thisTagId = $(this).parent().parent().attr('class');
				var clickedPostTagId = $(clickedPost.parent().parent()).attr('class');
				var clickedPostTagPositionLeft = $("#issues ." + thisTagId).position().left;
				if ($(this).hasClass(settings.datesSelectedClass)){
					event.preventDefault();
				}
				else {
					// moving the elements
					if(settings.orientation == 'horizontal') {

						$("#issues #" + clickedPost[0].id).css("opacity",0);
						$("#issues #" + this.id).css('opacity',1);

						if (thisTagId != clickedPostTagId ){
							console.log("diferete");
							$("#issues ." + thisTagId).css("left",0);
							$("#issues ." + clickedPostTagId).css("left", clickedPostTagPositionLeft);
						}
						
					} else if(settings.orientation == 'vertical') {
						$(settings.issuesDiv).animate({'marginTop':-heightIssue*currentIndex},{queue:false, duration:settings.issuesSpeed});
					}
					// if(howManyDates == 1) {
					// 	$(settings.prevButton+','+settings.nextButton).fadeOut('fast');
					// } else if(howManyDates == 2) {
					// 	if($(settings.issuesDiv+' li:first-child').hasClass(settings.issuesSelectedClass)) {
					// 		$(settings.prevButton).fadeOut('fast');
					// 	 	$(settings.nextButton).fadeIn('fast');
					// 	} 
					// 	else if($(settings.issuesDiv+' li:last-child').hasClass(settings.issuesSelectedClass)) {
					// 		$(settings.nextButton).fadeOut('fast');
					// 		$(settings.prevButton).fadeIn('fast');
					// 	}
					// } else {
					// 	if( $(settings.issuesDiv+' li:first-child').hasClass(settings.issuesSelectedClass) ) {
					// 		$(settings.prevButton).fadeOut('fast');
					// 	} 
					// 	else if( $(settings.issuesDiv+' li:last-child').hasClass(settings.issuesSelectedClass) ) {
					// 		$(settings.nextButton).fadeOut('fast');
					// 	}
					// 	else {
					// 		$(settings.nextButton+','+settings.prevButton).fadeIn('slow');
					// 	}	
					// }
					// now moving the dates
					$(settings.datesDiv+' a').removeClass(settings.datesSelectedClass);
					$(this).addClass(settings.datesSelectedClass);
					if(settings.orientation == 'horizontal') {
						// $(settings.datesDiv).animate({'marginLeft':defaultPositionDates-(widthDate*currentIndex)},{queue:false, duration:'settings.datesSpeed'});
					} else if(settings.orientation == 'vertical') {
						$(settings.datesDiv).animate({'marginTop':defaultPositionDates-(heightDate*currentIndex)},{queue:false, duration:'settings.datesSpeed'});
					}
				}
				event.preventDefault();
			});
		});
		$(".post_line").mouseover(function(event){
			var hoverPostId = this.id;
			var postContent = $("#issues #" + hoverPostId).html();
			var postTitle = $("#issues #" + hoverPostId + " .content h4").text();
			var postImage = $("#issues #" + hoverPostId + " > a").html();
			// check overflow
			if ( $(this).offset().left > 1150 ) {
				var html_s = "<div class='pop-line p-east clearfix'><a href='#'>" + postImage + "</a><div class='content'><h4>" + postTitle + "</h4></div></div>";
				$("#dates ." + $(this).parent().parent().attr('class')).append(html_s);
				var position = $(this).position().left - $('.pop-line').width();
				$('.pop-line').css("left",position + 40);
				$('.pop-line').css("top",$(this).position().top + 56);
				$(".pop-line").fadeIn('slow');
				return false;
			}
			else {
				var html_s = "<div class='pop-line p-west clearfix'><a href='#'>" + postImage + "</a><div class='content'><h4>" + postTitle + "</h4></div></div>";
				$("#dates ." + $(this).parent().parent().attr('class')).append(html_s);
				$('.pop-line').css("left",$(this).position().left + 25);
				$('.pop-line').css("top",$(this).position().top + 56);
				$(".pop-line").fadeIn('slow');
				return false;
			}

			event.preventDefault();
		}).mouseout(function(event){
			event.preventDefault();
			$(".pop-line").remove();
			event.preventDefault();
		}
		);

		$("#next").click(function(event){
			$("#prev").css("display","block");
			$.each( $(settings.datesDiv+" > li"),function(i,value){
				$(value).animate({
					left : $(value).position().left - $("#wedding-line").width()
				}, 1500);
				$(value).css("left",$(value).position().left - $("#wedding-line").width());
				// Checa se chegou ao final para remover o next button
				if ( i == ( $(settings.datesDiv + " > li" ).length - 1) ){
					if ( $(value).position().left < $("#wedding-line").width() ){
						$("#next").css("display","none");
						$("#prev").css("display","block");
					} 
				}
			});
			event.preventDefault();
		})
		$("#prev").click(function(event){
			$.each( $(settings.datesDiv+" > li"),function(i,value){
				$(value).animate({
					left: $(value).position().left + $("#wedding-line").width()
				},1500);
				$(value).css("left",$(value).position().left + $("#wedding-line").width());
				if( i == 0){
					if ( ( $(value).position().left >= 0 ) && ( $(value).position().left < $("#wedding-line").width() ) ){
						$("#prev").css("display","none");
						$("#next").css("display","block");
					}
				}
			});
			event.preventDefault();
		})

		// keyboard navigation, added since 0.9.1
		if(settings.arrowKeys=='true') {
			if(settings.orientation=='horizontal') {
				$(document).keydown(function(event){
					if (event.keyCode == 39) { 
				       $(settings.nextButton).click();
				    }
					if (event.keyCode == 37) { 
				       $(settings.prevButton).click();
				    }
				});
			} else if(settings.orientation=='vertical') {
				$(document).keydown(function(event){
					if (event.keyCode == 40) { 
				       $(settings.nextButton).click();
				    }
					if (event.keyCode == 38) { 
				       $(settings.prevButton).click();
				    }
				});
			}
		}
		// default position startAt, added since 0.9.3
		$(settings.datesDiv+' li').eq(settings.startAt-1).find('a').trigger('click');
		// autoPlay, added since 0.9.4
		if(settings.autoPlay == 'true') { 
			setInterval("autoPlay()", settings.autoPlayPause);
		}
	});
};

// autoPlay, added since 0.9.4
function autoPlay(){
	return false;
}