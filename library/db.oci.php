<?
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Класс базы данных для связи с ORACLE DB
//--------------------------------------------------------------------------------------------------------------------------------------------
class db{
var $link, $user_pref, $user_real_name,$session_id_local;
private $arhive_sql,$vields_sql = [];

	function __construct($new_descript = false) {	
	$ora = $this -> connect_db($new_descript);
	
		if (!$ora) {		
			$err_array = oci_error();				
			BasicFunctions::to_log("ERR: ".$err_array['message']);
			die("<p align='left' >".iconv(LOCAL_ENCODING,HTML_ENCODING,str_replace(array("\r\n", "\n",),"<br>",str_replace(array("    ","   ","  ")," ",$err_array['message'])))."</p>");
		
		} else {
		
            $this->link = $ora;	
				// Проверяем на присутсвие пользователя в базе:
				$load_data = BasicFunctions::load_from_cache("user_prefs");
				if ($load_data) {
							$this -> user_real_name = $load_data['real_name'];
							$this -> user_pref = $load_data['userprf'];								
					} else {				
						if (DB_USER_NAME != "wb") { // костыль если используется пользователь WB!
								$query = OCI_Parse($this->link,"select t.id_wb_user, t.name, t.param_view from ".DB_USER_NAME.".wb_user t where t.wb_name = upper('".auth::get_user()."')");
							} else {
								$query = OCI_Parse($this->link,"select t.id_wb_user, t.name, t.param_view from wb_user t where t.wb_name = upper('".auth::get_user()."')");
						}
						OCI_Execute($query);
						while (oci_fetch($query)) {
							$this -> user_real_name = iconv(LOCAL_ENCODING,HTML_ENCODING,oci_result($query,"NAME"));
							$this -> user_pref = oci_result($query,"PARAM_VIEW");							
							$load_data['real_name'] = $this -> user_real_name;
							$load_data['userprf'] = $this -> user_pref;
							BasicFunctions::save_to_cache("user_prefs", $load_data, null);
						}
				}
				// ОК, регистрируемся в системе
				if (strtolower(DB_USER_NAME) != "wb") { // костыль если используется пользователь WB, из-за того что у нас пакет WB!
					OCI_Execute(OCI_Parse($this->link,"begin ".DB_USER_NAME.".wb.save_wb_user(upper('".auth::get_user()."')); end;"));
				} else {
					OCI_Execute(OCI_Parse($this->link,"begin wb.save_wb_user(upper('".auth::get_user()."')); end;"));
				}
				// При написани вьюх Павел неуказал формат для функций to_number, по этому мы жестко привязываемся к тому что на сервере формат
				// дробной части начинается на точку.
				OCI_Execute(OCI_Parse($this->link,"alter session set NLS_NUMERIC_CHARACTERS= '.,'"));
				return true;
		}

	}
	
	// Соединение с базой данных, false в случае проблемы, возвращает указатель
    static function connect_db($is_new = false) {	
	
		if (defined("AUTH_DB_USER_NAME")) {
				$USER_NAME = AUTH_DB_USER_NAME;
			} else {
				$USER_NAME = DB_USER_NAME;
		}
		
		if (defined("AUTH_DB_PASSWORD")) {
				$PASSWORD = AUTH_DB_PASSWORD;
			} else {
				$PASSWORD = DB_PASSWORD;
		}
		
		if (defined("AUTH_DB_NAME")) {
				$NAME = AUTH_DB_NAME;
			} else {
				$NAME = DB_NAME;
		}
		
		if ($is_new) {
				$connection = oci_new_connect($USER_NAME,
								   $PASSWORD,
								   $NAME,
								   DB_ENCODING);
			} else {
				$connection = oci_connect($USER_NAME,
								   $PASSWORD,
								   $NAME,
								   DB_ENCODING);
		}		
		return $connection;
	}	
	
