<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Определение дополнительных элементов
//--------------------------------------------------------------------------------------------------------------------------------------------
header("Content-Type: text/html; charset=".strtolower(HTML_ENCODING));
header("Cache-Control: private,no-cache,no-store");
header("Pragma: no-cache");
//--------------------------------------------------------------------------------------------------------------------------------------------
// Подключаем необходимые модули
//--------------------------------------------------------------------------------------------------------------------------------------------
require_once("lib.func.php");
BasicFunctions::requre_script_file("db.".DB.".php");

//--------------------------------------------------------------------------------------------------------------------------------------------
// Основной класс
//--------------------------------------------------------------------------------------------------------------------------------------------	
class DATA_FORM {
var $db_conn, $Param_res,  $data_res, $IsInputform, $grid_main_name, $main_menu = array();   
public $id_mm_fr, $id_mm_fr_d, $id_mm, $pageid;

	 // Создание связи с ДБ
	function __construct() { 
		
		// Временный оффлайн системы с сообщением
		if (defined("OFFINE_START_DATE") and defined("OFFINE_END_DATE") and (time() >= OFFINE_START_DATE) and (time() <= OFFINE_END_DATE)) {
			die(BasicFunctions::Create_logon_window(true)); // факт офлайна включается заглушка
		}
		
		// Запрос авторизации:
		$user_auth = new AUTH();
		if (!$user_auth -> is_user()) {
                        BasicFunctions::to_log("LIB: Session time expired!");
			die(BasicFunctions::Create_logon_window());
		}
		 // Соединение с ДБ
		$this -> db_conn = new DB();
		
		// Для использования кеширования, нужно сразу загрузить меню
		if (empty($this -> main_menu)) {
                        $this -> set_tree_main_menu_from_db();
                }        
	}
	
	 // Метод завершения
	function __destruct() {		
	    // Завершаем все соединения с ДБ
		if (is_object($this->db_conn)) {
				$this->db_conn->__destruct();
		}                
	}
	
	// Короткая форма для сокращения текста обращений к ДБ
	function return_sql($query,$param)	{
			return $this ->db_conn ->sql_result($query,$param);
	}
		
	// Оставлено для совместимости с более старыми версиями
	//------------------------------------------------------------------------------------------------------------------------------------------------	
	function execute_pl_sql_block() {        
        $query = $this->db_conn->sql_execute("select t.action_sql from ".DB_USER_NAME.".wb_mm_form t where t.id_wb_mm_form = ".$this->id_mm_fr);
		while ($this-> db_conn-> sql_fetch($query)) {
                $str_block = $this -> return_sql($query, "ACTION_SQL");
                if (!empty($str_block)) {
                        $this->db_conn->sql_execute($str_block); 			
                  }
        }       
    }
	 
