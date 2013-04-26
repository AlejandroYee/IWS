<?
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Вывод данных для грида
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	requre_script_file("db.".DB.".php");
	header("Content-type: text/script;charset=".HTML_ENCODING);

  	// Начальные переменные
	if (isset($_GET['value_name'])) {				
			$value_name = trim_fieldname(Convert_quotas($_GET['value_name']));
			$value_id   = substr(Convert_quotas($_GET['value_name']), strrpos(Convert_quotas($_GET['value_name']), "_") + 1);
		} else {
		die();
	}
	
	$result_array = "";
	
	if (isset($_GET['parent_id']) and ($_GET['parent_id'] != 'null')) {	
			$parent_id = Convert_quotas($_GET['parent_id']);			
		} else {
			$parent_id = 'null';
	}	
	$main_db = new db();
	// Получаем данные из свойств столбца
	$query = $main_db -> sql_execute("select fw.field_txt from ".DB_USER_NAME.".wb_form_field fw where lower(fw.field_name) = lower('".$value_name."') and abs(fw.id_wb_form_field) = '".$value_id."'");		
    end_session(); // закрываем сейсию чтобы скрипты нетормозили
	while ($main_db -> sql_fetch($query)) {
		$select = $main_db -> sql_result($query, "FIELD_TXT",false);
	}
	
	$result_array = get_select_data($main_db, $select, $parent_id);
	
	// отдаем массив
	echo $result_array;
?>