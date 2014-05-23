// ==ClosureCompiler==
// @compilation_level SIMPLE_OPTIMIZATIONS
/**
* @license Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//jsHint options
/*jshint evil:true, eqeqeq:false, eqnull:true, devel:true */
/*global jQuery */
jQuery.uiBackCompat = false;
jQuery.jgrid.no_legacy_api = true;

var counttab = 1;	
var sumtab = 0;
var alert_enabled = 0;
var hidden_menu = false;
var user_not_logget = true;
var main_menu_higth;
var enable_menu = false;
var slidebar = 'left';
var doc_height;
var doc_width;
var doc_title = null;

$(function() {
    
	custom_alert = function (output_msg)
	{
            
                title_msg = 'Внимание:';		
                if (output_msg.search('ORA-') !== -1) title_msg = 'SQL Ошибка конфигурации:';
                if (output_msg.search('запрещен') !== -1) title_msg = 'Аунтефикация:';
		if (!output_msg) output_msg = '';

		$("<div />").html(output_msg).dialog({
			title: title_msg,
			resizable: false,
			minWidth: 450,
			modal: true,
			dialogClass: "alert",
                        
			buttons: {                            	
				"Закрыть": function() {
					$( this ).dialog( "close" );
				}
			},							
			open: function() {								
					$(this).parent().css('z-index', 9999).parent().children('.ui-widget-overlay').css('z-index', 105);					
			}
		});
	};
	
	// Функция обезки строки
	trim_text = function (text,size,col) {
		var final_string = '';
		if (text.length < size ) {
				return text;
			} else {
				var spl_text = text.split(' ');
				for (var i = 0; i < spl_text.length; i++) {
					final_string = final_string + ' ' + spl_text[i];
					if (i > col - 2) {
						return final_string + '...';
					}
				}
		}
	};
	
        // Отрисовка,перерисовка графиков
        plot_graph = function (self_obj) { 
          
            // Заполняем графики						
            $.ajax({
              url: self_obj.attr('url'),							  
              type: 'GET',
              success: function(data) {	 
                  if (data === "Not autorised") {                     
                                $(location).prop('href',location.href);
                  }
                  var obj = jQuery.parseJSON(data); 
                  var chart_render = $('#' + self_obj.attr('id'));
                  var options = {                      
                        canvas: true,
                        grid:   {hoverable: true, clickable: true },
                        legend: {                           
                            backgroundOpacity:0.8,
                            show: obj.legend
                        },                      
                        xaxis: obj.xaxis,
                        yaxes: obj.yaxis,
                        zoom: {interactive: true },
			pan: {interactive: false },
                        crosshair: {
				mode: "xy"
			}
                    };  
                    $.extend(options, obj.options);
                   if (self_obj.children().length === 0) {
                            $.plot(chart_render, obj.data,options); 
                            chart_render.bind( "plothover", function( e, pos, item ) {
                                 var isTooltip = chart_render.is( ":ui-tooltip" );
                                 var ttPos = $.ui.tooltip.prototype.options.position;                        
                                 if ( item !== null && isTooltip === false ) {
                                     var label = item.series.label,
                                         data = item.datapoint[1],
                                         data0 = item.series.data[item.dataIndex][0],                                         
                                         content = label + ": " + data0 + ", " + data,
                                         evtPos;
                                     evtPos = $.extend( ttPos, {
                                         of: {
                                             pageX: item.pageX,
                                             pageY: item.pageY,
                                             preventDefault: $.noop
                                         }
                                     });
                                     chart_render.tooltip({position: evtPos,
                                                     content: content,
                                                     items: '*'})
                                           .tooltip( "open" );
                                 } else if ( item === null && isTooltip === true ) {
                                     chart_render.tooltip( "destroy" );
                                 }
                             });
                       $('<div><b>'+ obj.chart_label+ '</b></div>').insertBefore(self_obj);                      
                 } else {
                     // пушим данные для обновления
                    $.plot(chart_render, obj.data,options);         
                }  
                // поворачиваем надписи
                if (obj.xaxis.labelAngle > 0) {
                    var calculate_data = 3;
                    self_obj.find(".flot-x-axis").children(".flot-tick-label").css({
                        "-webkit-transform": "translateX(50%) rotate(" + obj.xaxis.labelAngle + "deg)",
                        "-moz-transform": "translateX(50%) rotate(" + obj.xaxis.labelAngle + "deg)",
                        "-ms-transform": "translateX(50%) rotate(" + obj.xaxis.labelAngle + "deg)",
                        "-o-transform": "translateX(50%) rotate(" + obj.xaxis.labelAngle + "deg)",
                        "transform": "translateX(50%) rotate(" + obj.xaxis.labelAngle + "deg)",
                        "transform-origin": calculate_data + "px " + calculate_data + "px 0px",
                        "-ms-transform-origin": calculate_data + "px " + calculate_data + "px 0px",
                        "-moz-transform-origin": calculate_data + "px " + calculate_data + "px 0px",
                        "-webkit-transform-origin": calculate_data + "px " + calculate_data + "px 0px",
                        "-o-transform-origin": calculate_data + "px " + calculate_data + "px 0px"
                    });
                  }
            }
          });
        };   
        
	// Функция добавления вкладок и содержимого через аякс
	SetTab = function (tabTitle,tabContentUrl,same_tab) {
		// Если предан флаг, то просто перезагружаем вкладу
		if (same_tab !== 'false') {
				var id = same_tab;
                                $("." + id).remove();
				$('#'+id).empty();						
				if (tabTitle !== '') {
					$('#ui-'+id).text(trim_text(tabTitle,40,3));
					$('#ui-'+id).prop("title",tabTitle);
				}								
			} else {							
				var id = 'tabs_' + counttab;	
                                sumtab++;
				$( "#tabs").children(".ui-tabs-nav").append(
								$('<li />').css('style','cursor:default;')                                                                
                                                                .append ($('<a />').css('style','cursor:default;')   
                                                                            .attr({ href: '#' + id, title: tabTitle, id: 'ui-' + id })   
                                                                            .append('<span style="float:right;left:10px;cursor:default;">'+trim_text(tabTitle,40,3)+'</span>')
                                                                            .append('<span class="ui-icon ui-icon-document" style="float:left;top:5px;cursor:default;"></span>')
                                                                         )
                                                                .append($('<span />').attr({
                                                                    'class':'ui-icon ui-icon-close',
                                                                    'style':'float:left;cursor:pointer'
                                                                }).on("touchend click", function() {
                                                                        CloseTab($( this ).parent().attr( "aria-controls" ));	
                                                                }))
                                                                );                                                                
				$( "#tabs" ).append( $("<div />").attr({'id': id,'style': 'overflow:hide;width:' + (doc_width - 18) + 'px'}) );
		}
		$('#'+id).append("<div class='loader_tab' style='overflow:hide'><div>");												
		tabContentUrl = tabContentUrl+"&tabid="+id;
		
		$( "#tabs" ).tabs("refresh");
		
		if (same_tab === 'false') {
			$("#tabs").tabs("option", "active",$('#tabs').children('.ui-tabs-nav li').length - 1);
		}						
		// ставим тригер на загрузку содержимого вкладки во фрейм
                $('#'+id).attr({need_redraw:true});
                redraw_document();
		$.ajax({
			  url: tabContentUrl,							  
			  type: 'GET',
			  success: function(data){
                              if (data !== "Not autorised") {
                                // нужно задестроить гриды если они есть:
                                $.each( $('#'+id).find('.ui-jqgrid'), function() {
                                    $('#'+$(this).attr('id')).jqGrid('GridDestroy');
                                }); 
                                $('#'+id).empty().css('text-align','left').attr({need_redraw:true});
                                $('#'+id).append($(data).fadeIn(300));                                        
                                redraw_document($(".ui-tabs-panel[aria-expanded='true']"));
                            } else {
                                // неавторизованы
                                $(location).prop('href',location.href);  
                            }
			  }	  
			});
		counttab++;							
	};					

	// Закрываем вкладку
	CloseTab = function (id_tab) {            
		var panelId = $("#ui-" + id_tab).parent().closest( "li" ).remove().attr( "aria-controls" );
		$( "#tabs" ).tabs( "refresh" );
                sumtab--;
                redraw_document($(".ui-tabs-panel[aria-expanded='true']"));              
                if ($(".ui-tabs-nav li[aria-selected='true']").length === 0 ) {                
                    document.title = doc_title;
                } 
                $( "#" + panelId ).remove();                
                // Нужно подчистить элементы multiselect и диалоги
                $("." + id_tab).remove();
                
                if (sumtab === 0 && !enable_menu) {   
                    $('.slidebarmenu').SlidebarMenu("open");  
                }
	};
        
	// Отрисовка окна и вкладок:
	redraw_document = function (id_tab) {                
                
                $('body').width(doc_width).height(doc_height);                
                $('.user_login').css({ top: doc_height/2 - 175, left: doc_width/2 - 200 });
                if ($.browser.msie) {
                    $('.post_form_login').css('top','110px');
                }
                // Для убыстрения отрисовки нам может быть передан идентификатор вкладки. (а может и нет) так что в
		// случае когда его нет берем текущую
		if (typeof(id_tab) === 'undefined')  id_tab = $($(".ui-tabs-panel[aria-expanded='true']"));                
              
                if (id_tab.attr('need_redraw') || id_tab.length === 0 ) {
                    // Основная страница расчет высоты:											
                    $("#tabs").tabs().height( doc_height - main_menu_higth - 10);
                    $("#tabs .ui-tabs-panel").height(doc_height - main_menu_higth - 10).width(doc_width - 20);

                    // Для надписи внутри вкладки
                    $(".about_tabs").offset({ top: doc_height - 50});
                    $(".about_tabs_ver").offset({ top: doc_height - 25});
                    
                    // Содержимое контейнера		
                    id_tab.children(".tab_main_content").height(doc_height - main_menu_higth - 90).width(doc_width - 20);
                    id_tab.attr({need_redraw:false}).children(".navigation_header").height(30);
                }
		//  Основные оверлеи
		$(".dialog_jqgrid_overlay").height(doc_height - main_menu_higth - 88).width(doc_width - 24).offset({ top: main_menu_higth + 30 + 50, left: 12 });
                 
		// Прячем полосу прокрутки
                id_tab.css('overflow','hidden');
                    
		// Помощь:
                if (id_tab.find(".help_content").length > 0) {
                    var hel_ll = id_tab.find(".help_content");    
                    var help_header = id_tab.children(".ui-accordion-header");                    
                    var content_hiegth = doc_height - main_menu_higth - 150 - ((help_header.height() * 2.05)* (help_header.length - 1));
                    hel_ll.height(doc_height - main_menu_higth - 90).width(doc_width - 20);
                    help_header.width(doc_width - 65);                    
                    hel_ll.children('.ui-accordion-content').height(content_hiegth).width(doc_width - 87);
                }

                // Гриды общие	
		$.each( id_tab.find('.grid_resizer, .grid_resizer_tabs'), function() {
			var self = $(this);                        
                        var ft      = self.attr('form_type');
                        var percent = self.attr('percent');
                        
                        if (!self.attr('detail_sub_tab')) {
                             if ((percent < 90 && percent > 10 ) || (self.attr('percent_saved') > 0)) {
                                            var doc_height_grid = (doc_height - main_menu_higth - 93)/100 * percent;
                                    } else {
                                            var doc_height_grid = doc_height - main_menu_higth - 93;
                             }
                             doc_width_grid = doc_width - 27;
                             add_to_koeff = 20;
                        } else {
                             percent = percent - (33/(doc_height/100));
                             doc_height_grid = (doc_height - main_menu_higth - 93)/100 * percent - 23;
                             doc_width_grid  = doc_width - 48;
                             add_to_koeff = 0;
                       }
			// Коэфициент для грида если открыт фильтр:
                       if (ft !== "TREE_GRID_FORM_DETAIL" && ft !== "TREE_GRID_FORM") { 
                            if (self.children('.ui-jqgrid').find('.ui-search-toolbar').css("display") !== 'none' && ft !== "TREE_GRID_FORM_MASTER" ) {
                                            var coeffd_filtr = 82 + add_to_koeff;
                                    } else {
                                            var coeffd_filtr = 55 + add_to_koeff;
                            }
                        } else {
                            // для деревьев кроме мастер дерева
                             var coeffd_filtr = 82;
                        }                        
			self.height(doc_height_grid).width(doc_width_grid);   
			self.height(doc_height_grid).children('.ui-jqgrid').height(doc_height_grid - 2).width(doc_width_grid)
										.children('.ui-jqgrid-pager').height(25).width(doc_width_grid)
							   .parent().children('.ui-jqgrid-view').height(doc_height_grid - 27).width(doc_width_grid)
										.children('.ui-jqgrid-hdiv').width(doc_width_grid)
							   .parent().children('.ui-jqgrid-bdiv').height(doc_height_grid - coeffd_filtr).width(doc_width_grid);
                    var frosen = self.find('.frozen-div');    
                    $.each( frosen, function() {
                        var wd = frosen.children('table').width();
                        var hd = self.find('.ui-jqgrid-titlebar').outerHeight();
                        frosen.width(wd).css('top',(hd+1)+'px');
                        frosen.parent().children('.frozen-bdiv').width(wd).height(self.find('.ui-jqgrid-bdiv')[0].clientHeight + 1).css('top',(hd + self.find('.ui-jqgrid-hbox').outerHeight()+1)+'px');
                    });
		});		

		$.each($(".grid_resizer[form_type$='_DETAIL'] div.ui-jqgrid-titlebar, .detail_tab .ui-tabs-nav"), function() {
			if ($(this).children("div[control='window']").length < 1) {	
				button_htm_down =  $('<span>').attr({
											'style':'float:right;cursor: pointer',
											'class':'ui-icon ui-icon-circle-triangle-n',
											'title':'Распахнуть на все окно/восстановить'
										}).click(function() {	
											upper = $(".ui-tabs-panel[aria-expanded='true'] .grid_resizer:first");											
											downn = $(".ui-tabs-panel[aria-expanded='true'] .grid_resizer:last,.ui-tabs-panel[aria-expanded='true'] .grid_resizer_tabs");
											$(".ui-tabs-panel[aria-expanded='true'] .ui-icon-circle-triangle-s").show();

											if (upper.attr('percent_saved') > 0) {
												upper.attr('percent',upper.attr('percent_saved')).removeAttr('percent_saved');
												downn.attr('percent',downn.attr('percent_saved')).removeAttr('percent_saved');
												downn.show();												
												$(this).parent().remove();
											} else {
												upper.attr('percent_saved',upper.attr('percent')).attr('percent',0);
												downn.attr('percent_saved',downn.attr('percent')).attr('percent',100);												
												upper.hide();
												$(this).hide();
											}
											redraw_document($(".ui-tabs-panel[aria-expanded='true']"));	

										});

				button_htm_up = $('<span>').attr({
											'style':'float:right;cursor: pointer',
											'class':'ui-icon ui-icon-circle-triangle-s',
											'title':'Свернуть/восстановить'
										}).click(function() {
											upper = $(".ui-tabs-panel[aria-expanded='true'] .grid_resizer:first");											
											downn = $(".ui-tabs-panel[aria-expanded='true'] .grid_resizer:last,.ui-tabs-panel[aria-expanded='true'] .grid_resizer_tabs");
											$(".ui-tabs-panel[aria-expanded='true'] .ui-icon-circle-triangle-n").show();

											if (upper.attr('percent_saved') > 0) {
												upper.attr('percent',upper.attr('percent_saved')).removeAttr('percent_saved');
												downn.attr('percent',downn.attr('percent_saved')).removeAttr('percent_saved');
												upper.show();
												$(this).show();
											} else {
												upper.attr('percent_saved',upper.attr('percent')).attr('percent',100);
												downn.attr('percent_saved',downn.attr('percent')).attr('percent',0);												
												downn.hide();
												$(this).hide();
												$(".ui-tabs-panel[aria-expanded='true'] div[control='window']").appendTo(upper.find('.ui-jqgrid-titlebar'));												
											}
											redraw_document($(".ui-tabs-panel[aria-expanded='true']"));	
										});
				$(this).append($('<div control="window" style="float:right;"></div>').append(button_htm_up,button_htm_down));
			}
		});
            // Проверка на открытые вкладки:
		if (sumtab > 7) {
                                alert_enabled = 1;
				$.each($('.navigation_header'), function() {											
					if ($(this).children('.alert_button').length !== 1) {
						$(this).append("<div class='alert_button ui-state-error ui-corner-all' style='float:right;width:100px;margin: 6px 15px 5px 5px;' title='Открыто более 7 вкладок одновременно," +
							"это может сильно замедлить работу системы. По возможности закройте одну или несколько вкладок.'><span class='ui-icon ui-icon-alert' style='float:left'></span>ВНИМАНИЕ!</div>");
					}
				});
			} else {
				if (alert_enabled > 0) {
                                    alert_enabled = 0;
                                    $('.navigation_header .alert_button').remove();
                                }
		}
                
        };
	
	replace_select_opt_group = function (object) {
		if (typeof(object) === 'undefined') object = $('body');
		// перерисовываем селекты, чтобы сработали отп группы, сначало начало группы:
		$.each($(object).find("select option[value='GROUP_START']"), function() {		
			$(this).replaceWith("<optgroup label='" + $(this).text() + "' >");
		});	
		// теперь смотри селекты с окончанием группы и преобразовавыем их
		$.each($(object).find("select option[value='GROUP_END']"), function() {
			var object 			= $(this).parent();
			var	selected_obj 	= object.children('option:selected');	// запоминаем выбранную позицию
			
			if (typeof(object.html()) !== 'undefined') {
				var select_text	= $(object.html().split('</optgroup>').join('')
                                                                .split('<option value="GROUP_END"></option>').join('</optgroup>')
                                                                .split('<option role="option" value="GROUP_END"></option>').join('</optgroup>'));
				select_text.children('option[value="' + selected_obj.attr('value') + '"]').attr('selected','selected');	
				object.empty().append(select_text);
			}
		});	
		
	};
	
	// Прикрепляем ресизеры
	set_resizers = function() {
		// Авторесизер
		$('.has_resize_control').resizable({
			distance: 30,					
			handles: 's',	
			resize: function( event, ui ) {						
					// Обновляем проценты и перерисовываем все
                                        var hh = doc_height -  93;
					var hgrid = 100 + ((ui.size.height - hh)/Math.abs(hh) * 100);
					var lgrid = 100 - hgrid;
					
					if (hgrid > 10 && hgrid < 95 && lgrid > 10 && lgrid < 95) {
                                            var objjj = $(this).attr("percent",hgrid);
                                            switch (objjj.attr("form_type"))
                                            {
                                                case "GRID_FORM_MASTER":
                                                    objjj.parent().children("div[form_type='GRID_FORM_DETAIL']").attr('percent', lgrid);
                                                    objjj.parent().children("div[form_type='TABED_GRID_FORM']").attr('percent', lgrid).children('.ui-tabs-panel').children('.grid_resizer_tabs').attr('percent', lgrid);
                                                break;
                                                 case "TREE_GRID_FORM_MASTER":
                                                    objjj.parent().children("div[form_type='TREE_GRID_FORM_DETAIL']").attr('percent', lgrid);
                                                    objjj.parent().children("div[form_type='TABED_GRID_FORM']").attr('percent', lgrid).children('.ui-tabs-panel').children('.grid_resizer_tabs').attr('percent', lgrid);
                                                break;
                                                default:
                                                    objjj.parent().children("div[form_type='GRID_FORM']").attr('percent', lgrid);
                                                break;
                                            }
					}									
			},
			create: function( event, ui ) {
				// Ресизер хелпер:
				$(this).children('.ui-resizable-handle').height(5.3).attr('align','center').append(
						$('<div />').addClass('ui-widget-header ui-state-hover ui-corner-all').height(2).width(150));
			}
		});			
	};

	//Детальные вкладки
	set_detail_tab= function() {						
			$( ".detail_tab" ).tabs({
					collapsible: true,
					heightStyle: "fill",
					activate: function( event, ui ) {
						if ($('#' + ui.newTab.attr('aria-controls')).children('.grid_resizer_tabs').attr('need_update') === 'true') {
							$('#' + $('#' + ui.newTab.attr('aria-controls')).children('.grid_resizer_tabs').attr('for')).jqGrid().trigger('reloadGrid', true);
							$('#' + ui.newTab.attr('aria-controls')).children('.grid_resizer_tabs').attr('need_update','false');
						}
                                                redraw_document(ui.newPanel);	
					}
			});
	};
	
	$(document).ready(function () {	           
            // Исправление некорректных пробелов в меню для IE8+
            if ($.browser.msie) {
                $('.ui-menu-item a').append('&nbsp;&nbsp;&nbsp;&nbsp;');
            }

            doc_height = $(window).height();
            doc_width = $(window).width() - 2;
            
            if (!user_not_logget) {
                if (enable_menu) {
                    $(".slidebarmenu").menubar({
                            menuIcon : true
                    }).css({
                            'text-align':'left'                            
                    });	
                    main_menu_higth = $(".slidebarmenu").height();
                } else {
                    main_menu_higth = 0;
                    $('.slidebarmenu').SlidebarMenu({
                        onClose:function () {
                            if (sumtab > 0) {
                                return true;
                            } else {
                                return false;
                            }
                        },
                        'position': slidebar,
                        'resizable':true
                    }).SlidebarMenu("open");
                    
                    // Кнопка меню
                    $("#tabs").children(".ui-tabs-nav").append("<div class='tab-nav-sb sb-toggle' style='float: " + slidebar + ";' title='Главное меню'><div class='ui-state-active navicon-line sb-toggle'></div><div class='ui-state-active navicon-line sb-toggle'></div><div class='ui-state-active navicon-line sb-toggle'></div></div>");
      
                    $('.sb-toggle').click(function() {
                        $('.slidebarmenu').SlidebarMenu('toggle');
                    });
                }
            }
            // Отрисовываем все элементы и формы на вкладке
            redraw_document();	

            // Сплеш сгрин для процесса загрузки страници
            // Дело в том что пока страница и скрипты непрогрузятся отображается как есть,
            // По этому мы ее скрываем чтобы небыло видно кишков
            $('#loading').fadeOut();
	});	

	$(window).resize(function () {
                $(".ui-tabs-panel").attr({need_redraw:true});
                doc_height = $(window).height();
		doc_width = $(window).width() - 2;                
		redraw_document($(".ui-tabs-panel[aria-expanded='true']"));
                if (!enable_menu) {
                    $('.slidebarmenu').SlidebarMenu("resize");
                }
	});
        
        // Для окна логина
        $('#password').keyup(function(eventObject){
            if (eventObject.keyCode === 13) {                        
                    $('#logon_btn').click();
              }
        });

        // Диалог настроке и обработчики
        $(".iws_param").dialog({
                autoOpen: false,
                modal: true,
                minWidth:450,
                closeOnEscape: true,
                resizable:false,
                buttons: {
                        "Применить" : function() {
                                $('#btn_opt_cancel').button('option', 'disabled', true );
                                $('#btn_opt_save').button('option', 'disabled', true );
                                    var searilezed = [];
                                    $.each($(this).find("input, select, textarea"), function() {
                                            var obj = $(this);
                                            if (obj.attr('name') !== undefined ){                                     
                                                   if (obj.attr('type') === 'checkbox') {
                                                      searilezed[obj.attr('name')] = (obj.attr('checked') === 'checked')?'on':'off'; 
                                                   } else {
                                                      searilezed[obj.attr('name')] = obj.val();
                                                   }                                       
                                            }
                                        });
                                        searilezed =  $.extend({}, searilezed);
                                        $.ajax({
                                                url: location.href + 'ajax.saveparams.php',
                                                datatype:'json',
                                                data: searilezed,
                                                cache: false,
                                                type: 'POST',
                                                        success: function(data) {                                                            
                                                            $(location).prop('href',location.href);                                                                    
                                                }	  
                                        });
                        },
                        "Отмена":function() {
                        $( this ).dialog( "close" );
                        }
                },
                close:function() {
                        $( this ).dialog( "close" );
                },
                open: function() {
                                $('.ui-dialog-buttonpane').find('button:contains("Отмена")').button({icons: { primary: 'ui-icon-close'}}).prop('id','btn_opt_cancel');;
                                $('.ui-dialog-buttonpane').find('button:contains("Применить")').button({icons: { primary: 'ui-icon-disk'}}).prop('id','btn_opt_save');;
                                $(this).parent().css('z-index', 805).parent().children('.ui-widget-overlay').css('z-index', 800);
                }
        });				

        $(".iws_about").dialog({
                autoOpen: false,
                modal: true,
                minWidth:650,
                closeOnEscape: true,
                resizable:false,                
                close:function() {
                        $( this ).dialog( "close" );
                },
                open: function() {								
                        $(this).parent().css('z-index', 805).parent().children('.ui-widget-overlay').css('z-index', 800); 
                }
        });

        // Обработка мультиселекта и кнопки настроек
        $("#themeselector").multiselect({multiple: false, header: false, selectedList: 1});
        $("#editabled,#cache_enable,#slidebar_right").iosCheckbox(); 
        $("#random_theme").iosCheckbox({
            checked: function() {
                $("#themeselector").multiselect('disable');
            },
            unchecked: function() {
                $("#themeselector").multiselect('enable');
            }            
        });
        
        $("#enable_menu").iosCheckbox({
            checked: function() {
                $("#slidebar_right").iosCheckbox('disable');
            },
            unchecked: function() {
                $("#slidebar_right").iosCheckbox('enable');
            }
        });      
        
        $("#renderer").slider({
            range: "min",
            value: $("#render_type").val(),
            min: 0,
            max: 3,
            step: 1,
            slide: function( event, ui ) {
                                if ($.browser.msie && ui.value >= 2) {
                                        $( "#render_type" ).val(2);
                                        $(this).slider({ value: 2 });
                                } else {
                                        $( "#render_type" ).val( ui.value );
                                }
            }
        }).height(8).children('a').css('border-radius',"100%")
        $("#num_mounth").spinner({
                                          spin: function( event, ui ) {
                                                if ( ui.value > 6 ) {
                                                  $( this ).spinner( "value", 1 );
                                                  return false;
                                                } else if ( ui.value < 1 ) {
                                                  $( this ).spinner( "value", 6 );
                                                  return false;
                                                }
                                          }
                                        });
        $("#num_reck").spinner({
                                          step: 10,
                                          spin: function( event, ui ) {
                                                if ( ui.value > 5000 ) {
                                                  $( this ).spinner( "value", 1 );
                                                  return false;
                                                } else if ( ui.value < 1 ) {
                                                  $( this ).spinner( "value", 5000 );
                                                  return false;
                                                }
                                          }
                                        });
        // Наши вкладки
        $( "#tabs" ).tabs({
                        collapsible: false,
                        heightStyle: "fill",
                        activate: function( event, ui ) {
                                    if (doc_title === null) {
                                      doc_title = document.title;  
                                    } 
                                    document.title = doc_title + ' [ ' + $(ui.newTab).children('a').attr('title') + ' ]';
                                    redraw_document(ui.newPanel);
                        }
        }).find( ".ui-tabs-nav" ).sortable({
          axis: "x",
          placeholder: "ui-state-highlight",
          distance: 10,
        stop: function() {
          $( "#tabs" ).tabs( "refresh" );
          redraw_document($(".ui-tabs-panel[aria-expanded='true']"));	
        }
       }).disableSelection();

        $('#logon_btn')
           .button()
           .click(function( event ) {                  
                     var usr = $('#username').val();
                     var pass = $('#password').val();
                     $('#login_form').fadeOut(500);
                     setTimeout(function() {$('#loading_text').text('Загрузка...');}, 500);    
                     
                     setTimeout(function(){ 
                        if (usr.replace(/\s/g,'') === '') {
                                custom_alert('Необходимо указать имя пользователя!');                                
                                $('#loading_text').empty();
                                $('#login_form').fadeIn(500);
                                return false;
                        }		
                        if (pass.replace(/\s/g,'') === '') {
                            custom_alert('Необходимо указать пароль!');                            
                            $('#loading_text').empty();
                            $('#login_form').fadeIn(500);
                            return false;
                        }
                        var specialChars = "<>!#$%^&*()+[]{}?:;|'\",.~`-=";
                            var check = function(string){
                             for(i = 0; i < specialChars.length;i++){
                               if(string.indexOf(specialChars[i]) > -1){
                                   return true;
                                }
                             }
                             return false;
                            };
                        if (check(pass) === true) {
                            custom_alert('Пароль содержит один или несколько символов которые недопустимы для логина в систему. Например символы ".",",","&#60;","&#62;" а также некотоые другие специальные символы.');                            
                            $('#loading_text').empty();
                            $('#login_form').fadeIn(500);
                            return false;
                        }
                        $.ajax({
                                            url: 'ajax.saveparams.php?act=login',
                                            datatype:'json',
                                            data: { username: $('#username').val(), password:  $('#password').val() },
                                            cache: false,
                                            type: 'POST',
                                                    success: function(data) {                                                                    
                                                          if (data != 'true') {                                                                              
                                                              custom_alert('Неверное имя пользователя или пароль!');                                                                          
                                                              $('#loading_text').empty();
                                                              $('#login_form').fadeIn(500);
                                                           } else {   
                                                                setTimeout(function() {                                                                                
                                                                     $('#loading').fadeIn(300);
                                                                }, 500);                                                            
                                                                setTimeout(function() {                                                                                     
                                                                     $.ajax({
                                                                            success: function(s){
                                                                                $('body').html(s);
                                                                                // cleanup:
                                                                                $('body').children('meta').remove();                                                                                            
                                                                                $('body').children('link[rel!="stylesheet"]').remove();
                                                                                $('body').children('title').remove();
                                                                                $('head').children('style[type="text/css"]').remove();
                                                                                $('head').children('link[rel="stylesheet"]').remove();
                                                                                $('head').children('link[rel="stylesheet"]').remove();
                                                                                $('head').children('script[type="text/javascript"]').remove();
                                                                            }
                                                                        });
                                                                }, 1000);                                                                                
                                                          }	
                                                    }
                            });                        
                     }, 1000);
                     return false;
        });

        // Кнопка справки если есть:
        $(".help_button").button({icons: {primary: 'ui-icon-help'},text: false})
                        .attr('style','float: right;')
                        .appendTo("#tabs .ui-tabs-nav").click(function() {
                                SetTab('Индекс справочного раздела',$(this).attr('url'),'false'); 
        });

        // Кнопка закрытия
        $("#tabs").children(".ui-tabs-nav").append(
                        $('<button>Закрыть все вкладки</button>').attr({
                                id:'close_all_tab',
                                style:'float: right;margin: 0px 5px 3px 0px;'
                        }).button({icons: {primary: 'ui-icon-closethick'},text: false}).click(function() {
                           $.each( $('#tabs .ui-tabs-nav li') , function() {                                    
                                CloseTab($(this).attr('aria-controls'));
                        });
        }));

        // Кнопка распечатать
        $("#tabs").children(".ui-tabs-nav").append(
                        $('<button>Распечатать текущую открытую вкладку</button>').attr({
                                id:'print_this_tab',
                                style:'float: right;margin: 0px 5px 3px 0px;'
                        }).button({icons: {primary: 'ui-icon-print'},text: false})
                          .click(function() {
                              var pr_object = $(".ui-tabs-panel[aria-expanded='true'] .tab_main_content").find('.ui-jqgrid-view table, .FormGrid table, .chart').clone();
                                  pr_object.removeAttr('height class top left'); 
                                $(pr_object).printThis({
                                            printContainer: false, 
                                            importCSS: false,
                                            loadCSS: '/library/print.css',
                                            debug: false
                                });                 
                        })
        );
       
	// Проверка значений:
	check_form = function(formid) {
		var data_ok = true;
			$.each(formid.find("input[is_requred='true']"), function() {
					if ($.trim($(this).val()) === "") {									
						$(this).addClass('ui-state-error');
						$('#clone_' + $(this).attr('id')).parent().addClass('ui-state-error');
						$(this).parent().children('.ui-button').addClass('ui-state-error');	
						data_ok = false;
				}
			});
			$.each(formid.find("select[is_requred='true']"), function() {																			
				if ($.trim($(this).val()) === "") {
					$(this).addClass('ui-state-error');																				
					$(this).parent().children('button').addClass('ui-state-error');	
					data_ok = false;
				}
			});		
			$.each(formid.find("textarea[is_requred='true']"), function() {																			
					if ($.trim($(this).val()) === "") {
					$(this).addClass('ui-state-error');		
					$(this).parent().children('.ace_scroller').addClass('ui-state-error');																				
					data_ok = false;
				}
			});																						
		if (data_ok) {
				return true; 
			} else {								
				custom_alert("Не все поля заполнены, заполните выделенные ячейки.");
				return false;
		}
	};
	
        // Создание элементов
        create_from_table_elements = function (form_id) {         
             var spl_text = form_id.attr('id').split('_');
             var spl_tabid = spl_text[spl_text.length-2] + '_' + spl_text[spl_text.length-1]; 
             var s_width = 0;
             
             $.each(form_id.find("input, select, textarea"), function() {
		var obj = $(this);
                
		obj.width(obj.attr('w')).addClass(spl_tabid);
			
		switch (obj.attr('row_type')) {			
                    case 'I' : // INTEGER, NUMBER, NUMBER LOOOONG,CURRVAL
                    case 'N' :
                    case 'NL':
                    case 'C' :         
                            sp_value =  obj.val();
                            obj.spinner();
                            if (obj.attr('row_type') === 'N') {
                                obj.spinner( "option", "culture", "ru-RU" )
                                         .spinner( "option", "numberFormat", "n2" )
                                         .spinner( "option", "step", "0.01" );
                            } else if (obj.attr('row_type') === 'NL') {
                                obj.spinner( "option", "culture", "ru-RU" )
                                         .spinner( "option", "numberFormat", "n7" )
                                         .spinner( "option", "step", "0.0000001" );
                            } else if (obj.attr('row_type') === 'C') {
                                  obj.spinner( "option", "culture", "ru-RU" )
                                         .spinner( "option", "numberFormat", "n2" )
                                         .spinner( "option", "step", "0.01" );
                            }                                  
                            obj.removeClass('ui-widget-content ui-corner-all')
                            .calculator({
                                    useThemeRoller: true, showAnim:'', showOn:'',
                                    onButton: function(label, value, inst) { 
                                                    obj.spinner( 'value', value );
                                    }
                            });	
                            $($('<button>Открыть калькулятор</button>').button({icons: {primary: 'ui-icon-calculator'}, text: false})
                                            .click(function( event ) {
                                                            obj.calculator('show');
                                            })
                            ).insertAfter(obj.parent());
                            if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') !== 'false') {
                                    obj.spinner( "option", "disabled" );
                                    obj.parent().parent().children('.ui-button').remove();	
                            }
                            obj.spinner( 'value', sp_value );
					
		    break;
		    case 'P': // PASSWORD
			    obj.attr('value','');
		    break;
		    case 'B': // CHECKBOX
                            obj.iosCheckbox();					
		     break;
                     case 'MAS': // МАСКА СПЕЦ ПОЛЕ
                            var char_case = obj.attr('case');
                            obj.mask(obj.attr('mask') , {
                                onKeyPress: function(str, e, o){ 
                                  switch (char_case) {
                                      case "U":
                                         $(o).val(str.toUpperCase()); 
                                      break;
                                      case "L":
                                         $(o).val(str.toLowerCase());
                                      break;      
                                  }  
                                }
                           });
                    break;
		    case 'D': // DATE					
                        obj.datepicker({
                                        showOn: 'button',
                                        showWeek: true,
                                        numberOfMonths: num_of_mounth,
                                        changeYear: true,
                                        firstDay: 1
                                        }).addClass(spl_tabid)
                                        .parent().children('.ui-datepicker-trigger')
                                        .button({
                                                icons: {primary: 'ui-icon-calendar'},
                                                text: false
                                        }).addClass(spl_tabid);
		    break;
		    case 'DT': // DATE TIME					
                                var myControl=  {
                                        create: function(tp_inst, obj, unit, val, min, max, step){
                                                $('<input class="ui-timepicker-input" value="'+val+'" style="width:50px">')
                                                        .appendTo(obj)
                                                        .spinner({
                                                                min: min,
                                                                max: max,
                                                                step: step,												
                                                                change: function(e,ui){
                                                                                if(e.originalEvent !== undefined)
                                                                                        tp_inst._onTimeChange();
                                                                                tp_inst._onSelectHandler();
                                                                        },
                                                                spin: function(e,ui){
                                                                                tp_inst.control.value(tp_inst, obj, unit, ui.value);
                                                                                tp_inst._onTimeChange();
                                                                                tp_inst._onSelectHandler();
                                                                        }
                                                        });
                                                return obj;
                                        },
                                        options: function(tp_inst, obj, unit, opts, val){
                                                if(typeof(opts) === 'string' && val !== undefined)
                                                                return obj.find('.ui-timepicker-input').spinner(opts, val);
                                                return obj.find('.ui-timepicker-input').spinner(opts);
                                        },
                                        value: function(tp_inst, obj, unit, val){
                                                if(val !== undefined)
                                                        return obj.find('.ui-timepicker-input').spinner('value', val);
                                                return obj.find('.ui-timepicker-input').spinner('value');
                                        }
                                };
                        obj.datetimepicker({
                                        showWeek: true,
                                        numberOfMonths: num_of_mounth,
                                        changeYear: true,
                                        firstDay: 1,
                                        timeFormat :'HH:mm:ss',
                                        showOn: 'button',
                                        controlType: myControl
                                        }).addClass(spl_tabid)
                                        .parent().children('.ui-datepicker-trigger')
                                        .button({
                                                icons: {primary: 'ui-icon-calendar'},
                                                text: false
                                        }).addClass(spl_tabid);
			   break;		
			   case 'SB': // MULTISELECT
				obj.multiselect({
                                        multiple: obj.attr('multiple')?true:false,
                                        minWidth: (obj.attr('w') < 255)?255:obj.attr('w'),
                                        header: true,
                                        height_button: 29,
                                        selectedList: obj.attr('size')?obj.attr('size'):1
				}).multiselectfilter().addClass(spl_tabid);
			    break;
			    case 'M': // MULTILINE - ACE     
                                if (obj.attr('show_disabled') !== "true") {
                                    setTimeout(function() {  
                                     obj.before($('<div />').attr({'id':'editor_' + obj.attr('name')}));
                                         $('#editor_' + obj.attr('name')).ace_editor({
                                            width: obj.attr('w'),
                                            heigth: (obj.attr('rows')*12 > 50)?obj.attr('rows')*12:50,
                                            mode: 'ace/mode/pgsql',
                                            classes: 'FormElement ui-widget-content ui-corner-all',
                                            resizable: true,
                                            value: obj.val(),
                                            change: function( element, data ) {								
                                                    if(typeof(data) === "object") {
                                                            obj.val(""); // Бывает такое что возвращается обьект, если он пустой
                                                    } else {
                                                            obj.val(data);
                                                    }
                                            }
                                    }).addClass(spl_tabid).css({'margin-left':'0px;'});
                                    obj.hide(); 
                                   }, 50); 
                               }
                            break;
			}
                    if (typeof(obj.attr('field_has_sql')) !== "undefined" && obj.attr('row_type') !== "SB") {
                        $($('<button>Расчитать/вставить/обновить содержимое</button>').button({icons: {primary: 'ui-icon-refresh'}, text: false}).addClass('have_sql_action')
                                .click(function( event ) {
                                    var searilezed_elem = [];
                                        $.each(form_id.find("input, select, textarea"), function() {
                                            var elem = $(this);
                                            if (elem.attr('name') !== undefined ){                                     
                                                   if (elem.attr('row_type') === 'B') {
                                                      searilezed_elem[elem.attr('name')] = (elem.attr('checked') === 'checked')?1:0; 
                                                   } else {
                                                      searilezed_elem[elem.attr('name')] = elem.val();
                                                   }                                       
                                            }
                                        }); 
                                searilezed_elem =  $.extend({}, searilezed_elem); //save as object                             
                                $.ajax({
                                    url:  'ajax.data.field.php?type=field&value_name=' + obj.attr('name') + "&form_id=" + obj.attr('form_id'),
                                    datatype:'json',
                                    data: searilezed_elem,
                                    cache: false,
                                    type: 'POST',
                                       success: function(rets) {	
                                          obj.val(rets);
                                          update_table_elemnts(form_id,obj);
                                       }	  
                                   });	  
                                   return false;
                                })
                            ).insertAfter(form_id.find('#tr_'+ obj.attr('id')+ ' .DataTD' ).children(':last'));
                        $(this).width($(this).width() + 20);                    
                    }   
                    
                    // Если мы видим поля но не можем изменять
                    if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') !== 'false') {
                         obj.attr({'name':null,'disabled':'disabled'}).addClass('FormElement ui-widget-content ui-corner-all ui-state-disabled');
                         if (typeof(obj.attr('field_has_sql')) !== "undefined") {
                             //Блокируем самообновление
                             obj.parent().children('.have_sql_action').button('option', 'disabled', true );
                         }
                         switch (obj.attr('row_type')) {			
                                case 'I' : // INTEGER, NUMBER, NUMBER LOOOONG,CURRVAL
                                case 'N' :
                                case 'NL':
                                case 'C' : 
                                    obj.spinner({ disabled: true });
                                break;   
                                case 'D': // DATE	
                                case 'DT':
                                       obj.datepicker( "option", "disabled", true );
                                       obj.parent().children('.ui-datepicker-trigger').remove();
                                break;   
                                case 'SB':
                                       obj.multiselect('disable');
                                break;
                         }
                    }
                     if ($(this).width() > s_width) {
                         s_width = $(this).width();
                    }
              });  
              return s_width;
        };    
        
        // хеширование строки
        hashCode = function(s){
            return s.split("").reduce(function(a,b){a=((a<<5)-a)+b.charCodeAt(0);return a&a},0);              
        }
	
        // обновление элементов и контроллов на странице
	update_table_elemnts = function (form_id,cur_elem) {                
          
          if (typeof(cur_elem) === 'undefined') {
            var search_in = form_id.find("input, select, textarea");
           } else {
            var search_in = cur_elem;
          }      
                // разбираем элементы
		$.each(search_in, function() {
			var obj = $(this);			
			// Убираем алертный класс			
			obj.removeClass('ui-state-error');
			$('#clone_' + obj.attr('id')).parent().removeClass('ui-state-error');
			obj.parent().children('.ui-button').removeClass('ui-state-error');	
			obj.parent().children('button').removeClass('ui-state-error');			
			obj.parent().children('.ace_scroller').removeClass('ui-state-error');	
			
			switch (obj.attr('row_type')) {			
                                case 'I' : // INTEGER, NUMBER, NUMBER LOOOONG,CURRVAL
                                case 'N' :
                                case 'NL':
                                case 'C' :  	
                                        obj.spinner( 'value', obj.val() );
				break;
				case 'P': // PASSWORD
                                    obj.attr('value','');
				break;				
				case 'B': // CHECKBOX	
                                    obj.iosCheckbox("refresh");				
				break;
				case 'D': // DATE
                                case 'DT': // DATE TIME    
                                    strs = obj.val();
                                    if (strs.length  > 1) {
                                        obj.datepicker("setDate", obj.val());	
                                    }
				break;
				case 'SB': // MULTISELECT
						if (!obj.attr('multiple')) {
                                                        var txt = obj.find('option:selected').text();                                                       
                                                        obj.multiselect("setButtonValue",txt);
							obj.multiselect("widget").find("input:checked").removeAttr('checked').removeAttr('aria-selected').parent().removeClass('ui-state-active ui-state-hover');							
							$.each(obj.multiselect("widget").find("span:contains('" + txt + "')"), function() {
								if (txt !== "" && $(this).text() === txt) {
								$(this).parent().addClass('ui-corner-all ui-state-active ui-state-hover')
									.children('input').attr('checked','checked').attr('aria-selected',true);
								}
							});
							if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') !== 'false') {
								obj.multiselect('disable');
								obj.multiselect("refresh");	
							}
						} else {
							obj.multiselect("refresh");						
						}
		
				break;
				
				case 'M': // MULTILINE - ACE
                                    if (obj.attr('show_disabled') !== "true") {
                                        $('#editor_' + obj.attr('name')).ace_editor({value: obj.val()});
                                    }
				break;
			} 
		});	
	};	
	
	// Нужно для автозагрузки данных в селект в гриде 	
	get_select_values_grid = function (gridname, value_name,parent_id) {
		$.ajax({
				url: 'ajax.data.field.php?type=select&value_name=' + value_name+'&parent_id='+parent_id,
				datatype :'json',
				cache: false,
				type: 'GET',
					success: function(data) {											
						$('#' + gridname).jqGrid('setColProp',value_name,{ editoptions: { value: data }, searchoptions: {value: ':;'+ data}});
						$('#' + gridname).attr('new_colmodel',true);
				}	  
			});	
	};

