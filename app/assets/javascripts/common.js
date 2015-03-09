/* W3 Cookies References*/
function getCookie(c_name) {
  var i,x,y,ARRcookies=document.cookie.split(";");
  for (i=0;i<ARRcookies.length;i++) {
    x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
    y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
    x=x.replace(/^\s+|\s+$/g,"");
    if (x==c_name) {
      return unescape(y);
    }
  }
}

function setCookie(c_name,value,exdays) {
  var exdate=new Date();
  exdate.setDate(exdate.getDate() + exdays);
  var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
  document.cookie=c_name + "=" + c_value + "; path=/";
}
/* ========================================================================  */
buscarPor = function(type) {
  if (type === "nome") {
    $("span#search_address").hide();
    $("span#search_name").show();
    $(".switch-field-address").removeClass("selected");
    $(".switch-field-name").addClass("selected");
    $("span#search_name input").val($("span#search_address input").val());
    $("span#search_address input").val("");
  } else if (type === "endereco") {
    $("span#search_address").show();
    $("span#search_name").hide();
    $(".switch-field-name").removeClass("selected");
    $(".switch-field-address").addClass("selected");
    $("span#search_address input").val($("span#search_name input").val());
    $("span#search_name input").val("");
  }
};

catselect = new function(){
  var timeout = null;
  this.togglePopup = function(){
    if ( search_is_menu == 1 ){
      $('#search-bar-form #categoryPopup').css("top", "39px");
      $('#search-bar-form #categoryTextbox').css("border-bottom-left-radius", "0px")
      $('#search-bar-form #categoryTextbox').css("border-color", "#009AB3");
      $("#search-bar-form #categoryTextbox").removeClass("selected");
      $("#search-bar-form #categoryTextbox").addClass("clicked");
      $("#search-bar-form #categoryTextbox span.arrow").css("background-position","-12px 0");
      this.clearTimeout();
      $('#search-bar-form .popup-bar').toggle('fast');
    }
    else if (search_is_menu == 0) {
      $('#search-banner-form .popup-banner').css("left", ( $("#search-banner-form #categoryTextbox").offset().left ) ).css("top", $("#search-banner-form #categoryTextbox").offset().top+30);
      $('#search-banner-form #categoryTextbox').css("border-bottom-left-radius", "0px")
      $('#search-banner-form #categoryTextbox').css("border-color", "#009AB3");
      $("#search-banner-form #categoryTextbox span.arrow").css("background-position","-12px 0");
      $("#search-banner-form #categoryTextbox").removeClass("selected");
      $("#search-banner-form #categoryTextbox").addClass("clicked");
      this.clearTimeout();
      $('#search-banner-form .popup-banner').toggle('fast');
    }
    else if ( search_is_menu == 2 ) {
      $('#search-blog-form .popup-blog').css("left", ( $("#search-blog-form #categoryTextbox").offset().left ) ).css("top", $("#search-blog-form #categoryTextbox").offset().top+30);
      $('#search-blog-form #categoryTextbox').css("border-bottom-left-radius", "0px");
      $('#search-blog-form #categoryTextbox').css("border-color", "#009AB3");
      $("#search-blog-form #categoryTextbox span.arrow").css("background-position","-12px 0");
      $("#search-blog-form #categoryTextbox").removeClass("selected");
      $("#search-blog-form #categoryTextbox").addClass("clicked");
      this.clearTimeout();
      $('#search-blog-form .popup-blog').toggle('fast');

    }
  }
  this.select = function(code){
    if ( search_is_menu == 1 ){
      $('.search-bar').data('value',code).html($('.popup-bar #categoryPopupItem' + code).attr('data-value-port'));
      $('#search-bar-form #search_service_type').val($('.popup-bar #categoryPopupItem' + code).data('value'))
      $('.search-bar').css("border-bottom-left-radius", "5px")
      $('.search-bar').css("border-color", "#009AB3")
      $('.popup-bar').hide('fast');
      $("#search-bar-form #categoryTextbox span.arrow").css("background-position","0 0");
      $("#search-bar-form #categoryTextbox").addClass("selected");
      $('#search-bar-form input#search_name').focus();

    }
    else if ( search_is_menu == 0) {
      $('#search-banner-form #categoryTextbox').data('value',code).html($('#search-banner-form #categoryPopupItem' + code).attr('data-value-port'));
      $('#search-banner-form #search_service_type').val($('#categoryPopupItem' + code).data('value'))
      $('#search-banner-form #categoryTextbox').css({
        "border-bottom-left-radius" : "5px",
        "border-color": "#009AB3"
      });
      $('#search-banner-form #categoryPopup').hide('fast');
      $("#search-banner-form #categoryTextbox span.arrow").css("background-position","0 0");
      $("#search-banner-form #categoryTextbox").addClass("selected");
      $('#search-banner-form input#search_name').focus();

    }
    else if (search_is_menu == 2){
      $('#search-blog-form #categoryTextbox').data('value',code).html($('#search-blog-form #categoryPopupItem' + code).attr('data-value-port'));
      $('#search-blog-form #search_service_type').val($('#categoryPopupItem' + code).data('value'))
      $('#search-blog-form #categoryTextbox').css({
        "border-bottom-left-radius" : "5px",
        "border-color": "#009AB3"
      });
      $('#search-blog-form #categoryPopup').hide('fast');
      $("#search-blog-form #categoryTextbox span.arrow").css("background-position","0 0");
      $("#search-blog-form #categoryTextbox").addClass("selected");
      $('#search-blog-form input#search_name').focus();
    }
  }
  this.value = function(){
    if ( search_is_menu == 1 ){
      return $('#search-bar-form #categoryTextbox').data('value');
    }
    else {
      return $('#search-banner-form #categoryTextbox').data('value');
    }
  }
  this.hidePopup = function(){
    timeout = window.setTimeout(function(){
      $('#categoryTextbox').css("border-bottom-left-radius", "5px");

      // $('#categoryTextbox').css("border-bottom-color", "#CBCCCC")
      $('.categoryTextbox').css("border-color", "#DDD");
      $("#search-banner-form #categoryTextbox").addClass("selected");
      // $('#search-bar-form #categoryTextbox').css("border-color", "#009AB3");
      $('#categoryPopup').hide('fast');
    }, 200);
  }
  this.clearTimeout = function(){
    if(timeout != null){
      window.clearTimeout(timeout);
      timeout = null;
    }     
  }
}


