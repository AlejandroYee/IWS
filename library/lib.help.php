<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
class HELP extends DATA_FORM {
		//--------------------------------------------------------------------------------------------------------------------------------------------
		// Формирование индекса справки
		//--------------------------------------------------------------------------------------------------------------------------------------------
		function get_help_index($parent_id = 0,$first_parent = 0) {	
			$res = "";
				// Смотрим дальше:				
				foreach ($this -> main_menu as $key)
					if ($key['PARENT'] == $parent_id) {
						if ((isset($key['MENU']) and ( $key['MENU'] > 0)) and ($key['PARENT'] == 0)) {
								if (is_file(iconv(HTML_ENCODING,LOCAL_ENCODING,ENGINE_ROOT. DIRECTORY_SEPARATOR .HELP_FOLDER. DIRECTORY_SEPARATOR .$key['ID']."-".$key['NAME'].".html"))) {
									// это корневой индекс	(папки)
									$res.= "\n</div>\n
											<h3>
												<b>".$key['NAME']."</b>
											</h3>\n";
									$res.= "<div id='".$key['ID']."'>\n";
									$first_parent = $key['ID'];
									$content =  str_replace("\n","<br>",file_get_contents(iconv(HTML_ENCODING,LOCAL_ENCODING,ENGINE_ROOT. DIRECTORY_SEPARATOR .HELP_FOLDER. DIRECTORY_SEPARATOR .$key['ID']."-".$key['NAME'].".html")));
									$content =  str_replace("%HELP_DIR%",ENGINE_HTTP. DIRECTORY_SEPARATOR .HELP_FOLDER."/",$content);	
									$res .= $content;
								} else if ($key['ID'] == 100000000000000) {
									$res.= "<h3><b>Основные принципы работы с системой</b></h3>\n<div id='mine'>\n";
									$content =  str_replace("\n","<br>",file_get_contents(iconv(HTML_ENCODING,LOCAL_ENCODING,ENGINE_ROOT. DIRECTORY_SEPARATOR .HELP_FOLDER."/-0-Основные принципы работы.html")));
									$content =  str_replace("%HELP_DIR%",ENGINE_HTTP. DIRECTORY_SEPARATOR .HELP_FOLDER."/",$content);	
									$first_parent = 'mine';
									$res .= $content;	
								}
							} else {
								// это разделы
								if (isset($key['NAME']) and is_file(iconv(HTML_ENCODING,LOCAL_ENCODING,ENGINE_ROOT. DIRECTORY_SEPARATOR .HELP_FOLDER. DIRECTORY_SEPARATOR .$key['ID']."-".$key['NAME'].".html"))) {
									$query_dwl = $this-> db_conn -> sql_execute("select listagg(t.name, '<span class=\"ui-icon ui-icon-carat-1-e\" style=\"display:inline-block;border:0px;height: 12px;\"></span>') within group(order by level desc) as name 
										from wb_main_menu t where t.id_parent is not null start with t.id_wb_main_menu = ".$key['ID']." connect by prior t.id_parent = t.id_wb_main_menu");														
									while ($this-> db_conn ->sql_fetch($query_dwl)) $name = $this-> db_conn ->sql_result($query_dwl, "NAME");
										if (empty($name)) $name = $key['NAME'];
										$res.= "<p>
												<h3 class='ui-tabs ui-widget ui-widget-header ui-corner-all'>
													".$name."
													<a href='#' onclick='$(\"#".$first_parent."\").scrollTop(0);' style='float: right;'><span class='ui-icon ui-icon-arrowthickstop-1-n'></span></a>
												</h3>
												</p>\n";
										$content = str_replace("\n","<br>",file_get_contents(iconv(HTML_ENCODING,LOCAL_ENCODING,ENGINE_ROOT. DIRECTORY_SEPARATOR .HELP_FOLDER. DIRECTORY_SEPARATOR .$key['ID']."-".$key['NAME'].".html")));
										$content = str_replace("%HELP_DIR%",ENGINE_HTTP. DIRECTORY_SEPARATOR .HELP_FOLDER."/",$content);	
										$res .= $content;
									
								}
						}
					if (isset($key['MENU']) and ( $key['MENU'] > 0)) $res .= $this -> get_help_index($key['ID'],$first_parent);						
				}
		return  $res;	
		}	
		
		static function get_about() {
			return "Помощь и подсистема справки";
		}
}