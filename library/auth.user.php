<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
class AUTH {
	function is_user($user = false,$pass = false) {	
		// Пробуем узнать если ли у нас переменная сейсии:
		if (isset($_SESSION['us_name']) and isset($_SESSION['us_pr']) and $user == false and $pass == false) {			
				if ($this->check_user($_SESSION['us_name'], $_SESSION['us_pr'],false)) {
					return true;				
                                }                        
                }
		
		// Возможно нам передали логин пароль
		if (($user != false) and ($pass != false)) {
			if (!empty($pass)) {	
				// скорее всего это вход по этому проверям и сохраняем пароль
				if ($this->check_user($user, $pass,true)) {
					if ($this -> save_user($user,$pass)) {
						return true;
					}
				}				
			}
		}	
		
		return false;
	}
        
	private function check_user($user,$pass,$encrupt) {
            $db_con = new DB();
            if ($encrupt) {
               $pass = md5($pass);
            }    
            $sql = $db_con -> sql_execute("select count(*) as is_user from wb_user w where w.wb_name = upper('".$user."') and w.password = '".$pass."'");
            while ($db_con -> sql_fetch($sql)) {
		if ($db_con -> sql_result($sql, "is_user") > 0 ) {
                  return true;   
                }
            }
            
        }
        
        private function save_user($user,$pass) {	
		// Шифруем пароль
		$key = md5($pass);
		$_SESSION["us_name"] = $user;
		$_SESSION["us_pr"]   = $key;
                return true;
	}
	
	static function get_about() {
		return "Аунтефикация пользователя через табличку wb_users";
	}
        
	static function get_user() {
		if (isset($_SESSION['us_name'])) {
				return $_SESSION['us_name'];
		} else {
				return false;
		}
	}	
}