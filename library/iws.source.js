/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
jQuery.uiBackCompat = false;
jQuery.jgrid.no_legacy_api = true;

function browserDetectNav(chrAfterPoint)
{
var UA=window.navigator.userAgent,
	OperaB = /Opera[ \/]+\w+\.\w+/i,
	OperaV = /Version[ \/]+\w+\.\w+/i,	
	FirefoxB = /Firefox\/\w+\.\w+/i,
	ChromeB = /Chrome\/\w+\.\w+/i,
	SafariB = /Version\/\w+\.\w+/i,
	IEB = /MSIE *\d+\.\w+/i,
	SafariV = /Safari\/\w+\.\w+/i,
	browser = new Array(),
	browserSplit = /[ \/\.]/i,
	OperaV = UA.match(OperaV),
	Firefox = UA.match(FirefoxB),
	Chrome = UA.match(ChromeB),
	Safari = UA.match(SafariB),
	SafariV = UA.match(SafariV),
	IE = UA.match(IEB),
	Opera = UA.match(OperaB);
		if ((!Opera=="")&(!OperaV=="")) browser[0]=OperaV[0].replace(/Version/, "Opera")
				else 
		if (!Opera=="")	browser[0]=Opera[0]
				else
		if (!IE=="") browser[0] = IE[0]
				else 
		if (!Firefox=="") browser[0]=Firefox[0]
				else
		if (!Chrome=="") browser[0] = Chrome[0]
				else
		if ((!Safari=="")&&(!SafariV=="")) browser[0] = Safari[0].replace("Version", "Safari")
                                else
                if (!!window.MSStream) browser[0] = "Internet Explorer IE11";
            
	var outputData;
	
	if (browser[0] != null) outputData = browser[0].split(browserSplit);
	if (((chrAfterPoint == null)|(chrAfterPoint == 0))&(outputData != null)) 
		{
			chrAfterPoint=outputData[2].length;
			outputData[2] = outputData[2].substring(0, chrAfterPoint);
			return(outputData);
		}
			else
				if (chrAfterPoint != null) 
				{
					outputData[2] = outputData[2].substr(0, chrAfterPoint);
					return(outputData);					
				}
					else	return(false);
}

function browserDetectJS() {
var
	browser = new Array();
	
	if (window.opera) {
		browser[0] = "Opera";
		browser[1] = window.opera.version();
	}
		else 
		if (window.chrome) {
			browser[0] = "Chrome";
		}
			else
			if (window.sidebar) {
				browser[0] = "Firefox";
			}
				else
					if ((!window.external)&&(browser[0]!=="Opera")) {
						browser[0] = "Safari";
					}
						else
						if (window.ActiveXObject) {
							browser[0] = "MSIE";
							if (window.navigator.userProfile) browser[1] = "6"
								else 
									if (window.Storage) browser[1] = "8"
										else 
											if ((!window.Storage)&&(!window.navigator.userProfile)) browser[1] = "7"
												else browser[1] = "Unknown";
						}
	
	if (!browser) return(false)
		else return(browser);
}
function alert_browser_message (br) {
alert("К сожалению, ваша версия браузера:\r\n" + br + "\r\nбольше не поддерживается и система будет работать нестабильно, обновитесь, либо обратитесь к администратору!");
throw new Exception_no_browser("error"); // инициируем ошибку для остановки выполнения скриптов
}

var browserNav = browserDetectNav(1),
	browserJS = browserDetectJS(), browser;
	if (browserNav[0] == browserJS[0]) browser = browserNav
		else
			if (browserNav[0] != browserJS[0]) browser = browserJS
				else
			browser = false;
			
