<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
class AUTH {
	function is_user($user = false,$pass = false) {	
		// Пробуем узнать если ли у нас переменная сейсии:
		if (isset($_SESSION['us_name']) and isset($_SESSION['us_pr'])) {			
			// распаковываем пароль
			$pwd = base64_decode($this->decrypt($_SESSION['us_pr'],session_id()));
			if (!empty($pwd)) {			
				// пытаемся приверить пользователя, даже если он пройдет проверку, то потом отвалится от лдап
				if ($this->check_ldap_user(Convert_quotas($_SESSION['us_name']), $pwd)) {
					// все хорошо, работаем дальше
					return true;
				}
			}
		}
		
		// Возможно нам передали логин пароль
		if (($user != false) and ($pass != false)) {
			if (!empty($pass)) {			
				// пытаемся приверить пользователя по ldap
				if ($this->check_ldap_user($pass, $pwd)) {
					if ($this -> save_user($user,$pass)) {
						// все хорошо, работаем дальше
						return true;
					} else {
						return false;
					}
				}				
			}
		}	
		
		return false;
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
		$ldap = ldap_connect(AUTH_DOMAIN,AUTH_PORT);
		if ($ldap) {		
			ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
			if(@ldap_bind($ldap,$user."@".AUTH_DOMAIN,$pass)) {
				return true;	
			} else {
				to_log("ERR: User login failed! Broken user name or password.");
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
		$block = mcrypt_get_block_size('des', 'ecb');
		$pad = ord($str[($len = strlen($str)) - 1]);
		return substr($str, 0, strlen($str) - $pad);
	}
}
?>