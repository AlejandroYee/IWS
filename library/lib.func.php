<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
define("ENGINE_HTTP","http://".$_SERVER['HTTP_HOST']);
define("ENGINE_ROOT",$_SERVER['DOCUMENT_ROOT']);
define("SESSION_ID",md5(time().rand(time()/100,getrandmax())));

// Переопределение времени выполнения
ini_set('max_execution_time', 2100);
ini_set('display_errors','Off');
ini_set('session.gc_probability', 1);
ini_set("session.use_only_cookies", 1);
date_default_timezone_set('Europe/Moscow');

session_start();
Error_Reporting(E_ALL);

require_once(ENGINE_ROOT."/config.".$_SERVER['HTTP_HOST'].".php");
set_error_handler('my_error_handler');
set_exception_handler('my_exception_handler');

//--------------------------------------------------------------------------------------------------------------------------------------------
// exception
//--------------------------------------------------------------------------------------------------------------------------------------------
function my_exception_handler($e) {
	to_log("ERR: ". iconv(HTML_ENCODING,LOCAL_ENCODING,$e));
}

function my_error_handler($no,$str,$file,$line) {		
	if ($no <> 2 ) {
		my_exception_handler(" '".$str."' файл: ".$file." строка: ".$line); 
	}
    return true;		
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Для загрузки конфигов
//--------------------------------------------------------------------------------------------------------------------------------------------
Function requre_script_file($file_name) {
if (!is_file($_SERVER['DOCUMENT_ROOT']."/library/".$file_name)) 
		die("Проблема при загрузке конфигурации и модулей, обратитесь к документации. [".$file_name."]");	
	require_once ($_SERVER['DOCUMENT_ROOT']."/library/".$file_name);
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Логирование
//--------------------------------------------------------------------------------------------------------------------------------------------
function to_log($log,$sub_debug = false) {

requre_script_file("auth.".AUTH.".php");

if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" ) and (( auth::get_user() != "") or ($sub_debug))) {
		$log = str_replace(array("\r\n", "\n", "\r", "\t", "    ","   ","  ")," ",$log);
		$log = iconv(LOCAL_ENCODING,HTML_ENCODING."//IGNORE",$log);
		file_put_contents(ENGINE_ROOT."/".HAS_DEBUG_FILE,"[".date("d.m.Y H:i:s")." <".strtoupper(auth::get_user()).">] ".$log."\r\n", FILE_APPEND | LOCK_EX);		
	}
}
//--------------------------------------------------------------------------------------------------------------------------------------------
// Класс подсчета времени выполнения
//--------------------------------------------------------------------------------------------------------------------------------------------	
class TIMER {
    private $starttime;
    function __construct() {
	    $mtime = microtime ();
        $mtime = explode (' ', $mtime);
        $mtime = $mtime[1] + $mtime[0];
        $this -> starttime = $mtime;
    }
	
	static function get_about() {
		return "Отладочная информация и DEBUG";
	}
	
    function __destruct() {
        $mtime = microtime ();
        $mtime = explode (' ', $mtime);
        $mtime = $mtime[1] + $mtime[0];
        $endtime = $mtime;
        $totaltime = round (($endtime - $this ->starttime), 5);
        to_log("LIB: Session ".SESSION_ID." end, worktime ".$totaltime);
    }
}

// Запускаем клас времени и дебагер
$timer = new TIMER();
to_log("LIB: New ".SESSION_ID." start ... ");

//--------------------------------------------------------------------------------------------------------------------------------------------
// Окно авторизации:
//--------------------------------------------------------------------------------------------------------------------------------------------
function Create_logon_window() {
clear_cache();
if (isset($_SERVER['HTTP_USER_AGENT']) &&  (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) { 
?>
<html class="no-js" lang="en-US">
<?
} else {
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html class="no-js" lang="en-US">
<?
}
?>
			<head>
				<meta charset="<?php echo strtolower(HTML_ENCODING); ?>">
				<title>IWS Login</title>
				<meta http-equiv="Content-Type" content="text/html; charset=<?php echo strtolower(HTML_ENCODING); ?>"/>
				<meta http-equiv="Pragma" content="no-cache" >
				<meta http-equiv="Cache-Control" content="no-cache">
				<?php if (isset($_SERVER['HTTP_USER_AGENT']) && (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) { 				
					echo "  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\" />";
				}?>				
				<link rel="shortcut icon" href="<?=ENGINE_HTTP?>/favicon.ico" />	
				<link rel="stylesheet" type="text/css" href="<?=ENGINE_HTTP?>/library/normalize.css?s=<?=SESSION_ID?>" />
<?php			
				// Тема не задана! Задаем тему по умомчанию и выводим напоминание пользователю чтобы зашел и сменил
				if (!is_dir(THEMES_DIR)) die ("Неуказана директория тем в конфигурации!");		
				$dh  = opendir(THEMES_DIR.DIRECTORY_SEPARATOR);
				while (false !== ($file = readdir($dh))) {
				if (($file == ".") or ($file == "..")) continue;
				  if (is_dir(THEMES_DIR. DIRECTORY_SEPARATOR . $file)) {
					$dh_sub  = opendir(THEMES_DIR. DIRECTORY_SEPARATOR . $file);
					while (false !== ($file_t = readdir($dh_sub))) {
						if (($file_t == ".") or ($file_t == "..")) continue;						
						if (strpos($file_t,".css") > 0) { 
								$theme_first['theme_file'][] = THEMES_DIR."/".$file."/".$file_t;
								$theme_first['theme_name'][] = $file;
								break;
							}	
						}
					}					
				}
				$theme_number = rand(0,count($theme_first['theme_file']) - 1);			
				if (isset($_COOKIE['theme_num_last'])) while ($theme_number == $_COOKIE['theme_num_last']) {
						$theme_number = rand(0,count($theme_first['theme_file']) - 1);
						
				}
				setcookie("theme_num_last", $theme_number);
				echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/".$theme_first['theme_file'][$theme_number]." \" /> \n";					
?>								
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-2.0.0.min.js?s=<?=SESSION_ID?>"></script>				
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-1.10.2.custom.min.js?s=<?=SESSION_ID?>"></script>
				<style type="text/css">											
						#loading {background:#ffffff url(<?=ENGINE_HTTP?>/library/ajax-loader.gif) no-repeat center center;height: 100%;width: 100%;position: absolute; z-index: 999999; }		
						html, body {padding: 0px; margin: 0px; overflow:hidden; font-size: 12px;}
						a { cursor:pointer; }		
				</style>						 
</head>
<body>
	<div id="loading"></div>	
<div id="logon" window_login="logon" class="ui-widget ui-widget-content ui-corner-all" style="position:absolute;text-align :center;width:400px;height:350px;">
<h3>
<?php
$main_db = new db();
if ($main_db)	echo $main_db -> get_settings_val("ROOT_CONFIG_NAME");
?>
</h3>
<p>Необходима авторизация, представьтесь:</p>	
<form method="POST" id="settings_from" style="position:absolute;text-align:center;width:200px;height:190px;top:100px;left:100px" >
		<div id="login_edit">
			<label for="username_or_email" tabindex="-1" class="ui-widget" style="font-size:1.2em"><b>Ваш логин:</b></label><br>
			<input aria-required="true"  autofocus="autofocus" id="username" name="username" class="ui-widget ui-widget-content ui-corner-all" style="height: 24px;"  type="text" /><br><br>
			<label for="password" tabindex="-1" style="font-size:1.2em"><b>Пароль:</b></label>
		</div>
			<input aria-required="true" id="password" class="ui-widget ui-widget-content ui-corner-all" name ="password" style="height: 24px;" type="password" /><br><br>
			<input type="submit" id="submit_settings" style="display: none;">
			<button>Войти</button>
</form>
<div id="login_theme" style="position:absolute;text-align:center;width:200px;height:20px;top:305px;left:100px">
	<h6>Случайная тема оформления, называется: "<?=$theme_first['theme_name'][$theme_number]?>"</h6>
</div>
</div>
<script type="text/javascript" >
 $(function() {
    $( "button" )
      .button()
      .click(function( event ) {
		if ($("#password").val() == "" || $("#username").val() == "")  custom_alert("Необходимо указать имя пользователя и пароль!");		
		if ($("#password").val() != "" && $("#username").val() != "") {
				$('#loading').show();
				$.ajax({
						url: '<?=ENGINE_HTTP?>/ajax.saveparams.php?act=login',
						datatype:'json',
						data: { username: $("#username").val(), password:  $("#password").val() },
						cache: false,
						type: 'POST',
							success: function(data) {	
								setTimeout(function(){
										$(location).prop('href','<?=ENGINE_HTTP?>/');	
								}, 1000);								
						}	  
					});
		}
		return false;
      });
  });
$(document).ready(function () {	
	$('#loading').fadeOut(300);		
});	  
$(window).resize(function () {
		$("#logon").css({ top: $(window).height()/2 - 175, left: $(window).width()/2 - 200 });			
});
$("#logon").css({ top: $(window).height()/2 - 175, left: $(window).width()/2 - 200 });		
</script>
</body>
<?php
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Сжимаем Javascript
//--------------------------------------------------------------------------------------------------------------------------------------------
function regex_javascript($str) {
$str = preg_replace(array(
					'/(?<!\:)\/\/(.*)\\n/',
					'/\s{2,}/',
					'/[\t\n]/'
					 ), '', $str); 
return $str;
}

//--------------------------------------------------------------------------------------------------------------------------------------------	
// Проверка загруженных классов
//--------------------------------------------------------------------------------------------------------------------------------------------
Function check_classes() {
// прогружаем оставшиеся
requre_script_file("lib.charts.php");
requre_script_file("lib.help.php");
requre_script_file("lib.input.php");
requre_script_file("lib.jqgrid.php");

//Проверяем о информации
$classes_define = get_declared_classes();
	foreach($classes_define as $key)  {
		if (method_exists($key, 'get_about')) {
			echo "<b>".strtoupper($key).":</b> ".call_user_func($key."::get_about")."<br>";
		}
	}
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Ескейпим стринги
//--------------------------------------------------------------------------------------------------------------------------------------------
Function Convert_quotas($num) { 
	if (is_int($num)) {
		return intval($num);
	} else {
		$tmp_num=strip_tags(html_entity_decode($num));
		return $tmp_num;
	}
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Принудительный редирект страници по адресу
//--------------------------------------------------------------------------------------------------------------------------------------------
Function Redirect($url) { 
	echo "<script language='JavaScript' type='text/javascript'>window.location.replace('".$url."')</script>";
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Текущий ИП
//--------------------------------------------------------------------------------------------------------------------------------------------
function get_ip() {
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
// Парсинг css файла на values
//--------------------------------------------------------------------------------------------------------------------------------------------
Function css_get_value($css_file, $section, $value) { 
	$found = false;
	$css_content = "{";
	$lines = file($css_file);
		foreach ($lines as $line_num => $line) {
			// Ищем раздел
			if ($found) $css_content .= trim($line)."\n";
			if (strpos(strtolower($line), strtolower($section." {"))) $found = true;
			if ($found and (trim($line) == '}')) {
				// Нашли секцию, разбиваем:
				preg_match_all('/\s*([-\w]+)\s*:?\s*(.*?)\s*;/m', $css_content, $matches);
				// Ищем нужную:
				foreach ($matches[0] as $sec => $sec_line) {
					if (strpos(strtolower($sec_line), strtolower($value))) {
						// Нашли ключь
						$result = explode(" ", $sec_line);
						// Возвращаем значение
						if (isset($result[1])) {
								return $result[1];
						} else {
								return '#FFFFFF';
						}
					}
				}				
			}			
	}	
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Обрезает айдишник филда в конце
//--------------------------------------------------------------------------------------------------------------------------------------------
Function trim_fieldname($field_name, $id = false) {
	if ($id == false) {
			$name = substr($field_name, 0, strrpos($field_name, "_"));			
		} else {
			$name = str_replace("_".$id,"",$field_name);
	}
	return $name;
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Обрезка пробелов в строке, включая html пробел
//--------------------------------------------------------------------------------------------------------------------------------------------
Function FullTrim($txt) {
		return trim(str_replace("&nbsp;","",$txt));
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Сохранение масивов и переменных в кеш (с помощью кукисов)
//--------------------------------------------------------------------------------------------------------------------------------------------
function save_to_cache($name, $value, $time = -1) {		
	if (!isset($_SESSION["ENABLED_CACHE"])) {
		if ($time < 0) $time = time() + 10800; // по умолчанию 3 часа			
			$cokie = base64_encode(gzencode(json_encode($value)));					
			$_SESSION[strtoupper($name)] = $cokie;			
			to_log("LIB: ".strtoupper($name)." saved to cache");
	}
}

//--------------------------------------------------------------------------------------------------------------------------------------------	
// Загрузка переменной из кеша если она там есть:
//--------------------------------------------------------------------------------------------------------------------------------------------
function load_from_cache($name, $is_array = true) {	
		if (isset($_SESSION[strtoupper($name)])  and !isset($_SESSION["ENABLED_CACHE"])) {
				// Кукие есть, загружаем их, загружаем их в массив и выходим.
				$to_menu = $_SESSION[strtoupper($name)];				
				// Распаковываем без проверки чексум, баг firefox'a
				$to_menu = json_decode(gzinflate(substr(base64_decode($to_menu),10,-8)), $is_array);		 			
				// Проверяем есть ли данные, если есть то перемещаем их в массив
				if (!empty($to_menu)) {
					to_log("LIB: ".strtoupper($name)." from cache");
					return $to_menu;
				}
			} else {
			 return false;
			}
}

//--------------------------------------------------------------------------------------------------------------------------------------------	
// Отчистка кеша, частично либо полностью:
//--------------------------------------------------------------------------------------------------------------------------------------------
function clear_cache($name = false) {	
	if ($name != false) {
			if ($name == "no_user") {
				// все кроме пользователя
				$us = isset($_SESSION['us_name'])?$_SESSION['us_name']:"";
				$ps = isset($_SESSION['us_pr'])?$_SESSION['us_pr']:"";
				session_destroy();	
				session_start();
				$_SESSION['us_name'] = $us;
				$_SESSION['us_pr']	 = $ps;
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
function end_session() {
	session_write_close();  // Закрываем сейсию для паралельного исполнния
}

//--------------------------------------------------------------------------------------------------------------------------------------------	
// Создаем о программе
//--------------------------------------------------------------------------------------------------------------------------------------------
function about($db) {
?>
	<div id="about" title="О программе" style="text-align:left">
	<div class="ui-widget-header ui-state-default about_tabs_pict" style="top:5%; width:90%;text-align :right;position:absolute;border:1px transparent;background: transparent;margin:10px;opacity: 1">
	<?php
	$about_logo = $db -> get_settings_val('ROOT_CONFIG_LOGO');
	if (!empty($about_logo) and is_file(ENGINE_HTTP.DIRECTORY_SEPARATOR.$about_logo)) echo "<img src='".ENGINE_HTTP.DIRECTORY_SEPARATOR.$about_logo."'>";
	?>
	</div>
	<p><b style="font-size:220%;">IWS</b><br><b>Intellectual web system</b><br>
	<b>Версия системы:</b> <?=VERSION_ENGINE?><br>
	<b>Конфигурация:</b><br><?=$db -> get_settings_val('ROOT_CONFIG_NAME')?> версия: <?=$db -> get_settings_val('ROOT_CONFIG_VERSION')?> <br>
	</p>
	<p><b>Авторы:</b> Лысиков А.В., Мындра П.А.</p>
	<b>Подключенные модули:</b></br>
	<div class="ui-widget-content" style="height:110px;overflow: auto;font-size:80%;padding: .5em 1em; text-align:left;position: relative;">
	<?php	
	check_classes();	
	if (is_dir(HELP_FOLDER))
			if (HELP) {
				echo "<button class='help_button' url='".ENGINE_HTTP."/ajax.tab.php?action=help'>Справочный раздел</button>";
			} 
	?>
	</div>
	<b>Используемые сторонние бибилиотеки под <a href="http://opensource.org/licenses/mit-license.php">MIT License:</a></b></br>
	<div class="ui-widget-content" style="height:30px;overflow: auto;font-size:80%;padding: .5em 1em; text-align:center;position: relative;">
		<a href="http://www.phpexcel.net" target="_blank">PHPExcel</a>,
		<a href="http://jqgrid.com" target="_blank">JQGrid</a>,
		<a href="http://jquery.com/" target="_blank">JQuery</a>,
		<a href="http://jqueryui.com/" target="_blank">JQuery UI</a>,
		<a href="http://trentrichardson.com/examples/timepicker/" target="_blank">JQuery TimePicker</a>,
		<a href="https://github.com/johnculviner/jquery.fileDownload" target="_blank">JQuery fileDownload</a>,
		<a href="https://github.com/jquery/globalize" target="_blank">JQuery globalize</a>,
		<a href="http://ace.ajax.org/" target="_blank">ACE Cloud9 Editor</a>,
		<a href="https://github.com/ehynds/jquery-ui-multiselect-widget" target="_blank">JQuery UI multiselect</a>,		
		<a href="http://sourceforge.net/projects/fusioncharts/" target="_blank">FusionCharts free (Under GNU License)</a>
	</div>
	<a href="<?=ENGINE_HTTP?>/history.txt" target="_blank"><b>История изменений:</b></a><br>
		<div class="ui-widget-content" style="height:150px;overflow: auto;font-size:70%;padding: .5em 1em; text-align:left;position: relative;">
		<?=str_replace("\n","<br>",file_get_contents(ENGINE_ROOT."/history.txt"))?>
		</div>
	</div>
<?php
}

//--------------------------------------------------------------------------------------------------------------------------------------------	
// Корректная gzip функция
//--------------------------------------------------------------------------------------------------------------------------------------------
function gzdecode_zip($data) {
  $len = strlen($data);
  if ($len < 18 || strcmp(substr($data,0,2),"\x1f\x8b")) {
    return null;  
  }
  $method = ord(substr($data,2,1));  
  $flags  = ord(substr($data,3,1));  
  if ($flags & 31 != $flags) {    
    return null;
  }

  $mtime = unpack("V", substr($data,4,4));
  $mtime = $mtime[1];
  $xfl   = substr($data,8,1);
  $os    = substr($data,8,1);
  $headerlen = 10;
  $extralen  = 0;
  $extra     = "";
  if ($flags & 4) {
  
    if ($len - $headerlen - 2 < 8) {
      return false;   
    }
    $extralen = unpack("v",substr($data,8,2));
    $extralen = $extralen[1];
    if ($len - $headerlen - 2 - $extralen < 8) {
      return false;   
    }
    $extra = substr($data,10,$extralen);
    $headerlen += 2 + $extralen;
  }

  $filenamelen = 0;
  $filename = "";
  if ($flags & 8) {
   
    if ($len - $headerlen - 1 < 8) {
      return false; 
    }
    $filenamelen = strpos(substr($data,8+$extralen),chr(0));
    if ($filenamelen === false || $len - $headerlen - $filenamelen - 1 < 8) {
      return false;   
    }
    $filename = substr($data,$headerlen,$filenamelen);
    $headerlen += $filenamelen + 1;
  }

  $commentlen = 0;
  $comment = "";
  if ($flags & 16) {
   
    if ($len - $headerlen - 1 < 8) {
      return false;  
    }
    $commentlen = strpos(substr($data,8+$extralen+$filenamelen),chr(0));
    if ($commentlen === false || $len - $headerlen - $commentlen - 1 < 8) {
      return false;  
    }
    $comment = substr($data,$headerlen,$commentlen);
    $headerlen += $commentlen + 1;
  }

  $headercrc = "";
  if ($flags & 2) {
    
    if ($len - $headerlen - 2 < 8) {
      return false;   
    }
    $calccrc = crc32(substr($data,0,$headerlen)) & 0xffff;
    $headercrc = unpack("v", substr($data,$headerlen,2));
    $headercrc = $headercrc[1];
    if ($headercrc != $calccrc) {
      return false;  
    }
    $headerlen += 2;
  }

 
  $datacrc = unpack("V",substr($data,-8,4));
  $datacrc = $datacrc[1];
  $isize = unpack("V",substr($data,-4));
  $isize = $isize[1];

 
  $bodylen = $len-$headerlen-8;
  if ($bodylen < 1) {
   
    return null;
  }
  $body = substr($data,$headerlen,$bodylen);
  $data = "";
  if ($bodylen > 0) {
    switch ($method) {
      case 8:
        
        $data = gzinflate($body);
        break;
      default:
      
        return false;
    }
  } 
  if ($isize != strlen($data) || crc32($data) != $datacrc) {
    return false;
  }
  return $data;
}

//--------------------------------------------------------------------------------------------------------------------------------------------	
// Создание select списка для jqgrid
//--------------------------------------------------------------------------------------------------------------------------------------------
function get_select_data($db, $sql, $rowid) {

// заменяем ровид если передан
$sql = str_ireplace(":rowid",$rowid,$sql);	
// Проверяем кодировку

$sql = iconv(HTML_ENCODING,LOCAL_ENCODING."//TRANSLIT", $sql);
					
// Выполняем запрос на получение данных:
$query = $db -> sql_execute($sql);	
$level 		= 0;
$countgroup = 0;
$i			= 0;
$rezult		= "";

while ($db -> sql_fetch($query)) {
	// поддержка опт группы (optgroup):
	if (trim($db -> sql_result($query, "LEV")) !="" ) {	
		// Используем группы, сначала заполняем данные в массив		
		if (($level != $db -> sql_result($query, "LEV")) and ($level != 0)) {
			if ($level < $db -> sql_result($query, "LEV")) {	
					$sd_name	= "";
					if (isset($sd_options_content[$i - 3]) and (intval($sd_options_content[$i - 3]['LEV']) == intval($sd_options_content[$i - 1]['LEV'] + 1))) {
						$sd_name			    	= $sd_options_content[$i - 1]['NAME'];
						$sd_options_content[$i]		= $sd_options_content[$i - 1];
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
		$sd_options_content[$i]['ID']		=	Convert_quotas($db -> sql_result($query, "ID"));
		$sd_options_content[$i]['NAME'] 	=   str_ireplace("'","",trim(Convert_quotas($db -> sql_result($query, "NAME"))));
		$sd_options_content[$i]['LEV']		=	$db -> sql_result($query, "LEV");
		
		$i++; // Обновляем индекс
		$level = $db -> sql_result($query, "LEV"); // Сохраняем индекс
	} else {	
		// Отп группы не используем, просто отдаем данные в селект
		$sd_options_content[$i]['ID']		=	Convert_quotas($db -> sql_result($query, "ID"));
		$sd_options_content[$i]['NAME'] 	=   str_ireplace("'","",trim(Convert_quotas($db -> sql_result($query, "NAME"))));
		$i++;
	}
}

// Сформировали, выводим:
if (isset($sd_options_content)) foreach ($sd_options_content as $key) {
	$rezult .= $key['ID'].":".$key['NAME'].";";
}

// Вдруг у нас незакрытые группы
while( $countgroup != 0) {
	$rezult .=  "GROUP_END:;";
	$countgroup--;
}

// убираем последнюю точку с зяпятой
return rtrim(trim($rezult), ";");	
}
 
// $ чекаем сейсию на предмет подмены куков либо самой сейсии:
if (isset($_SESSION['control_ses'])) {
	// проверяем:
	if (($_SESSION['control_ses_ip'] != get_ip()) or ($_SESSION['control_ses_agent'] != $_SERVER['HTTP_USER_AGENT'])) {
		// Возможно пользователь сменил браузер либо попытка подмены сейсии
		session_destroy(); // убиваем сейсию для безопастности
		die(Create_logon_window());
	}
} else {
	$_SESSION['control_ses_ip'] = get_ip();
	$_SESSION['control_ses_agent'] = $_SERVER['HTTP_USER_AGENT'];
}

?>