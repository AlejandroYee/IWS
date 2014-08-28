set define off
spool object.log

prompt
prompt Creating table REGIONS
prompt ======================
prompt
create table REGIONS
(
  id_regions  NUMBER not null,
  name        VARCHAR2(255),
  create_user VARCHAR2(50) not null,
  create_date DATE not null,
  last_user   VARCHAR2(50) not null,
  last_date   DATE not null
)
;
alter table REGIONS
  add constraint PK_REGIONS primary key (ID_REGIONS);

prompt
prompt Creating table TRANKS
prompt =====================
prompt
create table TRANKS
(
  id_tranks   NUMBER not null,
  name_prefix VARCHAR2(255),
  comments    VARCHAR2(255),
  create_user VARCHAR2(50) not null,
  create_date DATE not null,
  last_user   VARCHAR2(50) not null,
  last_date   DATE not null,
  id_regions  NUMBER not null,
  in_out      VARCHAR2(1) default 'I' not null,
  channel     VARCHAR2(255)
)
;
alter table TRANKS
  add constraint PK_TRANKS primary key (ID_TRANKS);
alter table TRANKS
  add constraint FK_REGIONS_TRUNKS foreign key (ID_REGIONS)
  references REGIONS (ID_REGIONS);

prompt
prompt Creating table FAX_QUERY
prompt ========================
prompt
create table FAX_QUERY
(
  id_fax_query     NUMBER not null,
  id_tranks        NUMBER not null,
  in_out           VARCHAR2(1) default 'I' not null,
  file_pic         VARCHAR2(255),
  file_pic_content CLOB,
  status           VARCHAR2(10) default 'SEND' not null,
  error            VARCHAR2(2000),
  create_date      DATE not null,
  last_date        DATE not null,
  tel_number       VARCHAR2(50),
  sender           VARCHAR2(255)
)
;
alter table FAX_QUERY
  add constraint PK_ID_FAX_QUERY primary key (ID_FAX_QUERY);
alter table FAX_QUERY
  add constraint FK_ID_TRANKS_QUERY foreign key (ID_TRANKS)
  references TRANKS (ID_TRANKS);

prompt
prompt Creating table FILES
prompt ====================
prompt
create table FILES
(
  id_files         NUMBER not null,
  file_pic         VARCHAR2(255),
  file_pic_content CLOB,
  create_date      DATE
)
;
alter table FILES
  add constraint PK_ID_FILES primary key (ID_FILES);

prompt
prompt Creating table LISTS
prompt ====================
prompt
create table LISTS
(
  id_lists    NUMBER not null,
  id_tranks   NUMBER not null,
  email_lists VARCHAR2(2000) not null,
  in_out      VARCHAR2(1) default 'I',
  create_user VARCHAR2(50) not null,
  create_date DATE not null,
  last_user   VARCHAR2(50) not null,
  last_date   DATE not null
)
;
alter table LISTS
  add constraint PK_LISTS primary key (ID_LISTS);
alter table LISTS
  add constraint FK_TRANKS_LISTS foreign key (ID_TRANKS)
  references TRANKS (ID_TRANKS);

prompt
prompt Creating table LISTS_USER
prompt =========================
prompt
create table LISTS_USER
(
  id_lists_user NUMBER not null,
  id_tranks     NUMBER not null,
  wb_user       NUMBER not null,
  in_out        VARCHAR2(1) default 'I',
  create_user   VARCHAR2(50) not null,
  create_date   DATE not null,
  last_user     VARCHAR2(50) not null,
  last_date     DATE not null
)
;
alter table LISTS_USER
  add constraint PK_ID_LISTS_USER primary key (ID_LISTS_USER);
alter table LISTS_USER
  add constraint FK_ID_TRANKS_US foreign key (ID_TRANKS)
  references TRANKS (ID_TRANKS);
alter table LISTS_USER
  add constraint FK_ID_USER_WB foreign key (WB_USER)
  references WB_USER (ID_WB_USER);

