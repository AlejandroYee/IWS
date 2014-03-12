<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
class INPUT extends DATA_FORM {
var $db_conn, $id_mm_fr, $id_mm, $pageid;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------
	// Обрезка пробелов в строке, включая html пробел
	//--------------------------------------------------------------------------------------------------------------------------------------------
	Function FullTrim($txt) {
					return trim(str_replace("&nbsp;","",$txt));
	}
	
	// Описываем элементы данных
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	function data_element($field_text, $field_name, $name, $requred) {
			$output = "";
			$field_name_short = strtolower($field_name."_".$this->pageid);
			// проверка на пустой филд
			if (empty($field_text)) {
                                $field_text = "select to_char(sysdate, 'dd.mm.yyyy') def_date from dual";
                                $is_active = "";
                        } else {
                                $is_active = "field_has_sql='true'";
                        }   
			$query_d = $this->db_conn->sql_execute($field_text);
				while ($this-> db_conn-> sql_fetch($query_d))  {					
					$output .= "
					<p><label for='".$field_name_short."' >".$this->FullTrim($name)."</label>
						<input type='text' class='date_".$this->pageid." FormElement ui-widget-content ui-corner-all' row_type='D' ".$is_active." is_requred='".$requred."' id='".$field_name_short."' name='".$field_name."' value='".$this -> return_sql($query_d, 1)."' />
					</p>
					";
				}
	return $output;	
	}

	function data_time_element($field_text, $field_name,$name, $requred) {
			$output = "";
			$field_name_short = strtolower($field_name."_".$this->pageid);
			// проверка на пустой филд
			if (empty($field_text)) {
                                $field_text = "select to_char(sysdate, 'dd.mm.yyyy') def_date from dual";
                                $is_active = "";
                        } else {
                                $is_active = "field_has_sql='true'";
                        }   
			$query_d = $this->db_conn->sql_execute($field_text);
						while ($this-> db_conn-> sql_fetch($query_d))  {					
							$output .= "
							<p><label for='".$field_name_short."' >".$this->FullTrim($name)."</label>
								<input type='text' class='date_time_".$this->pageid." FormElement ui-widget-content ui-corner-all' row_type='DT' ".$is_active." is_requred='".$requred."' id='".$field_name_short."' name='".$field_name."' value='".$this -> return_sql($query_d,1)."' />
							</p>
							";
						}
	return $output;	
	}
	
	function string_element($field_text,$field_name,$name,$width, $requred) {
		$field_name_short = strtolower($field_name."_".$this->pageid);
			if (!empty($field_text) and (strpos($field_text,"input")  == 0)) {			
				$query_d = $this->db_conn->sql_execute($field_text);	
				while ($this-> db_conn-> sql_fetch($query_d))  {
                                        $str_val = $this -> return_sql($query_d, 1);
                                }
                                $is_active = "field_has_sql='true'";
			} else {
				$str_val = "";
                                $is_active = "";
			}
				
		return "<p><label for='".$field_name_short."' >".$this->FullTrim($name)."</label>
					<input type='text' class='FormElement ui-widget-content ui-corner-all' is_requred='".$requred."' ".$is_active." id='".$field_name_short."' size='".round($width/8)."' name='".$field_name."' value='".$str_val."' />
			</p>
			";
	}
	
	function textarea_element($field_name,$name,$count_element, $requred) {
		$field_name_short = strtolower($field_name."_".$this->pageid);
		return "<p style='text-align :left;'><label for='".$field_name_short."' >".$this->FullTrim($name)."</label>
					  <textarea id='".$field_name_short."' h='".$count_element."' is_requred='".$requred."' row_type='M' name='".$field_name."' role='textbox' multiline='true' class='FormElement ui-widget-content ui-corner-all'></textarea>
					</p>";
	}
	function select_element($field_text,$field_name,$name,$width,$count_element, $requred) {
		$output = "";		
		if ($count_element <= 1) {						
						$output .= "<p>
								<label for='".$field_name."' >".$this->FullTrim($name)."</label>
								<select id=\"".$field_name."-".$this->pageid."\"  row_type='SB' field_has_sql='true' is_requred='".$requred."' name=\"".$field_name."\"  w='".$width."' >";
					} else {
						
						$output .= "<p>
								<label for='".$field_name."' >".$this->FullTrim($name)."</label>
								<select id=\"".$field_name."-".$this->pageid."\" multiple='multiple' field_has_sql='true' row_type='SB' name=\"".$field_name."[]\" h='".$count_element."' w='".$width."'>";
					}
					
						$query_d = $this -> db_conn->sql_execute($field_text);
						while ($this-> db_conn-> sql_fetch($query_d)) { 
								$output .= "<option ".$this -> return_sql($query_d, "FL_SELECTED")." value=".$this -> return_sql($query_d, "ID").">".$this -> return_sql($query_d, "NAME");
                                                }
                                                $output .= "</select></p>";
	return $output;
	}
	
