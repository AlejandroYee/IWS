<?
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Вывод данных для грида
//--------------------------------------------------------------------------------------------------------------------------------------------
	require_once("library/lib.func.php");
	requre_script_file("lib.requred.php"); 
	header("Content-type: text/script;charset=".HTML_ENCODING);

  	// Начальные переменные
	$user_auth = new AUTH();	
	if (!$user_auth -> is_user()) {
			clear_cache();
			die("Доступ запрещен");
	}	
	$main_db = new db();
	
	$type    		 = @Convert_quotas($_GET['type']);
	if (is_numeric($_GET['id_mm'])) {
		$id_mm      	 = @intval($_GET['id_mm']); 
	} else {
		$id_mm      	 = "'" .@Convert_quotas($_GET['id_mm']). "'"; 
	}
	$id_mm_fr   	 = @intval($_GET['id_mm_fr']); 
	$id_mm_fr_d 	 = @intval($_GET['id_mm_fr_d']);	
	$page_ 	 		 = @intval($_GET['page']);  
	$limit 			 = @intval($_GET['rows']);  
	$sidx 			 = @Convert_quotas($_GET['sidx']);                   
	$sord 			 = @Convert_quotas($_GET['sord']); 
	
	if (isset($_GET['pageid'])) {	
		$pageid			 = @Convert_quotas($_GET['pageid']); 
	} else {
		$pageid			 = "";
	}
	if (isset($_GET['idx'])) {
		$idx			 = Convert_quotas($_GET['idx']);
	} else {
		$idx			 =  "";
	}
	if (isset($_GET['Master_Table_ID'])) {
		$Master_Table_ID			 = Convert_quotas($_GET['Master_Table_ID']);
	} else {
		$Master_Table_ID			 =  "";
	}	
	
	// Переменные для инициализации
	$arr_field      = array();
    $arr_field_type = array();
	$count			= 0;
	$i 				= 0;	
	$m 				= 0;	
	$k              = 0;
    $str_dt         = "";
	$qWhere			= "";
	if(!$sidx) {
			$sidx = 1;
		} else {
			$sidx = trim_fieldname($sidx);
	}
	if(isset($_GET['n_level'])) $level = intval($_GET['n_level']);
	if(isset($_GET['nodeid']))  $node  = intval($_GET['nodeid']);
	
	// Переделываем запрос для детального грида
	if (($type == "GRID_FORM_DETAIL") or ($type == "TREE_GRID_FORM_DETAIL")) {		
			$s_d_m_Where     = " AND ".$Master_Table_ID." = ".$id_mm;
			$id_mm_fr = $id_mm_fr_d;
	} else 	$s_d_m_Where     = "";

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
       ta.html_txt align_txt, tf.xsl_file_in, t.field_type
	   from ".DB_USER_NAME.".wb_mm_form tf
	   left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form
	   left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
	   where tf.id_wb_mm_form = ".$id_mm_fr." order by t.num");
		
    while ($main_db -> sql_fetch($query)) {
				if ($str_dt=="") {
                    $owner      = $main_db -> sql_result($query, "OWNER",false);
					$table_name = $main_db -> sql_result($query, "OBJECT_NAME",false);
					$str_dt = "select * from (Select max_count_number_99999, ".$main_db -> sql_result($query, "F_NAME",false);
					$str_dt_f = ",rownum r_num_page from (Select rownum r_num,count(*) over (order by 1) as max_count_number_99999, t.* from ".$owner.".".$table_name." t  WHERE 1=1 SqWhere ".$main_db -> sql_result($query, "FORM_WHERE",false)." ".$s_d_m_Where." ";					
                    $str_leafs = "Select t.id_".$table_name." ID from ".$owner.".".$table_name." t left join ".$owner.".".$table_name." t1 on t1.id_parent = t.id_".$table_name." where t1.id_".$table_name." is null";
				} else {					
					 $str_dt = $str_dt.", ".$main_db -> sql_result($query, "F_NAME",false);
                }
				$i++;			
                $arr_field[$i]      = $main_db -> sql_result($query, "FIELD_NAME",false);
                $arr_field_type[$i] = trim($main_db -> sql_result($query, "FIELD_TYPE",false));			
    }     	

			// Разбираем переменные для поиска			
			if (@$_GET['_search'] != "false") foreach($_GET as $k=>$v) {
				// Мы можем передать данные в формате <тип поиска>><данные>
				$s_opts = explode(">",$v);
					if (isset($s_opts[1])) {
					$v = iconv(HTML_ENCODING,LOCAL_ENCODING,trim($s_opts[1])); // кодировочку меняем
						if (array_search(trim_fieldname($k), $arr_field, true)) {
							$type_field = $arr_field_type[array_search(trim_fieldname($k), $arr_field)];						
							if ($v != "" ) if (( $type_field == "DT" ) or ( $type_field == "D" )) {
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
				// Если у нас выставлена постраничная прокрутка то грузим постранично
				$str_dt = $str_dt.$str_dt_f." order by ".$sidx." ".$sord.")) where r_num_page between ".$start." and ".$stop;
			} 
			
			end_session();
			
			$query_dt = $main_db -> sql_execute($str_dt);					
            while ($main_db -> sql_fetch($query_dt)) {
					$k = $k + 1;
					$id_ = "ID_".$table_name;					
					if (!array_search($id_, $arr_field)) { $dt->rows[$m]['id'] = $k; } else $dt->rows[$m]['id'] = $main_db -> sql_result($query_dt, $id_);					
					$dt_cell = array();
					$r = 0;				
                    foreach ($arr_field as $key=>$line) {
                        switch ($arr_field_type[$key]) {
							case 'L':
								$td_val = $main_db -> sql_result($query_dt, $arr_field[$key]);								
								$td_val = $td_val -> load();
								$td_val = $td_val;								
								break;
							default:
								$td_val = $main_db -> sql_result($query_dt, $arr_field[$key]);
								if ($arr_field[$key]=='LEV')       $td_level_val     = $td_val-1;
							    if ($arr_field[$key]=='ID_PARENT') $td_id_parent_val = $td_val; 							
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
						$r = $r + 1;						
						// Определяем родителя
						if ($td_id_parent_val == '') {$parent = NULL;} else $parent = $td_id_parent_val;
						$dt_cell[$r] = $parent;
						$r = $r + 1;
						
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
			echo json_encode($dt);			
$main_db -> __destruct();
?>