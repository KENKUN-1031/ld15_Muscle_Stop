/*global $*/
//= require jquery3
//= require jquery_ujs
//= require_tree .
// $(document).ready(function(){
//  var sec = 0;
//  var min = 0;
//  var timer = 0;
 
//  $("min").html(min);
//  $("sec").html(sec);
 
//  $("begin").click(function(){
//   var message1 = "開始！"
//   $("#calc").html(message1);
//   $("#begin").hide();
//   $("stop").show();
  
//   timer = setInterval(function(){
//    $("#main").html(min);
//    $("#sec").html(sec);
//    sec++;
//    if (sec == 60){
//     sec = 0;
//     min++;
//    };
//   },1000);
//  });
 
//  $("#stop").click(function(){
//   var message2 = "止めます";
//   $("#calc").html(message2);
//   clearInterval(timer);
  
//   $("#stop").hide();
//   $("begin").show();
//  });
 
//  $("#end").click(function(){
//   var message3 = "計りなおします。";
//   $("#calc").html(message3);
//   clearInterval(timer);
  
//   min = 0;
//   sec = 0;
//   $("#min").html(min);
//   $("#sec").html(sec);
//  });
// });