	// all numbers
	function number_element($field_text,$field_name,$name,$num_culture,$requred,$width) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
					// проверка на пустой филд
					if (empty($field_text)) {
                                                $field_text = "select null def_num from dual";
                                                $is_active = "";
                                        } else {
                                                $is_active = "field_has_sql='true'";
                                        }   
					$query_d = $this->db_conn->sql_execute($field_text);
                                        while ($this-> db_conn-> sql_fetch($query_d)) {
                                                $value = $this -> return_sql($query_d, 1);
                                        }        
						$output .= "<p><label for=\"".$field_name_short."\">".$this->FullTrim($name)."</label>
						<input type='text'  class='FormElement ui-widget-content ui-corner-all' row_type='".$num_culture."' w='".$width."' ".$is_active." is_requred='".$requred."' id='".$field_name_short."' value='".$value."' name='".$field_name."' /></p>";
						
					
	return $output;
	}
	// link or email
	function link_element($field_text,$name) {
		return "<p><a href='".$field_text."'>".$this->FullTrim($name)."</a></p>";						
	}
        
	// maska
	function mask_element($field_name,$name,$requred) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
						$output .= "<p><label for=\"".$field_name_short."\">".$this->FullTrim($name)."</label>
						<input type='text'  is_requred='".$requred."' class='FormElement ui-widget-content ui-corner-all' row_type='IP'  id='".$field_name_short."' name='".$field_name."' /></p>";
						
								
	}
		
	// Checkbox
	function checkbox_element($field_name,$name,$requred) {
		$output = "";
		$field_name_short = strtolower($field_name."_".$this->pageid);
						$output .= "<p><label for=\"".$field_name_short."\">".$this->FullTrim($name)."</label>
						<input type='checkbox'  is_requred='".$requred."' class='FormElement ui-widget-content ui-corner-all' row_type='B' id='".$field_name_short."' name='".$field_name."' /></p>";
						
					
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
                       substr(t.name, decode(instr(t.name, '@')+1, 1, null, instr(t.name, '@')+1)) help_name, t.field_txt, t.field_name, decode(nvl(t.is_requred,0), 0,'false', 'true') is_requred, upper(t.field_type) as field_type,
                       nvl(t.count_element, 1) count_element, nvl(t.width, decode(t.field_type, 'D', 46, 300)) width from ".DB_USER_NAME.".wb_form_field t
					   where t.id_wb_mm_form = ".$this->id_mm_fr." order by t.num");	
					   
	$output = "<div id='param-".$this->pageid."' title='Укажите параметры:' class='ui-jqdialog-content'>
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
				$output .= $this -> textarea_element($this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "COUNT_ELEMENT"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;
			// new
			case "B":	
				$output .= $this -> checkbox_element($this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);				
			break;                    
			case "C":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"C",
										$this -> return_sql($query_tmp, "IS_REQURED"),
										$this -> return_sql($query_tmp, "WIDTH")
										);				
			break;
			case "I":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"I",
										$this -> return_sql($query_tmp, "IS_REQURED"),
										$this -> return_sql($query_tmp, "WIDTH")
										);				
			break;
			case "N":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"N",
										$this -> return_sql($query_tmp, "IS_REQURED"),
										$this -> return_sql($query_tmp, "WIDTH")
										);				
			break;
			case "NL":	
				$output .= $this -> number_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										"NL",
										$this -> return_sql($query_tmp, "IS_REQURED"),
										$this -> return_sql($query_tmp, "WIDTH")
										);				
			break;			
			case "A":	
				$output .= $this -> link_element($this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "NAME")
										);				
			break;
			case "E":	
				$output .= $this -> link_element("mailto:".$this -> return_sql($query_tmp, "FIELD_TXT"),
										$this -> return_sql($query_tmp, "NAME")
										);				
			break;	
			default:
                            if (substr($this -> return_sql($query_tmp, "FIELD_TYPE"),0,1) == "U") {	
                                        $output .= $this -> mask_element($this -> return_sql($query_tmp, "FIELD_NAME"),
										$this -> return_sql($query_tmp, "NAME"),
										$this -> return_sql($query_tmp, "IS_REQURED")
										);					
                            } else {
                                $output .= "<p>".$this -> return_sql($query_tmp, "FIELD_TXT")."</p>";
                            }                            
			break;
		}
	}
	
	
	$output .= "	
    </form>
	</div>
	<script type=\"text/javascript\">";
        $output .= BasicFunctions::regex_javascript("
				$(function() { 			
					// Преобразовываемся:
					create_from_table_elements($('#form_parameters_".$this->pageid."'));			
					
					$('#param-".$this->pageid."').dialog({
						autoOpen: false,
						modal: false,						
						minWidth: 450,
						minHeight: 50,	
						closeOnEscape: true,
						resizable:true,
						appendTo: $('#".$this->pageid." .tab_main_content'),
						buttons: [							 
							 {
								text: 'Применить',
								click: function () {
								if (check_form($('#form_parameters_".$this->pageid."'))) {
									var qString = $('#form_parameters_".$this->pageid."').serialize();
                                                                        var self_dialog = $(this);
                                                                        $('#ajax_".$this->pageid."').show();
									$('#show_parameters-".$this->pageid."').button('option','disabled',true);
                                                                        $('#cancel_".$this->pageid."').button('option','disabled',true); 
                                                                        $('#save_".$this->pageid."').button('option','disabled',true); 
									");									
				if ($c_count < 2 ) {
                                                    $output .= BasicFunctions::regex_javascript("
									$('#".$this->pageid." .tab_main_content .CaptionTD').remove();
									$('#".$this->pageid." .tab_main_content').append('<div class=\"ui-widget CaptionTD\" style=\"height: 80%;width: 99%;vertical-align: middle;\"></div>');
									var load_".$this->pageid."_time = 0;
                                                                        $('#ui-".$this->pageid." span').removeClass('ui-icon-document').addClass('ui-icon-transferthick-e-w');
									function loader_function() {
													load_".$this->pageid."_time++;
													minutes_".$this->pageid." = (Math.floor(load_".$this->pageid."_time/60) < 10) ? '0'+Math.floor(load_".$this->pageid."_time/60) : Math.floor(load_".$this->pageid."_time/60);
													seconds_".$this->pageid." = ((load_".$this->pageid."_time - minutes_".$this->pageid."*60) < 10) ? '0'+(load_".$this->pageid."_time - minutes_".$this->pageid."*60) : (load_".$this->pageid."_time - minutes_".$this->pageid."*60);										
													$('#".$this->pageid." .tab_main_content .CaptionTD').html('<h2>(' + minutes_".$this->pageid." +':' + seconds_".$this->pageid." + ') Данные обрабатываются ... </h2>');                                                                                                        
									}	
									load_".$this->pageid."_intval = setInterval(loader_function, 1000);
									loader_function();
									$.get('ajax.saveparams.php?&id_mm_fr=".$this->id_mm_fr."&' + qString, function(data) {										
										clearInterval(load_".$this->pageid."_intval);										
										$('#".$this->pageid." .tab_main_content .CaptionTD').html('<h2>Данные успешно обработаны,<br>Длительность обработки ' + minutes_".$this->pageid." +' минут(а), ' + seconds_".$this->pageid." + ' секунд.</h2>');
                                                                                load_".$this->pageid."_time = 0;
                                                                                $('#ui-".$this->pageid." span').removeClass('ui-icon-transferthick-e-w').addClass('ui-icon-document'); 
										$('li[aria-selected=\"false\"] a[href=\"#".$this->pageid."\"]').parent().effect('pulsate', {}, 2000);
										if (data.length > 20) {
												custom_alert(data);
										}
                                                                                $('#ui-".$this->pageid." span').removeClass('ui-icon-transferthick-e-w').addClass('ui-icon-document');
                                                                                self_dialog.dialog('close');
                                                                                
									});
									");
				} else {
                                                             $output .= BasicFunctions::regex_javascript("
                                                                        $('#ui-".$this->pageid." span').removeClass('ui-icon-document').addClass('ui-icon-transferthick-e-w');
									$.get('ajax.saveparams.php?&id_mm_fr=".$this->id_mm_fr."&' + qString, function(data) {
                                                                                 if (data.length > 20) {
                                                                                        custom_alert(data);
                                                                                 }
                                                                                 $.each( $('#".$this->pageid." .tab_main_content .chart_data_".$this -> pageid."') , function() {
                                                                                            plot_graph($(this));  	
                                                                                 });
                                                                                 $('#ui-".$this->pageid." span').removeClass('ui-icon-transferthick-e-w').addClass('ui-icon-document');
                                                                                 ");
                                                                if (($c_count > 1) and isset($gridname)) {
                                                                    $output .= BasicFunctions::regex_javascript(
                                                                                       "$('#ui-".$this->pageid." span').removeClass('ui-icon-document').addClass('ui-icon-transferthick-e-w');
                                                                                        $('#".$gridname."').jqGrid('setGridParam',{datatype:'json'});	
                                                                                        $('#".$gridname."').trigger('reloadGrid');"
                                                                            );  

                                                                }  
                                                             $output .= BasicFunctions::regex_javascript(
                                                                          "data_".$this -> pageid."_loaded = 1;                                                                           
                                                                           self_dialog.dialog('close');
                                                                        });									 
									");
				} 
                $output .= BasicFunctions::regex_javascript("
                                                             }
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
                                                        $('#show_parameters-".$this->pageid."').button('option','disabled',false);                                                        
                                                        $('#cancel_".$this->pageid."').button('option','disabled',false); 
                                                        $('#save_".$this->pageid."').button('option','disabled',false);
                                                        $('#ajax_".$this->pageid."').remove(); 
							$(this).parent().parent().children('.ui-widget-overlay').remove();
							$(this).dialog( 'close' );
						},
						open: function() {
                                                                var self = $(this).parent();
								self.children('.ui-dialog-buttonpane').find('button:contains(\"Отмена\")').button({icons: { primary: 'ui-icon-close'}}).attr({id:'cancel_".$this->pageid."'});
								self.children('.ui-dialog-buttonpane').find('button:contains(\"Применить\")').button({icons: { primary: 'ui-icon-disk'}}).attr({id:'save_".$this->pageid."'});
								$($('<div />').attr({'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all',
													 'style':'position:absolute;'})).prependTo(self.parent());
                                                                self.children('.ui-dialog-buttonpane').append(\"<div id= 'ajax_".$this->pageid."' style='position:relative;top:15px;left:10px'><img src='/library/ajax-loader-tab.gif' style='padding-bottom: 4px; vertical-align: middle;' > Сохраняю...</div>\");
                                                                $('#ajax_".$this->pageid."').hide();    
								redraw_document();
						}
					});
					$('#show_parameters-".$this->pageid."').button({
					     icons: {primary: 'ui-icon-info'}})
						.button()
						.click(function() {
						$('#param-".$this->pageid."').dialog('open');
					});					
				
				setTimeout(function() {
                                    $('#param-".$this->pageid."').dialog('open');
                                }, 500);
                    });");
	$output .= "</script>	
	<button id=\"show_parameters-".$this->pageid."\"  style=\"float: right;margin:0 5px 0 0;\">Задать параметры</button>";	
	if (empty($show_form)) $output = ""; // Если форма пустая, то просто обнуляем содержимое вывода
	return $output;	
	}
	
	// Запрос и обработка данных  формы (визард)
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	function Creare_wizard_from () {
	$output ="";
	$inputs_form = "";
	$query_tmp2 = $this->db_conn->sql_execute("select ft.name, t.id_wb_mm_form id from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and ft.name like 'GRID%' and rownum = 1 order by t.num");
		while ($this-> db_conn-> sql_fetch($query_tmp2)) {
                    $gridname = strtolower($this -> return_sql($query_tmp2, "NAME")."_".$this -> return_sql($query_tmp2, "ID")."_".$this ->pageid);
                }    
	$query_tmp1 = $this->db_conn->sql_execute("select ft.name, t.id_wb_mm_form id from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and ft.name like 'CHARTS%' and rownum = 1 order by t.num");
		while ($this-> db_conn-> sql_fetch($query_tmp1)) {
                    $chartname = strtolower($this -> return_sql($query_tmp1, "NAME")."_".$this -> return_sql($query_tmp1, "ID")."_".$this ->pageid);
                }
	// Собираем все формы в одну кучу
	$query_tmp = $this->db_conn->sql_execute("select  t.*, ft.name as form_type from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$this -> id_mm." and  (ft.name like 'INPUT_%' or ft.name = 'WIZARD_FORM') order by t.num");
	while ($this-> db_conn-> sql_fetch($query_tmp)) {
		if ($this -> return_sql($query_tmp, "FORM_TYPE") == "WIZARD_FORM") {
			$output .= "<div id='wizard_form_".$this -> pageid."' title='".$this -> return_sql($query_tmp, "NAME")."' class='ui-jqdialog-content' >
							<form id = 'wizard_parameters_".$this -> pageid."' name = 'wizard_parameters_".$this -> pageid."' >
								<div id='ajaxload_".$this -> pageid."' ><img src='/library/ajax-loader.gif' style='padding-bottom: 4px; vertical-align: middle;' > Загружаю...</div>	
								<div id='wizard_form_".$this -> pageid."_content'>
                                                                    
								</div></form>
							<div><div class=\"ui-widget-header\" style = \"height: 1px;\"></div><br>
                                                        <button id ='button_back_".$this -> pageid."' >назад</button>&ensp;<button id ='button_next_".$this -> pageid."' >вперед</button>&ensp;<button id ='button_close_".$this -> pageid."' >Отмена</button>
							</div></div>";
		} else {
			$inputs_form .= "'".$this -> return_sql($query_tmp, "ID_WB_MM_FORM")."',";
		}
	}	
	
	$output .=  "<script type=\"text/javascript\">
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
							$('#button_next_".$this -> pageid."').button({icons: { primary: 'ui-icon-disk'},label: 'Применить'});
						}
					}
		}
		if (action === 'back') {
				for(var i = 0; i <  form_list_".$this->pageid.".length; i++) 	
					if (form_list_now_".$this -> pageid." == form_list_".$this->pageid."[i]) {						
						counter = form_list_".$this->pageid."[i-1];
						if ( i == 1 ) {
							$('#button_back_".$this -> pageid."').button('option','disabled', true );
						}	
						$('#button_next_".$this -> pageid."').button({icons: { primary: 'ui-icon-arrowthick-1-e'},label: 'вперед'});
					}			
		}
		if (action === 'first') {					
				counter = form_list_".$this->pageid."[0];
				$('#button_next_".$this -> pageid."').button({icons: { primary: 'ui-icon-arrowthick-1-e'},label: 'вперед'});			
		}
		if (counter === undefined) {
			// Загрузку делать ненужно отдаем на выполнение скрипт:
			$('#show_parameters-".$this->pageid."').button('option','disabled',true);
                        $('#ui-".$this->pageid." span').removeClass('ui-icon-document').addClass('ui-icon-transferthick-e-w');
                        $('#button_back_".$this -> pageid."').button('option','disabled', true );
                        $('#button_next_".$this -> pageid."').button('option','disabled', true ); 
                        var qstring = $('#wizard_parameters_".$this -> pageid."').serialize();
                        $('#wizard_form_".$this -> pageid."_content').empty();
			$('#ajaxload_".$this -> pageid."').show();
			";
			if(!isset($gridname) and !isset($chartname)) {
				$output .=
                                        "$('#".$this->pageid." .tab_main_content .CaptionTD').remove();											
						$('#".$this->pageid." .tab_main_content').append('<div class=\"ui-widget CaptionTD\" style=\"height: 80%;width: 99%;vertical-align: middle;\"></div>');
						var load_".$this->pageid."_time = 0;                                                 
						function loader_function() {
										load_".$this->pageid."_time++;
										minutes_".$this->pageid." = (Math.floor(load_".$this->pageid."_time/60) < 10) ? '0'+Math.floor(load_".$this->pageid."_time/60) : Math.floor(load_".$this->pageid."_time/60);
										seconds_".$this->pageid." = ((load_".$this->pageid."_time - minutes_".$this->pageid."*60) < 10) ? '0'+(load_".$this->pageid."_time - minutes_".$this->pageid."*60) : (load_".$this->pageid."_time - minutes_".$this->pageid."*60);										
										$('#".$this->pageid." .tab_main_content .CaptionTD').html('<h2>(' + minutes_".$this->pageid." +':' + seconds_".$this->pageid." + ') Данные обрабатываются ... </h2>');                                                                                    
						}							
						load_".$this->pageid."_intval = setInterval(loader_function, 1000);
						loader_function();
                                                $('#wizard_form_".$this->pageid."').dialog('close');
				";
			}
			$output .= "			
			$.ajax({
					url:'".ENGINE_HTTP."/ajax.data.wizard.php?id_mm_fr=' + form_list_now_".$this->pageid."  + '&finish=true&pageid=".$this -> pageid."&id_mm=".$this -> id_mm."',
					type: 'POST',
					data: qstring,
					success: function(data, status) {
                                        $('#ui-".$this->pageid." span').removeClass('ui-icon-transferthick-e-w').addClass('ui-icon-document'); 
					";
					if(isset($gridname)) {
						$output .= "
                                                        $('#ui-".$this->pageid." span').removeClass('ui-icon-document').addClass('ui-icon-transferthick-e-w');
                                                        $('#".$gridname."').jqGrid('setGridParam',{datatype:'json'});
                                                        $('#".$gridname."').trigger('reloadGrid');";
					} else if(!isset($gridname) and !isset($chartname)) {
						$output .= "
								clearInterval(load_".$this->pageid."_intval);
								load_".$this->pageid."_time = 0;
                                                                $('#".$this->pageid." .tab_main_content .CaptionTD').html('<h2>Данные успешно обработаны,<br>Длительность обработки ' + minutes_".$this->pageid." +' минут(а), ' + seconds_".$this->pageid." + ' секунд.</h2>');								
                                                                $('li[aria-selected=\"false\"] a[href=\"#".$this->pageid."\"]').parent().effect('pulsate', {}, 2000);
								$('#show_parameters-".$this->pageid."').button('option','disabled',false);
												
						";
					}
					$output .= "
						$.each( $('#".$this->pageid." .tab_main_content .chart_data_".$this -> pageid."') , function() {																
							plot_graph($(this));  
						});
					$('#show_parameters-".$this->pageid."').button('option','disabled',false);
					data_".$this -> pageid."_loaded = 1;                                            
					if (data.length > 20) {custom_alert(data);}                                        
                                        $('#wizard_form_".$this->pageid."').dialog('close');                                        
					}
			});
			} else {
				form_list_now_".$this->pageid." = counter;				
				// Нужно загрузить форму
                                $('#ui-".$this->pageid." span').removeClass('ui-icon-document').addClass('ui-icon-transferthick-e-w');
                                $('#button_back_".$this -> pageid."').button('option','disabled', true );
                                $('#button_next_".$this -> pageid."').button('option','disabled', true );    
				var self = $('#wizard_form_".$this -> pageid."_content');
				var qstring = $('#wizard_parameters_".$this -> pageid."').serialize();				
				self.empty();
				$('#ajaxload_".$this -> pageid."').show();
				$.post('".ENGINE_HTTP."/ajax.data.wizard.php?id_mm_fr=' + counter  + '&pageid=".$this -> pageid."&id_mm=".$this -> id_mm."',qstring, function(data) {
					$('#ajaxload_".$this -> pageid."').hide();
					self.append(data);
					create_from_table_elements(self);
                                        $('#button_back_".$this -> pageid."').button('option','disabled', false );
                                        $('#button_next_".$this -> pageid."').button('option','disabled', false );  
                                        $('#ui-".$this->pageid." span').removeClass('ui-icon-transferthick-e-w').addClass('ui-icon-document');
				});	
		}
	}
	
	$('#wizard_form_".$this->pageid."').dialog({
						autoOpen: false,
						modal: false,						
						minWidth: 450,
						minHeight: 100,						
						closeOnEscape: true,
						resizable:true,
						appendTo: $('#".$this->pageid." .tab_main_content'),						
						close:function() {
							$(this).parent().parent().children('.ui-widget-overlay').remove();
                                                        $('#button_back_".$this -> pageid."').button('option','disabled', false );
                                                        $('#button_next_".$this -> pageid."').button('option','disabled', false ); 
							$(this).dialog('close');
						},
						open: function() {
								$($('<div />').attr({'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all',
													 'style':'position:absolute;'})).prependTo($(this).parent().parent());
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
	});</script>	
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
}