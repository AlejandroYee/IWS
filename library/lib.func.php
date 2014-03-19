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

if (!defined('PHP_VERSION_ID')) {
    $version = explode('.', PHP_VERSION);
    define('PHP_VERSION_ID', ($version[0] * 10000 + $version[1] * 100 + $version[2]));   
}

if ((PHP_VERSION_ID < 50400) and (ini_get("short_open_tag") != 1)) {
            die("Для работы системы IWS нужно включить директиву short_open_tag = On"); 
}

if (PHP_SAPI === 'cli' || (!isset($_SERVER['DOCUMENT_ROOT']) && !isset($_SERVER['REQUEST_URI']))) {
        define("ENGINE_HTTP", false);        
        define("AUTH","local");
        define("AUTH_USER_NAME","console");
        error_reporting(E_ALL ^ E_NOTICE);
        require_once(ENGINE_ROOT."/config.".CONFIG.".php");
    } else {
        if (filter_input(INPUT_SERVER, 'HTTPS',FILTER_VALIDATE_BOOLEAN) > 0) {
            if (!extension_loaded ("openssl")) die("Для работы системы IWS нужен модуль php_openssl который незагружен или отсутсвует, подключите модуль.");  
            define("ENGINE_HTTP",  "https://" .filter_input(INPUT_SERVER, 'HTTP_HOST',FILTER_SANITIZE_URL));
        } else {    
            define("ENGINE_HTTP",  "http://" .filter_input(INPUT_SERVER, 'HTTP_HOST',FILTER_SANITIZE_URL));
        }
        
        define("ENGINE_ROOT",  filter_input(INPUT_SERVER, 'DOCUMENT_ROOT',FILTER_SANITIZE_STRING));
        
        // Проверяем основные переменнные и модули
        if (is_file(ENGINE_ROOT."/config.".filter_input(INPUT_SERVER, 'HTTP_HOST',FILTER_SANITIZE_URL).".php")) {
            require_once(ENGINE_ROOT."/config.".filter_input(INPUT_SERVER, 'HTTP_HOST',FILTER_SANITIZE_URL).".php");
        } else {
            die("Вы зашли на сайт системы IWS, но по данному адресу ".ENGINE_HTTP." конфигурацая ненастроена, пожалуйста обратитесь к вашему администратору!");   
        }    
}

define("SESSION_ID",md5(time().rand(time()/100,getrandmax())));
define("HTTP_USER_AGENT",filter_input(INPUT_SERVER, 'HTTP_USER_AGENT',FILTER_SANITIZE_STRING));
define("SESSION_LIFE_TIME", 10800);
define("VERSION_ENGINE","2.1.1");

session_start();

if (!extension_loaded ("mbstring")) die("Для работы системы IWS нужен модуль php-mbstring который незагружен или отсутсвует, подключите модуль.");  

set_error_handler('my_error_handler');
set_exception_handler('my_exception_handler');
register_shutdown_function('end_timer');

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

//--------------------------------------------------------------------------------------------------------------------------------------------
// Класс подсчета времени выполнения
//--------------------------------------------------------------------------------------------------------------------------------------------
if (!isset($starttime)) {  
        $mtime = explode (' ', microtime());
        $mtime_split = $mtime[1] + $mtime[0];
        $_SESSION[strtoupper("timer_".SESSION_ID)] = $mtime_split;
        BasicFunctions::to_log("LIB: Session ".SESSION_ID." start ... ");
}

