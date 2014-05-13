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
	
// Проверка на пользователя
$user_auth = new AUTH();	
if ($user_auth -> is_user() !== true) {
		BasicFunctions::to_log("ERR: User maybe not loggen, from no: ".filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT)."!");
		BasicFunctions::clear_cache();
		die("Доступ запрещен");
	}
       
$main_db 	= new db();

$type                   = filter_input(INPUT_GET, 'type',FILTER_SANITIZE_STRING);
$id_mm                  = filter_input(INPUT_GET, 'id_mm',FILTER_SANITIZE_STRING);
$id_mm_fr   		= filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT); 
$id_mm_fr_d 		= filter_input(INPUT_GET, 'id_mm_fr_d',FILTER_SANITIZE_NUMBER_INT);
$type_of_past 		= filter_input(INPUT_POST, 'oper',FILTER_SANITIZE_STRING); 
$oper    		= filter_input(INPUT_GET, 'oper',FILTER_SANITIZE_STRING); 
$Master_Table_ID 	= filter_input(INPUT_GET, 'Master_Table_ID',FILTER_SANITIZE_STRING);

if (empty($id_mm)) {
    $id_mm      	= filter_input(INPUT_POST, 'id',FILTER_SANITIZE_STRING);
}

if (($type == 'GRID_FORM_DETAIL') or ($type == 'TREE_GRID_FORM_DETAIL')) {
    $id_mm_fr = $id_mm_fr_d;
}

$file_data_path		= "";
$action_bat		= "";
$file_data_action 	= "";
$str_sql_fl		= "";
$str_sql_data		= "";
$str_sql		= "";
$value			= "";
$check			= "";

// Дополнительная проверка на пользователя и права доступа:
$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable' and tf.is_read_only = 0");
while ($main_db -> sql_fetch($query_check)) {
	$check	= explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON") )));
}
// если пользователю недоступна форма или она только для чтения, то выходим сразу
if (empty($check)) {
    die("Доступ для изменения запрещен"); 
}

