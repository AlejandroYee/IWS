<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
class JQGRID extends DATA_FORM{
var $db_conn, $id_mm_fr, $id_mm_fr_d, $id_mm, $pageid;
	//-----------------------------------------------------------------------------------------------------------------------------------------------
	// Получаем и формируем переменный столбцов для грида
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
    function Create_grid_header($object_name) {
	$ResArray['Full_width'] = 0;
	$ResArray['Filter_Box'] = "";
	$ResArray['colModel'] = "";
	$ResArray['colNames'] = "";	
	$ResArray['TREE_EMPTY_DATA'] = "";				
		
	// Проверяем на наличие в кеше:
	$load_data = load_from_cache("grid_". abs($this->id_mm_fr));
	if ($load_data) {	
		return $load_data;
	} else {
		
		$filed_sys_hiden = array_merge_recursive($this -> db_conn -> get_settings_many_val('SETTINGS_VIEW_INVISIBLE_SYS_FIELDS'),
											 $this -> db_conn -> get_settings_many_val('SETTINGS_VIEW_INVISIBLE_AUDIT_FIELDS'));							
		$inv_view_table = $this -> db_conn  -> get_settings_val('SETTINGS_VIEW_INVISIBL_ID_TABLE');

		// Запрос в базу сразу с возвратом необходимых тегов и скриптов, тамже считаем длину текстовых полей
		$query = $this -> db_conn -> sql_execute("select tf.object_name, tf.name form_name, decode(nvl(t.is_requred, 0), 0, 'false', 'true') is_requred, tf.owner, t.name, tf.edit_button, nvl(t.width, 100) l_name, t.id_wb_form_field field_id, t.field_name || '_' || abs(t.id_wb_form_field) field_name, 'align: ''' || nvl(ta.html_txt, 'left') || ''', ' align_txt,
																case
																	when upper(trim(t.field_type)) = 'P'  then  'edittype:''password'' '
																	when upper(trim(t.field_type)) = 'SB' then  decode(trunc((nvl(t.count_element, 0) + 2) / 2), 1, 'stype:''select'', formatter:''select'', edittype: ''select'' ','stype:''select'', formatter:''select'', edittype: ''select'' multiple ')
																	when upper(trim(t.field_type)) = 'M'  then  'edittype:  ''textarea'''
																	when upper(trim(t.field_type)) = 'I'  then  'formatter: ''number'', formatoptions:{decimalPlaces: 0, defaultValue:''0'' } '
																	when upper(trim(t.field_type)) = 'N'  then  'formatter: ''number'', formatoptions:{decimalPlaces: 2, thousandsSeparator:'''',defaultValue:''0''}'
																	when upper(trim(t.field_type)) = 'NL' then  'formatter: ''number'', formatoptions:{decimalPlaces: 7}, defaultValue:''0'''
																	when upper(trim(t.field_type)) = 'C'  then  'formatter: ''currency'', formatoptions:{prefix: '''', suffix:''p.'',defaultValue:''0''}'
																	when upper(trim(t.field_type)) = 'D'  then  'formatter: ''date'', formatoptions:{srcformat:''d.m.Y'',newformat:''d.m.Y''} '
																	when upper(trim(t.field_type)) = 'DT' then  'formatter: ''date'', formatoptions:{srcformat:''d.m.Y H:i:s'',newformat:''d.m.Y H:i:s''}'
																	when upper(trim(t.field_type)) = 'E'  then  'formatter: ''email'' '
																	when upper(trim(t.field_type)) = 'B'  then  'edittype:''checkbox'', formatter:''checkbox'', formatoptions:{disabled:false}'
																	when upper(trim(t.field_type)) = 'A'  then  'formatter: ''link'', formatoptions:{target: ''_blank''}'
																	else 'formatoptions: { defaultValue: '''' }'
																end field_type, t.count_element,
														t.field_type field_type_sum, t.field_txt,
														decode(t.is_read_only, 1, 'true', 'false') is_read_only,
														decode(tf.is_read_only, 1, 'true', 'false') as read_only_form
												from ".DB_USER_NAME.".wb_mm_form tf
												left join ".DB_USER_NAME.".wb_form_field t
												on t.id_wb_mm_form = tf.id_wb_mm_form
												left join ".DB_USER_NAME.".wb_form_field_align ta
												on ta.id_wb_form_field_align = t.id_wb_form_field_align
											  where tf.id_wb_mm_form = ".$this -> id_mm_fr." order by t.num");		
											  
				while ($this-> db_conn-> sql_fetch($query)) {
					$date_formatter = "";
					$hidden 		= "";
					$sd_options     = "";
					$edit_options 	= "";
					
					// Параметры поля
					$filed_type = $this -> return_sql($query, "FIELD_TYPE");
						
					// Проверка элементов:
					switch ($this -> return_sql($query, "FIELD_TYPE_SUM")) {						
						// SELECT
						case "SB":									
							if (strrpos($this -> return_sql($query, "FIELD_TYPE"),"multiple") === false) {
									$multi_str = " multiple:false, h:1, ";
								} else {
									$filed_type = str_replace("multiple","",$filed_type);
									$multi_str = " multiple:true, h:3, ";
							}							
							$main_dbs = new db();
								$sd_options_content = get_select_data($main_dbs, $this -> return_sql($query, "FIELD_TXT"), 'null');	
							$main_dbs -> __destruct();						
							$edit_options .= ", i_type:'SB', input_type:'select', ".$multi_str." value: '".$sd_options_content."'";
							$sd_options = "searchoptions: {value: ':;".$sd_options_content."'}, ";
						break;
						case "DT": $edit_options .= ", i_type:'DT'";break;
						// ONLY DATE
						case "D":  $edit_options .= ", i_type:'D'";break;						
						// MULTILINE
						case "M":  $edit_options .= ", i_type:'M', h:'".$this -> return_sql($query, "COUNT_ELEMENT")."'";break;				
						// CHEKBOX
						case "B":  $edit_options .= ", i_type:'B', value:'1:0'";break;
						// INTEGER
						case "I":  $edit_options .= ", i_type:'I'";break;
						// NUMBER
						case "N":  $edit_options .= ", i_type:'N'";break;
						// NUMBER LONG
						case "NL": $edit_options .= ", i_type:'NL'";break;
						// CURRENCIS
						case "C":  $edit_options .= ", i_type:'C'";break;
						// PASSWORD
						case "P":  $edit_options .= ", i_type:'P'";break;					
					}
					$edit_options .= ", w:'".$this -> return_sql($query, "L_NAME")."'";
					 
					// Создаем заголовок					
					$ResArray['colNames'] .= ",
						'".trim(str_ireplace(array("(not display)","#","<br>")," ",$this -> return_sql($query, "NAME")))."'";
					
					// Проверяем на служебные поля
					if (trim_fieldname($this -> return_sql($query, "FIELD_NAME")) == "ID_".$this -> return_sql($query, "OBJECT_NAME") ) {
							$hidden = "hidden: true, ";
							if ($inv_view_table == 0) {
										$hidden = "hidden: false,";
							} 
					}
				
					//Поле обязательно?
					if (($this -> return_sql($query, "IS_READ_ONLY")  != "true") and ($this -> return_sql($query, "FIELD_TYPE_SUM") != "SB")) {
						$edit_options .= ", is_requred:'".$this -> return_sql($query, "IS_REQURED")."'";
					}
					
					// Спрятать ID_CONTROL_LOAD_DATA если включены служебные поля
					if ((trim_fieldname($this -> return_sql($query, "FIELD_NAME")) == "ID_CONTROL_LOAD_DATA") and ($inv_view_table <> 1)) {							
										$hidden = "hidden: true, ";
					} else if(in_array(trim_fieldname($this -> return_sql($query, "FIELD_NAME")), $filed_sys_hiden)) { 
						$hidden = "hidden: true, ";
					}
						
					// Если нажато то мы смотрим но неизменяем поля
					if ($this -> return_sql($query, "IS_READ_ONLY")  == "true") {
						$editabled = "editable: false, ";
						if 	( $this -> db_conn->get_param_view("editabled") == "checked") {
							$edit_options .= ", show_disabled:'true' ";
							$editabled = "editable : true, ";
						}
					} else {
						$editabled = "editable : true, ";
					}	
					
					$ResArray['Full_width'] = intval($ResArray['Full_width']) + intval($this -> return_sql($query, "L_NAME"));				
					// формируем поля:
					$ResArray['colModel'] .= "{
						name: '".$this -> return_sql($query, "FIELD_NAME")."',
						index: '".$this -> return_sql($query, "FIELD_NAME")."',
						width: ".$this -> return_sql($query, "L_NAME").",
						".$editabled.$hidden."
						searchoptions: {sopt:['eq','ne', 'lt', 'le', 'gt', 'ge', 'bw','cn']},
						".$this -> return_sql($query, "ALIGN_TXT")."
						".$sd_options.$filed_type.", editoptions: {".trim($edit_options,",")."}
					},";					
					
						
					// Указываем имя таблички если это detail_grid
					$ResArray['Title'] = trim($this -> return_sql($query, "FORM_NAME"));
						
					// Ссылка на ведущую таблицу, она нужна для правильного постоения запроса к данным для ведомой таблици
					$ResArray['Master_Table_ID'] = "ID_".$this -> return_sql($query, "OBJECT_NAME");							
					
					// Форма редонли?
					$ResArray['fl_table'] = $this -> return_sql($query, "READ_ONLY_FORM");
					
					// Кнопочки формы
					$form_buttons = explode(",",strtoupper(trim($this -> return_sql($query, "EDIT_BUTTON"))));
					
					// Определяющая уровня для дерева
					if ( trim_fieldname($this -> return_sql($query, "FIELD_NAME")) == "NAME") {
						$ResArray['TREE_LEV_NAME'] = $this -> return_sql($query, "FIELD_NAME");
					}
					// Добавляем данные для пустой строки
					$ResArray['TREE_EMPTY_DATA'] .= ",\"\"";
				}
				
				
				// Кнопки редактирования
				foreach($form_buttons as $index => $value) {
					switch (trim($value)) { 
						case 'A':
							$ResArray['ADD_BUTTON'] = true;
						break;
						case 'E':
							$ResArray['EDIT_BUTTON'] = true;
						break;
						case 'D':
							$ResArray['DELETE_BUTTON'] = true;
						break;
						case 'EXP':
							$ResArray['EXPORT_BUTTON'] = true;
						break;							
					}				
				}
				// Возвращаем все
				$ResArray['TREE_EMPTY_DATA'] = "{0:[".trim($ResArray['TREE_EMPTY_DATA'],",")."]}";
				$ResArray['colNames'] = "[".trim($ResArray['colNames'], ",")."]";
				$ResArray['colModel'] = "[".trim($ResArray['colModel'], ",")."]";					
				save_to_cache("grid_". abs($this->id_mm_fr), $ResArray);
				return $ResArray;		
		}
	}

