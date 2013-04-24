<?
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Экспорт:
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	requre_script_file("lib.requred.php"); 

	header("Set-Cookie: fileDownload=false");

	$user_auth = new AUTH();	
	if (!$user_auth -> is_user()) {
			clear_cache();
			die("Доступ запрещен");
	}
	$main_db = new db();
	
	end_session();  // Закрываем сейсию для паралельного исполнния
	
	$type    	= @Convert_quotas($_GET['type']);
	$id_mm      = @intval($_GET['id_mm']); 
	$id_mm_fr   = @intval($_GET['id_mm_fr']); 
	$id_mm_fr_d = @intval($_GET['id_mm_fr_d']); 
	$pageid		= @Convert_quotas($_GET['pageid']); 

	$qWhere		= "";
	$arr_field      = array();
    $arr_field_type = array();
	$i              = 0;
	$m 				= 0;	
	$k              = 0;
	
	// Переменные для детальных гридов
	if (($type == "GRID_FORM_DETAIL") or ( $type == "TREE_GRID_FORM_MASTER") or ( $type == "TREE_GRID_FORM_DETAIL") ) {	
	$exp_query = $main_db -> sql_execute("select t.object_name from ".DB_USER_NAME.".wb_mm_form t left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = t.id_wb_form_type where t.id_wb_main_menu = ".$id_mm." and ft.name like '%_MASTER'");
			while ($main_db -> sql_fetch($exp_query)) $Master_Table_ID = $main_db -> sql_result($exp_query, "OBJECT_NAME");
			if (is_numeric($_GET['id'])) {			 
					$s_d_m_Where  = " AND ID_".$Master_Table_ID." = ".intval($_GET['id']);
				} else {
					$s_d_m_Where  = " AND ID_".$Master_Table_ID." = '".Convert_quotas($_GET['id'])."'";
			}
			//$id_mm_fr = $id_mm_fr_d;
	} else {
			$s_d_m_Where     = "";	
	}
	
	//Подготавливаем к экспорту все
	require_once 'library/PHPExcel.php';
	$exp_query = $main_db -> sql_execute("select t.name as s_name,t.object_name as f_name, t.xsl_file_in as filename from ".DB_USER_NAME.".WB_MM_FORM t where rownum = 1 and t.id_wb_mm_form = ".$id_mm_fr);
	while ($main_db -> sql_fetch($exp_query)) {				
		$exp_name = $main_db -> sql_result($exp_query, "S_NAME",false);
		$exp_title = $main_db -> sql_result($exp_query, "S_NAME");
		$exp_file = $main_db -> sql_result($exp_query, "FILENAME",false);
		if ($exp_file == "") $exp_file = $exp_name." (".date("d-m-Y").").xls";	
		$creator_name = $main_db -> get_realname();
	}
	$temp_file = tempnam(sys_get_temp_dir(), rand(5, 15) . $exp_name);
	// Вариант экспорта по шаблону версия без дума
		if ($_GET['isaexport'] == "old") {
			require_once 'library/PHPExcel/Shared/ZipArchive.php';
			require_once 'library/PHPExcel/IOFactory.php';
			
			// Проверяем тип файла:			
			if (strpos($exp_file,".xlsm") == false) $exp_file .= "m";
			
			// Временный файл для экселя			
			file_put_contents($temp_file,file_get_contents("xlt/". $exp_file));			
			$filetype = PHPExcel_IOFactory::identify($temp_file);
			$objReader = PHPExcel_IOFactory::createReader($filetype);			
			$objPHPExcel = $objReader -> load($temp_file);
			
			// Сохраняем макрос в файл
			$zip = new ZipArchive; 
			$zip -> open($temp_file);
			// Доставем переменные для макросов:
			$macro_content = $zip->getFromName('xl/vbaProject.bin');			

					// Начинаем считать строки и столбцы
					$cell_exp = 0;
					$row_exp = 2;
					
					// Говорим что это обьект xls с макросом (для корректного сохранения)
					$_GET['isaexport'] = 'xlsm';
		
			unset($zip);

		} else {
			$objPHPExcel = new PHPExcel();
			$objPHPExcel->getProperties()->setCreator($creator_name)
														 ->setLastModifiedBy($creator_name)
														 ->setTitle($exp_name)
														 ->setCategory("Data export file");
			// Начинаем считать строки и столбцы
			$cell_exp = 0;
			$row_exp = 1;
		}
	
	// Заполняем поля заголовка если они есть
	$exp_query = $main_db -> sql_execute("select t.name,t.field_txt, t.field_name,t.xls_position_col,t.xls_position_row,t.field_type
                            from ".DB_USER_NAME.".wb_form_cells t where t.id_wb_mm_form = ".$id_mm_fr." and t.type_cells = 'H' order by t.num");
	while ($main_db -> sql_fetch($exp_query)) {				
					// получаем значение
					$str_res = "Select 1 X,".$main_db -> sql_result($exp_query, "FIELD_TXT")." PARAM from dual";
					$query_res = OCI_Parse($main_db -> link,$str_res);
					if (OCI_Execute($query_res, OCI_DEFAULT) and ($_GET['isaexport'] <> 'csv')) while ($main_db -> sql_fetch($query_res)) {
							$objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($cell_exp,$row_exp,str_replace("&nbsp;", " ",$main_db -> sql_result($exp_query, "NAME")." ".$main_db -> sql_result($query_res, "PARAM",false)));
							$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($cell_exp,$row_exp);
							$objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setBold(true);
					$row_exp++;									
					}					
	 }		
	 
	// Делаем отступ в 2 строки
	if ($_GET['isaexport'] <> 'csv') $row_exp = $row_exp + 2;
				
	// Если это шаблон то делаем отступ только в одну строку
	if ($_GET['isaexport'] == 'xlsm') $row_exp = $row_exp - 1;
	
	// Запоминаем стратовую позицию данных
	$row_exp_zag = 	$row_exp;
	
	// ПРоверяем нужно-ли выводить скрытые столбци
	$query = $main_db -> sql_execute("Select ".DB_USER_NAME.".wb_sett.get_settings_val_char(upper('SETTINGS_VIEW_INVISIBL_ID_TABLE')) column_value from dual");
            while ($main_db -> sql_fetch($query)) $param_value = $main_db -> sql_result($query, "COLUMN_VALUE");  
			
	if (intval($param_value) <> 0) {
		$query = $main_db -> sql_execute("Select ".DB_USER_NAME.".wb_sett.get_settings_val_char(upper('SETTINGS_VIEW_INVISIBLE_AUDIT_FIELDS')) column_value from dual");
            while ($main_db -> sql_fetch($query)) $param_value_audit = str_replace(",","','", $main_db -> sql_result($query, "COLUMN_VALUE"));   
		$query = $main_db -> sql_execute("Select ".DB_USER_NAME.".wb_sett.get_settings_val_char(upper('SETTINGS_VIEW_INVISIBLE_SYS_FIELDS')) column_value from dual");
            while ($main_db -> sql_fetch($query)) $param_value_audit .= "','".str_replace(",","','", $main_db -> sql_result($query, "COLUMN_VALUE"));
		$show_hidden = "and t.field_name not in ('".$param_value_audit."') ";
		
	} else {
		$show_hidden = "";	
	}
        $arr_field      = array();
		$Cell_format_align = array();
		$Cell_format = array();
        $str_dt         = "";		
		
		// Запрос списка столбцов и их имен
        $query = $main_db -> sql_execute("select tf.owner,tf.object_name,tf.XSL_FILE_IN, tf.XSL_FILE_OUT, t.name, round(t.width/3) as l_width,
                       decode(t.field_type, 'D', 'to_char('||t.field_name||', ''dd.mm.yyyy hh24:mi:ss'') '||t.field_name, 'I', 'round('||t.field_name||', 0) '||t.field_name, t.field_name) f_name,
                       nvl2(tf.form_where, 'AND '||tf.form_where, null) form_where,  t.field_type,
                       t.field_name, ta.html_txt align_txt,t.XLS_POSITION_COL,t.XLS_POSITION_ROW
                  from ".DB_USER_NAME.".wb_mm_form tf
                  left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form
                  left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
                  where tf.id_wb_mm_form = ".$id_mm_fr." ".$show_hidden." and t.field_name != 'ID_' || tf.object_name order by t.num");
        while ($main_db -> sql_fetch($query)) {
			if ((intval($param_value) <> 1) and ($main_db -> sql_result($query, "FIELD_NAME") == "ID_CONTROL_LOAD_DATA")) continue;	
                if ($str_dt=="") {
                    $owner      = $main_db -> sql_result($query, "OWNER");
					$table_name = $main_db -> sql_result($query, "OBJECT_NAME");
					$str_dt = "Select ".$main_db -> sql_result($query, "F_NAME");
					$str_dt_f = " from (Select /*+ F  IRST_ROWS*/ rownum r_num, t.* from ".$owner.".".$table_name." t  WHERE 1=1  SqWhere ".$main_db -> sql_result($query, "FORM_WHERE")." ".$s_d_m_Where." )";					
					$str_count = "Select /*+ F  IRST_ROWS*/ count(*) C_COUNT from ".$owner.".".$table_name." t WHERE 1=1  ".$main_db -> sql_result($query, "FORM_WHERE")." ".$s_d_m_Where."  ";
                    $str_leafs = "Select t.id_".$table_name." ID from ".$owner.".".$table_name." t left join ".$owner.".".$table_name." t1 on t1.id_parent = t.id_".$table_name." where t1.id_".$table_name." is null";
				} else {
                    $str_dt = $str_dt.", ".$main_db -> sql_result($query, "F_NAME");
                }
                $arr_field[$cell_exp] = $main_db -> sql_result($query, "FIELD_NAME");
				$arr_field_type[$cell_exp] = $main_db -> sql_result($query, "FIELD_TYPE");			
				
				// выбираем ячейку
				$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($cell_exp,$row_exp);
				// говорим что она БОЛД
				$objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setBold(true);				
				
				// Используем ячейки только при нормальном экспорте, если кустом или csv то неиспользуем
				if 	((($_GET['isaexport'] <> 'csv') and ($_GET['isaexport'] <> 'xlsm')) or (!isset($macro_content))) {	
					// Заполняем начальные данные по столбцам				
					$objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($cell_exp,$row_exp, trim(str_replace(array("(not display)", "<BR>", "#","<br>")," ",$main_db -> sql_result($query, "NAME"))));
					
					// Указываем алигн для всего столбца начиная с текущей строки:					
					switch ($main_db -> sql_result($query, "ALIGN_TXT")) {
						case 'left':   $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_LEFT; break;
						case 'right':  $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_RIGHT; break;
						case 'center': $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_CENTER;	break;
						default: $Cell_format_align[$cell_exp] = PHPExcel_Style_Alignment::HORIZONTAL_LEFT; break;
					}
					
					// Выстовляем ширину столбца
					$objPHPExcel->setActiveSheetIndex(0)->getColumnDimensionByColumn($cell_exp)->setWidth($main_db -> sql_result($query, "L_WIDTH"));
					//$objPHPExcel->setActiveSheetIndex(0)->getColumnDimensionByColumn($cell_exp)->setAutoSize(false);	
				}	
				
				// Указываем Формат для всего столбца начиная с текущей строки:					
				switch ($main_db -> sql_result($query, "FIELD_TYPE")) {
					case 'S':   $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_GENERAL ; break;
					case 'D':  $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_DATE_DDMMYYYY; break;
					case 'N': $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1;	break;
					default:   $Cell_format[$cell_exp] = PHPExcel_Style_NumberFormat::FORMAT_GENERAL ; break;
				}										
				// инкрементируем значение ячейки
				$cell_exp++;
			}			
			
			if 	(($_GET['isaexport'] <> 'csv') and ($_GET['isaexport'] <> 'xlsm')) {	
			
				// Обьединяем ячейки для заголовка таблици
				$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow(0,$row_exp-1); //выбираем откуда
				$F_rom = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();
				$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($cell_exp-1,$row_exp-1); //выбираем куда
				$T_o = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();
				$objPHPExcel->setActiveSheetIndex(0)->mergeCells($F_rom.":".$T_o);
				
				// Рисуем заголовок таблици обьеденяя все ячейка столбцов в одну		
				$objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$row_exp - 1, $exp_title);
				$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow(0,$row_exp - 1);
				$objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);	
				$objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setBold(true);
				$objPHPExcel->setActiveSheetIndex(0)->getStyle($objPHPExcel->setActiveSheetIndex(0)->getActiveCell())->getFont()->setSize(14);	
			} 
			
			function in_array_search($text,$array) { foreach($array as $key => $arrayValue) if (strtoupper(trim($arrayValue)) == strtoupper(trim($text))) return $key; }
			
			// Разбираем переменные для поиска			
			if ((@$_GET['_search'] <> "false") and (@$_GET['filtred'] <> "undefined")) foreach($_GET as $k=>$v) {
				// Мы можем передать данные в формате <тип поиска>><данные>
				$s_opts = explode(">",$v);
				$v = iconv(HTML_ENCODING,LOCAL_ENCODING,trim(@$s_opts[1])); // кодировочку меняем				
				$type_field = @$arr_field_type[in_array_search(trim_fieldname($k), $arr_field)];
				if ($v != "" ) if ( $type_field == "D" ) {
									// Дата может быть нескольких форматов
									if (stripos($v,":") > 0) {
										$qWhere .= " AND t.".trim_fieldname($k)." = to_date('".$v."', 'dd.mm.yyyy hh24:mi:ss') ";
									} else {
										$qWhere .= " AND t.".trim_fieldname($k)." = to_date('".$v."', 'dd.mm.yyyy') ";
									}								
								} else switch (trim($s_opts[0])) { // Смотрим что за логическая операция
											case "NOT": $qWhere .= " AND lower(t.".trim_fieldname($k).") != lower('".$v."') "; break;
											case "MORE": $qWhere .= " AND lower(t.".trim_fieldname($k).") > lower('".$v."') "; break;
											case "MINI": $qWhere .= " AND lower(t.".trim_fieldname($k).") < lower('".$v."') "; break;
											case "EQUAL": $qWhere .= " AND lower(t.".trim_fieldname($k).") = lower('".$v."') "; break;
											case "LIKE": $qWhere .= " AND lower(t.".trim_fieldname($k).") LIKE lower('%".$v."%') "; break;
											case "undefined": $qWhere .= " AND lower(t.".trim_fieldname($k).") = lower('".$v."') "; break;
											case "NONE": break;
										}										
						
			}	
			
			$str_dt_f  = str_replace("SqWhere", $qWhere,$str_dt_f);	
			// Теперь загружаем данные в табличку
			$query_dt = $main_db -> sql_execute($str_dt.$str_dt_f);			
               while ($main_db -> sql_fetch($query_dt)) {
					$cell_exp = 0;
					$row_exp++;
                    foreach ($arr_field as $key=>$line){
						// Вставляем ячейку						
						$objPHPExcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($cell_exp, $row_exp, $main_db -> sql_result($query_dt, $arr_field[$key]));						
						$cell_exp++;
                    }
            }
					
		for ($i = 0; $i < $cell_exp; $i++) {
			$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($i,$row_exp_zag); //выбираем откуда
			$F_rom = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();
			$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow($i,$row_exp); //выбираем куда
			$T_o = $objPHPExcel->setActiveSheetIndex(0)->getActiveCell();			
			// Применяем стиль и формат постолбцам
			$objPHPExcel->setActiveSheetIndex(0)->getStyle($F_rom.":".$T_o)->getNumberFormat()->setFormatCode($Cell_format[$i]);					
			if (isset($Cell_format_align[$i])) $objPHPExcel->setActiveSheetIndex(0)->getStyle($F_rom.":".$T_o)->getAlignment()->setHorizontal($Cell_format_align[$i]);					
			$objPHPExcel->setActiveSheetIndex(0)->getStyle($F_rom.":".$T_o)->getBorders()->getAllBorders()->setBorderStyle(PHPExcel_Style_Border::BORDER_THIN);				
		}
					
		// выбираем ячейку самую первую
		$objPHPExcel->setActiveSheetIndex(0)->setSelectedCellByColumnAndRow(0,0);
		// Экспортируем файл в браузер
		if ($_GET['isaexport'] != 'xlsm') $objPHPExcel->getActiveSheet()->setTitle("Данные экспорта"); // имя листа
		if ($_GET['isaexport'] != 'xlsm') $objPHPExcel->setActiveSheetIndex(0);
        header("Set-Cookie: fileDownload=true");	
		// формат экспорта:
		switch ($_GET['isaexport']) {
				case 'xlsx':						
						header("Content-Type: application/vnd.ms-excel;");
						header("Content-Disposition: attachment;filename=".str_replace(".xls",".xlsx",$exp_file)."");
						header("Cache-Control: max-age=0");
						$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, "Excel2007");
						$objWriter -> save($temp_file);
						echo file_get_contents($temp_file);
				break;
				case 'xlsm':						
						header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;");
						header("Content-Disposition: attachment;filename=".$exp_file."");
						header("Cache-Control: max-age=0");
						
						// Нам нужно собрать данные для макроса из файла экселя:
						$zip = new ZipArchive; 
						$zip -> open($temp_file);
						
						// Доставем переменные для макросов:		
						$macro_content   = $zip->getFromName('xl/vbaProject.bin');
						$temp_macro = tempnam(sys_get_temp_dir(), rand(5, 15) . $exp_name);
						file_put_contents($temp_macro,$macro_content);			
						
						unset($zip);
						$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, "Excel2007");
						$objWriter -> save($temp_file);
						
						// Открываем файл и добавляем к нему макрос						
						$zip = new ZipArchive; 
						$zip->open($temp_file);
						$zip->addFile($temp_macro, 'xl/vbaProject.bin');
						unlink($temp_macro);
						
						$ContentTypes = $zip->getFromName('[Content_Types].xml');
						$ContentTypesXML = new DomDocument();
						$success = (int) @$ContentTypesXML->loadXML( $ContentTypes );
						$Types = $ContentTypesXML->getElementsByTagName('Types')->item(0);						
						$Override = $ContentTypesXML->createElement("Override");
						$Override = $Types->appendChild($Override);
						$Override->setAttribute('PartName', '/xl/vbaProject.bin');
						$Override->setAttribute('ContentType', 'application/vnd.ms-office.vbaProject');						
						foreach($Types->getElementsByTagName('Override') as $Override){
							if($Override->hasAttribute('PartName') && $Override->getAttribute('PartName')=="/xl/workbook.xml" ){
								$Override->setAttribute('ContentType', 'application/vnd.ms-excel.sheet.macroEnabled.main+xml');
							}
						}     						
						$zip->addFromString('[Content_Types].xml', $ContentTypesXML->saveXML() );      
						$Workbook = $zip->getFromName('xl/_rels/workbook.xml.rels');
						$WorkbookXML = new DomDocument();
						$success = (int) @$WorkbookXML->loadXML( $Workbook );
						$Rltns = $WorkbookXML->getElementsByTagName('Relationships')->item(0);
						$Rltn = $WorkbookXML->createElement("Relationship");
						$Rltn = $Rltns->appendChild($Rltn);
						$Rltn->setAttribute('Id', 'rId99');
						$Rltn->setAttribute('Type', 'http://schemas.microsoft.com/office/2006/relationships/vbaProject');
						$Rltn->setAttribute('Target', 'vbaProject.bin');
						$zip->addFromString('xl/_rels/workbook.xml.rels', $WorkbookXML->saveXML() );
						$zip->close();
						
						// Отдаем пользователю файл
						echo file_get_contents($temp_file);
						unlink($temp_file);
				break;
				case 'csv':
						header("Content-type: text/csv");
						header("Content-Disposition: attachment;filename=".str_replace(".xls",".csv",$exp_file)."");
						header("Cache-Control: max-age=0");
						$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'CSV')->setDelimiter(';')
                                                                  ->setEnclosure('"')
                                                                  ->setLineEnding("\r\n")
                                                                  ->setSheetIndex(0);
						$objWriter -> save("php://output");	
				break;
				case 'xls':
						header("Content-Type: application/vnd.ms-excel");
						header("Content-Disposition: attachment;filename=".$exp_file."");
						header("Cache-Control: max-age=0");
						$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, "Excel5");
						$objWriter -> save("php://output");	
				break;
		}			
$main_db -> __destruct();
?>