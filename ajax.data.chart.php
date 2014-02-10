<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Вывод данных для графика
//--------------------------------------------------------------------------------------------------------------------------------------------
require_once("library/lib.func.php");
BasicFunctions::requre_script_file("lib.requred.php"); 
BasicFunctions::requre_script_file("auth.".AUTH.".php");
BasicFunctions::requre_script_file("lib.json.php");

header("Content-type: text/script;charset=".HTML_ENCODING);

// Начальные переменные
$id 		= filter_input(INPUT_GET, 'id',FILTER_SANITIZE_NUMBER_INT);
$dt             = (object)''; 
$dt_cell        = array();
$dt_obj         = array();
$dt_cat         = array();
$axis_y_pos     = array();
$showaxis       = true;

$user_auth = new AUTH();	
if (!$user_auth -> is_user()) {
				BasicFunctions::to_log("ERR: User maybe not loggen, from no: ".$id."!");
                BasicFunctions::clear_cache();
                die("Доступ запрещен");
}
	
$main_db = new db();
BasicFunctions::end_session();
		
// Дополнительная проверка на пользователя и права доступа:
$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
while ($main_db -> sql_fetch($query_check)) {
        $check	= explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON") )));
}

if (empty($check)) {
		BasicFunctions::to_log("ERR: User not allowed to read from: ".$id_mm_fr."!");
		die("Доступ для чтения данных запрещен");
}
	
	
$query_korrdinates = $main_db -> sql_execute("select tf.owner, tf.object_name, tf.name chart_label, nvl(tf.CHART_show_name, 0) as is_show_name,
				 decode(nvl(tf.CHART_rotate_name, 0),1,90,0) is_rotate_name, nvl(tf.CHART_X, 1000) CHART_X, nvl(tf.CHART_Y,  350) CHART_Y,
				 (Select u.object_type from user_objects u where u.object_name = upper(tf.object_name)) object_type,
				 nvl2(tf.form_where, 'AND '||tf.form_where, null) form_where,  t.name, nvl(substr(t.name, 1, instr(t.name, '@') - 1), t.name) l_name,
				 nvl(substr(t.name, instr(t.name, '@') + 1), t.name) s_name, t.field_name, decode(t.field_type, 'D', 'to_char('||t.field_name||', ''dd.mm.yyyy hh24:mi:ss'') '||t.field_name
														   ,'I', 'round('||t.field_name||', 0) '||t.field_name
															   ,t.field_name) f_name,
				 t.name axis_name, ta.html_txt align_txt, ta.html_txt as axisOnLeft,
				 t.field_type, row_number() over(ORDER BY t.num)-1 as num, ct.name chart_name, ct.id_wb_chart_type as chart_id
				 from ".DB_USER_NAME.".wb_mm_form tf
                                 left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form
				 left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
				 left join ".DB_USER_NAME.".wb_chart_type ct on ct.id_wb_chart_type = tf.id_wb_chart_type
				 where tf.id_wb_mm_form = ".$id." order by t.num");
				
while ($main_db -> sql_fetch($query_korrdinates)) {
                
                $field_name = $main_db -> sql_result($query_korrdinates, "F_NAME");
                $field_num = $main_db -> sql_result($query_korrdinates, "NUM");
                
                $str_dt = "Select ".$field_name." from ( "
                        . "Select rownum r_num, t.* from ".$main_db -> sql_result($query_korrdinates, "OWNER").".".$main_db -> sql_result($query_korrdinates, "OBJECT_NAME")." t ) "
                        . "where 1 = 1 ".$main_db -> sql_result($query_korrdinates, "FORM_WHERE");
                
                $dt -> chart_label    = $main_db -> sql_result($query_korrdinates, "CHART_LABEL");
                $dt -> legend         = boolval($main_db -> sql_result($query_korrdinates, "is_show_name"));
                $m = 0; 
                $query_data = $main_db -> sql_execute($str_dt);	
                while ($main_db -> sql_fetch($query_data)) {
                        if ($field_num == 0) {
                            switch (trim($main_db -> sql_result($query_korrdinates, "FIELD_TYPE"))) {			
                                    // Поле ввода ДАТА
                                    case "D": 
                                           $dt_cat[$m] = strtotime($main_db -> sql_result($query_data, $field_name))."000";
                                           $dt -> xaxis        = array( "mode" => "time",  "timeformat" => "%d.%m.%Y", "timezone" => "browser","labelHeight"=> 75,"labelAngle"=>intval($main_db -> sql_result($query_korrdinates, "is_rotate_name")));
                                    break;
                                    // Поле ввода ДАТА и ВРЕМЯ
                                    case "DT":
                                          $dt_cat[$m] = strtotime($main_db -> sql_result($query_data, $field_name))."000";
                                          $dt -> xaxis        = array( "mode" => "time",  "timeformat" => "%d.%m.%Y %H:%M:%S", "timezone" => "browser","labelHeight"=> 75,"labelAngle"=>intval($main_db -> sql_result($query_korrdinates, "is_rotate_name")));
                                    break;			
                                    case "C":	
                                           $dt_cat[$m] = $main_db -> sql_result($query_data, $field_name)." руб.";
                                           $dt -> xaxis = array( "mode" => "categories","labelHeight"=> 75,"labelAngle"=>intval($main_db -> sql_result($query_korrdinates, "is_rotate_name")));		
                                    break;		
                                    default:
                                           $dt_cat[$m] = $main_db -> sql_result($query_data, $field_name);
                                           $dt -> xaxis = array( "mode" => "categories","labelHeight"=> 75,"labelAngle"=>intval($main_db -> sql_result($query_korrdinates, "is_rotate_name")));
                                    break;
                            }        
                        } else {
                            $dt_cell[$field_num][$m] = $main_db -> sql_result($query_data, $field_name);
                        }
                        $m++; 
                }
                $dt_row             = (object)'';
                $dt_row -> label    = $main_db -> sql_result($query_korrdinates, "L_NAME");                                
                
                if ($field_num > 0) {
                    $tmp_array =  array();
                    for ($m = 0; $m < count($dt_cat); $m++) {    
                        $tmp_array[$m][0] = $dt_cat[$m];
                        $tmp_array[$m][1] = $dt_cell[$field_num][$m];
                    }
                    $dt_row -> xaxis      = 1; 
                    $dt_row -> yaxis      = intval($field_num);
                    $dt_row -> data       = $tmp_array; 
                    $axis_y_pos[$field_num-1] = (object) array( "position" => $main_db -> sql_result($query_korrdinates, "axisOnLeft"),"show"=>$showaxis);
                }   
                
                switch (intval($main_db -> sql_result($query_korrdinates, "CHART_ID"))) {
                    case 12: 
                        $showaxis           = false;
                        $dt -> legend       = true;
                        $dt_row -> lines    = array( "show" => true, "fill" => false);
                        if ($field_num > 0) {    $dt_obj[$field_num-1] = $dt_row; }  
                    break;
                    case 20: 
                        $showaxis           = true;
                        $dt -> legend       = true;
                        $dt_row -> lines    = array( "show" => true, "fill" => true);
                        if ($field_num > 0) {    $dt_obj[$field_num-1] = $dt_row; }  
                    break;
                    case 4: 
                        $showaxis           = true;
                        $dt -> legend       = false;                         
                        $dt -> options      = (object) array("series" => (object) array("pie" => (object) array( "show" => true, "fill" => true,"tilt"=> 0.3,
                                                                         "shadow" => array("top" => 20, "left" => 0,"alpha" => 0.03)))); 
                        
                        // преобразовываем масив данных
                        for ($m = 0; $m < count($dt_cat); $m++) { 
                           $dt_obj[$m]       = (object) array("label"=>$dt_cat[$m],"data"=>$dt_cell[$field_num][$m]);
                        };                         
                    break;
                    case 18: 
                        $showaxis           = false;
                        $dt -> legend       = false;
                        $dt_row -> bars     = array( "show" => true, "fill" => true);
                        if ($field_num > 0) {    $dt_obj[$field_num-1] = $dt_row; }  
                    break;
                    default:
                        $showaxis           = true;
                        $dt -> legend       = true;
                        $dt_row -> lines   = array( "show" => true, "fill" => false);
                        if ($field_num > 0) {    $dt_obj[$field_num-1] = $dt_row; }  
                    break;
                }
}

// формируем доп опции для y осей кроме первой
$dt -> yaxis = $axis_y_pos; 
$dt -> data =  $dt_obj;
/*$json = new json();
echo $json -> jsonencode($dt);*/

echo json_encode ($dt,JSON_PRETTY_PRINT);
$main_db -> __destruct();