function end_timer()
{
    if (isset($_SESSION[strtoupper("timer_".SESSION_ID)])) {
        $mtime = explode (' ', microtime ()); 
        $totaltime = round(($mtime[1] + $mtime[0]) - $_SESSION[strtoupper("timer_".SESSION_ID)], 4,PHP_ROUND_HALF_ODD);
        unset($_SESSION[strtoupper("timer_".SESSION_ID)]);
        BasicFunctions::to_log("LIB: Session ".SESSION_ID." end, worktime ".$totaltime." s.");        
   }  
   
   if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" ) and ( auth::get_user() != "")) {
    file_put_contents(ENGINE_ROOT. DIRECTORY_SEPARATOR .HAS_DEBUG_FILE,$_SESSION[strtoupper("log_".SESSION_ID)], FILE_APPEND | LOCK_EX);
    unset($_SESSION[strtoupper("log_".SESSION_ID)]);
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
                BasicFunctions::requre_script_file("auth.".AUTH.".php");
                $log = str_replace(array("\r\n", "\n", "\r", "\t", "    ","   ","  ")," ",$log); 
                if(strpos($log,"Load page:") != false) {
                    $log =  iconv(HTML_ENCODING,LOCAL_ENCODING,$log);
                }
                if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" ) and (auth::get_user() != "")) {
                                if (!isset($_SESSION[strtoupper("log_".SESSION_ID)])) {
                                        $_SESSION[strtoupper("log_".SESSION_ID)] = null;
                                }
                                $_SESSION[strtoupper("log_".SESSION_ID)].= "[".date("d.m.Y H:i:s")." <".strtoupper(auth::get_user()).">] ".$log."\r\n";
                        }
                // для случаев когда неавторизированны
                if ($sub_debug and !auth::get_user()) {
                    file_put_contents(ENGINE_ROOT. DIRECTORY_SEPARATOR .HAS_DEBUG_FILE,"[".date("d.m.Y H:i:s")." <".strtoupper($sub_debug).">] ".$log."\r\n", FILE_APPEND | LOCK_EX);                
                }
            }      
            }

            //--------------------------------------------------------------------------------------------------------------------------------------------
            // Окно авторизации:
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function Create_logon_window($offline = false) {
            BasicFunctions::clear_cache();
            ?>
            <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html lang="en-US">
                                    <head>
                                            <meta charset="<?php echo strtolower(HTML_ENCODING); ?>">
                                            <title>IWS Login</title>
                                            <meta http-equiv="Content-Type" content="text/html; charset=<?php echo strtolower(HTML_ENCODING); ?>"/>
                                            <meta http-equiv="Cache-Control" content="no-cache">
                                            <meta http-equiv="Pragma" content="no-cache" >				
                                            <meta http-equiv="expires" content="0">						
                                            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />				
                                            <link rel="stylesheet" type="text/css" href="<?=ENGINE_HTTP?>/library/normalize.css?s=<?=SESSION_ID?>" />
            <?php			
                                            // Проверим на старые версии IE
                                            if (strpos(HTTP_USER_AGENT, 'MSIE 6.0') > 0 or strpos(HTTP_USER_AGENT, 'MSIE 7.0') > 0 or strpos(HTTP_USER_AGENT, 'MSIE 8.0') > 0) {
                                            ?>
                                            <script type="text/javascript" >
                                            var ieVersion = /*@cc_on (function() {switch(@_jscript_version) {case 1.0: return 3; case 3.0: return 4; case 5.0: return 5; case 5.1: return 5; case 5.5: return 5.5; case 5.6: return 6; case 5.7: return 7; case 5.8: return 8; case 9: return 9; case 10: return 10;}})() || @*/ 0;
                                             if (ieVersion === 0) { // IE 11 FIX
                                                 if (!!window.MSStream) {
                                                  ieVersion = 11;
                                                }    
                                             } if ( ieVersion < 9) {					
                                                    alert("К сожалению ваша версия Internet Explorer больше не поддерживается и не безопасна.\nОбновите ее, либо обратитесь к вашему системному администратору!");				
                                                    throw new Exception_no_browser("error");
                                            }
                                            </script>
                                            <?php
                                            }
                                            $theme_first = array();
                                            // Тема не задана! Задаем тему по умомчанию и выводим напоминание пользователю чтобы зашел и сменил
                                            if (!is_dir(THEMES_DIR)) {
                                                die ("Неуказана директория тем в конфигурации!");                                                
                                            }	
                                            if (!is_dir(ENGINE_ROOT."/jscript/")) {
                                                die ("Ошибка конфигурации и привелегий сервера!");                                                 
                                            }

                                            $dh  = opendir(THEMES_DIR."/");
                                            while (false !== ($file = readdir($dh))) {
                                            if (($file == ".") or ($file == "..")) { 
                                                    continue;                                                    
                                            }
                                              if (is_dir(THEMES_DIR. "/" . $file)) {
                                                    $dh_sub  = opendir(THEMES_DIR. "/" . $file);
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
                                            setcookie("theme_num_last", $theme_number);
                                            echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"". ENGINE_HTTP . "/" .$theme_first['theme_file'][$theme_number]." \" /> \n";														
            ?>  			<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-2.1.0.min.js?s=<?=SESSION_ID?>"></script>
                                            <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-1.10.4.custom.min.js?s=<?=SESSION_ID?>"></script>
                                            <style type="text/css">											
                                                            #loading {background:#ffffff url(<?=ENGINE_HTTP?>/library/ajax-loader-tab.gif) no-repeat center center;height: 100%;width: 100%;position: absolute; z-index: 999999; }	
                                                            #loading2 {background:#ffffff url(<?=ENGINE_HTTP?>/library/ajax-loader.gif) no-repeat center center;height: 100%;width: 100%;position: absolute; z-index: 99; }
                                                            html, body {padding: 0px; margin: 0px; overflow:hidden; font-size: 12px;}
                                            </style>						 
            </head>
            <body>
            <div id="loading"></div>            
            <div id="logon" window_login="logon" class="ui-widget ui-widget-content ui-corner-all" style="position:absolute;text-align :center;width:400px;height:350px;">
            <div id="loading2" class="ui-widget ui-widget-content ui-corner-all" style="border:0"></div>  
            <?php if (!$offline) { ?>
            <h3>
            <?php
            $main_db = new db();
            if ($main_db) {
                    echo $main_db -> get_settings_val("ROOT_CONFIG_NAME");
            }
            ?>
            </h3>
            <p>Необходима авторизация, представьтесь:</p>	
            <form method="POST" id="settings_from" style="position:absolute;text-align:center;width:200px;height:190px;top:100px;left:100px" >
                            <div id="login_edit">
                                    <label for="username_or_email" tabindex="-1" class="ui-widget" style="font-size:1.2em"><b>Ваш логин:</b></label><br>
                                    <input aria-required="true"  autofocus="autofocus" id="username" name="username" class="ui-widget ui-widget-content ui-corner-all" style="height: 24px;"  type="text" /><br><br>
                                    <label for="password" tabindex="-1" style="font-size:1.2em"><b>Пароль:</b></label>
                            </div>
                                    <input aria-required="true" id="password" class="ui-widget ui-widget-content ui-corner-all" name="password" style="height: 24px;" type="password" /><br><br>
                                    <input type="submit" id="submit_settings" style="display: none;">
                                    <button>Войти</button>	
            </form>
            <?php } else {?>
                <p><br><br><br>
                <b>Уважаемый пользователь.</b><br><br>
                C <b><?=date("H:i:s d.m.Y",OFFINE_START_DATE)?></b> по <b><?=date("H:i:s d.m.Y",OFFINE_END_DATE)?></b><br><br>
                Система будет находится в оффлайне для:<br><br>
                <b><?=OFFINE_MESSAGE?> </b><br><br>
                Приносим свои извенения<br>за доставленное неудобство,<br>
                зайдите позже.
                </p>
                <?php } ?>
                <div id="login_theme" style="position:absolute;text-align:center;width:200px;height:20px;top:280px;left:100px">
                        <h6>Случайная тема оформления, называется: "<?=$theme_first['theme_name'][$theme_number]?>"</h6>
                </div>
                <div id="login_theme" style="position:absolute;text-align:center;width:200px;height:20px;top:315px;left:100px">
                        <h6 id="about">IWS: v<?=VERSION_ENGINE?>@<?=date("Y")?></h6>
                </div>
            </div>   
            <script type="text/javascript" >
        <?php
             echo BasicFunctions::regex_javascript("$(function() {  
                 base64_encode = function ( data ) {    

                        data = escape(data);  

                        var b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
                        var o1, o2, o3, h1, h2, h3, h4, bits, i=0, enc='';

                        do { // pack three octets into four hexets
                            o1 = data.charCodeAt(i++);
                            o2 = data.charCodeAt(i++);
                            o3 = data.charCodeAt(i++);

                            bits = o1<<16 | o2<<8 | o3;

                            h1 = bits>>18 & 0x3f;
                            h2 = bits>>12 & 0x3f;
                            h3 = bits>>6 & 0x3f;
                            h4 = bits & 0x3f;

                            enc += b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4);
                        } while (i < data.length);

                        switch( data.length % 3 ){
                            case 1:
                                enc = enc.slice(0, -2) + '==';
                            break;
                            case 2:
                                enc = enc.slice(0, -1) + '=';
                            break;
                        }

                        return enc;
                    };
                    
                    custom_alert = function (output_msg) {	
                                   $('<div />').html(output_msg).dialog({
                                           title: 'Ошибка',
                                           resizable: false,
                                           minWidth: 450,
                                           modal: true,
                                           buttons: {
                                                   'Закрыть': function() 
                                                   {
                                                           $( this ).dialog( 'close' );                                                           
                                                   }
                                           },							
                                           open: function() {								
                                                           $(this).parent().css('z-index', 9999).parent().children('.ui-widget-overlay').css('z-index', 105);					
                                           }
                                   });
                   };

                $( 'button')
                  .button()
                  .click(function( event ) {
                  
                            var usr = $('#username').val();
                            var pass = $('#password').val();
                            $('#loading2').fadeIn(300);
                            setTimeout(function(){ 
                            if (usr.replace(/\s/g,'') === '') custom_alert('Необходимо указать имя пользователя!');		
                            if (pass.replace(/\s/g,'') === '') custom_alert('Необходимо указать пароль!');		
                            if (usr.replace(/\s/g,'') !== '' && pass.replace(/\s/g,'') !== '') {                                                                        	                                
                                        $.ajax({
                                                            url: '".ENGINE_HTTP."/ajax.saveparams.php?act=login',
                                                            datatype:'json',
                                                            data: { username: $('#username').val(), password:  base64_encode($('#password').val()) },
                                                            cache: false,
                                                            type: 'POST',
                                                                    success: function(data) {
                                                                          if (data != 'true') {                                                                              
                                                                              custom_alert('Неверное имя пользователя или пароль!');
                                                                              $('#loading2').fadeOut(300);
                                                                           } else {   
                                                                                $('#logon').fadeOut(400);
                                                                                setTimeout(function() {                                                                                
                                                                                     $('#loading').fadeIn(300);
                                                                                }, 500);                                                            
                                                                                setTimeout(function() {                                                                                     
                                                                                     $(location).prop('href','".ENGINE_HTTP."/');
                                                                                }, 3000);                                                                                
                                                                          }	
                                                                    }
                                            });
                            }
                            }, 2000);
                            return false;
                  });
              });
            $(document).ready(function () {
                    $('#loading2').hide();
                    $('#loading').fadeOut(500);		
                });
                
            $('#password').keyup(function(eventObject){
                    if (eventObject.keyCode === 13) {                        
                            $('button').click();
                      }
             });
             
            $(window).resize(function () {
              $('#logon').css({ top: $(window).height()/2 - 175, left: $(window).width()/2 - 200 });			
            });
            
            $('#logon').css({ top: $(window).height()/2 - 175, left: $(window).width()/2 - 200 });");	
        ?>
            </script>
            </body>
            <?php
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
            // Проверка загруженных классов
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static Function check_classes() {
            // прогружаем оставшиеся
            BasicFunctions::requre_script_file("lib.charts.php");
            BasicFunctions::requre_script_file("lib.help.php");
            BasicFunctions::requre_script_file("lib.input.php");
            BasicFunctions::requre_script_file("lib.jqgrid.php");

            //Проверяем о информации
            $classes_define = get_declared_classes();
                    foreach($classes_define as $key)  {
                            if (method_exists($key, 'get_about')) {
                                    echo "<b>".strtoupper($key).":</b> ".call_user_func($key."::get_about")."<br>";
                            }
                    }
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
                                                    $ip=$ip1.':'.$ip2;
                     if (!empty($ip1) & empty($ip2)) 
                                                    $ip=$ip1;
                     if (empty($ip1) & !empty($ip2)) 
                                                    $ip=$ip2;
                     if (empty($ip1) & empty($ip2)) 
                                                    $ip='неизвестно';
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
            // Сохранение масивов и переменных в кеш
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function save_to_cache($name, $value, $time = -1) {
                BasicFunctions::requre_script_file("lib.json.php");
                BasicFunctions::requre_script_file("lib.gz.php");
                    if (!isset($_SESSION["ENABLED_CACHE"])) {
                            if ($time < 0) {
                                $time = time() + SESSION_LIFE_TIME; // по умолчанию 3 часа
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
                
                            if (isset($_SESSION[strtoupper($name)])  and !isset($_SESSION["ENABLED_CACHE"])) {				
                                            // Распаковываем без проверки чексум, баг firefox'a
                                            BasicFunctions::requre_script_file("lib.json.php");
                                            BasicFunctions::requre_script_file("lib.gz.php");
                                            $json = new json(); 
                                            $to_menu = $json -> jsondecode(gz::gzdecode_zip(base64_decode($_SESSION[strtoupper($name)])), $is_array);		 			
                                            // Проверяем есть ли данные, если есть то перемещаем их в массив
                                            if (!empty($to_menu)) {
                                                    $ddd = debug_backtrace();
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
                                            session_destroy();	
                                            session_start();
                                            $_SESSION['us_name'] = $us;
                                            $_SESSION['us_pr']   = $ps;
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
            // Создаем о программе
            //--------------------------------------------------------------------------------------------------------------------------------------------
            public static function about($db) {
            ?>
                    <div id="about" title="О программе" style="text-align:left">
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
                    <b>Подключенные модули:</b><br>
                    <div class="ui-widget-content" style="height:110px;overflow: auto;font-size:80%;padding: .5em 1em; text-align:left;position: relative;">
                    <?php	
                    BasicFunctions::check_classes();	
                    if (is_dir(HELP_FOLDER)) {
                                    if (HELP) {
                                            echo "<button class='help_button' url='".ENGINE_HTTP."/ajax.tab.php?action=help'>Справочный раздел</button>";
                                    }
                    }
                    ?>
                    </div>
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
                            <a href="https://github.com/ehynds/jquery-ui-multiselect-widget" target="_blank">JQuery UI multiselect</a>,		
                            <a href="http://www.flotcharts.org/" target="_blank">FlotCharts</a>
                            <a href="http://keith-wood.name/calculator.html" target="_blank">jQuery Calculator</a>
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