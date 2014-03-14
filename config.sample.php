<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------
// Параметры соединения с базой данных, см DB Class
//--------------------------------------------------------------

##ORACLE OCI8 INTERFACE
define("DB","oci");
define("DB_USER_NAME","user");
define("DB_PASSWORD","password");
define("DB_NAME", "base cheme");
define("DB_ENCODING","CL8MSWIN1251");

//--------------------------------------------------------------
// Авторизация пользователей:
//--------------------------------------------------------------
##LDAP AUTH INTERFACE
#define("AUTH","ldap");
#define("AUTH_DOMAIN","domain.ru");
#define("AUTH_PORT","389");
#define("AUTH_ALLOW_GUEST","GUEST_USER"); //  Укажите имя пользователя гостя в базе, гости будут залогенены под ним

## AUTH FROM DB INTERFACE
#define("AUTH","oci.db");

## AUTH FORM WB_USER TABLE INTERFACE
#define("AUTH","user");
#define("AUTH_ALLOW_GUEST","GUEST_USER"); //  Укажите имя пользователя гостя в базе, гости будут залогенены под ним

## TESTING LOCAL AUTCH INTERFACE
define("AUTH","local");
define("AUTH_USER_NAME","user name");

//--------------------------------------------------------------
// Параметры справки:
//--------------------------------------------------------------
define("HELP",false);
define("HELP_FOLDER","help");

//--------------------------------------------------------------
// Кодировка, базы данных, кодировка веб сервера, и ХТМЛ
//--------------------------------------------------------------
define("LOCAL_ENCODING","CP1251");
define("HTML_ENCODING","UTF-8");
define("THEMES_DIR","themes");

//--------------------------------------------------------------
// Общие параметры
//--------------------------------------------------------------
define("UPLOAD_DIR","upload_file");
define("UPDATE_SITE","https://raw.github.com/andrey-boomer/IWS/master");
//--------------------------------------------------------------
// Дебагер
//--------------------------------------------------------------
#define("HAS_DEBUG_FILE","debug.txt");

//--------------------------------------------------------------
// ЕСЛИ СИСТЕМА БУДЕТ В ОФЛАЙНЕ, ВВЕДИТЕ ДАТУ И ВРЕМЯ
//--------------------------------------------------------------
define("OFFINE_MESSAGE","Планового обновление базы данных");
define("OFFINE_START_DATE",strtotime("15.08.2013 15:00:00"));
define("OFFINE_END_DATE",strtotime("16.08.2013 17:00:00"));
?>