	// Список форм для вывода, и типонизация и подключение компонентов
	//------------------------------------------------------------------------------------------------------------------------------------------------
	function Create_Table_Space($id, $pid, $pagetab) {			
		$IsInputform 		= 0; // флаг наличия входящих данных	
		$is_wizard_form  	= 0; // Флаг формы визарда
		$count_detail_forms     = 0;
                $form_name_user         = "";
		$this-> id_mm = $id;
		$this-> pid_mm  = $pid;		
		$this-> pageid = $pagetab;
				
			$query = $this->db_conn->sql_execute("Select count(*) over() c_count,  mm.name as form_name_usrv, mf.form_where, mf.object_name, mf.height_rate as  height_rate,mf.auto_update, mf.id_wb_mm_form id,mf.action_sql,
					nvl(mf.name, mm.name) name, ft.name type, mf.xsl_file_in, max(case when ft.name like '%_DETAIL' then mf.id_wb_mm_form else null end) over(order by mm.id_wb_main_menu) id_d
					from ".DB_USER_NAME.".wb_main_menu mm inner join ".DB_USER_NAME.".wb_mm_form mf  on mf.id_wb_main_menu = mm.id_wb_main_menu left join ".DB_USER_NAME.".wb_form_type ft on ft.id_wb_form_type = mf.id_wb_form_type
					where mm.id_wb_main_menu = ".$id." and exists (Select 1 from ".DB_USER_NAME.".wb_mm_role mr inner join ".DB_USER_NAME.".wb_role_user ru on ru.id_wb_role = mr.id_wb_role and ru.id_wb_user = ".DB_USER_NAME.".wb.get_wb_user_id
					where mr.id_wb_main_menu   = mm.id_wb_main_menu and mr.id_wb_access_type = 1) order by mf.num");
					
            while ($this-> db_conn-> sql_fetch($query)) {
			
				// Заполняем переменные для работы								
				$this-> id_mm_fr = $this -> return_sql($query, "ID");
				$this-> id_mm_fr_d  = $this -> return_sql($query, "ID_D");
                                $form_name_user = $this -> return_sql($query, "form_name_usrv");
				$object_name = strtolower($this -> return_sql($query, "TYPE")."_".abs($this -> return_sql($query, "ID"))."_".$this ->pageid);	
                                
				// Начинаем создавать формы				
				switch ($this -> return_sql($query, "TYPE")) {
                                case "INPUT_FORM": 
						if ($is_wizard_form == 0 ) {
							require_once(ENGINE_ROOT."/library/lib.input.php");
							$input = new INPUT($this -> id_mm_fr, $this -> id_mm, $this -> pageid);
							$this -> Param_res .= $input -> Create_input_form($this -> return_sql($query, "C_COUNT"));
						
							if (!empty($this -> Param_res)) {								
									// Флаг на загрузку данных
									$this -> data_res .= "<script type=\"text/javascript\"> var data_".$this -> pageid."_loaded = 0;  </script>";
									$IsInputform = 1; 
							}
						}
					break;				
					
					case "REPORT_FORM": break;	// not uset, but for finerep				
					
					// Формальная форма для мастера
					case "WIZARD_FORM":
						// Мы будем сами обрабатывать инпуты в отдельной функции, для этого остальные инпуты блокируем
						$is_wizard_form = 1;
						require_once(ENGINE_ROOT."/library/lib.input.php");
						$this -> data_res .= "<script type=\"text/javascript\"> var data_".$this -> pageid."_loaded = 0;  </script>";
						$input = new INPUT($this -> id_mm_fr, $this -> id_mm, $this -> pageid);
						$this -> Param_res .= $input -> Creare_wizard_from();
							if (!empty($this -> Param_res)) {								
									// Флаг на загрузку данных
									$this -> data_res .= "<script type=\"text/javascript\"> var data_".$this -> pageid."_loaded = 0;  </script>";
									$IsInputform = 1; 
							}
					break;
					
					// Графики
					case "CHARTS_FORM":
							$this->grid_main_name = $object_name;
							require_once(ENGINE_ROOT."/library/lib.charts.php");
							$chart = new CHART($this -> id_mm_fr, $this -> pageid,$this -> return_sql($query, "AUTO_UPDATE"));
						    $this -> data_res .= $chart -> create_chart();
					break;
					
					// Форма прикрепления файла к строке грида
					case "INPUT_FORM_UPLOAD":
						if (isset($grid) and isset($last_grid_name)) {
							$this -> data_res .= $grid -> append_file_to_grid($last_grid_name, $this->id_mm_fr);
						}
					break;
					
					// Пользовательские кнопки для грида
					case "BUTTON_CUSTOM":
						if (isset($grid)) {
							$this -> data_res .= $grid -> User_button( $object_name, $last_grid_name,$this -> return_sql($query, "ID"), $this -> return_sql($query, "FORM_WHERE"),  $this -> return_sql($query, "NAME"));
						}
					break;					
					
					// Вызов для выполения PL/SQL скрипта
					case "PL_SQL_FORM": 
						$this -> data_res .= $this -> execute_pl_sql_block();
						$this -> data_res .= "	<script type=\"text/javascript\">
										 $('#".$this->pageid."').append('<div style=\"height: 100%;width: 100%;vertical-align: middle;\"><h2>Скрипт выполнен!/h2></div>');
									</script>";
					break;	
					
					// Форма выгрузки файла
					case "DOWNLOAD_FORM":
					$query_dwl = $this-> db_conn -> sql_execute("select tf.xsl_file_in, tf.name, tf.id_wb_main_menu from ".DB_USER_NAME.".wb_mm_form tf  where tf.id_wb_mm_form = ".$this->id_mm_fr."  and tf.xsl_file_in is not null");					
							while ($this-> db_conn ->sql_fetch($query_dwl)) {								
								$this -> data_res .=  "<button id='".$object_name."' >Скачать: \"".$this-> db_conn ->sql_result($query_dwl, "NAME")."\"</button>
								<script type=\"text/javascript\">
								$('#".$object_name."').button({icons: { primary: 'ui-icon-disk' }})
												   .click(function( event ) {
														$.fileDownload('".UPLOAD_DIR . "/" . $this-> db_conn -> sql_result($query_dwl, "XSL_FILE_IN")."',
														{ 
															failCallback: function (html, url) { return; },
															encodeHTMLEntities: true,
															httpMethod:'GET',
														});	
													});
								</script>";								
							}	
					break;
					
					// форма для деталей
					case "GRID_FORM_DETAIL": 
						require_once(ENGINE_ROOT."/library/lib.jqgrid.php");						
						// Если детальный грид первый или один то перед ним ставим ресизер
						if ($count_detail_forms == 0) $this -> data_res .= "<script type=\"text/javascript\"> $(function() { $('#gbox_".$last_grid_name."').parent().addClass('has_resize_control'); set_resizers();}); </script>";	
						
						// Создаем детальный грид
						$grid = new JQGRID($this -> id_mm_fr, $this ->id_mm_fr_d, $this -> id_mm, $this -> pageid, $this -> grid_main_name);
						$this -> data_res .= BasicFunctions::regex_javascript( $grid -> greate_grid($this -> return_sql($query, "TYPE"),
																					"local",
																					$object_name,$this -> return_sql($query, "XSL_FILE_IN"),
																					$this -> return_sql($query, "HEIGHT_RATE"),
																					$this -> return_sql($query, "ID"),
																					$this -> return_sql($query, "AUTO_UPDATE")));									
						$last_grid_name = $object_name;
						$last_grid_type = $this -> return_sql($query, "TYPE");
						$count_detail_forms++;
					break;
					
					case "TREE_GRID_FORM_DETAIL": 
						require_once(ENGINE_ROOT."/library/lib.jqgrid.php");						
						// Если детальный грид первый или один то перед ним ставим ресизер
						if ($count_detail_forms == 0) $this -> data_res .= "<script type=\"text/javascript\"> $(function() { $('#gbox_".$last_grid_name."').parent().addClass('has_resize_control'); set_resizers();}); </script>";	
						
						// Создаем детальный грид
						$grid = new JQGRID($this -> id_mm_fr, $this ->id_mm_fr_d, $this -> id_mm, $this -> pageid, $this -> grid_main_name);
						$this -> data_res .= BasicFunctions::regex_javascript($grid -> greate_grid($this -> return_sql($query, "TYPE"),
																"local",
																$object_name,
																$this -> return_sql($query, "XSL_FILE_IN"),
																$this -> return_sql($query, "HEIGHT_RATE"),
																$this -> return_sql($query, "ID"),
																$this -> return_sql($query, "AUTO_UPDATE")));									
						$last_grid_name = $object_name;
						$last_grid_type = $this -> return_sql($query, "TYPE");
						$count_detail_forms++;
					break;		
					
					// по сути у нас только три формы уникальные, остальные похоже но с разными параметрами
					// в итоге все что не подходит по уникальные пускаем по умолчанию.
					default:					
					require_once(ENGINE_ROOT."/library/lib.jqgrid.php");
					$grid = new JQGRID($this -> id_mm_fr, $this ->id_mm_fr_d, $this -> id_mm, $this ->pageid, $this -> grid_main_name);
					
					// Фикс для старой формы загрузки
					$heigth_rate = $this -> return_sql($query, "HEIGHT_RATE");	
					if (($this -> return_sql($query, "TYPE") == "GRID_FORM_UPLOAD") and ($this -> return_sql($query, "C_COUNT") == 2)) $heigth_rate = 100;
					
					// Создаем гриды
						if (empty($IsInputform)) {
								$this -> data_res .= BasicFunctions::regex_javascript($grid -> greate_grid($this -> return_sql($query, "TYPE"),"json", $object_name,$this -> return_sql($query, "XSL_FILE_IN"),$heigth_rate,$this -> return_sql($query, "ID"),$this -> return_sql($query, "AUTO_UPDATE")));								
							} else {
								$this -> data_res .= BasicFunctions::regex_javascript($grid -> greate_grid($this -> return_sql($query, "TYPE"),"local", $object_name,$this -> return_sql($query, "XSL_FILE_IN"),$heigth_rate,$this -> return_sql($query, "ID"),$this -> return_sql($query, "AUTO_UPDATE")));
						}	
						
					// Сохраняем предыдущий обьект
					$this -> grid_main_name = $object_name;
					$last_grid_name = $object_name;
					$last_grid_type = $this -> return_sql($query, "TYPE");					
				}			
            }
                // Здесь мы создаем финальную обвязку:
                if (isset($chart)) $this -> data_res .= BasicFunctions::regex_javascript($chart -> set_script());
                if ($count_detail_forms > 1)  $this -> data_res .= BasicFunctions::regex_javascript($grid -> create_detail_tab_script());

                // Флаг что входные данные загружены
                if ($IsInputform == 0 ) $this -> data_res .= "<script type=\"text/javascript\"> var data_".$this -> pageid."_loaded = 1;  </script>";


                // Если у пользователя отсутствуют привелегии:
                if (empty($this->id_mm_fr)) {
                    $this -> data_res = "<h3>У вас недостаточно привелегий!<br>Перезагрузите страницу полностью!</h3>";
                    BasicFunctions::to_log("LIB: Load page: '".$form_name_user."' erroor! No privilegies set.");
                } else {
                    BasicFunctions::to_log("LIB: Load page: '".$form_name_user."' done!");
                }
		// Закрываем сейсии
		if (isset($chart)) $chart -> __destruct();
		if (isset($grid))  $grid -> __destruct();
		}
		
		// Загрузка содержимого меню в массив (для сокращения обращений к меню)
		// Сделано для того чтобы в последствии можно было обращаться к массиву неперезапрашивая информацию с базы
		// Обычно соединение с базой очень меделенное, плюс кеширование с помощью кукисов, лайв гдето час
		function set_tree_main_menu_from_db() {		
			// Проверяем если у нас закешированный кукис:
			$load_data = BasicFunctions::load_from_cache("main_menu",true);
			if ($load_data) {
					$this -> main_menu = $load_data;
					return true;
			}
			$last_num = 99999999999999;			
				$query = $this-> db_conn -> sql_execute("select * from (select t.id_wb_main_menu, nvl(t.id_parent, 0) id_parent, t.name, t.num, (select count(name) from ".DB_USER_NAME.".wb_main_menu g where nvl(g.id_parent, 0) = t.id_wb_main_menu) as menu
						from ".DB_USER_NAME.".wb_main_menu t where used = 1 and (".DB_USER_NAME.".wb.get_access_main_menu(t.id_wb_main_menu) = 'enable' or t.name is null)) g order by g.id_parent, g.num ");
				// Формируем дополнительное меню пользователя:
				$this -> main_menu[$last_num + 1]['ID'] = $last_num + 1;
				
				$this -> main_menu[$last_num + 1]['NAME'] = "<b style='padding:0 0 0 25px'>".$this -> db_conn -> get_realname()."</b>";
				$this -> main_menu[$last_num + 1]['ICON'] = "<span class='ui-icon ui-icon-person'></span>";
				
				$this -> main_menu[$last_num + 1]['MENU'] = 1;
				$this -> main_menu[$last_num + 1]['PARENT'] = 0;
				// Формируем суб меню пользователя:
				$this -> main_menu[$last_num + 2]['ID'] = $last_num + 2;
				$this -> main_menu[$last_num + 2]['NAME'] = "Параметры";
				$this -> main_menu[$last_num + 2]['ICON'] = "<span class='ui-icon ui-icon-wrench'></span>";
				$this -> main_menu[$last_num + 2]['ACTION'] = "$('#param').dialog( 'open' );";
				$this -> main_menu[$last_num + 2]['PARENT'] = $last_num + 1;
				$this -> main_menu[$last_num + 3]['ID'] = $last_num + 3;
				$this -> main_menu[$last_num + 3]['NAME'] = "Информация";
				$this -> main_menu[$last_num + 3]['ICON'] = "<span class='ui-icon ui-icon-help'></span>";
				$this -> main_menu[$last_num + 3]['ACTION'] = "$('#about').dialog( 'open' );";
				$this -> main_menu[$last_num + 3]['PARENT'] = $last_num + 1;
				
			// каждый шаг это меню. если парент 0 то тогда это новый подпункт меню
			while ($this-> db_conn ->sql_fetch($query)) {
				// Хук для перевода меню в меню пользователя:
				if (intval($this -> return_sql($query, "NUM")) == 999 ) {
						$this -> main_menu[$last_num + 4]['ID'] = $last_num + 4;
						$this -> main_menu[$last_num + 4]['PARENT'] = $last_num + 1;
						$this -> main_menu[$this -> return_sql($query, "ID_WB_MAIN_MENU")]['PARENT'] = $last_num + 1;
						$this -> main_menu[$this -> return_sql($query, "ID_WB_MAIN_MENU")]['ICON'] = "<span class='ui-icon ui-icon-note'></span>";	
						// Возможность посмотреть лог программы:
						if (defined("HAS_DEBUG_FILE") and (HAS_DEBUG_FILE != "" )) {
							$this -> main_menu[$last_num + 5]['ID'] = $last_num + 5;
							$this -> main_menu[$last_num + 5]['NAME'] = "Посмотреть лог программы...";
							$this -> main_menu[$last_num + 5]['ICON'] = "<span class='ui-icon ui-icon-script'></span>";
							$this -> main_menu[$last_num + 5]['ACTION'] = "$(function() {SetTab('Просмотр лог программы','".ENGINE_HTTP."/ajax.tab.php?action=get_debug','false');});";
							$this -> main_menu[$last_num + 5]['PARENT'] = $last_num + 1;
						}
					} else {
						$this -> main_menu[$this -> return_sql($query, "ID_WB_MAIN_MENU")]['PARENT'] = $this -> return_sql($query, "ID_PARENT");
				}
				$this -> main_menu[$this -> return_sql($query, "ID_WB_MAIN_MENU")]['ID'] = intval($this -> return_sql($query, "ID_WB_MAIN_MENU"));
				$this -> main_menu[$this -> return_sql($query, "ID_WB_MAIN_MENU")]['NAME'] = $this -> return_sql($query, "NAME");
				$this -> main_menu[$this -> return_sql($query, "ID_WB_MAIN_MENU")]['MENU'] = $this -> return_sql($query, "MENU");	
			}	
			
			if ($this-> db_conn -> get_param_view("cache_enable") != "checked") {
				$this -> main_menu[$last_num + 6]['ID'] = $last_num + 6;
				$this -> main_menu[$last_num + 6]['NAME'] = "Отчистить кеш...";
				$this -> main_menu[$last_num + 6]['ICON'] = "<span class='ui-icon ui-icon-trash'></span>";
				$this -> main_menu[$last_num + 6]['ACTION'] = "$(function() { $(location).prop('href','".ENGINE_HTTP."/ajax.saveparams.php?act=cache'); });";
				$this -> main_menu[$last_num + 6]['PARENT'] = $last_num + 1;
			}
				// Разделитель:
				$this -> main_menu[$last_num + 7]['ID'] = $last_num + 7;
				$this -> main_menu[$last_num + 7]['PARENT'] = $last_num + 1;
				// Выход
				$this -> main_menu[$last_num + 8]['ID'] = $last_num + 8;
				$this -> main_menu[$last_num + 8]['NAME'] = "Выход";
				$this -> main_menu[$last_num + 8]['ICON'] = "<span class='ui-icon ui-icon-power'></span>";
				$this -> main_menu[$last_num + 8]['ACTION'] = "$(function() { $(location).prop('href','".ENGINE_HTTP."/ajax.saveparams.php?act=logout'); });";
				$this -> main_menu[$last_num + 8]['PARENT'] = $last_num + 1;
				
				// Кешируем меню
				BasicFunctions::save_to_cache("main_menu",$this -> main_menu);
		}

		static function get_about() {
			return "Основной модуль системы";
		}
	
		// Формирование меню ( $parent_id номер дочернего меню для показа, $sametab ади вкладки которую показывать, если пусто то создать новую)
		//--------------------------------------------------------------------------------------------------------------------------------------------
		function get_tree_main_menu($parent_id = 0, $sametab = 'false') {
			$res = "";
			$action = "";
			$parenttab = "";			
				// Смотрим дальше:				
				foreach ($this -> main_menu as $key)
					if ($key['PARENT'] == $parent_id) {		
						if ((isset($key['MENU']) and ( $key['MENU'] > 0)) or (!isset($key['NAME']))) {
								$icon = "<span class='ui-icon ui-icon-folder-collapsed'></span>";							
								$action ="";														
							} else {
								$icon = "<span class='ui-icon ui-icon-document-b'></span>";
								if ($sametab != 'false') {
									$parenttab = "parent.";
								}
								$action =  $parenttab."SetTab('".$key['NAME']."','".ENGINE_HTTP."/ajax.tab.php?id=".$key['ID']."&pid=".$key['PARENT']."','".$sametab."') "; 
						}
						if ($parent_id == 0)  $icon = ""; 	
						if (isset($key['ICON']) and !empty($key['ICON'])) $icon = $key['ICON'];
						if (isset($key['ACTION']) and !empty($key['ACTION'])) $action = $key['ACTION'];
						
						// пусто для разделителя
						if (!isset($key['NAME'])) {
								$res .= "<li>";			
							} else {
							if ($parent_id == 0) {
								$res .= "<li><a onclick=\"".$action."\" class='ui-button ui-widget ui-menubar-link ui-state-default ui-button-text-icon-secondary'>".$icon.$key['NAME']."</a>";	
							} else {
								$res .= "<li><a onclick=\"".$action."\" >".$icon.$key['NAME']."</a>";	
							}
						}
						if (isset($key['MENU']) and ( $key['MENU'] > 0)) $res .= $this -> get_tree_main_menu($key['ID'], $sametab);
						if ($parent_id <> 0) $res .= "</li>\n";	
				}				
			if ($parent_id <> 0)  {
				return  "\n<ul>" . $res . "</ul>";
			} else {
				return  $res; 
			}				
		}	
}