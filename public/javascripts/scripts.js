if ($(window).width() > 980){
  $("#pageHeader").css("left", ($(window).width()-980)/2);
  $("#welcomePernix").css("left", ($(window).width()-980)/2);
}

$(window).resize(function() {
  if ($(window).width() > 980) {
    $("#pageHeader").css("left", ($(window).width()-980)/2);
    $("#welcomePernix").css("left", ($(window).width()-980)/2);
  }
  }
);