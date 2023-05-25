/*global $*/
$(document).ready(function() {
  var startTime;
  var interval;
  var running = false;

  $("#start").click(function() {
    if (!running) {
      startTime = Date.now();
      interval = setInterval(updateTimer, 1000);
      running = true;
    }
  });

  $("#pause").click(function() {
    if (running) {
      clearInterval(interval);
      running = false;
    }
  });

  $("#end").click(function() {
    clearInterval(interval);
    $("#timer").text("00:00:00");
    running = false;
  });

  function updateTimer() {
    var elapsed = Date.now() - startTime;
    var hours = Math.floor(elapsed / 3600000);
    var minutes = Math.floor((elapsed % 3600000) / 60000);
    var seconds = Math.floor((elapsed % 60000) / 1000);

    var timeString =
      ("0" + hours).slice(-2) +
      ":" +
      ("0" + minutes).slice(-2) +
      ":" +
      ("0" + seconds).slice(-2);

    $("#timer").text(timeString);
  }
});