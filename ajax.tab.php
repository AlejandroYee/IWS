<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Файл содержимого вкладок и управления ими
//--------------------------------------------------------------------------------------------------------------------------------------------
require_once("library/lib.func.php");
requre_script_file("lib.requred.php"); 
requre_script_file("lib.help.php");	

// Инициализация
$DataGrid = new Data_form();
$main_db = new Db();
$s_help = new Help();

// Проверяем переменные на инжекты и приводим в нужный формат
if (isset($_GET['id'])) {
	$id=intval($_GET['id']);
	$pid=intval($_GET['pid']);	
} else {
	$pid = 0;
	$id  = 0;
}

$tabid=Convert_quotas($_GET['tabid']);	

if (isset($_GET['action'])) {	
		$action = Convert_quotas($_GET['action']);
	} else {
		$action = "";
}

// Формирование шапки и меню навигации $Navigation_res
//--------------------------------------------------------------------------------------------------------------------------------------------
$query = $main_db->sql_execute("Select level lev, t.id_wb_main_menu, nvl(t.id_parent, 0) id_parent, t.name from ".DB_USER_NAME.".wb_main_menu t start with t.id_wb_main_menu = $id connect by prior t.id_parent = t.id_wb_main_menu order by lev desc");
$Navigation_res = "<table style='float: left;'><tr><td>";
while ($main_db->sql_fetch($query)) { 				
	if ($main_db->sql_result($query, "ID_PARENT") <> 0 ) {	
				$Navigation_res.= "<label class='ui-widget ui-widget-content' style='border:0px;background:transparent;'>".trim($main_db->sql_result($query, "NAME"))."</label></td><td>";
				if ($main_db->sql_result($query, "LEV") <> 1 ) $Navigation_res.= "<span class='ui-icon ui-icon-carat-1-e'></span></td><td>";
		} else {
				$Navigation_res.= "<ul id='nav_menu".$tabid."' class='navigate_submenu' style='text-align:left;padding:0px;margin:-1px;' >
										<li>
											<a><span class='ui-icon ui-icon-folder-collapsed'></span>".$main_db->sql_result($query, "NAME")."&nbsp;&nbsp;&nbsp;&nbsp;</a>
										".str_replace("<ul></ul>","",$DataGrid -> get_tree_main_menu($main_db->sql_result($query, "ID_WB_MAIN_MENU"),$tabid))."
									</ul>
									</td><td>";
				$text_width = $main_db->sql_result($query, "NAME"); // Для автоподстройки длины
		}			
}
$Navigation_res .= "</td></tr></table>";

// Возможно что это специфичная вкладка, смотрим:
//--------------------------------------------------------------------------------------------------------------------------------------------	
switch ($action) {
	// В случае если у нас страничка помощи
	case "help":			
		$Navigation_res = "<h2 style='float: left;margin:0 5px 0 0;'>Добро пожаловать в справочную систему, доступные разделы:</h2>";
		$DataGrid->data_res = "
				<div class='help_content' style='padding:-5px;margin:1px;'>".
					$s_help -> get_help_index()
					."</div>
				</div>
				<script type='text/javascript'>		
				// Создание справочной информации
						$('.help_content').accordion({
									collapsible: true,
									heightStyle: 'fill',
									active: false
						});	
				</script>
				";
	break;
	
	case "get_debug":			
		$Navigation_res = "<h2 style='float: left;margin:0 5px 0 0;'>Лог файл программы:</h2>";
		$DataGrid->data_res = "<div class='log_container ui-widget-content'>
				<textarea name='log_".$tabid."' style='font-family: monospace;'>";
				$log = explode("\n",file_get_contents(ENGINE_ROOT."/".HAS_DEBUG_FILE));
				$DataGrid -> data_res .= implode("\n",$log);
		$DataGrid->data_res .= "</textarea>
				<div id='log_".$tabid."' style='font-family: monospace;'></div>
				</div>
				<script type='text/javascript'>
						var elem = $('textarea[name=\"log_".$tabid."\"]');				
						var editor = ace.edit('log_".$tabid."');						
						editor.getSession().setMode('ace/mode/log');
						editor.getSession().setValue(elem.val());
							editor.getSession().on('change', function(){
							  elem.val(editor.getSession().getValue());
							});
						if ($.browser.msie) {		
							$('.log_container').height($(document).height() - $('.main_menu').height() - 150);
							$('#log_".$tabid."').width($(document).width() - 28).height($(document).height() - $('.main_menu').height() - 150);
						} else {
							$('.log_container').height($(document).height() - $('.main_menu').height() - 90);
							$('#log_".$tabid."').width($(document).width() - 28).height($(document).height() - $('.main_menu').height() - 90);
						}
						elem.hide();
						editor.setReadOnly(true);
						editor.scrollToRow(editor.session.getLength()+1);
				</script>
				";
	break;
	// Для всех остальных случаем выводим стандартную обвязку
	default:
		$DataGrid -> Create_Table_Space($id,$pid,$tabid);
	break;
}
?>
<div class="navigation_header">
		<?=$Navigation_res?>
		<button id="update_page-<?=$tabid?>" s_id="<?=$id?>" act="<?=$action?>" s_pid="<?=$pid?>" tabid="<?=$tabid?>" class="reload_button" style="float: right;" title="Полностью перезагрузить все содержимое вкладки">Перезагрузить вкладку</button>
		<?=$DataGrid->Param_res?>
</div>
<div class="tab_main_content">
	<?=$DataGrid->data_res?>
</div>
<script type='text/javascript'>	
					// Дополнительно меню во вкладке
					$(".navigate_submenu").menu();	
					
					// Кнопка перезагрузки фкладки
					$(".reload_button").button({
						icons: {
							primary: "ui-icon-refresh"
						}}).click(function() {
							SetTab('','<?=ENGINE_HTTP?>/ajax.tab.php?action=' + $(this).attr('act') + '&id=' + $(this).attr('s_id') + '&pid=' + $(this).attr('s_pid'),$(this).attr('tabid'));	
					});
</script>					
<?php
$main_db -> __destruct();
$DataGrid -> __destruct();
?>