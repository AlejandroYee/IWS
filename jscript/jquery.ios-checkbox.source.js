/*
* Copyright (c) 2014 - Andrey Boomer - andrey.boomer at gmail.com
* icq: 454169
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
*/

(function($) { 
	$.widget("ui.iosCheckbox", { 
	options: { 
            width: 35,
            height: 18
        },
	_create: function() {
            var elem = this;
            var el = elem.element.hide();
            var o = this.options;
            
            var span_element = $(this.span_element = $('<span />').attr({
                        'class':'ui-widget ui-state-default ui-state-active',
                        'style':'border: 0px; cursor: pointer; display: inline-block; position: relative; vertical-align: middle;padding:3px;margin:0 0 0 5px;box-shadow: inset 0px 2px 5px rgba(0,0,0,0.5);border-radius:' + (o.width * 2) + 'px'
                    }).append( this.small_element = $('<small />').attr({
                                        'class':'ui-widget ui-widget-content ui-state-hover',
                                        'style':'transition:left 0.2s; left: ' + (o.width/2) + 'px;border: 1px;border-radius: 100%; padding:1px;margin:1px;box-shadow: inset 0px 2px 5px rgba(0,0,0,0.2);position: absolute; top: 1px;'
                                    }).width(o.height).height(o.height)               
                                )).insertAfter(el).width(o.width).height(o.height);
            
            this.small_element.on('touchend click', function(event) {
                elem._eventHandler(event, $(this)); 
                elem.toggle(); 
	    });
            this.span_element.on('touchend click', function(event) {
                elem._eventHandler(event, $(this)); 
                elem.toggle(); 
	    });
            this.refresh();
	},
        toggle: function() {
            if (this.span_element.hasClass('ui-state-active')) {
                this.uncheck();
            } else {
                this.check();
            }
        },
        check: function() {
            this.span_element.addClass('ui-state-active');
            this.small_element.css('left',(this.options.width/2) + 'px');
            this.element.attr('checked','checked');
            this._trigger("unchecked", null);
        },
        uncheck: function() {
            this.span_element.removeClass('ui-state-active');
            this.small_element.css('left','1px');
            this.element.removeAttr('checked');
            this._trigger("checked", null);
        },
        refresh:function(){
            if (this.element.attr("checked") !== "checked") {
                this.uncheck();
            } else {
                this.check();
            }
        },
        status:function() {
            if (this.span_element.hasClass('ui-state-active')) {
                return "checked";
            } else {
                return "unchecked";
            }
        },
        _eventHandler: function (event, selector) {
            event.stopPropagation();
            event.preventDefault();
            if (event.type === 'touchend') selector.off('click');
	},
	_setOption: function(option, value) {  
            $.Widget.prototype._setOption.apply( this, arguments ); 
	}
	}); 
})(jQuery);