prompt
prompt Creating table MESSAGES
prompt =======================
prompt
create table MESSAGES
(
  id_messages NUMBER not null,
  in_out      VARCHAR2(1) default 'I' not null,
  tel_number  VARCHAR2(50),
  id_files    NUMBER,
  email       VARCHAR2(255),
  wb_user     NUMBER,
  status      VARCHAR2(50),
  error       VARCHAR2(2000),
  create_date DATE not null,
  last_date   DATE not null,
  id_tranks   NUMBER
)
;
alter table MESSAGES
  add constraint PK_ID_MESSAGE primary key (ID_MESSAGES);
alter table MESSAGES
  add constraint FK_FILES foreign key (ID_FILES)
  references FILES (ID_FILES);
alter table MESSAGES
  add constraint FK_ID_TRANKS foreign key (ID_TRANKS)
  references TRANKS (ID_TRANKS);
alter table MESSAGES
  add constraint FK_USER_WB foreign key (WB_USER)
  references WB_USER (ID_WB_USER);

prompt
prompt Creating sequence SEQ_ID_FAX_QUERY
prompt ==================================
prompt
create sequence SEQ_ID_FAX_QUERY
minvalue 1
maxvalue 9999999999999999
start with 581
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_ID_FILES
prompt ==============================
prompt
create sequence SEQ_ID_FILES
minvalue 1
maxvalue 99999999999999999
start with 161
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_ID_LISTS
prompt ==============================
prompt
create sequence SEQ_ID_LISTS
minvalue 1
maxvalue 999999999999999999
start with 101
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_ID_LISTS_USER
prompt ===================================
prompt
create sequence SEQ_ID_LISTS_USER
minvalue 1
maxvalue 9999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_ID_MESSAGES
prompt =================================
prompt
create sequence SEQ_ID_MESSAGES
minvalue 1
maxvalue 9999999999999999999
start with 281
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_ID_REGION
prompt ===============================
prompt
create sequence SEQ_ID_REGION
minvalue 1
maxvalue 99999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_ID_TRANKS
prompt ===============================
prompt
create sequence SEQ_ID_TRANKS
minvalue 1
maxvalue 99999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating view FAX_QUERY_VIEW
prompt ============================
prompt
create or replace force view fax_query_view as
select t.id_fax_query as ID_FAX_QUERY_VIEW,
       tr.name_prefix as prefix,
       tr.channel,
       t.TEL_NUMBER,
       decode(upper(t.in_out), 'I', 'Входящий', 'Исходящий') as in_out,
       nvl2(t.file_pic, wb.create_download_link('ajax.download_file.php?id=' || t.id_fax_query || '&data=fax_query&name=file_pic', t.file_pic), null) file_name,
       case
        when t.status = 'SEND' then 'Отправлен, ждет обработки'
        when t.status = 'ERROR' then 'Ошибка!'
        when t.status = 'INCOMING' then 'Принимается'
        when t.status = 'RESIVED' then 'Принят, ждет обработки'
        when t.status = 'QUERED' then 'Ждет отправки'
        when t.status = 'SENDING' then 'Отправляется'
        when t.status = 'LOADING' then 'Загружается'
       end as status,
       t.error,
       t.create_date,
       t.last_date
  from fax_query t
 inner join tranks tr on tr.id_tranks = t.id_tranks;

prompt
prompt Creating view FAX_STATISTICS
prompt ============================
prompt
create or replace force view fax_statistics as
select t.name_prefix,
       t.comments,
       t.channel,
       t.id_regions,
       count(s.id_messages) as count_all_messages,
       sum(decode(s.status, 'SEND', 1, 0)) as send_messages,
       sum(decode(s.status, 'RESIVED', 1, 0)) as resived_messages,
       sum(decode(s.status, 'ERROR', 1, 0)) as error_messages
  from tranks t
  left join messages s on s.id_tranks = t.id_tranks
 group by t.name_prefix,
          t.comments,
          t.channel,
          t.id_regions
union all
select null as name_prefix,
       'Всего по всем' as comments,
       null as channel,
       null as id_regions,
       count(s.id_messages) as count_all_messages,
       sum(decode(s.status, 'SEND', 1, 0)) as send_messages,
       sum(decode(s.status, 'RESIVED', 1, 0)) as resived_messages,
       sum(decode(s.status, 'ERROR', 1, 0)) as error_messages
  from dual
 cross join messages s;

