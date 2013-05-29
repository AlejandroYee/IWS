/*
* Copyright (c) 2013 - Andrey Boomer - andrey.boomer at gmail.com
* icq: 454169
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
jQuery.uiBackCompat = false;
jQuery.jgrid.no_legacy_api = true;
jQuery.browser = {};
jQuery.browser.mozilla = /mozilla/.test(navigator.userAgent.toLowerCase()) && !/webkit/.test(navigator.userAgent.toLowerCase());
jQuery.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
jQuery.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
jQuery.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
				
var counttab = 1;	
var hidden_menu = false;	
			
$(function() {
	// ���� �������
	$( "#tabs" ).tabs({
			collapsible: false,
			heightStyle: "fill",
			activate: function( event, ui ) {
				redraw_document(ui.newPanel);
			}
	});

	custom_alert = function (output_msg, title_msg)
	{	
		is_modal = false;
		if (!title_msg) {
			title_msg = '������';
			is_modal = true;
			st = "ui-state-error";
		}
		if (!output_msg)
			output_msg = '';

		$("<div />").html(output_msg).dialog({
			title: title_msg,
			resizable: false,
			minWidth: 450,
			modal: is_modal,
			buttons: {
				"�������": function() 
				{
					$( this ).dialog( "close" );
				}
			},							
			open: function() {								
					$(this).parent().css('z-index', 9999).parent().children('.ui-widget-overlay').css('z-index', 105);
					if (st != "") {
						$(this).addClass(st);
					}
			}
		});
	}
					
	// �������� ���� ��� ��������
	$("#Menubar").menubar({
		menuIcon : true
	}).css({						
		'float': 'left',
		'text-align':'left',
		'display': 'block'
	});	

	// ������� ������ ������
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
	
	// ������� ���������� ������� � ����������� ����� ����
	SetTab = function (tabTitle,tabContentUrl,same_tab) {
		// ���� ������ ����, �� ������ ������������� ������
		if (same_tab != 'false') {
				var id = same_tab;								
				$('#'+id).empty();						
				if (tabTitle != '') {
					$('#ui-'+id).text(trim_text(tabTitle,40,3));
					$('#ui-'+id).prop("title",tabTitle);
				}								
			} else {							
				var id = 'tabs_' + counttab;								
				$( "#tabs").children(".ui-tabs-nav" ).append(
								$('<li />')
										.append($('<a />').attr({ href: '#' + id, title: tabTitle, id: 'ui-' + id })
														  .text(trim_text(tabTitle,40,3)))
										.append('<span class="ui-icon ui-icon-close" style="float:left"></span>')
					);
				$( "#tabs" ).append( $("<div />").attr({
										'id': id,
										'style': 'overflow:hide;width:' + ($(window).width() - 20) + 'px'
									}) );
		}
		$('#'+id).append("<div class='loader_tab' style='overflow:hide'><div>");												
		tabContentUrl = tabContentUrl+"&tabid="+id;
		
		$( "#tabs" ).tabs("refresh");
		
		if (same_tab == 'false') {
			$("#tabs").tabs("option", "active",$('#tabs').children('.ui-tabs-nav li').length - 1);
		}						
		// ������ ������ �� �������� ����������� ������� �� �����						
		$.ajax({
			  url: tabContentUrl,							  
			  type: 'GET',
			  success: function(data){				
				if($(data).find("div[window_login='logon']").length == 0) {
					$('#'+id).empty().css('text-align','left').append(data);
					redraw_document($(".ui-tabs-panel[aria-expanded='true']"));				
				} else {		 		
					// ��� ������� �������� �����������. �������� ��������
					$('html').empty().append(data);
				}
			  }	  
			});
		counttab++;							
	}					

	// ��������� �������
	CloseTab = function (id_tab) {
		$("#ui-" + id_tab).parent().closest( "li" ).remove();
		$('#' + id_tab).remove();
		$( "#tabs" ).tabs( "refresh" );
		$('.ui-tabs-panel').css('overflow','hidden');
		redraw_document();
	}

	// ������ ������� ���� ����:
	$(".help_button").button({icons: {primary: 'ui-icon-help'},text: true}).attr('style','float: right;').appendTo("#tabs .ui-tabs-nav").click(function() {
				SetTab('������ ����������� �������',$(this).attr('url'),'false'); 
	});
								
	// ������ ��������
	$("#tabs").children(".ui-tabs-nav").append(
			$('<button>������� ��� �������</button>').attr({
				id:'close_all_tab',
				style:'float: right;margin: 0px 5px 3px 0px;'
			}).button({icons: {primary: 'ui-icon-closethick'},text: false}).click(function() {
				$.each( $('#tabs .ui-tabs-nav li') , function() {
				CloseTab($(this).attr('aria-controls'));
			});
	}));								
		
	// ��������� ���� � �������:
	redraw_document = function (id_tab) {
		var doc_height = $(window).height();
		var doc_width = $(window).width() - 2;						
		var main_menu = $(".main_menu").height();
		
		// �������� �������� ������ ������:											
		$("#tabs").tabs().height( doc_height - main_menu - 10);
		$("#tabs .ui-tabs-panel").height(doc_height - main_menu - 10).width(doc_width - 20);
		
		// ��� ������� ������ �������
		$(".about_tabs").offset({ top: doc_height - 50});
		$(".about_tabs_ver").offset({ top: doc_height - 25});
		
		// ��� ���������� ��������� ��� ����� ���� ������� ������������� �������. (� ����� � ���) ��� ��� �
		// ������ ����� ��� ��� ����� ���� ��������
		if (typeof(id_tab) === 'undefined')  id_tab = $('body');
		
		id_tab.find(".navigation_header").height(30);

		//  �������� �������
		$(".dialog_jqgrid_overlay").height(doc_height - main_menu - 85).width(doc_width - 24).offset({ top: main_menu + 30 + 50, left: 12 });
		
		// ���������� ����������		
		id_tab.find(".tab_main_content").height(doc_height - main_menu - 90).width(doc_width - 20);
		
		// ������ ������ ���������
		id_tab.css('overflow','hidden');
		
		// ������:
		id_tab.find(".help_content").height(doc_height - main_menu - 90).width(doc_width - 20)
				.children('.ui-accordion-header').width(doc_width - 65)
				.parent().children('.ui-accordion-content').height(doc_height - main_menu - 150 - (($(".ui-accordion-header").height() * 2.05)* ($(".help_content .ui-accordion-header").length - 1))	).width(doc_width - 87);
		
		// ����� �����	
		$.each( id_tab.find('.grid_resizer'), function() {
			var percent = $(this).attr('percent');							
			var doc_width_grid = doc_width - 27;
			
			if (percent < 90 && percent > 10 ) {
					var doc_height_grid = (doc_height - main_menu - 93)/100 * percent;
				} else {
					var doc_height_grid = doc_height - main_menu - 93;
			}
			
			// ���������� ��� ����� ���� ������ ������:
			if ($(this).children('.ui-jqgrid').find('.ui-search-toolbar').css("display") != 'none' && $(this).attr('form_type') != "TREE_GRID_FORM_MASTER" && $(this).attr('form_type') != "TREE_GRID_FORM_DETAIL"  && $(this).attr('form_type') != "TREE_GRID_FORM" ) {
					var coeffd_filtr = 102;
				} else {
					var coeffd_filtr = 75;
			}	
			$(this).height(doc_height_grid).width(doc_width_grid);
			$(this).height(doc_height_grid).children('.ui-jqgrid').height(doc_height_grid - 2).width(doc_width_grid)
										.children('.ui-jqgrid-pager').height(25).width(doc_width_grid)
							   .parent().children('.ui-jqgrid-view').height(doc_height_grid - 27).width(doc_width_grid)
										.children('.ui-jqgrid-hdiv').width(doc_width_grid)
							   .parent().children('.ui-jqgrid-bdiv').height(doc_height_grid - coeffd_filtr).width(doc_width_grid);
				   
		});
		
		// ����� ������� �� ��������	
		$.each( id_tab.find('.grid_resizer_tabs'), function() {
			var doc_width_grid = doc_width - 48;
			var percent = $(this).attr('percent') - (33/(doc_height/100));
			
			var doc_height_grid = (doc_height - main_menu - 93)/100 * percent - 23;
			
			// ���������� ��� ����� ���� ������ ������:
			if ($(this).children('.ui-jqgrid').find('.ui-search-toolbar').css("display") != 'none' && $(this).attr('form_type') != "TREE_GRID_FORM_MASTER" && $(this).attr('form_type') != "TREE_GRID_FORM_DETAIL"  && $(this).attr('form_type') != "TREE_GRID_FORM" ) {
					var coeffd_filtr = 82;
				} else {
					var coeffd_filtr = 55;
			}	
			$(this).height(doc_height_grid).width(doc_width_grid);
			$(this).height(doc_height_grid).children('.ui-jqgrid').height(doc_height_grid - 2).width(doc_width_grid)
										.children('.ui-jqgrid-pager').height(25).width(doc_width_grid)
							   .parent().children('.ui-jqgrid-view').height(doc_height_grid - 27).width(doc_width_grid)
										.children('.ui-jqgrid-hdiv').width(doc_width_grid)
							   .parent().children('.ui-jqgrid-bdiv').height(doc_height_grid - coeffd_filtr).width(doc_width_grid);
				   
		});
		
		// �������� �� �������� �������:
		if ($("#tabs").children(".ui-tabs-nav").children("li").length > 6) {
				$.each($('.navigation_header'), function() {											
					if ($(this).children('.alert_button').length != 1) {
						$(this).append("<div class='alert_button ui-state-error ui-corner-all' style='float:right;width:100px;margin: 6px 15px 5px 5px;' title='������� ����� 7 ������� ������������," +
							"��� ����� ������ ��������� ������ �������. �� ����������� �������� ���� ��� ��������� �������.'><span class='ui-icon ui-icon-alert' style='float:left'></span>��������!</div>");
					}
				});
			} else {
				$.each($('.navigation_header .alert_button'), function() {											
					$(this).remove();
				});
		}
	}
	
	replace_select_opt_group = function (object) {
		if (typeof(object) === 'undefined') object = $('body');
		// �������������� �������, ����� ��������� ��� ������, ������� ������ ������:
		$.each($(object).find("select option[value='GROUP_START']"), function() {		
			$(this).replaceWith("<optgroup label='" + $(this).text() + "' >");
		});	
		// ������ ������ ������� � ���������� ������ � ��������������� ��
		$.each($(object).find("select option[value='GROUP_END']"), function() {
			var object 			= $(this).parent();
			var	selected_obj 	= object.children('option:selected');	// ���������� ��������� �������
			
			if (typeof(object.html()) !== 'undefined') {
				var select_text	= $(object.html().split('</optgroup>').join('')
												   .split('<option value="GROUP_END"></option>').join('</optgroup>')
												   .split('<option role="option" value="GROUP_END"></option>').join('</optgroup>'));
				select_text.children('option[value="' + selected_obj.attr('value') + '"]').attr('selected','selected');	
				object.empty().append(select_text);
			}
		});	
		
	}
	
	// ���������� �������� � ����� (����������� ������ � ����������)
	auto_width_grid = function (grid) {
		// �������� �������� � ������ ������ � ������� � �����
		var grid_header = $('#gview_' + grid + ' .ui-jqgrid-hdiv .ui-jqgrid-hbox table tr:first th:visible');
		var grid_hcontent = $('#gview_' + grid + ' .ui-jqgrid-bdiv div table tr:first td:visible');
		
		// ��������� ����� �� ������� ���������� (�.�. ����� �������� �� ����� ������ ��� ����� ��������)
		var grid_width_old = 0;
		var has_r_num	= 0;	
		var count_element = 0;
		
		$.each(grid_header, function() {
			if ($(this).attr('id') == grid + "_rn") {
				has_r_num = $(this).width(); // ������� r_num �� �������
			}
			grid_width_old = grid_width_old + $(this).width();
			count_element = count_element + 1;
		});
		
		var grid_width = $('#' + grid).parent().width(); // ����� �� ��������� ����������
		
		if (grid_width_old < grid_width) {
			// ��������������� ������ � ��������� �� �������� ������ ������ ��������
			var coeff = (grid_width/(grid_width_old)); // ���������� ����������
			$.each(grid_header, function() {
				var w_tmp = $(this).width();
				// ��������� � ���������
				if ($(this).attr('id') != grid + "_rn") {	
					$(this).width(w_tmp * coeff);
				}
			});
			$.each(grid_hcontent, function() {
				var w_tmp = $(this).width();
				// ��������� � ���������
				if ($(this).width() != has_r_num) {	
					$(this).width(w_tmp * coeff);
				}
			});
		}					
	}

	// ����������� ��������
	set_resizers = function() {
		// �����������
		$('.has_resize_control').resizable({
			distance: 30,					
			handles: 's',	
			resize: function( event, ui ) {						
					// ��������� �������� � �������������� ���
					var main_menu = $(".main_menu").height();
					var hh = $(window).height() - main_menu - 93;	
					var hgrid = 100 + ((ui.size.height - hh)/Math.abs(hh) * 100);
					var lgrid = 100 - hgrid;
					
					if (hgrid > 10 && hgrid < 95 && lgrid > 10 && lgrid < 95) {
						$(this).attr("percent",hgrid).parent().children("div[form_type='GRID_FORM_DETAIL']").attr('percent', lgrid);
						$(this).attr("percent",hgrid).parent().children("div[form_type='TREE_GRID_FORM_DETAIL']").attr('percent', lgrid);
						$(this).attr("percent",hgrid).parent().children("div[form_type='TABED_GRID_FORM']").attr('percent', lgrid).children('.ui-tabs-panel').children('.grid_resizer_tabs').attr('percent', lgrid);
						$(this).attr("percent",hgrid).parent().children("div[form_type='GRID_FORM']").attr('percent', lgrid);
					}									
			},
			create: function( event, ui ) {
				// ������� ������:
				$(this).children('.ui-resizable-handle').height(5.3).attr('align','center').append(
						$('<div />').addClass('ui-widget-header ui-state-hover ui-corner-all').height(2).width(150));
			}
		});
	}

	//��������� �������
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

	// ����� ��� ���������� �������� �������, ����� ������ � ���� �� ��� �� ��������
	$(document).on("click", "#tabs span.ui-icon-close", function() {
		CloseTab($( this ).parent().attr( "aria-controls" ));	
	});
				
	// ��� ��� �������������� ������� ������ ������� (����� ����� �� ��� ���������)
	$(document).ready(function () {	

		// ����������� ������������ �������� � ���� ��� IE8+
		if ($.browser.msie) {
			$('.ui-menu-item a').append('&nbsp;&nbsp;&nbsp;&nbsp;');
		}
		
		// ���� ������ �������� ����, �� ������ ���
		if (hidden_menu) {						
			// ������� ������� ����:
			$("#Menubar").menubar( "destroy" );
			$(".main_menu").height(0).hide();
			
			// ������� ������
			$("#tabs").children(".ui-tabs-nav").append(
							$('<button>����</button>').attr({
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
				// ����������� ������������ �������� � ���� ��� IE8+
				if ($.browser.msie) {
					$(this).children('a').append("&nbsp;&nbsp;&nbsp;&nbsp;");
				}
			});
			$("#hidden_menubar").children('li:first').after('<li></li>');
			$("#hidden_menubar").hide().menu();							
		}		

		// ������������ ��� �������� � ����� �� �������
		redraw_document();	
		
		// ����� ����� ��� �������� �������� ��������
		// ���� � ��� ��� ���� �������� � ������� ������������� ������������ ��� ����,
		// �� ����� �� �� �������� ����� ������ ����� ������
		$('#loading').fadeOut(300);
		
		// � ������ ������ ������, ����������.
		if ( $.browser.msie && parseInt(navigator.userAgent.substring (navigator.userAgent.indexOf ( "MSIE " )+5, navigator.userAgent.indexOf (".", navigator.userAgent.indexOf ( "MSIE " ) ))) < 8 ) {							
			$(document).empty();
			alert("� ���������, ���� ������ �������� ������ �� ��������������, ����������, ���� ���������� � ��������������!");
		}
		
	});	

	$(window).resize(function () {
		redraw_document($(".ui-tabs-panel[aria-expanded='true']"));			
	});

	// �������� ��������:
	check_form = function(formid) {
		var data_ok = true;
				$.each(formid.find("input[is_requred='true']"), function() {
					if ($.trim($(this).val()) == "") {									
						$(this).addClass('ui-state-error');
						$('#clone_' + $(this).attr('id')).parent().addClass('ui-state-error');
						$(this).parent().children('.ui-button').addClass('ui-state-error');	
						data_ok = false;
				}
			});
			$.each(formid.find("select[is_requred='true']"), function() {																			
				if ($.trim($(this).val()) == "") {
					$(this).addClass('ui-state-error');																				
					$(this).parent().children('button').addClass('ui-state-error');	
					data_ok = false;
				}
			});		
			$.each(formid.find("textarea[is_requred='true']"), function() {																			
					if ($.trim($(this).val()) == "") {
					$(this).addClass('ui-state-error');		
					$(this).parent().children('.codemirror').addClass('ui-state-error');																				
					data_ok = false;
				}
			});																						
		if (data_ok) {
				return true; 
			} else {								
				custom_alert("���������� ��������� ��� ���������� ����!");
				return false;
		}
	}
	
	// �������� ��������� � ���������� �� ��������
	create_from_table_elemnts = function (formid) {
		$.each(formid.find("input, select, textarea"), function() {
			var obj = $(this);
			obj.width(obj.attr('w'));
					
			switch (obj.attr('i_type')) {
			
				 case 'I': // INTEGER
					var obj_clone = $(this).clone().attr('id','clone_' + obj.attr('id')).removeAttr('name');
					obj_clone.insertBefore(obj.hide());
					obj_clone.spinner({
						change: function( event, ui ) {
								obj.val($(this).attr('aria-valuenow'));	
						}
					}).removeClass('ui-widget-content ui-corner-all')
					.calculator({
						useThemeRoller: true, showAnim:'', showOn:'',
						onButton: function(label, value, inst) { 
								obj_clone.spinner( 'value', value );
						}
					});	
					$($('<button>������� �����������</button>').button({icons: {primary: 'ui-icon-calculator'}, text: false})
							.click(function( event ) {
									obj_clone.calculator('show');
							})
					).insertAfter(obj_clone.parent());
				break;
				
				case 'N': // NUMBER
					var obj_clone = $(this).clone().attr('id','clone_' + obj.attr('id')).removeAttr('name');
					obj_clone.insertBefore(obj.hide());
					obj_clone.spinner({
						numberFormat: 'n2',
						culture: 'ru-RU',
						step: 0.01,
						change: function( event, ui ) {
								obj.val($(this).attr('aria-valuenow'));												
						}
					}).removeClass('ui-widget-content ui-corner-all')
					.calculator({
						useThemeRoller: true, showAnim:'', showOn:'',layout: $.calculator.scientificLayout, 
						onButton: function(label, value, inst) { 
								obj_clone.spinner( 'value', value );
						}
					});	
					$($('<button>������� �����������</button>').button({icons: {primary: 'ui-icon-calculator'}, text: false})
							.click(function( event ) {
									obj_clone.calculator('show');
							})
					).insertAfter(obj_clone.parent());
				break;
				
				case 'NL': // NUMBER LOOOONG
					var obj_clone = $(this).clone().attr('id','clone_' + obj.attr('id')).removeAttr('name');
					obj_clone.insertBefore(obj.hide());
					obj_clone.spinner({
						numberFormat: 'n7',
						culture: 'ru-RU',
						step: 0.01,
						change: function( event, ui ) {
								obj.val($(this).attr('aria-valuenow'));												
						}
					}).removeClass('ui-widget-content ui-corner-all')
					.calculator({
						useThemeRoller: true, showAnim:'', showOn:'',layout: $.calculator.scientificLayout, 
						onButton: function(label, value, inst) { 
								obj_clone.spinner( 'value', value );
						}
					});	
					$($('<button>������� �����������</button>').button({icons: {primary: 'ui-icon-calculator'}, text: false})
							.click(function( event ) {
									obj_clone.calculator('show');
							})
					).insertAfter(obj_clone.parent());
				break;
				
				case 'C': // CURENSYS
					var obj_clone = $(this).clone().attr('id','clone_' + obj.attr('id')).removeAttr('name');
					obj_clone.insertBefore(obj.hide());
					obj_clone.spinner({
						numberFormat: 'C',
						culture: 'ru-RU',
						step: 0.01,
						change: function( event, ui ) {
								obj.val($(this).attr('aria-valuenow'));												
						}
					}).removeClass('ui-widget-content ui-corner-all')
					.calculator({
						useThemeRoller: true, showAnim:'', showOn:'',
						onButton: function(label, value, inst) { 
								obj_clone.spinner( 'value', value );
						}
					});	
					$($('<button>������� �����������</button>').button({icons: {primary: 'ui-icon-calculator'}, text: false})
							.click(function( event ) {
									obj_clone.calculator('show');
							})
					).insertAfter(obj_clone.parent());
				break;
				
				case 'P': // PASSWORD
					obj.attr('value','');
				break;
				
				case 'B': // CHECKBOX
							 obj.before('<label for="' + obj.attr('id') + '">�������� ��� ���������</label>')
								.button({icons: { primary: 'ui-icon-check' }, text: false})
								.click(function() {
									if (obj.attr('checked') != 'checked') {
											obj.attr('checked','checked').button({icons: { primary: 'ui-icon-check' }});
										} else {
											obj.removeAttr('checked').button({icons: { primary: 'ui-icon-bullet' }});
									}
								});
								
								if (obj.attr('checked') == 'checked') {
									obj.attr('checked','checked').button({icons: { primary: 'ui-icon-check' }});
								} else {
									obj.removeAttr('checked').button({icons: { primary: 'ui-icon-bullet' }});						
								}									
				break;
				
				case 'D': // DATE
					obj.datepicker({
							showOn: 'button',
							showWeek: true,
							numberOfMonths: num_of_mounth,
							changeYear: true,
							firstDay: 1
							})
							.parent().children('.ui-datepicker-trigger')
							.button({
								icons: {primary: 'ui-icon-calendar'},
								text: false
							});
				break;
				
				case 'DT': // DATE TIME
					obj.datetimepicker({
							showWeek: true,
							numberOfMonths: num_of_mounth,
							changeYear: true,
							firstDay: 1,
							timeFormat :'HH:mm:ss',
							showOn: 'button',
							hourGrid: 4,
							minuteGrid: 10
							})
							.parent().children('.ui-datepicker-trigger')
							.button({
								icons: {primary: 'ui-icon-calendar'},
								text: false
							});
				break;		
				
				case 'SB': // MULTISELECT
					obj.multiselect({
							multiple: (typeof(obj.attr('multiple')) === "undefined")?false:true,
							minWidth: (obj.width() < 255)?255:obj.width(),
							header: true,
							selectedList: obj.attr('h')
						}).multiselectfilter();
				break;
				case 'M': // MULTILINE - CODEMIRROR					
					obj.removeAttr('id').before('<div id="' + obj.attr('name')+ '"></label>');					
					var editor = ace.edit(obj.attr('name'));
					var h = (obj.attr('h')*12 > 50)?obj.attr('h')*12:50;
					editor.getSession().setMode("ace/mode/pgsql");
					editor.getSession().setValue(obj.val());
						editor.getSession().on('change', function(){
						  obj.val(editor.getSession().getValue());
						});
					obj.hide();
					editor.setHighlightActiveLine(false);
					editor.renderer.setShowGutter(false);
					editor.setShowPrintMargin(false);
					$('#' + obj.attr('name')).width(obj.attr('w')).height(h).addClass('FormElement ui-widget-content ui-corner-all').css('margin-left','5px')
					.resizable({						  
							resize: function(event, ui) {
									$('#' + obj.attr('name')).height($(this).height()).width($(this).width());
									editor.resize();
							}
						});
					editor.resize();				
				break;
			} // end type def
			
			// ���� �� ����� ���� �� �� ����� ��������
			if (typeof(obj.attr('show_disabled')) !== "undefined" && obj.attr('show_disabled') != 'false') {
					obj.attr({'name':null,'disabled':'disabled','class':'FormElement ui-widget-content ui-corner-all ui-state-disabled'});
			}
		});
	
	}
	
	// ������ �������� � �����������
	$("#param").dialog({
		autoOpen: false,
		modal: true,
		minWidth:450,
		closeOnEscape: true,
		resizable:false,
		buttons: {
			"���������" : function() {	
				// ��������� ������	
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
			"������":function() {
			$( this ).dialog( "close" );
			}
		},
		close:function() {
			$( this ).dialog( "close" );
		},
		open: function() {
				$('.ui-dialog-buttonpane').find('button:contains("������")').button({icons: { primary: 'ui-icon-close'}});
				$('.ui-dialog-buttonpane').find('button:contains("���������")').button({icons: { primary: 'ui-icon-disk'}});
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

					
	// ��������� ������������� � ������ ��������
	$("#themeselector").multiselect({multiple: false, header: false, selectedList: 1});
	$("#width_enable").button({icons: { primary: "ui-icon-arrow-2-e-w" }}).click(function() {var btn = $("#width_enable");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});
	$("#page_enable").button({icons: { primary: "ui-icon-script" }}).click(function() {var btn = $("#page_enable");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});
	$("#multiselect").button({icons: { primary: "ui-icon-grip-solid-horizontal" }}).click(function() {var btn = $("#multiselect");if (btn.attr("checked") != "checked") {btn.attr("checked","checked");} else {btn.removeAttr("checked");}});
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
	
	// ����� ��� ������������ ������ � ������ � ����� 	
	get_select_values_grid = function (gridname,value_name, parent_value_id) {
		$.ajax({
				url: 'ajax.data.select.php?value_name=' + value_name + '&parent_id=' + parent_value_id,
				datatype :'json',
				cache: false,
				type: 'GET',
					success: function(data) {											
						$('#' + gridname).jqGrid('setColProp',value_name,{ editoptions: { value: data }, searchoptions: {value: ':;'+ data}});
				}	  
			});	
	}

Globalize.addCultureInfo( "ru-RU", "default", {
	name: "ru-RU",
	englishName: "Russian (Russia)",
	nativeName: "������� (������)",
	language: "ru",
	numberFormat: {
		",": "",
		".": ",",
		negativeInfinity: "-�������������",
		positiveInfinity: "�������������",
		percent: {
			pattern: ["-n%","n%"],
			",": "",
			".": ","
		},
		currency: {
			pattern: ["-n$","n$"],
			",": "",
			".": ",",
			symbol: "�."
		}
	},
	calendars: {
		standard: {
			"/": ".",
			firstDay: 1,
			days: {
				names: ["�����������","�����������","�������","�����","�������","�������","�������"],
				namesAbbr: ["��","��","��","��","��","��","��"],
				namesShort: ["��","��","��","��","��","��","��"]
			},
			months: {
				names: ["������","�������","����","������","���","����","����","������","��������","�������","������","�������",""],
				namesAbbr: ["���","���","���","���","���","���","���","���","���","���","���","���",""]
			},
			monthsGenitive: {
				names: ["������","�������","�����","������","���","����","����","�������","��������","�������","������","�������",""],
				namesAbbr: ["���","���","���","���","���","���","���","���","���","���","���","���",""]
			},
			AM: null,
			PM: null,
			patterns: {
				d: "dd.MM.yyyy",
				D: "d MMMM yyyy '�.'",
				t: "H:mm",
				T: "H:mm:ss",
				f: "d MMMM yyyy '�.' H:mm",
				F: "d MMMM yyyy '�.' H:mm:ss",
				Y: "MMMM yyyy"
			}
		}
	}
});
	
$.calculator.regional['ru'] = {
	decimalChar: ',',
	buttonText: '...', buttonStatus: '������� �����������',
	closeText: '�������', closeStatus: '������� �����������',
	useText: 'OK', useStatus: '������������ ������� �������� � ����',
	eraseText: '�����', eraseStatus: '������� ��������',
	backspaceText: '<-', backspaceStatus: '������� ��������� �����',
	clearErrorText: 'CE', clearErrorStatus: '������� ��������� �����',
	clearText: '�', clearStatus: '��������',
	memClearText: 'MC', memClearStatus: '�������� ������',
	memRecallText: 'MR', memRecallStatus: '�������� �� ������',
	memStoreText: 'MS', memStoreStatus: '��������� � ������',
	memAddText: 'M+', memAddStatus: '�������� � ������',
	memSubtractText: 'M-', memSubtractStatus: '������� �� ������',
	base2Text: '���', base2Status: '��������',
	base8Text: '����', base8Status: '�����������',
	base10Text: '���', base10Status: '����������',
	base16Text: '����', base16Status: '�����������������',
	degreesText: '����', degreesStatus: '�������',
	radiansText: '���', radiansStatus: '�������',
	isRTL: false
};

$.calculator.setDefaults($.calculator.regional['ru']);
									
$.extend($.ech.multiselectfilter.prototype.options, {
	label: "������:",
	placeholder: "������� �����"
});

$.extend($.ech.multiselect.prototype.options, {
    height: 250,
    minWidth: 350,
	checkAllText: '�������� ���',
	uncheckAllText: '����� ������� �� ����',
	noneSelectedText: '�������� �� ������',
	selectedText: '������� #'
});

// ������� ��� �������� �����:
$.extend($.jgrid,{	
	viewModal : function (selector,o){
		o = $.extend({
			toTop: true,
			overlay: 10,
			modal: true,
			overlayClass : 'ui-widget-overlay',
			onShow: $.jgrid.showModal,
			onHide: $.jgrid.closeModal,
			gbox: '',
			jqm : true,
			jqM : true
		}, o || {});			
			$(selector).dialog( "open" );				
			var s_width = $(selector)[0].scrollWidth;
			var doc_height = $(window).height();
			var doc_width = $(window).width() - 2;
			var main_menu = $(".main_menu").height();
			var tab_nav = $(".ui-tabs-nav").height();
			
			if ($(selector).attr('selector_type') == "true") {
				$(selector).find('.EditTable').css('table-layout','auto');
				$(selector).find('.FormData td').removeClass('ui-widget-content');	
			}
			
			if ($(selector).attr('selector_type') == "true" && s_width < 550) {
					var view_conf = 1.5;								
				} else {
					var view_conf = 1;
			}
			if (s_width > 0 ) {
				$(selector).dialog( "option", "width", s_width * view_conf + 25);
			}
			
			if ($(selector).parent().parent().attr('role') == "tabpanel") {
					var to_object = $(selector).parent().parent().parent().parent();
				} else {
					var to_object = $(selector).parent().parent();				
			}			
			$($("<div />").attr({
				'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all',
				'style':'position:absolute;'
			})).prependTo(to_object);
			
			if ($.browser.msie) {		
					$(".dialog_jqgrid_overlay").height(doc_height - main_menu - 90).width(doc_width - 24).offset({ top: main_menu + tab_nav + 45, left: 12 });
				} else {
					$(".dialog_jqgrid_overlay").height(doc_height - main_menu - 90).width(doc_width - 24).offset({ top: main_menu + tab_nav + 50, left: 12 });
		    }
		
	},
	hideModal : function (selector,o) {
		o = $.extend({jqm : true, gb :''}, o || {});
			if ($(selector).parent().parent().attr('role') == "tabpanel") {
					var to_object = $(selector).parent().parent().parent().parent();
				} else {
					var to_object = $(selector).parent().parent();				
			}
			
		to_object.children('.ui-widget-overlay').remove();		
		$(selector).dialog( "close" );		
	},
	createModal : function(aIDs, content, p, insertSelector, posSelector, appendsel, css) {
			p = $.extend(true, {}, $.jgrid.jqModal || {}, p);
			var self = this, i, buttons_set = [];
			
			// �������� ���������� ������ ���� ����
			$('#' + aIDs.themodal).dialog('destroy').remove();
			
			// ������� �������
			$('body').find('.jqgrid-overlay').remove();
			
			// ��������� ��������
			if(p.jqModal === undefined) {p.jqModal = true; }
			if(p.resize === undefined) {p.resize=true;}
			
			if (aIDs.themodal.indexOf('viewmod', 0) > -1) {
				var view_dialog = true;
			} else {
				var view_dialog = false;
			}			
			
			var folder_self = $(insertSelector).parent().parent().parent();	
			$(folder_self).append($('<div />').attr({
							'id': aIDs.themodal,
							'selector_type': view_dialog,
							'class':'FormElement ui-jqdialog-content',
							'title': p.caption.replace(/<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,"")
						}).append($(content)));
			$('#' + aIDs.themodal +' div').children('form').removeAttr('style').css('text-align','left')
								  .parent().children('table').hide();
			$('#' + aIDs.themodal).children('table').hide();
						  
			if (p.viewPagerButtons  == true) {				
					buttons_set[buttons_set.length] = {text: '����������', icons: { primary: "ui-icon-arrowthick-1-w" }, showText : false,
														click: function() {
															$( this ).find('#pData').click();
														} 
								};
		
			
			
					buttons_set[buttons_set.length] = {text: '���������', icons: { primary: "ui-icon-arrowthick-1-e" }, showText : false,
														click: function() {
															$( this ).find('#nData').click();
														} 
								};
			
			};
			
			if ($(content).find('#sData') !== 'undefined') {
					buttons_set[buttons_set.length] = {text: p.bSubmit?p.bSubmit:'false', icons: { primary: p._savedData?"ui-icon-disk":"ui-icon-trash" },
														click: function() {
														  // ���������
														  if (typeof(p._savedData) !== 'undefined')	$( this ).find('#sData').click();
														  
														  // �������
														  if (typeof(p.delData) !== 'undefined') $( this ).find('#dData').click();
														  $( this ).dialog( "close" );
														} 
								};
			};
			if ($(content).find('#cData') !== 'undefined') {
				if (p.bCancel !== '' || p.bClose !== '') 
					buttons_set[buttons_set.length] = {text: p.bCancel?p.bCancel:p.bClose, icons: { primary: "ui-icon-closethick" },
														click: function() {
															$( this ).find('#cData').click();
															$( this ).find('#eData').click();
															$( this ).dialog( "close" );
														} 
								};
			};
			
			if (typeof(p.buttons) !== 'undefined') buttons_set = null;		
			
			replace_select_opt_group();
			create_from_table_elemnts($('#' + aIDs.themodal).find('.FormGrid'));
			// ������� ��� ��� ������
			$('#' + aIDs.themodal).dialog({
										autoOpen: false,
										appendTo: folder_self,
										modal: false,
										minWidth:250,
										closeOnEscape: p.closeOnEscape,
										resizable: p.resize,	
										buttons: buttons_set,
										close:function() {
												$( this ).find('#cData').click();
												$( this ).find('#eData').click();
												$( this ).dialog( "close" );
										},
										open: function() {
											if (p.viewPagerButtons  == true) {											
												// ������ ���� ���� ��� ��������
												$('.ui-dialog-buttonpane').find('button:contains("false")').hide();
											}
										}
									});
	}
});

$.jgrid.extend({
	filterToolbar : function(p){
		p = $.extend({
			autosearch: true,
			searchOnEnter : true,
			beforeSearch: null,
			afterSearch: null,
			beforeClear: null,
			afterClear: null,
			searchurl : '',
			stringResult: false,
			groupOp: 'AND',
			defaultSearch : "bw"
		},p  || {});
		return this.each(function(){
			var $t = this;
			var ext_name = $(this).parent().parent().parent().prop("id");
			var has_search = false;
			if(this.ftoolbar) { return; }			
			var triggerToolbar = function() {
				var sdata={}, j=0, v, nm, sopt={}, so;
				$.each($t.p.colModel,function(){
					nm = this.index || this.name;
					so  = (this.searchoptions && this.searchoptions.sopt) ? this.searchoptions.sopt[0] : this.stype=='select'?  'eq' : p.defaultSearch;
					v = $("#gs_" + ext_name + "_" + $.jgrid.jqID(this.name), (this.frozen===true && $t.p.frozenColumns === true) ?  $t.grid.fhDiv : $t.grid.hDiv).val();	
					has_search = true;
					if(v) {	
						if ($("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop("class") == " ui-icon  ui-icon-close") 
								$("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).attr({ 'class': " ui-icon  ui-icon-radio-off", title: "������", value: "LIKE"});
						sdata[nm] = $("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).attr("value") + ">" + $("#gs_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop("value"); 
						sopt[nm] = so;
						j++;
					} else {
						try {
							delete $t.p.postData[nm];
						} catch (z) {}
					}
				});
				var sd =  j>0 ? true : false;
				if(p.stringResult === true || $t.p.datatype == "local") {
					var ruleGroup = "{\"groupOp\":\"" + p.groupOp + "\",\"rules\":[";
					var gi=0;
					$.each(sdata,function(i,n){
						if (gi > 0) {ruleGroup += ",";}
						ruleGroup += "{\"field\":\"" + i + "\",";
						ruleGroup += "\"op\":\"" + sopt[i] + "\",";
						n+="";
						ruleGroup += "\"data\":\"" + n.replace(/\\/g,'\\\\').replace(/\"/g,'\\"') + "\"}";
						gi++;
					});
					ruleGroup += "]}";
					$.extend($t.p.postData,{filters:ruleGroup});
					$.each(['searchField', 'searchString', 'searchOper'], function(i, n){
						if($t.p.postData.hasOwnProperty(n)) { delete $t.p.postData[n];}
					});
				} else {
					$.extend($t.p.postData,sdata);
				}
				var saveurl;
				if($t.p.searchurl) {
					saveurl = $t.p.url;
					$($t).jqGrid("setGridParam",{url:$t.p.searchurl});
				}
				var bsr = $($t).triggerHandler("jqGridToolbarBeforeSearch") === 'stop' ? true : false;
				if(!bsr && $.isFunction(p.beforeSearch)){bsr = p.beforeSearch.call($t);}
				if(!bsr) { $($t).jqGrid("setGridParam",{search:sd}).trigger("reloadGrid",[{page:1}]); }
				if(saveurl) {$($t).jqGrid("setGridParam",{url:saveurl});}
				$($t).triggerHandler("jqGridToolbarAfterSearch");
				if($.isFunction(p.afterSearch)){p.afterSearch.call($t);}
			};
			var clearToolbar = function(trigger){
				var sdata={}, j=0, nm;
				trigger = (typeof trigger != 'boolean') ? true : trigger;
				$.each($t.p.colModel,function(){
					var v;
					if(this.searchoptions && this.searchoptions.defaultValue !== undefined) { v = this.searchoptions.defaultValue; }					
					nm = this.index || this.name;
					$("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop({ 'class': " ui-icon  ui-icon-close", title: "��������������", value: "NONE"});
					$("#gs_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop({value: ""});
					switch (this.stype) {
						case 'select' :
							$("#gs_"+$.jgrid.jqID(this.name)+" option",(this.frozen===true && $t.p.frozenColumns === true) ?  $t.grid.fhDiv : $t.grid.hDiv).each(function (i){
								if(i===0) { this.selected = true; }
								if ($(this).val() == v) {
									this.selected = true;
									return false;
								}
							});
							if ( v !== undefined ) {
								// post the key and not the text
								sdata[nm] = v;
								j++;
							} else {
								try {
									delete $t.p.postData[nm];
								} catch(e) {}
							}
							break;
						case 'text':
							$("#gs_"+$.jgrid.jqID(this.name),(this.frozen===true && $t.p.frozenColumns === true) ?  $t.grid.fhDiv : $t.grid.hDiv).val(v);
							if(v !== undefined) {
								sdata[nm] = v;
								j++;
							} else {
								try {
									delete $t.p.postData[nm];
								} catch (y){}
							}
							break;
					}
				});
				var sd =  j>0 ? true : false;
				if(p.stringResult === true || $t.p.datatype == "local") {
					var ruleGroup = "{\"groupOp\":\"" + p.groupOp + "\",\"rules\":[";
					var gi=0;
					$.each(sdata,function(i,n){
						if (gi > 0) {ruleGroup += ",";}
						ruleGroup += "{\"field\":\"" + i + "\",";
						ruleGroup += "\"op\":\"" + "eq" + "\",";
						n+="";
						ruleGroup += "\"data\":\"" + n.replace(/\\/g,'\\\\').replace(/\"/g,'\\"') + "\"}";
						gi++;
					});
					ruleGroup += "]}";
					$.extend($t.p.postData,{filters:ruleGroup});
					$.each(['searchField', 'searchString', 'searchOper'], function(i, n){
						if($t.p.postData.hasOwnProperty(n)) { delete $t.p.postData[n];}
					});
				} else {
					$.extend($t.p.postData,sdata);
				}
				var saveurl;
				if($t.p.searchurl) {
					saveurl = $t.p.url;
					$($t).jqGrid("setGridParam",{url:$t.p.searchurl});
				}
				var bcv = $($t).triggerHandler("jqGridToolbarBeforeClear") === 'stop' ? true : false;
				if(!bcv && $.isFunction(p.beforeClear)){bcv = p.beforeClear.call($t);}
				if(!bcv) {
					if(trigger) {
						$($t).jqGrid("setGridParam",{search:sd}).trigger("reloadGrid",[{page:1}]);
					}
				}
				if(saveurl) {$($t).jqGrid("setGridParam",{url:saveurl});}
				$($t).triggerHandler("jqGridToolbarAfterClear");
				if($.isFunction(p.afterClear)){p.afterClear();}
			};
			var toggleToolbar = function(){
				var trow = $("tr.ui-search-toolbar",$t.grid.hDiv),
				// ���������� �������� � ��������������� ����
				trow2 = $t.p.frozenColumns === true ?  $("tr.ui-search-toolbar",$t.grid.fhDiv) : false;
				if(trow.css("display")=='none') { 
					trow.show();
					$("#" + ext_name).children('.ui-jqgrid-bdiv').height($("#" + ext_name).children('.ui-jqgrid-bdiv').height() - 27);
					has_search = false;
					if(trow2) {
						trow2.show();
					}
				} else { 
					trow.hide();
					$("#" + ext_name).children('.ui-jqgrid-bdiv').height($("#" + ext_name).children('.ui-jqgrid-bdiv').height() + 27);
					if (has_search) clearToolbar();
					if(trow2) {
						trow2.hide();
					}
				}
			};
			// create the row
			function bindEvents(selector, events) {
				var jElem = $(selector);
				if (jElem[0]) {
					jQuery.each(events, function() {
						if (this.data !== undefined) {
							jElem.bind(this.type, this.data, this.fn);
						} else {
							jElem.bind(this.type, this.fn);
						}
					});
				}
			}
			var tr = $("<tr class='ui-search-toolbar' role='rowheader'></tr>");
			var timeoutHnd;
			$.each($t.p.colModel,function(){
				var cm=this, thd , th, soptions,surl,self;
				th = $("<th role='columnheader' class='ui-state-default ui-th-column ui-th-"+$t.p.direction+"'></th>");
				thd = $("<div style='text-align:left;position:relative;vertical-align:middle'></div>");				
				if(this.hidden===true) { $(th).css("display","none");}
				this.search = this.search === false ? false : true;
				if(typeof cm.formatter == 'undefined' ) {cm.formatter='text';}
				soptions = $.extend({},this.searchoptions || {});
				if(this.search){
					switch (cm.formatter)
					{
					case "select":
						surl = this.surl || soptions.dataUrl;
						if(surl) {
							// data returned should have already constructed html select
							// primitive jQuery load
							self = thd;
							$.ajax($.extend({
								url: surl,
								dataType: "html",
								success: function(res) {
									if(soptions.buildSelect !== undefined) {
										var d = soptions.buildSelect(res);
										if (d) { $(self).append(d); }
									} else {
										$(self).append(res);
									}
									if(soptions.defaultValue !== undefined) { $("select",self).val(soptions.defaultValue); }
									$("select",self).prop({name:cm.index || cm.name, id: "gs_" + ext_name + "_" + cm.name});
									$("select",self).css('float','left').css('padding-left','15px');
									$("select",self).prop('class','ui-state-default');
									if(soptions.prop) {$("select",self).prop(soptions.prop);}
									$("select",self).css({width: "100%"});									
									// preserve autoserch
									if(soptions.dataInit !== undefined) { soptions.dataInit($("select",self)[0]); }
									if(soptions.dataEvents !== undefined) { bindEvents($("select",self)[0],soptions.dataEvents); }
									if(p.autosearch===true){
										$("select",self).change(function(){
											triggerToolbar();
											return false;
										});
									}
									res=null;
								}
							}, $.jgrid.ajaxOptions, $t.p.ajaxSelectOptions || {} ));
						} else {
							var oSv, sep, delim;
							if(cm.searchoptions) {
								oSv = cm.searchoptions.value === undefined ? "" : cm.searchoptions.value;
								sep = cm.searchoptions.separator === undefined ? ":" : cm.searchoptions.separator;
								delim = cm.searchoptions.delimiter === undefined ? ";" : cm.searchoptions.delimiter;
							} else if(cm.editoptions) {
								oSv = cm.editoptions.value === undefined ? "" : cm.editoptions.value;
								sep = cm.editoptions.separator === undefined ? ":" : cm.editoptions.separator;
								delim = cm.editoptions.delimiter === undefined ? ";" : cm.editoptions.delimiter;
							}
							if (oSv) {	
								var elem = document.createElement("select");
								elem.style.width = "100%";
								$(elem).prop({name:cm.index || cm.name, id: "gs_" + ext_name + "_" + cm.name});																								
								var so, sv, ov;
								if(typeof oSv === "string") {
									so = oSv.split(delim);
									for(var k=0; k<so.length;k++){
										sv = so[k].split(sep);
										ov = document.createElement("option");
										ov.value = sv[0]; ov.innerHTML = sv[1];
										elem.appendChild(ov);
									}
								} else if(typeof oSv === "object" ) {
									for ( var key in oSv) {
										if(oSv.hasOwnProperty(key)) {
											ov = document.createElement("option");
											ov.value = key; ov.innerHTML = oSv[key];
											elem.appendChild(ov);
										}
									}
								}
								if(soptions.defaultValue !== undefined) { $(elem).val(soptions.defaultValue); }
								if(soptions.prop) {$(elem).prop(soptions.prop);}
								if(soptions.dataInit !== undefined) { soptions.dataInit(elem); }
								if(soptions.dataEvents !== undefined) { bindEvents(elem, soptions.dataEvents); }								
								$(thd).append(elem);							
								replace_select_opt_group($(thd));
								$(thd).children('select').multiselect({
									multiple: cm.editoptions.multiple === undefined ? false :  cm.editoptions.multiple,
									minWidth: cm.width,
									header:false,
									selectedList: cm.editoptions.size === undefined ? 1 :  cm.editoptions.size
									}).css('padding','0.3em');
								if(p.autosearch===true){
									$(elem).change(function(){
										triggerToolbar();
										return false;
									});
								}
							}
						}
						break;
					case 'checkbox':
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";						
						$(thd).append("<input type='checkbox' class='ui-widget ui-widget-content ui-corner-all' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' value=''/>");						
						$(thd).css('text-align','center'); 
						$(thd).children('input').before("<label for='gs_"+ ext_name + "_" + cm.name+"'>�������� ��� ���������</label>")
										        .button({icons: { primary: "ui-icon-check" },text: false})
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						if(p.autosearch===true){
							$("input",thd).click(function() {							
								if ($("input",thd).prop("value") == "1" ) {
										$("input",thd).prop({value: "0"});										
								} else {
										$("input",thd).prop({value: "1"});
								}
								triggerToolbar();
							});
						}
						break;
					case 'date':
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";
						$(thd).append("<input type='text' style='width:95%;padding-left:15px;' class='FormElement ui-widget ui-widget-content ui-corner-all' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' value='"+df+"'/>");						
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						$("input",thd).datetimepicker({ changeYear: true, firstDay: 1, timeFormat :"HH:mm:ss"});
						if(p.autosearch===true){
							if(p.searchOnEnter) {
								$("input",thd).keypress(function(e){
									var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;														
									if(key == 13){
										triggerToolbar();
										return false;
									}
									return this;
								});
							} else {
								$("input",thd).keydown(function(e){
									var key = e.which;														
									switch (key) {
										case 13:
											return false;
										case 9 :
										case 16:
										case 37:
										case 38:
										case 39:
										case 40:
										case 27:
											break;
										default :
											if(timeoutHnd) { clearTimeout(timeoutHnd); }
											timeoutHnd = setTimeout(function(){triggerToolbar();},500);
									}
								});
							}
						}
						break;
					case 'number':
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";						
						$(thd).append("<input type='text' class='FormElement' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' style='float:left;width:93%;' value='"+df+"'/>");						
						$(thd).children('input').spinner({numberFormat: 'n2', culture: 'ru-RU', step: 1 }).css({'width':'95%','padding-left':'15px'});
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}							
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						if(p.autosearch===true){
							if(p.searchOnEnter) {
								$("input",thd).keypress(function(e){
									var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;															
									if(key == 13){
										triggerToolbar();
										return false;
									}
									return this;
								});
							} else {
								$("input",thd).keydown(function(e){
									var key = e.which;														
									switch (key) {
										case 13:
											return false;
										case 9 :
										case 16:
										case 37:
										case 38:
										case 39:
										case 40:
										case 27:
											break;
										default :
											if(timeoutHnd) { clearTimeout(timeoutHnd); }
											timeoutHnd = setTimeout(function(){triggerToolbar();},500);
									}
								});
							}
						}
						break;
					default:
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";						
						$(thd).append("<input type='text' style='width:95%;padding-left:15px;' class='FormElement ui-widget ui-widget-content ui-corner-all' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' value='"+df+"'/>");						
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}						
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						if(p.autosearch===true){
							if(p.searchOnEnter) {
								$("input",thd).keypress(function(e){
									var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;															
									if(key == 13){
										triggerToolbar();
										return false;
									}
									return this;
								});
							} else {
								$("input",thd).keydown(function(e){
									var key = e.which;														
									switch (key) {
										case 13:
											return false;
										case 9 :
										case 16:
										case 37:
										case 38:
										case 39:
										case 40:
										case 27:
											break;
										default :
											if(timeoutHnd) { clearTimeout(timeoutHnd); }
											timeoutHnd = setTimeout(function(){triggerToolbar();},500);
									}
								});
							}
						}
						break;
					}
				}
				
				// ��������� ������ � ���� ��� �������� ���� ������
				if ((cm.name !== 'rn') && ( cm.formatter !== "checkbox") && ( cm.formatter !== "select")) {					
					thd.append($("<span />").attr({
							'class':' ui-icon  ui-icon-close',
							id:'search_' + ext_name + '_' + cm.name,
							style: 'float:left;top:3px;position: absolute; cursor: pointer;',
							title:'��������������',
							value:'NONE'
						}));
						
						$("span.ui-icon",thd).click(function() {
							if ($(this).prop("class") == " ui-icon  ui-icon-close") { $(this).attr({ 'class': " ui-icon  ui-icon-notice", title: "�������", value: "NOT"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-notice") { $(this).attr({ 'class': " ui-icon  ui-icon-carat-1-e", title: "������", value: "MORE"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-carat-1-e") { $(this).attr({ 'class': " ui-icon  ui-icon-carat-1-w", title: "������", value: "MINI"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-carat-1-w") { $(this).attr({ 'class': " ui-icon  ui-icon-grip-solid-horizontal", title: "�����", value: "EQUAL"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-grip-solid-horizontal") { $(this).attr({ 'class': " ui-icon  ui-icon-radio-off", title: "������", value: "LIKE"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-radio-off") $(this).attr({ 'class': " ui-icon  ui-icon-close", title: "��������������", value: "NONE"});
							
					});
				}
				$(th).append(thd);
				$(tr).append(th);
			});
			$("table thead",$t.grid.hDiv).append(tr);
			this.ftoolbar = true;
			this.triggerToolbar = triggerToolbar;
			this.clearToolbar = clearToolbar;
			this.toggleToolbar = toggleToolbar;
			// �������� �� ��������� ������ ������
			toggleToolbar();
		});
		
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
});
