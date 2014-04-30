<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
require_once("library/lib.func.php");
BasicFunctions::requre_script_file("lib.requred.php"); 

//Подключаем формы
$DataGrid = new Data_form();
$main_db = new db();

// Смотрим разрешено ли кеширование
if ($main_db->get_param_view("cache_enable") == "checked") {
	$_SESSION["ENABLED_CACHE"] = false;
	BasicFunctions::to_log("LIB: User disabled cache!");
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html class="no-js" lang="en-US">                                                                                                                                            
<head>
        <meta charset="<?=strtolower(HTML_ENCODING)?>">
        <title>IWS - <?=$main_db -> get_settings_val('ROOT_CONFIG_NAME')?></title>
        <meta http-equiv="Content-Type" content="text/html; charset=<?=strtolower(HTML_ENCODING)?>"/>
        <meta http-equiv="Cache-Control" content="no-cache">
        <meta http-equiv="Pragma" content="no-cache" >				
        <meta http-equiv="expires" content="0">		
        <meta http-equiv="imagetoolbar" content="no" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta name="author" lang="ru" content="Andrey Lysikov ICQ:454169, skype: andrey.boomer" />
        <meta name="copyright" lang="ru" content="MIT License" />
        <meta name="description" content="Интелектуальная веб система. Интерфейс обмена и работы с sql базой данны" />
        <meta name="document-state" content="Dynamic" />
        <meta name="robots" content="noindex,follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link rel="icon" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
        <link rel="Bookmark" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
        <link rel="shortcut icon" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
        <?php				
        if (!is_dir(ENGINE_ROOT.DIRECTORY_SEPARATOR.THEMES_DIR)) {
			die ("Неуказана директория тем в конфигурации!");
	    }
        if (!is_dir(ENGINE_ROOT.DIRECTORY_SEPARATOR."jscript/")) {
			die ("Ошибка конфигурации и привелегий сервера!");
		}
        ?>				
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-2.1.1.min.js?s=<?=SESSION_ID?>" ></script>		
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-1.11.min.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.mb.browser.min.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-timepicker-addon.js?s=<?=SESSION_ID?>" ></script>	
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery-ui-timepicker-ru.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.jqGrid.min.js?s=<?=SESSION_ID?>" ></script>				
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.fileUpload.js?s=<?=SESSION_ID?>" ></script>						
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.jqGrid.locale-ru.js?s=<?=SESSION_ID?>" ></script>        	
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.mask.min.js?s=<?=SESSION_ID?>" ></script>	
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.fileDownload.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.calculator.min.js?s=<?=SESSION_ID?>" ></script>				
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.flot.min.js?s=<?=SESSION_ID?>" ></script>	
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.printThis.js?s=<?=SESSION_ID?>" ></script> 
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.ui-contextmenu.js?s=<?=SESSION_ID?>" ></script> 
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.globalize.min.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.slidebarmenu.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/ace.js?s=<?=SESSION_ID?>" ></script>
<?php
            if (trim(strtolower(filter_input(INPUT_SERVER, 'HTTP_HOST',FILTER_SANITIZE_URL))) == 'bianca.test') {
                $min = "source";
            } else {
                $min = "min";
            }    
?>        <script type="text/javascript" src="<?=ENGINE_HTTP?>/jscript/jquery.multiselect.<?=$min?>.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/library/iws.<?=$min?>.js?s=<?=SESSION_ID?>" ></script>
        <script type="text/javascript" src="<?=ENGINE_HTTP?>/library/iws.jqgrid.extend.<?=$min?>.js?s=<?=SESSION_ID?>" ></script>
                                <link rel="stylesheet" type="text/css" href="<?=ENGINE_HTTP?>/library/normalize.css?s=<?=SESSION_ID?>" />  				
				<?php
				$db_link = new DB();
				if ((trim($db_link->get_param_view("theme")) != "") and ( is_file(ENGINE_ROOT . "/" . $db_link->get_param_view("theme")) )) {	
						echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP . "/" . str_ireplace("\\", "/", $db_link->get_param_view("theme"))."?s=".SESSION_ID." \" /> \n\t\t\t\t";						
				} else {
				$dh  = opendir(ENGINE_ROOT."/".THEMES_DIR."/");
				while (false !== ($file = readdir($dh))) {
				if (($file == ".") or ($file == "..")) continue;				
				  if (is_dir(THEMES_DIR. "/" . $file)) {				  
					$dh_sub  = opendir(THEMES_DIR. "/" . $file);
					while (false !== ($file_t = readdir($dh_sub))) {
						if (($file_t == ".") or ($file_t == "..")) continue;						
						if (strrpos($file_t,".css") !== false) {
						    // Попытаемся найти дефолтную темку						
							if (trim(strtolower($file)) == "smoothness") {
								$theme_first = THEMES_DIR. "/" .$file. "/" .$file_t;	
							}
							if (empty($theme_first)) $theme_first = THEMES_DIR. "/" .$file. "/" .$file_t;
						}	
						}
					}
				  }
				if (!empty($theme_first)) { 
					echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP. "/" .$theme_first."?s=".SESSION_ID."\" /> \n\t\t\t\t";					
				}
				}
				unset($dh);				
				$dh  = opendir(ENGINE_ROOT."/"."jscript");
				while (false !== ($file = readdir($dh))) {
				if (($file == ".") or ($file == "..")) continue;
					if (strrpos($file,".css") !== false)  {
						echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"".ENGINE_HTTP."/jscript/".$file ."?s=".SESSION_ID."\" /> \n\t\t\t\t";
					}
				}
				?> 			<style type="text/css">
						#loading{background:#fff url(<?=ENGINE_HTTP?>/library/ajax-loader-tab.gif) no-repeat center center;height:100%;position:absolute;width:100%;z-index:100}
						html,body{font-size:12px;margin:0;overflow:hidden;padding:0;-webkit-transform: translate3d(0, 0, 0);}
						a{cursor:pointer}
						.loader_tab{background:url(<?=ENGINE_HTTP?>/library/ajax-loader.gif) no-repeat center center;height:100%;position:absolute;width:100%;z-index:100}
						.ui-widget-content{margin:1px;padding:1px}
						.ui-menubar-item{float:left;list-style:none;white-space:nowrap;z-index:102}
						.ui-menubar .ui-menu{list-style:none;min-width:200px;position:absolute;white-space:nowrap;z-index:102}
						.ui-menu-item .ui-menu{min-width:200px;z-index:102}
                                                .ui-menu-item .ui-state-focus {left:-px;}
						.ui-menu{min-width:250px;z-index:101}
						.ui-dialog .ui-dialog-content{text-align:right}
						.formelement{padding:.3em}
						.ui-pg-button{left:1px}
						.ui-menu-divider{padding:0}
						.ui-pg-table{border-collapse:separate}
						.ui-tabs .ui-tabs-panel{padding:7px}
						.ui-accordion-header{margin:1px}
						.ui-jqgrid .ui-jqgrid-htable th div{height:26px;overflow:hidden;position:relative;white-space:normal!important}						
						.ui-jqgrid .loading{background:transparent;border:0 transparent;color:inherit;height:99%;left:-5px;opacity:1;padding:10px;top:-5px;width:98%;z-index:89}						
						.ui-search-toolbar{border-color:transparent}
                                                .ui-icon-triangle-1-s {background-position: -65px -16px;} /* fix fo left sprite*/
						.ui-jqgrid tr.jqgrow,.ui-state-active{cursor:default}	
                                                .DataTD .ace_editor{left:-5px}
						li, li li, li li li {list-style-type: none;} 
<?php 
if (($main_db->get_param_view("render_type") > 2) and (!strrpos(HTTP_USER_AGENT, 'MSIE') == "")) $main_db -> set_param_view("render_type",2); // Проверка на эксплорер
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
        <div class="slidebarmenu">
           <?=$DataGrid -> get_tree_main_menu()?>
       </div>
        <div id="slidebarmenu-body">
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
							if (trim(THEMES_DIR. DIRECTORY_SEPARATOR .$file. DIRECTORY_SEPARATOR .$file_t) === trim($main_db->get_param_view("theme"))) {$selected="selected";} else {$selected="";}
							echo "			<option value=\"".THEMES_DIR. DIRECTORY_SEPARATOR .$file. DIRECTORY_SEPARATOR .$file_t."\" $selected>$file</option>\n\t";
							break;
						}
					}				  
				  }
			}
	?>
                </select>
		<p><input type="hidden" name="width_enable" value="off" ><input type="checkbox" name="width_enable" id="width_enable" <?=$main_db->get_param_view("width_enable") ?>><label for="width_enable" style="font-size:80%" >Автоширина данных</label></p>
		<p><input type="hidden" name="editabled" value="off" ><input type="checkbox" name="editabled" id="editabled" <?=$main_db->get_param_view("editabled") ?>><label for="editabled" style="font-size:80%" >Отображать нередактируемые поля</label></p>
		<p><input type="hidden" name="hide_menu" value="off" ><input type="checkbox" name="hide_menu" id="hide_menu" <?=$main_db->get_param_view("hide_menu") ?>><label for="hide_menu" style="font-size:80%" >Меню в панели вкладок</label><br /></p>
		<p><label for="spinner">Количество месяцев в окне выбора дат: </label><input id="num_mounth" size="2" name="num_mounth" value = "<?=$main_db->get_param_view("num_mounth")?>" />
                <p><label for="spinner2">Количество записей на страницу: </label><input id="num_reck" size="2" name="num_reck" value = "<?=$main_db->get_param_view("num_reck")?>" /></p>		
                <p><div class="ui-widget-header" style = "height: 1px;"></div></p>
		<p>Парамерты производительности:</p>
		<p><input type="hidden" name="cache_enable" value="off" ><input type="checkbox" name="cache_enable" id="cache_enable" <?=$main_db->get_param_view("cache_enable") ?>><label for="cache_enable" style="font-size:80%" >Отключить кеширование</label></p>
		<p><label for="renderer">Качество отображения:</label></p>
		<input type="hidden" name="render_type" id="render_type" value="<?=$main_db->get_param_view("render_type")?>" />
		<div style="float:right">
			<div name="renderer" id="renderer"  style="float:right;top:-13px;width:280px;"></div>
			<div style="width:150px;top:10px;display: block;height:30px;">
					<span style="position:absolute;float:left;display: block;width: 280px;text-align:left;font-size: 11px;">Минимальное</span>
					<span style="position:absolute;float:right;display: block;width: 293px;font-size: 11px;">Максимальное</span>               
			</div>
		</div>
		<input type="submit" id="submit_settings" style="display: none;">		
	</form>
	</div>
	<?=BasicFunctions::about($main_db)?>
        <?=BasicFunctions::check_version($main_db)?>
        <table cellpadding="0" cellspacing="0" style="border:0px;padding:0px;margin:0px;width:100%"><tr>
        <tr>
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
<?php
        // Предупреждение о предстоящих работах
        if (defined("OFFINE_START_DATE") and defined("OFFINE_END_DATE") and (date("d.m.Y",time()) === date("d.m.Y",OFFINE_START_DATE)) and (time() <= OFFINE_END_DATE)) {
        ?>
        <div id="dialog_offline" title="Запланированные работы:">
        <p>
        <b>Уважаемый пользователь.</b><br /><br />
        C <?=date("H:i:s",OFFINE_START_DATE)?> по <?=date("H:i:s",OFFINE_END_DATE)?><br /><br />
        Система будет находится в оффлайне для:<br /> 
        <b><?=OFFINE_MESSAGE?> </b><br /><br />
        Приносим свои извенения за доставленное неудобство, 
        по возможности завершите работу с системой до указанного времени.
        </p>
        </div>
</div>

<script type='text/javascript'>	
$(function() {
    $( "#dialog_offline" ).dialog({ minWidth: 550 });
  });
</script>
<?php
}
$main_db -> __destruct();
$DataGrid -> __destruct();
?>
	</body>
</html>