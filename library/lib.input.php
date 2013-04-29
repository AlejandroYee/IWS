<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
class INPUT extends DATA_FORM {
var $db_conn, $id_mm_fr, $id_mm, $pageid;

	// Описываем элементы данных
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	function data_element($field_text, $field_name,$name, $requred) {
			$output = "";
			$field_name_short = strtolower($field_name."_".$this->pageid);
			$query_d = $this->db_conn->sql_execute("select to_char(".$field_text.", 'dd.mm.yyyy') def_date from dual");
			
						while ($this-> db_conn-> sql_fetch($query_d))  {					
							$output .= "
							<p><label for='".$field_name_short."' >".FullTrim($name)."</label>
								<input type='text' class='date_".$this->pageid." FormElement ui-widget-content ui-corner-all' is_requred='".$requred."' id='".$field_name_short."' name='".$field_name."' value='".$this -> return_sql($query_d, "DEF_DATE")."' />
								<script type=\"text/javascript\">
									$(function() {
									$('#".$field_name_short."').datepicker({
										showOn: 'button',
										showWeek: true,
										numberOfMonths: ".$this -> db_conn -> get_param_view("num_mounth").",
										changeYear: true,
										firstDay: 1
									})
									.parent().children('.ui-datepicker-trigger')
									.button({
										icons: {primary: 'ui-icon-calendar'},
										text: false
									});	
									});
									</script>
							</p>
							";
						}
	return $output;	
	}

	function data_time_element($field_text, $field_name,$name, $requred) {
			$output = "";
			$field_name_short = strtolower($field_name."_".$this->pageid);
			$query_d = $this->db_conn->sql_execute("select to_char(".$field_text.", 'dd.mm.yyyy') def_date from dual");
						while ($this-> db_conn-> sql_fetch($query_d))  {					
							$output .= "
							<p><label for='".$field_name_short."' >".FullTrim($name)."</label>
								<input type='text' class='date_time_".$this->pageid." FormElement ui-widget-content ui-corner-all' is_requred='".$requred."' id='".$field_name_short."' name='".$field_name."' value='".$this -> return_sql($query_d, "DEF_DATE")."' />
									<script type=\"text/javascript\">
									$(function() { 
									$('#".$field_name_short."').datetimepicker({
										showOn: 'button',
										showWeek: true,
										numberOfMonths: ".$this -> db_conn -> get_param_view("num_mounth").",
										changeYear: true,
										firstDay: 1,
										timeFormat :'HH:mm:ss',
										hourGrid: 4,minuteGrid: 10
									})
									.parent().children('.ui-datepicker-trigger')
									.button({
										icons: {primary: 'ui-icon-calendar'},
										text: false
									});
									});
									</script>
							</p>
							";
						}
	return $output;	
	}
	
	function string_element($field_text,$field_name,$name,$width, $requred) {
		$field_name_short = strtolower($field_name."_".$this->pageid);
			if (!empty($field_text) and (strpos($field_text,"input")  == 0)) {			
				$query_d = $this->db_conn->sql_execute("select (".$field_text.") str_val from dual");	
				while ($this-> db_conn-> sql_fetch($query_d))  $str_val = $this -> return_sql($query_d, "STR_VAL");
			} else {
				$str_val = "";
			}
				
		return "<p><label for='".$field_name_short."' >".FullTrim($name)."</label>
					<input type='text' class='FormElement ui-widget-content ui-corner-all' is_requred='".$requred."' id='".$field_name_short."' size='".round($width/8)."' name='".$field_name."' value='".$str_val."' />
			</p>
			";
	}
	