	// Загрузка параметров системы
	//------------------------------------------------------------------------------------------------------------------------------------------------
	public function get_settings_val($param_name) {
		$load_data = BasicFunctions::load_from_cache($param_name);
		if ($load_data) {
			return $load_data;
		} else {
			$query = $this->sql_execute("Select ".DB_USER_NAME.".wb_sett.get_settings_val_char(upper('".$param_name."')) column_value from dual");
				while ($this-> sql_fetch($query)) {
                                    $param_value = $this->sql_result($query, "COLUMN_VALUE"); 
                                }
			BasicFunctions::save_to_cache($param_name, $param_value, null);
			return $param_value;
		}
		
	}
	
	// Загрузка срузку нескольких параметров системы в массив
	//------------------------------------------------------------------------------------------------------------------------------------------------
	public function get_settings_many_val($param_name) {
		$load_data = BasicFunctions::load_from_cache($param_name);
		if ($load_data) {
			return $load_data;
		} else {
			$query = $this->sql_execute("Select t.column_value from table(".DB_USER_NAME.".wb_sett.get_settings_many_val_char(upper('".$param_name."'))) t");
			$param_value = array();
				while ($this-> sql_fetch($query)) { 
                                        $param_value[] =  $this->sql_result($query, "COLUMN_VALUE");
                                }
			BasicFunctions::save_to_cache($param_name, $param_value, null);
			return $param_value;
		}
	}
	
	// Обеспечиваем корректное завершение базы 
	public function __destruct() {				
		if (is_resource($this->link)) {			
			oci_close($this->link);
		}
	}
	
	static function get_about() {
		return "Модуль для работы Oracle OCI v8";
	}

	// Выполнение скрипта пользователя
	public function sql_execute($sql) { 
	
		if (strtolower(DB_USER_NAME) == "wb") {		 // костыль если пользователь WB!
			$sql =  str_ireplace(array("wb.wb.","WB.WB."),"wb.", $sql);
		}               
                if (empty($sql)) {                    
                    BasicFunctions::to_log("ERR: Empty sql query!");
                } else {                
                    BasicFunctions::to_log("SQL: <".$this->link."> ".trim($sql).";");
                }
		$rowid = "";
		
		// Парсим запрос
		$res = OCI_Parse($this->link, $sql);
		
		// Если инсерт и есть ретурнинг то забиваем переменную
		if (strpos(strtolower($sql),"returning") > 0 ) {			
			oci_bind_by_name($res, ":rid", $rowid, -1, SQLT_INT);			
		} 
		$this -> arhive_sql = $sql;
		// Выполняем
		if (!OCI_Execute($res)) {
				// Проверяем еще раз на наличе ретурна, и если есть убираем его и отдаем в обработку заново:
				if (strpos(strtolower($sql),"returning") > 0 ) {
					$sql = substr($sql,0, strpos(strtolower($sql),"returning"));
					$res = OCI_Parse($this->link, $sql);
					// Полюбому вернется контекст!
					if (OCI_Execute($res)) {
							$res2 = OCI_Parse($this->link,"select SYS_CONTEXT ('CLIENTCONTEXT', 'rowid' ) as row_id from dual");
							OCI_Execute($res2);
							while (OCI_Fetch($res2)) {
                                                            $rowid = oci_result($res2,'ROW_ID');                                                        
                                                        }							
						} else {
							$err_array = oci_error($res);					
							// если нет то умираем
							BasicFunctions::to_log("ERR: ".$err_array['message']);
							die("<p align='left' >".iconv(LOCAL_ENCODING,HTML_ENCODING,str_replace(array("\r\n", "\n",),"<br>",str_replace(array("    ","   ","  ")," ",$err_array['message'])))."</p>");
						}
				} else {					
					$err_array = oci_error($res);					
					// если нет то умираем
					BasicFunctions::to_log("ERR: ". $err_array['message'],true);
					die("<p align='left' >".iconv(LOCAL_ENCODING,HTML_ENCODING,str_replace(array("\r\n", "\n",),"<br>",str_replace(array("    ","   ","  ")," ",$err_array['message'])))."</p>");
				}
		}
                // заполняем массив столбцов
                $this -> vields_sql = [];		
                for ($i = 1; $i <= oci_num_fields($res); $i++) {
                    $this -> vields_sql[] = strtoupper(oci_field_name($res, $i));
                }    
		// Если был ретурнинг то отдаем вместо ресурса вернувшиеся значение
		if (!empty($rowid)) {
					BasicFunctions::to_log("SQL: <".$this->link."> returning id ".$rowid." is a reached;");
					return $rowid;
			} else {		
					// Возвращаем ресурс для извлечения данных
					return $res; 
		}
	}
	
