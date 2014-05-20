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
                animation_amount: 500,
                onClose:null,
                onOpen:null
        },
	_create: function() {
            var elem = this;
            var self = elem.element;
            var $bdy = $(this.options.bodyElement);
            
            if (this.options.position === "left") {
                var left = '-' +  $(window).width()/100*this.options.width;
            } else {
                var left = $(window).width();
            }
            self.addClass('ui-widget ui-state-default slidebar');    
            self.css('background-image','none');
            self.css('left',left + 'px');
            self.css('width', this.options.width + '%');
            $bdy.css('position','relative');
            self.hide();
            this._CreateMenu(self); //creating menu
            //events
            self.on('touchend click', function(event) {
                elem._eventHandler(event, $(this)); 
                elem.toggle(); 
	    });
		
	    $bdy.on('touchend click', function(event) {
                elem._eventHandler(event, $(this));
                elem.close();
            });
	},
        _CreateMenu: function (self) {
           var w = this;
           var o = this.options;
           $.each( self.children('li'), function() {   
                var elm_menu = $(this);               
                if (elm_menu.text() === "") {
                    elm_menu.addClass('ui-state-default slidebar-item slidebar-item-empty').css('float',o.position).css('background-image','none');     
                } else {
                    elm_menu.addClass('ui-state-default slidebar-item').css('float',o.position).css('background-image','none');                    
                    clc = elm_menu.children('a').attr('onClick');
                    if (elm_menu.parent()[0].localName === "div") {
                        pls = elm_menu.children('a').html();
                        elm_menu.children('a').empty().append($('<span />').append(pls));
                        elm_menu.width(w.element.width());
                    }
                    elm_menu.children('a').find('span').css('float',o.position);  
                    if (clc !== '') {                        
                            elm_menu.attr('onClick',clc);
                    }
                    elm_menu.children('a').removeAttr('onClick');                    
                    elm_menu.on({
                        'mouseenter': function(event) {  
                            w._eventHandler(event, $(this));
                            elm_menu.addClass('ui-state-hover');                      
                        },
                        'mouseleave': function(event) {          
                            w._eventHandler(event, $(this));
                            elm_menu.removeClass('ui-state-hover');
                        },
                        'touchend click': function(event){
                            w._eventHandler(event, $(this));
                            var elm = $(this);
                            if (elm.attr('has_menu') === 'true') {
                                var next_element = elm.next('ul');                                                            
                               if (next_element.attr('opened') === 'true') { 
                                    elm.children('a').children('.ui-icon-circlesmall-minus').removeClass('ui-icon-circlesmall-minus').addClass('ui-icon-circlesmall-plus');
                                    next_element.slideUp(o.animation_amount);                                
                                    elm.removeClass('ui-state-active');
                                    next_element.attr('opened',false);               
                               } else {
                                    elm.parent().children('ul[opened]').slideUp(o.animation_amount).attr('opened',false);
                                    elm.parent().children('.ui-state-active').removeClass('ui-state-active');
                                    next_element.slideDown(o.animation_amount);  
                                    elm.children('a').children('.ui-icon-circlesmall-plus').removeClass('ui-icon-circlesmall-plus').addClass('ui-icon-circlesmall-minus');
                                    next_element.attr('opened',true);
                                    elm.addClass('ui-state-active'); 
                               }   
                               return false;
                            } else {
                                w.close();
                            }
                        }
                      });       
                    if (elm_menu.children('ul').length > 0 ) {        
                        var sub_menu = elm_menu.children('ul');
                            sub_menu.addClass('slidebar-menu');
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
        _eventHandler: function (event, selector) {
			event.stopPropagation();
			event.preventDefault();
			if (event.type === 'touchend') selector.off('click');
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
            var o = this.options;
            var self = this.element;
            var $bdy = $(this.options.bodyElement);
            var selector = $bdy.add(self); 
            var amount;
            if (o.position === 'left') {
                amount = '-' + $(window).width()/100 * o.width;
            } else {
                amount = $(window).width();
            }
            self.stop().animate({
                        left: amount
                    }, o.animation_amount); 
            $bdy.stop().animate({
                        left:0
                    }, o.animation_amount); 
                    
            setTimeout(function() { 
                    self.hide();
                    self.attr('active',false);
                }, o.animation_amount);       
        },
        _animate_show: function() {           
            var o = this.options;
            var self = this.element;
            var $bdy = $(this.options.bodyElement);
            var selector = $bdy.add(self);  
            if (o.position === 'left') {
                var amount = '+=' + $(window).width()/100 * o.width;
            } else {
                var amount = '-=' + $(window).width()/100 * o.width;                
            }
            self.show();
            selector.stop().animate({
                left: amount
            }, o.animation_amount);
            setTimeout(function() { 
                    self.attr('active',true);
            }, o.animation_amount);  
        },
	// Если нам вернули опцию, то заменяем ее
	_setOption: function(option, value) {  
		$.Widget.prototype._setOption.apply( this, arguments );  
		/*switch (option) {  
			case "width":  
				if (this.options.iframe) {					
					this.element.parent().find('iframe')
										.contents().find('body').children('form').attr('action',value);
				}				
			break; 
		} */ 
	} 	
	
	}); 
})(jQuery);