prompt
prompt Creating view FAX_VIEW_MESSAGES
prompt ===============================
prompt
create or replace force view fax_view_messages as
select "ID_MESSAGES","TEL_NUMBER","EMAIL","WB_USER","IN_OUT","FILE_NAME","STATUS","ERROR","START_DATE","END_DATE","NAME_PREFIX"
  from (select t.id_messages,
               t.tel_number,
               t.email,
               nvl(t.wb_user,
                   (select w.id_wb_user
                      from wb_user w
                     where w.e_mail = t.email
                       and rownum = 1)) as wb_user,
               t.in_out,
               nvl2(f.file_pic, wb.create_download_link('ajax.download_file.php?id=' || f.id_files || '&data=files&name=file_pic', f.file_pic), null) file_name,
               t.status,
               t.error,
               t.create_date as start_date,
               t.last_date as end_date,
               tt.name_prefix
          from messages t
          left join files f on f.id_files = t.id_files
          left join tranks tt on tt.id_tranks = t.id_tranks
         order by t.create_date desc) d
 where d.wb_user = wb.get_wb_user_id
    or 2 in (select r.id_wb_role from wb_role_user r where r.id_wb_user = wb.get_wb_user_id);

prompt
prompt Creating trigger T_B_IU_FAX_QUERY
prompt =================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_FAX_QUERY"
BEFORE INSERT OR UPDATE
ON FAX_QUERY
FOR EACH ROW
BEGIN
  if INSERTING then
    :new.ID_FAX_QUERY:=seq_id_FAX_QUERY.nextval;
    :new.CREATE_DATE := sysdate;
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_DATE   := sysdate;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_FILES
prompt =============================
prompt
create or replace trigger "T_B_IU_FILES"
   before insert on files
   for each row
begin
   if :new.id_files is null then
      select seq_id_files.nextval into :new.id_files from dual;
   end if;
   :new.create_date := sysdate;

end;
/

prompt
prompt Creating trigger T_B_IU_LISTS
prompt =============================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_LISTS"
BEFORE INSERT OR UPDATE
ON fax.lists
FOR EACH ROW
BEGIN
  if INSERTING then
    :new.id_lists:=seq_id_lists.nextval;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_LISTS_USER
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_LISTS_USER"
BEFORE INSERT OR UPDATE
ON fax.lists_user
FOR EACH ROW
BEGIN
  if INSERTING then
    :new.id_lists_user:=seq_id_lists_user.nextval;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_MESSAGES
prompt ================================
prompt
create or replace trigger "T_B_IU_MESSAGES"
   before insert on MESSAGES
   for each row
begin
   if :new.id_messages is null then
      select seq_id_messages.nextval into :new.id_messages  from dual;
   end if;
   
      if :new.create_date is null then
      :new.create_date := sysdate;
   end if;
end;
/

prompt
prompt Creating trigger T_B_IU_REGIONS
prompt ===============================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_REGIONS"
BEFORE INSERT OR UPDATE
ON REGIONS
FOR EACH ROW
BEGIN
  if INSERTING then
    :new.ID_REGIONS:=seq_id_region.nextval;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_TRANKS
prompt ==============================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_TRANKS"
BEFORE INSERT OR UPDATE
ON TRANKS
FOR EACH ROW
BEGIN
  if INSERTING then
    :new.ID_TRANKS:=seq_id_tranks.nextval;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
END;
/

prompt
prompt Creating trigger T_I_IUD_FAX_QUERY_VIEW
prompt =======================================
prompt
create or replace trigger t_i_iud_fax_query_view
   instead of delete on fax_query_view
   for each row
begin
   delete from fax_query fc where fc.id_fax_query = :old.id_fax_query_view;
end;
/

prompt
prompt Creating trigger T_I_IUD_WB_FORM_CELLS_VIEW
prompt ===========================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_WB_FORM_CELLS_VIEW
INSTEAD OF INSERT OR UPDATE OR DELETE
ON WB_FORM_CELLS_VIEW
FOR EACH ROW
DECLARE
  l_id number := :old.id_wb_form_cells_view;
