# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	# Toggle the hint of new quotation
	$('.readmore-toggle-comments').click ->
		$('.readmore-toggle-comments').addClass('atual');
		$('.comments').toggle("slow");

	$('.readmore-toggle-guests').click ->
		$('.readmore-toggle-guests').addClass('atual');
		$('.number-guests').toggle("slow");

	$('.readmore-toggle-telephone').click ->
		$('.readmore-toggle-telephone').addClass('atual');
		$('.telephone').toggle("slow");

	# Set row background 
	$('.quotation-index tr').each -> 
	 	status = $(this).find("td").eq(10).html();
	 	if (status == "Enviado")
	 		$(this).css("background","#E6FCCC")
	 	if (status == "Aguardando")
	 		$(this).css("background","#FCF2CC")