	// Создаем скриптовую обвязку грида
	//------------------------------------------------------------------------------------------------------------------------------------------------
	function greate_grid($type, $dataload, $object_name, $XSL_FILE_OUT, $heigth_of_grid, $form_id,$auto_update) {
	// Получаем массив данных для обвязки грида
	$ResArray = $this -> Create_grid_header($object_name); 	
	// Начинаем создавать сам грид
	ob_start();
	ob_implicit_flush();
	?>	<div class="grid_resizer <?=$this->pageid?>" for="<?=$object_name?>" form_id="<?=$form_id?>" auto_update="<?=$auto_update?>" form_type="<?=$type?>" percent="<?=$heigth_of_grid?>">
		<table id="<?=$object_name?>"></table>
			<div id="Pager_<?=$object_name?>"></div>
		</div>
		<script type="text/javascript">		
		var export_post_data_<?=$object_name?> = '';
		var crc_input_<?=$object_name?> = '';
		
		$(function() {	
			$('#<?=$object_name?>').jqGrid({										
			rownumbers: true,	
			shrinkToFit:false,						
		<?php		
		
		// Постраничная или нет прокрутка
		if ($this->db_conn->get_param_view("page_enable") == "checked") { 
					?> 		 scroll:false,
							 rowNum:50,
							 recordtext:'Просмотр записей {0} - {1} из {2}',
							 <?php	
			} else  {
					?> 		 scroll:true,
							 rowNum: 1000,
							 recordtext:'Просмотр записей {0} - {1}',
							  <?php	
		}
	// Множественный выбор
	if (($this->db_conn->get_param_view("multiselect") == "checked") and ($type != "TREE_GRID_FORM_DETAIL") and (stripos($type,"_MASTER") === false)) {		
		?> multiselect:true, <?php
	}		
	
	// Эсли это просто дерево:
	if (($type == "TREE_GRID_FORM") or ($type == "TREE_GRID_FORM_MASTER") or ($type == "TREE_GRID_FORM_DETAIL")) 	{
		?>					treeGrid: true,
							treeGridModel: 'adjacency',                     
							ExpandColClick: true,
							rownumbers: false,							
							ExpandColumn: '<?=$ResArray['TREE_LEV_NAME']?>',
							multiselect: false,							
							recordtext:'Записей в дереве: {1}',							
							treeIcons: {plus:'ui-icon-folder-collapsed',minus:'ui-icon-folder-open',leaf:'ui-icon-document'},
							
		<?php		
	}
	// Нужно обязательно засунуть строку в такое дерево, иначе вывалится с ошибкой
	if (($type == "TREE_GRID_FORM_DETAIL") and (isset($ResArray['TREE_EMPTY_DATA']))) 	{
		echo "data:".$ResArray['TREE_EMPTY_DATA'].",";
	}
		
	// для всех случаев и вариантов грида				
	    ?>
				    datatype: '<?=$dataload?>',						
					mtype: 'GET',											
					pager: '#Pager_<?=$object_name?>',
					rowList:[10,50,100,500,1000,2000,5000],					
					colNames:<?=$ResArray['colNames']?>,  
					colModel:<?=$ResArray['colModel']?>,					
					sortable: true,
					caption:'<?=$ResArray['Title']?>',
					ignoreCase:true,	
					viewrecords: true,	
					scrollOffset:17,
					hidegrid:false,
					width:500,
					url: '<?=ENGINE_HTTP?>/ajax.data.grid.php?type=<?=$type?>&pageid=<?=$this ->pageid?>&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=<?=$this ->id_mm_fr_d?>&id_mm=<?=$this ->id_mm?>',	
					loadtext: 'Запрашиваю данные...',
					onSelectRow: function(ids) {
								// Узнаем тип грида
								var grid_type = $("#<?=$this -> pageid?> .tab_main_content .grid_resizer[for='" + $(this).attr('id') + "']").attr('form_type');
								var tree_leaf =  $('#<?=$object_name?>').jqGrid('getRowData', ids).isLeaf;
								// Для древовидных гридов переопределяем путь сохранения
								if (grid_type == "TREE_GRID_FORM_MASTER" || grid_type == "TREE_GRID_FORM" || grid_type == "TREE_GRID_FORM_DETAIL") {								
									$('#<?=$object_name?>').jqGrid('setGridParam',{editurl:'<?=ENGINE_HTTP?>/ajax.savedata.grid.php?type=<?=$type?>&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d='+ ids +'&id_mm='+ ids, page:1});	
								}	
									
								if (typeof(tree_leaf) === 'undefined' || tree_leaf  == "true") {	// защита от дерева												
									//Если это не детальный грид то:
									if (grid_type !== "GRID_FORM_DETAIL" && grid_type !== "TREE_GRID_FORM_DETAIL") {								
										// Нужно просмотреть все детальные гриды, и обновить в них данные
										$.each( $("#<?=$this -> pageid?> .tab_main_content .grid_resizer[form_type$='_DETAIL']"), function() {
											var gridname = $(this).attr('for');
											var grid_type = $(this).attr('form_type');
											var grid_parent_id = $("#<?=$this -> pageid?> .tab_main_content .grid_resizer[for='" + gridname + "']").attr('form_id');										
											$('#' + gridname).jqGrid('setGridParam',{url:'<?=ENGINE_HTTP?>/ajax.data.grid.php?type=' + grid_type + '&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=' + grid_parent_id + '&Master_Table_ID=<?=$ResArray['Master_Table_ID']?>&id_mm='+ids,page:1});
											$('#' + gridname).jqGrid('setGridParam',{editurl:'<?=ENGINE_HTTP?>/ajax.savedata.grid.php?type=' + grid_type + '&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=' + grid_parent_id + '&Master_Table_ID=<?=$ResArray['Master_Table_ID']?>&id_mm='+ids,page:1});
											$('#' + gridname).jqGrid('setGridParam',{search:false, datatype:'json',loadonce:false,treedatatype:'json'}, true);											
											$('#' + gridname).jqGrid().trigger('reloadGrid', true);
											// Обновляем филд select в случае если он есть и подсовываем ему rowid	
											$.each( $('#' + gridname).jqGrid ('getGridParam', 'colModel') , function() {
													if (this.edittype == "select") {												
														get_select_values_grid(gridname, this.name, ids);
													}
											});
										});
									}
									var grid_type = $("#<?=$this -> pageid?> .tab_main_content .grid_resizer_tabs[for='" + $(this).attr('id') + "']").attr('form_type');
									// В случае если гриды во вкладках, то обновляем их, но только активный перезагружаем
									if (grid_type !== "GRID_FORM_DETAIL" && grid_type !== "TREE_GRID_FORM_DETAIL") {	
										$.each( $("#<?=$this -> pageid?> .tab_main_content .grid_resizer_tabs[form_type$='_DETAIL']"), function() {
											var gridname = $(this).attr('for');
											var grid_type = $(this).attr('form_type');										
											var grid_parent_id = $("#<?=$this -> pageid?> .tab_main_content .grid_resizer_tabs[for='" + gridname + "']").attr('form_id');
											$('#' + gridname).jqGrid('setGridParam',{url:'<?=ENGINE_HTTP?>/ajax.data.grid.php?type=' + grid_type + '&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=' + grid_parent_id + '&Master_Table_ID=<?=$ResArray['Master_Table_ID']?>&id_mm='+ids,page:1});
											$('#' + gridname).jqGrid('setGridParam',{editurl:'<?=ENGINE_HTTP?>/ajax.savedata.grid.php?type=' + grid_type + '&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=' + grid_parent_id + '&Master_Table_ID=<?=$ResArray['Master_Table_ID']?>&id_mm='+ids,page:1});
											$('#' + gridname).jqGrid('setGridParam',{search:false, datatype:'json',loadonce:false,treedatatype:'json'}, true);
											$.each( $('#' + gridname).jqGrid ('getGridParam', 'colModel') , function() {
													if (this.edittype == "select") {												
														get_select_values_grid(gridname, this.name, ids);
													}
											});
											if ($(this).parent().attr('aria-expanded') == "true") {
												$('#' + gridname).jqGrid().trigger('reloadGrid', true);
											} else {
												$(this).attr('need_update','true');
											}
										});
									}
								}
							},
					gridComplete: function() {	// на случай невыбранной ноды после обновления в дереве				
						var grid_type = $("#<?=$this -> pageid?> .tab_main_content .grid_resizer[for='" + $(this).attr('id') + "']").attr('form_type');
						if (grid_type == "TREE_GRID_FORM_MASTER" || grid_type == "TREE_GRID_FORM" || grid_type == "TREE_GRID_FORM_DETAIL") {								
							$('#<?=$object_name?>').jqGrid('setGridParam',{editurl:'<?=ENGINE_HTTP?>/ajax.savedata.grid.php?type=<?=$type?>&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=&id_mm=', page:1});							
						};					
					},
					beforeRequest: function() {
							var postdata = $(this).getGridParam('postData');
						    export_post_data_<?=$object_name?> = '';
							for( key in postdata ){
								if(postdata.hasOwnProperty(key)) {
										export_post_data_<?=$object_name?> = export_post_data_<?=$object_name?> + '&' + key + '=' + postdata[key];
								}
							}
					},
					beforeProcessing: function(data, status, xhr) {
						if (crc_input_<?=$object_name?> == $.md5(xhr.responseText)) {
								return false;
							}else {								
								crc_input_<?=$object_name?> = $.md5(xhr.responseText);									
						}
					},
					editurl:'<?=ENGINE_HTTP?>/ajax.savedata.grid.php?type=<?=$type?>&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=<?=$this ->id_mm_fr_d?>',
					loadError: function(xhr,status, err){ 
									custom_alert(xhr.responseText);
						}
					})
					.jqGrid('navGrid','#Pager_<?=$object_name?>',{
						view: false,edit: false,del: false,add: false,search:false
					})
					.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
                                              caption: 'Просмотр',
                                              title: 'Просмотреть выделенную запись',
                                              buttonicon: 'ui-icon-document',
                                              onClickButton: function(){
                                                                row_id = $('#<?=$object_name?>').jqGrid ('getGridParam', 'selrow');                                                               
																$('#<?=$object_name?>').jqGrid('viewGridRow',row_id,{viewPagerButtons:true, recreateForm:false, closeOnEscape:true});
                                                             }											
							})					
					.jqGrid('navSeparatorAdd','#Pager_<?=$object_name?>')
		<?php
		// однако можно редактировать записи, добавляем кнопки	
		if (trim($ResArray['fl_table']) == 'false') { 				
					if (isset($ResArray['ADD_BUTTON'])) { ?>
					.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
                                              caption: 'Добавить',
                                              title: 'Добавить новую запись',
                                              buttonicon: 'ui-icon-plus',
                                              onClickButton: function(){
                                                      $('#<?=$object_name?>').jqGrid('editGridRow','new',{viewPagerButtons:false,closeOnEscape:true, addedrow:'last',recreateForm:true,reloadAfterSubmit:false, closeAfterAdd:true,																
																	afterSubmit: function(response, postdata) {																	
																		if (response.responseText.length > 0) {																				
																			if (response.responseText.length > 20) {
																				custom_alert(response.responseText);																			
																			} else {																				
																				return [true,"Ok",response.responseText];																				
																			}
																		} else {
																			return [true,"Ok"];
																		}
																	},
																	beforeSubmit : function(postdata, formid) {																					
																		if (check_form(formid)) {
																			return [true,'']; 
																		} 
																	}
															});
                                               }
											   
							})
		<?php		}
					if (isset($ResArray['EDIT_BUTTON'])) { ?>
					.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
                                              caption: 'Изменить',
                                              title: 'Изменить выделенную запись',
                                              buttonicon: 'ui-icon-pencil',
                                              onClickButton: function(){
																row_id = $('#<?=$object_name?>').jqGrid ('getGridParam', 'selrow');
                                                                $('#<?=$object_name?>').jqGrid('editGridRow',row_id,{viewPagerButtons:false,closeOnEscape:true, recreateForm:true,reloadAfterSubmit:false, closeAfterEdit:true,																		
															     	afterSubmit: function(response, postdata)  {
																		if (response.responseText.length > 0) {
																			custom_alert(response.responseText);																			
																		} else {
																			return [true,"Ok"];
																		}
																	},
																	beforeSubmit : function(postdata, formid) {
																		if (check_form(formid)) {
																			return [true,'']; 
																		} 
																	}
																});
                                                             }                                              
							})
		<?php		}
					if (isset($ResArray['DELETE_BUTTON'])) {?>
					.jqGrid('navGrid','#Page_-<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
                                              caption: 'Удалить',
                                              title: 'Удалить выделенную запись',
                                              buttonicon: 'ui-icon-close',
                                              onClickButton: function(){
																row_id = $('#<?=$object_name?>').jqGrid ('getGridParam', 'selarrrow');
																if ($.isArray(row_id) && row_id != "") {																	
																		 $('#<?=$object_name?>').jqGrid('delGridRow',row_id,{closeAfterDel: true,closeOnEscape:true, recreateForm:true,reloadAfterSubmit:false,															
																			afterSubmit: function(response, postdata)  {
																				if (response.responseText.length > 0) {
																					custom_alert(response.responseText);
																				} else {
																					return [true,''];
																				}
																			}
																		});																	
																} else {
																		row_id = $('#<?=$object_name?>').jqGrid ('getGridParam', 'selrow');
																		  $('#<?=$object_name?>').jqGrid('delGridRow',row_id,{closeAfterDel: true,closeOnEscape:true, recreateForm:true,reloadAfterSubmit:false,																
																			afterSubmit: function(response, postdata)  {
																				if (response.responseText.length > 0) {
																					custom_alert(response.responseText);
																				} else {
																					return [true,''];
																				}
																			}
																		});
																}	
                                                             }                                              
							})
		<?php
					}
		echo ".jqGrid('navSeparatorAdd','#Pager_".$object_name."')";
		}		
		?>
		// Кнопки которые видны всегда, с разделителем								
					.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
											caption: 'Выбрать столбцы',
											title: 'Скрыть/показать столбцы',
											onClickButton : function (){
																$('#<?=$object_name?>').jqGrid('columnChooser',{
																done : function () {
																			redraw_document();
																			<?php
																				// Если нужна автоширина, то запускаем перерасчет
																				if ($this->db_conn->get_param_view("width_enable") == "checked") {
																					?> auto_width_grid('<?=$object_name?>'); <?php		
																				}
																			?>
																		}
																}); 
											}
									});
		$('#<?=$object_name?>')
		<?php
		if (($type != "TREE_GRID_FORM_MASTER") and ($type != "TREE_GRID_FORM") and ($type != "TREE_GRID_FORM_DETAIL")) {
		?>		
					.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
                                              caption: 'Отфильтровать',
                                              title: 'Поиск по ключевым словам',
                                              buttonicon: 'ui-icon-search',
                                              onClickButton: function(){
																	$('#<?=$object_name?>').jqGrid()[0].toggleToolbar();	
															 },
						}).jqGrid('filterToolbar',{searchOnEnter:true})	
		<?php
		}
		?>				
						.hideCol(['r_num']);						
						$('#pg_Pager_<?=$object_name?>').children('.ui-pg-table').removeAttr( 'style' ).css('width','100%');
						$('#Pager_<?=$object_name?>_left').removeAttr( 'style' );
						$('#Pager_<?=$object_name?>_center').removeAttr( 'style' ).removeAttr('align').css({'width':'0px','align':'right'});						
						$('#Pager_<?=$object_name?>_right').removeAttr( 'style' ).removeAttr('align').css({'width':'250px','align':'right'});
		<?php
		// Для постраничноый прокрутки применяем стили на элементы выбора страници
		if ($this->db_conn->get_param_view("page_enable") == "checked") { 
		?>
			$('#Pager_<?=$object_name?>_center').removeAttr( 'style' ).removeAttr('align').css({'width':'260px','align':'right'});
			$('#Pager_<?=$object_name?>_center .ui-pg-table tr').find('.ui-pg-input').prop('class','ui-pg-input ui-state-default');		
			$('#Pager_<?=$object_name?>_center .ui-pg-table tr').find('.ui-pg-selbox').prop('class','ui-pg-selbox ui-state-default');			
		<?php
	    }
		// Если нужна автоширина, то запускаем перерасчет
		if ($this->db_conn->get_param_view("width_enable") == "checked") {
				?> auto_width_grid('<?=$object_name?>'); <?php	
		}
	if (!empty($auto_update)) {
	?>
	var updater_<?=$object_name?>;
	$('#<?=$this -> pageid?> .navigation_header').append($('<input>').attr({
		'id':'reload_grid_<?=$this -> pageid?>','style':'float: right;','type':'checkbox'}));
		$('#reload_grid_<?=$this -> pageid?>').before('<label for="reload_grid_<?=$this -> pageid?>" style="float: right;">Автообновление данных в "<?=$ResArray['Title']?>"</label>')
			.button({icons: {primary: 'ui-icon-refresh'}, text: true}).click(function() {
					var btn = $("#reload_grid_<?=$this -> pageid?>");
					if (btn.attr("checked") != "checked") {		
							btn.attr("checked","checked");
							$('#<?=$object_name?>').jqGrid('setGridParam',{'loadui':'disable'});	
							$('#load_<?=$object_name?>').hide();
							updater_<?=$object_name?> = setInterval(function() {
								$('#<?=$object_name?>').jqGrid().trigger('reloadGrid', true);
							}, <?=($auto_update*1000)?>);
						} else {
							$('#<?=$object_name?>').jqGrid('setGridParam',{'loadui':'enable'});
							clearInterval(updater_<?=$object_name?>);							
							btn.removeAttr("checked");
					}});;
		$('#reload_grid_<?=$this -> pageid?>').click();
	<?php
	}
	// Закрываем скрипт	
	?>
	});
	 </script>
	 <?php
	 // Делаем возможность экспорта
	 if (isset($ResArray['EXPORT_BUTTON'])) {
			$this -> Create_export($object_name, $type,  'Экспорт содержимого таблици в файл',  $XSL_FILE_OUT);
		}	
	$data = ob_get_contents();
	ob_end_clean();	
	return $data;
	}
	
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	// Создание доп вкладок и кнопок
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	function create_detail_tab_script(){
	ob_start();
	ob_implicit_flush();
	?>
		<script type="text/javascript">		
		$(function() {	
			// Делам новые вкладки и перемещаем туда детальные гриды:
			var perch = $("#<?=$this -> pageid?> .tab_main_content .grid_resizer[form_type$='_MASTER']");
			var perc = 100 - $(perch).attr('percent');
			$($("<div />").attr({
				 	'class' : 'grid_resizer detail_tab tabs-bottom',
					'id' : 'detail_tab_<?=$this -> pageid?>',
					'percent' : perc,
					'form_type' : 'TABED_GRID_FORM'
			}).append("<ul></ul>")).insertAfter(perch);		
			
			$.each( $("#<?=$this -> pageid?> .tab_main_content .grid_resizer[form_type$='_DETAIL']"), function(i) {
			
				var grid_name = $(this).find('span.ui-jqgrid-title').text();
				
				// Создаем вкладку
				$('#detail_tab_<?=$this -> pageid?>').append( $("<div />").attr({
						'id':'detail_content_' + i + '_<?=$this -> pageid?>'
					})); 
					
				// Создаем заголовок вкладки
				$('#detail_tab_<?=$this -> pageid?> ul').append("<li><a href='#detail_content_" + i + "_<?=$this -> pageid?>'>" + grid_name + "</a></li>");
				$(this).find('.ui-jqgrid-titlebar').remove();
				// Перемещаем грид во вкладку
				$('#detail_content_' + i + '_<?=$this -> pageid?>').append($(this).removeClass( "grid_resizer" ).addClass( "grid_resizer_tabs" ));
			});
			
			// Говорим создать вкладки
			set_detail_tab();
			set_resizers();
		});
		</script>
	<?php
	$data = ob_get_contents ();
	ob_end_clean();	
	return $data;
	}
	
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	// Функция добавление пользовательских кнопок
	//-----------------------------------------------------------------------------------------------------------------------------------------------
	function  User_button($button_name, $object_name, $id, $label, $obj_name) {
	ob_start();
	ob_implicit_flush();
	?>	
		<div id="<?=$button_name?>" title="Выполнить?">
			<p><?=$label?></p>
			<div id= 'ajax_<?=$button_name?>' ><img src='/library/ajax-loader.gif' style='padding-bottom: 4px; vertical-align: middle;' > Выполняю...</div>	
		</div>
		<script type="text/javascript">		
		$(function() {	
			$('#<?=$object_name?>')
				// Добавляем пользовательскую кнопку
						.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
											caption: '<?=$obj_name?>',
											title: '<?=$label?>',
											buttonicon: 'ui-icon-flag',
											onClickButton : function () {												
													row_id = $('#<?=$object_name?>').jqGrid ('getGridParam', 'selarrrow');
																	if ($.isArray(row_id) && row_id != "") {																	
																			$('#<?=$button_name?>').attr('grid_row',row_id);
																			$('#<?=$button_name?>').dialog( 'open' );															
																	} else {
																			row_id = $('#<?=$object_name?>').jqGrid ('getGridParam', 'selrow');
																			if ( row_id != null) {	
																				$('#<?=$button_name?>').attr('grid_row',row_id);
																				$('#<?=$button_name?>').dialog( 'open' );
																			}
													}
											}
						});
			
			$('#<?=$button_name?>').dialog({
					autoOpen: false,
						modal: true,
						minWidth:400,
						appendTo: $('#<?=$this->pageid?> .tab_main_content'),
						closeOnEscape: true,
						resizable:false,
				buttons: [	
							{
								text: 'Да',
								click: function () {							
									$('#ajax_<?=$button_name?>').show();
									$('.ui-dialog-buttonpane').hide();
											$.ajax({
											  url: '<?=ENGINE_HTTP?>/ajax.saveparams.php?id_mm_fr=<?=$id?>&rowid=' + $('#<?=$button_name?>').attr('grid_row'),
											  processData: false,
											  datatype:'json',
											  cache: false,
											  type: 'POST',
											  success: function(data){
														$('.ui-dialog-buttonpane').show();
														$('#ajax_<?=$button_name?>').hide();
														$('#<?=$button_name?>').dialog( 'close' );
														$('#ui-<?=$this->pageid?>').parent().effect('pulsate', {}, 2000);
														$('#<?=$object_name?>').jqGrid().trigger('reloadGrid', true);
												if (data.length > 20) {
														custom_alert(data);
												}
											  }	  
											});	
									
								}
							},{
								text: 'Нет',
								click: function () {
									$('.ui-dialog-buttonpane').show();
									$('#ajax_<?=$button_name?>').hide();
									$( this ).dialog( 'close' );
								}
						   }						
						],
						close:function() {
							$('.ui-dialog-buttonpane').show();
							$( this ).dialog( 'close' );
						},
						open: function() {
								$('#ajax_<?=$button_name?>').hide();
								$('.ui-dialog-buttonpane').find('button:contains("Нет")').button({icons: { primary: 'ui-icon-close'}});
								$('.ui-dialog-buttonpane').find('button:contains("Да")').button({icons: { primary: 'ui-icon-check'}});
								$(this).parent().parent().children('.ui-widget-overlay').addClass('dialog_jqgrid_overlay ui-corner-all');
								redraw_document();
						}						
			});
		});
		</script>
	<?php
	$data = ob_get_contents ();
	ob_end_clean();
	return $data;
	}
	//-----------------------------------------------------------------------------------------------------------------------------------------------	
	// Функция формирования скриптов и форм для экспорта
	//-----------------------------------------------------------------------------------------------------------------------------------------------
	function  Create_export($object_name,$type,$label,$XSL_FILE_OUT) {
	// Смотрим от кого экспортировать
	if ($type == "GRID_FORM_DETAIL")  {
		$export_grid = $this -> grid_main_name;
	 } else {
		$export_grid = $object_name;
	}
	?>
	<div id="export_<?=$object_name?>" title='Укажите формат экспорта:'>
							<label for="themefor">Тип экспорта:</label>
							<select id="select_export_<?=$object_name?>" name="select_export_<?=$object_name?>" >
	<?php
	if (!empty($XSL_FILE_OUT)) {
			echo "<option value='old' selected>Экспорт данных по шаблону</option>\n";	
			$ex_sel = "";
		} else {
			$ex_sel = "selected";
		}							
	?>
								<option value='xls' <?=$ex_sel?> >Формат Microsoft Office XP (.xls)</option>
								<option value='xlsx' >Формат Microsoft Office 2007 (.xlsx)</option>							
								<option value='csv' >Формат данных с разделителями (.csv)</option>
							</select><br><br>
							<input type='checkbox' id='export_filtered_<?=$object_name?>'>
								<label for='export_filtered_<?=$object_name?>' style='font-size:80%' >Применить фильтр и сортировку</label><br><br>						
							<div id="export_ajax_<?=$object_name?>" >
								<img src="<?=ENGINE_HTTP?>/library/ajax-loader.gif" style="padding-bottom: 4px; vertical-align: middle;" > Экспортирую...
							</div>
					</div>
					<script type="text/javascript">		
			$(function() {	
				// Диалог экспорта общий				
					$('#export_ajax_<?=$object_name?>').hide();
					$('#export_filtered_<?=$object_name?>').button({
							icons: { primary: 'ui-icon-search' }
							}).click(function() {
								var btn = $("#export_filtered_<?=$object_name?>");
								if (btn.attr("checked") != "checked") {
									btn.attr("checked","checked");
								} else {
									btn.removeAttr("checked");
								}
							});					
					$('#export_<?=$object_name?>').dialog({
						autoOpen: false,
						modal: true,
						minWidth:450,
						closeOnEscape: true,
						resizable:false,
						appendTo: $('#<?=$this->pageid?> .tab_main_content'),
						buttons: [	
							   {
								text: 'Экспортировать',
								click: function () {							
									$('#export_ajax_<?=$object_name?>').show();
									$('#btn_e_<?=$object_name?>').button('option', 'disabled', true );
									$('#btn_o_<?=$object_name?>').button('option', 'disabled', true );
									$.fileDownload('<?=ENGINE_HTTP?>/ajax.export.grid.php?isaexport=' + $('#select_export_<?=$object_name?>').val() + '&type=<?=$type?>&pageid=<?=$this ->pageid?>&id_mm_fr=<?=$this ->id_mm_fr?>&id_mm_fr_d=<?=$this ->id_mm_fr_d?>&id_mm=<?=$this ->id_mm?>&id=' + $('#<?=$export_grid?>').jqGrid('getGridParam', 'selrow') + '&filtred=' + $("#export_filtered_<?=$object_name?>").attr('checked') + export_post_data_<?=$object_name?>,
									{ 	
											encodeHTMLEntities: false,
											httpMethod:'GET',
											successCallback: function (responseHtml, url) {
													$('#export_ajax_<?=$object_name?>').hide();
													$('#btn_e_<?=$object_name?>').button('option', 'disabled', false );
													$('#btn_o_<?=$object_name?>').button('option', 'disabled', false );
													$('#export_<?=$object_name?>').dialog( 'close' );													
											},
											failCallback: function (responseHtml, url) {
													$('#export_ajax_<?=$object_name?>').hide();
													$('#btn_e_<?=$object_name?>').button('option', 'disabled', false );
													$('#btn_o_<?=$object_name?>').button('option', 'disabled', false );
													$('#export_<?=$object_name?>').dialog( 'close' );
													custom_alert("Ошибка выполнения экспорта!" + responseHtml);
											}
									});	
								  }
								},
								{
								text: 'Отмена',
								click: function () {
									$('#export_ajax_<?=$object_name?>').hide();
									$('#btn_e_<?=$object_name?>').button('option', 'disabled', false );
									$('#btn_o_<?=$object_name?>').button('option', 'disabled', false );
									$( this ).dialog( 'close' );
								}
							   }						
						],
						close:function() {							
							$('#export_ajax_<?=$object_name?>').hide();
							$('#btn_e_<?=$object_name?>').button('option', 'disabled', false );
							$('#btn_o_<?=$object_name?>').button('option', 'disabled', false );
							$( this ).dialog( 'close' );
						},
						open: function() {
								$('.ui-dialog-buttonpane').find('button:contains("Отмена")').button({icons: { primary: 'ui-icon-close'}}).prop('id','btn_o_<?=$object_name?>');
								$('.ui-dialog-buttonpane').find('button:contains("Экспортировать")').button({icons: { primary: 'ui-icon-disk'}}).prop('id','btn_e_<?=$object_name?>');
								$(this).parent().parent().children('.ui-widget-overlay').addClass('dialog_jqgrid_overlay ui-corner-all');
								redraw_document();
						}
					});	
					
							
				// для селекта экспорта	
				$("#select_export_<?=$object_name?>").multiselect({multiple: false, minWidth:300,header: false, selectedList: 1})
						.bind('multiselectclick multiselectcheckall multiselectuncheckall', function( event, ui ){
								var checkedValues = $.map($(this).multiselect('getChecked'), function( input ){
									return input.value;
								});
								if (checkedValues == 'old' ) {									
										$("#export_filtered_<?=$object_name?>").button( 'disable' );
								} else {										
										$("#export_filtered_<?=$object_name?>").button( 'enable' );
								}
				})
				.triggerHandler('multiselectclick'); 
				$('#<?=$object_name?>')
				// Добавляем кнопку экспорта
				.jqGrid('navSeparatorAdd','#Pager_<?=$object_name?>')
						.jqGrid('navGrid','#Pager_<?=$object_name?>').jqGrid('navButtonAdd','#Pager_<?=$object_name?>',{
											caption: 'Экспорт...',
											title: '<?=$label?>',
											buttonicon: 'ui-icon-disk',
											onClickButton : function (){
												$('#export_<?=$object_name?>').dialog( 'open' );
											}
						});
				});
			</script>
	<?php
	}
	
	static function get_about() {
		return "Модуль Таблиц и операции над ними";
	}
	
	// Конструктор
	function __construct($id_mm_fr, $id_mm_fr_d, $id_mm, $pageid, $grid_main_name) {
		$this -> db_conn = new db();		
		$this -> id_mm_fr = $id_mm_fr;
		$this -> id_mm_fr_d = $id_mm_fr_d;
		$this -> id_mm = $id_mm;
		$this -> pageid = $pageid;
		$this -> grid_main_name = $grid_main_name;
	}
	
	function __destruct() {
		$this-> db_conn ->__destruct();	
	}
} // END CLASS
?>