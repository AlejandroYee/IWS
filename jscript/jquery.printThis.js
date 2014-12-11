/*
 * printThis v1.5
 * @desc Printing plug-in for jQuery
 * @author Jason Day
 *
 * Resources (based on) :
 *              jPrintArea: http://plugins.jquery.com/project/jPrintArea
 *              jqPrint: https://github.com/permanenttourist/jquery.jqprint
 *              Ben Nadal: http://www.bennadel.com/blog/1591-Ask-Ben-Print-Part-Of-A-Web-Page-With-jQuery.htm
 *
 * Licensed under the MIT licence:
 *              http://www.opensource.org/licenses/mit-license.php
 *
 * (c) Jason Day 2014
 *
 * Usage:
 *
 *  $("#mySelector").printThis({
 *      debug: false,               * show the iframe for debugging
 *      importCSS: true,            * import page CSS
 *      importStyle: false,         * import style tags
 *      printContainer: true,       * grab outer container as well as the contents of the selector
 *      loadCSS: "path/to/my.css",  * path to additional css file - us an array [] for multiple
 *      pageTitle: "",              * add title to print page
 *      removeInline: false,        * remove all inline styles from print elements
 *      printDelay: 333,            * variable print delay
 *      header: null,               * prefix to html
 *      formValues: true            * preserve input/form values
 *  });
 *
 * Notes:
 *  - the loadCSS will load additional css (with or without @media print) into the iframe, adjusting layout
 */
(function(e){var t;e.fn.printThis=function(n){t=e.extend({},e.fn.printThis.defaults,n);var r=this instanceof jQuery?this:e(this);var i="printThis-"+(new Date).getTime();if(window.location.hostname!==document.domain&&navigator.userAgent.match(/msie/i)){var s='javascript:document.write("<head><script>document.domain=\\"'+document.domain+'\\";</script></head><body></body>")';var o=document.createElement("iframe");o.name="printIframe";o.id=i;o.className="MSIE";document.body.appendChild(o);o.src=s}else{var u=e("<iframe id='"+i+"' name='printIframe' />");u.appendTo("body")}var a=e("#"+i);if(!t.debug)a.css({position:"absolute",width:"0px",height:"0px",left:"-600px",top:"-600px"});setTimeout(function(){var n=a.contents(),i=n.find("head"),s=n.find("body");i.append('<base href="'+document.location.protocol+"//"+document.location.host+'">');if(t.importCSS)e("link[rel=stylesheet]").each(function(){var t=e(this).attr("href");if(t){var n=e(this).attr("media")||"all";i.append("<link type='text/css' rel='stylesheet' href='"+t+"' media='"+n+"'>")}});if(t.importStyle)e("style").each(function(){e(this).clone().appendTo(i)});if(t.pageTitle)i.append("<title>"+t.pageTitle+"</title>");if(t.loadCSS){if(e.isArray(t.loadCSS)){jQuery.each(t.loadCSS,function(e,t){i.append("<link type='text/css' rel='stylesheet' href='"+this+"'>")})}else{i.append("<link type='text/css' rel='stylesheet' href='"+t.loadCSS+"'>")}}if(t.header)s.append(t.header);if(t.printContainer)s.append(r.outer());else r.each(function(){s.append(e(this).html())});if(t.formValues){var o=r.find("input");if(o.length){o.each(function(){var t=e(this),r=e(this).attr("name"),i=t.is(":checkbox")||t.is(":radio"),s=n.find('input[name="'+r+'"]'),o=t.val();if(!i){s.val(o)}else if(t.is(":checked")){if(t.is(":checkbox")){s.attr("checked","checked")}else if(t.is(":radio")){n.find('input[name="'+r+'"][value='+o+"]").attr("checked","checked")}}})}var u=r.find("select");if(u.length){u.each(function(){var t=e(this),r=e(this).attr("name"),i=t.val();n.find('select[name="'+r+'"]').val(i)})}var f=r.find("textarea");if(f.length){f.each(function(){var t=e(this),r=e(this).attr("name"),i=t.val();n.find('textarea[name="'+r+'"]').val(i)})}}if(t.removeInline){if(e.isFunction(e.removeAttr)){n.find("body *").removeAttr("style")}else{n.find("body *").attr("style","")}}setTimeout(function(){if(a.hasClass("MSIE")){window.frames["printIframe"].focus();i.append("<script>  window.print(); </script>")}else{a[0].contentWindow.focus();a[0].contentWindow.print()}if(!t.debug){setTimeout(function(){a.remove()},1e3)}},t.printDelay)},333)};e.fn.printThis.defaults={debug:false,importCSS:true,importStyle:false,printContainer:true,loadCSS:"",pageTitle:"",removeInline:false,printDelay:333,header:null,formValues:true};jQuery.fn.outer=function(){return e(e("<div></div>").html(this.clone())).html()}})(jQuery)