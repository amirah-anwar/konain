$(function(){

  set_class_for_property_attachments();

  $('body').on('change','.imageInput',function(event) {
    var self = $(this);
    var files = event.target.files;
    var image = files[0];
    var reader = new FileReader();

    reader.onload = function(file) {
      var img = new Image();
      $(img).addClass('image-preview-size');
      img.src = file.target.result;

      if($('img.' + self.attr("id")).length > 0)
      {
        $('img.' + self.attr("id")).replaceWith(img);
      }
      else
      {
        self.siblings("p").children(".target").html(img);
      }
        $(img).addClass(self.attr('id'));
    }
    reader.readAsDataURL(image);
  });

  function set_class_for_property_attachments() {
    $(".imageInput").each(function(index) {
      $('.image-preview-size').eq(index).addClass($(this).attr("id"));
    });
  }

});