$(document).ready (function(){
  if ( $("#wedding-line").length > 0 ){
    $(function(){
     $().timelinr({
      orientation: 'horizontal',
      // value: horizontal | vertical, default to horizontal
      containerDiv: '#wedding-line',
      // value: any HTML tag or #id, default to #timeline
      datesDiv: '#dates',
      // value: any HTML tag or #id, default to #dates
      datesSelectedClass: 'clicked',
      // value: any class, default to selected
      datesSpeed: 'normal',
      // value: integer between 100 and 1000 (recommended) or 'slow', 'normal' or 'fast'; default to normal
      issuesDiv : '#issues',
      // value: any HTML tag or #id, default to #issues
      issuesSelectedClass: 'clicked',
      // value: any class, default to selected
      issuesSpeed: 'fast',
      // value: integer between 100 and 1000 (recommended) or 'slow', 'normal' or 'fast'; default to fast
      issuesTransparency: 0,
      // value: integer between 0 and 1 (recommended), default to 0.2
      issuesTransparencySpeed: 500,
      // value: integer between 100 and 1000 (recommended), default to 500 (normal)
      prevButton: '#prev',
      // value: any HTML tag or #id, default to #prev
      nextButton: '#next',
      // value: any HTML tag or #id, default to #next
      arrowKeys: 'false',
      // value: true/false, default to false
      startAt: 1,
      // value: integer, default to 1 (first)
      autoPlay: 'false',
      // value: true | false, default to false
      autoPlayDirection: 'forward',
      // value: forward | backward, default to forward
      postClass: '.post_line',
      autoPlayPause: 2000
      // value: integer (1000 = 1 seg), default to 2000 (2segs)< });

     });
    });

  }
  if ( $(".resize").length > 0 ) {
    $(".tipsy-n").css("top", "37px");
  } 
  else {
  }


  if ( $(".head-search").length == 0 ) {
    $(".user-area").css("position", "absolute");
  }
  $(".categoryTextbox").click(function(){
    if ( $(this).hasClass("search-bar") ){
      search_is_menu = 1;
    }
    // Busca do blog 
    else if ( $(this).hasClass("search-blog")) {
        search_is_menu = 2;
    }
    else {
      search_is_menu = 0;
    }
    catselect.togglePopup();
    return false;
  });
  $(".categoryPopup").mouseover(function(){
    catselect.clearTimeout();
    return false;
  });
  $(".categoryPopup").mouseout(function(){
    catselect.hidePopup();
    return false;
  });

	$('blockquote p:first-child, q p:first-child').prepend('<img src="/assets/up-quotes.png" alt="&#34" class="up-quotes" />');
	$('blockquote p:first-child, q p:first-child').append('<img src="/assets/down-quotes.png" alt="&#34" class="down-quotes" />');
  $("#new_appointment").validate();

  // Active/Inactive tabs
  // $(".banner-wrapper a").click(function(){
  //   $(this).removeClass("inactive");
  //   $(this).addClass("active");
  //   return false;
  // })
  
  //find all form with class jqtransform and apply the plugin
  $(".jqtransform").jqTransform();

 $(".service-menu").hover(
    //on mouseover
    function() {
      $(this).animate({
        height: '+=100' //adds 250px
        }, 'slow' //sets animation speed to slow
      );
    },
    //on mouseout
    function() {
      $(this).animate({
        height: '-=100px' //substracts 250px
        }, 'slow'
      );
    }
  );
	
	$(".lightbox").fancybox({
		'scrolling'		: 'no',
		'titleShow'		: false,
		'overlayOpacity': 0.5,
		'overlayColor' : '#000',
		'centerOnScroll' : true,
		'padding' : 0,
		'type'        : 'iframe',
	  'width'       : 370,
	  'height'      : 330,
    'showNavArrows' : false,
    onCleanup     : function() {
                      return window.location.reload();
                  }
	});
  
  $(".lightbox_review").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'centerOnScroll' : true,
    'padding' : 0,
    'type'        : 'iframe',
    'width'       : 568,
    'height'      : 800,
    'showNavArrows' : false,
    onCleanup     : function() {
                      return window.location.reload();
                  }
  });
	
  $(".lightbox_quotation").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'centerOnScroll' : true,
    'padding' : 0,
    'type'        : 'iframe',
    'width'       : 568,
    'height'      : 600,
    'showNavArrows' : false
  });

  $(".lightbox_gmap").fancybox({
    'scrolling'   : 'no',
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'centerOnScroll' : true,
    'padding' : 0,
    'type'        : 'iframe',
    'width'       : 600,
    'height'      : 400,
    'showNavArrows' : false
  });
  
  $(".lightbox_likebox").fancybox({
    'scrolling'   : 'no',
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'centerOnScroll' : true,
    'padding' : 0,
    'showNavArrows' : false
  });

  $(".lightbox_contactform").fancybox({
    'titleShow'   : false,
    'scrolling'   : 'no',
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'centerOnScroll' : true,
    'padding' : 0,
    'type'        : 'iframe',
    'width'       : 420,
    'height'      : 500,
    'showNavArrows' : false
  });

  $(".lightbox_desc").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'centerOnScroll' : true,
    'padding' : 0,
    'type'        : 'iframe',
    'width'       : 400,
    'height'      : 200,
    'showNavArrows' : false
  });

  $(".lightbox_appointment").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'scrolling'   : 'no',
    'centerOnScroll' : false,
    'padding' : 0,
    'type'        : 'iframe',
    'width'       : 450,
    'height'      : 380,
    'showNavArrows' : false
  });

  $(".lightbox_bookmark").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#000',
    'scrolling'   : 'no',
    'centerOnScroll' : false,
    'padding' : 0,
    'type'        : 'iframe',
    'autoDimensions' : true,
    'showNavArrows' : false
  });

  $(".lightbox_invitation").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#fff',
    'scrolling'   : 'no',
    'centerOnScroll' : true,
    'padding' : 10,
    'type'        : 'iframe',
    'width'       : 620,
    'height'      : 420,
    //'height'      : 64,
    //'height'      : 40,
    'showNavArrows' : false,
    onCleanup     : function() {
                      return window.location.reload();
                  }
  });

  $(".lightbox_invitation2").fancybox({
    'titleShow'   : false,
    'overlayOpacity': 0.5,
    'overlayColor' : '#fff',
    'scrolling'   : 'no',
    'centerOnScroll' : true,
    'padding' : 10,
    'type'        : 'iframe',
    'width'       : 380,
    'height'      : 50,
    'showNavArrows' : false,
    onCleanup     : function() {
                      return window.location.reload();
                  }
  });

  $(".lightbox_points").fancybox({
    'titleShow'   : true,
    'titleFormat' : 'Parabéns.',
    'titlePosition' : 'outside',
    'overlayOpacity': 0.5,
    'overlayColor' : '#fff',
    'scrolling'   : 'no',
    'centerOnScroll' : false,
    'padding' : 0,
    'type'        : 'inline',
    'showNavArrows' : false,
    'centerOnScroll' : true,
    'overlayShow' : false
  });

  $(".lightbox_likebox").trigger('click');
  $(".lightbox_points").trigger('click');

  $(".timepicker").datetimepicker({
    timeOnlyTitle: 'Escolha a hora',
    timeText: 'Hora',
    hourText: 'Horas',
    minuteText: 'Minutos',
    secondText: 'Segundos',
    timezoneText: 'Fuso horário',
    currentText: 'Agora',
    closeText: 'Fechar',
    timeFormat: 'hh:mm',
    amNames: ['a.m.', 'AM', 'A'],
    pmNames: ['p.m.', 'PM', 'P'],
    ampm: false
  });
  $(".datepicker").datepicker({
      changeMonth: true,
      changeYear: true
  });

	$(".datepicker_bday").datepicker({
      changeMonth: true,
      changeYear: true,
      minDate: '-90y',
      defaultDate: '-30y'    
  });
	
  // Configuração do datepicker para PT-BR
  $.datepicker.setDefaults({dateFormat: 'dd/mm/yy',
                            dayNames: ['Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado','Domingo'],
                            dayNamesMin: ['D','S','T','Q','Q','S','S','D'],
                            dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','Sáb','Dom'],
                            monthNames: ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro', 'Outubro','Novembro','Dezembro'],
                            monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set', 'Out','Nov','Dez'],
                            nextText: 'Próximo',
                            prevText: 'Anterior'
                           });

	$(".tipsy_like").tipsy({gravity: 'w'});
	$(".tipsy_link").tipsy();
	$(".tipsy_help").tipsy({gravity: 'w', opacity: 1});
  $("a.points-hint").tipsy({
    trigger: 'manual', 
    fallback: 'Olá, aqui você vai poder conferir todas as novidades da Bem Casados. Comece buscando os seus fornecedores favoritos e ganhe pontos. ',
    opacity: 0.7
  });

  if ( $("#quotation-form").length > 0 ){
    $('#quotation-form').validate({
      errorPlacement: function(error, element) {
           error.insertAfter(element.closest('span'));
       }
    });
    $('#quotation_wedding_date').rules("add",{
      required: true,
      messages: {
          required: 'A data de casamento é obrigatória.'
      }
    });
    $('#quotation_email').rules("add",{
      required: true,
      messages: {
          required: 'O e-mail é obrigatório.'
      }
    });
    $('#quotation_number_guests').rules("add",{
      required: true,
      messages: {
          required: 'O número de convidados é obrigatório.'
      }
    });
    
  }


  $(".tipsy_banner_dinamico").popover({
      placement: 'top', 
      title: 'Selo Flutuante', 
      content: 'Os banners com estrelas são atualizados e fixados automaticamente ao seu site.',
      trigger: 'hover'
  });
  $(".tipsy_banner_estatico").popover({
    placement: 'right', 
    content: 'Banner tradicional que pode ser colocado em qualquer lugar da sua página',
    title: 'Selo estático',
    trigger: 'hover'
  });
  $(".popover-proposal").popover({
    placement: 'right',
    content: 'Este fornecedor disponibiliza um orçamento rápido e fácil. Para mais detalhes clique aqui.',
    title: 'Orçamento Instantâneo!',
    trigger: 'hover'
  })
  $(".popover-gift").popover({
    placement: 'right',
    content: 'Temos uma cortesia especial para você. Peça a sua, não perca!',
    title: 'Cortesia',
    trigger: 'hover'
  })
 //localStorage.clear();
  var achievements = 0;
  achievements = localStorage.getItem('popover');
  if ( (achievements < 4) || (achievements == null ) ) {
    $("#show-filter").popover({
      placement: "right", 
      trigger: 'manual',
      html: 'true'
    });
    $("#pop-vendor").popover({
      placement: "right", 
      trigger: 'manual', 
      html: 'true',
      title: 'Nome ou Endereço do Fornecedor',
      content: "Ótimo! Agora você pode escolher um endereço, ou simplesmente clicar em Buscar. Vamos listar os fornecedores mais recomendados por outras noivas!"
    });

    $("#pop-price").popover({
      placement: "right", 
      trigger: 'manual', 
      html: 'true',
      content: 'Você pode refinar os resultados por faixa de preço selecionando a opção desejada e clicando em Filtrar.',
      title: 'Qual a faixa de preço?'
    });

    $("#pop-discount").popover({
      placement: "top", 
      trigger: 'manual', 
      html: 'true',
      content: 'Alguns fornecedores oferecem ofertas especiais para nossas noivas. Confira entrando no perfil do fornecedor.',
      title: 'Cortesias'
    });
    $("#pop-show-discount").popover({
      placement: "top", 
      trigger: 'manual', 
      html: 'true',
      title: 'Ganhe cortesias!',
      content: 'Oba! Esse fornecedor tem um presente especial para você. Clique no botão de desconto e solicite o seu.'
    });
    $("#pop-review").popover({
      placement: "top", 
      trigger: 'manual', 
      html: 'true',
      content: 'Se você conhece esse fornecedor, deixe sua recomendação para ajudar outras noivas na escolha!',
      title: 'Ajude outras noivas'
    });
    $("#pop-info-vendor").popover({
      placement: "top", 
      trigger: 'manual', 
      html: 'true',
      content: 'Aqui você acessa as informações do fornecedor ideal para o seu casamento!',
      title: 'Conheça cada fornecedor'
    });
    $("#pop-show-vendor").popover({
      placement: "top", 
      trigger: 'manual', 
      html: 'true',
      content: 'Se você conhece esse fornecedor, deixe sua recomendação para ajudar outras noivas na escolha!',
      title: 'Ajude outras noivas'
    });
    if ( ( achievements < 2 ) || ( achievements == null ) ){
      if ( $('.store-search').length > 0) {
        $("#show-filter").popover('show');
        $(".popover-title").append("<a href='#'></a>");
        $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
        window.setTimeout("window.scrollTo($('.popover').offset().left,$('.popover').offset().top)",500);
      }
      if( $("#show-filter").length > 0 ) {
        $(".popover").parent().append("<div class='popover-backdrop'></div>");
      }
      $(".popover").click(function(e){
        $("#show-filter").popover("hide");
        // Só exibe se existir os inputs nome/endereco na página
        if($("#pop-vendor").length > 0 ){
          $("#pop-vendor").popover("show");
          $(".popover-title").append("<a href='#'></a>");
          $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
          window.setTimeout("window.scrollTo(0,$('.popover').offset().top)",500);
          $(".popover").click(function(e){
            $("#pop-vendor").popover("hide");
            $("#pop-price").popover("show");
            $(".popover-title").append("<a href='#'></a>");
            $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
            window.setTimeout("window.scrollTo(0,$('.popover').offset().top)", 500);
            $(".popover").click(function(e){
              $("#pop-price").popover("hide");
                if ($(".results").length > 0 ){
                  if ( $("#pop-discount").length > 0 ){
                    $("#pop-discount").popover("show");
                    window.setTimeout("window.scrollTo($('.popover').offset().left,$('.popover').offset().top)",500);
                    $(".popover-title").append("<a href='#'></a>");
                    $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
                    $(".popover").click(function(e){
                      $("#pop-discount").popover("hide");
                      $(".popover-backdrop").remove();
                      localStorage.setItem('popover',2);
                    });
                  }
                  else {
                    $("#pop-info-vendor").popover("show");
                    $(".popover-title").append("<a href='#'></a>");
                    $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
                    window.scrollTo(0,0);
                    $(".popover").click(function(e){
                      $("#pop-info-vendor").popover("hide");
                      $(".popover-backdrop").remove();
                      localStorage.setItem('popover',3);
                    });

                  }
                }
                else {
                      $(".popover-backdrop").remove();
                      localStorage.setItem('popover',3);
                }
            });
          });
          e.preventDefault();
        }
        else
        {
          $("#pop-price").popover("show");
          $(".popover-title").append("<a href='#'></a>");
          $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
          window.scrollTo(0,$(".popover").offset().top);
          $(".popover").click(function(e){
            $("#pop-price").popover("hide");
              if ($(".results").length > 0 ){
                if ( $("#pop-discount").length > 0 ){
                  $("#pop-discount").popover("show");
                  $(".popover-title").append("<a href='#'></a>");
                  $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
                  window.setTimeout("window.scrollTo($('.popover').offset().left,$('.popover').offset().top)",500);
                  $(".popover").click(function(e){
                    $("#pop-discount").popover("hide");
                    $(".popover-backdrop").remove();
                    localStorage.setItem('popover',2);
                  });
                }
                else {
                  $("#pop-info-vendor").popover("show");
                  $(".popover-title").append("<a href='#'></a>");
                  $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
                  $(".popover").click(function(e){
                    $("#pop-info-vendor").popover("hide");
                    $(".popover-backdrop").remove();
                    localStorage.setItem('popover',3);
                  });

                }
              }
              else {
                    $(".popover-backdrop").remove();
                    localStorage.setItem('popover',3);
              }
          });

        }
        e.preventDefault();
      });

    }
    if (achievements == 2){
      if ( $('.venue-detail-page').length > 0) {
        $("#pop-show-discount").popover('show');
        $(".popover-title").append("<a href='#'></a>");
        $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
        window.setTimeout("window.scrollTo(0,0)",50);
        $(".popover").parent().append("<div class='popover-backdrop'></div>");
        $(".popover").click(function(e){
          $("#pop-show-discount").popover("hide");
          $("#pop-review").popover("show");
          // window.setTimeout("window.scrollTo(0,$('.popover').offset().top)",500);
          window.setTimeout("window.scrollTo(0,$('.reviews').offset().top-120)",50);
          $(".popover-title").append("<a href='#'></a>");
          $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
          $(".popover").click(function(e){
            $("#pop-review").popover("hide");
            $(".popover-backdrop").remove();
            localStorage.setItem('popover',4);
          });
          e.preventDefault();
        });
      }
    }
    if (achievements == 3){
      if( $('.venue-detail-page').length > 0 ){
        $("#pop-show-vendor").popover('show');
        $(".popover-title").append("<a href='#'></a>");
        $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
        $(".popover").parent().append("<div class='popover-backdrop'></div>");
        window.setTimeout("window.scrollTo(0, 0)",500);
        $(".popover").click(function(e){
          $('#pop-show-vendor').popover('hide');
            $(".popover-backdrop").remove();
            localStorage.setItem('popover',2);
            e.preventDefault();

        });
      }
    }

  }
    $(".popover-backdrop").click(function(e){
      e.preventDefault();
    })
  if ($("#bemcasados-widget").length > 0){

    $("#popover-banner").popover({
      placement: "right", 
      trigger: 'manual', 
      html: 'true',
      content: "Adicione esse selo de qualidade na sua homepage <a href='http://www.bemcasados.art.br/fornecedores/widget'>clicando aqui.</a>",
      title: 'Selos de qualidade'
    });

    $("#popover-banner").popover('show');
    $(".popover").css("position","fixed");
    $(".popover-title").append("<a href='#'></a>");
    $(".popover-title a").css({ "position" : "absolute" , "top" : "7px", "right" : "7px", "background" : "url(/images/close.png) no-repeat 0 0", "width" : "24px", "height" : "24px" });
    $(".popover-title a").click(function(e){
      $("#popover-banner").popover("hide");
      e.preventDefault();
    });

  }
