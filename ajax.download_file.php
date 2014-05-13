<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
require_once("library/lib.func.php");
BasicFunctions::is_offline();
BasicFunctions::requre_script_file("lib.requred.php"); 
BasicFunctions::requre_script_file("auth.".AUTH.".php");
	
$user_auth = new AUTH();	
if ($user_auth -> is_user() !== true) {
		BasicFunctions::to_log("ERR: User maybe not loggen, from no: ".filter_input(INPUT_GET, 'field',FILTER_SANITIZE_STRING)."!");
		BasicFunctions::clear_cache();
		die("Not autorised");
}
$main_db = new db();
BasicFunctions::end_session();
$data    	= filter_input(INPUT_GET, 'data',FILTER_SANITIZE_STRING);
$name    	= filter_input(INPUT_GET, 'name',FILTER_SANITIZE_STRING);
$id    		= filter_input(INPUT_GET, 'id',FILTER_SANITIZE_NUMBER_INT); 
$field    	= filter_input(INPUT_GET, 'field',FILTER_SANITIZE_STRING); 
$owner          = DB_USER_NAME;

if (!empty($field)) { // если задана переменная поля то прогружаем данные сами
   $query_field = $main_db -> sql_execute("select p.field_name,mf.owner, mf.object_name from  ".$owner.".wb_form_field p " .
                                          "inner join ".$owner.".wb_mm_form mf on mf.id_wb_mm_form = p.id_wb_mm_form " .
                                          "where p.id_wb_form_field = ".$field." and rownum = 1");
          
    while ($main_db -> sql_fetch($query_field)) {        
        $data    	= $main_db -> sql_result($query_field, "object_name");
        $name    	= $main_db -> sql_result($query_field, "field_name");
        $owner    	= $main_db -> sql_result($query_field, "owner");
    }
}


if (filter_input(INPUT_GET, 'encon',FILTER_SANITIZE_NUMBER_INT) == 0) {
	$encon = false;
} else {
	$encon = true;
}

$query = $main_db -> sql_execute("select ".$name."_CONTENT, ".$name." from ".$owner.".".$data.
                                 " where ID_".$data." = ".$id." and rownum = 1");

while ($main_db -> sql_fetch($query)) {
    header("Set-Cookie: fileDownload=true");	
    header("Content-Disposition: attachment;filename=".$main_db -> sql_result($query, $name)."");
    header("Cache-Control: max-age=0");
    $file_content = $main_db -> sql_result($query, $name."_CONTENT",$encon);	
    // Проверка на декод64
    if (base64_decode($file_content, true)) {
            //да это контент закодирован base64
            // Проверяем, возможно он запакован
            $tmp = base64_decode($file_content);
            $flags  = ord(substr($tmp,3,1)); 

            if ((strlen($tmp) < 18 || strcmp(substr($tmp,0,2),"\x1f\x8b")) or ($flags & 31 != $flags)) {
                    // Это точно не сжатие, выводим как есть
                    echo $tmp;	
            } else {
                    BasicFunctions::requre_script_file("lib.gz.php");
                    echo gz::gzdecode_zip($tmp);
            } 
    } else {
            // Это просто контент, значит просто выводим
            echo $file_content;	
    }
    BasicFunctions::to_log("Downloaded file: ".$main_db -> sql_result($query, $name));
}
$main_db -> __destruct();