	// Парсинг строк в таблице
	public function sql_fetch($sql) { return OCI_Fetch($sql); }
	
        // Проверяем есть ли в массиве наше имя столбца
        public function sql_has_field($sql,$name) {
            $name   = str_ireplace(array("&QUOT;","&quot;"), "", strtoupper(trim($name)));
            if (array_search($name,$this -> vields_sql) !== false) {
                    return true;
            } else {
                    return false;
            }    
        }
	
	// Возвращаем значение нужного столбца, в случае чего перекодируем
	public function sql_result($sql,$name,$encoding = true) {
                $name   = str_ireplace(array("&QUOT;","&quot;"), "", strtoupper(trim($name)));
                if (array_search($name,$this -> vields_sql) !== false) {
                    $res 	= oci_result($sql,  $name);
                    $val	= "";	

                    // Если результат CLOB или BLOB
                    if (is_object($res)) {			
                            while(!$res -> eof()){
                                    $val .= $res -> read(1024);
                            }
                    } else {
                            $val = $res;
                    }

                    // Нужна ли перекодировка:
                    if ($encoding)	{
                            $val =  iconv(LOCAL_ENCODING,HTML_ENCODING,$val);
                    }
                    return $val;
                } else {                                         
                    BasicFunctions::to_log("ERR: getting ".$name." from SQL: ".$this -> arhive_sql,true);
                    return "";
                }    
	}	
	
	// Получаем полное имя пользователя
	public function get_realname() {		
		$names = explode(" ",$this->user_real_name);
		if (count($names) > 1) {
				return $names[0]." ".mb_substr ($names[1],0,1,HTML_ENCODING).". ".mb_substr ($names[2],0,1,HTML_ENCODING).".";
			} else {
				return $this->user_real_name;
		}
	}	
	
	// Берем пользовательские параметры из базы
	public function get_param_view($param_name) {
		$is_found = false;
		$arr_field = explode(";",$this -> user_pref);
			foreach ($arr_field as $line) {
				$sub_line = explode(":", $line);
				if ($sub_line[0] == strtolower(trim($param_name))) {
					// Есть старый параметр, заменяем:
					return base64_decode($sub_line[1]);
					$is_found = true;					
				}			
			}
	    
		// Необходимо вернуть значения по умолчанию
		if (!$is_found) {
			switch (strtolower(trim($param_name))) {
				case "editabled": return "checked"; break;
				case "num_mounth": return "3"; break;
				case "render_type": return "2"; break;
				case "num_reck": return "100"; break;
			}
                }
	}
	
	// Сохраняем пользовательские параметры в базу
	public function set_param_view ($param_name, $value) {
		$sub_line_new = "";
		$is_found = false;
		// Проверка на ключ
		if (strtolower(trim($value)) == 'on' ) { 
                    $value = "checked";
                }
		$arr_field = explode(";",$this -> user_pref);
			foreach ($arr_field as $line) {
				// Смотрим значения:
				$sub_line = explode(":", $line);
				if ($sub_line[0] == strtolower(trim($param_name))) {
					// Есть старый параметр, заменяем:					
					$sub_line[1] = base64_encode($value);
					$is_found = true;					
				}
				// Склеиваем обратно:
				$sub_line_new[] = implode(":", $sub_line);
			}
		// На случай если такого параметра нет, мы его создаем:
		if (!$is_found) {
			$sub_line_new[] = strtolower(trim($param_name)).":".base64_encode($value);		
		}		
		// только в случа расхождения строк настроек мы их обновяем
		if ( ($this -> user_pref != ltrim(implode(";",$sub_line_new),";")) and (auth::get_user() != "")) {
			$this->sql_execute("update ".DB_USER_NAME.".WB_USER t set t.PARAM_VIEW = '".ltrim(implode(";",$sub_line_new),";")."' where t.WB_NAME =  upper('".auth::get_user()."')");
			$this -> user_pref = ltrim(implode(";",$sub_line_new),";");		
		}
	}
	
} 