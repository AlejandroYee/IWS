// ==ClosureCompiler==
// @compilation_level SIMPLE_OPTIMIZATIONS
/**
* @license Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
*/
//jsHint options
/*jshint evil:true, eqeqeq:false, eqnull:true, devel:true */
/*global jQuery */
(function($) { 
	$.widget("ui.SlidebarMenu", {  
	// Опции по умолчанию
	options: { 
                position:'left',
                width: '15',
                bodyElement:'#slidebarmenu-body',
                animation_amount: 300,
                minwidth:250,
                resizable:false,
                onClose:null,
                onOpen:null
        },
	_create: function() {
            var elem = this;
            var self = elem.element;
            var bdy = $(this.options.bodyElement);
            var widt = $(window).width();
            
            if (widt/100 * this.options.width > this.options.minwidth) {
                self.width(widt/100 * this.options.width);
            } else {
                self.width(this.options.minwidth);
            }
            if (this.options.position === "left") {
                var left = '-' +  self.width();                
                bdy.width(widt - self.width() - left);
            } else {
                var left = widt;
                bdy.width(widt);
            }
            self.css('left',left + 'px');  
            self.addClass('ui-widget ui-state-default slidebar slidebar-animate');    
            self.css('background-image','none');
            bdy.addClass('slidebar-animate').css('position','relative');
             if (this.options.resizable) {
                var hand = (this.options.position === "left")?'e':'w';
                self.resizable({							
                           handles: hand,	
                           resize: function( event, ui ) {	
                               elem.resize(ui.size.width);
                           }
                });
            }           
            this._CreateMenu(self); //creating menu           		
	    bdy.on('click', function(event) {
                elem.close();
            });
	},
        _CreateMenu: function (self) {
           var w = this;
           var o = this.options;
           $.each( self.children('li'), function() {   
                var elm_menu = $(this);               
                if (elm_menu.text() === "") {
                    elm_menu.addClass('ui-state-default slidebar-item slidebar-item-empty').css('float','left').css('background-image','none');     
                } else {
                    elm_menu.addClass('ui-state-default slidebar-item').css('float','left').css('background-image','none');                    
                    clc = elm_menu.children('a').attr('onClick');
                    if (elm_menu.parent()[0].localName === "div") {
                        pls = elm_menu.children('a').html();
                        elm_menu.children('a').empty().append($('<span />').append(pls));
                        elm_menu.width('100%');
                    }
                    elm_menu.children('a').find('span').css('float','left');  
                    if (clc !== '') {                        
                            elm_menu.attr('onClick',clc);
                    }
                    elm_menu.children('a').removeAttr('onClick');                    
                    elm_menu.on({
                        'mouseenter': function(event) {  
                            elm_menu.addClass('ui-state-hover');                      
                        },
                        'mouseleave': function(event) {
                            elm_menu.removeClass('ui-state-hover');
                        },
                        'click': function(event){
                            var elm = $(this);
                            if (elm.attr('has_menu') === 'true') {
                                var next_element = elm.next('ul');                                                            
                               if (next_element.attr('opened') === 'true') { 
                                    elm.children('a').children('.ui-icon-circlesmall-minus').removeClass('ui-icon-circlesmall-minus').addClass('ui-icon-circlesmall-plus');                                                                    
                                    elm.removeClass('ui-state-active');
                                    next_element.attr('opened',false);        
                                    next_element.slideUp(o.animation_amount);       
                               } else {
                                    elm.parent().children('ul[opened]').attr('opened',false).slideUp(o.animation_amount)
                                                .prev().children('a').children('.ui-icon-circlesmall-minus').removeClass('ui-icon-circlesmall-minus').addClass('ui-icon-circlesmall-plus');
                                    elm.parent().children('.ui-state-active').removeClass('ui-state-active');                                    
                                    elm.children('a').children('.ui-icon-circlesmall-plus').removeClass('ui-icon-circlesmall-plus').addClass('ui-icon-circlesmall-minus');
                                    next_element.attr('opened',true);
                                    elm.addClass('ui-state-active'); 
                                    next_element.slideDown(o.animation_amount);
                               }   
                               return false;
                            } else {
                                w.close();
                            }
                        }
                      });       
                    if (elm_menu.children('ul').length > 0 ) {        
                        var sub_menu = elm_menu.children('ul');
                            sub_menu.addClass('slidebar-menu showUp');
                        elm_menu.attr('has_menu',true);
                        $('<span>').attr({
                            'class':'ui-icon ui-icon-circlesmall-plus',
                            'style':'float:left'
                        }).insertBefore(elm_menu.children('a').children('span:first'));
                        sub_menu.insertAfter(elm_menu).hide().attr('opened',false);
                        elm_menu.css('border','0px');
                        w._CreateMenu(sub_menu);
                    } else {
                        elm_menu.css('border','0px');
                        elm_menu.attr('has_menu',false);
                    }
            }
	    });
              
        },
        resize: function(widt_elem) {
            var self = this.element;
            var bdy = $(this.options.bodyElement);
            var widt = $(window).width();
            
            if (typeof(widt_elem) === 'undefined') {
               widt_elem = self.width();
            } 
            
            if (widt_elem > this.options.minwidth) {
                  self.width(widt_elem);
              } else {
                  self.width(this.options.minwidth);
            }   
            if (self.attr('active') !== 'true') {
                if (this.options.position === "left") {
                    var left = '-' + self.width();
                    bdy.css('left',0 + 'px'); 
                } else {
                    var left = widt;
                    bdy.css('left',widt + 'px'); 
                }
                bdy.width(widt);
            } else {
                 if (this.options.position === "left") {
                     var left = 0;
                     bdy.css('left',+(left + self.width())+ 'px'); 
                } else {
                     var left = widt -  self.width();
                     bdy.css('left',+(-self.width())+ 'px');
                }
                bdy.width(widt);                
            }
            self.css('left',left + 'px'); 
        },
        toggle: function() {
            var self = this.element;              
            if (self.attr('active') === 'false' || self.attr('active') === undefined) {
                    this.open(); 
            } else {
                   this.close();
            }
        },
        close: function() {
            var self = this.element;
            var o = this.options;
            if (self.attr('active') === 'true') {
                if ($.isFunction(o.onClose) ) {                                        
                      if (o.onClose.call()) {
                          this._animate_hide();
                      }
                } else {
                    this._animate_hide();
                }
            }
        },
        open: function() {
            var self = this.element;
            var o = this.options;
            if (self.attr('active') !== 'true') {
                if ($.isFunction(o.onOpen) ) {                                        
                      if (o.onOpen.call()) {
                          this._animate_show();
                      }
                } else {
                    this._animate_show();
                }
            }
        },
        _animate_hide: function () {
            var self = this.element;
            var bdy = $(this.options.bodyElement);                       
            var widt = $(window).width();
            if (this.options.position === "left") {
                    var left = '-' + self.width();
                    bdy.css('left',0 + 'px'); 
                } else {
                    var left = widt;
                    bdy.css('left',widt + 'px'); 
                }
              bdy.width(widt);
              self.css('left',left + 'px');
            setTimeout(function() { 
                    self.attr('active',false);
                }, this.options.animation_amount);       
        },
        _animate_show: function() { 
            var self = this.element;
            var bdy = $(this.options.bodyElement);            
            var widt = $(window).width();
            if (this.options.position === "left") {
                    var left = 0;
                    bdy.css('left',+(left + self.width())+ 'px'); 
               } else {
                    var left = widt -  self.width();
                    bdy.css('left',+(-self.width())+ 'px');
               }
               bdy.width(widt);    
            self.css('left',left + 'px'); 
           
            setTimeout(function() { 
                    self.attr('active',true);
            }, this.options.animation_amount);  
        },
	_setOption: function(option, value) {  
            $.Widget.prototype._setOption.apply( this, arguments );
	} 	
	
	}); 
})(jQuery);