// Теперь смотрим есть ли определенные права
switch ($type_of_past) {
	case 'add':		
            if (array_search("A", $check) === false) {
            die("Нет привелегий для добавления строк");
        }
        break;			
	case 'del': 
            if (array_search("D", $check) === false) {
            die("Нет привелегий для удаления строк");
        }
        break;
	case 'edit':
            if (array_search("E", $check) === false) {
            die("Нет привелегий для изменения строк");
        }
        break;	
}
// Отчищаем подзапрос от лишниих указателей на страницу:
$input_post = array();
foreach (filter_input_array(INPUT_POST) as $key => $value) {    
    
    if (filter_input(INPUT_POST, $key,FILTER_SANITIZE_STRING) != null and !empty($key)) {        
        $input_post[substr($key, 0, strrpos($key, "-"))] = htmlspecialchars_decode(filter_input(INPUT_POST, $key,FILTER_SANITIZE_STRING),ENT_QUOTES,HTML_ENCODING); 
    } 
    if (is_array($value) and !empty($key)) {
        $input_post[substr($key, 0, strrpos($key, "-"))] = htmlspecialchars_decode(implode(",",filter_var_array($value,FILTER_SANITIZE_STRING)),ENT_QUOTES,HTML_ENCODING);  
    }
    if (empty($value) and (array_search(substr($key, 0, strrpos($key, "-")),$input_post) === false)) {
        $input_post[substr($key, 0, strrpos($key, "-"))] = "null";
    }
} 
$query = $main_db -> sql_execute("select tf.owner, tf.object_name, t.name, t.field_name || '_' || abs(t.id_wb_form_field) field_name_id, t.field_name, decode(trim(t.field_type), 'D', 'to_char('||t.field_name||', ''dd.mm.yyyy hh24:mi:ss'') '||t.field_name,t.field_name) f_name,
								    ta.html_txt align_txt, tf.xsl_file_in, trim(t.field_type) field_type, tf.action_sql, tf.action_bat from ".DB_USER_NAME.".wb_mm_form tf
									left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
									where tf.id_wb_mm_form = ".$id_mm_fr."  and t.is_read_only = 0 order by t.num");	
									
// Формируем поля для запроса
while ($main_db -> sql_fetch($query)) {
   	if (($main_db -> sql_result($query, "FIELD_NAME") <> "R_NUM") and ( isset($input_post[$main_db -> sql_result($query, "FIELD_NAME_ID")]) or
                isset($_FILES[$main_db -> sql_result($query, "FIELD_NAME")])) or ($main_db -> sql_result($query, "FIELD_NAME") == "ID_PARENT")) {
            if ($main_db -> sql_result($query, "FIELD_NAME") != "ID_PARENT" and isset($input_post[$main_db -> sql_result($query, "FIELD_NAME_ID")])) {
				$value =  iconv(HTML_ENCODING,LOCAL_ENCODING,$input_post[$main_db -> sql_result($query, "FIELD_NAME_ID")]); // кодировочку меняем                
            }    else {
				$value = "";
			}
		// Если родительский дерева и мы обновляем запись, то:                
		if ((($type == "TREE_GRID_FORM_MASTER") or ($type == "TREE_GRID_FORM") or ($type == "TREE_GRID_FORM_DETAIL")) and ($main_db -> sql_result($query, "FIELD_NAME") == "ID_PARENT")) {                    
			// только если добавляем запись:
			if ($type_of_past == 'add') {
				// Взможно это корневой уровень
				if (empty($id_mm_fr_d)) {
						$str_sql_data .= ", null";
					} else {
						if (is_numeric($id_mm_fr_d)) {
								$str_sql_data .= ",".$id_mm_fr_d;
							} else {
								$str_sql_data .= ", '".$id_mm_fr_d."'";
						}
				}
				if ($main_db -> sql_result($query, "FIELD_TYPE") <> 'P') {
						$str_sql_fl .= ",".$main_db -> sql_result($query, "FIELD_NAME");
				}
			}
			continue;
		} else {
			$str_sql_fl .= ",".$main_db -> sql_result($query, "FIELD_NAME");			
		}
        $data_action = $main_db -> sql_result($query, "ACTION_SQL");            
		// Смотрим на тип переменных						
		switch (strtoupper(trim($main_db -> sql_result($query, "FIELD_TYPE")))) {
				case 'D':
                                case 'DT':
                                            if (trim($value) != "null") {
                                                if (strlen($value) < 3) {
                                                    $value = "null";
                                                } else {
                                                     $value = "'".trim($value)."'";
                                                }
                                            } 
                                            if (stripos($value,":") > 0) {
                                                $str_sql_data .= ", to_date(".$value.", 'dd.mm.yyyy hh24:mi:ss')";										
                                            } else {
                                                $str_sql_data .= ", to_date(".$value.", 'dd.mm.yyyy')";
                                            }
				break;
				case 'I':
					if (trim($value) != "null") {
							$str_sql_data .= ",".intval($value);
						} else {
							$str_sql_data .= ", null";
						}
				break;
				case 'B': 
                                        if (trim($value) == "null") {
                                             $value = 0;
                                        }
					$str_sql_data .= ", ".trim($value);				
				break;
				case 'N':
						$str_sql_data .= ",".floatval(str_replace(",",".",$value));
				break;
				case 'P':
					if (trim($value) != "null") {
						$str_sql_data .= ",'".md5($value)."'";
					} else {
                                                $str_sql_data .= ", null";
                                        }    
				break;
				case 'C':
                                case 'NL':
						$str_sql_data .= ",".floatval(str_replace(",",".",$value));
				break;
				case 'F':						
						if (isset($_FILES[$main_db -> sql_result($query, "FIELD_NAME")])) {
							if(!rename($_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['tmp_name'], UPLOAD_DIR . "/" . $main_db -> sql_result($query, "XSL_FILE_IN") . "/" . iconv(HTML_ENCODING,LOCAL_ENCODING,$id_mm."_".$_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['name']))) {
								BasicFunctions::to_log("ERR: Filed upload file!");
							}
							$file_data_field = $main_db -> sql_result($query, "XSL_FILE_IN");
							$str_sql_data .= ", '".iconv(HTML_ENCODING,LOCAL_ENCODING,$_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['name'])."'";
							$action_bat = $main_db -> sql_result($query, "ACTION_BAT");
							$type_of_past = $oper;
						} else {
							$str_sql_data .= ", null";
						}
				break;
				case 'FB':
						if (isset($_FILES[$main_db -> sql_result($query, "FIELD_NAME")])) {
							$str_sql_data .= ", '".iconv(HTML_ENCODING,LOCAL_ENCODING,$_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['name'])."'";							
							$file_data_path = $_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['tmp_name'];
							$file_data_field = $main_db -> sql_result($query, "FIELD_NAME")."_CONTENT";
							$type_of_past = $oper;
						} else {
							$str_sql_data .= ", null";
						}
				break;
				default:
						if (trim($value) != "null") {
								$value = "'".$value."'";
							}   
					$str_sql_data .= ",".$value;
				break;
		}
	}	
	
	$owner      = $main_db -> sql_result($query, "OWNER");
	$table_name = $main_db -> sql_result($query, "OBJECT_NAME");	
}			
		
// Если это таблица деталей:
if (($type == 'GRID_FORM_DETAIL') or ($type == "TREE_GRID_FORM_DETAIL")) { 
	$str_sql_fl 	  .= ", ".$Master_Table_ID;
	if (is_numeric($id_mm)) {
			$str_sql_data .= ", ".$id_mm;
		} else {
			$str_sql_data .= ", '".$id_mm."' ";
	}	
	$id_mm = filter_input(INPUT_POST, 'id',FILTER_SANITIZE_STRING);
}

// Проверяем на массим входящюю переменную строки:
if (!is_numeric ($id_mm)) {
	// Если у нас не число, то возможно переданы числа или текст через зяпятую. проверяем и формируем:
	$tmp=explode(",",$id_mm);
        $id_mm1 = "";
	// пробегаемся по массиву и смотрим  на типы число или массив
	foreach($tmp as $val) if (!is_numeric ($val)) {
		$id_mm1 .= "'".$val."',";			
	} else {
		$id_mm1 .= $val.",";			
	}
	
	// Чистим от последней запятой, и выполняем
	$id_mm = trim($id_mm1,",");
}

// Смотрим на текущие действие
switch ($type_of_past) {
	// Добавляем запись
	case 'add':	
		// Формируем запрос		
		$str_sql = "insert into ".$owner.".".$table_name." (".trim($str_sql_fl, ", ").") values (".trim($str_sql_data,", ").") returning ID_".$table_name." into :rid";		
	break;
			
	// Удаляем запись
	case 'del': 
		$str_sql = "delete from ".$owner.".".$table_name." where ID_".$table_name." in (".$id_mm.")" ;
	break;
			
	// Изменяем запись
	case 'edit':
		$str_sql = "update ".$owner.".".$table_name." set (".trim($str_sql_fl, ", ").") = (select ".trim($str_sql_data,", ")." from dual) where  ID_".$table_name." in (".$id_mm.")";
	break;
	
}    

// Выполняем запрос
$return_id = $main_db -> sql_execute($str_sql); 

// В случае если есть переменная файла, то загружаем его в блоб, используем ораклячую привязку, обязательно нужно тригером обработать потом
if (!empty($file_data_path) and !empty($file_data_field)) {
	// Отчищаем клоб и загружаем данные	
	$main_db_2 = new db(true);	
	$main_db_2 -> sql_execute("update ".$owner.".".$table_name." set ".$file_data_field." = null where ID_".$table_name." = '$id_mm'");
	BasicFunctions::to_log("Load binary file to ".$owner.".".$table_name." ... WHERE ID_".$table_name." = ".$id_mm);
        BasicFunctions::requre_script_file("lib.gz.php");
	$filedata = str_split(base64_encode(gz::gzencode_zip(file_get_contents($file_data_path))), 2048);
		 foreach($filedata as $File_data_str) {
			$main_db_2 -> sql_execute("update ".$owner.".".$table_name." set ".$file_data_field." = ".$file_data_field." || '".$File_data_str."' WHERE ID_".$table_name." = '$id_mm'");
		}
	$main_db_2 -> __destruct();
}

// Если есть скрипт то запускаем скрипт
if (!empty($data_action)) {
	$main_db_2 = new db(true);	
	BasicFunctions::end_session();
    $to_exec = str_ireplace("&#39;", "'", str_replace(":ID_".$table_name,"'$id_mm'",$data_action));        
	$return_id = $main_db_2 -> sql_execute($to_exec);	
	$main_db_2 -> __destruct();	
}

// Если задано выполнение команды, то выполняем
if (!empty($action_bat)) {
	BasicFunctions::end_session();
	exec($action_bat);
}

// Отправляем что обновление данных выполнено для файлов
if (is_resource($return_id)) {
	if (!empty($file_data_field)) if (strpos(HTTP_USER_AGENT, 'MSIE') === false) {
			echo $return_id;  
		} else {
			echo "&nbsp;&nbsp;";// Отправляем пустую строку эксплореру, для формальности загрузки данных
	}
} else {
	echo $return_id;
}
$main_db -> __destruct();