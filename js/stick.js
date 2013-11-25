$(document).ready(function () {  
  var top = $('.nav').offset().top - parseFloat($('.nav').css('marginTop').replace(/auto/, 100));
  $(window).scroll(function (event) {
    // what the y position of the scroll is
    var y = $(this).scrollTop();

    // whether that's below the form
    if (y >= top) {
      // if so, ad the fixed class
      $('.nav').addClass('fixed');
    } else {
      // otherwise remove it
      $('.nav').removeClass('fixed');
    }
  });
});
