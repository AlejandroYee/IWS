<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
require_once("library/lib.func.php");
header("Content-Type: text/html; charset=".strtolower(HTML_ENCODING));
BasicFunctions::requre_script_file("lib.requred.php"); 
$main_db = new db();
$user_auth = new AUTH();
  
 // Смотрим разрешено ли кеширование
if ($main_db->get_param_view("cache_enable") == "checked" and isset($_SESSION["DISABLED_CACHE"]) and $_SESSION["DISABLED_CACHE"] === "on") {
 	BasicFunctions::to_log("LIB: User disabled cache!");
 }
 
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html class="no-js" lang="ru-RU" xmlns="http://www.w3.org/1999/xhtml">                                                                                                                                            
<head>
<meta charset="<?=strtolower(HTML_ENCODING)?>" />
<title>IWS - <?=$main_db -> get_settings_val('ROOT_CONFIG_NAME')?></title>
<meta http-equiv="Content-Type" content="text/html; charset=<?=strtolower(HTML_ENCODING)?>" />
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache" >				
<meta http-equiv="expires" content="0" />		
<meta http-equiv="imagetoolbar" content="no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="author" lang="ru" content="Andrey Lysikov ICQ:454169, skype: andrey.boomer" />
<meta name="copyright" lang="ru" content="MIT License" />
<meta name="description" content="Интелектуальная веб система. Интерфейс обмена и работы с sql базой данны" />
<meta name="document-state" content="Dynamic" />
<meta name="robots" content="noindex,follow" />
<link rel="icon" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
<link rel="Bookmark" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
<link rel="shortcut icon" type="image/x-icon" href="<?=ENGINE_HTTP?>/<?=$main_db -> get_settings_val("ROOT_CONFIG_FAVICON")?>" />
<?=BasicFunctions::get_theme($main_db,$user_auth)?>
<?=BasicFunctions::get_css()?>
<?=BasicFunctions::get_scripts($user_auth)?>
<style type="text/css">
            #loading{background:#fff url(<?=ENGINE_HTTP?>/library/ajax-loader-tab.gif) no-repeat center center;height:100%;position:absolute;width:100%;z-index:900}
            html,body{font-size:12px;overflow:hidden;}
            a{cursor:pointer}
            .loader_tab{background:url(<?=ENGINE_HTTP?>/library/ajax-loader.gif) no-repeat center center;height:100%;position:absolute;width:100%;z-index:100}
            .ui-widget-content{margin:0px;padding:1px}
            .ui-menubar {font-weight: normal;vertical-align:middle;}
            .ui-menubar-item{float:left;list-style:none;white-space:nowrap;z-index:102;vertical-align:middle}
            .ui-menubar .ui-menu{font-weight: normal;list-style:none;min-width:200px;position:absolute;white-space:nowrap;z-index:102}
            .ui-menu-item .ui-menu{font-weight: normal;min-width:200px;z-index:102}
            .ui-menu{font-weight: normal;list-style:none;min-width:250px;white-space:nowrap;z-index:101}
			.ui-state-focus {font-weight: normal;} 
            .ui-dialog .ui-dialog-content{text-align:right}
            .ui-th-column-header{text-align:center}
            .formelement{padding:.3em}
            .ui-pg-button{left:1px}
            .ui-pg-table{border-collapse:separate}
            .ui-tabs .ui-tabs-panel{padding:7px}
            .ui-accordion-header{margin:1px}
            .ui-jqgrid .ui-jqgrid-htable th div{height:26px;overflow:hidden;position:relative;white-space:normal!important}						
            .ui-jqgrid .loading{background:transparent;border:0 transparent;color:inherit;height:99%;left:-5px;opacity:1;padding:10px;top:-5px;width:98%;z-index:89}						
            .ui-search-toolbar{border-color:transparent}
            .ui-icon-triangle-1-s {background-position: -65px -16px;} /* fix fo left sprite*/
            .ui-jqgrid tr.jqgrow,.ui-state-active{cursor:default}	
            .DataTD .ace_editor{left:-5px}
            .navicon-line {width: 18px;height: 2px; border:0px;border-radius: 1px; margin-bottom: 2px; cursor:pointer;}
            .tab-nav-sb {width: 26px;padding: 6px;cursor:pointer;margin-bottom: 1px;}
            li, li li, li li li {list-style-type: none;} 
            <?php 
            switch ($main_db->get_param_view("render_type")) {
            case 2:echo "            * {border-radius: 0 !important;box-shadow: none !important;}";break;
            case 1:echo "            *:not(.ui-icon) {border-radius: 0 !important;box-shadow: none !important;background-repeat: no-repeat !important;background-image: none !important; }";break;
            case 0:echo "            * {border-radius: 0 !important;box-shadow: none !important;background:white !important;color:black !important;background-image:none !important;filter: none !important; opacity:1 !important;}";break;
            }
            ?>
