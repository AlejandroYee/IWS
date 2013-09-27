<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
require_once("library/lib.func.php");
requre_script_file("lib.requred.php"); 
	
$user_auth = new AUTH();	
if (!$user_auth -> is_user()) {
		clear_cache();
		die("Доступ запрещен");
}
$main_db = new db();
end_session();

$data    	= @Convert_quotas($_GET['data']);
$name    	= @Convert_quotas($_GET['name']);
$id    		= @intval($_GET['id']);

$query = $main_db -> sql_execute("select ".strtoupper($name)."_CONTENT, ".strtoupper($name)." from ".DB_USER_NAME.".".strtoupper($data)." where ID_".strtoupper($data)." = ".$id." and rownum = 1");
while ($main_db -> sql_fetch($query)) {
header("Set-Cookie: fileDownload=true");	
header("Content-Disposition: attachment;filename=".$main_db -> sql_result($query, strtoupper($name))."");
header("Cache-Control: max-age=0");
$file_content = $main_db -> sql_result($query, strtoupper($name)."_CONTENT");	
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
		echo gzdecode_zip($tmp);
	} 
} else {
	// Это просто контент, значит просто выводим
	echo $file_content;	
}					
}
$main_db -> __destruct();
?>
