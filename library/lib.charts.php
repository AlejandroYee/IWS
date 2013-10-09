<?php
/*
* Autor Andrey Lysikov (C) 2013
* icq: 454169
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
// Вывод данных для графиков
//--------------------------------------------------------------------------------------------------------------------------------------------
class CHART extends DATA_FORM {
var $id_mm_fr, $pageid, $main_db;

	// Создаем график
	function create_chart() {
			$query = $this -> main_db -> sql_execute("select tf.owner, tf.object_name, tf.name chart_label, decode(tf.chart_x,0,1000,nvl(tf.chart_x, 1000)) chart_x, decode(tf.chart_y,0,350,nvl(tf.chart_y, 350)) chart_y, t.name, t.num, ct.name chart_name, ct.type_chart type_chart, t.is_read_only show_values
												  from ".DB_USER_NAME.".wb_mm_form tf left join ".DB_USER_NAME.".wb_form_field t on t.id_wb_mm_form = tf.id_wb_mm_form left join ".DB_USER_NAME.".wb_form_field_align ta on ta.id_wb_form_field_align = t.id_wb_form_field_align
												  left join ".DB_USER_NAME.".wb_chart_type ct on ct.id_wb_chart_type = tf.id_wb_chart_type where tf.id_wb_mm_form = ".$this -> id_mm_fr." order by t.num");
						
			while ($this -> main_db -> sql_fetch($query)) {
								$chart_X        = $this -> main_db -> sql_result($query, "CHART_X");
								$chart_Y        = $this -> main_db -> sql_result($query, "CHART_Y");								
								$chart_label    = $this -> main_db -> sql_result($query, "CHART_LABEL");
								$chart_name     = $this -> main_db -> sql_result($query, "CHART_NAME");
								$chartId		= $this -> pageid ."_chart_". $this -> main_db -> sql_result($query, "ID");
								$url = "ajax.data.chart.php?id=".$this -> id_mm_fr."";
			}
						
			return "<div id='".$chartId."_div_".$this -> pageid."' name='".$chartId."_".$this -> pageid."' schart_name='".$chart_name."' x='".$chart_X."' y='".$chart_Y."' label='".$chart_label."' url = 'ajax.data.chart.php?id=".$this -> id_mm_fr."' class='chart_data_".$this -> pageid."' align=\"center\">
				  </div>";
	}
	
	// Конструктор
	function __construct($id_mm_fr, $pageid) {
		$this -> main_db = new DB();
		$this -> id_mm_fr = $id_mm_fr;
		$this -> pageid = $pageid;
	}
	
	function __destruct() {
		$this-> main_db ->__destruct();				
	}
	
	static function get_about() {
		return "Графики FLASH и HTML5";
	}
	
	// Процедура запуска графиков:
	function set_script() {
	// Скрипт обвязки графиков:
	return "
		<script type='text/javascript'>
		$(function() {		
		
		if ($('.chart_data_".$this -> pageid.":first').parent().children('.grid_resizer').attr('percent') > 0) {
			var perch = 100 - $('.chart_data_".$this -> pageid.":first').parent().children('.grid_resizer').attr('percent');			
			$('<div class=\"grid_resizer has_resize_control chart_".$this -> pageid."\" percent=\"' + perch + '\"><div class=\"chart_content_".$this -> pageid."\"> </div></div>').insertBefore('.chart_data_".$this -> pageid.":first');		
			$('.chart_data_".$this -> pageid."').appendTo(\".chart_content_".$this -> pageid."\");			
			set_resizers();			
		}
			redraw_document();
			//Таймер ввода данных
			var chart_".$this -> pageid."_intval = setInterval(function() {
				if( data_".$this -> pageid."_loaded > 0 ) {
					// Просматриваем графики на странице:			
					$.each( $('.chart_data_".$this -> pageid."') , function() {
							var self = $(this);
							// Заполняем графки						
							$.get(self.attr('url'),function(data) {
								var chart_".$this -> pageid." = new FusionCharts(self.attr('swf'),self.attr('label'), self.attr('x'), self.attr('y'));
								chart_".$this -> pageid.".setTransparent(\"transparent\"); 
								chart_".$this -> pageid.".setDataXML(data);
								chart_".$this -> pageid.".render(self.attr('id'));	
								self.children().attr('id',self.attr('name'));	
							});	
							self.parent().css('overflow-y','auto');
					});
				clearInterval(chart_".$this -> pageid."_intval);
				}
			}, 1000);		
		});
		</script>";	
	}
} // END CLASS		
?>