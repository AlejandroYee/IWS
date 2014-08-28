#!/usr/bin/php
<?php

define("ENGINE_ROOT", "/var/www/html"); // папка с установленной конфигурацией IWS
define("CONFIG","faxserver.domain.ru"); // конфигурация IWS
define("OUT_FOLDER_ASTERISK","/var/spool/asterisk/outgoing"); // папка исходящий call файлов астериск
define("TMP_FOLDER_ASTERISK","/tmp/"); // временная дирректория для работы
define("ALLOWED_DOMAIN","@domain.ru"); // разрешенный домен отправителей факса
define('LOCK_FILE', "/var/run/" . basename($argv[0], ".php") . ".lock"); // файл пида скрипта

/*
 * В коде часто встречается $db->get_settings_val("")
 * это получение параметра настроек которые храняться и изменяются через веб интерфейс
 * указывается имя параметра
 */

$action = false;
$number = false;
$file	= false;
$status = false;
$error  = false;
$p_query_id = 0;
register_shutdown_function('unlink', LOCK_FILE); // удалим лок файл в случае завершения работы скрипта

// используются модули IWS:
require_once("library/lib.func.php");
BasicFunctions::requre_script_file("lib.smtp.php");
BasicFunctions::requre_script_file("db.".DB.".php");
BasicFunctions::requre_script_file("lib.gz.php");

// считываем параметры переданные скрипту
$arguments = BasicFunctions::getinput_var($argv);