$.calculator.regionalOptions['ru'] = {
	decimalChar: '.',
	buttonText: '...', buttonStatus: 'Открыть калькулятор',
	closeText: 'Закрыть', closeStatus: 'Закрыть калькулятор',
	useText: 'OK', useStatus: 'Использовать текущее значение в поле',
	eraseText: 'Сброс', eraseStatus: 'Стереть значение',
	backspaceText: '<-', backspaceStatus: 'Стереть последнюю цифру',
	clearErrorText: 'CE', clearErrorStatus: 'Стереть последнее число',
	clearText: 'С', clearStatus: 'Сбросить',
	memClearText: 'MC', memClearStatus: 'Сбросить память',
	memRecallText: 'MR', memRecallStatus: 'Вставить из памяти',
	memStoreText: 'MS', memStoreStatus: 'Сохранить в память',
	memAddText: 'M+', memAddStatus: 'Добавить в память',
	memSubtractText: 'M-', memSubtractStatus: 'Вычесть из памяти',
	base2Text: 'Бин', base2Status: 'Бинарный',
	base8Text: 'Восм', base8Status: 'Восмеричный',
	base10Text: 'Дес', base10Status: 'Десятичный',
	base16Text: 'Шест', base16Status: 'Шестнадцатиричный',
	degreesText: 'Град', degreesStatus: 'Градусы',
	radiansText: 'Рад', radiansStatus: 'Радианы',
	isRTL: false};