</style>						 
</head>
<body>
<div id="loading"></div>
<?php
BasicFunctions::is_offline(true);
if (!$user_auth -> is_user()) {
    ?>
        <div class="ui-widget ui-widget-content ui-corner-all user_login" style="position:absolute;text-align:center;width:400px;height:350px;">  
            <h3><?=$main_db -> get_settings_val("ROOT_CONFIG_NAME");?></h3><b id="loading_text"></b>
                            <div id='login_form'>                                
                                <p>Необходима авторизация, представьтесь:</p>	
                                <form method="POST" class="post_form_login" style="position:absolute;text-align:center;width:200px;height:190px;top:100px;left:100px" onsubmit="return false;">
                                                <div id="login_edit">
                                                        <label for="username_or_email" tabindex="-1" class="ui-widget" style="font-size:1.2em"><b>Ваш логин:</b></label><br>
                                                        <input aria-required="true"  autofocus="autofocus" id="username" name="username" class="ui-widget ui-widget-content ui-corner-all" style="height: 24px;"  type="text" /><br><br>
                                                        <label for="password" tabindex="-1" style="font-size:1.2em"><b>Пароль:</b></label>
                                                </div>
                                                        <input aria-required="true" id="password" class="ui-widget ui-widget-content ui-corner-all" name="password" style="height: 24px;" type="password" /><br><br>                                                        
                                                        <button id="logon_btn" >Войти</button>	
                                </form>
                            </div>
                       <div id="login_theme" style="position:absolute;text-align:center;width:200px;height:20px;top:280px;left:100px">
                                <h6>Случайная тема оформления, называется: "<?=THEME_NAME?>"</h6>
                       </div>
                       <div id="login_theme" style="position:absolute;text-align:center;width:200px;height:20px;top:315px;left:100px">
                               <h6 id="about">IWS: v<?=VERSION_ENGINE?>@<?=date("Y")?></h6>
                       </div>
        </div>   
<?php
 } else {     
    $DataGrid = new Data_form();
    BasicFunctions::get_about_html($main_db); 
    BasicFunctions::get_user_options($main_db);
    BasicFunctions::check_version($main_db);
    if (defined("OFFINE_START_DATE") and defined("OFFINE_END_DATE") and (date("d.m.Y",time()) === date("d.m.Y",OFFINE_START_DATE)) and (time() <= OFFINE_END_DATE)) {
        echo("<div  id=\"dialog_offline\" title='Запланированные работы:'><p><b>Уважаемый пользователь.</b><br /><br />C ".date("H:i:s",OFFINE_START_DATE)." по ".date("H:i:s",OFFINE_END_DATE)."<br />");
        echo("Система будет находится в оффлайне для:<br /><b>".OFFINE_MESSAGE." </b><br /><br />Приносим свои извенения за доставленное неудобство,по возможности завершите работу с системой до указанного времени.");
        echo("</p></div></div><script type=\"text/javascript\" >$(function() {  $('#dialog_offline').dialog({ minWidth: 550 });});</script> ");                        
    }
    ?>
    <div class="slidebarmenu ui-widget ui-widget-header">
        <?=$DataGrid -> get_tree_main_menu()?>
    </div>                 
    <div id="slidebarmenu-body">
            <div id="tabs" class="tabs_content">
                    <ul></ul>
                <h1 class="ui-widget-header ui-state-default about_tabs" style="width:98%;text-align :right;position:absolute;border:0px transparent;background: transparent;margin:10px;opacity: .3">
                        <?=$main_db -> get_settings_val("ROOT_CONFIG_NAME")?>
                </h1>
                <h5  class="ui-widget-header ui-state-default about_tabs_ver" style="width:98%;text-align :right;position:absolute;border:0px transparent;background: transparent;margin:10px;opacity: .3">
                        Версия: <?=$main_db -> get_settings_val("ROOT_CONFIG_VERSION")?>
                </h5>
            </div>
    <script type="text/javascript">	
            num_of_mounth = <?=$main_db->get_param_view("num_mounth")?>;	
    </script>
    </div>
    <?php
    $DataGrid -> __destruct();
    if ($main_db->get_param_view("enable_menu") == "checked") {
        echo "<script type='text/javascript'>enable_menu = true;user_not_logget = false;</script>";
    } else {
        echo "<script type='text/javascript'>user_not_logget = false;</script>";
    }
    if ($main_db->get_param_view("slidebar_right") == "checked") {
        echo "<script type='text/javascript'>slidebar = 'right';</script>";
    }
 }
?>
</body>
</html>
<?php
$main_db -> __destruct();
?>