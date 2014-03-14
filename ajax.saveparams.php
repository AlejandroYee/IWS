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
	$pwd = base64_decode(filter_input(INPUT_POST, 'password',FILTER_SANITIZE_STRING));
	$usr = filter_input(INPUT_POST, 'username',FILTER_SANITIZE_STRING);
	$user_auth -> is_user($usr,$pwd);
        if ($user_auth -> is_user()) {
			$udb = new db();
			$responce = "true";
		} else {                        
			$responce = "false";
                        BasicFunctions::to_log("ERR: USER LOGIN FILED!",$usr);
		}		
		echo $responce;
exit;
}

if (!$user_auth -> is_user()) {
	BasicFunctions::clear_cache();
	die("Доступ запрещен");
}
  
if ($act == "check_version") {
    BasicFunctions::to_log("LIB: Checking for new version....");	
    $fv =  file_get_contents(UPDATE_SITE . "/version.json");
    if ($fv) {
        echo $fv;
    } else {
        BasicFunctions::to_log("LIB: Check version filed! no internet access or proxy file.");
    }
    exit;    
}

if ($act == "get_history") {
    BasicFunctions::to_log("LIB: New version is avalable, getting changelog...");
    $fv = file(UPDATE_SITE . "/history.txt");
    if ($fv) {        
         for ($i = 1; $i < count($fv); $i++) {
                if (trim($fv[$i]) == "//--------------------------------------------------------------------------------------------------------//") {
                 die();   
                }  
             echo $fv[$i]."<br>";
         }
    }  
    exit;    
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

if ($act == "update_to_lastest_version") {
 function delTree($dir) { 
   $files = array_diff(scandir($dir), array('.','..')); 
    foreach ($files as $file) { 
      (is_dir($dir.DIRECTORY_SEPARATOR.$file)) ? delTree($dir.DIRECTORY_SEPARATOR.$file) : unlink($dir.DIRECTORY_SEPARATOR.$file); 
    } 
    return rmdir($dir); 
} 
function recurse_copy($src,$dst) { 
    if (!is_dir($src)) {
        exit; 
    }
    $dir = opendir($src); 
    if (!is_dir($dst)) {
        mkdir($dst); 
    }
    while(false !== ( $file = readdir($dir)) ) { 
        if (( $file != '.' ) && ( $file != '..' )) { 
            if ( is_dir($src . DIRECTORY_SEPARATOR . $file) ) { 
                recurse_copy($src . DIRECTORY_SEPARATOR . $file,$dst . DIRECTORY_SEPARATOR . $file); 
            } 
            else { 
                copy($src . DIRECTORY_SEPARATOR . $file,$dst . DIRECTORY_SEPARATOR . $file); 
            } 
        } 
    } 
    closedir($dir); 
}
function update_db($folder) {     
    $ver_db = $main_db -> get_settings_val('ROOT_DB_VERSION');
    // Применяем файл базы данных
                    $db_file = $folder."configurations".DIRECTORY_SEPARATOR."db_".DB."_update_".$ver_db."_to_".trim($dt["version"]).".sql";
                    if (is_file($db_file)) {
                        if (VERSION_ENGINE == trim($dt["previos"])) {
                            $main_db -> sql_execute(file_get_contents($db_file)); 
                        } else {
                            echo "Файлы системы обновлены до последней версии, но обновление БД неудалось. Вам необходимо вручную запустить все файлы по порядку из папки 'configurations'".
                                 " которые начинаются с версии ".$ver_db." до версии ".$dt["version"]. " по всем вопросам обратитесь к update.txt в папке configurations.";
                        }    
                    }    
}
 // проверяем привелегии
 $query = $main_db -> sql_execute("select decode(count(t.id_wb_main_menu), 0, 'false', 'true') as is_administator  from wb_main_menu t where used = 1 and (wb.get_access_main_menu(t.id_wb_main_menu) = 'enable' or t.name is null) and t.id_parent is null   and t.num = 999");
    while ($main_db -> sql_fetch($query)) {             
       $is_administator =  $main_db -> sql_result($query, "is_administator");
    }
    
  if (isset($is_administator) and (defined("UPDATE_SITE"))) {  
        // пытаемся обновить систему сами:
        $fv =  file_get_contents(UPDATE_SITE . "/version.json");
        if ($fv) {
            BasicFunctions::requre_script_file("lib.json.php");
            $json = new json(); 
            $dt = $json -> jsondecode($fv,true);
            if(VERSION_ENGINE != trim($dt["version"])) {
                if (is_dir(ENGINE_ROOT. DIRECTORY_SEPARATOR . ".git")) {
                 // Обновляемся через гит
                 exec("git pull 2>&1",$output,$comm);
                 if($comm != 0) {
                     echo "Ошибка работы GIT:<br>";
                     echo implode("<br>\n",$output);
                 } else {
                       update_db("");                     
                 }
                } else {
                // Обновляемся до релиза:  
                 $fv_z =  file_get_contents($dt["link"]);
                 if ($fv_z) {
                     $tmp_file = tempnam(sys_get_temp_dir(), rand(5, 15)."_iws_update.zip"); //скачать
                     if(file_put_contents($tmp_file,$fv_z)) { // сохранить
                          exec("unzip -o ".$tmp_file." -d ".ENGINE_ROOT." 2>&1",$output,$comm);       // распаковать                    
                                if($comm == 0) {
                                    $dir_input_name = "IWS-" .$dt["version"];// директория с новым релизом
                                    // Применяем файл базы данных
                                    update_db($dir_input_name.DIRECTORY_SEPARATOR);                                                                
                                    // отчищаем папки и файлы:
                                    delTree("configurations");
                                    delTree("jscript");
                                    delTree("library");
                                    delTree("themes");
                                    $files = array_diff(scandir(ENGINE_ROOT . DIRECTORY_SEPARATOR), array('.','..')); 
                                    foreach ($files as $file) {                                       
                                        if (!is_dir($file) and (!strstr($file, "config.") and (strstr($file, ".php")))) {
                                            unlink($file);
                                        }
                                    }
                                    // Перемещаем все файлы из директории в корень:
                                    recurse_copy($dir_input_name,ENGINE_ROOT);
                                    delTree($dir_input_name);                                    
                                 } else {
                                    echo "Ошибка работы UNZIP:<br>";
                                    echo implode("<br>\n",$output);
                                }   
                     } else {
                       echo "Неудалось записать временный файл.";   
                     }                     
                 } else {
                     echo "Неудалось скачать файл Обновления системы, ошибка сервера, либо сервер недоступен.";  
                 }    
                }
            }  else {                
                echo "Обновление не требуется, у вас система самой последней версии.";  
            }    
          } else {
         echo "Неудалось скачать файл обновления, возможно нет доступа в интернет на сервере, и/или прокси сервер ненастроен.";   
        } 
      // Проверяем обновления БД
    } else {
    echo "У вас недостаточно привилегий для обновления.";  
  }    
  exit;  
}

// Дополнительная проверка на пользователя и права доступа:
$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
while ($main_db -> sql_fetch($query_check)) {
	$check= explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON"))));
}
// если пользователю недоступна форма, то выходим сразу
if (empty($check)) die("Доступ запрещен");

$query_val = $main_db->sql_execute("select t.field_name from ".DB_USER_NAME.".wb_form_field t where t.id_wb_mm_form = ".$id_mm_fr." order by t.num");
    while ($main_db-> sql_fetch($query_val)) {
                $field_name = filter_input(INPUT_GET, $main_db->sql_result($query_val, "FIELD_NAME"),FILTER_SANITIZE_STRING,FILTER_NULL_ON_FAILURE);                
		if (trim($field_name) != "") {
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
                    $rowid1 = "";
			if (!is_numeric($rowid)) {
				// Если у нас не число, то возможно переданы числа или текст через зяпятую. проверяем и формируем:
				$tmp=explode(",",$rowid);
				$rowid = "";
				
				// пробегаемся по массиву и смотрим  на типы числе или
				foreach($tmp as $key => $val) if (!is_numeric ($val)) {
					$rowid .= "'".$val."',";			
				} else {
					$rowid .= $val.",";			
				}
				
				// Чистим от последней запятой, и выполняем
				$rowid1 = trim($rowid,",");
			} else {
                                $rowid1 = trim($rowid);
                        }    
			$str_block = str_ireplace(":rowid",$rowid1,$str_block);
		}
		$sql_block = new db(true);
                
                $str_block = str_ireplace("&#39;", "'", $str_block); // Транслируем кавычки
                
		BasicFunctions::end_session();
		$sql_block -> sql_execute($str_block); 	
		$sql_block -> __destruct();
    }
	
// Если задано выполнение команды, то выполняем
if (!empty($action_bat)) {
	exec($action_bat);
}

$main_db -> __destruct();