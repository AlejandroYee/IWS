<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Вывод данных для графика
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	requre_script_file("lib.requred.php"); 
	
	
  	// Начальные переменные
	$id 			= @intval($_GET['id']);  
	$arr_field      = array();
	$arr_field_cat  = array();
	$arrData        = array();
	$arrDataCat     = array();
	$i              = 0;
	$k              = 0;
	$str_dt         = "";	
	$has_parent		= "";
	$FC_ColorCounter = 0;
	$check			= "";
	$strData 		= "";
	$arr_FCColors = array("1941A5","AFD8F8","F6BD0F","8BBA00","A66EDD","F984A1","CCCC00","999999",
									  "0099CC","FF0000","006F00","0099FF","FF66CC","669966","7C7CB4","FF9933",
									  "9900FF","99FFCC","CCCCFF","669900");
	
	$user_auth = new AUTH();	
	if (!$user_auth -> is_user()) {
			clear_cache();
			die("Доступ запрещен");
	}
	
	$main_db = new db();
	end_session();
	
	function getFCColor() 
	{
		global $FC_ColorCounter,$arr_FCColors; 
		$FC_ColorCounter++;
		return($arr_FCColors[$FC_ColorCounter % count($arr_FCColors)]);
	}
	
	// Дополнительная проверка на пользователя и права доступа:
	$query = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
	while ($main_db -> sql_fetch($query)) {
		$check				= explode(",",strtoupper(trim( $main_db -> sql_result($query, "EDIT_BUTTON") )));;
	}
	// если пользователю недоступна форма, то выходим сразу
	if (empty($check)) die("Доступ для чтения данных запрещен");
	
	$query = $main_db -> sql_execute("select tf.owner,
									   tf.object_name,
									   tf.name chart_label,
									   nvl(tf.CHART_show_name, 0)   is_show_name,
									   nvl(tf.CHART_rotate_name, 0) is_rotate_name,
									   nvl(tf.CHART_X, 1000) CHART_X,
									   nvl(tf.CHART_Y,  350) CHART_Y,
									   nvl(tf.CHART_DEC_PREC,  0) CHART_DEC_PREC,
									   (Select u.object_type
										  from user_objects u
										  where u.object_name = upper(tf.object_name)) object_type,
									   nvl2(tf.form_where, 'AND '||tf.form_where, null) form_where, 
									   t.name,
									   nvl(substr(t.name, 1, instr(t.name, '@') - 1), t.name) l_name,
									   nvl(substr(t.name, instr(t.name, '@') + 1), t.name) s_name,
									   t.field_name,
									   decode(t.field_type, 'D', 'to_char('||t.field_name||', ''dd.mm.yyyy hh24:mi:ss'') '||t.field_name
														   ,'I', 'round('||t.field_name||', 0) '||t.field_name
															   ,t.field_name) f_name,
									   t.name axis_name,
									   ta.html_txt align_txt,
									   decode(ta.html_txt, 'left', 1, 0) axisOnLeft,
									   /*t.FL_HTML_CODE,*/
									   tf.xsl_file_in,
									   t.field_type,
									   t.num,
									   ct.name chart_name,
									   ct.type_chart type_chart
								  from ".DB_USER_NAME.".wb_mm_form tf
								  left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form
								  left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
								  left join ".DB_USER_NAME.".wb_chart_type ct on ct.id_wb_chart_type = tf.id_wb_chart_type
								  where tf.id_wb_mm_form = ".$id."
								order by t.num");
						
			while ($main_db -> sql_fetch($query)) {
								$show_name      = $main_db -> sql_result($query, "IS_SHOW_NAME");
								$rotate_name    = $main_db -> sql_result($query, "IS_ROTATE_NAME");
								$chart_X        = $main_db -> sql_result($query, "CHART_X");
								$chart_Y        = $main_db -> sql_result($query, "CHART_Y");
								$chart_dec_prec = intval($main_db-> sql_result($query, "CHART_DEC_PREC"));
								if ($str_dt=="") {
									$owner      = $main_db -> sql_result($query, "OWNER");
									$table_name = $main_db -> sql_result($query, "OBJECT_NAME");
									$form_where = $main_db -> sql_result($query, "FORM_WHERE");
									$str_dt = "Select ".$main_db -> sql_result($query, "F_NAME");
									$AxisName = $main_db -> sql_result($query, "AXIS_NAME");
									$str_dt_f = " from (Select rownum r_num, t.* from ".$owner.".".$table_name." t ) where 1 = 1 ".$form_where." ";
								} else {
									$str_dt = $str_dt.", ".$main_db -> sql_result($query, "F_NAME");
								}
							
								if ($main_db -> sql_result($query, "NUM") == "0") {
									$str_category = "Select ".$main_db -> sql_result($query, "F_NAME")." NAME_CAT from ".$owner.".".$table_name." where 1 = 1 ".$form_where." ";
									$arr_field_cat[0]  = $main_db -> sql_result($query, "FIELD_NAME");
									$arr_num[0]        = $main_db -> sql_result($query, "NUM");
								} else {
									$i = $i + 1;
									$arr_num[$i]        = $main_db -> sql_result($query, "NUM");
									$arr_field[$i]      = $main_db -> sql_result($query, "FIELD_NAME");																
									$arr_l_name[$i]     = $main_db -> sql_result($query, "L_NAME");
									$arr_s_name[$i]     = $main_db -> sql_result($query, "S_NAME");
									$align_txt[$i]      = $main_db -> sql_result($query, "ALIGN_TXT");
									$axisOnLeft[$i]     = $main_db -> sql_result($query, "AXISONLEFT");
								}
								$chart_label        = $main_db -> sql_result($query, "CHART_LABEL");
								$chart_name         = $main_db -> sql_result($query, "CHART_NAME");
								$type_chart         = $main_db -> sql_result($query, "TYPE_CHART");
			}
						
			$m = 0; 
			$query = $main_db -> sql_execute($str_dt.$str_dt_f);			
							
			while ($main_db -> sql_fetch($query)) {
				foreach ($arr_field as $key=>$line) {
						$arrDataCat[$arr_field[$key]][$m] = $main_db -> sql_result($query, $arr_field_cat[0]);
						$arrData[$arr_field[$key]][$m]    = $main_db -> sql_result($query, $arr_field[$key]);
					}
				$m++;  
			} 
				// Специфичные параметры для графиков
				switch (trim($chart_name)) { 
					case "MultiAxisLine":
						$field = "name";
						$legend = "showLegend='0'";
						$has_parent = "";
						$labels = false;
						$Set = false;
					break;
					case "MSColumn3DLineDY": //MSColumn2DLineDY
						$field = "label";
						$legend = "showLegend='1' xAxisName='".$AxisName."' ";
						$has_parent = "parentYaxis='S'";
						$labels = true;
						$Set = false;
					break;
					case "Pie3D":
						$field = "name";
						$legend = "showLegend='1' useEllipsesWhenOverflow='0'  pieSliceDepth='30' xAxisName='".$AxisName."' ";
						$has_parent = "";
						$labels = false;
						$Set = true;
					break;
					default:
						$field = "name";
						$legend = "showLegend='1' xAxisName='".$AxisName."' ";
						$has_parent = "";
						$labels = false;
						$Set = false;
					break;
				}
				
				// Заголовки графика
				$strXML = "<graph caption='".$chart_label."' divlinecolor='F47E00' ".$legend."  numVDivLines='".count($arrDataCat[$arr_field[1]])."' vDivLineAlpha='10' \n";
				$strXML .= "rotateNames='".$rotate_name."' showBorder = '0'  formatNumberScale='0' decimalSeparator='' setAdaptiveYMin='1' thousandSeparator=' ' bgColor='".trim(css_get_value($main_db -> get_param_view("theme"),'ui-widget-content', 'background'), "#;")."' \n";
				$strXML .= "outCnvBaseFontColor='".trim(css_get_value($main_db -> get_param_view("theme"),'ui-widget-content', 'color'), "#;")."' showValues='".$show_name."' decimalPrecision='".$chart_dec_prec."' > \n";
						
				// Формируем категории графика
				$strCategories = "<categories>\n";
				foreach ($arrDataCat[$arr_field[1]] as $key => $line) {
					$strCategories .= " <category ".$field."='".trim($arrDataCat[$arr_field[1]][$key])."' />\n";
				}
				$strCategories .= "</categories>\n";
							
				// Для каждого типа данных делаем легенду
				foreach ($arr_field as $key => $line) {		
					if ($chart_name =='MultiAxisLine') {
						$strData .= "<axis title='".$arr_s_name[$key]."' titlePos='".$align_txt[$key]."' axisOnLeft='".$axisOnLeft[$key]."' divlineisdashed='1' >\n";
					}
					// Только для первой записи парент
					if ($arr_num[$key] <> 1) {
						$has_parent ="";
					}
					$strData .= "<dataset seriesName='" . $arr_l_name[$key] . "' color='". getFCColor() ."' ".$has_parent." >\n";
					
					// Прогружаем данные
					foreach ($arrDataCat[$arr_field[$key]] as $key2 => $line2) {
						if ($labels) {
							$label="name='".trim($arrDataCat[$arr_field[1]][$key])."'";
						} else {
							$label="";
						}
						$strData .= "<set value='".round($arrData[$arr_field[$key]][$key2],$chart_dec_prec)."' ".$label." />\n";
					}
					$strData .= "</dataset>\n";		
					if ($chart_name =='MultiAxisLine') {
						$strData .= "</axis>";			
					}
				}
				if($Set) {
					 $strCategories = "";
					 $strData ="";
					 foreach ($arrDataCat[$arr_field[$key]] as $key2 => $line2) {
						$strData .= "<set  value='".round($arrData[$arr_field[$key]][$key2],$chart_dec_prec)."' name='".trim($arrDataCat[$arr_field[1]][$key])."' />\n";
					 }
				}
				$strXML .= $strCategories . $strData .  "</graph>";
echo $strXML;
$main_db -> __destruct();										
?>