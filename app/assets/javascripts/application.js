// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks

$(function(){
  // 尽量使面板占据视图的大部分空间
  // 虽然只是根据刚打开时的窗口大小进行调整，不能随窗口变化而动态改变，不过已经够了
  if ($('#main').length && $('#panel').length) {
    var winSize = $(window).height() - 
            $('#main').css('margin-top').replace('px', '') - 80; // 80px作为底部边距
    if ($('#panel').height() < winSize) {
      $('#panel').height(winSize);
    }
  }
});

