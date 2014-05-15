<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/

ini_set('max_execution_time', 2100);
ini_set('display_errors','Off');
ini_set('session.gc_probability', 1);
ini_set("session.use_only_cookies", 1);
date_default_timezone_set('Europe/Moscow');
Error_Reporting(E_ALL);

define("ENGINE_ROOT",  filter_input(INPUT_SERVER, 'DOCUMENT_ROOT',FILTER_SANITIZE_STRING));
define("HTTP_USER_AGENT",filter_input(INPUT_SERVER, 'HTTP_USER_AGENT',FILTER_SANITIZE_STRING));
define("VERSION_ENGINE","2.1.5");

if (!defined('CONFIG')) {
    define("CONFIG",filter_input(INPUT_SERVER, 'HTTP_HOST',FILTER_SANITIZE_URL));
}

if (!defined('PHP_VERSION_ID')) {
    $version = explode('.', PHP_VERSION);
    define('PHP_VERSION_ID', ($version[0] * 10000 + $version[1] * 100 + $version[2]));   
}

if ((PHP_VERSION_ID < 50400) and (ini_get("short_open_tag") != 1)) {
        die("Для работы системы IWS нужно включить директиву short_open_tag = On. Либо обновить PHP до версии 5.4"); 
}

if (!extension_loaded ("mbstring")) {
        die("Для работы системы IWS нужен модуль php-mbstring который незагружен или отсутсвует, подключите модуль.");  
}

if (!is_file(ENGINE_ROOT."/config.".CONFIG.".php")) {
        die("Вы загрузили платформу IWS, но конфигурацая не настроена, пожалуйста обратитесь к вашему администратору!");   
} 

if (!is_dir(ENGINE_ROOT.DIRECTORY_SEPARATOR."jscript/") or !is_dir(ENGINE_ROOT.DIRECTORY_SEPARATOR."themes/")) {
	die ("Ошибка конфигурации и привелегий сервера!");
}              

if (PHP_SAPI === 'cli' || (!isset($_SERVER['DOCUMENT_ROOT']) && !isset($_SERVER['REQUEST_URI']))) {
        define("ENGINE_HTTP", false);        
        define("AUTH","local");
        define("AUTH_USER_NAME","console");
        error_reporting(E_ALL ^ E_NOTICE);
    } else {       
        if (filter_input(INPUT_SERVER, 'HTTPS',FILTER_VALIDATE_BOOLEAN) > 0) {
            if (!extension_loaded ("openssl")) {
                die("Для работы системы IWS нужен модуль php_openssl который незагружен или отсутсвует, подключите модуль.");
            }
            define("ENGINE_HTTP",  "https://" .CONFIG);
        } else {    
            define("ENGINE_HTTP",  "http://" .CONFIG);
        }
}

session_name(str_replace(array(".",",","-"),"_",CONFIG));
session_start(); 
set_error_handler('my_error_handler');
set_exception_handler('my_exception_handler');
register_shutdown_function('end_timer');

require_once(ENGINE_ROOT."/config.".CONFIG.".php");  
BasicFunctions::requre_script_file("auth.".AUTH.".php");
BasicFunctions::requre_script_file("db.".DB.".php");

//--------------------------------------------------------------------------------------------------------------------------------------------
// exception
//--------------------------------------------------------------------------------------------------------------------------------------------
function my_exception_handler($e) {
	BasicFunctions::to_log("ERR: ". iconv(HTML_ENCODING,LOCAL_ENCODING,$e));
}

function my_error_handler($no,$str,$file,$line) {		
	if ($no <> 2 ) {
		my_exception_handler(" '".$str."' файл: ".$file." строка: ".$line); 
	}
    return true;		
}

// для старых версий php < 5.5
if (!function_exists('boolval')) {
        function boolval($val) {
                return (bool) $val;
        }
}
if (function_exists('session_register_shutdown')) {
    session_register_shutdown();    
}
//--------------------------------------------------------------------------------------------------------------------------------------------
// Класс подсчета времени выполнения
//--------------------------------------------------------------------------------------------------------------------------------------------
if (!isset($starttime)) {  
        $mtime = explode (' ', microtime());
        $mtime_split = $mtime[1] + $mtime[0];
        $_SESSION[strtoupper("timer_".session_id())] = $mtime_split;
        BasicFunctions::to_log("LIB: Session ".session_id()." start ... ");
}