//  $('.user-area').ready(function(){
    var closed = getCookie('tipsy');
    // var closed = localStorage.getItem('tipsy');
    if(closed == 1){
      $("a.points-hint").tipsy("hide");
      // $(".user-points a span").stop();
    }
    else{
      $("a.points-hint").tipsy("show");
    }
//    return false;
  //});

    if ( $(".tipsy-inner").length > 0 ) {
      $(".tipsy-inner").prepend("<div class='tipsy-close'><a href ='#'></a></div>");
      // $(".user-points a span").stop().effect("pulsate", { times: 300}, 2000);
    }

  $(".user-points a:first-child").click(function(e){
    if ( $(this).hasClass("open-hint") ){
      $(this).removeClass("open-hint");
      // $("a.points-hint").tipsy("show");
      $(".tipsy-inner").prepend("<div class='tipsy-close'><a href ='#'></a></div>");
      setCookie('tipsy',0,30);
      return false;
    }
    else {
      $(".user-points a:first-child").addClass("open-hint");
      // $("a.points-hint").tipsy("hide");
      //localStorage.setItem('tipsy',1);
      setCookie('tipsy',1,30);
      return false;

    }
  });

   $(".tipsy-close a").click(function(){
    var user_area = ".user-points a:first-child";
    $(user_area).addClass("open-hint");
    $("a.points-hint").tipsy("hide");
    setCookie('tipsy',1,30);
    // $(".user-points a span").stop();
    return false;
  })

  if ($("#close_lightbox").length == 1) {
    parent.$.fancybox.close();
  }

  $('input, textarea').placeholder();
	
	$('#login-form').validate({
	errorPlacement: function(error, element) {
	   	   error.insertAfter(element.closest('span'));
	   },
		messages:{
			username:{
				required: ''
			},
			password:{
				required: ''
			}
		}
	});

  $("#new_message").validate({
    errorPlacement: function(error, element) {
         error.insertAfter(element.closest('span'));
     },
    rules: {
      name: "required",
      email: "required",
      termo: "required",
    },
    messages:{
      name: "Este campo é obrigatório.",
      email: "Este campo é obrigatório."
    } 
  });

  function gerarWidget(){
    var urlJSWidget = 'http://www.bemcasados.art.br/widget.js';
    var snippet;
    $('#view .preview').empty();
    var vendor_slug = $('#vendorWidget option:checked')[0].value;
    var widget_position = $('#widgetPosition')[0].value;
    if( estatico == 0){
      snippet = '<script src="http://code.jquery.com/jquery-1.8.0.min.js"></script><script type="text/javascript">var urlVendor = "';
      snippet += vendor_slug;
      snippet += '";';
      snippet += 'var widgetPosition = ';
      snippet += widget_position;
      snippet += ';</script><a href="http://www.bemcasados.art.br/';
      snippet += vendor_slug;
      snippet += '"><div id="bemcasados-widget"></div></a><script src="';
      snippet += urlJSWidget;
      snippet += '"></script>';
      $('#snippet').text(snippet); 
      $("#view .preview").css("padding-left","10px");
      $('#view .preview').append(snippet);
      return false;
    }
    else {  
      snippet = '<a href="http://www.bemcasados.art.br/'
      snippet += vendor_slug;
      snippet += '"><img alt="Bem casados planeje o seu casamento" src="http://www.bemcasados.art.br/images/bemcasados_widget.png" /></a>';
      $('#snippet').text(snippet); 
      $('#view .preview').append(snippet);
      return false;
    }

  }

  function clipboard(text){
    window.prompt("Copie: Ctrl+C, Enter", text);
  }
  $("#clipboard").click(function(e){
    clipboard($("#snippet").val());
    return false;

  })
  $('#gerarWidget').click(function(){
    $(".new-badge #view").css("display","block");
    gerarWidget();
    $("#view .header p").css("display","block");
    $("#view .codigo").css("display","block");
    $("#gerarWidget").css("display","none");
    $("#resetWidget").css("display","block");
    $("#clipboard").css("display","block");
    $("#create-preview").css("display","block");

    return false;
  });
  $("#create-preview").click(function(){
    gerarWidget();
    $("#bemcasados-widget").css("z-index","9999999");
    if ( ( $('#widgetPosition')[0].value == 0 ) || ( $('#widgetPosition')[0].value == 1 ) ) {
      $("#bemcasados-widget").css("top","155px");
    }
    return false;
  })
  $('#resetWidget').click(function(){
    $("#view preview").empty();
    $("#snippet").empty();
    location.reload();
    $("#snippet-create .tipo select").removeAttr("disabled");
    $("#snippet-create .posicao select").removeAttr("disabled");

  });
  // Configura o primeiro passo
  function setFirstStep(){
      $("#snippet-create .vendor select").removeAttr("disabled");
      $("#snippet-create .tipo select").removeAttr("disabled");
      $("#snippet-create .posicao select").removeAttr("disabled");
  }
  function setSecondStep(){
      $("#snippet-create .vendor").css("display","block");
  }
  function setThirdStep(){
      $("#snippet-create .vendor #continue").remove();
      $("#snippet-create .vendor select").attr("disabled","disabled");
      $("#snippet-create .posicao").css("display","block");
  }
  function setFourthStep(){
      $("#snippet-create .posicao #continue").remove();
      $("#snippet-create .posicao select").attr("disabled","disabled");
      if (estatico == 1){
        $("#snippet-create .buttons").css("display","block");
        $("#view .step-four").css("background-position", "-80px 0");
        $("#create-preview").remove();
      }
  }
  if( $("#snippet-create").length > 0 ){
    setFirstStep();
    var step = 1;
    var estatico = 0;
    $("#snippet-create #continue").click(function(e){
      step++;
      if (step == 1){
        return false;
      }
      if (step == 2){
        check = ( $(this).attr("class") || '' ).split(' ')[2];
        // Desvio do passo 2 para o passo 4
        if ( check == "estatico"){
          $("#snippet-create .estatico").css("display","block");
          $("#snippet-create .tipo .dinamico").css("opacity","0.3");
          $("#snippet-create .buttons").css("display","block");
          $("#snippet-create .vendor #continue").css("display","none");
          // seta como estatico
          estatico = 1;
          step++;
          setSecondStep();
          return false;
        }
        $("#snippet-create .tipo .estatico").css("opacity","0.3");
        estatico = 0;
        setSecondStep();
        return false;
      }
      if ( (step == 3) && (estatico == 0) ){
        $("#snippet-create .buttons").css("display","block");

        setThirdStep();
        return false;
      }
      if (step == 4){
        setFourthStep();
        return false;
      }
      if (step > 4){
        return false;
      }
      e.preventDefault();
    });
  }


  $('#facebook_like_button_holder iframe').hover(function(){
    var color = $('.share .facebook a').css('background-color');
    if ( color == "rgb(0, 111, 131)" ){
      $('.share .facebook a').css('background-color','#00ADC8');
    }
    else{
      $('.share .facebook a').css('background-color','#006F83');
    }
  });
  
});

