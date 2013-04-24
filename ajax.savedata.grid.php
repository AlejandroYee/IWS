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
$main_db 			= new db();

$type    			= (isset($_GET['type']))? Convert_quotas($_GET['type']) : "";

// Есть вариант когда указана строка
if (!isset($_GET['id_mm'])) {
	$id_mm			= @Convert_quotas($_POST['id']);
}  else {
	$id_mm  		= @Convert_quotas($_GET['id_mm']);
}
$id_mm_fr   		= @intval($_GET['id_mm_fr']); 
$id_mm_fr_d 		= (isset($_GET['id_mm_fr_d']))? Convert_quotas($_GET['id_mm_fr_d']) : "";
$type_of_past 		= (isset($_POST['oper']))? Convert_quotas($_POST['oper']) : "";
$Master_Table_ID 	= (isset($_GET['Master_Table_ID']))? Convert_quotas($_GET['Master_Table_ID'])  : "";	
$file_data_path		= "";
$action_bat			= "";
$file_data_action 	= "";
$str_sql_fl			= "";
$str_sql_data		= "";
$str_sql			= "";
$value				= "";


if (($type == 'GRID_FORM_DETAIL') or ($type == 'TREE_GRID_FORM_DETAIL')) $id_mm_fr = $id_mm_fr_d;
$query = $main_db -> sql_execute("select tf.owner, tf.object_name, t.name, t.field_name || '_' || abs(t.id_wb_form_field) field_name_id, t.field_name, decode(trim(t.field_type), 'D', 'to_char('||t.field_name||', ''dd.mm.yyyy hh24:mi:ss'') '||t.field_name,t.field_name) f_name,
								    ta.html_txt align_txt, tf.xsl_file_in, trim(t.field_type) field_type, tf.action_sql, tf.action_bat from ".DB_USER_NAME.".wb_mm_form tf
									left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
									where tf.id_wb_mm_form = ".$id_mm_fr."  and t.is_read_only = 0 order by t.num");	
									
// Формируем поля для запроса
while ($main_db -> sql_fetch($query)) {
	if (($main_db -> sql_result($query, "FIELD_NAME") <> "R_NUM") and (isset($_POST[$main_db -> sql_result($query, "FIELD_NAME_ID")]) or isset($_FILES[$main_db -> sql_result($query, "FIELD_NAME")]))) {
		// Вдруг у нас значения в виде массива:
		if (isset($_POST[$main_db -> sql_result($query, "FIELD_NAME_ID")])) if (is_array($_POST[$main_db -> sql_result($query, "FIELD_NAME_ID")])) {
			$value = implode(",",$_POST[$main_db -> sql_result($query, "FIELD_NAME_ID")]);
		} else {
			$value = $_POST[$main_db -> sql_result($query, "FIELD_NAME_ID")];
		}		
		$value = iconv(HTML_ENCODING,LOCAL_ENCODING, $value); // кодировочку меняем				
		// Если родительский дерева и мы обновляем запись, то:
		if ((($type == "TREE_GRID_FORM_MASTER") or ($type == "TREE_GRID_FORM") or ($type == "TREE_GRID_FORM_DETAIL")) and ($main_db -> sql_result($query, "FIELD_NAME") == "ID_PARENT")) {			
			// только если добавляем запись:
			if ($type_of_past == 'add') {
				// Взможно это корневой уровень
				if (empty($id_mm)) {
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
		// Смотрим на тип переменных						
		switch ($main_db -> sql_result($query, "FIELD_TYPE")) {
				case 'D':
						if (stripos($value,":") > 0) {
								$str_sql_data .= ", to_date('".$value."', 'dd.mm.yyyy hh24:mi:ss')";										
						} else {
								$str_sql_data .= ", to_date('".$value."', 'dd.mm.yyyy')";
						}
				break;
				case 'DT':
						if (stripos($value,":") > 0) {
								$str_sql_data .= ", to_date('".$value."', 'dd.mm.yyyy hh24:mi:ss')";										
						} else {
								$str_sql_data .= ", to_date('".$value."', 'dd.mm.yyyy')";
						}
				break;
				case 'I':
					if (trim($value) <> "") {
							$str_sql_data .= ",".@intval($value);
						} else {
							$str_sql_data .= ", null";
						}
				break;
				case 'B':
					if (@intval($value) <> 1) {
							$str_sql_data .= ", 0";
						} else {
							$str_sql_data .= ", 1";
						}
				break;
				case 'N':
						$str_sql_data .= ",".@floatval(str_replace(",",".",$value));
				break;
				case 'P':
					if (!empty($value)) {
						$str_sql_data .= ",'".Convert_quotas(md5($value))."'";
					}
				break;
				case 'C':
						$str_sql_data .= ",".@floatval(str_replace(",",".",$value));
				break;
				case 'NL':
						$str_sql_data .= ",".@floatval(str_replace(",",".",$value));
				break;
				case 'F':						
						if (isset($_FILES[$main_db -> sql_result($query, "FIELD_NAME")])) {
							if(!rename($_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['tmp_name'], UPLOAD_DIR . "/" . $main_db -> sql_result($query, "XSL_FILE_IN") . "/" . iconv(HTML_ENCODING,LOCAL_ENCODING,$id_mm."_".$_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['name']))) {
								to_log("ERR: Filed upload file!");
							}
							$file_data_field = $main_db -> sql_result($query, "XSL_FILE_IN");
							$str_sql_data .= ", '".iconv(HTML_ENCODING,LOCAL_ENCODING,$_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['name'])."'";
							$file_data_action = $main_db -> sql_result($query, "ACTION_SQL");
							$action_bat = $main_db -> sql_result($query, "ACTION_BAT");
							$type_of_past = Convert_quotas($_GET['oper']);
						} else {
							$str_sql_data .= ", null";
						}
				break;
				case 'FB':
						if (isset($_FILES[$main_db -> sql_result($query, "FIELD_NAME")])) {
							$str_sql_data .= ", '".iconv(HTML_ENCODING,LOCAL_ENCODING,$_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['name'])."'";							
							$file_data_path = $_FILES[$main_db -> sql_result($query, "FIELD_NAME")]['tmp_name'];
							$file_data_field = $main_db -> sql_result($query, "FIELD_NAME")."_CONTENT";
							$file_data_action = $main_db -> sql_result($query, "ACTION_SQL");
							$type_of_past = Convert_quotas($_GET['oper']);
						} else {
							$str_sql_data .= ", null";
						}
				break;
				
				default:
						$str_sql_data .= ",'".@Convert_quotas(str_replace("'","''",$value))."' ";
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
	$id_mm = Convert_quotas($_POST['id']);
}

// Проверяем на массим входящюю переменную строки:
if (!is_numeric ($id_mm)) {
	// Если у нас не число, то возможно переданы числа или текст через зяпятую. проверяем и формируем:
	$tmp=explode(",",$id_mm);
	$id_mm = "";
	
	// пробегаемся по массиву и смотрим  на типы числе или
	foreach($tmp as $key => $val) if (!is_numeric ($val)) {
		$id_mm .= "'".$val."',";			
	} else {
		$id_mm .= $val.",";			
	}
	
	// Чистим от последней запятой, и выполняем
	$id_mm = trim($id_mm,",");
}

// Смотрим на текущие действие
switch ($type_of_past) {
	// Добавляем запись
	case 'add':	
		// Формируем запрос		
		$str_sql = "insert into ".$owner.".".$table_name." (".substr($str_sql_fl, 1).") values (".substr($str_sql_data,1).") returning ID_".$table_name." into :rid";		
	break;
			
	// Удаляем запись
	case 'del': 
		$str_sql = "delete from ".$owner.".".$table_name." where ID_".$table_name." in (".$id_mm.")" ;
	break;
			
	// Изменяем запись
	case 'edit':
		$str_sql = "update ".$owner.".".$table_name." set (".substr($str_sql_fl, 1).") = (select ".substr($str_sql_data,1)." from dual) where  ID_".$table_name." in (".$id_mm.")";
	break;
	
}    

// Выполняем запрос
$return_id = $main_db -> sql_execute($str_sql); 

// В случае если есть переменная файла, то загружаем его в блоб, используем ораклячую привязку, обязательно нужно тригером обработать потом
if (!empty($file_data_path) and !empty($file_data_field)) {
	// Отчищаем клоб и загружаем данные	
	$main_db_2 = new db(true);	
	$main_db_2 -> sql_execute("update ".$owner.".".$table_name." set ".$file_data_field." = null where ID_".$table_name." = '$id_mm'");
	to_log("Load binary file to ".$owner.".".$table_name." ... WHERE ID_".$table_name." = ".$id_mm);					
	$filedata = str_split(base64_encode(gzencode(file_get_contents($file_data_path))), 2048);
		 foreach($filedata as $File_data_str) {
			$main_db_2 -> sql_execute("update ".$owner.".".$table_name." set ".$file_data_field." = ".$file_data_field." || '".$File_data_str."' WHERE ID_".$table_name." = '$id_mm'");
		}
	$main_db_2 -> __destruct();
}

// Файл загружен, если есть скрипт в загрузке то запускаем его:
if (!empty($file_data_action)) {
	$main_db_2 = new db(true);	
		end_session();
		$return_id = $main_db_2 -> sql_execute(str_replace(":ID_".$table_name,"'$id_mm'",$file_data_action));	
	$main_db_2 -> __destruct();	
}

// Если задано выполнение команды, то выполняем
if (!empty($action_bat)) {
	end_session();
	@exec($action_bat);
}

// Отправляем что обновление данных выполнено для файлов
if (is_resource($return_id)) {
	if (!empty($file_data_field)) if (isset($_SERVER['HTTP_USER_AGENT']) && (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') === false)) {
			echo $return_id;  
		} else {
			echo "&nbsp;&nbsp;";// Отправляем пустую строку эксплореру, для формальности загрузки данных
	}
} else {
	echo $return_id;
}
$main_db -> __destruct();
?>