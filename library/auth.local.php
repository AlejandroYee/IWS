<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/

if (!defined("AUTH_USER_NAME")) die("Для работы системы IWS с аунтификацие LOCAL нужно указать параметры подключения в конфигурационном файле"); 
class AUTH {
	function is_user($user = false,$pass = false) {		
		// Обычная заглушка
		$_COOKIE['us_name'] = AUTH_USER_NAME;
                $pass = "";
                $user = "";
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