<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
require_once("library/lib.func.php");
BasicFunctions::requre_script_file("lib.requred.php");

$act             = filter_input(INPUT_GET, 'act',FILTER_SANITIZE_STRING);
$theme           = filter_input(INPUT_POST, 'theme',FILTER_SANITIZE_STRING);
$id_mm_fr   	 = filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT); 
$rowid           = filter_input(INPUT_GET, 'rowid',FILTER_SANITIZE_STRING);

// Выход пользователя
if ($act == "logout") {	
	BasicFunctions::clear_cache();
	BasicFunctions::to_log("LIB: User logout....");	
	BasicFunctions::Redirect(ENGINE_HTTP);
	exit;
}

// Отчистить кеш
if ($act ==  "cache") {
	BasicFunctions::clear_cache("no_user");
	BasicFunctions::end_session();
	BasicFunctions::to_log("LIB: User cleaned cache....");	
	BasicFunctions::Redirect(ENGINE_HTTP);
	exit;
}

BasicFunctions::requre_script_file("auth.".AUTH.".php");
$user_auth = new AUTH();

// Вход пользователя
if ($act == "login") {
	$pwd = filter_input(INPUT_POST, 'password',FILTER_SANITIZE_STRING);
	$usr = filter_input(INPUT_POST, 'username',FILTER_SANITIZE_STRING);
	if (!$user_auth -> is_user($usr,$pwd)) {
			$udb = new db();
			$responce = $udb -> user_real_name;			
		} else {
			$responce = "fail";		
		}		
		echo $responce;
exit;
}

if (!$user_auth -> is_user()) {
	BasicFunctions::clear_cache();
	die("Доступ запрещен");
}

// Сделано для смены темы
if (!empty($theme)) {
	$dataform = new DB();
	// сохраняем параметры:
	foreach (filter_input_array(INPUT_POST,FILTER_SANITIZE_STRING) as $key => $line) {
		$dataform -> set_param_view($key,filter_input(INPUT_POST, $key,FILTER_SANITIZE_STRING));
	}
	// отчищаем куку пользователя:	
	BasicFunctions::to_log("LIB: User changed self params!");
	$dataform -> __destruct();
	BasicFunctions::clear_cache("no_user");
	BasicFunctions::end_session();
	BasicFunctions::Redirect(ENGINE_HTTP);
	exit;
}

// Отчистка лога
if ($act ==  "clear_log_file") {
   if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" )) {
     file_put_contents(ENGINE_ROOT. DIRECTORY_SEPARATOR .HAS_DEBUG_FILE,"[".date("d.m.Y H:i:s")." <".strtoupper(auth::get_user()).">] Cleared log file!\r\n", LOCK_EX);
    }
   exit;        
}

$main_db = new db();

// Дополнительная проверка на пользователя и права доступа:
$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
while ($main_db -> sql_fetch($query_check)) {
	$check= explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON"))));
}
// если пользователю недоступна форма, то выходим сразу
if (empty($check)) die("Доступ запрещен");

$query_val = $main_db->sql_execute("select t.field_name from ".DB_USER_NAME.".wb_form_field t where t.id_wb_mm_form = ".$id_mm_fr." order by t.num");
    while ($main_db-> sql_fetch($query_val)) {
                $field_name = filter_input(INPUT_GET, $main_db->sql_result($query_val, "FIELD_NAME"),FILTER_SANITIZE_STRING);
		if (!empty($field_name)) {
			if (is_array($field_name)) {
                                    $arr_value[$main_db->sql_result($query_val, "FIELD_NAME")] = implode(",",$field_name);
                            } else {			
                                    $arr_value[$main_db->sql_result($query_val, "FIELD_NAME")] = $field_name;
                            }
		}
    }
$query = $main_db->sql_execute("select t.action_sql,t.action_bat from ".DB_USER_NAME.".wb_mm_form t  where t.id_wb_mm_form = ".$id_mm_fr);
    while ($main_db-> sql_fetch($query)) {
	    $str_block = $main_db->sql_result($query, "ACTION_SQL");
		$action_bat	= $main_db->sql_result($query, "ACTION_BAT");
		$query_tmp = $main_db->sql_execute("select t.field_name from ".DB_USER_NAME.".wb_form_field t where t.id_wb_mm_form = ".$id_mm_fr."  order by t.num");
                while ($main_db-> sql_fetch($query_tmp)) {                       
					if (isset($arr_value[$main_db->sql_result($query_tmp, "FIELD_NAME")])) {
						$str_block = str_ireplace(":".$main_db->sql_result($query_tmp, "FIELD_NAME"),"'".$arr_value[$main_db->sql_result($query_tmp, "FIELD_NAME")]."'",$str_block);	
					}
				}
		// Для кастомных кнопок проверка на заданный ровайди
		if (!empty($rowid)) {
			if (!is_numeric($rowid)) {
				// Если у нас не число, то возможно переданы числа или текст через зяпятую. проверяем и формируем:
				$tmp=explode(",",$rowid);
				$rowid = "";
				
				// пробегаемся по массиву и смотрим  на типы числе или
				foreach($tmp as $key => $val) if (!is_numeric ($val)) {
					$rowid.= "'".$val."',";			
				} else {
					$rowid .= $val.",";			
				}
				
				// Чистим от последней запятой, и выполняем
				$rowid1 = trim($rowid,",");
			}		
			$str_block = str_ireplace(":rowid",$rowid1,$str_block);
		}
		$sql_block = new db(true);
		BasicFunctions::end_session();
		$sql_block -> sql_execute($str_block); 	
		$sql_block -> __destruct();
    }
	
// Если задано выполнение команды, то выполняем
if (!empty($action_bat)) {
	exec($action_bat);
}

/*$json = new json();
BasicFunctions::requre_script_file("lib.json.php"); 
echo jsonencode("done");*/
$main_db -> __destruct();