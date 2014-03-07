/*
Файл обновления БД с версии 2.0.4 до версии 2.1.0
*/
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR DISABLE;
update WB_FORM_FIELD t set t.fl_html_code = null;
alter table WB_FORM_FIELD rename column fl_html_code to ELEMENT_ALT;
alter table WB_FORM_FIELD modify element_alt varchar2(2000) default null;
alter table WB_MM_FORM drop column html_img;
delete from wb_form_field t where t.id_wb_form_field < 0 and t.field_name = 'HTML_IMG';
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-188, -7, 6, 'Пароль', 'PASSWORD', null, null, 1, 'P', 0, null, 150, null, null, null, 0, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-189, -4, 13, 'Подсказка к полю', 'ELEMENT_ALT', null, null, 1, 'S', 0, null, 250, null, null, null, 0, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (-1, null, 3, 'Версия БД', 'ROOT_DB_VERSION', '2.1.0', 1, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
update wb_form_field t set t.element_alt =    
   case t.field_name
         when 'PASSWORD' then               'Пароль пользователь при использовании модуля аунтификации auth.user'
         when 'XLS_POSITION_ROW' then       'Положение по вертикали вставляемого поля в файл при экспорте либо печати документа'
         when 'HEIGHT_RATE' then            'Высота формы на странице, в случае если форма одна то можно незаполнять либо указать 100%, если форм несколько, то необходимо заполнить в процентном соотношении от остальных форм'
         when 'EDIT_BUTTON' then            'Кнопки которые будут отражены под таблицей, по необходимости вы можете контролировать что можно делать с выделенной строкой'
         when 'XSL_FILE_IN' then            'Имя выходного файла при экспорте документа, либо шаблон на основе которого сформируется файл для экспорта. поддерживается формат xlsm с макросами'
         when 'CHART_SHOW_NAME' then        'Показывать или нет названия графика и его заголовок'
         when 'CHART_Y' then                'Высота графика в пикселях'
         when 'CREATE_DATE' then            'Дата создания записи в БД'
         when 'TYPE_CHART' then             'Тип графика, в зависимости от типа можно добавлять разные элементы на графике'
         when 'XLS_POSITION_COL' then       'Положение по горизонтали вставляемого поля в файл при экспорте либо печати документа'
         when 'FIELD_TYPE' then             'Тип столбца данных, в случае если это список то необходимо заполнить поле SQL Блок/Текст поля для того чтобы получить данны для списка. Принимаемые значения: id, name'
         when 'USED' then                   'Флаг определяющий можно ли использовать данную форму пользователям или нет, если нет то данная форма не будет видна и доступ к ней блокируется'
         when 'WB_NAME' then                'Логин пользователя для доступа к системе'
         when 'DESCRIPTION' then            'Описание типа графиков, что может сделать и как'
         when 'CHART_X' then                'Длина графика в пикселях'
         when 'WIDTH' then                  'Длина элемента в пикселях, на основе длины строится диалоговые окна изменения и просмотра'
         when 'CREATE_USER' then            'Пользователь создавший запись в БД'
         when 'LAST_USER' then              'Пользователь последний изменивший запись в БД'
         when 'ARRAY_NAME' then             'Наименование массива либо переменной для биндинга и дальнейшего использования, заполняется без первого символа ":". В последующих столбцах ее можно использовать для динамического получения списка либо обновления какого либо поля'
         when 'IS_REQURED' then             'Данное поля обязательно или нет для заполнения при редактировании записи'
         when 'TYPE_CELLS' then             'Позиция ячейки в файле экспорта'
         when 'PARAM_VIEW' then             'Служебное поле с параметрами пользователя'
         when 'FORM_WHERE' then             'Поле для выполения каких либо действий в системе, например выполнение команды после загрузки файла'
         when 'COUNT_ELEMENT' then          'Высота элемента, применима только к типу поля "Многострочный текст" и "Выпадающий список"'
         when 'IS_READ_ONLY' then           'Данный столбец или элемент недоступен для изменения либо удаления'
         when 'ACTION_SQL' then             'Блок выполняемый в зафисимости от типа формы, может содержать забиндиные переменные. Внутри обязательно нужно указывать схемы вызываемых обьектов если не указана схема в нижнем поле'
         when 'NUM' then                    'Порядковый номер отображения и использования элемента на странице либо в таблице, важно чтобы номера не пересекались!'
         when 'LAST_DATE' then              'Дата последнего изменения записи в БД'
         when 'PHONE' then                  'Телефон пользователя'
         when 'E_MAIL' then                 'Электронная почта пользователя'
         when 'NAME' then                   'Отображаемое имя элемента'
		 when 'AUTO_UPDATE' then            'Автоматическое обновление формы через определенный промежуток времени'	
		 when 'ID_WB_MAIN_MENU_VIEW_TREE' then            'Главное меню к которому привязывается форма или элемент'		
		 when 'ID_WB_FORM_TYPE' then        'Тип формы, на одной странице их может быть несколько, важно соблюдать порядок форм иначе будут ошибки отображения и логики'		
		 when 'ID_WB_CHART_TYPE' then       'Тип графика, используется только когда тип формы выбран как "График"'	
         when 'FIELD_TXT' then              'SQL Блок который позволяет заполнить данными элемент в случает "Выпадающего списка" можно использовать переменную :rowid для того чтобы подставить либо текущий выделенный rowid элемента  либо rowid ведущей формы если данный элемент принадлежит ведомой форме. Также позволяет использовать значение из выше стоящего поля, биндить можно по названию поля в БД'
         when 'OWNER' then                  'Схема в БД в которой находится элемент и в которой будут выполены все sql блоки касаемо данного элемента'
         when 'OBJECT_NAME' then            'Обьект в БД с привязкой к схеме для которого создается форма.'
         when 'CHART_ROTATE_NAME' then      'Если указато то шкалы в графике будут повернуты на 90 градусов вокруг своей оси'
         when 'SHORT_NAME' then             'Короткое имя переменной кторое будет использоваться в дальнейшем в БД'
         when 'FIELD_NAME' then             'Поле в обьекте БД которое будет привязано к данному элементу, также оно будет доступно как переменная для дальшейших полей для значений на основе значений данного обьекта'
         else
             null
      end        where t.id_wb_form_field < 0;
create or replace view wb_form_field_ as
select t.id_wb_mm_form,
       t.num,
       t.name,
       t.field_name,
       t.id_wb_form_field_align,
       t.xls_position_col,
       t.xls_position_row,
       t.element_alt,
       t.field_type
  from wb_form_field t;
create or replace force view wb_form_field_view as
select t.id_wb_form_field id_wb_form_field_view,
       t.id_wb_mm_form    id_wb_mm_form_view,
       t.num,
       t.name,
       t.field_name,
       t.array_name,
       t.field_txt,
       t.id_wb_form_field_align,
       trim(t.field_type) field_type,
       t.is_read_only,
       t.count_element,
       t.width,
       t.xls_position_col,
       t.xls_position_row,
       t.is_requred,
       t.element_alt,
       t.create_user,
       t.create_date,
       t.last_user,
       t.last_date
  from wb_form_field t
  order by t.num, t.name;
create or replace force view wb_mm_form_view as
select t.id_wb_mm_form id_wb_mm_form_view,
       t.id_wb_main_menu id_wb_main_menu_view_tree,
	     t.id_wb_main_menu id_wb_main_menu_view_tree_usv,
       t.num,
       t.name,
       t.id_wb_form_type,
       t.action_sql,
       t.object_name,
       t.xsl_file_in,
       nvl(t.auto_update,0) auto_update,
       t.create_user,
       t.create_date,
       t.last_user,
       t.last_date,
       t.form_where,
       t.id_wb_chart_type,
       t.is_read_only,
       t.chart_show_name,
       t.action_bat,
       t.chart_rotate_name,
       t.chart_x,
	   t.form_order,
       t.chart_y,
       t.chart_dec_prec,
       t.height_rate,
       t.edit_button,
       t.owner
  from wb_mm_form t
  where wb.get_access_main_menu(t.id_wb_main_menu) = 'enable'
  order by t.num, t.name;
CREATE OR REPLACE TRIGGER T_I_IUD_WB_FORM_FIELD_VIEW
INSTEAD OF INSERT OR UPDATE OR DELETE
ON WB_FORM_FIELD_VIEW
FOR EACH ROW
DECLARE
  l_id       number := :old.id_wb_form_field_view;
BEGIN
  if INSERTING then
    insert into wb_form_field(id_wb_form_field,id_wb_mm_form,num,name,field_name,field_txt,id_wb_form_field_align,field_type,
                             is_read_only,count_element,width,xls_position_col,xls_position_row,is_requred,element_alt)
      values (null,:new.id_wb_mm_form_view,:new.num,:new.name,:new.field_name,:new.field_txt,:new.id_wb_form_field_align,:new.field_type,
              :new.is_read_only,:new.count_element,:new.width,:new.xls_position_col,:new.xls_position_row,:new.is_requred,:new.element_alt)
                             RETURNING id_wb_form_field INTO l_id;

  dbms_session.set_context('CLIENTCONTEXT', 'rowid',l_id );

  elsif UPDATING then
    update wb_form_field ff set
      ff.id_wb_mm_form          = :new.id_wb_mm_form_view,
      ff.num                    = :new.num,
      ff.name                   = :new.name,
      ff.field_name             = :new.field_name,
      ff.field_txt              = :new.field_txt,
      ff.id_wb_form_field_align = :new.id_wb_form_field_align,
      ff.field_type             = :new.field_type,
      ff.is_read_only           = :new.is_read_only,
      ff.count_element          = :new.count_element,
      ff.width                  = :new.width,
      ff.xls_position_col       = :new.xls_position_col,
      ff.xls_position_row       = :new.xls_position_row,
      ff.is_requred             = :new.is_requred,
      ff.element_alt           = :new.element_alt
      where ff.id_wb_form_field = l_id;
  else
    delete
      from wb_form_field ff
      where ff.id_wb_form_field = l_id;
  end if;
END;
/
CREATE OR REPLACE TRIGGER "T_I_IUD_WB_MM_FORM_VIEW"
INSTEAD OF INSERT OR UPDATE OR DELETE
ON WB_MM_FORM_VIEW
FOR EACH ROW
DECLARE
  l_id number := :old.id_wb_mm_form_view;
  n_id number := :new.id_wb_main_menu_view_tree;
begin
  if l_id is null then
     l_id := :old.id_wb_main_menu_view_tree_usv;
  end if;

  if n_id is null then
     n_id := :new.id_wb_main_menu_view_tree_usv;
  end if;

  if INSERTING then
    insert into wb_mm_form(id_wb_mm_form, id_wb_main_menu,num,name,id_wb_form_type,action_sql,object_name,
                             xsl_file_in,form_where,id_wb_chart_type,is_read_only,chart_show_name,chart_rotate_name,
                             chart_x,chart_y,chart_dec_prec,height_rate,owner,edit_button,auto_update,form_order)
      values (null,n_id,:new.num,:new.name,:new.id_wb_form_type,:new.action_sql,:new.object_name,
              :new.xsl_file_in,:new.form_where,:new.id_wb_chart_type,:new.is_read_only,:new.chart_show_name,:new.chart_rotate_name,
              :new.chart_x,:new.chart_y,:new.chart_dec_prec,:new.height_rate,:new.owner,:new.edit_button,:new.auto_update, upper(:new.form_order))
              returning id_wb_mm_form into l_id;
		          dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

  elsif UPDATING then
    update wb_mm_form mf set
      mf.id_wb_main_menu   = n_id,
      mf.num               = :new.num,
      mf.name              = :new.name,
      mf.id_wb_form_type   = :new.id_wb_form_type,
      mf.action_sql        = :new.action_sql,
      mf.object_name       = :new.object_name,
      mf.xsl_file_in       = :new.xsl_file_in,
      mf.form_where        = :new.form_where,
      mf.id_wb_chart_type  = :new.id_wb_chart_type,
      mf.is_read_only      = :new.is_read_only,
      mf.chart_show_name   = :new.chart_show_name,
      mf.chart_rotate_name = :new.chart_rotate_name,
      mf.chart_x           = :new.chart_x,
      mf.chart_y           = :new.chart_y,
      mf.chart_dec_prec    = :new.chart_dec_prec,
      mf.height_rate       = :new.height_rate,
      mf.owner             = :new.owner,
      mf.edit_button       = :new.edit_button,
      mf.auto_update       = :new.auto_update,
      mf.form_order        = upper(:new.form_order)
      where mf.id_wb_mm_form = l_id;
  else
    delete
      from wb_mm_form mf
      where mf.id_wb_mm_form = l_id;
  end if;
END;
/
create or replace trigger "T_B_IU_WB_USER"
   before insert or update or delete on wb_user
   for each row
begin
   if inserting then
      if :new.id_wb_user is null then
         select gen_wb_user.nextval into :new.id_wb_user from dual;
      end if;
      :new.create_user := nvl(wb.get_wb_user, user);
      :new.create_date := sysdate;
      :new.last_user := nvl(wb.get_wb_user, user);
      :new.last_date := sysdate;
      :new.wb_name := upper(:new.wb_name);
   elsif updating then
      :new.last_user := nvl(wb.get_wb_user, user);
      :new.last_date := sysdate;
      :new.wb_name := upper(:new.wb_name);
   else
      delete from wb_role_user u where u.id_wb_user = :old.id_wb_user;
   end if;
end;
/
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR ENABLE;
commit;