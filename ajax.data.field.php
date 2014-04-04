<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Dinamycs data fo elements
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	BasicFunctions::requre_script_file("db.".DB.".php");
	header("Content-type: text/script;charset=".HTML_ENCODING);
	
        $parent_id      = filter_input(INPUT_GET, 'parent_id',FILTER_SANITIZE_STRING);
        $type           = filter_input(INPUT_GET, 'type',FILTER_SANITIZE_STRING);
	$value_name     = filter_input(INPUT_GET, 'value_name',FILTER_SANITIZE_STRING);
        $value_id       = substr(substr($value_name, strrpos($value_name, "_") + 1), 0, strrpos(substr($value_name, strrpos($value_name, "_") + 1), "-"));
	$query_field    = "";
        
	$main_db = new db();
	
	$query = $main_db -> sql_execute("select fw.field_txt from ".DB_USER_NAME.".wb_form_field fw where lower(fw.field_name) = lower('".BasicFunctions::trim_fieldname($value_name)."') and abs(fw.id_wb_form_field) = '".$value_id."'");		
        
        BasicFunctions::end_session(); 
	while ($main_db -> sql_fetch($query)) {
		$query_field = $main_db -> sql_result($query, "FIELD_TXT");
	}
        
        // пробуем прибиндить переменные если они есть в посте, но сначала формируем массив
        $input_post = array();
        if (filter_input_array(INPUT_POST)) {
            foreach (filter_input_array(INPUT_POST) as $key => $value) {    
                if (filter_input(INPUT_POST, $key,FILTER_SANITIZE_STRING) != null and !empty($key)) {        
                    $input_post[":" . BasicFunctions::trim_fieldname(substr($key, 0, strrpos($key, "-")))] = filter_input(INPUT_POST, $key,FILTER_SANITIZE_STRING);  
                } 
                if (is_array($value) and !empty($key)) {
                    $input_post[":" . BasicFunctions::trim_fieldname(substr($key, 0, strrpos($key, "-")))] = implode(",",filter_var_array($value,FILTER_SANITIZE_STRING));  
                }
            } 
        }
        
        // заменяем значения:
        if (!empty($input_post)) {
            foreach ($input_post as $key => $value) {
                if (!is_numeric($value)) {
                   $value = "'".$value."'";
                }
                 $query_field =  str_ireplace($key,$value,$query_field);
            }
        }
        
	switch ($type) {
          case 'select':  
            // возвращаем селект  
            echo BasicFunctions::get_select_data($main_db, $query_field, $parent_id);
          break;
          case 'field':  
            //выполняем и возвращаем значение (должно быть только одно!)
            $query_field = str_ireplace("&#39;", "'", $query_field);  
            $query_sub = $main_db -> sql_execute($query_field);	
            while ($main_db -> sql_fetch($query_sub)) {
		echo $main_db -> sql_result($query_sub, 1);
            }              
          break;
        }