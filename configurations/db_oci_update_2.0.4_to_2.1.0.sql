/*
���� ���������� �� � ������ 2.0.4 �� ������ 2.1.0
*/
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR DISABLE;
update WB_FORM_FIELD t set t.fl_html_code = null;
alter table WB_FORM_FIELD rename column fl_html_code to ELEMENT_ALT;
alter table WB_FORM_FIELD modify element_alt varchar2(2000) default null;
alter table WB_MM_FORM drop column html_img;
delete from wb_form_field t where t.id_wb_form_field < 0 and t.field_name = 'HTML_IMG';
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-188, -7, 6, '������', 'PASSWORD', null, null, 1, 'P', 0, null, 150, null, null, null, 0, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-189, -4, 13, '��������� � ����', 'ELEMENT_ALT', null, null, 1, 'S', 0, null, 250, null, null, null, 0, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (-1, null, 3, '������ ��', 'ROOT_DB_VERSION', '2.1.0', 1, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
update wb_form_field t set t.element_alt =    
   case t.field_name
         when 'PASSWORD' then               '������ ������������ ��� ������������� ������ ������������ auth.user'
         when 'XLS_POSITION_ROW' then       '��������� �� ��������� ������������ ���� � ���� ��� �������� ���� ������ ���������'
         when 'HEIGHT_RATE' then            '������ ����� �� ��������, � ������ ���� ����� ���� �� ����� ����������� ���� ������� 100%, ���� ���� ���������, �� ���������� ��������� � ���������� ����������� �� ��������� ����'
         when 'EDIT_BUTTON' then            '������ ������� ����� �������� ��� ��������, �� ������������� �� ������ �������������� ��� ����� ������ � ���������� �������'
         when 'XSL_FILE_IN' then            '��� ��������� ����� ��� �������� ���������, ���� ������ �� ������ �������� ������������ ���� ��� ��������. �������������� ������ xlsm � ���������'
         when 'CHART_SHOW_NAME' then        '���������� ��� ��� �������� ������� � ��� ���������'
         when 'CHART_Y' then                '������ ������� � ��������'
         when 'CREATE_DATE' then            '���� �������� ������ � ��'
         when 'TYPE_CHART' then             '��� �������, � ����������� �� ���� ����� ��������� ������ �������� �� �������'
         when 'XLS_POSITION_COL' then       '��������� �� ����������� ������������ ���� � ���� ��� �������� ���� ������ ���������'
         when 'FIELD_TYPE' then             '��� ������� ������, � ������ ���� ��� ������ �� ���������� ��������� ���� SQL ����/����� ���� ��� ���� ����� �������� ����� ��� ������. ����������� ��������: id, name'
         when 'USED' then                   '���� ������������ ����� �� ������������ ������ ����� ������������� ��� ���, ���� ��� �� ������ ����� �� ����� ����� � ������ � ��� �����������'
         when 'WB_NAME' then                '����� ������������ ��� ������� � �������'
         when 'DESCRIPTION' then            '�������� ���� ��������, ��� ����� ������� � ���'
         when 'CHART_X' then                '����� ������� � ��������'
         when 'WIDTH' then                  '����� �������� � ��������, �� ������ ����� �������� ���������� ���� ��������� � ���������'
         when 'CREATE_USER' then            '������������ ��������� ������ � ��'
         when 'LAST_USER' then              '������������ ��������� ���������� ������ � ��'
         when 'ARRAY_NAME' then             '������������ ������� ���� ���������� ��� �������� � ����������� �������������, ����������� ��� ������� ������� ":". � ����������� �������� �� ����� ������������ ��� ������������� ��������� ������ ���� ���������� ������ ���� ����'
         when 'IS_REQURED' then             '������ ���� ����������� ��� ��� ��� ���������� ��� �������������� ������'
         when 'TYPE_CELLS' then             '������� ������ � ����� ��������'
         when 'PARAM_VIEW' then             '��������� ���� � ����������� ������������'
         when 'FORM_WHERE' then             '���� ��� ��������� ����� ���� �������� � �������, �������� ���������� ������� ����� �������� �����'
         when 'COUNT_ELEMENT' then          '������ ��������, ��������� ������ � ���� ���� "������������� �����" � "���������� ������"'
         when 'IS_READ_ONLY' then           '������ ������� ��� ������� ���������� ��� ��������� ���� ��������'
         when 'ACTION_SQL' then             '���� ����������� � ����������� �� ���� �����, ����� ��������� ���������� ����������. ������ ����������� ����� ��������� ����� ���������� �������� ���� �� ������� ����� � ������ ����'
         when 'NUM' then                    '���������� ����� ����������� � ������������� �������� �� �������� ���� � �������, ����� ����� ������ �� ������������!'
         when 'LAST_DATE' then              '���� ���������� ��������� ������ � ��'
         when 'PHONE' then                  '������� ������������'
         when 'E_MAIL' then                 '����������� ����� ������������'
         when 'NAME' then                   '������������ ��� ��������'
		 when 'AUTO_UPDATE' then            '�������������� ���������� ����� ����� ������������ ���������� �������'	
		 when 'ID_WB_MAIN_MENU_VIEW_TREE' then            '������� ���� � �������� ������������� ����� ��� �������'		
		 when 'ID_WB_FORM_TYPE' then        '��� �����, �� ����� �������� �� ����� ���� ���������, ����� ��������� ������� ���� ����� ����� ������ ����������� � ������'		
		 when 'ID_WB_CHART_TYPE' then       '��� �������, ������������ ������ ����� ��� ����� ������ ��� "������"'	
         when 'FIELD_TXT' then              'SQL ���� ������� ��������� ��������� ������� ������� � ������� "����������� ������" ����� ������������ ���������� :rowid ��� ���� ����� ���������� ���� ������� ���������� rowid ��������  ���� rowid ������� ����� ���� ������ ������� ����������� ������� �����. ����� ��������� ������������ �������� �� ���� �������� ����, ������� ����� �� �������� ���� � ��'
         when 'OWNER' then                  '����� � �� � ������� ��������� ������� � � ������� ����� �������� ��� sql ����� ������� ������� ��������'
         when 'OBJECT_NAME' then            '������ � �� � ��������� � ����� ��� �������� ��������� �����.'
         when 'CHART_ROTATE_NAME' then      '���� ������� �� ����� � ������� ����� ��������� �� 90 �������� ������ ����� ���'
         when 'SHORT_NAME' then             '�������� ��� ���������� ������ ����� �������������� � ���������� � ��'
         when 'FIELD_NAME' then             '���� � ������� �� ������� ����� ��������� � ������� ��������, ����� ��� ����� �������� ��� ���������� ��� ���������� ����� ��� �������� �� ������ �������� ������� �������'
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