// Прописываем корректно определенные версии браузеров, и сверяемся с версиями
jQuery.browser = {};
switch (browser[0])
{
		case 'Chrome':
			jQuery.browser.webkit = true;
			if (browser[1] < 23) { alert_browser_message(browser[0] +' (версия ' + browser[1] +'.' + browser[2] + ')') }; 
		break;
		case 'Safari':
			jQuery.browser.safari = true;
			if (browser[1] < 5) { alert_browser_message(browser[0] +' (версия ' + browser[1] +'.' + browser[2] + ')') }; 
		break;
		case 'MSIE':
			jQuery.browser.msie = true;
			if (browser[1] < 9) { alert_browser_message(browser[0] +' (версия ' + browser[1] +'.' + browser[2] + ')') }; 
		break;
		case 'Opera':
			jQuery.browser.opera = true;
			if (browser[1] < 13 ) { alert_browser_message(browser[0] +' (версия ' + browser[1] +'.' + browser[2] + ')') }; 
		break;
		case 'Firefox':
			jQuery.browser.mozilla = true;
			if (browser[1] < 10) { alert_browser_message(browser[0] +' (версия ' + browser[1] +'.' + browser[2] + ')') }; 
		break;
};
        
var counttab = 1;	
var sumtab = 0;
var alert_enabled = 0;
var hidden_menu = false;	
var main_menu_higth;
var doc_height;
var doc_width;
var doc_title = null;
                