$.calculator.setDefaults($.calculator.regionalOptions['ru']);
									
$.extend($.ech.multiselectfilter.prototype.options, {
	label: "Фильтр:",
	placeholder: "введите слово"
});

$.extend($.ech.multiselect.prototype.options, {
    height: 250,
    minWidth: 350,
	checkAllText: 'Отметить все',
	uncheckAllText: 'Снять отметку со всех',
	noneSelectedText: 'Выберите из списка',
	selectedText: 'Выбрано #'
});

Globalize.addCultureInfo( "ru-RU", "default", {
	name: "ru-RU",
	englishName: "Russian (Russia)",
	nativeName: "русский (Россия)",
	language: "ru",
	numberFormat: {
		",": "",
		".": ".",
		negativeInfinity: "-бесконечность",
		positiveInfinity: "бесконечность",
		percent: {
			pattern: ["-n%","n%"],
			",": "",
			".": "."
		},
		currency: {
			pattern: ["-n$","n$"],
			",": "",
			".": ".",
			symbol: "p."
		}
	},
	calendars: {
		standard: {
			"/": ".",
			firstDay: 1,
			days: {
				names: ["воскресенье","понедельник","вторник","среда","четверг","пятница","суббота"],
				namesAbbr: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"],
				namesShort: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
			},
			months: {
				names: ["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь",""],
				namesAbbr: ["янв","фев","мар","апр","май","июн","июл","авг","сен","окт","ноя","дек",""]
			},
			monthsGenitive: {
				names: ["января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря",""],
				namesAbbr: ["янв","фев","мар","апр","май","июн","июл","авг","сен","окт","ноя","дек",""]
			},
			AM: null,
			PM: null,
			patterns: {
				d: "dd.MM.yyyy",
				D: "d MMMM yyyy 'г.'",
				t: "H:mm",
				T: "H:mm:ss",
				f: "d MMMM yyyy 'г.' H:mm",
				F: "d MMMM yyyy 'г.' H:mm:ss",
				Y: "MMMM yyyy"
			}
		}
	}
});
	
