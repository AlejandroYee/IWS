<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
require_once("library/lib.func.php");
requre_script_file("lib.requred.php"); 
$user_auth = new AUTH();

// Сделано для смены темы
if (isset($_POST['theme'])) {
	if (!$user_auth -> is_user()) {
		clear_cache();
		die("Доступ запрещен");
	}
	$dataform = new DB();
	// сохраняем параметры:
	foreach ($_POST as $key => $line) {
		$dataform -> set_param_view($key,Convert_quotas($_POST[$key]));
	}
	// отчищаем куку пользователя:	
	to_log("LIB: User changed self params!");
	$dataform -> __destruct();
	clear_cache("no_user");
	end_session();
	Redirect(ENGINE_HTTP);
	exit;
}

// Выход пользователя
if (isset($_GET['act']) and ($_GET['act'] == "logout")) {	
	clear_cache();
	to_log("LIB: User logout....");	
	Redirect(ENGINE_HTTP);
	exit;
}

// Отчистить кеш
if (isset($_GET['act']) and ($_GET['act'] == "cache")) {
	clear_cache("no_user");
	end_session();
	to_log("LIB: User cleaned cache....");	
	Redirect(ENGINE_HTTP);
	exit;
}

// Вход пользователя
if (isset($_GET['act']) and ($_GET['act'] == "login")) {
	$pwd = Convert_quotas($_POST['password']);
	$usr = Convert_quotas($_POST['username']);
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
	clear_cache();
	die("Доступ запрещен");
}

if (isset($_GET['id_mm_fr'])) {
	$id_mm_fr     = intval($_GET['id_mm_fr']);
} else {
	$id_mm_fr ="";
}

$main_db = new db();


// Дополнительная проверка на пользователя и права доступа:
$query = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
while ($main_db -> sql_fetch($query)) {
	$check				= explode(",",strtoupper(trim( $main_db -> sql_result($query, "EDIT_BUTTON") )));;
}
// если пользователю недоступна форма, то выходим сразу
if (empty($check)) die("Доступ запрещен");

$query = $main_db->sql_execute("select t.field_name from ".DB_USER_NAME.".wb_form_field t where t.id_wb_mm_form = ".$id_mm_fr." order by t.num");
    while ($main_db-> sql_fetch($query)) {
		if (isset($_GET[$main_db->sql_result($query, "FIELD_NAME")])) {
			if (is_array($_GET[$main_db->sql_result($query, "FIELD_NAME")])) {
                    $arr_value[$main_db->sql_result($query, "FIELD_NAME")] = implode(",",$_GET[$main_db->sql_result($query, "FIELD_NAME")]);
            } else {			
					$arr_value[$main_db->sql_result($query, "FIELD_NAME")] = $_GET[$main_db->sql_result($query, "FIELD_NAME")];
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
		if (isset($_GET['rowid'])) {
			if (!is_numeric ($_GET['rowid'])) {
				// Если у нас не число, то возможно переданы числа или текст через зяпятую. проверяем и формируем:
				$tmp=explode(",",$_GET['rowid']);
				$_GET['rowid'] = "";
				
				// пробегаемся по массиву и смотрим  на типы числе или
				foreach($tmp as $key => $val) if (!is_numeric ($val)) {
					$_GET['rowid'] .= "'".$val."',";			
				} else {
					$_GET['rowid'] .= $val.",";			
				}
				
				// Чистим от последней запятой, и выполняем
				$_GET['rowid'] = trim($_GET['rowid'],",");
			}		
			$str_block = str_ireplace(":rowid",@Convert_quotas($_GET['rowid']),$str_block);
		}
		$sql_block = new db(true);
		end_session();
		$sql_block -> sql_execute($str_block); 	
		$sql_block -> __destruct();
    }
	
// Если задано выполнение команды, то выполняем
if (!empty($action_bat)) {
	@exec($action_bat);
}

echo jsonencode("done");
$main_db -> __destruct();
?>