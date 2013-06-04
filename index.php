<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
require_once("library/lib.func.php");
requre_script_file("lib.requred.php"); 

$main_db = new db();
// Смотрим разрешено ли кеширование
if ($main_db->get_param_view("cache_enable") == "checked") {
	$_SESSION["ENABLED_CACHE"] = false;
	to_log("LIB: User disabled cache!");
}

//Подключаем формы
$DataGrid = new Data_form();

if (isset($_SERVER['HTTP_USER_AGENT']) &&  (strrpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) { 
?>
<html class="no-js" lang="en-US">
<?
} else {
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html class="no-js" lang="en-US">
<?
}
?>                                                                                                                                                                                   
			<head>
				<meta charset="<?php echo strtolower(HTML_ENCODING); ?>">
				<title><?=$main_db -> get_settings_val('ROOT_CONFIG_NAME')?></title>
				<meta http-equiv="Content-Type" content="text/html; charset=<?php echo strtolower(HTML_ENCODING); ?>"/>
				<meta http-equiv="Cache-Control" content="no-cache">
				<meta http-equiv="Pragma" content="no-cache" >				
				<meta http-equiv="expires" content="0">						
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
				<link rel="icon" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
				<link rel="Bookmark" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
				<link rel="shortcut icon" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
				<?php				
				if (!is_dir(ENGINE_ROOT.DIRECTORY_SEPARATOR.THEMES_DIR)) die ("Неуказана директория тем в конфигурации!");	
				if (!is_dir(ENGINE_ROOT.DIRECTORY_SEPARATOR."jscript/")) die ("Ошибка конфигурации и привелегий сервера!"); ?>
				
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-2.0.1.min.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-1.10.3.custom.min.js?s=<?=SESSION_ID?>" /></script>
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-timepicker-addon.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-timepicker-ru.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/globalize.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/FusionCharts.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.jqGrid.min.js?s=<?=SESSION_ID?>" /></script>				
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.fileUpload.js?s=<?=SESSION_ID?>" /></script>						
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.jqGrid.locale-ru.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.multiselect.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.fileDownload.js?s=<?=SESSION_ID?>" /></script>	
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.ui.menubar.js?s=<?=SESSION_ID?>" /></script>
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.calculator.min.js?s=<?=SESSION_ID?>" /></script>
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/ace.js?s=<?=SESSION_ID?>" /></script>		
				<script type="text/javascript" src="<?=ENGINE_HTTP?>/library/iws.js?s=<?=SESSION_ID?>" /></script>
				
				<link rel="stylesheet" type="text/css" href="<?=ENGINE_HTTP?>/library/normalize.css?s=<?=SESSION_ID?>" />  				
				<?php
				$db_link = new DB();
				if ((trim($db_link->get_param_view("theme")) != "") and ( is_file(ENGINE_ROOT."/".Convert_quotas($db_link->get_param_view("theme"))) )) {	
						echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/".Convert_quotas($db_link->get_param_view("theme"))."?s=".SESSION_ID." \" /> \n\t\t\t\t";						
				} else {
				$dh  = opendir(ENGINE_ROOT.DIRECTORY_SEPARATOR.THEMES_DIR.DIRECTORY_SEPARATOR);
				while (false !== ($file = readdir($dh))) {
				if (($file == ".") or ($file == "..")) continue;
				  if (is_dir(THEMES_DIR. DIRECTORY_SEPARATOR . $file)) {
					$dh_sub  = opendir(THEMES_DIR. DIRECTORY_SEPARATOR . $file);
					while (false !== ($file_t = readdir($dh_sub))) {
						if (($file_t == ".") or ($file_t == "..")) continue;						
						if (strrpos($file_t,".css") !== false) { $theme_first = THEMES_DIR."/".$file."/".$file_t;break;}	
						}
					}
					if (!empty($theme_first)) { 
						echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/".$theme_first."?s=".SESSION_ID."\" /> \n\t\t\t\t";						
						break;
					}
				  }
				}
				unset($dh);				
				$dh  = opendir(ENGINE_ROOT.DIRECTORY_SEPARATOR."jscript");
				while (false !== ($file = readdir($dh))) {
				if (($file == ".") or ($file == "..")) continue;
					if (strrpos($file,".css") !== false)  {
						echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/jscript/".$file ."?s=".SESSION_ID."\" /> \n\t\t\t\t";
					}
				}
				?> 				
				<style type="text/css">
						#loading{background:#fff url(<?=ENGINE_HTTP?>/library/ajax-loader.gif) no-repeat center center;height:100%;position:absolute;width:100%;z-index:100}
						html,body{font-size:12px;margin:0;overflow:hidden;padding:0}
						a{cursor:pointer}
						.loader_tab{background:url(<?=ENGINE_HTTP?>/library/ajax-loader.gif) no-repeat center center;height:100%;position:absolute;width:100%;z-index:100}
						.ui-widget-content{margin:1px;padding:1px}
						.ui-menubar-item{float:left;list-style:none;white-space:nowrap;z-index:102}
						.ui-menubar .ui-menu{list-style:none;min-width:200px;position:absolute;white-space:nowrap;z-index:102}
						.ui-menu-item .ui-menu{min-width:200px;z-index:102}
						.ui-menu{list-style:none;margin:1px;min-width:250px;padding:3px;white-space:nowrap;z-index:101}
						.ui-dialog .ui-dialog-content{text-align:right}
						.formelement{padding:.3em}
						.ui-pg-button{left:1px}
						.ui-menu-divider{padding:0}
						.ui-pg-table{border-collapse:separate}
						.ui-tabs .ui-tabs-panel{padding:7px}
						.ui-accordion-header{margin:1px}
						.ui-jqgrid .ui-jqgrid-htable th div{height:26px;overflow:hidden;position:relative;white-space:normal!important}
						.ui-multiselect-single .ui-multiselect-checkboxes label{padding:2px!important}
						.ui-multiselect-checkboxes span{clear:both;font-size:.9em;padding-left:4px}
						.ui-jqgrid .loading{background:transparent;border:0 transparent;color:inherit;height:99%;left:-5px;opacity:1;padding:10px;top:-5px;width:98%;z-index:89}
						.ui-multiselect-checkboxes li.ui-multiselect-optgroup-label{text-align:left}
						.ui-search-toolbar{border-color:transparent}
						.ui-jqgrid tr.jqgrow,.ui-state-active{cursor:default}	
						li, li li, li li li {list-style-type: none; }   						
<?php 
if (($main_db->get_param_view("render_type") > 2) and isset($_SERVER['HTTP_USER_AGENT']) and (!strrpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') == "")) $main_db -> set_param_view("render_type",2); // Проверка на эксплорер
switch ($main_db->get_param_view("render_type")) {
case 2: // для ie максимальный режим
echo "						* {border-radius: 0 !important;box-shadow: none !important;}";
break;
case 1:
echo "						*:not(.ui-icon) {border-radius: 0 !important;box-shadow: none !important;background-repeat: no-repeat !important;background-image: none !important; }";
break;
case 0:
echo "						* {border-radius: 0 !important;box-shadow: none !important;background:white !important;color:black !important;background-image:none !important;filter: none !important; opacity:1 !important;}";
break;
} 
?>
					
				</style>						 
</head>
<body>
	<div id="loading"></div>	
	<div id="param" title="Укажите ваши предпочтения:">
	<p><span class="ui-icon ui-icon-alert" style="float: right; margin: 0 7px 20px 10px;"></span>Задайте параметры для работы. В дальнейшем их можно изменить в меню где написано ваше имя</p>
	<form method="POST" id="settings_from" action="ajax.saveparams.php">
	<label for="themefor">Тема оформления:</label>
		<select id="themeselector" name="theme" >;
			<?php			
			// Загружаем список тем
			$dh  = opendir(THEMES_DIR);
			while (false !== ($file = readdir($dh))) {
				if (($file == ".") or ($file == "..")) continue;
				  if (is_dir(THEMES_DIR. DIRECTORY_SEPARATOR . $file)) {
					$dh_sub  = opendir(THEMES_DIR. DIRECTORY_SEPARATOR . $file);
					while (false !== ($file_t = readdir($dh_sub))) {
						if (($file_t == ".") or ($file_t == "..")) continue;
						$iscss = strpos($file_t,".css");
						if (!empty($iscss)) {
								if (trim(THEMES_DIR."/".$file."/".$file_t) == trim($main_db->get_param_view("theme"))) {$selected="selected";} else {$selected="";}
							echo "<option value=\"".THEMES_DIR."/".$file."/".$file_t."\" $selected>$file</option>\n\t";
							break;
						}
					}				  
				  }
			}
	?>
		</select><br><br>
		<input type="hidden" name="page_enable" value="off" ><input type="checkbox" name="page_enable" id="page_enable" <?=$main_db->get_param_view("page_enable")?>><label for="page_enable" style="font-size:80%" >Постраничная прокрутка</label><br>
		<input type="hidden" name="width_enable" value="off" ><input type="checkbox" name="width_enable" id="width_enable" <?=$main_db->get_param_view("width_enable") ?>><label for="width_enable" style="font-size:80%" >Автоширина данных</label><br>
		<input type="hidden" name="multiselect" value="off" ><input type="checkbox" name="multiselect" id="multiselect" <?=$main_db->get_param_view("multiselect") ?>><label for="multiselect" style="font-size:80%" >Множественный выбор</label><br>
		<input type="hidden" name="editabled" value="off" ><input type="checkbox" name="editabled" id="editabled" <?=$main_db->get_param_view("editabled") ?>><label for="editabled" style="font-size:80%" >Отображать нередактируемые поля</label><br>
		<input type="hidden" name="hide_menu" value="off" ><input type="checkbox" name="hide_menu" id="hide_menu" <?=$main_db->get_param_view("hide_menu") ?>><label for="hide_menu" style="font-size:80%" >Меню в панели вкладок</label><br><br>
		<label for="spinner">Количество месяцев в окне выбора дат: </label><input id="num_mounth" size="2" name="num_mounth" value = "<?=$main_db->get_param_view("num_mounth")?>" />
		<br><br><div class="ui-widget-header" style = "height: 1px;"></div><br>
		Парамерты производительности:<br><br>
		<input type="hidden" name="cache_enable" value="off" ><input type="checkbox" name="cache_enable" id="cache_enable" <?=$main_db->get_param_view("cache_enable") ?>><label for="cache_enable" style="font-size:80%" >Отключить кеширование</label><br><br>
		<label for="renderer">Качество отображения:</label><br><br>
		<input type="hidden" name="render_type" id="render_type" value="<?=$main_db->get_param_view("render_type")?>" />
		<div style="float:right">
			<div name="renderer" id="renderer"  style="float:right;top:-5px;width:280px;"></div>
			<div style="width:200px;display: block;height:30px;">
					<span style="position:absolute;float:left;display: block;width: 280px;text-align:left;"><br>Минимальное</span>
					<span style="position:absolute;float:right;display: block;width: 293px;"><br>Максимальное</span>               
			</div>
		</div>
		<input type="submit" id="submit_settings" style="display: none;">		
	</form>
	</div>
	<?=about($main_db)?>
	<table cellpadding="0" cellspacing="0" style="border:0px;padding:0px;margin:0px;width:100%"><tr>
	<td class="ui-widget ui-widget-header main_menu">
		<div id="Menubar" style="border:0px;">			
					<?=$DataGrid -> get_tree_main_menu()?>
		</div>
	</td>
	</tr><tr>
	<td>
		<div id="tabs" class="tabs_content">
			<ul></ul>						
		
		<h1 class="ui-widget-header ui-state-default about_tabs" style="width:98%;text-align :right;position:absolute;border:0px transparent;background: transparent;margin:10px;opacity: .3">
						<?=$main_db -> get_settings_val("ROOT_CONFIG_NAME")?>
		</h1>
		<h5  class="ui-widget-header ui-state-default about_tabs_ver" style="width:98%;text-align :right;position:absolute;border:0px transparent;background: transparent;margin:10px;opacity: .3">
						Версия: <?=$main_db -> get_settings_val("ROOT_CONFIG_VERSION")?>
		</h5>
		</div>
	</td>
	</tr></table>
	<?php if ($main_db->get_param_view("hide_menu") == "checked") { ?>
		<script type='text/javascript'>	
			hidden_menu = true;	
		</script>
	<?php } ?>
		<script type='text/javascript'>	
			num_of_mounth = <?=$main_db->get_param_view("num_mounth")?>;	
		</script>
	</body>
</html>
<?php
$main_db -> __destruct();
$DataGrid -> __destruct();
?>