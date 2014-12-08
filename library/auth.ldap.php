<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/

// Проверяем сначала модули:
if (!extension_loaded ("ldap")) die("Для работы системы IWS с аунтификацие LDAP нужен модуль php-ldap который незагружен или отсутсвует, подключите модуль.");    
if (!extension_loaded ("mcrypt")) die("Для работы системы IWS с аунтификацие LDAP нужен модуль php-mcrypt который незагружен или отсутсвует, подключите модуль."); 
if (!defined("AUTH_DOMAIN") or !defined("AUTH_PORT")) die("Для работы системы IWS с аунтификацие LDAP нужно указать параметры подключения в конфигурационном файле"); 
        
class AUTH {
	function is_user($user = false,$pass = false) {	
            $ret_val = false;
		// Пробуем узнать если ли у нас переменная сейсии:
		if (isset($_SESSION['us_name']) and isset($_SESSION['us_pr']) and $user == false and $pass == false) {			
			// распаковываем пароль
			$pwd = base64_decode($this->decrypt($_SESSION['us_pr'],session_id()));
			if (!empty($pwd) or defined("AUTH_ALLOW_GUEST")) {			
				// пытаемся приверить пользователя, даже если он пройдет проверку, то потом отвалится от лдап
				if ($this->check_ldap_user($_SESSION['us_name'], $pwd)) {
					$ret_val = true;				
                                }
                        }
                }
		
		// Возможно нам передали логин пароль
		if (($user != false) and ($pass != false)) {
			if (!empty($pass)) {	
				// пытаемся приверить пользователя по ldap
				if ($this->check_ldap_user($user, $pass)) {
					if ($this -> save_user($user,$pass)) {
						$ret_val = true;
					}
				}				
			}
		}	
		// Если пользователб у нас корявый и выставлено разрешение для гостей то определяем его как гостя
                if (defined("AUTH_ALLOW_GUEST") and $user != false and !$ret_val) {
                    if ($this -> save_user(AUTH_ALLOW_GUEST,"")) {
                        BasicFunctions::to_log("LIB: User ". strtoupper($user). " has logined as GUEST: ".AUTH_ALLOW_GUEST);
                        $ret_val = true;
                    }    
                }
		return $ret_val;
	}

	static function get_user() {
		if (isset($_SESSION['us_name'])) {
				return $_SESSION['us_name'];
		} else {
				return false;
		}
	}
	
	static function get_about() {
		return "Авторизация в домене ldap";
	}
	
	private function check_ldap_user($user,$pass) {
            if (defined("AUTH_ALLOW_GUEST") and $user == AUTH_ALLOW_GUEST ) {
                return true;
            } 
		$ldap = ldap_connect(AUTH_DOMAIN,AUTH_PORT);
		if ($ldap) {		
			ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
			if(ldap_bind($ldap,$user."@".AUTH_DOMAIN,$pass)) {
                                return true;
			} else {
				return false;
			}
	   }
	   return false;
	}	
	
	private function save_user($user,$pass) {	
		// Шифруем пароль
		$key = $this->encrypt(base64_encode($pass),session_id());
		$_SESSION["us_name"] = $user;
		$_SESSION["us_pr"]   = $key;
                return true;
	}
	
	private function encrypt($str, $key)
	{
		$block = mcrypt_get_block_size('des', 'ecb');
		$pad = $block - (strlen($str) % $block);
		$str .= str_repeat(chr($pad), $pad);
		return mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $key, $str, MCRYPT_MODE_ECB);
	}

	private function decrypt($str, $key)
	{   
		$str = mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $key, $str, MCRYPT_MODE_ECB);		
		$pad = ord($str[($len = strlen($str)) - 1]);
		return substr($str, 0, strlen($str) - $pad);
	}
}