$(document).ready(function(){
	var vHTML = '';
	vHTML += '<div class="banner-iframe">';

	var urlGet = "http://www.bemcasados.art.br/fornecedores/banners/";
	urlGet += urlVendor;

/*	 var xhReq = new XMLHttpRequest();
	 xhReq.open("GET", urlGet, false);
	 xhReq.send(null);
	 var serverResponse = xhReq.responseText;
	 alert(serverResponse); // Shows "15"*/

	if ($.browser.msie && window.XDomainRequest) {
	    // Use Microsoft XDR
	   var xdr = new XDomainRequest();
	   xdr.open("get", urlGet );
	   xdr.onload = function () {
	   //parse response as JSON
	   var JSON = $.parseJSON(xdr.responseText);
	   if (JSON == null || typeof (JSON) == 'undefined')
	   {
	        JSON = $.parseJSON(data.firstChild.textContent);
	   }
			vHTML += '<div class="banner" style="position:absolute" >';
			vHTML += '<img alt="Bem casados planeje o seu casamento" src="http://www.bemcasados.art.br/images/bemcasados_banner.png" /></div>';
			vHTML += '<div class="rating-bar" style="position: absolute;top: 50px;left:8px;width: 80px;background: url(http://www.bemcasados.art.br/images/stars_mini.png) repeat-x scroll 0 -33px transparent;display: inline-block;height: 17px;">';
			vHTML += '<div class="rating" style="position: absolute;height: 17px;display: inline-block;background: url(http://www.bemcasados.art.br/images/stars_mini.png) repeat-x scroll 0 2px transparent;width:';
			vHTML += 100*JSON["rating_average"]/5;
			vHTML += '%"></div>';
			vHTML += '</div>';
			vHTML += '</div>';
			//vHTML += 'Reviews: ' + result["number_reviews"];
			vHTML += '</div>';
			//alert(vHTML);
			document.getElementById("bemcasados-widget").innerHTML = vHTML;
	   //processData(JSON);

	   };
	    xdr.send();
	}
	else{
		$.ajax({
	    url: urlGet,
	    type: 'GET',
	    contentType: 'application/json; charset=utf-8',
	    dataType: 'JSONP',
	    data: {"name": name},
	    cache: false,
	    success: function(result){
			//vHTML += result["name"];
			vHTML += '<div class="banner" style="position:absolute">';
			vHTML += '<img alt="Bem casados planeje o seu casamento" src="http://www.bemcasados.art.br/images/bemcasados_banner.png" /></div>';
			vHTML += '<div class="rating-bar" style="position: absolute;top: 38px;left:8px;width: 80px;background: url(http://www.bemcasados.art.br/images/stars_mini.png) repeat-x scroll 0 -34px transparent;display: inline-block;height: 17px;">';
			vHTML += '<div class="rating" style="position: absolute;height: 17px;display: inline-block;background: url(http://www.bemcasados.art.br/images/stars_mini.png) repeat-x scroll 0 0 transparent;width:';
			vHTML += 100*result["rating_average"]/5;
			vHTML += '%"></div>';
			vHTML += '</div>';
			vHTML += '</div>';
			//vHTML += 'Reviews: ' + result["number_reviews"];
			vHTML += '</div>';
			document.getElementById("bemcasados-widget").innerHTML = vHTML;
	    }
		});
	}
	// Posicionamento do widget
	// 1 - Left
	// 0 - Right
	if ( widgetPosition == 1 )
	{
		$("#bemcasados-widget").css({
			'position' : 'fixed',
			'width' : '106px',
			'left' : '0px'
		});
	}
	else if ( widgetPosition == 0 ) 
	{
		$("#bemcasados-widget").css({
			'position' : 'fixed',
			'width' : '106px',
			'right' : '-9px'
		});
	}
	else if ( widgetPosition == 2 )
	{
		$("#bemcasados-widget").css({
			'position' : 'fixed',
			'width' : '106px',
			'right' : '-9px',
			'top' 	: '0px'
		});

	}
	else if ( widgetPosition == 3 )
	{
		$("#bemcasados-widget").css({
			'position' : 'fixed',
			'width' : '106px',
			'left' : '0',
			'top' 	: '0'
		});

	}

});
