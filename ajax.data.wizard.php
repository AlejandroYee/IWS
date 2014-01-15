<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
//Возвращаемых данных для WIZARD_FORM
//--------------------------------------------------------------------------------------------------------------------------------------------
require_once("library/lib.func.php");
BasicFunctions::requre_script_file("lib.requred.php"); 
BasicFunctions::requre_script_file("auth.".AUTH.".php");
BasicFunctions::requre_script_file("lib.input.php"); 

function ext_implode($symv,$data) {
        $result = "";
        foreach ($data as $value) {
                if (is_numeric($value)) {
                        $result .= $symv.$value;
                } else {
                        $result .= $symv."'".$value."'";
                }
        }
        return trim($result,",");
}
	
// Начальные переменные
$user_auth = new AUTH();	
if (!$user_auth -> is_user()) {
		BasicFunctions::clear_cache();
		die("Доступ запрещен");
}

$main_db = new db();
$id_mm_fr 			= filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT);   
$id_mm				= filter_input(INPUT_GET, 'id_mm',FILTER_SANITIZE_NUMBER_INT);
$pageid				= filter_input(INPUT_GET, 'pageid',FILTER_SANITIZE_NUMBER_INT); 
$action_sql                     = "";
$action_bat			= "";
$check				= "";
	
// Дополнительная проверка на пользователя и права доступа:
$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
while ($main_db -> sql_fetch($query_check)) {
	$check	= explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON") )));
}
// если пользователю недоступна форма, то выходим сразу
if (empty($check)) die("Доступ для чтения данных запрещен");
	
// Проверяем, всели данные собраны:
if (filter_input(INPUT_GET, 'finish',FILTER_VALIDATE_BOOLEAN)) {
	// да все, загружаем финальный скрипт
	$query = $main_db -> sql_execute("select g.action_sql, g.action_bat from ".DB_USER_NAME.".wb_mm_form g join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = g.id_wb_form_type where g.id_wb_main_menu in (select t.id_wb_main_menu from ".DB_USER_NAME.".wb_mm_form t where t.id_wb_mm_form = ".$id_mm_fr .") and ft.name = 'WIZARD_FORM'");
	while ($main_db -> sql_fetch($query))	{
			$action_sql = $main_db -> sql_result($query, "ACTION_SQL");
			$action_bat = $main_db -> sql_result($query, "ACTION_BAT");
	}
	// подменяем переменные
	foreach(filter_input_array(INPUT_POST,FILTER_SANITIZE_STRING) as $k => $v) {
		if (is_array($v)) {
			$action_sql = str_replace(strtolower(trim(":".$k)),"'".ext_implode(",",$v)."'",strtolower($action_sql));
		} else {
			$action_sql = str_replace(strtolower(trim(":".$k)),"'".$v."'",strtolower($action_sql));
		}
	}
	
	// выполняем...
	$sql_block = new db(true);
	$action_sql = iconv(HTML_ENCODING,LOCAL_ENCODING, $action_sql);
	BasicFunctions::end_session();  // Закрываем сейсию для паралельного исполнения
	$sql_block -> sql_execute($action_sql);	
	$sql_block -> __destruct();
	
	// Если задано выполнение команды, то выполняем
	if (!empty($action_bat)) {
		exec($action_bat);
	}

	echo "done!";
	exit;
}

// формируем массив спрятанных форм с пришедшими данными:
foreach(filter_input_array(INPUT_POST,FILTER_SANITIZE_STRING) as $k => $v) {
	if (is_array($v)) {
		echo "<input type='hidden' name='".BasicFunctions::Convert_quotas(strtolower($k))."' value = '".BasicFunctions::Convert_quotas(ext_implode(",",$v))."' >\n";
	} else {
		echo "<input type='hidden' name='".BasicFunctions::Convert_quotas(strtolower($k))."' value = '".BasicFunctions::Convert_quotas($v)."' >\n";
	}
}

// Подгружаем класс форм:
$input = new INPUT($id_mm_fr, $id_mm, $pageid);

