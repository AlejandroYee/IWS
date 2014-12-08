/*
* printThis v1.3
* @desc Printing plug-in for jQuery
* @author Jason Day
* 
* Resources (based on) :
*              jPrintArea: http://plugins.jquery.com/project/jPrintArea
*              jqPrint: https://github.com/permanenttourist/jquery.jqprint
*              Ben Nadal: http://www.bennadel.com/blog/1591-Ask-Ben-Print-Part-Of-A-Web-Page-With-jQuery.htm
*
* Dual licensed under the MIT and GPL licenses:
*              http://www.opensource.org/licenses/mit-license.php
*              http://www.gnu.org/licenses/gpl.html
*
* (c) Jason Day 2013
*
* Usage:
*
*  $("#mySelector").printThis({
*      debug: false,              * show the iframe for debugging
*      importCSS: true,           * import page CSS
*      printContainer: true,      * grab outer container as well as the contents of the selector
*      loadCSS: "path/to/my.css", * path to additional css file
*      pageTitle: "",             * add title to print page
*      removeInline: false,       * remove all inline styles from print elements
*      printDelay: 333,           * variable print delay
*      header: null               * prefix to html
*  });
*
* Notes:
*  - the loadCSS will load additional css (with or without @media print) into the iframe, adjusting layout
*/
(function(b){var a;b.fn.printThis=function(e){a=b.extend({},b.fn.printThis.defaults,e);var g=this instanceof jQuery?this:b(this);e="printThis-"+(new Date).getTime();if(window.location.hostname!==document.domain&&navigator.userAgent.match(/msie/i)){var h='javascript:document.write("<head><script>document.domain=\\"'+document.domain+'\\";\x3c/script></head><body></body>")',f=document.createElement("iframe");f.name="printIframe";f.id=e;f.className="MSIE";document.body.appendChild(f);f.src=h}else b("<iframe id='"+
e+"' name='printIframe' />").appendTo("body");var d=b("#"+e);a.debug||d.css({position:"absolute",width:"0px",height:"0px",left:"-600px",top:"-600px"});setTimeout(function(){var c=d.contents();a.importCSS&&b("link[rel=stylesheet]").each(function(){var a=b(this).attr("href");if(a){var d=b(this).attr("media")||"all";c.find("head").append("<link type='text/css' rel='stylesheet' href='"+a+"' media='"+d+"'>")}});a.pageTitle&&c.find("head").append("<title>"+a.pageTitle+"</title>");a.loadCSS&&c.find("head").append("<link type='text/css' rel='stylesheet' href='"+
a.loadCSS+"'>");a.header&&c.find("body").append(a.header);a.printContainer?c.find("body").append(g.outer()):g.each(function(){c.find("body").append(b(this).html())});a.removeInline&&(b.isFunction(b.removeAttr)?c.find("body *").removeAttr("style"):c.find("body *").attr("style",""));setTimeout(function(){d.hasClass("MSIE")?(window.frames.printIframe.focus(),c.find("head").append("<script>  window.print(); \x3c/script>")):(d[0].contentWindow.focus(),d[0].contentWindow.print());g.trigger("done");a.debug||
setTimeout(function(){d.remove()},1E3)},a.printDelay)},333)};b.fn.printThis.defaults={debug:!1,importCSS:!0,printContainer:!0,loadCSS:"",pageTitle:"",removeInline:!1,printDelay:333,header:null};jQuery.fn.outer=function(){return b(b("<div></div>").html(this.clone())).html()}})(jQuery);
