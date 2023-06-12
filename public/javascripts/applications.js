/*global $*/
/*global fetch*/
$(document).ready(function() {
  var startTime;
  var interval;
  var timeString;
  var running = false;
  var pauseFlag = false;
  var pauseTime = 0;

  $("#start").click(function() {
    if (!running) {
      if (pauseFlag){
        startTime = Date.now() - pauseTime;
      }else{
        startTime = Date.now();
      }
      interval = setInterval(updateTimer, 1000);
      running = true;
      pauseFlag = false;
    }
    
  });

  $("#pause").click(function() {
    if (running) {
      clearInterval(interval);
      running = false;
      pauseFlag = true;
      pauseTime = Date.now() - startTime;
    }
  });

  $("#end").click(function async() {
    // ここからfetchAPI使ってる↓
    // fetch('/post', {
    //   Method: 'POST',
    //   Body: JSON.stringify({
    //     "Time": timeString
    //   })
    // })
    window.location.href= "/post?time="+timeString //ページに飛ぶと同時にtimeStringを渡してる
    
    clearInterval(interval);
    $("#timer").text("00:00:00");
    running = false;
    pauseFlag = false;
  });

  function updateTimer() {
    var elapsed = Date.now() - startTime;
    var hours = Math.floor(elapsed / 3600000);
    var minutes = Math.floor((elapsed % 3600000) / 60000);
    var seconds = Math.floor((elapsed % 60000) / 1000);

    timeString =
      ("0" + hours).slice(-2) +
      ":" +
      ("0" + minutes).slice(-2) +
      ":" +
      ("0" + seconds).slice(-2);

    $("#timer").text(timeString);
  }
});