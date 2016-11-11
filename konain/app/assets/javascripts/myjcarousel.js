$(function() {
  $('.jcarousel').jcarousel({
  });

  $('.jcarousel-control-prev').jcarouselControl({
    target: '-=2'
  });

  $('.jcarousel-control-next').jcarouselControl({
    target: '+=2'
  });
});
