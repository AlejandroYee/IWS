/*
 * jQuery UI Menubar @VERSION
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Menubar
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *	jquery.ui.position.js
 *	jquery.ui.menu.js
 */
/*
 * jQuery UI Menubar @VERSION
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Menubar
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *	jquery.ui.position.js
 *	jquery.ui.menu.js
 */
(function(b){b.widget("ui.menubar",{version:"@VERSION",options:{autoExpand:!1,buttons:!1,items:"li",menuElement:"ul",menuIcon:!1,position:{my:"left top",at:"left bottom"}},_create:function(){this.menuItems=this.element.children(this.options.items);this.items=this.menuItems.children("button, a");this.openSubmenus=0;this._initializeWidget();this._initializeMenuItems();this._initializeItems()},_initializeWidget:function(){this.element.addClass("ui-menubar ui-widget-header ui-helper-clearfix").attr("role",
"menubar");this._on(this.element,{keydown:function(a){var c;a.keyCode===b.ui.keyCode.ESCAPE&&(this.active&&!0!==this.active.menu("collapse",a))&&(c=this.active,this.active.blur(),this._close(a),b(a.target).blur().mouseleave(),c.prev().focus())},focusin:function(){this.items.eq(0).attr("tabIndex",-1);clearTimeout(this.closeTimer)},focusout:function(){this.closeTimer=this._delay(function(){this._close(event);this.items.eq(0).attr("tabIndex",0)},150)},"mouseleave .ui-menubar-item":function(){this.options.autoExpand&&
(this.closeTimer=this._delay(function(){this._close()},150))},"mouseenter .ui-menubar-item":function(){clearTimeout(this.closeTimer)}})},_initializeMenuItems:function(){var a,c=this;this.menuItems.addClass("ui-menubar-item").attr("role","presentation").css({"border-width":"1px","border-style":"hidden"});a=this.menuItems.children(c.options.menuElement).menu({position:{within:this.options.position.within},select:function(a,b){void 0===b.item.find("a.ui-state-focus:last").attr("aria-haspopup")&&(b.item.parents("ul.ui-menu:last").hide(),
c._close(),b.item.parents(".ui-menubar-item").children().first().focus(),c._trigger("select",a,b))},menus:this.options.menuElement}).hide().attr({"aria-hidden":"true","aria-expanded":"false"});this._on(a,{keydown:function(a){b(a.target).attr("tabIndex",0);var e;if(!b(this).is(":hidden"))switch(a.keyCode){case b.ui.keyCode.LEFT:e=c.active.prev(".ui-button");this.openSubmenus?this.openSubmenus--:this._hasSubMenu(e.parent().prev())?(c.active.blur(),c._open(a,e.parent().prev().find(".ui-menu"))):(e.parent().prev().find(".ui-button").focus(),
c._close(a),this.open=!0);a.preventDefault();b(a.target).attr("tabIndex",-1);break;case b.ui.keyCode.RIGHT:this.next(a),a.preventDefault()}},focusout:function(a){b(a.target).removeClass("ui-state-focus")}});this.menuItems.each(function(a,e){c._identifyMenuItemsNeighbors(b(e),c,a)})},_hasSubMenu:function(a){return 0<b(a).children(this.options.menuElement).length},_identifyMenuItemsNeighbors:function(a,c,d){c=this.menuItems.length;var e=d===c-1;0===d?(a.data("prevMenuItem",b(this.menuItems[c-1])),a.data("nextMenuItem",
b(this.menuItems[d+1]))):(e?a.data("nextMenuItem",b(this.menuItems[0])):a.data("nextMenuItem",b(this.menuItems[d+1])),a.data("prevMenuItem",b(this.menuItems[d-1])))},_initializeItems:function(){var a=this;this._focusable(this.items);this._hoverable(this.items);this.items.slice(1).attr("tabIndex",-1);this.items.each(function(c,d){a._initializeItem(b(d),a)})},_initializeItem:function(a){var c=this._hasSubMenu(a.parent());a.addClass("ui-button ui-widget ui-button-text-only ui-menubar-link").attr("role",
"menuitem").wrapInner("<span class='ui-button-text'></span>");this.options.buttons&&a.removeClass("ui-menubar-link").addClass("ui-state-default");this._on(a,{focus:function(){a.attr("tabIndex",0);a.addClass("ui-state-focus");event.preventDefault()},focusout:function(){a.attr("tabIndex",-1);a.removeClass("ui-state-focus");event.preventDefault()}});c?(this._on(a,{click:this._mouseBehaviorForMenuItemWithSubmenu,focus:this._mouseBehaviorForMenuItemWithSubmenu,mouseenter:this._mouseBehaviorForMenuItemWithSubmenu}),
this._on(a,{keydown:function(a){switch(a.keyCode){case b.ui.keyCode.SPACE:case b.ui.keyCode.UP:case b.ui.keyCode.DOWN:this._open(a,b(a.target).next());a.preventDefault();break;case b.ui.keyCode.LEFT:this.previous(a);a.preventDefault();break;case b.ui.keyCode.RIGHT:this.next(a),a.preventDefault()}}}),a.attr("aria-haspopup","true"),this.options.menuIcon&&(a.addClass("ui-state-default").append("<span class='ui-button-icon-secondary ui-icon ui-icon-triangle-1-s'></span>"),a.removeClass("ui-button-text-only").addClass("ui-button-text-icon-secondary"))):
this._on(a,{click:function(){this.active?this._close():(this.open=!0,this.active=b(a).parent())},mouseenter:function(){this.open&&(this.stashedOpenMenu=this.active,this._close())},keydown:function(a){a.keyCode===b.ui.keyCode.LEFT?(this.previous(a),a.preventDefault()):a.keyCode===b.ui.keyCode.RIGHT&&(this.next(a),a.preventDefault())}})},_mouseBehaviorForMenuItemWithSubmenu:function(a){var c,d;if("focus"!==a.type||a.originalEvent)if(a.preventDefault(),d=b(a.target).parents(".ui-menubar-item").children("ul"),
c="click"===a.type&&d.is(":visible")&&this.active&&this.active[0]===d[0])this._close();else if("mouseenter"===a.type&&(this.element.find(":focus").focusout(),this.stashedOpenMenu&&this._open(a,d),this.stashedOpenMenu=void 0),this.open&&"mouseenter"===a.type||"click"===a.type||this.options.autoExpand)clearTimeout(this.closeTimer),this._open(a,d),a.stopPropagation()},_destroy:function(){this.menuItems.removeClass("ui-menubar-item").removeAttr("role").css({"border-width":"","border-style":""});this.element.removeClass("ui-menubar ui-widget-header ui-helper-clearfix").removeAttr("role").unbind(".menubar");
this.items.unbind(".menubar").removeClass("ui-button ui-widget ui-button-text-only ui-menubar-link ui-state-default").removeAttr("role").removeAttr("aria-haspopup").children(".ui-icon").remove();this.items.children("span.ui-button-text").each(function(){var a=b(this);a.parent().html(a.html())});this.element.find(":ui-menu").menu("destroy").show().removeAttr("aria-hidden").removeAttr("aria-expanded").removeAttr("tabindex").unbind(".menubar")},_collapseActiveMenu:function(){this.active.menu("collapseAll").hide().attr({"aria-hidden":"true",
"aria-expanded":"false"}).closest(this.options.items).removeClass("ui-state-active")},_close:function(){this.active&&(this._collapseActiveMenu(),this.active=null,this.open=!1,this.openSubmenus=0)},_open:function(a,c){var d;d=c.closest(".ui-menubar-item");this.active&&(this.active.length&&this._hasSubMenu(this.active.closest(this.options.items)))&&this._collapseActiveMenu();d=d.addClass("ui-state-active");this.active=c.show().position(b.extend({of:d},this.options.position)).removeAttr("aria-hidden").attr("aria-expanded",
"true").menu("focus",a,c.children(".ui-menu-item").first()).focus();this.open=!0},next:function(a){this.open&&this.active&&this._hasSubMenu(this.active.closest(this.options.items))&&this.active.data("uiMenu")&&this.active.data("uiMenu").active&&this.active.data("uiMenu").active.has(".ui-menu").length?this.openSubmenus++:(this.openSubmenus=0,this._move("next",a))},previous:function(a){this.open&&this.openSubmenus?this.openSubmenus--:(this.openSubmenus=0,this._move("prev",a))},_move:function(a,c){var d=
b(c.target).closest(".ui-menubar-item"),e=d.data(a+"MenuItem"),f=e.find(".ui-button");this.open?this._hasSubMenu(e)?this._open(c,e.children(".ui-menu")):(this._collapseActiveMenu(),e.find(".ui-button").focus(),this.open=!0):(d.find(".ui-button"),f.focus())}})})(jQuery);