BEGIN
  if INSERTING then
    insert into wb_form_cells(id_wb_form_cells, id_wb_mm_form,num,name,field_txt,xls_position_col,xls_position_row,
                              xls_type,field_type,field_name,type_cells)
      values (null,:new.id_wb_mm_form_view,:new.num,:new.name,:new.field_txt,:new.xls_position_col,:new.xls_position_row,
              :new.xls_type,:new.field_type,:new.field_name,:new.type_cells)	returning id_wb_form_cells into l_id;
		dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

  elsif UPDATING then
    update wb_form_cells fc set
      fc.id_wb_mm_form    = :new.id_wb_mm_form_view,
      fc.num              = :new.num,
      fc.name             = :new.name,
      fc.field_txt        = :new.field_txt,
      fc.xls_position_col = :new.xls_position_col,
      fc.xls_position_row = :new.xls_position_row,
      fc.xls_type         = :new.xls_type,
      fc.field_type       = :new.field_type,
      fc.field_name       = :new.field_name,
      fc.type_cells       = :new.type_cells
      where fc.id_wb_form_cells = l_id;
  else
    delete
      from wb_form_cells fc
      where fc.id_wb_form_cells = l_id;
  end if;
END;
/

prompt
prompt Creating trigger T_I_IUD_WB_FORM_FIELD_VIEW
prompt ===========================================
prompt
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

prompt
prompt Creating trigger T_I_IUD_WB_MAIN_MENU_TREE_USV
prompt ==============================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_wb_main_menu_tree_usv
INSTEAD OF INSERT OR UPDATE OR DELETE
ON wb_main_menu_view_tree_usv
FOR EACH ROW
declare
  l_id number := :old.id_wb_main_menu_view_tree_usv;
begin
  if inserting then
    Insert into wb_main_menu
      (id_wb_main_menu, id_parent, name, num, used)
    values
      (null, :new.id_parent, :new.name, :new.num, :new.used)
    returning id_wb_main_menu into l_id;
    dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

  elsif updating then
    Update wb_main_menu mm
       set mm.id_parent = :new.id_parent, mm.name = :new.name, mm.num = :new.num, mm.used = :new.used
     Where mm.id_wb_main_menu = l_id;
  else
    delete From wb_main_menu mm Where mm.id_wb_main_menu = l_id;
  end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_WB_MAIN_MENU_VIEW_TREE
prompt ===============================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_WB_MAIN_MENU_VIEW_TREE
INSTEAD OF INSERT OR UPDATE OR DELETE
ON WB_MAIN_MENU_VIEW_TREE
FOR EACH ROW
declare
	l_id number := :old.id_wb_main_menu_view_tree;
begin
	if inserting then
		Insert into wb_main_menu
			(id_wb_main_menu, id_parent, name, num, used)
		values
			(null, :new.id_parent, :new.name, :new.num, :new.used)
		returning id_wb_main_menu into l_id;
		dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

	elsif updating then
		Update wb_main_menu mm
			 set mm.id_parent = :new.id_parent, mm.name = :new.name, mm.num = :new.num, mm.used = :new.used
		 Where mm.id_wb_main_menu = l_id;
	else
		delete From wb_main_menu mm Where mm.id_wb_main_menu = l_id;
	end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_WB_MM_FORM_VIEW
prompt ========================================
prompt
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

prompt
prompt Creating trigger T_I_IUD_WB_SETTINGS_VIEW_TREE
prompt ==============================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_WB_SETTINGS_VIEW_TREE
INSTEAD OF INSERT OR UPDATE OR DELETE
ON WB_SETTINGS_VIEW_TREE
FOR EACH ROW
DECLARE
  l_id number := :old.id_wb_settings_view_tree;
BEGIN
  if INSERTING then
    insert into wb_settings(id_wb_settings,id_parent, num, name, short_name, value, used)
      values (null,:new.id_parent, :new.num, :new.name, :new.short_name, :new.value, :new.used) 	returning id_wb_settings into l_id;
		dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

  elsif UPDATING then
    update wb_settings s set
      s.id_parent  = :new.id_parent,
      s.num        = :new.num,
      s.name       = :new.name,
      s.short_name = :new.short_name,
      s.value      = :new.value,
      s.used       = :new.used
      where s.id_wb_settings = l_id;
  else
    delete
      from wb_settings s
      where s.id_wb_settings = l_id;
  end if;
END;
/

