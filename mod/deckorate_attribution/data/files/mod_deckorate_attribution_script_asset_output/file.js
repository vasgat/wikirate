// attribution.js.coffee
(function(){$(document).ready(function(){return $("body").on("click","._export-button",function(){return $(this).closest("._attributable-export").find("._hidden-attribution-alert-link").trigger("click")})})}).call(this);
// clipboard.js.coffee
(function(){$(function(){return $("body").on("click",".copy-button",function(){var t,o,n;return o=$(this).closest(".tab-pane.active").find("._clipboard").html(),t=new Blob([o],{type:"text/html"}),n=new ClipboardItem({"text/html":t}),navigator.clipboard.write([n]).then(function(){return console.log("Text copied to clipboard: "+o)})["catch"](function(t){return console.error("Copy to clipboard failed:",t)})})})}).call(this);