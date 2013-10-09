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
				if (!defined("AUTH_DB_USER_NAME")) define("AUTH_DB_USER_NAME",Convert_quotas($_SESSION['us_name']));
				if (!defined("AUTH_DB_PASSWORD")) define("AUTH_DB_PASSWORD",$pwd);	
				
				// проверка на неактивность сейсии:
				if (isset($_SESSION['us_time']) and ((intval($_SESSION["us_time"]) + 60*60) < time())) {
					to_log("LIB: OCI timeout... relogin.");
					return false;
				}
				// пытаемся приверить пользователя
				if (db::connect_db() !== false) {
					// все хорошо, работаем дальше
					$_SESSION["us_time"] = time();
					return true;
				} else {
					return false;
				}
			}
		}
		
		// Возможно нам передали логин пароль
		if (($user != false) and ($pass != false)) {
			if (!empty($pass)) {
				// пытаемся приверить пользователя по ldap
				if (!defined("AUTH_DB_USER_NAME")) define("AUTH_DB_USER_NAME",$user);
				if (!defined("AUTH_DB_PASSWORD"))  define("AUTH_DB_PASSWORD",$pass);			
				// пытаемся приверить пользователя
				if (db::connect_db() !== false) {
					if ($this -> save_user($user,$pass)) {
						// все хорошо, работаем дальше
						return true;
					} else {
						return false;
					}
				} else {
					return false;
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
		return "Авторизация через базу данных ORACLE";
	}
	

	private function save_user($user,$pass) {	
		// Шифруем пароль
		$key = $this->encrypt(base64_encode($pass),session_id());
		$_SESSION["us_name"] = $user;
		$_SESSION["us_pr"]   = $key;
		$_SESSION["us_time"] = time();
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
?>