// после этого смотрим следующую форму:
$query = $main_db -> sql_execute("select decode(nvl(t.is_requred,0), 0,'false', 'true') is_requred, t.field_type, substr(t.name, 1, decode(instr(t.name, '@')-1, -1, length(t.name), instr(t.name, '@')-1)) name, substr(t.name, decode(instr(t.name, '@')+1, 1, null, instr(t.name, '@')+1)) help_name, t.field_txt, t.field_name, t.field_type,
nvl(t.count_element, 1) count_element, nvl(t.width, decode(trim(t.field_type), 'D', 46, 300)) width from ".DB_USER_NAME.".wb_form_field t  where t.id_wb_mm_form = ".$id_mm_fr." order by t.num");
while ($main_db -> sql_fetch($query)) {	
$content_value = $main_db -> sql_result($query, "FIELD_TXT",false);
// Производим подмену если есть такое значение:
foreach(filter_input_array(INPUT_POST,FILTER_SANITIZE_STRING) as $k => $v) {
	if (is_array($v)) {
		$content_value = str_replace(strtolower(trim(":".$k)),"'".ext_implode(",",$v)."'",strtolower($content_value));
	} else {
		$content_value = str_replace(strtolower(trim(":".$k)),"'".$v."'",strtolower($content_value));
	}
}
// И теперь заполняем формы данными:
		switch (trim($main_db -> sql_result($query, "FIELD_TYPE"))) {			
			// Поле ввода ДАТА
			case "D": 
				echo $input -> data_element(
										$content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										$main_db -> sql_result($query, "IS_REQURED")
										);			
			break;
			// Поле ввода ДАТА и ВРЕМЯ
			case "DT":
				echo $input -> data_time_element(
										$content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										$main_db -> sql_result($query, "IS_REQURED")
										);	
			break;
			
			// Поле ввода ВЫБОРКА STRING
			case "S":			
				echo $input -> string_element(
										$content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										$main_db -> sql_result($query, "WIDTH"),
										$main_db -> sql_result($query, "IS_REQURED")
										);	
			break;	
			
			// Поле ввода ВЫБОРКА SELECT
			case "SB":	
				echo $input -> select_element(
										$content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										$main_db -> sql_result($query, "WIDTH"),
										$main_db -> sql_result($query, "COUNT_ELEMENT"),
										$main_db -> sql_result($query, "IS_REQURED")
										);				
			break;
			case "M":	
				$input .= $this -> textarea_element(
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										$main_db -> sql_result($query, "COUNT_ELEMENT"),
										$main_db -> sql_result($query, "IS_REQURED")
										);				
			break;
			case "B":	
				$output .= $this -> checkbox_element(strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										$main_db -> sql_result($query, "IS_REQURED")
										);				
			break;
			case "C":	
				$output .= $this -> number_element($content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										"C",
										$main_db -> sql_result($query, "IS_REQURED"),
										$main_db -> sql_result($query, "WIDTH")
										);				
			break;
			case "I":	
				$output .= $this -> number_element($content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										"I",
										$main_db -> sql_result($query, "IS_REQURED"),
										$main_db -> sql_result($query, "WIDTH")
										);				
			break;
			case "N":	
				$output .= $this -> number_element($content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										"N",
										$main_db -> sql_result($query, "IS_REQURED"),
										$main_db -> sql_result($query, "WIDTH")
										);				
			break;
			case "NL":	
				$output .= $this -> number_element($content_value,
										strtolower($main_db -> sql_result($query, "FIELD_NAME")),
										$main_db -> sql_result($query, "NAME"),
										"NL",
										$main_db -> sql_result($query, "IS_REQURED"),
										$main_db -> sql_result($query, "WIDTH")
										);				
			break;			
			case "A":	
				$output .= $this -> link_element($content_value,
										$main_db -> sql_result($query, "NAME")
										);				
			break;
			case "E":	
				$output .= $this -> link_element("mailto:".$content_value,
										$main_db -> sql_result($query, "NAME")
										);				
			break;	
			default:
					echo $content_value;
			break;
		}
}