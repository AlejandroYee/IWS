/*
Файл обновления БД с версии 2.1.3 до версии 2.1.5
*/
update WB_SETTINGS w set w.value = '2.1.5' where w.short_name = 'ROOT_DB_VERSION';
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR DISABLE;
alter table WB_FORM_FIELD add is_frosen number default 0;
alter table WB_FORM_FIELD add is_grouping number default 0;
alter table WB_FORM_FIELD add is_grouping_header varchar2(2000) default null;
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date, is_frosen, is_grouping, is_grouping_header)
values (-191, -4, 25, 'Закрепленный столбец', 'IS_FROSEN', null, null, 1, 'B', 0, null, 200, null, null, 0, 'Позволяет закрепить столбец от горизонтальной прокрутки','LOADER', sysdate, 'LOADER', sysdate, 0, 0, null);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date, is_frosen, is_grouping, is_grouping_header)
values (-192, -4, 26, 'Группировать строки', 'IS_GROUPING', null, null, 1, 'B', 0, null, 200, null, null, 0, 'Позволяет сгруппировать записи по данному столбцу в раскрывающееся списки, если выставлено несколько столбцов то они сгруппируются в дерево', 'LOADER', sysdate, 'LOADER', sysdate, 0, 0, null);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date, is_frosen, is_grouping, is_grouping_header)
values (-193, -4, 27, 'Группировать заголовков столбцов', 'IS_GROUPING_HEADER', null, null, 1, 'S', 0, null, 200, null, null, 0, 'Группирует заголовки столбцов таким образом чтобы было понятно что они относятся к одному уровню, необходимо ввести общее имя группы, групирровать можно только рядом стоящие столбци!', 'LOADER', sysdate, 'LOADER', sysdate, 0, 0, null);
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR ENABLE;
create or replace view wb_form_field_view as
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
       t.is_frosen,
       t.is_grouping,
	   t.is_grouping_header,
       t.create_user,
       t.create_date,
       t.last_user,
       t.last_date
  from wb_form_field t
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
                             is_read_only,count_element,width,xls_position_col,xls_position_row,is_requred,element_alt,is_frosen,is_grouping,is_grouping_header)
      values (null,:new.id_wb_mm_form_view,:new.num,:new.name,:new.field_name,:new.field_txt,:new.id_wb_form_field_align,:new.field_type,
              :new.is_read_only,:new.count_element,:new.width,:new.xls_position_col,:new.xls_position_row,:new.is_requred,:new.element_alt,:new.is_frosen,:new.is_grouping,:new.is_grouping_header)
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
      ff.element_alt            = :new.element_alt,
      ff.is_frosen              = :new.is_frosen,
      ff.is_grouping            = :new.is_grouping,
	  ff.is_grouping_header		= :new.is_grouping_header
      where ff.id_wb_form_field = l_id;
  else
    delete
      from wb_form_field ff
      where ff.id_wb_form_field = l_id;
  end if;
END;
commit;