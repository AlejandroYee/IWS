// ==ClosureCompiler==
// @compilation_level SIMPLE_OPTIMIZATIONS
/**
* @license Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
* Based on jqgrid: https://github.com/tonytomov/jqGrid
* from jqgrid we need only modules:
* grid.base,
* grid.custom (setGridState,GridUnload,GridDestroy,clearBeforeUnload,sortGrid,setColProp,getColProp,destroyFrozenColumns,setGroupHeaders,destroyGroupHeader),
* grid.formedit (navSeparatorAdd,navButtonAdd,navGrid),
* grid.grouping,
* grid.treegrid,
* grid.jqueryui,
* grid.fmatter
*/
//jsHint options
/*jshint evil:true, eqeqeq:false, eqnull:true, devel:true */
/*global jQuery */
                
$.jgrid.extend({
editGridRow : function(rowid, p){
    p = $.extend(true, {
			modal: true,
			resize: true,
			mtype : "POST",
                        addedrow:'last',
			reloadAfterSubmit : true,
			beforeSubmit: null,
			afterSubmit: null,
			recreateForm : false,
			closeOnEscape : false,
			serializeEditData : null
		}, $.jgrid.edit, p || {});
    var grid = this;      
    CreateEditDialog = function(row_data){
        var colmodel  = grid.jqGrid('getGridParam', 'colModel');
        var col_names = grid.jqGrid('getGridParam', 'colNames');
        var tree      = grid.jqGrid('getGridParam', 'treeGrid');
        var form_id   = grid.attr('id');
            var form_html = $("<form />").attr({
                'name':'FormPost',
                'id':'editmod' + form_id,
                'onsubmit':'return false;',
                'style':'text-align: left;'
            });
            var form_table = $('<table />').attr({
                'id':'TblGrid_' + form_id,
                'class':'EditTable',
                'cellspacing':'0',
                'cellpadding':'0',
                'border':'0'
            });           
                        
            $('#dialog_editmod' + form_id).dialog('destroy').remove();

            // elemnts  
            $(colmodel).each( function(i) {  
                if (typeof(colmodel[i].editoptions) !== 'undefined') {  
                    var elem = '';
                    var edit_options = '';                    
                    
                   $.each(colmodel[i].editoptions, function(key, value) {
                       if (key !== "value") {
                                edit_options = edit_options + key + '="' + value +'" ';
                                if (key === "grouping_row" && value === "true") {
                                    colmodel[i].hidden = false;
                                }
                            }
                    });
                    if(!colmodel[i].editable) {
                        colmodel[i].hidden_tmp = true;
                    }    
                    if(colmodel[i].hidden) {
                        colmodel[i].hidden_tmp = true;
                    }   
                    if(!colmodel[i].edittype) {
                            colmodel[i].edittype = "text";
                    }
                    
                    switch (colmodel[i].edittype) {
                       case 'text':
                           elem = '<input class="FormElement ui-widget-content ui-corner-all" id="'+colmodel[i].index+'" name="'+colmodel[i].index+'" type="text" '+edit_options+' value="'+row_data[colmodel[i].index]+'" />';  
                       break;
                       case 'checkbox':
                           if (row_data[colmodel[i].index] === "1") {
                               edit_options = edit_options + 'checked="checked"';
                           }   
                           elem = '<input class="FormElement ui-widget-content ui-corner-all" id="'+colmodel[i].index+'" name="'+colmodel[i].index+'" type="checkbox" '+edit_options+' />';  
                       break;
                       case 'password':
                           elem = '<input class="FormElement ui-widget-content ui-corner-all" id="'+colmodel[i].index+'" name="'+colmodel[i].index+'" type="password" '+edit_options+' value="" />';  
                       break;
                       case 'textarea':
                           elem = '<textarea class="FormElement ui-widget-content ui-corner-all" id="'+colmodel[i].index+'" '+edit_options+' name="'+colmodel[i].index+'" >'+row_data[colmodel[i].index]+'</textarea>';  
                       break;                        
                       case 'select':
                           elem = '<select class="FormElement ui-widget-content ui-corner-all" id="'+colmodel[i].index+'" '+edit_options+' name="'+colmodel[i].index+'"  >';  
                            
                           $.each(colmodel[i].editoptions.value.split(';'), function(key, value) {
                               sel = ""; 
                               el = value.split(':');  
                                if (colmodel[i].editoptions.multiple) {
                                    val = row_data[colmodel[i].index].split(',');
                                    } else {
                                        if (typeof(row_data[colmodel[i].index]) !== "undefined") {
                                            val = row_data[colmodel[i].index].split('~|');
                                        }
                               }
                               $.each(val, function(keys, values) {
                                    if ($.trim(values) === $.trim(el[0])) {
                                         sel = "selected";
                                    } 
                               });
                               elem = elem + '<option value="'+el[0]+'" '+sel+'>'+el[1]+'</option>';
                            });
                           elem = elem + '</select>';
                       break;   
                    }                    
                    if (!colmodel[i].editoptions.title) {
                        colmodel[i].editoptions.title = '';
                    }
                    
                    table_elements = $('<tr />').attr({
                        'id':'tr_' + colmodel[i].index,
                        'class':'FormData',
                        'title': colmodel[i].editoptions.title,
                        'style': colmodel[i].hidden_tmp ? "display:none" : ""              
                    });        
                    
                    table_elements.append($('<td />').attr({'class':'CaptionTD','style':'width:150px;'}).append(col_names[i])); 
                    table_elements.append($('<td />').attr({'class':'DataTD'}).append(elem));                    
                    form_table.append(table_elements);
                }
             });  
             
                if ($.isFunction(create_from_table_elements)) {
                            if ($.isFunction(replace_select_opt_group)) {
                                   replace_select_opt_group(form_table);                
                            } 
                      var s_width = create_from_table_elements(form_table) + 200 + 60;
                } else {
                      var s_width = 450 + 200 + 60;                  
                }    
              
             form_html.append(form_table); 
             form_html.append('<input type="hidden" name="id" value="'+rowid+'"><input type="hidden" name="oper" value="edit">');
             bSubmit = $.jgrid.edit.bSubmit;
             bCancel = $.jgrid.edit.bCancel;             
             
             $('<div>').attr({
                 'id':'dialog_editmod' + grid.attr('id'),
                 'class':'FormElement ui-jqdialog-content'
             }).append(form_html).dialog({
		autoOpen: false,
		modal: false,
		minWidth: 450,
                width: s_width,
                appendTo: $(".ui-tabs-panel[aria-expanded='true']").children(".tab_main_content"),
		closeOnEscape: p.closeOnEscape,
		resizable: p.resize,
		buttons: [							 
			{text: bSubmit,
			 click: function() {
                             var dlg = $(this);
                             var searilezed = [];
                             $.each($('#editmod' + form_id).find("input, select, textarea"), function() {
                                 var obj = $(this);
                                 var grid_obj_name = grid.attr('for_object_db');
                                 var grid_index_row = '';
                                 if (obj.attr('name') !== undefined ){                                     
                                        if (obj.attr('row_type') === 'B') {
                                           searilezed[obj.attr('name')] = (obj.attr('checked') === 'checked')?1:0; 
                                        } else {
                                           searilezed[obj.attr('name')] = obj.val();
                                        }                                       
                                 }
                             }); 
                                searilezed =  $.extend({}, searilezed); //save as object
                                
                                 if (searilezed.id === "new") {
                                     searilezed.oper = "add";
                                     // trees
                                     if (tree) {                                         
                                         searilezed.ID_PARENT =  grid.jqGrid('getGridParam', 'selrow');
                                      }     
                                 }    
                                var execut = true;
                                    if ($.isFunction(p.serializeEditData) ) {                                        
                                          searilezed = p.serializeEditData.call(p,searilezed);
                                       }
                                       
                                    if ($.isFunction(p.beforeSubmit) ) {
                                       ret =  p.beforeSubmit.call(p,searilezed,$('#editmod' + form_id));                                   
                                       execut = typeof(ret)!== "undefined"?ret[0]:false;
                                    }                                    
                                    if (execut) {
                                        $('#btn_s_'+form_id).button('option', 'disabled', true );
                                        $('#btn_c_'+form_id).button('option', 'disabled', true );
                                        // save data
                                        $.ajax({
                                                url:  grid.jqGrid('getGridParam','editurl'),
                                                datatype:'json',
                                                data: searilezed,
                                                cache: false,
                                                type: p.mtype,
                                                   success: function(rets,jqXHR) {	
                                                      execut = true; 
                                                      var data ={};
                                                      data.statusText = jqXHR;
                                                      data.responseText = rets;
                                                      if ($.isFunction(p.afterSubmit) ) {
                                                        ret =  p.afterSubmit.call(p,data,searilezed,form_id);                                   
                                                        execut = typeof(ret) !== "undefined"?ret[0]:false;
                                                     }     
                                                     if (execut) {
                                                        //save data to grid  
                                                        if (searilezed.oper !== "add") { 
                                                               delete searilezed.oper;   
                                                               grid.jqGrid('setRowData',searilezed.id,searilezed);
                                                           } else {   
                                                                 delete searilezed.oper;
                                                                 delete searilezed.id;
                                                               var row_id_n = [];                                                               
                                                                   row_id_n[$('#editmod' + form_id).find("input[index_field='true']").attr('id')] = ret[2];
                                                                   searilezed =  $.extend(searilezed, row_id_n);                                                                   
                                                               if (tree) {                                                                    
                                                                    grid.jqGrid('addChildNode',ret[2],searilezed.ID_PARENT,searilezed);                                                                    
                                                               } else {
                                                                    grid.jqGrid('addRowData',ret[2],searilezed,p.addedrow); 
                                                               }
                                                        }
                                                        dlg.dialog( "close" );
                                                     }
                                                      $('#btn_s_'+form_id).button('option', 'disabled', false );
                                                      $('#btn_c_'+form_id).button('option', 'disabled', false );
                                                }	  
                                        });	
                                    }
                        }
                        },
                        {text: bCancel,
			 click: function() {
			    $( this ).dialog( "close" );
			}
                    }
                ],
		close:function() {			
                        $( this ).parent().parent().children('.ui-widget-overlay').remove();
                        $( this ).dialog( "close" );
		},
		open: function() {
                                var self = $(this).parent();
				self.children('.ui-dialog-buttonpane').find('button:contains("'+bCancel+'")').button({icons: { primary: 'ui-icon-close'}}).prop('id','btn_c_'+form_id);
				self.children('.ui-dialog-buttonpane').find('button:contains("'+bSubmit+'")').button({icons: { primary: 'ui-icon-disk'}}).prop('id','btn_s_'+form_id);
                                $($('<div />').attr({'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all','style':'position:absolute;z-index:99'})).prependTo(self.parent());
                                redraw_document();
		}
	});
    };
    
    
    var form_id = $('#editmod' + grid.attr('id')); 
    if (rowid !== "new") {
        var row_data = grid.jqGrid('getRowData', rowid);
    } else {    
        var row_data = [];
        var colmodel = grid.jqGrid('getGridParam', 'colModel');
        $(colmodel).each( function(i) {  
          if (typeof(colmodel[i].editoptions) !== 'undefined') {
            row_data[colmodel[i].index] = '';
        }  
        });
       row_data =  $.extend({}, row_data);
    }
    
    //check if form is created
    if (p.recreateForm || form_id.length  === 0) {
           CreateEditDialog(row_data);
    } else {
      // refresh values  
      form_id = $('#editmod' + grid.attr('id')); 
      $.each(row_data, function(key,val) {
        var obj_el = $('#' + key);
          if (obj_el.attr("row_type") === "SB") {
            obj_el.children('option').removeAttr('selected');
            if (obj_el.attr("multiple")) {
                val = val.split(',');
            } else {
                val = val.split('~|');
            }
            $.each(val, function(keys, values) {  
                obj_el.find("option[value='"+$.trim(values)+"']").attr('selected','');                
            });
          } else if (obj_el.attr("row_type") === "B") {              
              if (val === "1") {
                    obj_el.attr({'checked':'checked'});
              } else {
                    obj_el.removeAttr('checked');
              }
              
          } else {
             obj_el.val(val);
         }
         
      });
      if ($.isFunction(replace_select_opt_group)) {
               replace_select_opt_group(form_id);                
        } 
      if ($.isFunction(update_table_elemnts)) {
               update_table_elemnts(form_id);                
        } 
    }

    form_id.find('input[name="oper"]').val('edit');
    form_id.find('input[name="id"]').val(rowid);
    
    // open dialog    
    $('#dialog_editmod' + grid.attr('id')).dialog( "option", "title",p.editCaption).dialog("open");
    
},
viewGridRow : function(rowid, p){
    		p = $.extend(true, {			
			modal: false,
			resize: true,
			closeOnEscape : false,			
			viewPagerButtons : true
		}, $.jgrid.view, p || {});
        var grid = this;
        var s_width = 0;
        var colmodel  = grid.jqGrid('getGridParam', 'colModel');
        var col_names = grid.jqGrid('getGridParam', 'colNames');
        var form_id   = grid.attr('id');     
        var row_data  = grid.jqGrid('getRowData', rowid);
        
            var form_table = $('<table />').attr({
                'id':'TblGrid_' + form_id,
                'class':'EditTable',
                'cellspacing':'0',
                'cellpadding':'0',
                'border':'0'
            });         
            
            // elemnts  
            $(colmodel).each( function(i) {  
                if (typeof(colmodel[i].editoptions) !== 'undefined') { 
                                   
                    if(!colmodel[i].edittype) {
                            colmodel[i].edittype = "text";
                    }
                    
                    if(!colmodel[i].editable) {
                        colmodel[i].hidden = true;
                    }  
                    
                    var edit_options = 'disabled ';                   
                    
                   $.each(colmodel[i].editoptions, function(key, value) {
                       if (key !== "value") {
                           if (key === "w") {
                                if (parseInt(value) > s_width) {
                                       s_width = parseInt(value);
                                    }    
                               key="style";
                               value="width:"+value+"px;";
                            }
                                edit_options = edit_options + key + '="' + value +'" ';
                            }
                    });
                    switch (colmodel[i].edittype) {
                       case 'text':
                           elem = '<input class="FormElement ui-widget-content ui-corner-all"  type="text" '+edit_options+' value="'+row_data[colmodel[i].index]+'" />';  
                       break;
                       case 'checkbox':
                           if (row_data[colmodel[i].index] === "1") {
                               edit_options = edit_options + 'checked="checked"';
                           }   
                           elem = '<input class="FormElement ui-widget-content ui-corner-all" type="checkbox" '+edit_options+' />';  
                       break;
                       case 'password':
                           elem = '<input class="FormElement ui-widget-content ui-corner-all" type="password" '+edit_options+' value="" />';  
                       break;
                       case 'textarea':
                           elem = '<textarea class="FormElement ui-widget-content ui-corner-all" '+edit_options+'>'+row_data[colmodel[i].index]+'</textarea>';  
                       break;                        
                       case 'select':
                            case 'select':
                           elem = '<select class="FormElement ui-widget-content ui-corner-all"  '+edit_options+'  >';  
                            
                           $.each(colmodel[i].editoptions.value.split(';'), function(key, value) {
                               sel = ""; 
                               el = value.split(':');  
                                if (colmodel[i].editoptions.multiple) {
                                    val = row_data[colmodel[i].index].split(',');
                                    } else {
                                    val = row_data[colmodel[i].index].split('~|');
                               }
                               $.each(val, function(keys, values) {
                                    if ($.trim(values) === $.trim(el[0])) {
                                         sel = "selected";
                                    } 
                               });
                               elem = elem + '<option value="'+el[0]+'" '+sel+'>'+el[1]+'</option>';
                            });
                           elem = elem + '</select>';
                       break;   
                    } 
                    if (!colmodel[i].editoptions.title) {
                        colmodel[i].editoptions.title = '';
                    }
                    table_elements = $('<tr />').attr({
                        'id':'tr_' + colmodel[i].index,
                        'class':'FormData',
                        'title': colmodel[i].editoptions.title,
                        'style': colmodel[i].hidden ? "display:none" : ""              
                    });        
                    table_elements.append($('<td />').attr({'class':'CaptionTD','style':'width:150px;text-align:left;padding:5px;'}).append('<b>' + col_names[i] +'</b>')); 
                    table_elements.append($('<td />').attr({'class':'DataTD','style':'text-align:left;padding:5px;'}).append(elem)); 
                    form_table.append(table_elements);
                }
             });             
             $('<div>').attr({
                 'id':'dialog_viewmod' + grid.attr('id'),
                 'class':'FormElement ui-jqdialog-content'
             }).append(form_table).dialog({
		autoOpen: true,
		modal: false,
		minWidth: 350,
                appendTo: $(".ui-tabs-panel[aria-expanded='true']").children(".tab_main_content"),
                title: $.jgrid.view.caption,
		closeOnEscape: p.closeOnEscape,
		resizable: p.resize,
                width:s_width + 300,
		buttons: [
                        {text: $.jgrid.view.bClose,
			 click: function() {
			    $( this ).dialog( "close" );
			}
                    }
                ],
		close:function() {
                        $( this ).parent().parent().children('.ui-widget-overlay').remove();
			$( this ).dialog( "close" );
                        $( this ).dialog('destroy').remove();
		},
		open: function() {
                                var self = $(this).parent();
				self.children('.ui-dialog-buttonpane').find('button:contains("'+$.jgrid.view.bClose+'")').button({icons: { primary: 'ui-icon-close'}}).prop('id','btn_c_'+form_id);
				$($('<div />').attr({'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all','style':'position:absolute;z-index:99'})).prependTo(self.parent());
                                redraw_document();
		}
	});
},
delGridRow : function(rowids,p) {
    	p = $.extend(true, {			
			resize: true,			
			mtype : "POST"
		}, $.jgrid.del, p ||{});
    var grid = this;
    var form_id   = grid.attr('id');  
    if ($.isArray(rowids)) {rowids = rowids.join(',');}
    $('<div>').attr({
                 'id':'dialog_delmod' + grid.attr('id'),
                 'class':'FormElement ui-jqdialog-content'
             }).append($.jgrid.del.msg).dialog({
		autoOpen: true,
		modal: false,
		minWidth: 350,
                appendTo: $(".ui-tabs-panel[aria-expanded='true']").children(".tab_main_content"),
                title: $.jgrid.del.caption,
		closeOnEscape: p.closeOnEscape,
		resizable: p.resize,
		buttons: [
                        {text: $.jgrid.del.bSubmit,
			 click: function() {
                            var dlg =  $( this );
			    $('#btn_d_'+form_id).button('option', 'disabled', true );
                            $('#btn_c_'+form_id).button('option', 'disabled', true );
                            var  searilezed = {};
                                     searilezed.id = rowids;
                                     searilezed.oper = "del";
                             $.ajax({
                                                url:  grid.jqGrid('getGridParam','editurl'),
                                                datatype:'json',
                                                data: searilezed,
                                                cache: false,
                                                type: p.mtype,
                                                   success: function(rets,jqXHR) {    
                                                      
                                                      $.each(rowids.split(','), function(key, value) {
                                                          grid.jqGrid('delRowData',value);  
                                                       });                                                      
                                                      dlg.dialog( "close" );
                                                      $('#btn_d_'+form_id).button('option', 'disabled', false );
                                                      $('#btn_c_'+form_id).button('option', 'disabled', false );
                                                }	  
                                        });	
                             
                             
                             
                            }
                        },
                        {text: $.jgrid.del.bCancel,
			 click: function() {
			    $( this ).dialog( "close" );
			}
                    }
                ],
		close:function() {
                        $( this ).parent().parent().children('.ui-widget-overlay').remove();
			$( this ).dialog( "close" );
                        $( this ).dialog('destroy').remove();
		},
		open: function() {
                                var self = $(this).parent();
				self.children('.ui-dialog-buttonpane').find('button:contains("'+$.jgrid.del.bCancel+'")').button({icons: { primary: 'ui-icon-close'}}).prop('id','btn_c_'+form_id);
                                self.children('.ui-dialog-buttonpane').find('button:contains("'+$.jgrid.del.bSubmit+'")').button({icons: { primary: 'ui-icon-trash'}}).prop('id','btn_d_'+form_id);
				$($('<div />').attr({'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all','style':'position:absolute;z-index:99'})).prependTo(self.parent());
                                redraw_document();
		}
	});
},
columnChooser : function(opts) {
        var self = this;        
        if($("#colchooser_"+$.jgrid.jqID(self[0].p.id)).length ) { return; }
        var colModel = self.jqGrid("getGridParam", "colModel");
        var colNames = self.jqGrid("getGridParam", "colNames");
        var dlg = $('<div />').attr({
            'id':'colchooser_' + self[0].p.id,
            'style':'position:relative;overflow-y:enable'
        });
        
        var selector = $('<ol />').attr({
            'style':'list-style-type: none; margin: 0; padding: 0; width: 100%;'
        });
        
        selector.bind("mousedown", function(e) {
             e.metaKey = true;
        }).selectable({
            selected: function( event, ui ) {
                $(ui.selected).addClass('ui-state-active');                
            },
            unselected: function( event, ui ) {
                $(ui.unselected).removeClass('ui-state-active');
            }
        }); 
        
        $.each(colModel, function(i) { 
            if (this.hidedlg) {               
                return;
            }
            var li = $("<li />").attr({
                'value':i,
                'class':'ui-widget-content ui-state-default',
                'style':'margin: 3px; padding: 0.4em; font-size: 0.8em; height: 12px; text-align:left; cursor:pointer;'
            }).html(colNames[i].replace('<br>',' ').replace('<BR>',' '));
            
            if (!this.hidden) {
                li.addClass('ui-state-active').addClass('ui-selected');                
            }            
            selector.append(li); 
        });
        
        dlg.append(selector).dialog({
		autoOpen: true,
		modal: false,
                appendTo: $(".ui-tabs-panel[aria-expanded='true']").children(".tab_main_content"),
                title: $.jgrid.col.caption,
                width:opts.width,
                height:opts.height,
		resizable: true,
		buttons: [
                        {text: $.jgrid.col.bSubmit,
			 click: function() {
                              $.each(selector.find('li'), function(key, value) {
                                  var i = $(this).val();
                                    if ($(this).hasClass('ui-selected')) {
                                        self.jqGrid("showCol", colModel[i].name);
                                    } else {
                                        self.jqGrid("hideCol", colModel[i].name);
                                    }
                               });    
                               
                             $( this ).dialog( "close" );
                            }
                        },
                        {text: $.jgrid.col.bCancel,
			 click: function() {
			    $( this ).dialog( "close" );
			}
                    }
                ],
		close:function() {
                        $( this ).parent().parent().children('.ui-widget-overlay').remove();
			$( this ).dialog( "close" );
                        $( this ).dialog('destroy').remove();
                        redraw_document();
		},
		open: function() {
                                var self = $(this).parent();
				self.children('.ui-dialog-buttonpane').find('button:contains("'+$.jgrid.col.bCancel+'")').button({icons: { primary: 'ui-icon-close'}});
                                self.children('.ui-dialog-buttonpane').find('button:contains("'+$.jgrid.col.bSubmit+'")').button({icons: { primary: 'ui-icon-disk'}});
				$($('<div />').attr({'class':'ui-widget-overlay ui-front dialog_jqgrid_overlay ui-corner-all','style':'position:absolute;z-index:99'})).prependTo(self.parent());
                                redraw_document();
		}
	});        
},
filterToolbar : function(p){
		p = $.extend({
			autosearch: true,
			searchOnEnter : true,
			beforeSearch: null,
			afterSearch: null,
			beforeClear: null,
			afterClear: null,
			searchurl : '',
			stringResult: false,
			groupOp: 'AND',
			defaultSearch : "bw"
		},p  || {});
		return this.each(function(){
			var $t = this;
			var ext_name = $(this).parent().parent().parent().prop("id");
			var has_search = false;
			if(this.ftoolbar) { return; }			
			var triggerToolbar = function() {
				var sdata={}, j=0, v, nm, sopt={}, so;
				$.each($t.p.colModel,function(){
					nm = this.index || this.name;
					so  = (this.searchoptions && this.searchoptions.sopt) ? this.searchoptions.sopt[0] : this.stype=='select'?  'eq' : p.defaultSearch;
					v = $("#gs_" + ext_name + "_" + $.jgrid.jqID(this.name), (this.frozen===true && $t.p.frozenColumns === true) ?  $t.grid.fhDiv : $t.grid.hDiv).val();	
					has_search = true;
					if(v) {	
						if ($("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop("class") == " ui-icon  ui-icon-close") 
								$("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).attr({ 'class': " ui-icon  ui-icon-radio-off", title: "входит", value: "LIKE"});
						sdata[nm] = $("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).attr("value") + ">" + $("#gs_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop("value"); 
						sopt[nm] = so;
						j++;
					} else {
						try {
							delete $t.p.postData[nm];
						} catch (z) {}
					}
				});
				var sd =  j>0 ? true : false;
				if(p.stringResult === true || $t.p.datatype == "local") {
					var ruleGroup = "{\"groupOp\":\"" + p.groupOp + "\",\"rules\":[";
					var gi=0;
					$.each(sdata,function(i,n){
						if (gi > 0) {ruleGroup += ",";}
						ruleGroup += "{\"field\":\"" + i + "\",";
						ruleGroup += "\"op\":\"" + sopt[i] + "\",";
						n+="";
						ruleGroup += "\"data\":\"" + n.replace(/\\/g,'\\\\').replace(/\"/g,'\\"') + "\"}";
						gi++;
					});
					ruleGroup += "]}";
					$.extend($t.p.postData,{filters:ruleGroup});
					$.each(['searchField', 'searchString', 'searchOper'], function(i, n){
						if($t.p.postData.hasOwnProperty(n)) { delete $t.p.postData[n];}
					});
				} else {
					$.extend($t.p.postData,sdata);
				}
				var saveurl;
				if($t.p.searchurl) {
					saveurl = $t.p.url;
					$($t).jqGrid("setGridParam",{url:$t.p.searchurl});
				}
				var bsr = $($t).triggerHandler("jqGridToolbarBeforeSearch") === 'stop' ? true : false;
				if(!bsr && $.isFunction(p.beforeSearch)){bsr = p.beforeSearch.call($t);}
				if(!bsr) { $($t).jqGrid("setGridParam",{search:sd}).trigger("reloadGrid",[{page:1}]); }
				if(saveurl) {$($t).jqGrid("setGridParam",{url:saveurl});}
				$($t).triggerHandler("jqGridToolbarAfterSearch");
				if($.isFunction(p.afterSearch)){p.afterSearch.call($t);}
			};
			var clearToolbar = function(trigger){
				var sdata={}, j=0, nm;
				trigger = (typeof trigger != 'boolean') ? true : trigger;
				$.each($t.p.colModel,function(){
					var v;
					if(this.searchoptions && this.searchoptions.defaultValue !== undefined) { v = this.searchoptions.defaultValue; }					
					nm = this.index || this.name;
					$("#search_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop({ 'class': " ui-icon  ui-icon-close", title: "Неиспользуется", value: "NONE"});
					$("#gs_" + ext_name + "_" + $.jgrid.jqID(this.name)).prop({value: ""});
					switch (this.stype) {
						case 'select' :
							$("#gs_"+$.jgrid.jqID(this.name)+" option",(this.frozen===true && $t.p.frozenColumns === true) ?  $t.grid.fhDiv : $t.grid.hDiv).each(function (i){
								if(i===0) { this.selected = true; }
								if ($(this).val() == v) {
									this.selected = true;
									return false;
								}
							});
							if ( v !== undefined ) {
								// post the key and not the text
								sdata[nm] = v;
								j++;
							} else {
								try {
									delete $t.p.postData[nm];
								} catch(e) {}
							}
							break;
						case 'text':
							$("#gs_"+$.jgrid.jqID(this.name),(this.frozen===true && $t.p.frozenColumns === true) ?  $t.grid.fhDiv : $t.grid.hDiv).val(v);
							if(v !== undefined) {
								sdata[nm] = v;
								j++;
							} else {
								try {
									delete $t.p.postData[nm];
								} catch (y){}
							}
							break;
					}
				});
				var sd =  j>0 ? true : false;
				if(p.stringResult === true || $t.p.datatype == "local") {
					var ruleGroup = "{\"groupOp\":\"" + p.groupOp + "\",\"rules\":[";
					var gi=0;
					$.each(sdata,function(i,n){
						if (gi > 0) {ruleGroup += ",";}
						ruleGroup += "{\"field\":\"" + i + "\",";
						ruleGroup += "\"op\":\"" + "eq" + "\",";
						n+="";
						ruleGroup += "\"data\":\"" + n.replace(/\\/g,'\\\\').replace(/\"/g,'\\"') + "\"}";
						gi++;
					});
					ruleGroup += "]}";
					$.extend($t.p.postData,{filters:ruleGroup});
					$.each(['searchField', 'searchString', 'searchOper'], function(i, n){
						if($t.p.postData.hasOwnProperty(n)) { delete $t.p.postData[n];}
					});
				} else {
					$.extend($t.p.postData,sdata);
				}
				var saveurl;
				if($t.p.searchurl) {
					saveurl = $t.p.url;
					$($t).jqGrid("setGridParam",{url:$t.p.searchurl});
				}
				var bcv = $($t).triggerHandler("jqGridToolbarBeforeClear") === 'stop' ? true : false;
				if(!bcv && $.isFunction(p.beforeClear)){bcv = p.beforeClear.call($t);}
				if(!bcv) {
					if(trigger) {
						$($t).jqGrid("setGridParam",{search:sd}).trigger("reloadGrid",[{page:1}]);
					}
				}
				if(saveurl) {$($t).jqGrid("setGridParam",{url:saveurl});}
				$($t).triggerHandler("jqGridToolbarAfterClear");
				if($.isFunction(p.afterClear)){p.afterClear();}
			};
			var toggleToolbar = function(){
				var trow = $("tr.ui-search-toolbar",$t.grid.hDiv),
				// Показываем скрываем и перерасчитываем грид
				trow2 = $t.p.frozenColumns === true ?  $("tr.ui-search-toolbar",$t.grid.fhDiv) : false;
				if(trow.css("display")=='none') { 
					trow.show();
					$("#" + ext_name).children('.ui-jqgrid-bdiv').height($("#" + ext_name).children('.ui-jqgrid-bdiv').height() - 27);
					has_search = false;
					if(trow2) {
						trow2.show();
					}
				} else { 
					trow.hide();
					$("#" + ext_name).children('.ui-jqgrid-bdiv').height($("#" + ext_name).children('.ui-jqgrid-bdiv').height() + 27);
					if (has_search) clearToolbar();
					if(trow2) {
						trow2.hide();
					}
				}
			};
			// create the row
			function bindEvents(selector, events) {
				var jElem = $(selector);
				if (jElem[0]) {
					jQuery.each(events, function() {
						if (this.data !== undefined) {
							jElem.bind(this.type, this.data, this.fn);
						} else {
							jElem.bind(this.type, this.fn);
						}
					});
				}
			}
			var tr = $("<tr class='ui-search-toolbar' role='rowheader'></tr>");
			var timeoutHnd;
			$.each($t.p.colModel,function(){
				var cm=this, thd , th, soptions,surl,self;
				th = $("<th role='columnheader' class='ui-state-default ui-th-column ui-th-"+$t.p.direction+"'></th>");
				thd = $("<div style='text-align:left;position:relative;vertical-align:middle'></div>");				
				if(this.hidden===true) { $(th).css("display","none");}
				this.search = this.search === false ? false : true;
				if(typeof cm.formatter == 'undefined' ) {cm.formatter='text';}
				soptions = $.extend({},this.searchoptions || {});
				if(this.search){
					switch (cm.formatter)
					{
					case "select":
						surl = this.surl || soptions.dataUrl;
						if(surl) {
							// data returned should have already constructed html select
							// primitive jQuery load
							self = thd;
							$.ajax($.extend({
								url: surl,
								dataType: "html",
								success: function(res) {
									if(soptions.buildSelect !== undefined) {
										var d = soptions.buildSelect(res);
										if (d) { $(self).append(d); }
									} else {
										$(self).append(res);
									}
									if(soptions.defaultValue !== undefined) { $("select",self).val(soptions.defaultValue); }
									$("select",self).prop({name:cm.index || cm.name, id: "gs_" + ext_name + "_" + cm.name});
									$("select",self).css('float','left').css('padding-left','15px');
									$("select",self).prop('class','ui-state-default');
									if(soptions.prop) {$("select",self).prop(soptions.prop);}
									$("select",self).css({width: "100%"});									
									// preserve autoserch
									if(soptions.dataInit !== undefined) { soptions.dataInit($("select",self)[0]); }
									if(soptions.dataEvents !== undefined) { bindEvents($("select",self)[0],soptions.dataEvents); }
									if(p.autosearch===true){
										$("select",self).change(function(){
											triggerToolbar();
											return false;
										});
									}
									res=null;
								}
							}, $.jgrid.ajaxOptions, $t.p.ajaxSelectOptions || {} ));
						} else {
							var oSv, sep, delim;
							if(cm.searchoptions) {
								oSv = cm.searchoptions.value === undefined ? "" : cm.searchoptions.value;
								sep = cm.searchoptions.separator === undefined ? ":" : cm.searchoptions.separator;
								delim = cm.searchoptions.delimiter === undefined ? ";" : cm.searchoptions.delimiter;
							} else if(cm.editoptions) {
								oSv = cm.editoptions.value === undefined ? "" : cm.editoptions.value;
								sep = cm.editoptions.separator === undefined ? ":" : cm.editoptions.separator;
								delim = cm.editoptions.delimiter === undefined ? ";" : cm.editoptions.delimiter;
							}
							if (oSv) {	
								var elem = document.createElement("select");
								elem.style.width = "100%";
								$(elem).prop({name:cm.index || cm.name, id: "gs_" + ext_name + "_" + cm.name});																								
								var so, sv, ov;
								if(typeof oSv === "string") {
									so = oSv.split(delim);
									for(var k=0; k<so.length;k++){
										sv = so[k].split(sep);
										ov = document.createElement("option");
										ov.value = sv[0]; ov.innerHTML = sv[1];
										elem.appendChild(ov);
									}
								} else if(typeof oSv === "object" ) {
									for ( var key in oSv) {
										if(oSv.hasOwnProperty(key)) {
											ov = document.createElement("option");
											ov.value = key; ov.innerHTML = oSv[key];
											elem.appendChild(ov);
										}
									}
								}
								if(soptions.defaultValue !== undefined) { $(elem).val(soptions.defaultValue); }
								if(soptions.prop) {$(elem).prop(soptions.prop);}
								if(soptions.dataInit !== undefined) { soptions.dataInit(elem); }
								if(soptions.dataEvents !== undefined) { bindEvents(elem, soptions.dataEvents); }								
								$(thd).append(elem);							
								replace_select_opt_group($(thd));
                                                                
                                                                // remove double empty section
                                                                if($(thd).find('option:empty').length > 1) {
                                                                    $(thd).find('option:empty:first').remove();
                                                                }    
                                                                
								$(thd).children('select').multiselect({
									multiple: cm.editoptions.multiple === undefined ? false :  cm.editoptions.multiple,
									minWidth: cm.width,
									header:false,
									selectedList: cm.editoptions.size === undefined ? 1 :  cm.editoptions.size
									}).css('padding','0.3em');
								if(p.autosearch===true){
									$(elem).change(function(){
										triggerToolbar();
										return false;
									});
								}
							}
						}
					break;
					case 'checkbox':
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";						
						$(thd).append("<input type='checkbox' class='ui-widget ui-widget-content ui-corner-all' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' value=''/>");						
						$(thd).css('text-align','center'); 
						$(thd).children('input').before("<label for='gs_"+ ext_name + "_" + cm.name+"'>Включено или выключено</label>")
										        .button({icons: { primary: "ui-icon-check" },text: false})
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						if(p.autosearch===true){
							$("input",thd).click(function() {							
								if ($("input",thd).prop("value") == "1" ) {
										$("input",thd).prop({value: "0"});										
								} else {
										$("input",thd).prop({value: "1"});
								}
								triggerToolbar();
							});
						}
						break;
					case 'date':
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";
						$(thd).append("<input type='text' style='width:95%;padding-left:15px;' class='FormElement ui-widget ui-widget-content ui-corner-all' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' value='"+df+"'/>");						
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						$("input",thd).datetimepicker({ changeYear: true, firstDay: 1, timeFormat :"HH:mm:ss"});
						if(p.autosearch===true){
							if(p.searchOnEnter) {
								$("input",thd).keypress(function(e){
									var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;														
									if(key == 13){
										triggerToolbar();
										return false;
									}
									return this;
								});
							} else {
								$("input",thd).keydown(function(e){
									var key = e.which;														
									switch (key) {
										case 13:
											return false;
										case 9 :
										case 16:
										case 37:
										case 38:
										case 39:
										case 40:
										case 27:
											break;
										default :
											if(timeoutHnd) { clearTimeout(timeoutHnd); }
											timeoutHnd = setTimeout(function(){triggerToolbar();},500);
									}
								});
							}
						}
						break;
					case 'number':
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";						
						$(thd).append("<input type='text' class='FormElement' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' style='float:left;width:93%;' value='"+df+"'/>");						
						$(thd).children('input').spinner({numberFormat: 'n2', culture: 'ru-RU', step: 1 }).css({'width':'95%','padding-left':'15px'});
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}							
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						if(p.autosearch===true){
							if(p.searchOnEnter) {
								$("input",thd).keypress(function(e){
									var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;															
									if(key == 13){
										triggerToolbar();
										return false;
									}
									return this;
								});
							} else {
								$("input",thd).keydown(function(e){
									var key = e.which;														
									switch (key) {
										case 13:
											return false;
										case 9 :
										case 16:
										case 37:
										case 38:
										case 39:
										case 40:
										case 27:
											break;
										default :
											if(timeoutHnd) { clearTimeout(timeoutHnd); }
											timeoutHnd = setTimeout(function(){triggerToolbar();},500);
									}
								});
							}
						}
						break;
					default:
						var df = soptions.defaultValue !== undefined ? soptions.defaultValue: "";						
						$(thd).append("<input type='text' style='width:95%;padding-left:15px;' class='FormElement ui-widget ui-widget-content ui-corner-all' name='"+(cm.index || cm.name)+"' id='gs_"+ ext_name + "_" + cm.name+"' value='"+df+"'/>");						
						if(soptions.prop) {$("input",thd).prop(soptions.prop);}						
						if(soptions.dataInit !== undefined) { soptions.dataInit($("input",thd)[0]); }
						if(soptions.dataEvents !== undefined) { bindEvents($("input",thd)[0], soptions.dataEvents); }
						if(p.autosearch===true){
							if(p.searchOnEnter) {
								$("input",thd).keypress(function(e){
									var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;															
									if(key == 13){
										triggerToolbar();
										return false;
									}
									return this;
								});
							} else {
								$("input",thd).keydown(function(e){
									var key = e.which;														
									switch (key) {
										case 13:
											return false;
										case 9 :
										case 16:
										case 37:
										case 38:
										case 39:
										case 40:
										case 27:
											break;
										default :
											if(timeoutHnd) { clearTimeout(timeoutHnd); }
											timeoutHnd = setTimeout(function(){triggerToolbar();},500);
									}
								});
							}
						}
						break;
					}
				}
				
				// Добавляем иконки и спан для передачи типа поиска
				if ((cm.name !== 'rn') && ( cm.formatter !== "checkbox") && ( cm.formatter !== "select")) {					
					thd.append($("<span />").attr({
							'class':' ui-icon  ui-icon-close',
							id:'search_' + ext_name + '_' + cm.name,
							style: 'float:left;top:3px;position: absolute; cursor: pointer;',
							title:'Неиспользуется',
							value:'NONE'
						}));
						
						$("span.ui-icon",thd).click(function() {
							if ($(this).prop("class") == " ui-icon  ui-icon-close") { $(this).attr({ 'class': " ui-icon  ui-icon-notice", title: "Неравно", value: "NOT"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-notice") { $(this).attr({ 'class': " ui-icon  ui-icon-carat-1-e", title: "Больше", value: "MORE"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-carat-1-e") { $(this).attr({ 'class': " ui-icon  ui-icon-carat-1-w", title: "Меньше", value: "MINI"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-carat-1-w") { $(this).attr({ 'class': " ui-icon  ui-icon-grip-solid-horizontal", title: "Равно", value: "EQUAL"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-grip-solid-horizontal") { $(this).attr({ 'class': " ui-icon  ui-icon-radio-off", title: "входит", value: "LIKE"});
							} else if ($(this).prop("class") == " ui-icon  ui-icon-radio-off") $(this).attr({ 'class': " ui-icon  ui-icon-close", title: "Неиспользуется", value: "NONE"});
							
					});
				}
				$(th).append(thd);
				$(tr).append(th);
			});
			$("table thead",$t.grid.hDiv).append(tr);
			this.ftoolbar = true;
			this.triggerToolbar = triggerToolbar;
			this.clearToolbar = clearToolbar;
			this.toggleToolbar = toggleToolbar;
			// Скрываем по умолчанию тулбар поиска
			toggleToolbar();
		});
		
	},
        setFrozenColumns : function () {
		return this.each(function() {
			if ( !this.grid ) {return;}
			var $t = this, cm = $t.p.colModel,i=0, len = cm.length, maxfrozen = -1, frozen= false;
			if($t.p.subGrid === true || $t.p.treeGrid === true)
			{
				return;
			}
			
			if($t.p.rownumbers) { i++; }
			if($t.p.multiselect) { i++; }
			
			while(i<len)
			{
				if(cm[i].frozen === true)
				{
					frozen = true;
					maxfrozen = i;
				} else {
					break;
				}
				i++;
			}
			if( maxfrozen>=0 && frozen) {				
				$t.grid.fhDiv = $('<div style="position:absolute;left:0px;" class="frozen-div ui-state-default ui-jqgrid-hdiv"></div>');
				$t.grid.fbDiv = $('<div style="position:absolute;overflow:hidden;left:0px;" class="frozen-bdiv ui-jqgrid-bdiv"></div>');
				$("#gview_"+$.jgrid.jqID($t.p.id)).append($t.grid.fhDiv);
				var htbl = $(".ui-jqgrid-htable","#gview_"+$.jgrid.jqID($t.p.id)).clone(true);
				if($t.p.groupHeader) {
					$("tr.jqg-first-row-header, tr.jqg-third-row-header", htbl).each(function(){
						$("th:gt("+maxfrozen+")",this).remove();
					});
					var swapfroz = -1, fdel = -1, cs, rs;
					$("tr.jqg-second-row-header th", htbl).each(function(){
						cs= parseInt($(this).attr("colspan"),10);
						rs= parseInt($(this).attr("rowspan"),10);
						if(rs) {
							swapfroz++;
							fdel++;
						}
						if(cs) {
							swapfroz = swapfroz+cs;
							fdel++;
						}
						if(swapfroz === maxfrozen) {
							return false;
						}
					});
					if(swapfroz !== maxfrozen) {
						fdel = maxfrozen;
					}
					$("tr.jqg-second-row-header", htbl).each(function(){
						$("th:gt("+fdel+")",this).remove();
					});
				} else {
					$("tr",htbl).each(function(){
						$("th:gt("+maxfrozen+")",this).remove();
					});
				}
				$(htbl).width(1);
				$($t.grid.fhDiv).append(htbl)
				.mousemove(function (e) {
					if($t.grid.resizing){ $t.grid.dragMove(e);return false; }
				});
                                $($t).bind('jqGridResizeStop.setFrozenColumns', function (e, w, index) {
					var rhth = $(".ui-jqgrid-htable",$t.grid.fhDiv);
					$("th:eq("+index+")",rhth).width( w ); 
					var btd = $(".ui-jqgrid-btable",$t.grid.fbDiv);
					$("tr:first td:eq("+index+")",btd).width( w ); 
                                        redraw_document($(".ui-tabs-panel[aria-expanded='true']"));
				});
				$($t).bind('jqGridSortCol.setFrozenColumns', function (e, index, idxcol) {

					var previousSelectedTh = $("tr.ui-jqgrid-labels:last th:eq("+$t.p.lastsort+")",$t.grid.fhDiv), newSelectedTh = $("tr.ui-jqgrid-labels:last th:eq("+idxcol+")",$t.grid.fhDiv);

					$("span.ui-grid-ico-sort",previousSelectedTh).addClass('ui-state-disabled');
					$(previousSelectedTh).attr("aria-selected","false");
					$("span.ui-icon-"+$t.p.sortorder,newSelectedTh).removeClass('ui-state-disabled');
					$(newSelectedTh).attr("aria-selected","true");
					if(!$t.p.viewsortcols[0]) {
						if($t.p.lastsort !== idxcol) {
							$("span.s-ico",previousSelectedTh).hide();
							$("span.s-ico",newSelectedTh).show();
						}
					}
				});				
				$("#gview_"+$.jgrid.jqID($t.p.id)).append($t.grid.fbDiv);
				$($t.grid.bDiv).scroll(function () {
					$($t.grid.fbDiv).scrollTop($(this).scrollTop());
				});
				if($t.p.hoverrows === true) {
					$("#"+$.jgrid.jqID($t.p.id)).unbind('mouseover').unbind('mouseout');
				}
				$($t).bind('jqGridAfterGridComplete.setFrozenColumns', function () {
					$("#"+$.jgrid.jqID($t.p.id)+"_frozen").remove();
					$($t.grid.fbDiv).height($($t.grid.bDiv).height()-16);
					var btbl = $("#"+$.jgrid.jqID($t.p.id)).clone(true);
					$("tr[role=row]",btbl).each(function(){
						$("td[role=gridcell]:gt("+maxfrozen+")",this).remove();
					});

					$(btbl).width(1).attr("id",$t.p.id+"_frozen");
					$($t.grid.fbDiv).append(btbl);
					if($t.p.hoverrows === true) {
						$("tr.jqgrow", btbl).hover(
							function(){ $(this).addClass("ui-state-hover"); $("#"+$.jgrid.jqID(this.id), "#"+$.jgrid.jqID($t.p.id)).addClass("ui-state-hover"); },
							function(){ $(this).removeClass("ui-state-hover"); $("#"+$.jgrid.jqID(this.id), "#"+$.jgrid.jqID($t.p.id)).removeClass("ui-state-hover"); }
						);
						$("tr.jqgrow", "#"+$.jgrid.jqID($t.p.id)).hover(
							function(){ $(this).addClass("ui-state-hover"); $("#"+$.jgrid.jqID(this.id), "#"+$.jgrid.jqID($t.p.id)+"_frozen").addClass("ui-state-hover");},
							function(){ $(this).removeClass("ui-state-hover"); $("#"+$.jgrid.jqID(this.id), "#"+$.jgrid.jqID($t.p.id)+"_frozen").removeClass("ui-state-hover"); }
						);
					}
					btbl=null;
				});
				if(!$t.grid.hDiv.loading) {
					$($t).triggerHandler("jqGridAfterGridComplete");
				}
				$t.p.frozenColumns = true;                                
			}
		});
	}
}); 