<?
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Вывод данных для грида
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	BasicFunctions::requre_script_file("lib.requred.php");
	BasicFunctions::requre_script_file("auth.".AUTH.".php");
	BasicFunctions::requre_script_file("lib.json.php");
	
	header("Content-type: text/script;charset=".HTML_ENCODING);

  	// Начальные переменные
	$user_auth = new AUTH();	
	if (!$user_auth -> is_user()) {
			BasicFunctions::clear_cache();
			die("Доступ запрещен");
	}	
	$main_db = new db();
	if (filter_input(INPUT_GET, 'id_mm',FILTER_VALIDATE_FLOAT)) {
		$id_mm      	 = filter_input(INPUT_GET, 'id_mm',FILTER_SANITIZE_NUMBER_FLOAT); 
	} else {
		$id_mm      	 = "'" .filter_input(INPUT_GET, 'id_mm',FILTER_SANITIZE_MAGIC_QUOTES). "'"; 
	}
        $type    	 = filter_input(INPUT_GET, 'type',FILTER_SANITIZE_STRING);
	$id_mm_fr   	 = filter_input(INPUT_GET, 'id_mm_fr',FILTER_SANITIZE_NUMBER_INT); 
	$id_mm_fr_d 	 = filter_input(INPUT_GET, 'id_mm_fr_d',FILTER_SANITIZE_NUMBER_INT);	
	$page_ 	 	 = filter_input(INPUT_GET, 'page',FILTER_SANITIZE_NUMBER_INT);  
	$limit 		 = filter_input(INPUT_GET, 'rows',FILTER_SANITIZE_NUMBER_INT);  
	$sidx 		 = filter_input(INPUT_GET, 'sidx',FILTER_SANITIZE_STRING);                   
	$sord 		 = filter_input(INPUT_GET, 'sord',FILTER_SANITIZE_STRING); 
        $pageid          = filter_input(INPUT_GET, 'pageid',FILTER_SANITIZE_NUMBER_INT); 
	$idx		 = filter_input(INPUT_GET, 'idx',FILTER_SANITIZE_NUMBER_INT);
	$Master_Table_ID = filter_input(INPUT_GET, 'Master_Table_ID',FILTER_SANITIZE_STRING);
	
	
	// Переменные для инициализации
	$arr_field      = array();
        $arr_field_type = array();
	$count		= 0;
	$i 		= 0;	
	$m 		= 0;	
	$k              = 0;
        $str_dt         = "";
	$qWhere		= "";
	$check		= "";
        
	// Переделываем запрос для детального грида
	if (($type == "GRID_FORM_DETAIL") or ($type == "TREE_GRID_FORM_DETAIL")) {		
			$s_d_m_Where     = " AND ".$Master_Table_ID." = ".$id_mm;
			$id_mm_fr = $id_mm_fr_d;
	} else 	$s_d_m_Where     = "";
	
	// Дополнительная проверка на пользователя и права доступа:
	$query_check = $main_db -> sql_execute("select tf.edit_button from wb_mm_form tf where tf.id_wb_mm_form = ".$id_mm_fr." and wb.get_access_main_menu(tf.id_wb_main_menu) = 'enable'");
	while ($main_db -> sql_fetch($query_check)) {
		$check	= explode(",",strtoupper(trim( $main_db -> sql_result($query_check, "EDIT_BUTTON"))));
        }
	// если пользователю недоступна форма, то выходим сразу
	if (empty($check)) die("Доступ для чтения данных запрещен");

	// Теперь просто смотрим все поля				
    $query = $main_db -> sql_execute("select tf.owner,
       tf.object_name,
       (select u.object_type  from user_objects u where u.object_name = upper(tf.object_name)) object_type,
	    nvl2(tf.form_where, 'AND ' || tf.form_where, null) form_where, t.name, t.field_name,
        decode(trim(t.field_type),
              'D',
              'decode(to_char(' || t.field_name ||
              ', ''hh24:mi:ss''), ''00:00:00'', to_char(' || t.field_name ||
              ', ''dd.mm.yyyy''),to_char(' || t.field_name ||
              ', ''dd.mm.yyyy hh24:mi:ss'')) ' || t.field_name,
              'DT',
              'decode(to_char(' || t.field_name ||
              ', ''hh24:mi:ss''), ''00:00:00'', to_char(' || t.field_name ||
              ', ''dd.mm.yyyy''),to_char(' || t.field_name ||
              ', ''dd.mm.yyyy hh24:mi:ss'')) ' || t.field_name,
              'I',
              'round(' || t.field_name || ', 0) ' || t.field_name,
              t.field_name) f_name,
       ta.html_txt align_txt, tf.xsl_file_in, t.field_type, tf.form_order as form_order
	   from ".DB_USER_NAME.".wb_mm_form tf
	   left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form
	   left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
	   where tf.id_wb_mm_form = ".$id_mm_fr." order by t.num");
		
    while ($main_db -> sql_fetch($query)) {
				if ($str_dt=="") {
                                        $owner      = $main_db -> sql_result($query, "OWNER",false);
					$table_name = $main_db -> sql_result($query, "OBJECT_NAME",false);
					$str_dt = "select * from (Select max_count_number_99999, ".$main_db -> sql_result($query, "F_NAME",false);
					$str_dt_f = ",rownum r_num_page from (Select rownum r_num, count(*) over (order by 1) as max_count_number_99999, t.* from ".$owner.".".$table_name." t  WHERE 1=1 SqWhere ".$main_db -> sql_result($query, "FORM_WHERE",false)." ".$s_d_m_Where." ";					
                                        $str_leafs = "Select t.id_".$table_name." ID from ".$owner.".".$table_name." t left join ".$owner.".".$table_name." t1 on t1.id_parent = t.id_".$table_name." where t1.id_".$table_name." is null";
					$order_field = $main_db -> sql_result($query, "FORM_ORDER",false);
				} else {					
					 $str_dt = $str_dt.", ".$main_db -> sql_result($query, "F_NAME",false);
                }
				$i++;			
                $arr_field[$i]      = $main_db -> sql_result($query, "FIELD_NAME",false);
                $arr_field_type[$i] = trim($main_db -> sql_result($query, "FIELD_TYPE",false));			
    }     	
			// Разбираем переменные для поиска
			if (filter_input(INPUT_GET, '_search',FILTER_VALIDATE_BOOLEAN))
                                foreach(filter_input_array(INPUT_GET) as $k => $v) {
				// Мы можем передать данные в формате <тип поиска>><данные>
				$s_opts = explode(">",$v);
					if (isset($s_opts[1])) {
					$v = iconv(HTML_ENCODING,LOCAL_ENCODING,trim(strip_tags(html_entity_decode($s_opts[1])))); // кодировочку меняем
						if (array_search(BasicFunctions::trim_fieldname($k), $arr_field, true)) {
							$type_field = $arr_field_type[array_search(BasicFunctions::trim_fieldname($k), $arr_field)];
                                                        $k = strip_tags(html_entity_decode(BasicFunctions::trim_fieldname($k)));
							if ($v != "" ) if (( $type_field == "DT" ) or ( $type_field == "D" )) {
									// Дата может быть нескольких форматов
									if (stripos($v,":") > 0) {
										$qWhere .= " AND t.".$k." = to_date('".$v."', 'dd.mm.yyyy hh24:mi:ss') ";
									} else {
										$qWhere .= " AND t.".$k." = to_date('".$v."', 'dd.mm.yyyy') ";
									}								
								} else switch (trim($s_opts[0])) { // Смотрим что за логическая операция
											case "NOT": $qWhere .= " AND lower(t.".$k.") != lower('".$v."') "; break;
											case "MORE": $qWhere .= " AND lower(t.".$k.") > lower('".$v."') "; break;
											case "MINI": $qWhere .= " AND lower(t.".$k.") < lower('".$v."') "; break;
											case "EQUAL": $qWhere .= " AND lower(t.".$k.") = lower('".$v."') "; break;
											case "LIKE": $qWhere .= " AND lower(t.".$k.") LIKE lower('%".$v."%') "; break;
											case "undefined": $qWhere .= " AND lower(t.".$k.") = lower('".$v."') "; break;
											case "NONE": break;
										}										
						}
					}
			}	
			// Вычисляем узлы дерева если это дерево
			if (($type == "TREE_GRID_FORM") or ($type == "TREE_GRID_FORM_MASTER")  or ($type == "TREE_GRID_FORM_DETAIL")) {
				$query_leafs = $main_db -> sql_execute($str_leafs);				
				while ($main_db -> sql_fetch($query_leafs)) $leafs[] = $main_db -> sql_result($query_leafs, "ID",false);								
		    }
			// Заменяем если есть поиск
			$str_dt_f  = str_replace("SqWhere", $qWhere,$str_dt_f);
			
			// Расчитываем страници                   
			$start = $limit*$page_ - $limit;  
			if($start < 0) $start = 0;                     
			$stop  = $start + $limit ;
			 
			$dt = (object)''; // инициализируем как обьект
			if  (($type == "TREE_GRID_FORM") or ($type == "TREE_GRID_FORM_MASTER") or ($type == "TREE_GRID_FORM_DETAIL"))  {
				
				// В случае если это древесный грид то грузим все
				$str_dt = $str_dt.$str_dt_f."))";
				$dt -> page         = 1;  
				$dt -> total        = 1;  
				$dt -> records      = 1; 	
			} else {
				// Продвинутая сортировка по столбцам
				if(!$sidx) {
						// Ордер не задан, берем из поля формы, либо если его там нет то ордер убираем полностью
						if (!empty($order_field)) {
							$order_type = " order by ". $order_field;
							// при этом у нас добавляется аналитический овер по полю ровнум
							$str_dt_f  = str_replace("rownum r_num,", "row_number() over (".$order_type.") r_num,",$str_dt_f);
						} else {
							$order_type = " order by 1"; // сортировка по первому полю ровнум
						}
					} else {
						$order_type = " order by " . BasicFunctions::trim_fieldname($sidx)." ".$sord;
				}
			
				// Если у нас выставлена постраничная прокрутка то грузим постранично
				$str_dt = $str_dt.$str_dt_f.$order_type.")) where r_num_page between ".$start." and ".$stop;
			} 
			
			BasicFunctions::end_session();
			
			$query_dt = $main_db -> sql_execute($str_dt);					
            while ($main_db -> sql_fetch($query_dt)) {
					$k = $k + 1;
					$id_ = "ID_".$table_name;					
					if (!array_search($id_, $arr_field)) { $dt->rows[$m]['id'] = $k; } else $dt->rows[$m]['id'] = $main_db -> sql_result($query_dt, $id_);					
					$dt_cell = array();
					$r = 0;				
                    foreach ($arr_field as $key => $line) {
                        switch ($arr_field_type[$key]) {
							case 'L':
								$td_val = $main_db -> sql_result($query_dt, $arr_field[$key]);								
								$td_val = $td_val -> load();
								$td_val = $td_val;								
								break;
							default:
								$td_val = $main_db -> sql_result($query_dt, $arr_field[$key]);
								if ($arr_field[$key] == 'LEV')       $td_level_val     = $td_val-1;
							        if ($arr_field[$key] == 'ID_PARENT') $td_id_parent_val = $td_val; 							
							break;
						}
						
						if (!empty($td_val)) {
								$dt_cell[$r] = $td_val;
							} else {
								$dt_cell[$r] = "";
							}
						$r = $r + 1;
                    }
					
					if  (($type == "TREE_GRID_FORM") or ($type == "TREE_GRID_FORM_MASTER") or ($type == "TREE_GRID_FORM_DETAIL"))  {
						$dt_cell[$r] = $td_level_val;
						$r++;						
						// Определяем родителя
						if ($td_id_parent_val == '') {$parent = NULL;} else $parent = $td_id_parent_val;
						$dt_cell[$r] = $parent;
						$r++;
						
						// Определяем является ли выбранный узел "листом"
						if(in_array($dt->rows[$m]['id'], $leafs)) { $dt_cell[$r] = TRUE; } else $dt_cell[$r] = FALSE;					
					}
					$dt->rows[$m]['cell'] = $dt_cell;
					$count = $main_db -> sql_result($query_dt, "MAX_COUNT_NUMBER_99999");
					$m++;  
            }	
			
			// Записываем общее количество:
			if (!isset($dt -> page)) {
				if ($count > 0 && $limit > 0) { $total_pages = ceil($count/$limit);  } else  $total_pages = 0; 
				if ($page_ > $total_pages) $page_=$total_pages;  
				$dt -> page         = $page_;  
				$dt -> total        = $total_pages;  
				$dt -> records      = $count;	
			}			                              
			
            $json = new json();
	    echo $json -> jsonencode($dt);			
$main_db -> __destruct();