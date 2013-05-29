﻿/*
* jQuery File Download Plugin v1.3.3
*
* http://www.johnculviner.com
*
* Copyright (c) 2012 - John Culviner
*
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
*/
(function(d){d.extend({fileDownload:function(b,w){function r(){if(-1!=document.cookie.indexOf(a.cookieName+"="+a.cookieValue))p.onSuccess(b),document.cookie=a.cookieName+"=; expires="+(new Date(1E3)).toUTCString()+"; path="+a.cookiePath,q(!1);else{if(c||h)try{var j;if((j=c?c.document:s(h))&&null!=j.body&&0<j.body.innerHTML.length){var t=!0;if(g&&0<g.length){var e=d(j.body).contents().first();0<e.length&&e[0]===g[0]&&(t=!1)}if(t){p.onFail(j.body.innerHTML,b);q(!0);return}}}catch(f){p.onFail("",b);
q(!0);return}setTimeout(r,a.checkInterval)}}function s(a){a=a[0].contentWindow||a[0].contentDocument;a.document&&(a=a.document);return a}function q(a){setTimeout(function(){c&&(l&&c.close(),m&&(a?(c.focus(),c.close()):c.focus()))},0)}function u(a){return a.replace(/[<>&\r\n"']/gm,function(a){return"&"+{"<":"lt;",">":"gt;","&":"amp;","\r":"#13;","\n":"#10;",'"':"quot;","'":"apos;"}[a]})}var v=function(){alert("A file download error has occurred, please try again.")},a=d.extend({preparingMessageHtml:null,
failMessageHtml:null,androidPostUnsupportedMessageHtml:"Unfortunately your Android browser doesn't support this type of file download. Please try again with a different browser.",dialogOptions:{modal:!0},successCallback:function(){},failCallback:v,httpMethod:"GET",data:null,checkInterval:100,cookieName:"fileDownload",cookieValue:"true",cookiePath:"/",popupWindowTitle:"Initiating file download...",encodeHTMLEntities:!0},w),e=(navigator.userAgent||navigator.vendor||window.opera).toLowerCase(),m=!1,
l=!1,f=!1;/ip(ad|hone|od)/.test(e)?m=!0:-1!=e.indexOf("android")?l=!0:f=/avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|playbook|silk|iemobile|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(e)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.test(e.substr(0,
4));e=a.httpMethod.toUpperCase();if(l&&"GET"!=e)d().dialog?d("<div>").html(a.androidPostUnsupportedMessageHtml).dialog(a.dialogOptions):alert(a.androidPostUnsupportedMessageHtml);else{var k=null;a.preparingMessageHtml&&(k=d("<div>").html(a.preparingMessageHtml).dialog(a.dialogOptions));var p={onSuccess:function(b){k&&k.dialog("close");a.successCallback(b)},onFail:function(b,c){k&&k.dialog("close");a.failMessageHtml?(d("<div>").html(a.failMessageHtml).dialog(a.dialogOptions),a.failCallback!=v&&a.failCallback(b,
c)):a.failCallback(b,c)}};null!==a.data&&"string"!==typeof a.data&&(a.data=d.param(a.data));var h,c,g;if("GET"===e)null!==a.data&&(-1!=b.indexOf("?")?"&"!==b.substring(b.length-1)&&(b+="&"):b+="?",b+=a.data),m||l?(c=window.open(b),c.document.title=a.popupWindowTitle,window.focus()):f?window.location(b):h=d("<iframe>").hide().attr("src",b).appendTo("body");else{var n="";null!==a.data&&d.each(a.data.replace(/\+/g," ").split("&"),function(){var b=this.split("="),c=a.encodeHTMLEntities?u(decodeURIComponent(b[0])):
decodeURIComponent(b[0]);if(c){var d=b[1]||"",d=a.encodeHTMLEntities?u(decodeURIComponent(b[1])):decodeURIComponent(b[1]);n+='<input type="hidden" name="'+c+'" value="'+d+'" />'}});f?(g=d("<form>").appendTo("body"),g.hide().attr("method",a.httpMethod).attr("action",b).html(n)):(m?(c=window.open("about:blank"),c.document.title=a.popupWindowTitle,f=c.document,window.focus()):(h=d("<iframe style='display: none' src='about:blank'></iframe>").appendTo("body"),f=s(h)),f.write("<html><head></head><body><form method='"+
a.httpMethod+"' action='"+b+"'>"+n+"</form>"+a.popupWindowTitle+"</body></html>"),g=d(f).find("form"));g.submit()}setTimeout(r,a.checkInterval)}}})})(jQuery);