$.widget("ui.ace_editor", {  
	options: {  
		editor: null,
		mode: 'ace/mode/pgsql',
		classes: 'ui-widget-content ui-corner-all',
		resizable: true,
		value: '',
		heigth: 30,
		width: 250
		},
	_create: function() { 
		var self = this,
			self_id = self.element.attr('id'),
			self_elem = $('#' + self.element.attr('id'));
			
		self.options.editor = ace.edit(self_id);
		self.options.editor.getSession().setMode(self.options.mode);
		self.options.editor.getSession().setValue(self.options.value);
		
		self.options.editor.getSession().on('change', function(){
			self._trigger("change",self,self.options.editor.getSession().getValue());
		});						

		self.options.editor.setHighlightActiveLine(false);
		self.options.editor.renderer.setShowGutter(false);
		self.options.editor.setShowPrintMargin(false);
		
		self_elem.width(self.options.width)
				.height(self.options.heigth)
				.addClass(self.options.classes)
				.css('margin-left','5px');
				
		if 	(self.options.resizable) {	
			self_elem.resizable({						  
					resize: function(event, ui) {
							self_elem.height($(this).height()).width($(this).width());
							self.options.editor.resize();
					}
				});
		}
		self.options.editor.resize();		
	},
	_setOption: function(option, value) {  
		$.Widget.prototype._setOption.apply( this, arguments );  
		switch (option) {  
			case "value":  
				this.options.editor.getSession().setValue(value);
				this.options.value = value;
			break;
			case "heigth":  this.options.heigth = value; 	break; 
			case "width":  this.options.width = value; 	break; 
			case "resizable":  this.options.resizable = value; 	break; 
			case "classes":  this.options.classes = value; 	break; 
			case "mode":  this.options.mode = value; 	break; 
			}  
	} 	
	
	}); 	 	
});