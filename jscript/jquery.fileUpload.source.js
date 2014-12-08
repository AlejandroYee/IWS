// ==ClosureCompiler==
// @compilation_level SIMPLE_OPTIMIZATIONS
/**
* @license Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* v1.0 - release 24.01.2013
* v1.1 - 11.02.2013
*	 - добавлена перезагрузка формы после отсылки файла
*	   чтобы не приходилось перезагружать страницу
*
* Использование:
* $(<element>).jInputFile();
*
* Параметры:
* url - Путь к обработчику POST
* filename - Имя файла для загрузки в пост
* iframe - Метод загрузки: если true то фреймом
* heigth - Высота элемента в пикселах
* width - Ширина в пикселах
*		
* Возвращаемые функции:
* success: Загрузка завершена
* selected: Когда один из файлов выбран
*/
//jsHint options
/*jshint evil:true, eqeqeq:false, eqnull:true, devel:true */
/*global jQuery */

(function($) { 
	$.widget("ui.jInputFile", {  
	// Опции по умолчанию
	options: {  
		url: null,
		filename: null,
		reloaded: 0,
		heigth: 30,
		width: 250,
		iframe: (/msie/.test(navigator.userAgent.toLowerCase()))? true : false
		},
	_create: function() { 
		if (this.options.iframe) {			
			var self = this;			
			$('<iframe />').attr({								
								src:'about:blank',
								style: 'border: 0;heigth: '+ self.options.heigth +'px;width: '+ self.options.width +'px'								
								}).prependTo(self.element.parent()).css('overflow','hidden').load(function() {	
										if (self.options.reloaded != 0 ) {
												self._trigger("success", null);
										}										
										// Создаем дочернюю копию элемента инпута
										self.element.parent().find('iframe')
										.contents().find('body').append($("<form />").attr({ 
												'method':'POST',			
												'action': self.options.url,
												'enctype':'multipart/form-data'
										}).css('overflow','hidden'))
										.children('form').append(self.element.clone(true).attr({ 
												'name':self.options.filename,
												'id':'file_iframe_upload'
										}).css('overflow','hidden').show().change(function() {	
												self._trigger("selected", null); 
										}));
										
										// Добавлем кнопки субмита и сброса формы:
										self.element.parent().find('iframe').contents().find('body').children('form')
										.append($('<input />').attr({
												'type':'submit',
												'value':'Загрузить',
												'class':'submit'												
										}).hide()).append($('<input />').attr({
												'type':'reset',
												'value':'Отчистить',
												'class':'reset'
										}).hide());
								// Считаем количество перезагрузок
								self.options.reloaded =  self.options.reloaded + 1;
								});			
			self.element.hide();
		
		
		} else {
			this.element.wrap($('<form />').attr({	'style': 'heigth: '+ this.options.heigth +'px;width: '+ this.options.width +'px', 'enctype': 'multipart/form-data' }));
			this._create_ajax_from(this);
		}
	},
	// отправляем данные
	submit: function() {
		if (this.options.iframe) {			
			this.element.parent().find('iframe').hide()
										.contents().find('body').children('form').children('.submit').click();	
			this.element.parent().find('iframe').css('overflow','hidden');
		} else {
			this._submit_ajax_from();
		}	
	},
	// Отчищаем форму
	clear: function() { 	
		if (this.options.iframe) {
			this.element.parent().find('iframe').show()
										.contents().find('body').children('form').children('.reset').click();
		} else {
			$(this.element).parent().children('.reset').click();
			$(this.element).parent().children('.jInputFile-filename').empty().append('невыбран файл');
		    $(this.element).parent().children('.jInputFile-fakeButton').button('option', 'disabled', false );
		}
	},	
	_create_ajax_from: function(self) {
		self.element.hide();
		if (self.options.filename !== null) {
			self.element.attr('name',self.options.filename);
		}
		self.element.after($('<input />').attr({
												'type':'reset',
												'value':'Отчистить',
												'class':'reset'
										}).hide());
										
		self.element.after('<button class="jInputFile-fakeButton">Загрузить файл...</button><div class="jInputFile-filename" style="font-size:80%">невыбран файл</div>');
		self.element.parent().children('.jInputFile-fakeButton')
					.button({icons: {primary: 'ui-icon-plusthick'}})
					.click(function( event ) {
						self.element.parent().children("input[type='file']").click();
						return false;
					});		
		
		
		$(self.element).change(function() {				
				var fileName = $(self.element).val();			
				fileName = fileName.replace(/.*\\(.*)/, '$1');
				fileName = fileName.replace(/.*\/(.*)/, '$1');			
				$(self.element).parent().children('.jInputFile-filename').html(fileName);
				$(self.element).parent().children('.jInputFile-fakeButton').button('option', 'disabled', true );
				self._trigger("selected", null);  
		}); 
	},
	_submit_ajax_from:function() {
		var self = this;			
		var fd = new FormData();
		fd.append($(self.element).attr('name'),self.element[0].files[0]);
		$(self.element).parent().children('.jInputFile-filename').empty();
		$.ajax({
		  url: self.options.url,
		  data: fd,
          processData: false,
          contentType: false,
		  datatype:'json',
          cache: false,
		  type: 'POST',
		  success: function(data){
			$(self.element).parent().children('.jInputFile-filename').empty().append('невыбран файл');
			self._trigger("success", data);
		  }	  
		});	
	
	},
	
	// Если нам вернули опцию, то заменяем ее
	_setOption: function(option, value) {  
		$.Widget.prototype._setOption.apply( this, arguments );  
		switch (option) {  
			case "url":  
				if (this.options.iframe) {					
					this.element.parent().find('iframe')
										.contents().find('body').children('form').attr('action',value);
				}				
				break; 
		}  
	} 	
	
	}); 
})(jQuery);