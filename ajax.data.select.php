<?
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Select data for grid
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	BasicFunctions::requre_script_file("db.".DB.".php");
	header("Content-type: text/script;charset=".HTML_ENCODING);
	
        $parent_id      = filter_input(INPUT_GET, 'parent_id',FILTER_SANITIZE_STRING);
	$value_name     = trim_fieldname(filter_input(INPUT_GET, 'value_name',FILTER_SANITIZE_STRING));
	$value_id       = substr($value_name, strrpos($value_name, "_") + 1);
	$select         = "";
	$result_array   = "";
        
	$main_db = new db();
	
	$query = $main_db -> sql_execute("select fw.field_txt from ".DB_USER_NAME.".wb_form_field fw where lower(fw.field_name) = lower('".$value_name."') and abs(fw.id_wb_form_field) = '".$value_id."'");		
        BasicFunctions::end_session(); 
	while ($main_db -> sql_fetch($query)) {
		$select = $main_db -> sql_result($query, "FIELD_TXT");
	}
	
	$result_array = BasicFunctions::get_select_data($main_db, $select, $parent_id);	
	echo $result_array;