	function textarea_element($field_text,$field_name,$name,$width,$count_element, $requred) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
		return "<p style='text-align :left;'><label for='".$field_name_short."' >".FullTrim($name)."</label>
					  <textarea id='".$field_name_short."' rows='".$count_elemen."' is_requred='".$requred."' name='".$field_name."' role='textbox' multiline='true' class='FormElement ui-widget-content ui-corner-all'></textarea>
					</p>
					<script type=\"text/javascript\">
					$(function() { 					
					var _".$field_name_short." =  CodeMirror.fromTextArea($('#".$field_name_short."')[0],{								
								lineNumbers: false,
								mode: 'text/x-plsql'								
								});
								_".$field_name_short.".setSize('".$width."', '".($count_element * 18)."');								
								setTimeout(function(){_".$field_name_short.".refresh();}, 500);								
								
								$('#".$field_name_short."').parent().children('.CodeMirror').removeClass()
										.addClass('FormElement ui-widget-content ui-corner-all CodeMirror cm-s-default')
										.resizable({						  
										  resize: function(event, ui) {
											ui.element.children('.CodeMirror-scroll').height($(this).height());
											ui.element.children('.CodeMirror-scroll').width($(this).width());
											_".$field_name_short.".refresh();
										  }
								});
								_".$field_name_short.".on('blur', function(cm) {
									$('#".$field_name_short."')[0].value = cm.getValue();
								});	
					});
					</script>
				   ";
		
	}
	function select_element($field_text,$field_name,$name,$width,$count_element, $requred) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
		if ($count_element <= 1) {
						$output .= "<script type=\"text/javascript\">	
							$(function() {  
								$(\"#".$field_name."-".$this->pageid."\").multiselect({multiple: false,  header:true, selectedList: 1}).multiselectfilter();;
							});
							</script>";
						$output .= "<p>
								<label for='".$field_name."' >".FullTrim($name)."</label>
								<select id=\"".$field_name."-".$this->pageid."\" is_requred='".$requred."' name=\"".$field_name."\" size=".$count_element." style=\"width: ".$width."px;\">";
					} else {
						$output .= "<script type=\"text/javascript\">	
							$(function() {  
								$(\"#".$field_name."-".$this->pageid."\").multiselect({multiple: true, header:true, noneSelectedText: 'Ничего не выбрано', selectedList: 1}).multiselectfilter();;
							});
							</script>";
						$output .= "<p>
								<label for='".$field_name."' >".FullTrim($name)."</label>
								<select multiple id=\"".$field_name."-".$this->pageid."\" is_requred='".$requred."' name=\"".$field_name."[]\" style=\"width: ".$width."px;\">";
					}
					
						$query_d = $this -> db_conn->sql_execute($field_text);
						while ($this-> db_conn-> sql_fetch($query_d)) 
								$output .= "<option ".$this -> return_sql($query_d, "FL_SELECTED")." value=".$this -> return_sql($query_d, "ID").">".$this -> return_sql($query_d, "NAME")."<br>";
					$output .= "</select></p>";
	return $output;
	}
	
	// all numbers
	function number_element($field_text,$field_name,$name,$num_culture,$requred) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
					$query_d = $this->db_conn->sql_execute("select (".$field_text.") def_num from dual");
						while ($this-> db_conn-> sql_fetch($query_d)) $value = $this -> return_sql($query_d, "DEF_NUM");
						$output .= "<p><label for=\"".$field_name_short."\">".FullTrim($name)."</label><input type='text'  class='FormElement ui-widget-content ui-corner-all' id='".$field_name_short."' value='".$value."' name='".$field_name."' /></p>";
						$output .= "<script type=\"text/javascript\">	
							$(function() {  
								var self_element_".$field_name_short." = $('#".$field_name_short."');							
								self_element_".$field_name_short.".parent().append(self_element_".$field_name_short.".clone().attr({
												id:'clone_".$field_name_short."',
												name:'clone_".$field_name_short."'
											}));
								$('#clone_".$field_name_short."').spinner({	".$num_culture."										
												change: function( event, ui ) {
													self_element_".$field_name_short." = $('#".$field_name_short."').val($(this).attr('aria-valuenow'));												
												}
											}).removeClass('ui-widget-content ui-corner-all');		
								
							    $('#clone_".$field_name_short."').calculator({
												useThemeRoller: true,
												showAnim:'',
												layout: $.calculator.scientificLayout, 
												showOn:'',
												onButton: function(label, value, inst) { 
														$('#clone_".$field_name_short."').spinner( 'value', value );
												}
												});	
								$($('<button>Открыть калькулятор</button>').button({icons: {primary: 'ui-icon-calculator'}, text: false}).click(function( event ) {
												$('#clone_".$field_name_short."').calculator('show');
								})).insertAfter($('#clone_".$field_name_short."').parent());	
								
								self_element_".$field_name_short.".hide().attr('is_requred','".$requred."');
							});
							</script>";
					
	return $output;
	}
	// link or email
	function link_element($field_text,$field_name,$name) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
						$output .= "<p><a href='".$field_text."'>".FullTrim($name)."</a></p>";						
	return $output;
	}
	
	// Checkbox
	function checkbox_element($field_text,$field_name,$name,$requred) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
						$output .= "<p><label for=\"".$field_name_short."\">".FullTrim($name)."</label><input type='checkbox'  is_requred='".$requred."' class='FormElement ui-widget-content ui-corner-all' id='".$field_name_short."' name='".$field_name."' /></p>";
						$output .= "<script type=\"text/javascript\">	
							$(function() {  
								$('#".$field_name_short."').button({icons: { primary: 'ui-icon-bullet' },text: true})
															.click(function() {
																var btn".$field_name_short." = $('#".$field_name_short."');
																	if (btn".$field_name_short.".attr(\"checked\") != \"checked\") {
																			btn".$field_name_short.".attr(\"checked\",\"checked\").val('on')
																			.button({icons: { primary: 'ui-icon-check' }});
																		} else {
																			btn".$field_name_short.".removeAttr(\"checked\").val('')
																			.button({icons: { primary: 'ui-icon-bullet' }});
																	}
															});
								if ( $('#".$field_name_short."').attr('checked') == 'checked') {
									$('#".$field_name_short."').val('on').button({icons: { primary: 'ui-icon-check' }});
								} else {
									$('#".$field_name_short."').val('').button({icons: { primary: 'ui-icon-bullet' }});						
								}		
							});
							</script>";
					
	return $output;
	}
	
	static function get_about() {
		return "Входные и выходные данные, сохранение данных в базу";
	}
	
	// Создаем форму запроса данных, и при этом блокируем таблицу с результатом
	//------------------------------------------------------------------------------------------------------------------------------------------------
	function Create_input_form($c_count) {
	$show_form=0;
		// Получаем имя родительского грида
		$query_tmp = $this->db_conn->sql_execute("select ft.name, t.id_wb_mm_form id from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and ft.name like 'GRID%' and rownum = 1 order by t.num");
		while ($this-> db_conn-> sql_fetch($query_tmp)) $gridname = strtolower($this -> return_sql($query_tmp, "NAME")."_".$this -> return_sql($query_tmp, "ID")."_".$this ->pageid);

		$query_tmp = $this->db_conn->sql_execute("select substr(t.name, 1, decode(instr(t.name, '@')-1, -1, length(t.name), instr(t.name, '@')-1)) name,
                       substr(t.name, decode(instr(t.name, '@')+1, 1, null, instr(t.name, '@')+1)) help_name, t.field_txt, t.field_name, decode(nvl(t.is_requred,0), 0,'false', 'true') is_requred, t.field_type,
                       nvl(t.count_element, 1) count_element, nvl(t.width, decode(t.field_type, 'D', 46, 300)) width from ".DB_USER_NAME.".wb_form_field t
					   where t.id_wb_mm_form = ".$this->id_mm_fr." order by t.num");	
					   
	$output = "<div id='param-".$this->pageid."' title='Укажите параметры:'>
	<form id='form_parameters_".$this->pageid."' >";  
	
    while ($this-> db_conn-> sql_fetch($query_tmp)) {
		$show_form++; // счетчик элементов
		switch (trim($this -> return_sql($query_tmp, "FIELD_TYPE"))) {			
			// Поле ввода ДАТА
			case "D": 
				$output .= $this -> data_element(
										$this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);			
			break;
			// Поле ввода ДАТА и ВРЕМЯ
			case "DT":
				$output .= $this -> data_time_element(
										$this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);	
			break;
			
			// Поле ввода ВЫБОРКА STRING
			case "S":			
				$output .= $this -> string_element(
										$this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "WIDTH"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);	
			break;	
			
			// Поле ввода ВЫБОРКА SELECT
			case "SB":	
				$output .= $this -> select_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "WIDTH"),
										$this -> return_sql($query_tmp, "COUNT_ELEMENT"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			case "M":	
				$output .= $this -> textarea_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "WIDTH"),
										$this -> return_sql($query_tmp, "COUNT_ELEMENT"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			// new
			case "B":	
				$output .= $this -> checkbox_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			case "C":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"numberFormat: 'C',	culture: 'ru-RU', step: 1,",
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			case "I":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"",
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			case "N":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"numberFormat: 'n2', culture: 'ru-RU', step: 0.01,",
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			case "NL":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"numberFormat: 'n7', culture: 'ru-RU', step: 0.01,",
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;			
			case "A":	
				$output .= $this -> link_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME")
										);				
			break;
			case "E":	
				$output .= $this -> link_element("mailto:".$this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME")
										);				
			break;	
			default:
					$output .= "<p>".$this -> return_sql($query_tmp, "FIELD_TXT")."</p>";
			break;
		}
	}
	
	
	$output .= "	
    </form>
	</div>
	<script type=\"text/javascript\">
				$(function() { 			
					$('#param-".$this->pageid."').dialog({
						autoOpen: false,
						modal: true,						
						minWidth: 450,
						minHeight: 50,	
						closeOnEscape: true,
						resizable:true,
						appendTo: $('#".$this->pageid." .tab_main_content'),
						buttons: [	
							 {
								text: 'Сохранить',
								click: function () {
								if (check_form($('#form_parameters_".$this->pageid."'))) {
									var qString = $('#form_parameters_".$this->pageid."').serialize();	
									$('#show_parameters-".$this->pageid."').button('option','disabled',true);
									$( this ).dialog( 'close' );	
									";									
				if ($c_count < 2 ) {
						$output .= "
									$('#".$this->pageid." .tab_main_content .CaptionTD').remove();
									$('#".$this->pageid." .tab_main_content').append('<div class=\"ui-widget CaptionTD\" style=\"height: 80%;width: 99%;vertical-align: middle;\"><h2>Данные обрабатываются ... </h2></div>');
									$.get('ajax.saveparams.php?&id_mm_fr=".$this->id_mm_fr."&' + qString, function(data) {
										$('#".$this->pageid." .tab_main_content .CaptionTD').remove();
										$('#".$this->pageid." .tab_main_content').append('<div class=\"ui-widget CaptionTD\" style=\"height: 80%;width: 99%;vertical-align: middle;\"><h2>Данные успешно обработаны!</h2></div>');
										$('#ui-".$this->pageid."').parent().effect('pulsate', {}, 2000);
										$('#show_parameters-".$this->pageid."').button('option','disabled',false);
										if (data.length > 20) {
														custom_alert(data);
										}
									});
									";
				} else if (($c_count > 1) and isset($gridname)) {	$output .= "
									$.get('ajax.saveparams.php?&id_mm_fr=".$this->id_mm_fr."&' + qString, function(data) {if (data.length > 20) {custom_alert(data);}});
									
									$('#".$gridname."').jqGrid('setGridParam',{datatype:'json'});									
									if (data_".$this -> pageid."_loaded > 0) {
										$.each( $('#".$this->pageid." .tab_main_content .chart_data_".$this -> pageid."') , function() {
											var self = $(this);					
											$.get(self.attr('url'),function(data) {													
													document.getElementById(self.attr('name')).SetVariable('_root.dataURL','');
													document.getElementById(self.attr('name')).SetVariable('_root.isNewData','1');
													document.getElementById(self.attr('name')).SetVariable('_root.newData',data);
													document.getElementById(self.attr('name')).TGotoLabel('/', 'JavaScriptHandler'); 													
											});	
										});
									}
									data_".$this -> pageid."_loaded = 1;
									$('#show_parameters-".$this->pageid."').button('option','disabled',false);
									$('#".$gridname."').trigger('reloadGrid');
									";
				} else {
									$output .= "
									$.get('ajax.saveparams.php?&id_mm_fr=".$this->id_mm_fr."&' + qString, function(data) {if (data.length > 20) {custom_alert(data);}});
									if (data_".$this -> pageid."_loaded > 0) {
										$.each( $('#".$this->pageid." .tab_main_content .chart_data_".$this -> pageid."') , function() {
											var self = $(this);					
											$.get(self.attr('url'),function(data) {													
													document.getElementById(self.attr('name')).SetVariable('_root.dataURL','');
													document.getElementById(self.attr('name')).SetVariable('_root.isNewData','1');
													document.getElementById(self.attr('name')).SetVariable('_root.newData',data);
													document.getElementById(self.attr('name')).TGotoLabel('/', 'JavaScriptHandler'); 													
											});	
										});
									}
									$('#show_parameters-".$this->pageid."').button('option','disabled',false);
									data_".$this -> pageid."_loaded = 1;
									";				
				}
				$output .= "	 }
								}
											
							},
							{
								text: 'Отмена',
								click: function () {
									$(this).dialog('close');
								}
							}						
						],
						close:function() {
							$( this ).dialog( 'close' );
						},
						open: function() {
								$('.ui-dialog-buttonpane').find('button:contains(\"Отмена\")').button({icons: { primary: 'ui-icon-close'}});
								$('.ui-dialog-buttonpane').find('button:contains(\"Сохранить\")').button({icons: { primary: 'ui-icon-disk'}});
								$(this).parent().parent().children('.ui-widget-overlay').addClass('dialog_jqgrid_overlay ui-corner-all');
								redraw_document();
						}
					});
					$('#show_parameters-".$this->pageid."').button({
					     icons: {
							primary: 'ui-icon-info'
						}})
						.button()
						.click(function() {
						$( '#param-".$this->pageid."').dialog('open');
					});					
				
				setTimeout(function() {
						$( '#param-".$this->pageid."').dialog('open');						
					}, 500);
				});
	</script>	
	<button id=\"show_parameters-".$this->pageid."\"  style=\"float: right;margin:0 5px 0 0;\">Задать параметры</button>";	
	if (empty($show_form)) $output = ""; // Если форма пустая, то просто обнуляем содержимое вывода
	return $output;	
	}
	
	// Запрос и обработка данных  формы (визард)
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	function Creare_wizard_from () {
	$output ="";
	$inputs_form = "";
	$query_tmp = $this->db_conn->sql_execute("select ft.name, t.id_wb_mm_form id from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and ft.name like 'GRID%' and rownum = 1 order by t.num");
		while ($this-> db_conn-> sql_fetch($query_tmp)) $gridname = strtolower($this -> return_sql($query_tmp, "NAME")."_".$this -> return_sql($query_tmp, "ID")."_".$this ->pageid);
	$query_tmp = $this->db_conn->sql_execute("select ft.name, t.id_wb_mm_form id from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and ft.name like 'CHARTS%' and rownum = 1 order by t.num");
		while ($this-> db_conn-> sql_fetch($query_tmp)) $chartname = strtolower($this -> return_sql($query_tmp, "NAME")."_".$this -> return_sql($query_tmp, "ID")."_".$this ->pageid);
	// Собираем все формы в одну кучу
	$query_tmp = $this->db_conn->sql_execute("select  t.*, ft.name as form_type from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and  (ft.name like 'INPUT_%' or ft.name = 'WIZARD_FORM') order by t.num");
	while ($this-> db_conn-> sql_fetch($query_tmp)) {
		if ($this -> return_sql($query_tmp, "FORM_TYPE") == "WIZARD_FORM") {
			$output .= "<div id='wizard_form_".$this -> pageid."' title='".$this -> return_sql($query_tmp, "NAME")."'>
							<form id = 'wizard_parameters_".$this -> pageid."' name = 'wizard_parameters_".$this -> pageid."' >
								<div id='ajaxload_".$this -> pageid."' ><img src='/library/ajax-loader.gif' style='padding-bottom: 4px; vertical-align: middle;' > Загружаю...</div>	
								<div id='wizard_form_".$this -> pageid."_content'>
								
								</div>
							</form>
							<div>
								<div class=\"ui-widget-header\" style = \"height: 1px;\"></div><br>
								<button id ='button_close_".$this -> pageid."' >Отмена</button>
								<button id ='button_back_".$this -> pageid."' >назад</button>
								<button id ='button_next_".$this -> pageid."' >вперед</button>
							</div>
							</div>";
		} else {
			$inputs_form .= "'".$this -> return_sql($query_tmp, "ID_WB_MM_FORM")."',";
		}
	}	
	
	$output .= "
	<script type=\"text/javascript\">
	$(function() {
	var form_list_".$this->pageid." = [".trim($inputs_form,',')."];
	var form_list_now_".$this->pageid.";
	
	// Функция возвращает значения и управляет кнопками в диалоге
	get_num_mm = function (action) {
		if (action === 'next') {				
				for(var i = 0; i < form_list_".$this->pageid.".length; i++)  
					if (form_list_now_".$this->pageid." == form_list_".$this->pageid."[i]) {					
						counter = form_list_".$this->pageid."[i+1];
						if ( i >= 0 ) {
							$('#button_back_".$this -> pageid."').button('option','disabled', false );
						}
						if (i == (form_list_".$this->pageid.".length - 2)) {
							$('#button_next_".$this -> pageid."').children('span.ui-button-text').text('Готово');
						}
					}
		}
		if (action === 'back') {
				for(var i = 0; i <  form_list_".$this->pageid.".length; i++) 	
					if (form_list_now_".$this -> pageid." == form_list_".$this->pageid."[i]) {						
						counter = form_list_".$this->pageid."[i-1];
						if ( i == 1 ) {
							$('#button_back_".$this -> pageid."').button('option','disabled', true );
						} else {
						    $('#button_next_".$this -> pageid."').children('span.ui-button-text').text('вперед');
						}
					}			
		}
		if (action === 'first') {					
				counter = form_list_".$this->pageid."[0];
				$('#button_next_".$this -> pageid."').children('span.ui-button-text').text('вперед');				
		}
		if (counter === undefined) {
			// Загрузку делать ненужно отдаем на выполнение скрипт:
			$('#show_parameters-".$this->pageid."').button('option','disabled',true);
			$('#wizard_form_".$this->pageid."').dialog('close');
			var qstring = $('#wizard_parameters_".$this -> pageid."').serialize();";
			if(!isset($gridname) and !isset($chartname)) {
				$output .= "$('#".$this->pageid." .tab_main_content .CaptionTD').remove();
												$('#".$this->pageid." .tab_main_content').append('<div class=\"ui-widget CaptionTD\" style=\"height: 80%;width: 99%;vertical-align: middle;\"><h2>Данные обрабатываются ... </h2></div>');";
			}
			$output .= "			
			$.ajax({
					url:'".ENGINE_HTTP."/ajax.data.wizard.php?id_mm_fr=' + form_list_now_".$this->pageid."  + '&finish=true&pageid=".$this -> pageid."&id_mm=".$this -> id_mm."',
					type: 'POST',
					data: qstring,
					success: function(data, status) {
					";
					if(isset($gridname)) {
						$output .= "$('#".$gridname."').trigger('reloadGrid');";
					} else if(!isset($gridname) and !isset($chartname)) {
						$output .= "
												$('#".$this->pageid." .tab_main_content .CaptionTD').remove();
												$('#".$this->pageid." .tab_main_content').append('<div  class=\"ui-widget CaptionTD\" style=\"height: 80%;width: 99%;vertical-align: middle;\"><h2>Данные успешно обработаны!</h2></div>');
												parent.$('#ui-".$this->pageid."').parent().effect('pulsate', {}, 2000);
												$('#show_parameters-".$this->pageid."').button('option','disabled',false);
												
						";
					}
					$output .= "
					data_".$this -> pageid."_loaded = 1;
							if (data_".$this -> pageid."_loaded > 0) {
														$.each( $('#down-size-".$this -> pageid." .chart_data_".$this -> pageid."') , function() {
															var self = $(this);					
															$.get(self.attr('url'),function(data) {													
																	document.getElementById(self.attr('name')).SetVariable('_root.dataURL','');
																	document.getElementById(self.attr('name')).SetVariable('_root.isNewData','1');
																	document.getElementById(self.attr('name')).SetVariable('_root.newData',data);
																	document.getElementById(self.attr('name')).TGotoLabel('/', 'JavaScriptHandler'); 													
															});	
														});
							}
					if (data.length > 20) {custom_alert(data);}
					}
			});
			} else {
				form_list_now_".$this->pageid." = counter;				
				// Нужно загрузить форму
				var self = $('#wizard_form_".$this -> pageid."_content');
				var qstring = $('#wizard_parameters_".$this -> pageid."').serialize();				
				self.empty();
				$('#ajaxload_".$this -> pageid."').show();
				$.post('".ENGINE_HTTP."/ajax.data.wizard.php?id_mm_fr=' + counter  + '&pageid=".$this -> pageid."&id_mm=".$this -> id_mm."',qstring, function(data) {
					$('#ajaxload_".$this -> pageid."').hide();
					self.append(data);
				});	
		}
	}
	
	$('#wizard_form_".$this->pageid."').dialog({
						autoOpen: false,
						modal: true,						
						minWidth: 450,
						minHeight: 100,						
						closeOnEscape: true,
						resizable:false,
						appendTo: $('#".$this->pageid." .tab_main_content'),						
						close:function() {
							$(this).dialog('close');
						},
						open: function() {
								$(this).parent().parent().children('.ui-widget-overlay').addClass('dialog_jqgrid_overlay ui-corner-all');
								redraw_document();
								get_num_mm('first');
						}					
	});
	$('#button_next_".$this -> pageid."').button({
					     icons: {
							primary: 'ui-icon-arrowthick-1-e'
						}})
						.button()
						.click(function() {
							get_num_mm('next');
					});
	$('#button_back_".$this -> pageid."').button({
						 disabled: true,
					     icons: {
							primary: 'ui-icon-arrowthick-1-w'
						}})
						.button()
						.click(function() {
							get_num_mm('back');
					});		
	$('#button_close_".$this -> pageid."').button({
					     icons: {
							primary: 'ui-icon-close'
						}})
						.button()
						.click(function() {
						$('#wizard_form_".$this->pageid."').dialog('close');
					});						
	$('#show_parameters-".$this->pageid."').button({
					     icons: {
							primary: 'ui-icon-info'
						}})
						.button()
						.click(function() {
						$('#wizard_form_".$this->pageid."').dialog('open');
					});			
		
			setTimeout(function() {
				$('#wizard_form_".$this->pageid."').dialog('open');
				}, 500);
	});
	</script>	
	<button id=\"show_parameters-".$this->pageid."\"  style=\"float: right;margin:0 5px 0 0;\">Задать параметры</button>";
	return $output;		
	}	
	
	// Конструктор
	function __construct($id_mm_fr, $id_mm, $pageid) {
		$this -> db_conn = new db();		
		$this -> id_mm_fr = $id_mm_fr;
		$this -> id_mm = $id_mm;
		$this -> pageid = $pageid;
	}
	
	function __destruct() {
		$this-> db_conn ->__destruct();	
	}
} // END CLASS
?>