$(function() {
    
       // Наши вкладки
	$( "#tabs" ).tabs({
			collapsible: false,
			heightStyle: "fill",
			activate: function( event, ui ) {                                    
                                    redraw_document($(".ui-tabs-panel[aria-expanded='true']"));
                                    if (doc_title === null) {
                                      doc_title = document.title;  
                                    } 
                                    document.title = doc_title + ' [ ' + ui.newTab.text() + ' ]';
                                   
			}
	});
	
	$( "#tabs" ).find( ".ui-tabs-nav" ).sortable({
          axis: "x",
	  placeholder: "ui-state-highlight",
	  distance: 10,
        stop: function() {
          $( "#tabs" ).tabs( "refresh" );
          redraw_document($(".ui-tabs-panel[aria-expanded='true']"));	
        }
      }).disableSelection();
	
	custom_alert = function (output_msg)
	{
            
                title_msg = 'Внимание:';		
                if (output_msg.search('ORA-') != -1) title_msg = 'SQL Ошибка конфигурации:';
                if (output_msg.search('запрещен') != -1) title_msg = 'Аунтефикация:';
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
	}
					
	// Основное меню для загрузки
	$("#Menubar").menubar({
		menuIcon : true
	}).css({						
		'float': 'left',
		'text-align':'left',
		'display': 'block'
	});	
	
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
	}
	
        // Отрисовка,перерисовка графиков
        plot_graph = function (self_obj) { 
          
            // Заполняем графики						
            $.ajax({
              url: self_obj.attr('url'),							  
              type: 'GET',
              success: function(data) {	 
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
                   if (self_obj.children().length == 0) {
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
		if (same_tab != 'false') {
				var id = same_tab;								
				$('#'+id).empty();						
				if (tabTitle != '') {
					$('#ui-'+id).text(trim_text(tabTitle,40,3));
					$('#ui-'+id).prop("title",tabTitle);
				}								
			} else {							
				var id = 'tabs_' + counttab;	
                                sumtab++;
				$( "#tabs").children(".ui-tabs-nav" ).append(
								$('<li />')                                                                
                                                                .append ($('<a />')
                                                                            .attr({ href: '#' + id, title: tabTitle, id: 'ui-' + id })                                                                            
                                                                            .text(trim_text(tabTitle,40,3))
                                                                            .append('<span class="ui-icon ui-icon-document" style="float:left;top:5px"></span>')
                                                                         )
                                                                .append('<span class="ui-icon ui-icon-close" style="float:left"></span>')
                                                                );                                                                
				$( "#tabs" ).append( $("<div />").attr({'id': id,'style': 'overflow:hide;width:' + (doc_width - 18) + 'px'}) );
		}
		$('#'+id).append("<div class='loader_tab' style='overflow:hide'><div>");												
		tabContentUrl = tabContentUrl+"&tabid="+id;
		
		$( "#tabs" ).tabs("refresh");
		
		if (same_tab == 'false') {
			$("#tabs").tabs("option", "active",$('#tabs').children('.ui-tabs-nav li').length - 1);
		}						
		// ставим тригер на загрузку содержимого вкладки во фрейм
                $('#'+id).attr({need_redraw:true});
                redraw_document();
		$.ajax({
			  url: tabContentUrl,							  
			  type: 'GET',
			  success: function(data){
				if($(data).find("div[window_login='logon']").length == 0) {
					$('#'+id).empty().css('text-align','left').attr({need_redraw:true});
                                        $('#'+id).append($(data).fadeIn(300));                                        
					redraw_document($(".ui-tabs-panel[aria-expanded='true']"));
				} else {		 		
					// Нам вернули страницу авторизации. отчищаем документ
					$('html').empty().append(data);
                                        document.title = doc_title;
                                       
				}
			  }	  
			});
		counttab++;							
	}					

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
	}

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
        
	// Отрисовка окна и вкладок:
	redraw_document = function (id_tab) {
               
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
		$(".dialog_jqgrid_overlay,.ui-widget-overlay").height(doc_height - main_menu_higth - 85).width(doc_width - 24).offset({ top: main_menu_higth + 30 + 50, left: 12 });
                 
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
                             percent = percent - (33/(doc_height/100))
                             doc_height_grid = (doc_height - main_menu_higth - 93)/100 * percent - 23;
                             doc_width_grid  = doc_width - 48;
                             add_to_koeff = 0;
                       }
			// Коэфициент для грида если открыт фильтр:
                       if (ft != "TREE_GRID_FORM_DETAIL" && ft != "TREE_GRID_FORM") { 
                            if (self.children('.ui-jqgrid').find('.ui-search-toolbar').css("display") != 'none' && ft != "TREE_GRID_FORM_MASTER" ) {
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
					if ($(this).children('.alert_button').length != 1) {
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
        }
	
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
		
	}
	
	// Автоширина столбцов в гриде (применяемся только к указаннуму)
	auto_width_grid = function (grid) {
		// Выбираем загловок и первую строку в таблице в гриде
		var grid_header = $('#gview_' + grid + ' .ui-jqgrid-hdiv .ui-jqgrid-hbox table tr:first th:visible');
		var grid_hcontent = $('#gview_' + grid + ' .ui-jqgrid-bdiv div table tr:first td:visible');
		
		// Проверяем можно ли сделать автоширину (т.е. сумма столбцов по длине меньше чем общий документ)
		var grid_width_old = 0;
		var has_r_num	= 0;	
		var count_element = 0;
		
		$.each(grid_header, function() {
			if ($(this).attr('id') == grid + "_rn") {
				has_r_num = $(this).width(); // Убираем r_num из расчета
			}
			grid_width_old = grid_width_old + $(this).width();
			count_element = count_element + 1;
		});
		
		var grid_width = $('#' + grid).parent().width(); // офсет на прокрутку обязателен
		
		if (grid_width_old < grid_width) {
			// Перерасчитываем ширину и применяем ее согласно старой ширине столбцов
			var coeff = (grid_width/(grid_width_old)); // Коэфициент увеличения
			$.each(grid_header, function() {
				var w_tmp = $(this).width();
				// Применяем к заголовку
				if ($(this).attr('id') != grid + "_rn") {	
					$(this).width(w_tmp * coeff);
				}
			});
			$.each(grid_hcontent, function() {
				var w_tmp = $(this).width();
				// Применяем к заголовку
				if ($(this).width() != has_r_num) {	
					$(this).width(w_tmp * coeff);
				}
			});
		}					
	}

	// Прикрепляем ресизеры
	set_resizers = function() {
		// Авторесизер
		$('.has_resize_control').resizable({
			distance: 30,					
			handles: 's',	
			resize: function( event, ui ) {						
					// Обновляем проценты и перерисовываем все
                                        var hh = doc_height - main_menu_higth - 93;
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
	}

	//Детальные вкладки
	set_detail_tab= function() {						
			$( ".detail_tab" ).tabs({
					collapsible: true,
					heightStyle: "fill",
					activate: function( event, ui ) {
						if ($('#' + ui.newTab.attr('aria-controls')).children('.grid_resizer_tabs').attr('need_update') == 'true') {
							$('#' + $('#' + ui.newTab.attr('aria-controls')).children('.grid_resizer_tabs').attr('for')).jqGrid().trigger('reloadGrid', true);
							$('#' + ui.newTab.attr('aria-controls')).children('.grid_resizer_tabs').attr('need_update','false');
						}
					}
			});
	}

	// Нужно для корретного закрытия вкладки, чтобы ничего в коде от нее не осталось
	$(document).on("click", "#tabs span.ui-icon-close", function() {
		CloseTab($( this ).parent().attr( "aria-controls" ));	
	});
				
	$(document).ready(function () {	

		// Исправление некорректных пробелов в меню для IE8+
		if ($.browser.msie) {
			$('.ui-menu-item a').append('&nbsp;&nbsp;&nbsp;&nbsp;');
		}
                
                main_menu_higth = $(".main_menu").height();
                doc_height = $(window).height();
		doc_width = $(window).width() - 2;
                
		// Если задано вскрытое меню, то прячем его
		if (hidden_menu) {						
			// Убиваем обычное меню:
			$("#Menubar").menubar( "destroy" );
			$(".main_menu").height(0).hide();
                        
                        main_menu_higth = 0;
			
                        // создаем кнопку
			$("#tabs").children(".ui-tabs-nav").append(
							$('<button>Меню</button>').attr({
								id:'menu_hidden_tab',
								style:'float: left;margin: 0px 5px 3px 0px;'
							}).button({icons: {primary: "ui-icon-newwin", secondary: 'ui-icon-triangle-1-s'},text: true}).click(function() {
								 var menu = $("#hidden_menubar").show().position({
										my: "left top",
										at: "left bottom",
										of: this
									  });
								 $( document ).one( "click", function() {
									menu.hide();
								  });
								  return false;
			}));
			$("body").append($("<ul />").attr({"id":"hidden_menubar","style":"float:left;"}).append($("#Menubar").children("li").unwrap()));
			
			$.each($("#hidden_menubar").children('li'), function() {
				$(this).children('a').append("<span class='ui-icon ui-icon-folder-collapsed'></span>").removeClass("ui-button-text-icon-secondary").children("b").removeAttr("style");								
				// Исправление некорректных пробелов в меню для IE8+
				if ($.browser.msie) {
					$(this).children('a').append("&nbsp;&nbsp;&nbsp;&nbsp;");
				}
			});
			$("#hidden_menubar").children('li:first').after('<li></li>');
			$("#hidden_menubar").hide().menu();							
		}		

		// Отрисовываем все элементы и формы на вкладке
		redraw_document();	
		
		// Сплеш сгрин для процесса загрузки страници
		// Дело в том что пока страница и скрипты непрогрузятся отображается как есть,
		// По этому мы ее скрываем чтобы небыло видно кишков
		$('#loading').fadeOut(300);
	});	

	$(window).resize(function () {
                $(".ui-tabs-panel").attr({need_redraw:true});
                main_menu_higth = $(".main_menu").height();
                doc_height = $(window).height();
		doc_width = $(window).width() - 2;
		redraw_document($(".ui-tabs-panel[aria-expanded='true']"));			
	});
        
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
                            obj.spinner();
                            if (obj.attr('row_type') == 'N') {
                                obj.spinner( "option", "culture", "ru-RU" )
                                         .spinner( "option", "numberFormat", "n2" )
                                         .spinner( "option", "step", "0.01" );
                            } else if (obj.attr('row_type') == 'NL') {
                                obj.spinner( "option", "culture", "ru-RU" )
                                         .spinner( "option", "numberFormat", "n7" )
                                         .spinner( "option", "step", "0.0000001" );
                            } else if (obj.attr('row_type') == 'C') {
                                  obj.spinner( "option", "culture", "ru-RU" )
                                         .spinner( "option", "numberFormat", "C" )
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
                            if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') != 'false') {
                                    obj.spinner( "option", "disabled" );
                                    obj.parent().parent().children('.ui-button').remove();	
                            }
					
		    break;
		    case 'P': // PASSWORD
			    obj.attr('value','');
		    break;
		    case 'B': // CHECKBOX			
                             obj.before('<label for="' + obj.attr('id') + '">Включено или выключено</label>')
                            .button({icons: { primary: 'ui-icon-check' }, text: false}).addClass(spl_tabid)
                            .click(function() {
                                    if (obj.attr('checked') != 'checked') {
                                                    obj.attr('checked','checked').button({icons: { primary: 'ui-icon-check' }});
                                            } else {
                                                    obj.removeAttr('checked').button({icons: { primary: 'ui-icon-bullet' }});
                                    }
                            });
                            obj.addClass('ui-helper-hidden-accessible');								
							
                            if (obj.attr('checked')) {
                                    obj.button({icons: { primary: 'ui-icon-check' }}).button("refresh");
                            } else {
                                    obj.button({icons: { primary: 'ui-icon-bullet' }}).button("refresh");						
                            }		
						
			    obj.removeAttr('style'); // Исправление неверной длины чекбокса							
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
                                                if(typeof(opts) == 'string' && val !== undefined)
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
                                    url:  'ajax.data.field.php?type=field&value_name=' + obj.attr('name'),
                                    datatype:'json',
                                    data: searilezed_elem,
                                    cache: false,
                                    type: 'POST',
                                       success: function(rets) {	
                                          obj.val(rets);
                                          update_table_elemnts(form_id,obj);
                                       }	  
                                   });	  
                                })
                            ).insertAfter(obj.parent().children(':last'));
                        $(this).width($(this).width() + 20);                    
                    }   
                    
                    // Если мы видим поля но не можем изменять
                    if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') != 'false') {
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
                                        if (obj.attr('checked')) {
                                                obj.button({icons: { primary: 'ui-icon-check' }}).button( "refresh" ).addClass('ui-state-active');
                                        } else {
                                                obj.button({icons: { primary: 'ui-icon-bullet' }}).button( "refresh" );						
                                        }					
				break;
				case 'D': // DATE
                                case 'DT': // DATE TIME
						obj.datepicker( "setDate", obj.val() );	
				break;
				case 'SB': // MULTISELECT
						if (!obj.attr('multiple')) {
						var txt = obj.find('option:selected').text();
							obj.parent().find('.ui-multiselect span:last').text(txt);
							obj.multiselect("widget").find("input:checked").removeAttr('checked').removeAttr('aria-selected').parent().removeClass('ui-state-active ui-state-hover');							
							$.each(obj.multiselect("widget").find("span:contains('" + txt + "')"), function() {
								if (txt != "" && $(this).text() == txt) {
								$(this).parent().addClass('ui-corner-all ui-state-active ui-state-hover')
									.children('input').attr('checked','checked').attr('aria-selected',true);
								}
							});
							if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') != 'false') {
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
	}
	
	// Диалог настроке и обработчики
	$("#param").dialog({
		autoOpen: false,
		modal: true,
		minWidth:450,
		closeOnEscape: true,
		resizable:false,
		buttons: {
			"Применить" : function() {	
				// Сохраняем данные	
				if ($.browser.msie) {
					$('#submit_settings').click();
				} else {															
					$.ajax({
							url: location.href + 'ajax.saveparams.php',
							datatype:'json',
							data: $("#settings_from").serialize(),
							cache: false,
							type: 'POST',
								success: function(data) {											
									$(location).prop('href',location.href);																	
							}	  
						});	
					
				}
				$( this ).dialog( "close" );
			},
			"Отмена":function() {
			$( this ).dialog( "close" );
			}
		},
		close:function() {
			$( this ).dialog( "close" );
		},
		open: function() {
				$('.ui-dialog-buttonpane').find('button:contains("Отмена")').button({icons: { primary: 'ui-icon-close'}});
				$('.ui-dialog-buttonpane').find('button:contains("Применить")').button({icons: { primary: 'ui-icon-disk'}});
				$(this).parent().css('z-index', 110).parent().children('.ui-widget-overlay').css('z-index', 105);
		}
	});				

	$("#about").dialog({
		autoOpen: false,
		modal: true,
		minWidth:650,
		closeOnEscape: true,
		resizable:false,                
		close:function() {
			$( this ).dialog( "close" );
		},
		open: function() {								
			$(this).parent().css('z-index', 110).parent().children('.ui-widget-overlay').css('z-index', 105); 
		}
	});	

					
	// Обработка мультиселекта и кнопки настроек
	$("#themeselector").multiselect({multiple: false, header: true, selectedList: 1});
	$("#width_enable").button({icons: { primary: "ui-icon-arrow-2-e-w" }}).click(function() {var btn = $("#width_enable");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});
	$("#editabled").button({icons: { primary: "ui-icon-lightbulb" }}).click(function() {var btn = $("#editabled");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});		
	$("#hide_menu").button({icons: { primary: "ui-icon-carat-2-e-w" }}).click(function() {var btn = $("#hide_menu");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});		
	$("#cache_enable").button({icons: { primary: "ui-icon-notice" }}).click(function() {var btn = $("#cache_enable");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});		
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
        });
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
	}

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
			symbol: "р."
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

    var rotateLeft = function(lValue, iShiftBits) {
        return (lValue << iShiftBits) | (lValue >>> (32 - iShiftBits));
    }
 
    var addUnsigned = function(lX, lY) {
        var lX4, lY4, lX8, lY8, lResult;
        lX8 = (lX & 0x80000000);
        lY8 = (lY & 0x80000000);
        lX4 = (lX & 0x40000000);
        lY4 = (lY & 0x40000000);
        lResult = (lX & 0x3FFFFFFF) + (lY & 0x3FFFFFFF);
        if (lX4 & lY4) return (lResult ^ 0x80000000 ^ lX8 ^ lY8);
        if (lX4 | lY4) {
            if (lResult & 0x40000000) return (lResult ^ 0xC0000000 ^ lX8 ^ lY8);
            else return (lResult ^ 0x40000000 ^ lX8 ^ lY8);
        } else {
            return (lResult ^ lX8 ^ lY8);
        }
    }
 
    var F = function(x, y, z) {
        return (x & y) | ((~ x) & z);
    }
 
    var G = function(x, y, z) {
        return (x & z) | (y & (~ z));
    }
 
    var H = function(x, y, z) {
        return (x ^ y ^ z);
    }
 
    var I = function(x, y, z) {
        return (y ^ (x | (~ z)));
    }
 
    var FF = function(a, b, c, d, x, s, ac) {
        a = addUnsigned(a, addUnsigned(addUnsigned(F(b, c, d), x), ac));
        return addUnsigned(rotateLeft(a, s), b);
    };
 
    var GG = function(a, b, c, d, x, s, ac) {
        a = addUnsigned(a, addUnsigned(addUnsigned(G(b, c, d), x), ac));
        return addUnsigned(rotateLeft(a, s), b);
    };
 
    var HH = function(a, b, c, d, x, s, ac) {
        a = addUnsigned(a, addUnsigned(addUnsigned(H(b, c, d), x), ac));
        return addUnsigned(rotateLeft(a, s), b);
    };
 
    var II = function(a, b, c, d, x, s, ac) {
        a = addUnsigned(a, addUnsigned(addUnsigned(I(b, c, d), x), ac));
        return addUnsigned(rotateLeft(a, s), b);
    };
 
    var convertToWordArray = function(string) {
        var lWordCount;
        var lMessageLength = string.length;
        var lNumberOfWordsTempOne = lMessageLength + 8;
        var lNumberOfWordsTempTwo = (lNumberOfWordsTempOne - (lNumberOfWordsTempOne % 64)) / 64;
        var lNumberOfWords = (lNumberOfWordsTempTwo + 1) * 16;
        var lWordArray = Array(lNumberOfWords - 1);
        var lBytePosition = 0;
        var lByteCount = 0;
        while (lByteCount < lMessageLength) {
            lWordCount = (lByteCount - (lByteCount % 4)) / 4;
            lBytePosition = (lByteCount % 4) * 8;
            lWordArray[lWordCount] = (lWordArray[lWordCount] | (string.charCodeAt(lByteCount) << lBytePosition));
            lByteCount++;
        }
        lWordCount = (lByteCount - (lByteCount % 4)) / 4;
        lBytePosition = (lByteCount % 4) * 8;
        lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80 << lBytePosition);
        lWordArray[lNumberOfWords - 2] = lMessageLength << 3;
        lWordArray[lNumberOfWords - 1] = lMessageLength >>> 29;
        return lWordArray;
    };
 
    var wordToHex = function(lValue) {
        var WordToHexValue = "", WordToHexValueTemp = "", lByte, lCount;
        for (lCount = 0; lCount <= 3; lCount++) {
            lByte = (lValue >>> (lCount * 8)) & 255;
            WordToHexValueTemp = "0" + lByte.toString(16);
            WordToHexValue = WordToHexValue + WordToHexValueTemp.substr(WordToHexValueTemp.length - 2, 2);
        }
        return WordToHexValue;
    };
 
    var uTF8Encode = function(string) {
        string = string.replace(/\x0d\x0a/g, "\x0a");
        var output = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                output += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                output += String.fromCharCode((c >> 6) | 192);
                output += String.fromCharCode((c & 63) | 128);
            } else {
                output += String.fromCharCode((c >> 12) | 224);
                output += String.fromCharCode(((c >> 6) & 63) | 128);
                output += String.fromCharCode((c & 63) | 128);
            }
        }
        return output;
    };
 
    $.extend({
        md5: function(string) {
            var x = Array();
            var k, AA, BB, CC, DD, a, b, c, d;
            var S11=7, S12=12, S13=17, S14=22;
            var S21=5, S22=9 , S23=14, S24=20;
            var S31=4, S32=11, S33=16, S34=23;
            var S41=6, S42=10, S43=15, S44=21;
            string = uTF8Encode(string);
            x = convertToWordArray(string);
            a = 0x67452301; b = 0xEFCDAB89; c = 0x98BADCFE; d = 0x10325476;
            for (k = 0; k < x.length; k += 16) {
                AA = a; BB = b; CC = c; DD = d;
                a = FF(a, b, c, d, x[k+0],  S11, 0xD76AA478);
                d = FF(d, a, b, c, x[k+1],  S12, 0xE8C7B756);
                c = FF(c, d, a, b, x[k+2],  S13, 0x242070DB);
                b = FF(b, c, d, a, x[k+3],  S14, 0xC1BDCEEE);
                a = FF(a, b, c, d, x[k+4],  S11, 0xF57C0FAF);
                d = FF(d, a, b, c, x[k+5],  S12, 0x4787C62A);
                c = FF(c, d, a, b, x[k+6],  S13, 0xA8304613);
                b = FF(b, c, d, a, x[k+7],  S14, 0xFD469501);
                a = FF(a, b, c, d, x[k+8],  S11, 0x698098D8);
                d = FF(d, a, b, c, x[k+9],  S12, 0x8B44F7AF);
                c = FF(c, d, a, b, x[k+10], S13, 0xFFFF5BB1);
                b = FF(b, c, d, a, x[k+11], S14, 0x895CD7BE);
                a = FF(a, b, c, d, x[k+12], S11, 0x6B901122);
                d = FF(d, a, b, c, x[k+13], S12, 0xFD987193);
                c = FF(c, d, a, b, x[k+14], S13, 0xA679438E);
                b = FF(b, c, d, a, x[k+15], S14, 0x49B40821);
                a = GG(a, b, c, d, x[k+1],  S21, 0xF61E2562);
                d = GG(d, a, b, c, x[k+6],  S22, 0xC040B340);
                c = GG(c, d, a, b, x[k+11], S23, 0x265E5A51);
                b = GG(b, c, d, a, x[k+0],  S24, 0xE9B6C7AA);
                a = GG(a, b, c, d, x[k+5],  S21, 0xD62F105D);
                d = GG(d, a, b, c, x[k+10], S22, 0x2441453);
                c = GG(c, d, a, b, x[k+15], S23, 0xD8A1E681);
                b = GG(b, c, d, a, x[k+4],  S24, 0xE7D3FBC8);
                a = GG(a, b, c, d, x[k+9],  S21, 0x21E1CDE6);
                d = GG(d, a, b, c, x[k+14], S22, 0xC33707D6);
                c = GG(c, d, a, b, x[k+3],  S23, 0xF4D50D87);
                b = GG(b, c, d, a, x[k+8],  S24, 0x455A14ED);
                a = GG(a, b, c, d, x[k+13], S21, 0xA9E3E905);
                d = GG(d, a, b, c, x[k+2],  S22, 0xFCEFA3F8);
                c = GG(c, d, a, b, x[k+7],  S23, 0x676F02D9);
                b = GG(b, c, d, a, x[k+12], S24, 0x8D2A4C8A);
                a = HH(a, b, c, d, x[k+5],  S31, 0xFFFA3942);
                d = HH(d, a, b, c, x[k+8],  S32, 0x8771F681);
                c = HH(c, d, a, b, x[k+11], S33, 0x6D9D6122);
                b = HH(b, c, d, a, x[k+14], S34, 0xFDE5380C);
                a = HH(a, b, c, d, x[k+1],  S31, 0xA4BEEA44);
                d = HH(d, a, b, c, x[k+4],  S32, 0x4BDECFA9);
                c = HH(c, d, a, b, x[k+7],  S33, 0xF6BB4B60);
                b = HH(b, c, d, a, x[k+10], S34, 0xBEBFBC70);
                a = HH(a, b, c, d, x[k+13], S31, 0x289B7EC6);
                d = HH(d, a, b, c, x[k+0],  S32, 0xEAA127FA);
                c = HH(c, d, a, b, x[k+3],  S33, 0xD4EF3085);
                b = HH(b, c, d, a, x[k+6],  S34, 0x4881D05);
                a = HH(a, b, c, d, x[k+9],  S31, 0xD9D4D039);
                d = HH(d, a, b, c, x[k+12], S32, 0xE6DB99E5);
                c = HH(c, d, a, b, x[k+15], S33, 0x1FA27CF8);
                b = HH(b, c, d, a, x[k+2],  S34, 0xC4AC5665);
                a = II(a, b, c, d, x[k+0],  S41, 0xF4292244);
                d = II(d, a, b, c, x[k+7],  S42, 0x432AFF97);
                c = II(c, d, a, b, x[k+14], S43, 0xAB9423A7);
                b = II(b, c, d, a, x[k+5],  S44, 0xFC93A039);
                a = II(a, b, c, d, x[k+12], S41, 0x655B59C3);
                d = II(d, a, b, c, x[k+3],  S42, 0x8F0CCC92);
                c = II(c, d, a, b, x[k+10], S43, 0xFFEFF47D);
                b = II(b, c, d, a, x[k+1],  S44, 0x85845DD1);
                a = II(a, b, c, d, x[k+8],  S41, 0x6FA87E4F);
                d = II(d, a, b, c, x[k+15], S42, 0xFE2CE6E0);
                c = II(c, d, a, b, x[k+6],  S43, 0xA3014314);
                b = II(b, c, d, a, x[k+13], S44, 0x4E0811A1);
                a = II(a, b, c, d, x[k+4],  S41, 0xF7537E82);
                d = II(d, a, b, c, x[k+11], S42, 0xBD3AF235);
                c = II(c, d, a, b, x[k+2],  S43, 0x2AD7D2BB);
                b = II(b, c, d, a, x[k+9],  S44, 0xEB86D391);
                a = addUnsigned(a, AA);
                b = addUnsigned(b, BB);
                c = addUnsigned(c, CC);
                d = addUnsigned(d, DD);
            }
            var tempValue = wordToHex(a) + wordToHex(b) + wordToHex(c) + wordToHex(d);
            return tempValue.toLowerCase();
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