alter table WB_FORM_FIELD disable all triggers;
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000007, null, 20, 'Работа с факсами', 'LOADER', to_date('17-03-2014 16:52:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:52:14', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000023, 1000007, 6, 'Статистика работы', 'LOADER', to_date('26-03-2014 16:45:53', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:45:53', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000002, null, 10, 'Настройки сервера', 'LOADER', to_date('17-03-2014 14:32:20', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:32:20', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000005, 1000007, 7, 'Текущая очередь сообщений', 'LOADER', to_date('17-03-2014 15:08:42', 'dd-mm-yyyy hh24:mi:ss'), 'FAX', to_date('26-03-2014 16:46:52', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000022, 1000007, 5, 'История факсимильных сообщений', 'LOADER', to_date('26-03-2014 13:59:11', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 13:59:11', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000008, 1000007, 10, 'Отправить факс', 'LOADER', to_date('17-03-2014 16:53:07', 'dd-mm-yyyy hh24:mi:ss'), 'FAX', to_date('17-03-2014 16:54:02', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000003, 1000002, 10, 'Справочник регионов', 'LOADER', to_date('17-03-2014 14:32:37', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:32:37', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000004, 1000002, 20, 'Справочник транков и групп и привязок email', 'LOADER', to_date('17-03-2014 14:32:56', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:00:05', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000003, 1000004, 20, 'Список привязаных электронных адресов', -9, null, 'LISTS', null, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 60, 'FAX', null, 'A,E,С,D,EXP', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000005, 1000005, 10, 'Очередь активности', -6, null, 'FAX_QUERY_VIEW', null, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('19-03-2014 13:02:56', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 100, 'FAX', null, 'D', 30, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000023, 1000023, 10, 'Общая статистика работы факсовой системы', -6, null, 'FAX_STATISTICS', null, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, 0, 0, null, null, null, 100, 'FAX', null, 'EXP', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000001, 1000003, 10, 'Список регионов', -6, null, 'REGIONS', null, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 100, 'FAX', null, 'A,E,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000004, 1000004, 30, 'Список пользователей системы привязаных к транку', -9, null, 'LISTS_USER', null, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:43:38', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 60, 'FAX', null, 'A,E,С,D,EXP', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000021, 1000022, 10, 'Список факсимильных сообщений', -6, null, 'FAX_VIEW_MESSAGES', null, null, 'LOADER', to_date('26-03-2014 14:02:45', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:02:45', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, 0, 0, null, null, null, 100, 'FAX', null, 'A,E,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000002, 1000004, 10, 'Список транков в каждом регионе', -8, null, 'TRANKS', null, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:32:47', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 40, 'FAX', null, 'A,E,С,D,EXP', null, null);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000019, 1000003, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000073, 1000023, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000021, 1000003, 30, 'Электронный адрес', 'EMAIL_LISTS', null, null, 1, 'E', 0, null, 300, null, null, 1, 'Может быть и группой рассылки а также шаблоном адреса', 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:25:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000074, 1000023, 10, 'Экстеншин', 'NAME_PREFIX', null, null, 1, 'S', 0, null, 100, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:51:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000023, 1000003, 50, 'Направление', 'IN_OUT', null, 'select * from (' || chr(10) || '  select &#39;I&#39; as id, &#39;Принимает факсы&#39; as name from dual union all' || chr(10) || '  select &#39;O&#39; as id, &#39;Отправляет факсы&#39; as name from dual union all' || chr(10) || '  select &#39;A&#39; as id, &#39;В оба направления&#39; as name from dual' || chr(10) || ')', 1, 'SB', 0, null, 150, null, null, 1, 'Что может делать электронный адрес с данным транком', 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:24:37', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000024, 1000003, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000025, 1000003, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000026, 1000003, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000027, 1000003, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000028, 1000003, 100, 'ID (not display)', 'ID_LISTS', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:21:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000075, 1000023, 20, 'Коментарий', 'COMMENTS', null, null, 1, 'S', 0, null, 300, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:51:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000076, 1000023, 30, 'Канал', 'CHANNEL', null, null, 2, 'S', 0, null, 150, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:55:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000077, 1000023, 40, 'Регион', 'ID_REGIONS', null, 'select id_regions as id, name from regions', 2, 'SB', 0, null, 150, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:55:25', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000078, 1000023, 50, 'Общее количество', 'COUNT_ALL_MESSAGES', null, null, 3, 'I', 0, null, 150, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:53:20', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000079, 1000023, 60, 'Отправленых', 'SEND_MESSAGES', null, null, 3, 'I', 0, null, 150, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:53:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000080, 1000023, 70, 'Принятых', 'RESIVED_MESSAGES', null, null, 3, 'I', 0, null, 150, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:54:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000081, 1000023, 80, 'С ошибкой', 'ERROR_MESSAGES', null, null, 3, 'I', 0, null, 150, null, null, 0, null, 'LOADER', to_date('26-03-2014 16:50:41', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 16:54:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000050, 1000005, 20, 'Номер телефона', 'TEL_NUMBER', null, null, 1, 'S', 0, null, 200, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:39:37', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 17:08:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000062, 1000021, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000063, 1000021, 10, 'Номер в очереди', 'ID_MESSAGES', null, null, 3, 'I', 0, null, 70, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:04:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000064, 1000021, 20, 'Телефонный номер', 'TEL_NUMBER', null, null, 1, 'S', 0, null, 120, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:04:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000065, 1000021, 40, 'Отправитель/получатель', 'EMAIL', null, null, 1, 'E', 0, null, 250, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:06:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000067, 1000021, 15, 'Направление', 'IN_OUT', null, 'select &#39;I&#39; as id, &#39;Входящий&#39; as name from dual' || chr(10) || 'union all' || chr(10) || 'select &#39;O&#39; as id, &#39;Исходящий&#39; as name from dual', 2, 'SB', 0, null, 80, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:28:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000068, 1000021, 30, 'Файл', 'FILE_NAME', null, null, 1, 'S', 0, null, 250, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:06:08', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000069, 1000021, 25, 'Статус', 'STATUS', null, 'select &#39;SEND&#39; as id, &#39;Отправлен&#39; as name from dual union all' || chr(10) || 'select &#39;ERROR&#39; as id, &#39;Ошибка&#39; as name from dual union all' || chr(10) || 'select &#39;RESIVED&#39; as id, &#39;Принят&#39; as name from dual union all' || chr(10) || 'select &#39;INCOMING&#39; as id, &#39;Принимается&#39; as name from dual union all' || chr(10) || 'select &#39;QUERED&#39; as id, &#39;Ждет отправки&#39; as name from dual union all' || chr(10) || 'select &#39;SENDING&#39; as id, &#39;Отправляется&#39; as name from dual union all' || chr(10) || 'select &#39;LOADING&#39; as id, &#39;Загружается&#39; as name from dual', 1, 'SB', 0, null, 100, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:27:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000070, 1000021, 100, 'Ошибка', 'ERROR', null, null, 1, 'S', 0, null, 350, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:08:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000071, 1000021, 92, 'Дата создания', 'START_DATE', null, null, 2, 'DT', 1, null, 130, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:13:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000072, 1000021, 94, 'Дата обновления', 'END_DATE', null, null, 2, 'DT', 1, null, 130, null, null, 0, null, 'LOADER', to_date('26-03-2014 14:02:46', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 14:13:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000009, 1000002, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000010, 1000002, 20, 'Имя или префикс транка', 'NAME_PREFIX', null, null, 1, 'S', 0, null, 200, null, null, 1, 'Префикс транка который определиться в системе как вызываемый факсовый номер', 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:44:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000011, 1000002, 30, 'Комментарий', 'COMMENTS', null, '        ', 1, 'S', 0, null, 300, null, null, 0, 'Комментарий к транку', 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:44:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000012, 1000002, 80, 'Регион', 'ID_REGIONS', null, 'select r.id_regions as id, r.name' || chr(10) || 'from regions r', 3, 'SB', 0, null, 150, null, null, 1, 'Регион привязки транка для их удобной сортировки', 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:45:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000013, 1000002, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000014, 1000002, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000015, 1000002, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000016, 1000002, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000017, 1000002, 100, 'ID (not display)', 'ID_TRANKS', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:43:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000053, 1000002, 25, 'Канал', 'CHANNEL', null, null, 1, 'S', 0, null, 150, null, null, 1, 'Канал к которому подключен транк', 'LOADER', to_date('17-03-2014 17:21:10', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 17:21:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000039, 1000005, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000040, 1000005, 10, 'Транк', 'PREFIX', null, null, 1, 'S', 0, null, 200, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:41:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000041, 1000005, 5, 'Уникальный номер в очереди', 'ID_FAX_QUERY_VIEW', null, null, 3, 'I', 0, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('19-03-2014 13:12:08', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000082, 1000021, 101, 'Транк', 'NAME_PREFIX', null, null, 3, 'S', 0, null, 100, null, null, 0, null, 'LOADER', to_date('27-03-2014 11:42:15', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('27-03-2014 11:42:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000044, 1000005, 50, 'Направление', 'IN_OUT', null, null, 1, 'S', 0, null, 100, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:41:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000045, 1000005, 60, 'Файл', 'FILE_NAME', null, null, 1, 'S', 0, null, 250, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:41:25', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000046, 1000005, 70, 'Статус обработки', 'STATUS', null, null, 1, 'S', 0, null, 250, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('19-03-2014 13:17:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000047, 1000005, 80, 'Ошибки', 'ERROR', null, null, 1, 'S', 0, null, 300, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:41:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000048, 1000005, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000049, 1000005, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 16:30:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000002, 1000001, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000003, 1000001, 20, 'Название региона', 'NAME', null, null, 1, 'S', 0, null, 200, null, null, 1, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000004, 1000001, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000005, 1000001, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000006, 1000001, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000007, 1000001, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000008, 1000001, 100, 'ID (not display)', 'ID_REGIONS', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:35:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000018, 1000002, 85, 'Направление', 'IN_OUT', null, 'select * from (' || chr(10) || '  select &#39;I&#39; as id, &#39;Входящиее&#39; as name from dual union all' || chr(10) || '  select &#39;O&#39; as id, &#39;Исходящиее&#39; as name from dual union all' || chr(10) || '  select &#39;A&#39; as id, &#39;В оба направления&#39; as name from dual' || chr(10) || ')', 1, 'SB', 0, null, 200, null, null, 1, 'Какое направление у транка, в зависимости от направления они по разному будут использоваться системой', 'LOADER', to_date('17-03-2014 14:53:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:54:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000029, 1000004, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000032, 1000004, 40, 'Пользователь системы', 'WB_USER', null, 'select u.id_wb_user as id, u.name || &#39; (&#39; || u.e_mail || &#39;)&#39; as name' || chr(10) || 'from wb_user u', 3, 'SB', 0, null, 350, null, null, 1, 'Нужно чтобы у данного пользователя обязательно был указан электронный адрес', 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:46:56', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000033, 1000004, 50, 'Направление', 'IN_OUT', null, 'select * from (' || chr(10) || '  select &#39;I&#39; as id, &#39;Принимает факсы&#39; as name from dual union all' || chr(10) || '  select &#39;O&#39; as id, &#39;Отправляет факсы&#39; as name from dual union all' || chr(10) || '  select &#39;A&#39; as id, &#39;В оба направления&#39; as name from dual' || chr(10) || ')', 1, 'SB', 0, null, 150, null, null, 1, 'Что может делать пользователь с данным транком', 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:46:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000034, 1000004, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000035, 1000004, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000036, 1000004, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000037, 1000004, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (1000038, 1000004, 100, 'ID (not display)', 'ID_LISTS_USER', null, null, 3, 'I', 1, null, 80, null, null, 0, null, 'LOADER', to_date('17-03-2014 15:32:36', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:44:04', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (4, 'STATISTICS', 'Статистика работы', 'LOADER', to_date('17-03-2014 15:53:24', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:53:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (5, 'SEND_FAX', 'Отправка факсимильного сообщения', 'LOADER', to_date('17-03-2014 15:55:08', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 15:55:08', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (3, 'SETTINGS', 'Настройка и администрирование сервера', 'LOADER', to_date('17-03-2014 14:33:27', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('17-03-2014 14:33:27', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (23, 'FAX_USER', 'Пользователь для работы с факсами через веб интерфейс', 'LOADER', to_date('21-03-2014 13:29:52', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('21-03-2014 13:29:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (19, 14, 9, 'Почтовый ящик по умолчанию', 'SETTINGS_DEFAULT_MAIL', 'mail@domain.ru', 1, 'LOADER', to_date('26-03-2014 12:43:29', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('26-03-2014 12:43:29', 'dd-mm-yyyy hh24:mi:ss'));
alter table WB_FORM_FIELD enable all triggers;