function end_timer()
{
    if (isset($_SESSION[strtoupper("timer_".session_id())])) {
        $mtime = explode (' ', microtime ()); 
        $totaltime = round(($mtime[1] + $mtime[0]) - $_SESSION[strtoupper("timer_".session_id())], 4,PHP_ROUND_HALF_ODD);
        unset($_SESSION[strtoupper("timer_".session_id())]);
        BasicFunctions::to_log("LIB: Session ".session_id()." end, worktime ".$totaltime." s.");        
   }  
   
   if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" ) and ( auth::get_user() != "")) {
    file_put_contents(ENGINE_ROOT. DIRECTORY_SEPARATOR .HAS_DEBUG_FILE,$_SESSION[strtoupper("log_".session_id())], FILE_APPEND | LOCK_EX);    
    $_SESSION[strtoupper("log_".session_id())] = null; 
    // Проверяем на предыдущие закрытые сейсии чтобы не плодить файлы, и делаем унсет им:
    foreach ($_SESSION as $key => $value) { 
          if ($value  == "NULL") {
              unset($_SESSION[$key]);
          }      
    }
   }
}

class BasicFunctions {
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Для загрузки конфигов
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static Function requre_script_file($file_name) {
                if (!is_file( ENGINE_ROOT ."/library/".$file_name)) {
                                die("Проблема при загрузке конфигурации и модулей, обратитесь к документации. [".$file_name."]\n");
                }
                require_once (ENGINE_ROOT ."/library/".$file_name);
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Логирование
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function to_log($log,$sub_debug = false) {                
            if (!stripos($log,"mdpf")) {
                $log = str_replace(array("\r\n", "\n", "\r", "\t", "    ","   ","  ")," ",$log); 
                $ip = BasicFunctions::get_ip();
                if (!empty($ip)) {
                    $ip = "/".$ip;
                }
                if(strpos($log,"Load page:") != false) {
                    $log =  iconv(HTML_ENCODING,LOCAL_ENCODING,$log);
                }
                if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" ) and (auth::get_user() != "")) {
                                if (!isset($_SESSION[strtoupper("log_".session_id())])) {
                                        $_SESSION[strtoupper("log_".session_id())] = null;
                                }                                
                                $_SESSION[strtoupper("log_".session_id())].= "[".date("d.m.Y H:i:s")." <".strtoupper(auth::get_user()).$ip.">] ".$log."\r\n";
                        }
                // для случаев когда неавторизированны
                if ($sub_debug != false and $sub_debug != true and !auth::get_user()) {
                    file_put_contents(ENGINE_ROOT. DIRECTORY_SEPARATOR .HAS_DEBUG_FILE,"[".date("d.m.Y H:i:s")." <".strtoupper($sub_debug).$ip.">] ".$log."\r\n", FILE_APPEND | LOCK_EX);                
                }
                // для случаев когда неавторизированны без пользователя
                if ($sub_debug == true) {
                    file_put_contents(ENGINE_ROOT. DIRECTORY_SEPARATOR .HAS_DEBUG_FILE,"[".date("d.m.Y H:i:s")." ] ".$log."\r\n", FILE_APPEND | LOCK_EX);                
                }
            }      
            }
            
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Сжимаем Javascript
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function regex_javascript($str) {
            $str = preg_replace(array(
                                                    '/(?<!\:)\/\/(.*)\\n/',
                                                    '/\s{2,}/',
                                                    '/[\t\n]/'
                                                     ), '', $str); 
            return $str;
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Функция преобразования переменных пришедших в скрипт в зависимости от того откуда пришли переменные
            // может брать как и из командной строки так и из get post переменных
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function getinput_var($argvs = false)  {  
               if (ENGINE_HTTP and $argvs)  // command line
               {
                  $found = array();
                  foreach (array_merge(filter_input_array("INPUT_POST"),filter_input_array("INPUT_GET")) as $key => $value) {   
                    $found[$key] = $value;                   
                  }
                  return $found;
               }
               else  {
                  $found = array();
                   foreach ($argvs as $arg) {
                        $e=explode("=",$arg);
                        if(count($e) == 2)
                            $found[str_ireplace("-","",$e[0])] = $e[1];
                        else    
                            $found[str_ireplace("-","",$e[0])] = true;
                   }
                  return $found;
               }

               return false;
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Принудительный редирект страници по адресу
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static Function Redirect($url) { 
                    echo "<script language='JavaScript' type='text/javascript'>window.location.replace('".$url."')</script>";
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Текущий ИП
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function get_ip() {
                     $ip1=preg_replace("/^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/", "\\1.\\2.\\3.\\4", getenv('HTTP_X_FORWARDED_FOR'));
                     $ip2=preg_replace("/^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/", "\\1.\\2.\\3.\\4", getenv('REMOTE_ADDR'));
                     if (!empty($ip1) & !empty($ip2)) 
                                                    $ip=$ip1.'@'.$ip2;
                     if (!empty($ip1) & empty($ip2)) 
                                                    $ip=$ip1;
                     if (empty($ip1) & !empty($ip2)) 
                                                    $ip=$ip2;
                     if (empty($ip1) & empty($ip2)) 
                                                    $ip='';
                     return $ip;
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Обрезает айдишник филда в конце
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static Function trim_fieldname($field_name, $id = false) {
                    if ($id == false) {
                                    $name = substr($field_name, 0, strrpos($field_name, "_"));
                                    //доп чистка спец символов:
                                    //$name = substr($field_name, 0, strrpos($field_name, "-"));
                                    
                            } else {
                                    $name = str_replace("_".$id,"",$field_name);
                                     //доп чистка спец символов:
                                    $name = substr($field_name, 0, strrpos($field_name, "-"));
                    }
                    return $name;
            }
            
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Если система оффлайн то информируем
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function is_offline($is_first_page = false) {
                if (defined("OFFINE_START_DATE") and defined("OFFINE_END_DATE") and (time() > OFFINE_START_DATE) and (time() <= OFFINE_END_DATE)) {                    
                    if ($is_first_page) {
                        echo "<div class=\"ui-widget ui-widget-content ui-corner-all user_login\" style=\"position:absolute;text-align:center;width:400px;height:350px;\"><p><br><br><br><br><br>";
                    }
                    ?>
                        <b>Уважаемый пользователь.</b><br><br>
                        C <b><?=date("H:i:s d.m.Y",OFFINE_START_DATE)?></b> по <b><?=date("H:i:s d.m.Y",OFFINE_END_DATE)?></b><br><br>
                        Система будет находится в оффлайне для:<br><br>
                        <b><?=OFFINE_MESSAGE?> </b><br><br>
                        Приносим свои извенения<br>за доставленное неудобство,<br>
                        зайдите позже.
                    <?php
                    if ($is_first_page) {
                            echo "</p></div>";        
                    }
                    die();
                }
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Сохранение масивов и переменных в кеш
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function save_to_cache($name, $value, $time = -1) {
                BasicFunctions::requre_script_file("lib.json.php");
                BasicFunctions::requre_script_file("lib.gz.php");
                    if (isset($_SESSION["DISABLED_CACHE"]) and $_SESSION["DISABLED_CACHE"] !== "on") {
                            if ($time < 0) {
                                $time = time() + (session_cache_expire()*60); // по умолчанию
                            }
                            $json = new json();    				
                            $_SESSION[strtoupper($name)] = base64_encode(gz::gzencode_zip($json -> jsonencode($value)));			
                            BasicFunctions::to_log("LIB: ".strtoupper($name)." saved to cache");
                    }
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Загрузка переменной из кеша если она там есть:
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function load_from_cache($name, $is_array = true) {
                            if (isset($_SESSION[strtoupper($name)]) and isset($_SESSION["DISABLED_CACHE"]) and $_SESSION["DISABLED_CACHE"] !== "on") {				
                                            // Распаковываем без проверки чексум, баг firefox'a
                                            BasicFunctions::requre_script_file("lib.json.php");
                                            BasicFunctions::requre_script_file("lib.gz.php");
                                            $json = new json(); 
                                            $to_menu = $json -> jsondecode(gz::gzdecode_zip(base64_decode($_SESSION[strtoupper($name)])), $is_array);
                                            $ddd = debug_backtrace();
                                            // Проверяем есть ли данные, если есть то перемещаем их в массив
                                            if (!empty($to_menu)) {
                                                    BasicFunctions::to_log("LIB: Module ".strtoupper($ddd[1]["class"])." found ".strtoupper($name)." in cache");
                                                    return $to_menu;
                                            }
                                    } else {
                                     return false;
                                    }
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Отчистка кеша, частично либо полностью:
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function clear_cache($name = false) {	
                    if ($name != false) {
                                    if ($name == "no_user") {
                                            // все кроме пользователя
                                            $us = isset($_SESSION['us_name'])?$_SESSION['us_name']:"";
                                            $ps = isset($_SESSION['us_pr'])?$_SESSION['us_pr']:"";
                                            $ch = isset($_SESSION['DISABLED_CACHE'])?$_SESSION['DISABLED_CACHE']:"";
                                            session_destroy();	
                                            session_start();
                                            $_SESSION['us_name'] = $us;
                                            $_SESSION['us_pr']   = $ps;
                                            $_SESSION['DISABLED_CACHE']   = $ch;
                                    } else {
                                            // Задана переменная для отчистки. Зачищаем:
                                            unset($name);
                                    }
                            } else {
                                    // Если незадано, то зачищаем все
                                    session_destroy();
                    }
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Закрываем сейсию
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function end_session() {
                    session_write_close();  // Закрываем сейсию для паралельного исполнния
            }
            
            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Получаем стили
            //--------------------------------------------------------------------------------------------------------------------------------------------            
            public static function get_css() {
                $res = "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/library/normalize.css\" />\n";
                    $dh  = opendir(ENGINE_ROOT."/"."jscript");
                        while (false !== ($file = readdir($dh))) {
                        if (($file == ".") or ($file == "..")) continue;
                                if (strrpos($file,".css") !== false)  {
                                        $res .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/jscript/".$file ."\" />\n";
                                }
                        }                        
                return $res;
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Подгружаем скрипты
            //--------------------------------------------------------------------------------------------------------------------------------------------  
            public static function get_scripts($user_auth) {               
                if (trim(strtolower(CONFIG)) == 'bianca.test') {
                            $min = "source";
                        } else {
                            $min = "min";
                }    
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery-2.1.1.min.js'></script>\n";		
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery-ui-1.11.min.js'></script>\n";
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.mb.browser.min.js'></script>\n";                   
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.jqGrid.min.js'></script>\n";
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.multiselect.".$min.".js'></script>\n";  
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.ios-checkbox.".$min.".js'></script>\n";  
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.calculator.min.js'></script>\n";                    
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.globalize.min.js'></script>\n"; 
                if ($user_auth -> is_user() === true) { 
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery-ui-timepicker-addon.js'></script>\n";
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery-ui-timepicker-ru.js'></script>\n";		
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.fileUpload.js'></script>\n";						
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.jqGrid.locale-ru.js'></script>\n";        	
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.mask.min.js'></script>\n";	
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.fileDownload.js'></script>\n";				
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.flot.min.js'></script>\n";	
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.printThis.js'></script>\n"; 
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.ui-contextmenu.js'></script>\n";  
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.slidebarmenu.".$min.".js'></script>\n";
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/jquery.ui.menubar.js'></script>\n";                          
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/jscript/ace.js'></script>\n";                  
                }  
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/library/iws.".$min.".js' ></script>\n";
                   echo "<script type='text/javascript' src='".ENGINE_HTTP."/library/iws.jqgrid.extend.".$min.".js'></script>\n";
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Получаем тему пользователя
            //--------------------------------------------------------------------------------------------------------------------------------------------  
            public static function get_theme($db,$user_auth) {
                $res = "";
                define("THEMES_DIR","/themes");
                if ($user_auth -> is_user() === true and !empty($db -> user_real_name) and $db->get_param_view("random_theme") != "checked") { 
                        if ((trim($db->get_param_view("theme")) != "") and ( is_file(ENGINE_ROOT . "/" . $db->get_param_view("theme")) )) {	
                                $res .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP . "/" . str_ireplace("\\", "/", $db->get_param_view("theme"))."\" /> \n";						
                        } else {
                                $dh  = opendir(ENGINE_ROOT.THEMES_DIR."/");
                                while (false !== ($file = readdir($dh))) {
                                    if (($file == ".") or ($file == "..")) continue;				
                                      if (is_dir(THEMES_DIR."/" . $file)) {				  
                                            $dh_sub  = opendir(THEMES_DIR."/" . $file);
                                            while (false !== ($file_t = readdir($dh_sub))) {
                                                    if (($file_t == ".") or ($file_t == "..")) continue;						
                                                    if (strrpos($file_t,".css") !== false) {
                                                        // Попытаемся найти дефолтную темку						
                                                            if (trim(strtolower($file)) == "smoothness") {
                                                                    $theme_first = THEMES_DIR."/" .$file. "/" .$file_t;	
                                                            }
                                                            if (empty($theme_first)) $theme_first =  THEMES_DIR."/" .$file. "/" .$file_t;
                                                    }	
                                                    }
                                            }
                                }

                                if (!empty($theme_first)) { 
                                    $res .=  "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP. "/" .$theme_first."\" /> \n";					
                                }
                        }
                } else {
                    $theme_first = array();         
                    $dh  = opendir(ENGINE_ROOT.THEMES_DIR."/");
                    while (false !== ($file = readdir($dh))) {
                        if (($file == ".") or ($file == "..")) { 
                                continue;                                                    
                        }
                        if (is_dir(ENGINE_ROOT.THEMES_DIR. "/" . $file)) {
                              $dh_sub  = opendir(ENGINE_ROOT.THEMES_DIR. "/" . $file);
                              while (false !== ($file_t = readdir($dh_sub))) {
                                      if (($file_t == ".") or ($file_t == "..")) {
                                              continue;
                                      }
                                      if (strpos($file_t,".css") > 0) { 
                                                      $theme_first['theme_file'][] = THEMES_DIR. "/" .$file. "/" .$file_t;
                                                      $theme_first['theme_name'][] = $file;
                                                      break;
                                              }	
                                      }
                        }					
                    }
                    $theme_number = rand(0,count($theme_first['theme_file']) - 1);			
                    if (filter_input(INPUT_COOKIE, 'theme_num_last',FILTER_VALIDATE_INT) != false) {
                            while ($theme_number == filter_input(INPUT_COOKIE, 'theme_num_last',FILTER_SANITIZE_NUMBER_INT)) {
                                    $theme_number = rand(0,count($theme_first['theme_file']) - 1);
                            }
                    }
                    define("THEME_NAME",$theme_first['theme_name'][$theme_number]);
                    $res .=  "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP. "/" .$theme_first['theme_file'][$theme_number]."\" /> \n";
                }
                return $res;
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Создаем параметры пользователя
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function get_user_options($db) {
            ?>
            <div class="iws_param" title="Укажите ваши предпочтения:">
                <p><span class="ui-icon ui-icon-alert" style="float: right; margin: 0 7px 20px 10px;"></span>Задайте параметры для работы. В дальнейшем их можно изменить в меню где написано ваше имя</p>
                <form method="POST" id="settings_from" action="ajax.saveparams.php">
                <label for="themefor">Тема оформления:</label>
                        <select id="themeselector" name="theme" >;
                                <?php			
                                // Загружаем список тем
                                $dh  = opendir("themes/");
                                while (false !== ($file = readdir($dh))) {
                                        if (($file == ".") or ($file == "..")) continue;
                                          if (is_dir("themes". DIRECTORY_SEPARATOR . $file)) {
                                                $dh_sub  = opendir("themes". DIRECTORY_SEPARATOR . $file);
                                                while (false !== ($file_t = readdir($dh_sub))) {
                                                        if (($file_t == ".") or ($file_t == "..")) continue;
                                                        $iscss = strpos($file_t,".css");
                                                        if (!empty($iscss)) {
                                                                if (trim("themes". DIRECTORY_SEPARATOR .$file. DIRECTORY_SEPARATOR .$file_t) === trim($db->get_param_view("theme"))) {$selected="selected";} else {$selected="";}
                                                                echo "			<option value=\""."themes". DIRECTORY_SEPARATOR .$file. DIRECTORY_SEPARATOR .$file_t."\" $selected>$file</option>\n\t";
                                                                break;
                                                        }
                                                }				  
                                          }
                                }
                ?>
                        </select>
                        <p><label for="random_theme" style="font-size:80%;margin:0 5px 0 0" >Использовать случайную тему</label><input type="checkbox" name="random_theme" id="random_theme" <?=$db->get_param_view("random_theme") ?>></p>
                        <p><label for="width_enable" style="font-size:80%;margin:0 5px 0 0" >Автоширина данных</label><input type="checkbox" name="width_enable" id="width_enable" <?=$db->get_param_view("width_enable") ?>></p>
                        <p><label for="editabled" style="font-size:80%;margin:0 5px 0 0" >Отображать нередактируемые поля</label><input type="checkbox" name="editabled" id="editabled" <?=$db->get_param_view("editabled") ?>></p>
                        <p><label for="enable_menu" style="font-size:80%;margin:0 5px 0 0" >Включить обычное меню</label><input type="checkbox" name="enable_menu" id="enable_menu" <?=$db->get_param_view("enable_menu") ?>><br /></p>
                        <p><label for="spinner">Количество месяцев в окне выбора дат: </label><input id="num_mounth" size="2" name="num_mounth" value = "<?=$db->get_param_view("num_mounth")?>" />
                        <p><label for="spinner2">Количество записей на страницу: </label><input id="num_reck" size="2" name="num_reck" value = "<?=$db->get_param_view("num_reck")?>" /></p>		
                        <p><div class="ui-widget-header" style = "height: 1px;"></div></p>
                        <p>Парамерты производительности:</p>
                        <p><label for="cache_enable" style="font-size:80%;margin:0 5px 0 0" >Отключить кеширование</label><input type="checkbox" name="cache_enable" id="cache_enable" <?=$db->get_param_view("cache_enable") ?>></p>
                        <p><label for="renderer">Качество отображения:</label></p>
                        <input type="hidden" name="render_type" id="render_type" value="<?=$db->get_param_view("render_type")?>" />
                        <div style="float:right">
                                <div name="renderer" id="renderer"  style="float:right;top:-13px;width:280px;"></div>
                                <div style="width:150px;top:10px;display: block;height:30px;">
                                                <span style="position:absolute;float:left;display: block;width: 280px;text-align:left;font-size: 11px;">Минимальное</span>
                                                <span style="position:absolute;float:right;display: block;width: 293px;font-size: 11px;">Максимальное</span>               
                                </div>
                        </div>		
                </form>
            </div>	
            <?php    
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Создаем о программе
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function get_about_html($db) {
            ?>
                    <div class="iws_about" title="О программе" style="text-align:left;">
                    <div class="ui-widget-header ui-state-default about_tabs_pict" style="top:5%; width:90%;text-align :right;position:absolute;border:1px transparent;background: transparent;margin:10px;opacity: 1">
                    <?php
                    $about_logo = $db -> get_settings_val('ROOT_CONFIG_LOGO');
                    if (is_file(ENGINE_ROOT.DIRECTORY_SEPARATOR.$about_logo)) {
                            echo "<img src='".ENGINE_HTTP.DIRECTORY_SEPARATOR.$about_logo."'>";
                    }
                    ?>
                    </div>
                    <p><b style="font-size:220%;">IWS</b><br><b>Intellectual web system</b><br>
                    <b>Версия системы:</b> v<?=VERSION_ENGINE?> <?=date("Y")?><br>
                    <b>Конфигурация:</b><br><?=$db -> get_settings_val('ROOT_CONFIG_NAME')?>, версия: <?=$db -> get_settings_val('ROOT_CONFIG_VERSION')?> <br>
                    </p>
                    <p><b>Авторы:</b> Лысиков А.В., Мындра П.А.</p>      
                    <b>Используемые сторонние бибилиотеки под <a href="http://opensource.org/licenses/mit-license.php" target="_blank">MIT License:</a></b><br>
                    <div class="ui-widget-content" style="height:30px;overflow: auto;font-size:80%;padding: .5em 1em; text-align:center;position: relative;">
                            <a href="http://www.phpexcel.net" target="_blank">PHPExcel</a>,
                            <a href="http://jqgrid.com" target="_blank">JQGrid</a>,
                            <a href="http://jquery.com/" target="_blank">JQuery</a>,
                            <a href="http://jqueryui.com/" target="_blank">JQuery UI</a>,
                            <a href="https://github.com/igorescobar/jQuery-Mask-Plugin" target="_blank">Mask-Plugin</a>,
                            <a href="http://trentrichardson.com/examples/timepicker/" target="_blank">JQuery TimePicker</a>,
                            <a href="https://github.com/johnculviner/jquery.fileDownload" target="_blank">JQuery fileDownload</a>,
                            <a href="http://ace.ajax.org/" target="_blank">ACE Cloud9 Editor</a>,
                            <a href="https://github.com/jasonday/printThis" target="_blank">PrintThis</a>,
                            <a href="http://www.mpdf1.com/mpdf/index.php" target="_blank">mPDF</a>,
                            <a href="https://github.com/ehynds/jquery-ui-multiselect-widget" target="_blank">JQuery UI multiselect</a>,		
                            <a href="http://www.flotcharts.org/" target="_blank">FlotCharts</a>
                            <a href="http://keith-wood.name/calculator.html" target="_blank">jQuery Calculator</a>
                            <a href="https://github.com/pupunzi/jquery.mb.browser/" target="_blank">jQuery browser</a>                            
                    </div>
                    <b>Подключенные модули:</b><br>
                    <div class="ui-widget-content" style="height:110px;overflow: auto;font-size:80%;padding: .5em 1em; text-align:left;position: relative;">
                    <?php
                    BasicFunctions::requre_script_file("lib.charts.php");
                    BasicFunctions::requre_script_file("lib.help.php");
                    BasicFunctions::requre_script_file("lib.input.php");
                    BasicFunctions::requre_script_file("lib.jqgrid.php");
                    BasicFunctions::requre_script_file("lib.gz.php");
                    BasicFunctions::requre_script_file("lib.json.php");
                    $classes_define = get_declared_classes();
                    foreach($classes_define as $key)  {                        
                            if (method_exists($key, 'get_about')) {
                                echo "<b>".strtoupper($key).":</b> ".call_user_func($key."::get_about")."<br>";
                            }
                    }
                    if (is_dir(HELP_FOLDER)) {
                        if (HELP) {
                                echo "<button class='help_button' url='".ENGINE_HTTP."/ajax.tab.php?action=help'>Справочный раздел</button>";
                        }
                    }
                    ?>
                    </div>
                    <a href="<?=ENGINE_HTTP?>/history.txt" target="_blank"><b>История изменений:</b></a><br>
                            <div class="ui-widget-content" style="height:150px;overflow: auto;font-size:70%;padding: .5em 1em; text-align:left;position: relative;">
                            <?php
                            $fv = file(ENGINE_ROOT . "/history.txt");
                            $j = 0;
                            $vl = "";
                            if ($fv) {        
                                 for ($i = 0; $i < count($fv); $i++) {
                                     if ($j < 5) { // показывает только 5 последних версий
                                        if (trim($fv[$i]) == "//--------------------------------------------------------------------------------------------------------//") {
                                            $j++; 
                                            $vl .= "<br>";
                                         } else {
                                            $vl .= $fv[$i];
                                        }
                                     }
                                 }
                            }
                            echo str_replace("\n","<br>",$vl);
                            ?>
                            </div>
                    </div>
            <?php
            }
            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Проверка версий
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static Function check_version($db) {               
                $query = $db -> sql_execute("select decode(count(t.id_wb_main_menu), 0, 'false', 'true') as is_administator  from wb_main_menu t where used = 1 and (wb.get_access_main_menu(t.id_wb_main_menu) = 'enable' or t.name is null) and t.id_parent is null   and t.num = 999");
                while ($db -> sql_fetch($query)) {             
                   $is_administator =  $db -> sql_result($query, "is_administator");
                }
                if (isset($is_administator) and (defined("UPDATE_SITE"))) {
               ?>
               <script type="text/javascript" >
                            $.ajax({
                               url: '<?=ENGINE_HTTP?>/ajax.saveparams.php?act=check_version',							  
                               type: 'GET',
                               success: function(data){	                                  
                                     if (data != "") {
                                       var dt = jQuery.parseJSON(data);                                            
                                        if ((dt.version) && $.trim(dt.version) !== $.trim('<?=VERSION_ENGINE?>') ) {                                        			
                                            $.ajax({
                                                   url: '<?=ENGINE_HTTP?>/ajax.saveparams.php?act=get_history',							  
                                                   type: 'GET',
                                                   success: function(dat)  {	
                                                   $('#tabs').children('.ui-tabs-nav').append("<div class='alert_button ui-state-highlight ui-corner-all' onclick='$(\"#update_dlg\").dialog(\"open\");' style='float:right;width:145px;margin:3px;padding:3px;cursor:pointer;' title='Доступна новая версия: v" + 
                                                               dt.version + " от " + dt.date + "'><span class='ui-icon ui-icon-alert' style='float:left'></span>Обновление IWS</div>");
                                                   
                                                   var msg = '<p><b>Новая версия:</b> v'+dt.version+'<br><b>Дата выпуска:</b> '+dt.date+'</p><b>Что нового:</b><br>'+ dat +
                                                           '<br>Обновиться можно вручную через git,<br>либо скачать новую версию нажав на ссылку ниже:<br>' +
                                                           '<a href="'+dt.link+'">'+dt.link+'</a>' +
                                                           '<br><br><br>А также в зависимости от настроек системы и сервера<br>можно обновиться автоматически ' +
                                                           'для этого нажмите кнопку "обновить"';
                                                   
                                                   $('<div />').attr({'id':'update_dlg','style':'text-align:left;'}).html(msg).dialog({
                                                        autoOpen: false,
                                                        modal: false,
                                                        minWidth: 350,
                                                        width: 830,
                                                        title: 'Доступно обновление системы IWS',
                                                        closeOnEscape: true,
                                                        buttons: [
                                                            {text: "Обновить систему",
                                                                click: function() {
                                                                    $('#btn_u').button('option', 'disabled', true );
                                                                    $.ajax({
                                                                        url: '<?=ENGINE_HTTP?>/ajax.saveparams.php?act=update_to_lastest_version',							  
                                                                        type: 'GET',
                                                                        success: function(data){
                                                                            if (data != "") {
                                                                                custom_alert(data);
                                                                                $('#btn_u').button('option', 'disabled', false );
                                                                            } else {    
                                                                                window.location.replace('<?=ENGINE_HTTP?>');
                                                                            }
                                                                        }
                                                                    });
                                                               }
                                                            }
                                                        ],
                                                        open: function() {
                                                            var self = $(this).parent();
                                                            self.children('.ui-dialog-buttonpane').find('button:contains("Обновить систему")').button({icons: { primary: 'ui-icon-refresh'}}).prop('id','btn_u');
                                                        }
                                                   });

                                                  }	  
                                            });    
                                       }
                                      } 
                               }	  
                             });
               </script>
               <?php
               }
            }
            
            //--------------------------------------------------------------------------------------------------------------------------------------------	
            // Создание select списка для jqgrid
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function get_select_data($db, $sql, $rowid) {
            // Чистим запрос, если там есть закодированные кавычки:
            $sql = str_ireplace("&#39;","'",$sql);
            
            // Проверяем кодировку
            $sql = iconv(HTML_ENCODING,LOCAL_ENCODING."//TRANSLIT", str_ireplace(":rowid",$rowid,$sql));            
           
            // Выполняем запрос на получение данных:
            $query = $db -> sql_execute($sql);	
            $level 		= 0;
            $countgroup         = 0;
            $i                  = 0;
            $rezult		= "";
            $sd_options_content = array();

            while ($db -> sql_fetch($query)) {
                    // поддержка опт группы (optgroup):
                    if ($db ->  sql_has_field($query,"LEV")) {	
                            // Используем группы, сначала заполняем данные в массив		
                            if (($level != $db -> sql_result($query, "LEV")) and ($level != 0)) {
                                    if ($level < $db -> sql_result($query, "LEV")) {	
                                                    $sd_name	= "";
                                                    if (isset($sd_options_content[$i - 3]) and (intval($sd_options_content[$i - 3]['LEV']) == intval($sd_options_content[$i - 1]['LEV'] + 1))) {
                                                            $sd_name                                    = $sd_options_content[$i - 1]['NAME'];
                                                            $sd_options_content[$i]                     = $sd_options_content[$i - 1];
                                                            $sd_options_content[$i - 1]['ID']		= "GROUP_END";
                                                            $sd_options_content[$i - 1]['NAME']		= "";	
                                                            $i++;						
                                                            $countgroup--;	
                                                    }

                                                    $sd_options_content[$i - 1]['ID'] = "GROUP_START";	
                                                    if (!empty($sd_name)) {
                                                            $sd_options_content[$i - 1]['NAME'] = $sd_name;	
                                                    }
                                                    $i++;
                                                    $countgroup++;
                                    }
                            }		
                            $sd_options_content[$i]['ID']		= $db -> sql_result($query, "ID");
                            $sd_options_content[$i]['NAME']             = str_ireplace("'","",trim($db -> sql_result($query, "NAME")));
                            $sd_options_content[$i]['LEV']		= $db -> sql_result($query, "LEV");

                            $i++; // Обновляем индекс
                            $level = $db -> sql_result($query, "LEV"); // Сохраняем индекс
                    } else {
                            // Отп группы не используем, просто отдаем данные в селект
                            $sd_options_content[$i]['ID']	=   $db -> sql_result($query, "ID");
                            $sd_options_content[$i]['NAME'] 	=   str_ireplace("'","",$db -> sql_result($query, "NAME"));
                            $i++;
                    }
            }

            // Сформировали, выводим:
            if (isset($sd_options_content)) foreach ($sd_options_content as $key) {
                    $rezult .= trim($key['ID']).":".trim($key['NAME']).";";
            }

            // Вдруг у нас незакрытые группы
            while( $countgroup != 0) {
                    $rezult .=  "GROUP_END:;";
                    $countgroup--;
            }            
            // убираем последнюю точку с зяпятой
            return rtrim(trim($rezult), ";");	
            }
}

// $ чекаем сейсию на предмет подмены куков либо самой сейсии:
if (isset($_SESSION['control_ses'])) {
	// проверяем:
	if (($_SESSION['control_ses_ip'] != BasicFunctions::get_ip()) or ($_SESSION['control_ses_agent'] != HTTP_USER_AGENT)) {
		// Возможно пользователь сменил браузер либо попытка подмены сейсии
		session_destroy(); // убиваем сейсию для безопастности
		die(BasicFunctions::Create_logon_window());
	}
} else {
	$_SESSION['control_ses_ip'] = BasicFunctions::get_ip();
	$_SESSION['control_ses_agent'] = HTTP_USER_AGENT;
}