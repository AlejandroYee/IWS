<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
class AUTH {
	function is_user($user = false,$pass = false) {		
		// Обычная заглушка
		$_COOKIE['us_name'] = AUTH_USER_NAME;
		return true;
	}
	
	static function get_about() {
		return "Аунтефикация через переопределенное имя пользователя";
	}
	
	static function get_user() {
		return AUTH_USER_NAME;
	}
	
	static function clear_user() {
		null;
	}
	
}
?>