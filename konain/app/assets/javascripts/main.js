jQuery(document).ready(function(){
// Tab contents = .inside
  set_class_for_property_attachments();
  var tag_cloud_class = '#tagcloud';
  //Fix for tag clouds - unexpected height before .hide()
  var tag_cloud_height = jQuery( '#tagcloud').height();
  jQuery( '.inside ul li:last-child').css( 'border-bottom','0px' ); // remove last border-bottom from list in tab content
  jQuery( '.realTabs').each(function(){
    jQuery(this).children( 'li').children( 'a:first').addClass( 'selected' ); // Add .selected class to first tab on load
  });
  jQuery( '.inside > *').hide();
  jQuery( '.inside > *:first-child').show();
  jQuery( '.realTabs li a').click(function(evt){ // Init Click funtion on Tabs
    var clicked_tab_ref = jQuery(this).attr( 'href' ); // Strore Href value
    jQuery(this).parent().parent().children( 'li').children( 'a').removeClass( 'selected' ); //Remove selected from all tabs
    jQuery(this).addClass( 'selected' );
    jQuery(this).parent().parent().parent().children( '.inside').children( '*').hide();
    jQuery( '.inside ' + clicked_tab_ref).fadeIn(500);
    evt.preventDefault();
  });

  $(".carousel-thumb-image").click(function() {
    $(this).addClass("active").siblings().removeClass("active");
    $('.connected-carousels-transparent').show();
    var first_index = $('.carousel-navigation').jcarousel('first').index();
    var last_index = $('.carousel-navigation').jcarousel('last').index();
    var median = Math.round((first_index + last_index) * 0.5);
    if ( median > $(this).index() )
    {
      $('.carousel-navigation').jcarousel('scroll', '-=1');
    }
    else
    {
      $('.carousel-navigation').jcarousel('scroll', '+=1');
    }
  });

    $('.next-navigation').click(function() {
      $('.carousel').jcarousel('scroll', '+=1');
      $('.carousel-navigation').jcarousel('scroll', '+=1');
      current_active = $(".carousel-thumb-image.active");
      if (current_active.next().length > 0) {
        $(".carousel-thumb-image.active").next().addClass("active");
        current_active.removeClass("active");
        $('.connected-carousels-transparent').show();
      }
    });

    $('.prev-navigation').click(function() {
      $('.carousel').jcarousel('scroll', '-=1');
      $('.carousel-navigation').jcarousel('scroll', '-=1');
      current_active = $(".carousel-thumb-image.active");
      if (current_active.prev().length > 0) {
        $(".carousel-thumb-image.active").prev().addClass("active");
        current_active.removeClass("active");
        $('.connected-carousels-transparent').show();
      }
    });

  $('body').on('change', '.pictureInput', function(event) {
    var self = $(this);
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    var url = files[0].name;

    reader.onload = function(file) {
      var img = new Image();
      img.onload = function () {
        var width = img.width;
        var height = img.height;
        if( width >= 865 && height >= 400 ) {
          $(img).addClass('image-preview-size');
          self.parent().siblings("p.url-txt-preview").addClass(self.attr('id'));

          if($('img.' + self.attr("id")).length > 0) {
            replaceImage(self, img, url);
          } else {
            $('.url-txt-preview.' + self.attr("id")).html(url);
            self.parent().siblings('.target').append(image);
            var div = $("<div/>");
            var outer_div = div.addClass("image-url-div").appendTo(".target");
            var url_span = $("<p/>");
            url_span.addClass("url-txt");
            var a = url_span.addClass(self.attr("id")).html(url);
            var image = outer_div.append(img);
            var span = a.appendTo(outer_div);
          }
          $(img).addClass(self.attr('id'));
          checkDisableUpload(self);
        } else {
          checkImageSize(self);
        }
      }
      img.src = file.target.result;
    }
    reader.readAsDataURL(image);
  });

  $('body').on('click','.remove-property-image',function() {
    var image_id = $(this).siblings(".chooseImgFile").children('.pictureInput').attr("id");
    $("." + image_id).parents(".image-url-div").remove();
    $(this).parent().siblings("div.error-div").removeClass('enabled');
    $("." + image_id).remove();
    $("." + image_id).parent().remove();
  });

  function set_class_for_property_attachments() {
    $(".pictureInput").each(function(index) {
      $('.image-preview-size').eq(index).addClass($(this).attr("id"));

      var target = $('.url-txt').eq(index).addClass($(this).attr("id")).parents(".target")
      var file_fields = target.siblings(".field").children(".fields").eq(index)
      file_fields.find("p").addClass($(this).attr("id"));
    });
  }

  $(document).on('nested:fieldRemoved', function() {
    if( $(".error-div:visible").not( ".enabled" ).length == 0 )
    {
      $('#form-upload').attr('disabled', false);
    }
  });

  $('input, select, textarea').bind('focus blur', function(event) {
    $viewportMeta.attr('content', 'width=device-width,initial-scale=1,maximum-scale=' + (event.type == 'blur' ? 10 : 1));
  });

  $('.connected-carousels-transparent').hide();

});

function replaceImage(self, img, url) {
  $('img.' + self.attr("id")).replaceWith(img);
  $('p.' + self.attr("id")).html(url);
  $('.url-txt-preview.' + self.attr("id")).html(url);
}

function checkDisableUpload(self) {
  var error_div =  self.parent().siblings("div.error-div");
  error_div.addClass('enabled');
  error_div.html("");
  if( $(".error-div:visible").not( ".enabled" ).length == 0 )
  {
    $('#form-upload').attr('disabled', false);
  }
}

function checkImageSize(self) {
  $('#form-upload').prop('disabled', true);
  var error_div =  self.parent().siblings("div.error-div");
  error_div.html("Image size must be greater than 865x400");
}