/*
  Barra de busca global sticky 
*/
function createGlobalSearch(){
  if ( $(".fixed").length > 0 ){
    var check_logo = 0;
    var check = 0;
    var header_reached = 0;
    search_menu = $(".fixed .head-search");
    user_menu = $(".fixed .toolbar .user-area");
    $(window).scroll(function(e){
      check = $(".fixed .toolbar-wrappper").height() - $(window).scrollTop();
      check_logo = $(".fixed .toolbar-wrappper").height() + $(".fixed .head-search").height() - $(window).scrollTop();
      var position =   ( check > 0 ) ? check : 0;
      var position_logo = (check_logo > 0 ) ? check_logo : 5;
      if ($(window).scrollTop() > $(".fixed .toolbar-wrappper").height()) {
        header_reached++;
        // One request logo
        if (header_reached == 1 ){
          $(".fixed .logo").css({
            "background-image" : "url('http://www.bemcasados.art.br/assets/images/logo3.png')",
            "top": "5px"
          });
          $(".fixed .socials").css("opacity","0");
        }

      } else if ($(window).scrollTop() <= $(".fixed .toolbar-wrappper").height()) { 
        header_reached = 0;
        $(".fixed .logo").css("background-image", "url('http://www.bemcasados.art.br/assets/images/logo2.png')");
        $(".fixed .socials").css("opacity","1");
      }
      if ( $(window).scrollTop() == 0 ){
        $(".fixed .logo").css("top",$(".fixed .toolbar-wrappper").height() + 15);
      }
      else {
        $(".fixed .logo").css("top",position_logo);
      }

      e.preventDefault();
    });

    if ( $(".user-area-wrapper .logged-out").length > 0 ) {
      $("#search-bar-form").css("padding-left", "0px");
    }
  }
  return false;
}
  createGlobalSearch();

/* Function Posts do blog */
// function getPostsXML(tagname){
//     $.ajax({
//       url: "http://blog.bemcasados.art.br/?tag="+ tagname +"&feed=rdf",
//       type: "GET",
//       dataType: "JSONP",
//       cache: false,
//       success: function(result){
//         console.log (result);
//       }
//     })

// }
// if ( $("#guide").length > 0 ) {
//   // Id Tag Primeira Decisão
//   var tagname = "1-semana-antes";
//   getPostsXML(tagname);
// }

/*
  Vendor signup interaction  
*/

$(".plans a").click(function(e){
  $("#signup .form-wrapper").css("display","block");
  $("#signup .backlog").css("display","block");
  $(".plans").css("display","none");
  // Get Plan
  plan = $(this).attr('id');
  $("#message_featured").val(plan);
  $(".backlog p").text(plan);

  if ( ( plan == "destaque" ) || ( plan == 'pro') ){
    $("#signup #proposal").css("display","block");
  }
  e.preventDefault();
});

