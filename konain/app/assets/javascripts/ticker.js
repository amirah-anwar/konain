$(function () {
  home_news_ticker = $('#home-ticker').newsTicker({
    base : {
      width : 2100,
      time : 40000
    },
  });

  $('#home-ticker').hover(function() {
      $(home_news_ticker).newsTickerPause();
    }, function() {
      $(home_news_ticker).newsTickerResume();
    });
});