if (isset($arguments['help'])) {
die("
usage: console_fax.php [--help] --number=1111 --from=9285558754 --status=RESIVED [--error='some error'] --file=/tmp/1.tif 
 
Options:
            --help      Show this message
            --number    Extension who has change status
            --from      Phone number send or resive fax
            --status    Status operarion [INCOMING, RESIVED, SEND]
            --error     If error halted
            --file      Image file for fax
");
}  

// создаем подключение к бд (используется конфигурация IWS)
$db = new DB(); 

/*
 * функция позволяет проверить запущен ли сейчас скрипт?
 */
function isLocked() { 
    if( file_exists( LOCK_FILE ) ) { 
        $lockingPID = trim( file_get_contents( LOCK_FILE ) ); 
        $pids = explode( "\n", trim( `ps -e | awk '{print $1}'` ) ); 
        if( in_array( $lockingPID, $pids ) )  return true;
        unlink( LOCK_FILE );
	}
    file_put_contents( LOCK_FILE, getmypid() . "\n" ); 
    return false; 
} 

/*
 * функции для работы с почтой и вложениями
 */
// получаем содержимое буфера соединения с сервером почты
function get_data($pop_conn) {
    $data = "";
    while (!feof($pop_conn)) {
        $buffer = chop(fgets($pop_conn,1024));
        $data .= "$buffer\r\n";
        if(trim($buffer) == ".") break;
    }
    return $data;
}

// получаем структуру письма при запросе писем
function fetch_structure($email) {
    $ARemail = Array();
    $separador = "\r\n\r\n";
    $header = trim(substr($email,0,strpos($email,$separador)));
    $bodypos = strlen($header)+strlen($separador);
    $body = substr($email,$bodypos,strlen($email)-$bodypos);
    $ARemail["header"] = $header;
    $ARemail["body"] = $body;
    return $ARemail;
}

// декодируем заголовок письма
function decode_header($header) {
    $count=substr_count ($header, "\r\n\t");
    for ($i=1; $i<=$count; $i++) $header=substr_replace ($header, " ", strpos ($header, "\r\n\t"), 3);
    $lasthead = "";
    $headers = explode("\r\n",$header);
    $decodedheaders = Array();
    for($i=0;$i<count($headers);$i++) {
        $thisheader = trim($headers[$i]);
        if(!empty($thisheader))
        if(!preg_match("/^[A-Z0-9a-z_-]+:/",$thisheader))
                $decodedheaders[$lasthead] .= " $thisheader";          
        else {
            $dbpoint = strpos($thisheader,":");
            $headname = strtolower(substr($thisheader,0,$dbpoint));
            $headvalue = trim(substr($thisheader,$dbpoint+1));
            if(isset($decodedheaders[$headname]) and ($decodedheaders[$headname] != "")) $decodedheaders[$headname] .= "; $headvalue";
            else $decodedheaders[$headname] = $headvalue;
            $lasthead = $headname;
        }
    }
    return $decodedheaders;
}

// преобразование и перекодирование строки mime, поддерживаем кои8 и утф
function decode_mime_string($subject) {
    $string = $subject;
    if(($pos = strpos($string,"=?")) === false) return $string;
    $newresult = "";
    while(!($pos === false)) {
        $newresult .= substr($string,0,$pos);
        $string = substr($string,$pos+2,strlen($string));
        $intpos = strpos($string,"?");
        $charset = substr($string,0,$intpos);
        $enctype = strtolower(substr($string,$intpos+1,1));
        $string = substr($string,$intpos+3,strlen($string));
        $endpos = strpos($string,"?=");
        $mystring = substr($string,0,$endpos);
        $string = substr($string,$endpos+2,strlen($string));
        if($enctype == "q") $mystring = quoted_printable_decode(preg_replace("_"," ",$mystring));
        else if ($enctype == "b") $mystring = base64_decode($mystring);
        $newresult .= $mystring;
        $pos = strpos($string,"=?");
    }

    $result = $newresult.$string;
    if(preg_match("/koi8/", $subject)) $result = convert_cyr_string($result, "k", "w");
    if(preg_match("/KOI8/", $subject)) $result = convert_cyr_string($result, "k", "w");
    if(preg_match("/utf-8/", $subject)) $result = iconv("UTF-8", "WINDOWS-1251", $result);
    if(preg_match("/UTF-8/", $subject)) $result = iconv("UTF-8", "WINDOWS-1251", $result);

    return $result;
}

// находим в теле письма разделитель вложений
function get_boundary($ctype){
    if(preg_match('/boundary[ ]?=[ ]?(["]?.*)/i',$ctype,$regs)) {
        $boundary = preg_replace('/\"(.*)\"$/', "\\1", $regs[1]);
        $boundary = explode ("\"", $boundary);
        return trim("--$boundary[0]");
    }
}

// разбиваем письмо по вложениям
function split_parts($boundary,$body) {
    $startpos = strpos($body,$boundary)+strlen($boundary)+2;
    $lenbody = strpos($body,"\r\n$boundary--") - $startpos;
    $body = substr($body,$startpos,$lenbody);
    return explode($boundary."\r\n",$body);
}

// функция позволяющая собрать тело письма в единое целое и закодировать его
function compile_body($body,$enctype,$ctype) {
    $enctype = explode(" ",$enctype); $enctype = $enctype[0];
    if(strtolower($enctype) == "base64")
         $body = base64_decode($body);
    elseif(strtolower($enctype) == "quoted-printable")
         $body = quoted_printable_decode($body);
    if(preg_match("/koi8/", $ctype)) $body = convert_cyr_string($body, "k", "w");
    if(preg_match("/utf-8/", $ctype)) $body = iconv("UTF-8", "WINDOWS-1251", $body);
    if(preg_match("/UTF-8/", $ctype)) $body = iconv("UTF-8", "WINDOWS-1251", $body);
    return $body;
}

// Отправка письма
function SendMail($mail_to, $subject, $param, $body) { 
    $db = new DB();
    $smtp=new smtp_class;
	$smtp->host_name=$db->get_settings_val("SETTINGS_MAIL_SMTP_HOST");      
	$smtp->host_port=25;            
	$smtp->ssl=0;
    $smtp->start_tls=0; 
	$smtp->localhost="localhost";    
	$smtp->timeout=10;              
	$smtp->data_timeout=0;        
	$smtp->debug=1;                  
	$smtp->html_debug=0;             
	$smtp->user=$db->get_settings_val("SETTINGS_MAIL_SMTP_AUTHLOGIN") ;     
	$smtp->password=$db->get_settings_val("SETTINGS_MAIL_SMTP_AUTHPWD"); 
	$smtp->authentication_mechanism=""; 
    if($smtp->SendMessage(
		$db->get_settings_val("SETTINGS_MAIL_SMTP_SENDER"),
		array( $mail_to ), array(
									"From: ".get_settings_val("SETTINGS_MAIL_SMTP_SENDER"),
									"To: ".$mail_to,
									"Subject: ".$subject,
									"Date: ".strftime("%a, %d %b %Y %H:%M:%S %Z")
							), $body)) {
            return true;
        } else {
            return false;
        }
}

/*
 * ЧАСТЬ ПЕРВАЯ: ОБРАБОТКА СТАТУСОВ ИЗ АСТЕРИСКА
 * Обработка статусов которые могут быть нам переданы с астериска
 * основная часть которая отрабатывает всегда
 */
 
// Заглушка на случай если нам не передали номер звонящего (иногда при переадресации возникает такая ситуация)
if (!isset($arguments['from']) or empty($arguments['from'])) {
    $arguments['from'] = "undefined";
}

if (isset($arguments['status']))
    switch (strtoupper($arguments['status'])) {
        case 'INCOMING':
		// Вызывается когда факс только идет к нам (при инициализации соединения на астериске)
		// Просто создаем запись в табличке статусов чтобы видеть что идет факс, и откуда идет
        $query = $db -> sql_execute("insert into fax_query t (id_tranks, in_out, file_pic, status, tel_number) select (select p.id_tranks from tranks p
                                                     where p.name_prefix like '".$arguments['number']."' and rownum = 1) as id_tranks,
                                                   'I' as in_out, '".str_ireplace(TMP_FOLDER_ASTERISK,"",$arguments['file'])."' as file_pic,
                                                   upper('".$arguments['status']."') as status, '".$arguments['from']."' as tel_number from dual");
        break;
        case 'RESIVED':
		// Случай когда факс к нам пришел и сохранен во временную папку
		
		// пытаемся получить айди записи сделаной при статусе INCOMING
		$query_resivd = $db -> sql_execute("select count(*) as count_ret from fax_query t where t.id_tranks in (select p.id_tranks from tranks p where p.name_prefix like '".$arguments['number']."') "
											. "and t.status = 'ERROR' and t.tel_number ='".$arguments['from']."'"); 
		while ($db -> sql_fetch($query_resivd)) $count_ret = $db -> sql_result($query_resivd, "count_ret");
		
		// Проверяем аргументы ошибок и количества попыток принять факс
		if (!empty($count_ret) and (!isset($arguments['error']) or (empty($arguments['error'])))) {
		   $count_ret = "Count retry: ".$count_ret; 
		   $db -> sql_execute("delete from fax_query t where t.id_tranks in (select p.id_tranks from tranks p where p.name_prefix like '".$arguments['number']."') and t.status = 'ERROR' and t.tel_number ='".$arguments['from']."'"); 
		}
		if ($count_ret === 0) $count_ret = ""; 
		
		// обновляем нашу запись отом что факс принят и записываем ошибки в случае если они возникли
		$db -> sql_execute("update fax_query t set t.status = '".$arguments['status']."',t.error ='".$count_ret."' where t.id_tranks in (select p.id_tranks from tranks p where p.name_prefix like '".$arguments['number']."') "
				. "and t.file_pic = '".str_ireplace(TMP_FOLDER_ASTERISK,"",$arguments['file'])."' and t.tel_number ='".$arguments['from']."'");  
		
		if (is_file($arguments['file'])) {
			// если с файлом все нормально то
			$data = file_get_contents($arguments['file']);
			// кодируем, жмем и
			$filedata = str_split(base64_encode(gz::gzencode_zip($data)), 2048);
			// записываем в бд почастям, чтобы небыло переполнения varchar2 (т.к. удобнее писать черезе varchar2 а не через clob)
			foreach($filedata as $File_data_str) {
					$db -> sql_execute("update fax_query t set t.file_pic_content = t.file_pic_content || '" .$File_data_str. "'"
										. "where t.id_tranks in (select p.id_tranks from tranks p where p.name_prefix like '".$arguments['number']."') "
										. "and t.file_pic = '".str_ireplace(TMP_FOLDER_ASTERISK,"",$arguments['file'])."' and t.tel_number ='".$arguments['from']."'"); 
			}
			// удаляем временный файл
			unlink($arguments['file']);
		} else {
			// файл не пришел, но и ошибки небыло, значит произошла ощибка передачи или сброс вызова, но астериск ошибку не передал
			if (!isset($arguments['error']) or (empty($arguments['error'])))  $arguments['error'] = "Call hangup from ".$arguments['from'];
			// обновляем статус на ошибку
			$db -> sql_execute("update fax_query t set t.status = 'ERROR',  t.error = '".$arguments['error']."' "
				. "where t.id_tranks in (select p.id_tranks from tranks p where p.name_prefix like '".$arguments['number']."') "
				. "and t.file_pic = '".str_ireplace(TMP_FOLDER_ASTERISK,"",$arguments['file'])."' and t.tel_number ='".$arguments['from']."'");  
		}   
        break;
        case 'SEND': 
            // случай когда мы отправляем факс
			
            $tmp_error = "";
            $tmp_fax_id = "";
			// получаем айди для дальнейше работы, а переменная error в данном случае контролирует количество попыток
            $query_send = $db -> sql_execute("select * from FAX_QUERY t where t.status = 'SENDING' and p.name_prefix like '".$arguments['number']."') and t.file_pic = '".str_ireplace(TMP_FOLDER_ASTERISK,"",$arguments['file'])."' and t.tel_number ='".$arguments['from']."'");
            while ($db -> sql_fetch($query_send)) { 
                $tmp_error = $db -> sql_result($query_send, "error");
                $tmp_fax_id = $db -> sql_result($query_send, "id_fax_query");
            } 
			
			// если айдишник есть
            if (!empty($tmp_fax_id)) {  
				
                if (!isset($arguments['error']) or (empty($arguments['error']))) { 
					// если отправился то просто обновляем бд
                    $db -> sql_execute("update fax_query t set t.status = '".$arguments['status']."' where t.id_fax_query = ".$tmp_fax_id);  
                    if (is_file($arguments['file']))  unlink($arguments['file']);                    
                } else {
					// смотрим на количество попыток
                    $num_ret = explode(":",$tmp_error);
                    $num_ret_val = intval($num_ret[1]);
                    if ($num_ret_val > 3) {
						// если больше 3х то тогда записываем ошибку и чистим файл
                        $arguments['status'] = "ERROR";
                        $arguments['error'] = "После ".$num_ret_val." попыток, факс так и небыл принят.";
                        if (is_file($arguments['file']))  unlink($arguments['file']);                        
                    } else {
						// если меньше 3х то тогда пробуем еще
                        $arguments['error']="Retry:".($num_ret_val+1);
                    }
					// записываем статус в базу
                    $db -> sql_execute("update fax_query t set t.status = '".$arguments['status']."',  t.error = '".$arguments['error']."' where t.id_fax_query = ".$tmp_fax_id);
                }  
            }
        break;    
}

/* Проверям запущен ли скрипт или нет сейчас
 * т.к. соединение с сервером почты может быть достаточно долго,
 * то не следует открывать еще одно чтобы не случилось коллизий.
 * Но часть кода перед этой проверкой будет выполняться всегда и
 * обработка событий от астериска будет выполняться всегда
 */
if( isLocked() ) die(); 

// Переносим сообщения с ошибками в историю в случае если они прошли все обработки, и добавляем количество вызовов если нужно
$db -> sql_execute("insert into messages select null as id_message,  'I' as in_out, max(s.tel_number) as tel_number, null as id_files, null as email, null as wb_user, 'ERROR' as status,
       'Count retry: ' || max(s.counts) || ', ' || listagg(s.error, ', ') within group(order by null) as error, min(s.create_date) as create_date, max(s.last_date) as last_date, max(s.id_tranks) as id_tranks
        from (select distinct t.id_tranks, t.error, t.tel_number, count(t.id_fax_query) over(partition by t.tel_number, t.id_tranks) as counts, max(t.last_date) over(partition by t.tel_number, t.id_tranks) as last_date,
        min(t.create_date) over(partition by t.tel_number, t.id_tranks) as create_date from fax_query t where t.in_out = 'I' and t.status = 'ERROR') s
        where s.last_date < sysdate - 1 / 24 / 2 group by s.id_tranks, s.tel_number");
// Чистим таблицу после предыдущего запроса, чтобы убрать лишние записи		
$db -> sql_execute("delete from fax_query t where t.in_out = 'I' and t.status = 'ERROR' and t.last_date < sysdate - 1 / 24 / 2");

/*
 * ЧАСТЬ ВТОРАЯ: ОПОВЕЩЕНИЯ
 * Селект из БД для оповещения пользователей в случае если состояние факса изменилось
 */
$query_send = $db -> sql_execute("select * from (select null as email_lists, null as wb_user, to_char(fq.create_date, 'dd.mm.yyyy hh24:mi:ss') as msg_date, to_char(fq.last_date, 'dd.mm.yyyy hh24:mi:ss') as msg_last_date, fq.*,
               count(rownum) over (partition by null) as count_mails from fax_query fq where fq.in_out = 'O' and fq.status in ('SEND','ERROR') order by fq.id_fax_query) union all
			   select * from (select p.email_lists, p.wb_user, to_char(fq.create_date, 'dd.mm.yyyy hh24:mi:ss') as msg_date, to_char(fq.last_date, 'dd.mm.yyyy hh24:mi:ss') as msg_last_date, fq.*,
               count(rownum) over (partition by null) as count_mails from (select id_fax_query, email_lists, max(wb_user) as wb_user from (select t.id_fax_query, l.email_lists, null as wb_user from fax_query t
               left join lists l on l.id_tranks = t.id_tranks and (l.in_out = 'I' or l.in_out = 'A') where t.status = 'RESIVED' and t.in_out = 'I' union all
               select t.id_fax_query, wu.e_mail as email_lists, wu.id_wb_user  wb_user from fax_query t left join lists_user lu on lu.id_tranks = t.id_tranks and (lu.in_out = 'I' or lu.in_out = 'A')
               left join wb_user wu on wu.id_wb_user = lu.wb_user where t.status = 'RESIVED' and t.in_out = 'I') group by id_fax_query, email_lists) p
               inner join fax_query fq on fq.id_fax_query = p.id_fax_query order by p.id_fax_query) where email_lists is not null or count_mails < 2");
while ($db -> sql_fetch($query_send)) { 
    $file_id    = false;
    $query_now  = $db -> sql_result($query_send, "id_fax_query");
    $error      = $db -> sql_result($query_send, "error");
    $status     = $db -> sql_result($query_send, "status");
    $user       = $db -> sql_result($query_send, "wb_user");
    $mail_to    = $db -> sql_result($query_send, "email_lists");
    $id_tranks  = $db -> sql_result($query_send, "ID_TRANKS");
	
	// проверка на наличе файл в табличке с файлами
    $query_file = $db -> sql_execute("select f.id_files from files f where lower(f.file_pic) = lower('".$db -> sql_result($query_send, "file_pic")."')");
    while ($db -> sql_fetch($query_file)) $file_id = $db -> sql_result($query_file, "id_files");
	
    // если файлна нет, то добавляем его (перенося из рабочей таблички
    if ($file_id === false and !empty($query_file)) {
        $file_id =  $query_tmp = $db -> sql_execute("insert into files f (file_pic, file_pic_content) values ((select t.file_pic from fax_query t where t.id_fax_query = ".$query_now."), (select t.file_pic_content from fax_query t where t.id_fax_query = ".$query_now.")) returning id_files into :rid");	
    }  
    if (empty($user)) $user  = "null";
	
    // Статусы факса  
    switch ($status) {
        case 'RESIVED':
            $subject = "Вам пришло новое факсимильное сообщение";
            $message = "Здравствуете, вам поступило факсимильное сообщение от номера:\n";
            $message .= $db -> sql_result($query_send, "tel_number")."\n\n";
            $message .= "Дата приема сообщения:\n";
            $message .= $db -> sql_result($query_send, "msg_date")."\n\n";
        break;
        case 'SEND':            
            $mail_to = $db -> sql_result($query_send, "sender");
            $subject = "Статус вашего факсимильного сообщения номер: ".$db -> sql_result($query_send, "id_fax_query");
            $message = "Ваше факсимильное сообщение для номера:\n";
            $message .= $db -> sql_result($query_send, "tel_number")." от ".$db -> sql_result($query_send, "msg_date")."\n\n";
            $message .= "Отправлено в:\n";
            $message .= $db -> sql_result($query_send, "msg_last_date")."\n\n";            
        break;
        case 'ERROR':
            $mail_to = $db -> sql_result($query_send, "sender");
            $subject = "Статус вашего факсимильного сообщения номер: ".$db -> sql_result($query_send, "id_fax_query");;
            $message = "Ваше факсимильное сообщение для номера:\n";
            $message .= $db -> sql_result($query_send, "tel_number")." от ".$db -> sql_result($query_send, "msg_date")."\n\n";
            $message .= "Неотправлено из за ошибки:\n";
            $message .= $error."\n\n";
        break;
    }
	
	// теперь формируем само письмо, основныех хидеры письма:
    $separator = md5(time());
    $eol = PHP_EOL;
    $headers  = "From: fax-server <".$db->get_settings_val("SETTINGS_MAIL_SMTP_SENDER").">" . $eol;
    $headers .= "MIME-Version: 1.0" . $eol;
    $headers .= "Content-Type: multipart/mixed; boundary=\"" . $separator . "\"" . $eol . $eol;
    $headers .= "Content-Transfer-Encoding: 7bit" . $eol;
    $headers .= "This is a MIME encoded message." . $eol . $eol;    
    $headers .= "--" . $separator . $eol;
    $headers .= "Content-Type: text/plain; charset=\"UTF-8\"" . $eol;
    $headers .= "Content-Transfer-Encoding: 8bit" . $eol . $eol;
    $headers .= $message . $eol . $eol;
	
	// Если факс пришел ДЛЯ пользователя, то прикрепляем к письму сам файл
    if ($status == "RESIVED") {
        $headers .= "--" . $separator . $eol;
        $headers .= "Content-Type: application/octet-stream; name=\"" . $db -> sql_result($query_send, "file_pic") . "\"" . $eol;
        $headers .= "Content-Transfer-Encoding: base64" . $eol;
        $headers .= "Content-Disposition: attachment" . $eol . $eol;
        $headers .= chunk_split(base64_encode(gz::gzdecode_zip(base64_decode($db -> sql_result($query_send, "file_pic_content"))))) . $eol . $eol;
    }
	
	// Закрываем письмо контрольным boundary
    $headers .= "--" . $separator . "--";   
	
    // В случае если неуказано или произошла ошибка определения кому отправить факс, то берем адрес для писем поумолчанию из настроек
	if (empty($mail_to)) $mail_to = $db->get_settings_val("SETTINGS_DEFAULT_MAIL");
	
	// отправляем и смотрим отправилось или нет
    if (!SendMail($mail_to, $subject, "", $headers))  $error = "Ошибка почтового сервера при отправке письма";
	
    // Записываем статус факсового сообщения в базу, и перемещаем его в историю
    $query_tmp = $db -> sql_execute("insert into messages (in_out, tel_number, id_files, email, wb_user, status, error, create_date, last_date,id_tranks) values ('".$db -> sql_result($query_send, "in_out")."', '".$db -> sql_result($query_send, "tel_number")."', ".$file_id.", "
                                   . "'".$mail_to."', ".$user.", '".$status."', '".iconv(HTML_ENCODING,LOCAL_ENCODING,$error)."',to_date('".$db -> sql_result($query_send, "msg_date")."','dd.mm.yyyy hh24:mi:ss') ,"
                                   . "to_date('".$db -> sql_result($query_send, "msg_last_date")."','dd.mm.yyyy hh24:mi:ss'),".intval(trim($id_tranks)).")");
    
	// В случае если пытались отправить или принять факс несколько раз, то у нас останутся несколько записей про это
	// следовательно нужно их подчистить (к слову селект который формирует письма идет с ордером по номеру телефона факса)
	// по этому сравниваем айди предыдущей запими и текущей, в случаем если изменился айди, то предыдущие запись можно подчистить
	// так как предыдущий скрипт уже внес количество попыток отправки или получения
	if ($p_query_id != $query_now) $query_tmp = $db -> sql_execute("delete from fax_query ff where ff.id_fax_query = ".$p_query_id);
    $p_query_id = $query_now;
}    

// окончательно подчищаем табличку очереди, т.к. все нужные нам записи уже обработаны       
if (intval($p_query_id) != 0 )  $query_tmp = $db -> sql_execute("delete from fax_query ff where ff.id_fax_query = ".$p_query_id);

/*
 * ЧАСТЬ ТРЕТЬЯ: ОТПРАВЛЯЕМ ФАКС
 * Получаем из таблици статусов факсы готовые к отправке и отправляем их
 */
$error = ""; // сбросим переменную ошибок
// Получаем все готовые факсы к отправке

$query = $db -> sql_execute("select t.id_fax_query, t.file_pic,t.file_pic_content, t.tel_number, tt.channel || '/' || t.tel_number as channel,tt.name_prefix as prefix from fax_query t
							inner join tranks tt on tt.id_tranks = t.id_tranks where upper(t.status) = 'QUERED' and upper(t.in_out) = 'O' and t.id_tranks not in (select distinct d.id_tranks from fax_query d where upper(d.status) = 'SENDING')");
while ($db -> sql_fetch($query)) {
	// формируем временный файл для астериска
	$file_name = TMP_FOLDER_ASTERISK.$db -> sql_result($query, "tel_number")."_".date("Ymd_His").".tif";
	
	// и подготавливаем содержимое файла
	$data = gz::gzdecode_zip(base64_decode($db -> sql_result($query, "file_pic_content")));  
	
	// Пробуем записать файл
	if(file_put_contents($file_name,$data) === false) {
		// несмогли записать, ошибка с системой или привилегиями
		if (empty($error))  $error = "Неудается создать временный файл для отправки";
	} else {
		// файл записали, но проверим на всякий случай размер
		if (filesize($file_name) < 1) {
				// проблема с размером, скорее всего либо данные битые, либо какаято ошибка при распаковке или кодировании
				$error = "Файл неполный или битые данные внутри";
				unlink($file_name);
				$db -> sql_execute("update fax_query t set t.status = 'ERROR' where t.id_fax_query = ".$db -> sql_result($query, "id_fax_query"));
		} else {
			// все нормально, идем дальше
			$error = "";
		}
	}
	
	// Подготоваливаем калл файл в формате астериска:
	$call_file  = "Channel: ".$db -> sql_result($query, "channel")."\n"; // канал в формате: НАЗВАНИЕКАНАЛА/ИМЯ
	$call_file .= "Extension: ".$db -> sql_result($query, "prefix")."\n"; // откого собственно отправляем файл
	$call_file .= "Context: fax_out\n"; // имя контекса который вызовется и отправит файл (там должно бых fax_send)
	$call_file .= "Priority: 1\n"; // приоритет
	$call_file .= "RetryTime: 300\n"; // время повтора в секундах
	$call_file .= "MaxRetries: 2\n"; // количество повторов ( отсчет от нуля)
	$call_file .= "WaitTime: 25\n"; // время ожидания приема факса на той стороне
	// Эти переменне используются к файле описания контекстов в астериске
	$call_file .= "Set: TEL_NUMB=".$db -> sql_result($query, "tel_number")."\n"; // указываем куда отправляем файл
	$call_file .= "Set: PICTURE=".$file_name."\n";  // путь к файлу
	
	// Проверяем ошибки на предыдущих этапах
	if (empty($error)) {
		// Пробуем записать калл файл в папку астериска для уходящих вызовов
		if(file_put_contents(OUT_FOLDER_ASTERISK."/".$db -> sql_result($query, "prefix")."-".md5(time().rand(time()/100,getrandmax())),$call_file) === false) {
			// Ошибка! Проблемы с ФС или с привелегиями
			$error = "Ошибка записи call файла";
		}		
	}    
	if (empty($error)) { 
		// Ошибок нет, ставим статус что факс отправляется
		$db -> sql_execute("update fax_query t set t.status = 'SENDING',t.error = 'Retry:1', t.file_pic = '".str_ireplace(TMP_FOLDER_ASTERISK,"",$file_name)."' where t.id_fax_query = ".$db -> sql_result($query, "id_fax_query"));
	} else {
		// есть ошибки, пишем их
		$db -> sql_execute("update fax_query t set t.error = '".iconv(HTML_ENCODING,LOCAL_ENCODING,$error)."', t.file_pic = '".str_ireplace(TMP_FOLDER_ASTERISK,"",$file_name)."' where t.id_fax_query = ".$db -> sql_result($query, "id_fax_query"));
	}    
}


/*
 * ЧАСТЬ ЧЕТВЕРТАЯ, ЗАКЛЮЧИТЕЛЬНАЯ: ПОДГОТАВЛИВАЕМ ФАКС ИЗ ПОЧТЫ ДЛЯ ОТПРАВКИ
 * Тк адекватной небольшой библиотеки для работы с почтой нет, будет делать свою,
 * и общаться с почтой будем чере сокет, напрямую
 */
$error = "";  // отчищаем переменную ошибок

// Устанавливаем соединение с почтовым серверов, стандартный порт протокола POP
$pop_conn = fsockopen($db->get_settings_val("SETTINGS_MAIL_SMTP_HOST"), 110,$errno, $errstr, 10);
// Важно после каждого запроса в сокет получать от него содержимое, иначе потом они вываляться все в кучу
$data = fgets($pop_conn);

// Логинимся под нашей учетной записью
fputs($pop_conn,"USER ".$db->get_settings_val("SETTINGS_MAIL_SMTP_AUTHLOGIN")."\r\n");$data = fgets($pop_conn);
fputs($pop_conn,"PASS ".$db->get_settings_val("SETTINGS_MAIL_SMTP_AUTHPWD")."\r\n");$data = fgets($pop_conn);

// Запрашиваем количество новых писем
fputs($pop_conn,"STAT\r\n"); $data = explode(" ",fgets($pop_conn));

// Проверяем есть ли новые письма
if ($data[1] > 0) {
	// Письма есть, обработаем каждое:
    for ($i = 1; $i < $data[1]+1; $i++) {
		// Запрашиваем письмо
		fputs($pop_conn,"RETR ".$i."\r\n");		
		$body = get_data($pop_conn);
		
		// Пытаемся письмо разобрать на блоки хидера и боди
		$struct=fetch_structure($body);
		$mass_header=decode_header($struct['header']);
		$mass_header["subject"] = decode_mime_string($mass_header["subject"]);
		preg_match("/<([^>]+)>*/i", $mass_header["from"], $email_from);
		
		// получаем от кого пришло письмо
		$mass_header["from"] =  $email_from[1];
		
		// Проверяем, может ли этот отправитель отправлять факс и находим с какого транка отправить
		$id_tranks = "";
		$query = $db -> sql_execute("select distinct * from (select g.id_tranks from lists g where lower(g.email_lists) like lower('".$mass_header["from"]."')
										and (g.in_out = 'O' or g.in_out = 'A') union all select t.id_tranks from lists_user t inner join wb_user w on w.id_wb_user = t.wb_user
										and lower(w.e_mail) = lower('".$mass_header["from"]."') where t.in_out = 'O' or t.in_out = 'A') where rownum = 1");
		while ($db -> sql_fetch($query)) $id_tranks = $db -> sql_result($query, "id_tranks");
		
		// Продолжаем разбор тела сообщения
		if (stripos($mass_header['content-type'],"multipart") !== false and !empty($id_tranks)) {
			
			// Разбиваем на части письмо по вложениям, если оно у нас multipart то и текст письма и файлы являются вложениями
			$boundary=get_boundary($mass_header['content-type']);
			$part = split_parts($boundary,$struct['body']);
			
			// Пробегаемся по всем частям письма
			for($j=1; $j<count($part); $j++) {
				// Выделяем структуру части
				$email = fetch_structure($part[$j]);
				$header = $email["header"];
				$headers = decode_header($header);
				$body = $email["body"];   
				
				// Пытаемся разобрать и выбрать только файлы, чтобы сам текст нетрогать
				$is_download = (preg_match("/name=/",$headers["content-disposition"].$headers["content-type"]) || $headers["content-id"] != "" || $rctype == "message/rfc822");
				if ($is_download > 0) { 
								// Если это действительно файл то пытаемся найти имя файла:
								$filename = "none";
								foreach (explode(";",$headers["content-disposition"]) as $key => $value) { 
									$pa = explode("=",$value);
									if (trim($pa[0]) == "filename") {
										$filename = decode_mime_string(str_replace("\"", "", substr($value,stripos($value,"=")+1)));
									}
								}
								// Если имя найдено, и файл не запрещенных типов:
								if (($filename != "none") and ((stripos($filename,".gif") === false) and (stripos($filename,".png") === false) and (stripos($filename,".jpg") === false) and (stripos($filename,".svg") === false))) {
									// Выделяем файл из письма
									$body = compile_body(str_replace("\"", "", $body),$headers["content-transfer-encoding"],"");
									// Обнуляем переменные
									$error = "";
									$status = "LOADING";
									
									// Обновляем записи в бд
									$db -> sql_execute("insert into fax_query t (id_tranks, in_out, file_pic, file_pic_content, status, tel_number,sender) select ".$id_tranks." as id_tranks,
														'O' as in_out, '".$filename."' as file_pic, '' as file_pic_content, upper('".$status."') as status, '".intval($mass_header["subject"])."' as tel_number,
														lower('".$mass_header["from"]."') as sender from dual");
									
									// Запрашиваем айди записи			  
									$query = $db -> sql_execute("select t.id_fax_query from fax_query t where t.sender = lower('".$mass_header["from"]."') and t.status='LOADING'  and t.file_pic = '".$filename."' and t.tel_number ='".intval($mass_header["subject"])."'");
									while ($db -> sql_fetch($query)) $id_file_query =$db -> sql_result($query, "id_fax_query");  
									
									// выставляем статус отправки 
									$status = "QUERED"; 
									$filedata = "";                            
									if (stripos($filename,".tif") === false) { 
									
										// Если файл не TIF то пробуем сконвертировать его:
										$tmp_filename = TMP_FOLDER_ASTERISK.intval($mass_header["subject"]).$db -> sql_result($query, "tel_number")."_".date("Ymd_His");
										$tmp_file_type = substr($filename,stripos($filename,"."));
										
										// Сначала сохраняем:
										if(file_put_contents($tmp_filename.$tmp_file_type,$body) === false) {
											// Неудалось сохранить файл, возможно нет привелегий
											$status = "ERROR";
											$error  = "Неудалось сконвертировать файл для отправки факсом, попробуйте пересохранить файл: ".$filename." в формате .tif";
										} else {
											// Сохранился, теперь преобразовываем сначала в pdf, т.к. unoconv не поддерживает tiff формат
											exec("/usr/bin/unoconv ".$tmp_filename.$tmp_file_type." 2>&1",$output,$comm);
											if ($comm == 0) {
												// получилось сконвертировать, теперь переводим его в tiff
												exec("/usr/bin/gs -q -dNOPAUSE -dBATCH -sDEVICE=tiffg4 -sOutputFile=".$tmp_filename.".tif ".$tmp_filename.".pdf 2>&1",$output,$comm);  
												// ошибок быть не может в данном случае, так что загружаем файл и подготавливаем к заливке в БД
												$body = file_get_contents($tmp_filename.".tif");
												$filedata = str_split(base64_encode(gz::gzencode_zip($body)), 2048); 
											} else {
												// неполучилось сконвертировать
												$status = "ERROR";
												$error  = "Некорректный файл! Возможно мы не смогли распознать формат файла ".$filename.",\n";
												$error .= "При конвертации может поехать разметка, если вы не хотите этого то используйте формат документа .tif или .pdf";
											}
											// Чистим временные файл если есть
											if (is_file($tmp_filename.".pdf")) unlink($tmp_filename.".pdf");
											if (is_file($tmp_filename.".tif")) unlink($tmp_filename.".tif");
											if (is_file($tmp_filename.$tmp_file_type)) unlink($tmp_filename.$tmp_file_type);
										}   
									} else {
										// Файл нужного формата, просто подготавливаем его к заливке в базу
										$filedata = str_split(base64_encode(gz::gzencode_zip($body)), 2048);                               
									}
									// Загружаем файл в базу данных
									foreach($filedata as $File_data_str) {
										$db -> sql_execute("update fax_query t set t.file_pic='".str_replace(TMP_FOLDER_ASTERISK,"",$tmp_filename).".tif', t.file_pic_content = t.file_pic_content || '" .$File_data_str. "'"
														   . "where t.id_fax_query = ".$id_file_query);  
									} 
									// Проверяем статусы и проверяем номер куда отсылать факс (непустой и только цифры)
									if ($status == "QUERED" and (intval($mass_header["subject"]) == 0)) {
									   $status = "ERROR";
									   $error = "Некорректный номер для отправки!\nДля того чтобы отправить факс в поле Тема нужно указать номер на который\nбудет отправляться факс, такой-же как вы набираете его у себя на телефоне.";
									}    
									// Обновляем статус записи отправки
									$db -> sql_execute("update fax_query t set t.status = '".$status."', t.error ='".iconv(HTML_ENCODING,LOCAL_ENCODING,$error)."' where t.id_fax_query = ".$id_file_query);
									$status = "LOADING";
								} else {
								
								  // файл ненайден в теле письма, либо он запрещен для отправки факсом
								  $status = "ERROR";
								  $error  = "К письму не приложен файл для отправки!";
								}    
				} 
			}
			
			// Все части приготовили и залили файлы в бд, в случае ошибок на всех этапах записываем их в бд			
			if($status == "ERROR") {
			   $db -> sql_execute("insert into fax_query t (id_tranks, in_out, file_pic, file_pic_content, status,error, tel_number,sender) select ".$id_tranks." as id_tranks,
									'O' as in_out, '' as file_pic, '' as file_pic_content, upper('ERROR') as status, '".iconv(HTML_ENCODING,LOCAL_ENCODING,$error)."' as error,
									'".intval($mass_header["subject"])."' as tel_number, lower('".$mass_header["from"]."') as sender from dual");
			}
		}   
		
		// Формируем письмо для пользователя со статусом его факса, но проверям можно ли нам пользователю слать письма, чтобы небыло фрода
		if (stripos($mass_header["from"],ALLOWED_DOMAIN) !== false ) {
			
			// Удаляем письмо из ящика, чтобы оно там не висело
			fputs($pop_conn,"DELE ".$i."\r\n");
			// Кому шлем письмо
			$mail_to = $mass_header["from"];	
			// Содержимое
			$subject = "Статус вашего факсимильного сообщения";
			$message = "Ваше факсимильное сообщение для номера:\n";
			$message .= intval($mass_header["subject"])."\n\n";
			if (!empty($id_tranks) ) {
				$message .= "Поставлено в очередь на отправку\n";
			} else {
				$message .= "Ваше факсимильное сообщение не будет отправлено, так как вас нет в разрешенных отправителях,\n\n";
				$message .= "обратитесь на e-mail: ".$db->get_settings_val("RECIPIENT_ADMIN")." чтобы вас добавили.\n\n";
			}    
			$separator = md5(time());
			$eol = PHP_EOL;
			// Готовим хидеры для письма:
			$headers  = "From: fax-server <".$db->get_settings_val("SETTINGS_MAIL_SMTP_SENDER").">" . $eol;
			$headers .= "MIME-Version: 1.0" . $eol;
			$headers .= "Content-Type: multipart/mixed; boundary=\"" . $separator . "\"" . $eol . $eol;
			$headers .= "Content-Transfer-Encoding: 7bit" . $eol;
			$headers .= "This is a MIME encoded message." . $eol . $eol;    
			$headers .= "--" . $separator . $eol;
			$headers .= "Content-Type: text/plain; charset=\"UTF-8\"" . $eol;
			$headers .= "Content-Transfer-Encoding: 8bit" . $eol . $eol;
			$headers .= $message . $eol . $eol;
			$headers .= "--" . $separator . "--";   
			// Отправляем
			SendMail($mail_to, $subject, "", $headers); 
		}
    }
}
// Обработали все письма, вежливо прощаемся с почтовым сервером и закрываем соединение
fputs($pop_conn,"QUIT\r\n");
fclose($pop_conn);
/*
 * THE END.
 */
