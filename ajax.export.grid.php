<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Экспорт:
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	BasicFunctions::requre_script_file("lib.requred.php");
	BasicFunctions::is_offline();	
        BasicFunctions::requre_script_file("auth.".AUTH.".php");
        BasicFunctions::requre_script_file("PHPExcel.php");
        
        error_reporting(E_ALL); // инача изза стороних библиотек мы будет неверный хидер отдавать
	
        header("Set-Cookie: fileDownload=false");
        
	$user_auth = new AUTH();	
	if ($user_auth -> is_user() !== true) {
			BasicFunctions::to_log("ERR: User maybe not loggen, from no: ".filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT)."!");
			BasicFunctions::clear_cache();
			die("Not autorised");
	}
	$main_db = new db();
	BasicFunctions::end_session();  // Закрываем сейсию для паралельного исполнния
	
        function in_array_search($text,$array) { 
            foreach($array as $key => $arrayValue) {
                    if (strtoupper(trim($arrayValue)) == strtoupper(trim($text))) 
                        {
                        return $key;
                     }
            }
        }
        
	$type    	= filter_input(INPUT_GET, 'type',FILTER_SANITIZE_STRING);
	$id_mm          = filter_input(INPUT_GET, 'id_mm',FILTER_SANITIZE_NUMBER_INT);
	$id_mm_fr       = filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT); 
	$id_mm_fr_d     = filter_input(INPUT_GET, 'id_mm_fr_d',FILTER_SANITIZE_NUMBER_INT);
	$pageid		= filter_input(INPUT_GET, 'pageid',FILTER_SANITIZE_STRING);
        $isaexport	= filter_input(INPUT_GET, 'isaexport',FILTER_SANITIZE_STRING);
        $id             = filter_input(INPUT_GET, 'id',FILTER_SANITIZE_STRING);
        
	$qWhere		= "";
        $show_hidden    = "";
	$arr_field      = array();
        $arr_field_type = array();
        $Cell_format_align  = array();
	$Cell_format    = array();
        $str_dt         = "";	
	$i              = 0;
	$m 		= 0;	
	$k              = 0;
	$check		= "";	 
        $cell_exp       = 0;
        $cell_exp_first = 0;
        $row_exp        = 2; 
	$exp_shabloned  = false;
	$exp_from_file	= false;
        
	// Дополнительная проверка на пользователя и права доступа:
	$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
	while ($main_db -> sql_fetch($query_check)) {
		$check = explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON") )));
	}
        
	// если пользователю недоступна форма, то выходим сразу
	if (empty($check)) {
			BasicFunctions::to_log("ERR: User not allowed to read from: ".$id_mm_fr."!");
			die("Доступ для чтения данных запрещен");
	}
	
	// Переменные для детальных гридов
	if (($type == "GRID_FORM_DETAIL") or ( $type == "TREE_GRID_FORM_MASTER") or ( $type == "TREE_GRID_FORM_DETAIL") ) {	
	$exp_query = $main_db -> sql_execute("select t.object_name from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$id_mm." and ft.name like '%_MASTER'");
			while ($main_db -> sql_fetch($exp_query)) {
                                $Master_Table_ID = $main_db -> sql_result($exp_query, "OBJECT_NAME");
                        }
			if (is_numeric($id)) {			 
					$s_d_m_Where  = " AND ID_".$Master_Table_ID." = ".intval($id);
				} else {
					$s_d_m_Where  = " AND ID_".$Master_Table_ID." = '".$id."'";
			}
            } else {
			$s_d_m_Where     = "";	
	}
	
	// Данные по экспорту основные
	$exp_query_main = $main_db -> sql_execute("select t.name as s_name,t.object_name as f_name, t.xsl_file_in as filename from ".DB_USER_NAME.".WB_MM_FORM t where rownum = 1 and t.id_wb_mm_form = ".$id_mm_fr);
	while ($main_db -> sql_fetch($exp_query_main)) {				
		$exp_name = $main_db -> sql_result($exp_query_main, "S_NAME",false);
		$exp_title = $main_db -> sql_result($exp_query_main, "S_NAME");
		$exp_file = $main_db -> sql_result($exp_query_main, "FILENAME",false);
	}

        if (empty($exp_file)) {
              $exp_file = $exp_name." (".date("d-m-Y").").".$isaexport;	// Если имени файла нет то берем текущую дату и формируем
        }  
                
        if (is_file(ENGINE_ROOT.DIRECTORY_SEPARATOR."exp_template".DIRECTORY_SEPARATOR.$exp_file) and ($isaexport == 'xlsm')) {                     
			$temp_file = tempnam(sys_get_temp_dir(), rand(5, 15) . $exp_file);			
			file_put_contents($temp_file,file_get_contents("exp_template/". $exp_file));
                        $filetype = PHPExcel_IOFactory::identify($temp_file);
			$objReader = PHPExcel_IOFactory::createReader($filetype);                        
			$objPHPExcel = $objReader -> load($temp_file);
                        $objPHPExcel->getProperties()->setCreator($main_db -> get_realname())
                                ->setLastModifiedBy($main_db -> get_realname())
                                ->setCategory("Data export file"); 
                        if (!$objPHPExcel->hasMacros()) {                            
                            $isaexport = 'xlsx';
                            $exp_file = substr($exp_file,0,strrpos($exp_file, '.')).".".$isaexport;
                        }
			$exp_from_file = true;
        } else {    
            $exp_file = substr($exp_file,0,strrpos($exp_file, '.')).".".$isaexport;
            $temp_file = tempnam(sys_get_temp_dir(), rand(5, 15) . $exp_file);
            $objPHPExcel = new PHPExcel();
            $objPHPExcel->getProperties()->setCreator($main_db -> get_realname())
                    ->setLastModifiedBy($main_db -> get_realname())
                    ->setTitle($exp_file)
                    ->setCategory("Data export file");
        }
	
        if  ($isaexport != 'csv') {
	    if (!$exp_from_file){
		$row_exp--; 
	    }
            // Заполняем поля заголовка если они есть
            $exp_query = $main_db -> sql_execute("select t.name,t.field_txt, t.field_name,  nvl(t.xls_position_col,1) as xls_position_col, nvl(t.xls_position_row,rownum +1) as xls_position_row,t.field_type
                                from ".DB_USER_NAME.".wb_form_cells t where t.id_wb_mm_form = ".$id_mm_fr." and t.type_cells = 'H' order by t.num");
            while ($main_db -> sql_fetch($exp_query)) {				
                                            // получаем значение
                                            $exp_query_custom = $main_db -> sql_execute("Select 1 X,". str_ireplace("&#39;", "'", $main_db -> sql_result($exp_query, "FIELD_TXT"))." PARAM from dual");
                                            $main_db -> sql_result($exp_query, "NAME");
                                            
                                            while ($main_db -> sql_fetch($exp_query_custom)) {	
                                                            $objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($cell_exp,$row_exp,str_replace("&nbsp;", " ",$main_db -> sql_result($exp_query, "NAME")." ".$main_db -> sql_result($exp_query_custom, "PARAM",false)));
                                                            $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($main_db -> sql_result($exp_query, "xls_position_col"),$main_db -> sql_result($exp_query, "xls_position_row"));
                                                            $objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setBold(true);
                                            $row_exp++;									
                                            }
					    $exp_shabloned = true;
             }	
	 $row_exp++; 
        } else {
          $row_exp--;
        }
	// Запоминаем стратовую позицию данных
	$row_exp_zag = 	$row_exp;
	
        // Имя листа
        if(!$objPHPExcel->hasMacros()) {
                $objPHPExcel->getActiveSheet()->setTitle("Данные экспорта"); // имя листа
                $objPHPExcel->setActiveSheetIndex(0);
        }
        
        // Проверяем нужно-ли выводить скрытые столбци
        $param_value = intval($main_db -> get_settings_val('SETTINGS_VIEW_INVISIBL_ID_TABLE'));
        if ( $param_value <> 0) {
            $filed_sys_hiden = array_merge_recursive($main_db -> get_settings_many_val('SETTINGS_VIEW_INVISIBLE_SYS_FIELDS'),
                                      $main_db -> get_settings_many_val('SETTINGS_VIEW_INVISIBLE_AUDIT_FIELDS'));
            $show_hidden =  "and t.field_name not in ('".implode("','",$filed_sys_hiden)."') ";
        }           
                
	// Запрос списка столбцов и их имен
        $query = $main_db -> sql_execute("select owner, object_name,name,l_width,f_name,form_where,field_type,field_name, align_txt,nvl(xls_position_col, rownum) as xls_position_col,nvl(xls_position_row, 2) as xls_position_row
	from (select tf.owner,tf.object_name, t.name, round(t.width/3) as l_width,
                       decode(t.field_type, 'D', 'to_char('||t.field_name||', ''dd.mm.yyyy hh24:mi:ss'') '||t.field_name, 'I', 'round('||t.field_name||', 0) '||t.field_name, t.field_name) f_name,
                       nvl2(tf.form_where, 'AND '||tf.form_where, null) form_where,  t.field_type,
                       t.field_name, ta.html_txt align_txt,t.xls_position_col, t.xls_position_row
                  from ".DB_USER_NAME.".wb_mm_form tf
                  left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form
                  left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
                  where tf.id_wb_mm_form = ".$id_mm_fr." ".$show_hidden." and t.field_name != 'ID_' || tf.object_name order by t.num)");
        if (!$exp_shabloned) {
	    
	}
        while ($main_db -> sql_fetch($query)) {
		if ((intval($param_value) <> 1) and ($main_db -> sql_result($query, "FIELD_NAME") == "ID_CONTROL_LOAD_DATA")) continue;	
                
                if (empty($str_dt)) {
                    $cell_exp_first = $main_db -> sql_result($query, "xls_position_col") - 1;
                    $owner      = $main_db -> sql_result($query, "OWNER");
                    $table_name = $main_db -> sql_result($query, "OBJECT_NAME");
                    $str_dt     = "Select ".$main_db -> sql_result($query, "F_NAME");
                    $str_dt_f   = " from (Select t.* from ".$owner.".".$table_name." t  WHERE 1=1  SqWhere ".$main_db -> sql_result($query, "FORM_WHERE")." ".$s_d_m_Where." )";	                 
		} else {
                    $str_dt = $str_dt.", ".$main_db -> sql_result($query, "F_NAME");
                }
                
                if ($isaexport != 'csv' ) $row_exp = intval($main_db -> sql_result($query, "xls_position_row"));
                $cell_exp = intval($main_db -> sql_result($query, "xls_position_col")) - 1;  
                $arr_field[$cell_exp] = $main_db -> sql_result($query, "FIELD_NAME");
                $arr_field_type[$cell_exp] = $main_db -> sql_result($query, "FIELD_TYPE");
                
                // Используем ячейки только при нормальном экспорте, если кустом или csv то неиспользуем
                if ($isaexport != 'csv' or !$objPHPExcel->hasMacros()) {
                    
                        // выбираем ячейку
                        $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($cell_exp,$row_exp);

                        // говорим что она БОЛД
                        $objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setBold(true);
                        
                        // Заполняем начальные данные по столбцам				
                        $objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($cell_exp,$row_exp, trim(str_replace(array("(not display)", "<BR>", "#","<br>")," ",$main_db -> sql_result($query, "NAME"))));

                        // Указываем алигн для всего столбца начиная с текущей строки:					
                        switch ($main_db -> sql_result($query, "ALIGN_TXT")) {
                                case 'left':   $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_LEFT; break;
                                case 'right':  $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_RIGHT; break;
                                case 'center': $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_CENTER; break;
                                default: $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_LEFT; break;
                        }

                        // Выставляем ширину столбца
			if (!$exp_from_file) {
			 $objPHPExcel->setActiveSheetIndex(0)->getColumnDimensionByColumn($cell_exp)->setWidth($main_db -> sql_result($query, "L_WIDTH")/2);
			}
                }	

                // Указываем Формат для всего столбца начиная с текущей строки:					
                switch ($main_db -> sql_result($query, "FIELD_TYPE")) {
                        case 'S': $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_GENERAL ; break;
                        case 'D': $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_DATE_DDMMYYYY; break;
                        case 'N': $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1; break;
                        default:  $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_GENERAL ; break;
                }	
	}			
			
        if ($isaexport != 'csv' and !$objPHPExcel->hasMacros()) {	
                for ($i = 1; $i < $row_exp; $i++) {
                    // Обьединяем ячейки для заголовка таблици
                    $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow(0,$i); //выбираем откуда     
                    $F_rom = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();
                    $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($cell_exp,$i); //выбираем куда                
                    $T_o = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();
                    $objPHPExcel->setActiveSheetIndex(0)->mergeCells($F_rom.":".$T_o);
                }
                // Рисуем заголовок таблици обьеденяя все ячейка столбцов в одну		
                $objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$row_exp - 1, $exp_title);
                $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow(0,$row_exp - 1);
                $objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);	
                $objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setBold(true);
                $objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setSize(14);    
        } 
            
        // Разбираем переменные для поиска			
        if (filter_input(INPUT_GET, '_search',FILTER_VALIDATE_BOOLEAN) and (filter_input(INPUT_GET, 'filtred',FILTER_SANITIZE_STRING) <> "undefined")) {
               foreach(filter_input_array(INPUT_GET) as $k => $v) {
				// Мы можем передать данные в формате <тип поиска>><данные>
				$s_opts = explode(">",$v);
					if (isset($s_opts[1])) {
					$v = iconv(HTML_ENCODING,LOCAL_ENCODING,trim(strip_tags(html_entity_decode($s_opts[1])))); // кодировочку меняем
						if (array_search(BasicFunctions::trim_fieldname($k), $arr_field, true)) {
							$type_field = $arr_field_type[array_search(BasicFunctions::trim_fieldname($k), $arr_field)];
                                                        $k = strip_tags(html_entity_decode(BasicFunctions::trim_fieldname($k)));
							
							switch (trim($s_opts[0])) { // Смотрим что за логическая операция
								case "NOT": $literal = "!="; break;
								case "MORE": $literal = ">"; break;
								case "MINI": $literal = "<"; break;
								case "EQUAL": $literal = "="; break;
								case "LIKE": $literal = "LIKE"; break;
								case "undefined": $literal = "= "; break;
								case "NONE": break;
							}	
										
							if ($v != "" ) 
							    if ((( $type_field == "DT" ) or ( $type_field == "D" ) and trim($s_opts[0]) != "LIKE") ) {
									// Дата может быть нескольких форматов
									if (stripos($v,":") > 0) {
										$qWhere .= " AND t.".$k." ".$literal." to_date('".$v."', 'dd.mm.yyyy hh24:mi:ss') ";
									} else {
										$qWhere .= " AND t.".$k." ".$literal." to_date('".$v."', 'dd.mm.yyyy') ";
									}								
							} else {
							    if (trim($s_opts[0]) == "LIKE") { 
								$qWhere .= " AND lower(t.".$k.") ".$literal." lower('%".$v."%') ";
							    } else {
								$qWhere .= " AND lower(t.".$k.") ".$literal." lower('".$v."') ";
							    }

							}										
						}
					}
			}
        }        

        // Теперь загружаем данные в табличку
        $query_dt = $main_db -> sql_execute($str_dt.str_replace("SqWhere", $qWhere,$str_dt_f));			
        while ($main_db -> sql_fetch($query_dt)) {
                    $cell_exp = $cell_exp_first;
                    $row_exp++;
             foreach ($arr_field as $key=>$line){
                    // Вставляем ячейку						
                    $objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($cell_exp, $row_exp, $main_db -> sql_result($query_dt, $arr_field[$key]));	
                    $cell_exp++;
             }
        }
        
        if(!$objPHPExcel->hasMacros()) {
            for ($i = $cell_exp_first; $i < $cell_exp; $i++) {
                    $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($i,$row_exp_zag); //выбираем откуда  
                    $F_rom = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();
                    $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($i,$row_exp); //выбираем куда                    
                    $T_o = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();			
                    // Применяем стиль и формат постолбцам
                    if (isset($Cell_format[$i])) $objPHPExcel->setActiveSheetIndex(0)->getStyle($F_rom.":".$T_o)->getNumberFormat()->setFormatCode($Cell_format[$i]);					
                    if (isset($Cell_format_align[$i])) $objPHPExcel->setActiveSheetIndex(0)->getStyle($F_rom.":".$T_o)->getAlignment()->setHorizontal($Cell_format_align[$i]);					
                    $objPHPExcel->setActiveSheetIndex(0)->getStyle($F_rom.":".$T_o)->getBorders()->getAllBorders()->setBorderStyle(PHPExcel_Style_Border::BORDER_THIN);				
            }
        }

        // выбираем ячейку самую первую
        $objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow(0,0);

        // формат экспорта:
        switch ($isaexport) {
                        case 'xlsx':    header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                                        $objWriter = new PHPExcel_Writer_Excel2007($objPHPExcel);					
                                        
                                        	
                        break;
                        case 'xlsm':    header("Content-Type: application/vnd.ms-excel.sheet.macroEnabled.12");
                                        $objWriter = new PHPExcel_Writer_Excel2007($objPHPExcel);
                        break;
                        case 'csv':
                                        header("Content-type: text/csv");
                                        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'CSV')->setDelimiter(';')
                                                          ->setEnclosure('"')
                                                          ->setLineEnding("\r\n")
                                                          ->setSheetIndex(0);
                        break;
                        case 'xls':						
                                        header("Content-Type: application/vnd.ms-excel");
                                        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, "Excel5");
                        break;
                        case 'pdf':						
                                        header("Content-Type: application/pdf");                       
                                        PHPExcel_Settings::setPdfRenderer(PHPExcel_Settings::PDF_RENDERER_MPDF,ENGINE_ROOT."/library/mdpf/");
                                        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'PDF');
                                        $objWriter -> writeAllSheets();	
                        break; 
                        case 'print':	
                                        header("Content-Type: text/html");    
                                        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'HTML');                                        	
                        break;    
        }			
        
        header("Content-Disposition: attachment;filename=".$exp_file);
        header("Cache-Control: max-age=0");        
        header("Set-Cookie: fileDownload=true");
        $objWriter -> save("php://output");
	
        // подчищаем за собой
        $objPHPExcel->disconnectWorksheets();
        unset($objWriter, $objPHPExcel);
        if (isset($temp_file) and is_file($temp_file)) {
            unlink($temp_file);            
        }
$main_db -> __destruct();