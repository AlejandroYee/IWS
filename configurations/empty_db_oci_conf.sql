/*
Пустая конфигурация предназначена для чистой установки, для нее не требуется производить обновление с помощью каких либо скриптов
*/


set define off
spool create-config.log

prompt
prompt Creating table WB_ACCESS_TYPE
prompt =============================
prompt
create table WB_ACCESS_TYPE
(
  id_wb_access_type NUMBER not null,
  wb_name           VARCHAR2(50),
  name              VARCHAR2(255),
  create_user       VARCHAR2(50) not null,
  create_date       DATE not null,
  last_user         VARCHAR2(50) not null,
  last_date         DATE not null
)
;
alter table WB_ACCESS_TYPE
  add primary key (ID_WB_ACCESS_TYPE);

prompt
prompt Creating table WB_CHART_TYPE
prompt ============================
prompt
create table WB_CHART_TYPE
(
  id_wb_chart_type NUMBER not null,
  name             VARCHAR2(50) not null,
  description      VARCHAR2(4000),
  type_chart       VARCHAR2(50) not null,
  create_user      VARCHAR2(50) not null,
  create_date      DATE not null,
  last_user        VARCHAR2(50) not null,
  last_date        DATE not null
)
;
create unique index IX_WB_CHART_TYPE_NAME on WB_CHART_TYPE (NAME);
alter table WB_CHART_TYPE
  add primary key (ID_WB_CHART_TYPE);

prompt
prompt Creating table WB_FIELD_TYPE
prompt ============================
prompt
create table WB_FIELD_TYPE
(
  id_wb_field_type NUMBER not null,
  id               VARCHAR2(3),
  name             VARCHAR2(2000),
  char_mask        VARCHAR2(2000),
  char_case        VARCHAR2(1) default 'N' not null,
  create_user      VARCHAR2(50) not null,
  create_date      DATE not null,
  last_user        VARCHAR2(50) not null,
  last_date        DATE not null 
)
;

prompt
prompt Creating table WB_FORM_TYPE
prompt ===========================
prompt
create table WB_FORM_TYPE
(
  id_wb_form_type NUMBER not null,
  num             NUMBER,
  name            VARCHAR2(255),
  create_user     VARCHAR2(50) not null,
  create_date     DATE not null,
  last_user       VARCHAR2(50) not null,
  last_date       DATE not null,
  human_name      VARCHAR2(255) not null
)
;
alter table WB_FORM_TYPE
  add primary key (ID_WB_FORM_TYPE);

prompt
prompt Creating table WB_MAIN_MENU
prompt ===========================
prompt
create table WB_MAIN_MENU
(
  id_wb_main_menu NUMBER not null,
  id_parent       NUMBER,
  num             NUMBER,
  name            VARCHAR2(255),
  create_user     VARCHAR2(50) not null,
  create_date     DATE not null,
  last_user       VARCHAR2(50) not null,
  last_date       DATE not null,
  used            NUMBER default 1
)
;
create index IX_WB_MM_1 on WB_MAIN_MENU (ID_PARENT, USED);
alter table WB_MAIN_MENU
  add primary key (ID_WB_MAIN_MENU);
alter table WB_MAIN_MENU
  add constraint FK_WB_MM_PARENT foreign key (ID_PARENT)
  references WB_MAIN_MENU (ID_WB_MAIN_MENU);

prompt
prompt Creating table WB_MM_FORM
prompt =========================
prompt
create table WB_MM_FORM
(
  id_wb_mm_form     NUMBER not null,
  id_wb_main_menu   NUMBER not null,
  num               NUMBER,
  name              VARCHAR2(255),
  id_wb_form_type   NUMBER,
  action_sql        VARCHAR2(2000),
  object_name       VARCHAR2(255),
  xsl_file_in       VARCHAR2(255),
  xsl_file_out      VARCHAR2(255),
  create_user       VARCHAR2(50) not null,
  create_date       DATE not null,
  last_user         VARCHAR2(50) not null,
  last_date         DATE not null,
  form_where        VARCHAR2(2000),
  id_wb_chart_type  NUMBER,
  is_read_only      NUMBER default 1,
  chart_show_name   NUMBER,
  chart_rotate_name NUMBER,
  chart_x           NUMBER,
  chart_y           NUMBER,
  chart_dec_prec    NUMBER,
  height_rate       NUMBER,
  owner             VARCHAR2(50),
  action_bat        VARCHAR2(2000),
  edit_button       VARCHAR2(200) default 'A,E,D',
  auto_update       NUMBER default 0 null
);
create index IX_WB_MM_FORM_1 on WB_MM_FORM (ID_WB_MAIN_MENU);
alter table WB_MM_FORM
  add primary key (ID_WB_MM_FORM);
alter table WB_MM_FORM
  add constraint FK_WB_MM_FORM_WB_CHART_TYPE foreign key (ID_WB_CHART_TYPE)
  references WB_CHART_TYPE (ID_WB_CHART_TYPE);
alter table WB_MM_FORM
  add constraint FK_WB_MM_FORM_WB_FORM_TYPE foreign key (ID_WB_FORM_TYPE)
  references WB_FORM_TYPE (ID_WB_FORM_TYPE);
alter table WB_MM_FORM
  add constraint FK_WB_MM_FORM_WB_MAIN_MENU foreign key (ID_WB_MAIN_MENU)
  references WB_MAIN_MENU (ID_WB_MAIN_MENU);
alter table WB_MM_FORM add form_order VARCHAR2(2000);

prompt
prompt Creating table WB_FORM_CELLS
prompt ============================
prompt
create table WB_FORM_CELLS
(
  id_wb_form_cells NUMBER not null,
  id_wb_mm_form    NUMBER,
  num              NUMBER,
  name             VARCHAR2(255),
  field_txt        VARCHAR2(2000),
  xls_position_col NUMBER,
  xls_position_row NUMBER,
  xls_type         VARCHAR2(20),
  field_type       VARCHAR2(3) default 'N',
  create_user      VARCHAR2(50) not null,
  create_date      DATE not null,
  last_user        VARCHAR2(50) not null,
  last_date        DATE not null,
  field_name       VARCHAR2(50) not null,
  type_cells       VARCHAR2(2) default 'H' not null
)
;
alter table WB_FORM_CELLS
  add primary key (ID_WB_FORM_CELLS);
alter table WB_FORM_CELLS
  add constraint FK_WB_FORM_CELLS_WB_MM_FROM foreign key (ID_WB_MM_FORM)
  references WB_MM_FORM (ID_WB_MM_FORM);

prompt
prompt Creating table WB_FORM_FIELD_ALIGN
prompt ==================================
prompt
create table WB_FORM_FIELD_ALIGN
(
  id_wb_form_field_align NUMBER not null,
  name                   VARCHAR2(255),
  html_txt               VARCHAR2(2000),
  create_user            VARCHAR2(50) not null,
  create_date            DATE not null,
  last_user              VARCHAR2(50) not null,
  last_date              DATE not null
)
;
alter table WB_FORM_FIELD_ALIGN
  add primary key (ID_WB_FORM_FIELD_ALIGN);

prompt
prompt Creating table WB_FORM_FIELD
prompt ============================
prompt
create table WB_FORM_FIELD
(
  id_wb_form_field       NUMBER not null,
  id_wb_mm_form          NUMBER,
  num                    NUMBER,
  name                   VARCHAR2(255),
  field_name             VARCHAR2(255),
  array_name             VARCHAR2(255),
  field_txt              VARCHAR2(2000),
  id_wb_form_field_align NUMBER default 1,
  field_type             VARCHAR2(3) default 'N',
  is_read_only           NUMBER default 0 not null,
  count_element          NUMBER,
  width                  NUMBER,
  xls_position_col       NUMBER,
  xls_position_row       NUMBER,
  is_requred             NUMBER default 0,
  element_alt            VARCHAR2(2000) default null,
  is_frosen 			 number default 0,
  is_grouping 			 number default 0,
  is_grouping_header 	 varchar2(2000) default null,
  create_user            VARCHAR2(50) not null,
  create_date            DATE not null,
  last_user              VARCHAR2(50) not null,
  last_date              DATE not null
)
;
create index IX_FORM_FL_1 on WB_FORM_FIELD (ID_WB_MM_FORM);
alter table WB_FORM_FIELD
  add primary key (ID_WB_FORM_FIELD);
alter table WB_FORM_FIELD
  add constraint FK_WB_FORM_FL_WB_FROM_ALG foreign key (ID_WB_FORM_FIELD_ALIGN)
  references WB_FORM_FIELD_ALIGN (ID_WB_FORM_FIELD_ALIGN);
alter table WB_FORM_FIELD
  add constraint FK_WB_FORM_FL_WB_MM_FROM foreign key (ID_WB_MM_FORM)
  references WB_MM_FORM (ID_WB_MM_FORM);

prompt
prompt Creating table WB_ROLE
prompt ======================
prompt
create table WB_ROLE
(
  id_wb_role  NUMBER not null,
  wb_name     VARCHAR2(255),
  name        VARCHAR2(255),
  create_user VARCHAR2(50) not null,
  create_date DATE not null,
  last_user   VARCHAR2(50) not null,
  last_date   DATE not null
)
;
alter table WB_ROLE
  add primary key (ID_WB_ROLE);

prompt
prompt Creating table WB_MM_ROLE
prompt =========================
prompt
create table WB_MM_ROLE
(
  id_wb_mm_role     NUMBER not null,
  id_wb_main_menu   NUMBER not null,
  id_wb_role        NUMBER not null,
  id_wb_access_type NUMBER not null,
  create_user       VARCHAR2(50) not null,
  create_date       DATE not null,
  last_user         VARCHAR2(50) not null,
  last_date         DATE not null
)
;
create index IX_WB_MM_ROLE_1 on WB_MM_ROLE (ID_WB_ROLE, ID_WB_ACCESS_TYPE);
alter table WB_MM_ROLE
  add primary key (ID_WB_MM_ROLE);
alter table WB_MM_ROLE
  add constraint FK_WB_MM_ROLE_WB_ACCESS_TYPE foreign key (ID_WB_ACCESS_TYPE)
  references WB_ACCESS_TYPE (ID_WB_ACCESS_TYPE);
alter table WB_MM_ROLE
  add constraint FK_WB_MM_ROLE_WB_MM foreign key (ID_WB_MAIN_MENU)
  references WB_MAIN_MENU (ID_WB_MAIN_MENU);
alter table WB_MM_ROLE
  add constraint FK_WB_MM_ROLE_WB_ROLE foreign key (ID_WB_ROLE)
  references WB_ROLE (ID_WB_ROLE);

prompt
prompt Creating table WB_PARAM_TYPE
prompt ============================
prompt
create table WB_PARAM_TYPE
(
  id_wb_param_type NUMBER not null,
  num              NUMBER,
  name             VARCHAR2(255) not null,
  description      VARCHAR2(4000),
  save_type        VARCHAR2(50) not null,
  get_type         VARCHAR2(50) not null,
  used             NUMBER default 1,
  create_user      VARCHAR2(50) not null,
  create_date      DATE not null,
  last_user        VARCHAR2(50) not null,
  last_date        DATE not null
)
;
create unique index IX_WB_PT_NAME on WB_PARAM_TYPE (NAME);
alter table WB_PARAM_TYPE
  add primary key (ID_WB_PARAM_TYPE);

prompt
prompt Creating table WB_USER
prompt ======================
prompt
create table WB_USER
(
  id_wb_user  NUMBER not null,
  wb_name     VARCHAR2(255) not null,
  name        VARCHAR2(255) not null,
  create_user VARCHAR2(50) not null,
  create_date DATE not null,
  last_user   VARCHAR2(50) not null,
  last_date   DATE not null,
  e_mail      VARCHAR2(255),
  phone       VARCHAR2(20),
  param_view  VARCHAR2(2000),
  password    VARCHAR2(2000)
)
;
create unique index IX_WB_USER_1 on WB_USER (WB_NAME);
alter table WB_USER
  add primary key (ID_WB_USER);

prompt
prompt Creating table WB_PARAM_VALUE
prompt =============================
prompt
create table WB_PARAM_VALUE
(
  id_wb_user       NUMBER not null,
  id_wb_param_type NUMBER not null,
  param_value      VARCHAR2(2000) not null
)
;
create index IX_WB_PV_USER on WB_PARAM_VALUE (ID_WB_USER);
create unique index IX_WB_PV_USER_TYPE on WB_PARAM_VALUE (ID_WB_USER, ID_WB_PARAM_TYPE);
alter table WB_PARAM_VALUE
  add constraint FK_WB_PV_TYPE foreign key (ID_WB_PARAM_TYPE)
  references WB_PARAM_TYPE (ID_WB_PARAM_TYPE);
alter table WB_PARAM_VALUE
  add constraint FK_WB_PV_USER foreign key (ID_WB_USER)
  references WB_USER (ID_WB_USER);

prompt
prompt Creating table WB_ROLE_USER
prompt ===========================
prompt
create table WB_ROLE_USER
(
  id_wb_role_user NUMBER not null,
  id_wb_role      NUMBER not null,
  id_wb_user      NUMBER not null,
  create_user     VARCHAR2(50) not null,
  create_date     DATE not null,
  last_user       VARCHAR2(50) not null,
  last_date       DATE not null
)
;
create index IX_WB_ROLE_USER_1 on WB_ROLE_USER (ID_WB_ROLE);
create index IX_WB_ROLE_USER_2 on WB_ROLE_USER (ID_WB_USER);
alter table WB_ROLE_USER
  add primary key (ID_WB_ROLE_USER);
alter table WB_ROLE_USER
  add constraint FK_WB_ROLE_USER_WB_ROLE foreign key (ID_WB_ROLE)
  references WB_ROLE (ID_WB_ROLE);
alter table WB_ROLE_USER
  add constraint FK_WB_ROLE_USER_WB_USER foreign key (ID_WB_USER)
  references WB_USER (ID_WB_USER);

prompt
prompt Creating table WB_SETTINGS
prompt ==========================
prompt
create table WB_SETTINGS
(
  id_wb_settings NUMBER not null,
  id_parent      NUMBER,
  num            NUMBER,
  name           VARCHAR2(255) not null,
  short_name     VARCHAR2(50) not null,
  value          VARCHAR2(2000),
  used           NUMBER default 1 not null,
  create_user    VARCHAR2(50) not null,
  create_date    DATE not null,
  last_user      VARCHAR2(50) not null,
  last_date      DATE not null
)
;
create unique index IX_WB_SETTINGS_1 on WB_SETTINGS (ID_PARENT, NAME, USED);
create unique index IX_WB_SETTINGS_2 on WB_SETTINGS (SHORT_NAME);
alter table WB_SETTINGS
  add primary key (ID_WB_SETTINGS);

prompt
prompt Creating sequence GEN_WB_FIELD_TYPE
prompt ===================================
prompt
create sequence GEN_WB_FIELD_TYPE
minvalue 1
maxvalue 999999999999
start with 19
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FORM_CELLS
prompt ===================================
prompt
create sequence GEN_WB_FORM_CELLS
minvalue 1000001
maxvalue 9999999999999999999999999999
start with 1000001
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FORM_CELLS_SYS
prompt =======================================
prompt
create sequence GEN_WB_FORM_CELLS_SYS
minvalue 1
maxvalue 9999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FORM_FIELD
prompt ===================================
prompt
create sequence GEN_WB_FORM_FIELD
minvalue 1000001
maxvalue 9999999999999999999999999999
start with 1000002
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FORM_FIELD_ALIGN
prompt =========================================
prompt
create sequence GEN_WB_FORM_FIELD_ALIGN
minvalue 1
maxvalue 9999999999999999999999999999
start with 5
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FORM_FIELD_SYS
prompt =======================================
prompt
create sequence GEN_WB_FORM_FIELD_SYS
minvalue 1
maxvalue 9999
start with 193
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FORM_TYPE
prompt ==================================
prompt
create sequence GEN_WB_FORM_TYPE
minvalue 1
maxvalue 9999999999999999999999999999
start with 13
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MAIN_MENU
prompt ==================================
prompt
create sequence GEN_WB_MAIN_MENU
minvalue 1000001
maxvalue 9999999999999999999999999999
start with 1000002
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MAIN_MENU_SYS
prompt ======================================
prompt
create sequence GEN_WB_MAIN_MENU_SYS
minvalue 1
maxvalue 9999
start with 11
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MM_FORM
prompt ================================
prompt
create sequence GEN_WB_MM_FORM
minvalue 1000001
maxvalue 9999999999999999999999999999
start with 1000001
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MM_FORM_SYS
prompt ====================================
prompt
create sequence GEN_WB_MM_FORM_SYS
minvalue 1
maxvalue 9999
start with 14
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MM_ROLE
prompt ================================
prompt
create sequence GEN_WB_MM_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 2
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_PARAM_TYPE
prompt ===================================
prompt
create sequence GEN_WB_PARAM_TYPE
minvalue 1
maxvalue 9999999999999999999999999999
start with 2
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_ROLE
prompt =============================
prompt
create sequence GEN_WB_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 3
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_ROLE_USER
prompt ==================================
prompt
create sequence GEN_WB_ROLE_USER
minvalue 1
maxvalue 9999999999999999999999999999
start with 3
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_SETTINGS
prompt =================================
prompt
create sequence GEN_WB_SETTINGS
minvalue 1
maxvalue 9999999999999999999999999999
start with 19
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_USER
prompt =============================
prompt
create sequence GEN_WB_USER
minvalue 1
maxvalue 9999999999999999999999999999
start with 2
increment by 1
cache 20;

prompt
prompt Creating view WB_FORM_CELLS_VIEW
prompt ================================
prompt
create or replace force view wb_form_cells_view as
select t.id_wb_form_cells id_wb_form_cells_view,
       t.id_wb_mm_form    id_wb_mm_form_view,
       t.num,
       t.name,
       t.field_txt,
       t.xls_position_col,
       t.xls_position_row,
       t.xls_type,
       t.field_type,
       t.create_user,
       t.create_date,
       t.last_user,
       t.last_date,
       t.field_name,
       t.type_cells
  from wb_form_cells t;

prompt
prompt Creating view WB_FORM_FIELD_
prompt ============================
prompt
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

prompt
prompt Creating view WB_FORM_FIELD_VIEW
prompt ================================
prompt
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

prompt
prompt Creating view WB_MAIN_MENU_VIEW_TREE
prompt ====================================
prompt
create or replace force view wb_main_menu_view_tree as
Select lpad(mm.name, LENGTH(mm.name) + (level - 1) * 6) tree_name,
       lpad(mm.name, LENGTH(mm.name) + (level - 1) * 4, '-') tree_name_,
       level lev,
       mm.id_wb_main_menu id_wb_main_menu_view_tree,
       mm.id_parent,
       mm.num,
       mm.name,
       mm.used,
       mm.create_user,
       mm.create_date,
       mm.last_user,
       mm.last_date
  from wb_main_menu mm
  start with mm.id_parent is null
  connect by prior mm.id_wb_main_menu = mm.id_parent
  order siblings by mm.num, mm.name;

prompt
prompt Creating package WB
prompt ===================
prompt
CREATE OR REPLACE PACKAGE WB is
wb_user varchar2(50);
wb_id_mm_fr number;

--+--Сохраняет текущего пользователя
procedure save_wb_user(i_user varchar2);

--+--Возвращает текущего пользователя
function get_wb_user return varchar2;

--+--Возвращает ID текущего пользователя
function get_wb_user_id return number;

--+--Andrey.Lysikov (14.02.2013)
--+--Возвращает ссылку на загрузку файла (унифицированная функция)
function create_download_link(link varchar2, text varchar2) return varchar2;

--+--Andrey.Lysikov (14.02.2013)
--+--Возвращает декодированное и разжатое преобразованное к кодировке содержимое CLOB (основной функционал в рамках переноса)
function decode_base64_clob(p_clob clob) return blob;

--+--Andrey.Lysikov (14.02.2013)
--+--Возвращает xmlnode (основной функционал в рамках переноса)
function decode_xml_blob_to_node(p_clob blob) return clob;

--+--Andrey.Lysikov (14.02.2013)
--+--Изменяет текст внутри CLOB (основной функционал в рамках переноса)
function replace_clob(p_clob in clob, p_what in varchar2, p_with in varchar2) return clob;

--+--Возвращает доступ к ветке main_menu
function get_access_main_menu(l_id_wb_main_menu number) return varchar2;

end;
/

prompt
prompt Creating view WB_MAIN_MENU_VIEW_TREE_USV
prompt ========================================
prompt
create or replace force view wb_main_menu_view_tree_usv as
Select lpad(mm.name, LENGTH(mm.name) + (level - 1) * 6) tree_name,
       lpad(mm.name, LENGTH(mm.name) + (level - 1) * 4, '-') tree_name_,
       level lev,
       mm.id_wb_main_menu id_wb_main_menu_view_tree_usv,
       mm.id_parent,
       mm.num,
       mm.name,
       mm.used,
       mm.create_user,
       mm.create_date,
       mm.last_user,
       mm.last_date
  from wb_main_menu mm
  where wb.get_access_main_menu(mm.id_wb_main_menu) = 'enable'
  start with mm.id_parent is null
  connect by prior mm.id_wb_main_menu = mm.id_parent
  order siblings by mm.num, mm.name;

prompt
prompt Creating view WB_MM_FORM_VIEW
prompt =============================
prompt
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

prompt
prompt Creating view WB_SETTINGS_VIEW_TREE
prompt ===================================
prompt
create or replace force view wb_settings_view_tree as
Select lpad('                     ', (level - 1) * 6, '  ')||s.name tree_name,
       lpad('---------------------', (level - 1) * 4, '--')||s.name tree_name_,
       level lev,
       s.id_wb_settings id_wb_settings_view_tree,
       s.id_parent,
       s.num,
       s.name,
       s.short_name,
       s.value,
       s.used,
       s.create_user,
       s.create_date,
       s.last_user,
       s.last_date
  from wb_settings s
  start with s.id_parent is null
  connect by prior s.id_wb_settings = s.id_parent
  order siblings by s.num, s.name, s.short_name
;

prompt
prompt Creating package WB_SETT
prompt ========================
prompt
CREATE OR REPLACE PACKAGE WB_SETT as

/*type t_row_char is record (value varchar2(2000));
type t_tab_char is table of t_row_char;

type t_row_number is record (value number);
type t_tab_number is table of t_row_number;

type t_row_date is record (value date);
type t_tab_date is table of t_row_date;
*/
type t_tab_char   is table of varchar2(2000);
type t_tab_number is table of number;
type t_tab_date   is table of date;

--+-- Возвращает наименование параметра
function get_name(i_short_name varchar2) return varchar2;

--+-- Возвращает значение параметра настройки
function get_settings_val(i_short_name varchar2) return varchar2;

--+-- Возвращает значение параметра настройки в типе varchar2
function get_settings_val_char(i_short_name varchar2)   return varchar2;

--+-- Возвращает значение параметра настройки в типе number
function get_settings_val_number(i_short_name varchar2) return number;

--+-- Возвращает значение параметра настройки в типе date
function get_settings_val_date(i_short_name varchar2)   return date;

--+-- Возвращает количество действующих параметров настройки
function get_settings_count_used_val(i_short_name varchar2) return number;

--+-- Возвращает значения параметров настройки в типе varchar2
function get_settings_many_val_char(i_short_name varchar2)   return t_tab_char   pipelined;

--+-- Возвращает значения параметров настройки в типе number
function get_settings_many_val_number(i_short_name varchar2) return t_tab_number pipelined;

--+-- Возвращает значения параметров настройки в типе date
function get_settings_many_val_date(i_short_name varchar2)   return t_tab_date   pipelined;


end;
/

prompt
prompt Creating package WB_MAIL
prompt ========================
prompt
CREATE OR REPLACE PACKAGE WB_MAIL
as

crlf              varchar2(10)  := UTL_TCP.crlf;
l_recipient_admin varchar2(255) := wb_sett.get_settings_val_char('RECIPIENT_ADMIN');

function send_mail(recipient varchar2,
                   subject   varchar2,
                   text      clob) return number;

function send_mail_admin(subject   varchar2,
                         text      clob) return number;

function send_mail_role(role_wb_name varchar2,
                        subject      varchar2,
                        text         clob) return number;

function send_mail_user(user_wb_name varchar2,
                        subject      varchar2,
                        text         clob) return number;

end;
/

prompt
prompt Creating package WB_PARAM_SG
prompt ============================
prompt
CREATE OR REPLACE PACKAGE WB_PARAM_SG is

--------------------------------------------------------------------------------
--+--Сохраняет значение темпового параметра в типе VARCHAR2
procedure save_tmp$param_value_str(p_param_type  varchar2,
                                   p_param_value varchar2);

--+--Сохраняет значение темпового параметра в типе NUMBER
procedure save_tmp$param_value_num(p_param_type  varchar2,
                                   p_param_value number);

--+--Сохраняет значение темпового параметра в типе INTEGER
procedure save_tmp$param_value_int(p_param_type  varchar2,
                                   p_param_value number);

--+--Сохраняет значение темпового параметра в типе DATE
procedure save_tmp$param_value_date(p_param_type  varchar2,
                                    p_param_value date);

--+--Сохраняет значение темпового параметра в типе DATE_TIME
procedure save_tmp$param_value_date_time(p_param_type  varchar2,
                                         p_param_value date);

--+--Возвращает значение темпового параметра в типе VARCHAR2
function get_tmp$param_value_str      (p_param_type varchar2) return varchar2 deterministic;

--+--Возвращает значение темпового параметра в типе NUMBER
function get_tmp$param_value_num      (p_param_type varchar2) return number deterministic;

--+--Возвращает значение темпового параметра в типе INTEGER
function get_tmp$param_value_int      (p_param_type varchar2) return number deterministic;

--+--Возвращает значение темпового параметра в типе DATE
function get_tmp$param_value_date     (p_param_type varchar2) return date deterministic;

--+--Возвращает значение темпового параметра в типе DATE_TIME
function get_tmp$param_value_date_time(p_param_type varchar2) return date deterministic;

end;
/

prompt
prompt Creating package body WB
prompt ========================
prompt
CREATE OR REPLACE PACKAGE BODY WB is

--+--Сохраняет текущего пользователя
procedure save_wb_user(i_user varchar2)
as
begin
  wb.wb_user := i_user;
  commit;
end;

--+--Возвращает ссылку на загрузку файла (унифицированная функция)
function create_download_link(link varchar2, text varchar2)
return varchar2
as
begin
  return '<a href=''' || link || '''  class = ''ui-widget ui-widget-content'' title=''' || text || ''' style = ''border:0px;background:transparent''
           target=''_blank'' ><span class=''ui-icon ui-icon-arrowthickstop-1-s'' style=''float: left;''></span> ' || text || '</a>';
end;

--+--Изменяет текст внутри CLOB (основной функционал в рамках переноса)
function replace_clob(p_clob in clob,
                        p_what in varchar2,
                        p_with in varchar2) return clob is

    c_whatlen constant pls_integer := length(p_what);
    c_withlen constant pls_integer := length(p_with);

    l_return  clob;
    l_segment clob;
    l_pos     pls_integer := 1 - c_withlen;
    l_offset  pls_integer := 1;

  begin

    if p_what is not null then
      while l_offset < dbms_lob.getlength(p_clob) loop
        l_segment := dbms_lob.substr(p_clob, 32767, l_offset);
        loop
          l_pos := dbms_lob.instr(l_segment, p_what, l_pos + c_withlen);
          exit when(nvl(l_pos, 0) = 0) or(l_pos = 32767 - c_withlen);
          l_segment := to_clob(dbms_lob.substr(l_segment, l_pos - 1) ||
                               p_with ||
                               dbms_lob.substr(l_segment,
                                               32767 - c_whatlen - l_pos -
                                               c_whatlen + 1,
                                               l_pos + c_whatlen));
        end loop;
        l_return := l_return || l_segment;
        l_offset := l_offset + 32767 - c_whatlen;
      end loop;
    end if;

    return(l_return);

end;

--+--Возвращает декодированное содержимое CLOB (основной функционал в рамках переноса)
function decode_base64_clob(p_clob clob) return blob is
    l_blob   blob;
    t_blob   blob;
    l_len    number;
    l_pos    number := 1;
    l_buffer varchar2(2048);
    l_amount number := 2048;
  begin
    l_len := dbms_lob.getlength(p_clob);
    dbms_lob.createtemporary(l_blob, true);

    -- для начала декодируем из base64 (binary safe)
    while l_pos <= l_len loop
      dbms_lob.read(p_clob, l_amount, l_pos, l_buffer);
      l_buffer := utl_encode.text_decode(l_buffer, encoding => utl_encode.base64);
      l_pos    := l_pos + l_amount;
      dbms_lob.writeappend(l_blob, length(l_buffer), utl_raw.cast_to_raw(l_buffer));
    end loop;

    -- Разжимаем содержимое
    dbms_lob.createtemporary(t_blob, true);
    t_blob:=utl_compress.lz_uncompress(l_blob);

    return t_blob;
end;

--+--Возвращает xmlnode (основной функционал в рамках переноса)
function decode_xml_blob_to_node(p_clob blob) return clob is
    o_clob   clob;
    s_offset number := 1;
    d_offset number := 1;
    warn     number := 0;
    iLang    integer:=DBMS_LOB.default_lang_ctx;
  begin
     dbms_lob.createtemporary(o_clob, true);
    -- Проебразовываем к CLOB для дальнейшей работы
    dbms_lob.converttoclob( dest_lob => o_clob,
                            src_blob => p_clob,
                            amount => dbms_lob.lobmaxsize,
                            dest_offset => d_offset,
                            src_offset => s_offset,
                            blob_csid => DBMS_LOB.default_csid,
                            lang_context => iLang,
                            warning => warn
                           );
    return o_clob;
end;
--Возвращает текущего пользователя
function get_wb_user
return varchar2
as
begin
  return wb.wb_user;
end;

--+--Возвращает ID текущего пользователя
function get_wb_user_id
return number
as
  res number;
begin
  Select t.id_wb_user
    into res
    from wb_user t
    where t.wb_name = wb.wb_user;
  return res;
exception
  when NO_DATA_FOUND then return null;
end;

--+--Возвращает доступ к ветке main_menu
function get_access_main_menu(l_id_wb_main_menu number)
return varchar2
as
  res varchar2(50);
begin
  Select nvl(max(mm.access_type), 'disable')
    into res
    from (Select mm.id_wb_main_menu,
                 mm.id_parent,
                 mm.num,
                 mm.name,
                 nvl(t_e.wb_name, t_d.wb_name) access_type
            from wb_main_menu mm
            left join (Select mr.id_wb_main_menu,
                              a.wb_name
                         from wb_mm_role mr
                         inner join wb_access_type a on a.id_wb_access_type = mr.id_wb_access_type
                                                    and a.wb_name           = 'enable'
                         inner join wb_role r        on r.id_wb_role        = mr.id_wb_role
                         inner join wb_role_user ru  on ru.id_wb_role       = r.id_wb_role
                         inner join wb_user u        on u.id_wb_user        = ru.id_wb_user
                                                    and u.wb_name           = get_wb_user) t_e on mm.id_wb_main_menu = t_e.id_wb_main_menu
            left join (Select mr.id_wb_main_menu,
                              a.wb_name
                           from wb_mm_role mr
                         inner join wb_access_type a on a.id_wb_access_type = mr.id_wb_access_type
                                                    and a.wb_name           = 'disable'
                         inner join wb_role r        on r.id_wb_role        = mr.id_wb_role
                         inner join wb_role_user ru  on ru.id_wb_role       = r.id_wb_role
                         inner join wb_user u        on u.id_wb_user        = ru.id_wb_user
                                                    and u.wb_name           = get_wb_user) t_d on mm.id_wb_main_menu = t_d.id_wb_main_menu

            where mm.used = 1) mm
    start with mm.id_wb_main_menu = l_id_wb_main_menu
    connect by prior mm.id_wb_main_menu = mm.id_parent
    order siblings by mm.num;
  return res;
exception
  when NO_DATA_FOUND then
    return 'disable';
end;

end;
/

prompt
prompt Creating package body WB_MAIL
prompt =============================
prompt
CREATE OR REPLACE PACKAGE BODY WB_MAIL
as
function send_mail(recipient varchar2,
                   subject   varchar2,
                   text      clob) return number
as
  HOST       varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_HOST');
  sender     varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_SENDER');
  CHARSET    varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_CHARSET');
  encoding   varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_ENCODING');
  authlogin  varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_AUTHLOGIN');
  authpwd    varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_AUTHPWD');
  destcset   varchar2(255) := wb_sett.get_settings_val_char('SETTINGS_MAIL_SMTP_DESTCSET');
  mail_conn  UTL_SMTP.connection;
  --err_msg   VARCHAR2(1000);
  i          integer;
  len        integer;
BEGIN
  mail_conn := UTL_SMTP.open_connection(HOST, 25);
  UTL_SMTP.ehlo(mail_conn, HOST);
  UTL_SMTP.helo (mail_conn, HOST);

  IF authlogin is not null then
    UTL_SMTP.command(mail_conn, 'AUTH LOGIN');
    UTL_SMTP.command(mail_conn, utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(authlogin))));
    UTL_SMTP.command(mail_conn, utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(authpwd))));
  END IF;

  UTL_SMTP.mail(mail_conn, sender);
  UTL_SMTP.rcpt(mail_conn, recipient);
  UTL_SMTP.open_data(mail_conn);
  UTL_SMTP.write_data(mail_conn, 'From: ' || sender || UTL_TCP.crlf);
  UTL_SMTP.write_data(mail_conn, 'To: ' || recipient || UTL_TCP.crlf);
  UTL_SMTP.write_raw_data(mail_conn, UTL_RAW.cast_to_raw(CONVERT('Subject: ' || subject || UTL_TCP.crlf, destcset)));
  UTL_SMTP.write_data(mail_conn,
                      'Content-Type: ' || CHARSET || UTL_TCP.crlf);
  UTL_SMTP.write_data(mail_conn,
                      'Content-Transfer-Encoding: ' || encoding ||
                      UTL_TCP.crlf);
  UTL_SMTP.write_data(mail_conn, UTL_TCP.crlf);
  i := 0;
  while i < length(text) loop
    len := length(text) - i;
    if len > 32000 then
      len := 32000;
    end if;
    UTL_SMTP.write_raw_data(mail_conn,
                            UTL_RAW.cast_to_raw(CONVERT(dbms_lob.substr(text,
                                                                        len,
                                                                        i + 1),
                                                        destcset)));
    i := i + len;
  end loop;
  UTL_SMTP.close_data(mail_conn);
  UTL_SMTP.quit(mail_conn);
  dbms_output.put_line('Успешно');
  return 1;
EXCEPTION
  WHEN OTHERS THEN
    --err_msg := SQLERRM;
    --write_log('sendmail', err_msg);
    UTL_SMTP.close_data(mail_conn);
    UTL_SMTP.quit(mail_conn);
    dbms_output.put_line('Неудачно');
    RAISE;

END;


function send_mail_admin(subject   varchar2,
                         text      clob)
  return number
as
  l_res number;
begin
  l_res := wb_mail.send_mail(wb_mail.l_recipient_admin, subject, text);
  --dbms_output.put_line('Результат = '||to_char(l_res)||';');
  return l_res;
end;

function send_mail_role(role_wb_name varchar2,
                        subject      varchar2,
                        text         clob)
return number
as
  l_res number := 0;
begin
  for i in (Select wu.wb_name,
                   wu.name,
                   wu.e_mail
              from wb_role wr
              inner join wb_role_user wru on wru.id_wb_role = wr.id_wb_role
              inner join wb_user      wu  on wu.id_wb_user  = wru.id_wb_user
              where wr.wb_name = role_wb_name
                and wu.e_mail is not null
              order by wu.id_wb_user)
    loop
      l_res := l_res + wb_mail.send_mail(i.e_mail, subject, text);
    end loop;
  return l_res;
end;

function send_mail_user(user_wb_name varchar2,
                        subject      varchar2,
                        text         clob)
return number
as
  l_res number := 0;
begin
  for i in (Select wu.wb_name,
                   wu.name,
                   wu.e_mail
              from wb_user wu
              where wu.wb_name = user_wb_name
                and wu.e_mail is not null)
    loop
      l_res := l_res + wb_mail.send_mail(i.e_mail, subject, text);
    end loop;
  return l_res;
end;

end;
/

prompt
prompt Creating package body WB_PARAM_SG
prompt =================================
prompt
CREATE OR REPLACE PACKAGE BODY WB_PARAM_SG is

function get_param_type_id(p_param_type_name      varchar2)
return varchar2
as
  v_id_wb_param_type number;
begin
  Select pt.id_wb_param_type
    into v_id_wb_param_type
    from wb_param_type pt
    where pt.used = 1
      and pt.name = upper(p_param_type_name);
  return v_id_wb_param_type;
exception
  when OTHERS then
	raise_application_error(-20001, 'Для '|| upper(p_param_type_name) ||' параметра отсутсвует описание.');   
end;

--+--Сохраняет темповые параметры пользователя
procedure save_tmp$param_value(p_param_type  varchar2,
                               p_param_value varchar2)
as
  v_id_wb_user       number := wb.get_wb_user_id;
  v_id_wb_param_type number := get_param_type_id(p_param_type);
begin
  if p_param_type is not null then
    begin
    insert into wb_param_value(id_wb_user, id_wb_param_type, param_value)
      values (v_id_wb_user, v_id_wb_param_type, p_param_value);
    exception
      when OTHERS then
        update wb_param_value pv set
          pv.param_value = p_param_value
          where pv.id_wb_user       = v_id_wb_user
            and pv.id_wb_param_type = v_id_wb_param_type;
    end;
  end if;
end;

--+--Сохраняет значение темпового параметра в типе VARCHAR2
procedure save_tmp$param_value_str(p_param_type  varchar2,
                                   p_param_value varchar2)
as
begin
  save_tmp$param_value(p_param_type, to_char(p_param_value));
end;

--+--Сохраняет значение темпового параметра в типе NUMBER
procedure save_tmp$param_value_num(p_param_type  varchar2,
                                   p_param_value number)
as
begin
  save_tmp$param_value(p_param_type, to_char(p_param_value));
end;

--+--Сохраняет значение темпового параметра в типе INTEGER
procedure save_tmp$param_value_int(p_param_type  varchar2,
                                   p_param_value number)
as
begin
  save_tmp$param_value(p_param_type, to_char(trunc(p_param_value, 0)));
end;

--+--Сохраняет значение темпового параметра в типе DATE
procedure save_tmp$param_value_date(p_param_type  varchar2,
                                    p_param_value date)
as
begin
  save_tmp$param_value(p_param_type, to_char(trunc(p_param_value, 'dd'), 'dd.mm.yyyy'));
end;

--+--Сохраняет значение темпового параметра в типе DATE_TIME
procedure save_tmp$param_value_date_time(p_param_type  varchar2,
                                         p_param_value date)
as
begin
  save_tmp$param_value(p_param_type, to_char(p_param_value, 'dd.mm.yyyy hh24:mi:ss'));
end;


--+--Возвращяет темповые параметры
function get_tmp$param_value(p_param_type  varchar2)
return varchar2
as
  v_id_wb_user       number := wb.get_wb_user_id;
  v_id_wb_param_type number := get_param_type_id(p_param_type);
  v_res              varchar2(4000);
begin
  Select pv.param_value
    into v_res
    from wb_param_value pv
    where pv.id_wb_user       = v_id_wb_user
      and pv.id_wb_param_type = v_id_wb_param_type;
  return v_res;
exception
  when NO_DATA_FOUND then
    return null;
end;

--+--Возвращает значение темпового параметра в типе VARCHAR2
function get_tmp$param_value_str(p_param_type varchar2)
return varchar2
as
  v_res varchar2(2000);
begin
  v_res := to_char(get_tmp$param_value(p_param_type));
  return v_res;
end;

--+--Возвращает значение темпового параметра в типе NUMBER
function get_tmp$param_value_num(p_param_type varchar2)
return number
as
  v_res number;
begin
  v_res := to_number(get_tmp$param_value(p_param_type));
  return v_res;
end;

--+--Возвращает значение темпового параметра в типе INTEGER
function get_tmp$param_value_int(p_param_type varchar2)
return number
as
  v_res number;
begin
  v_res := round(to_number(get_tmp$param_value(p_param_type)), 0);
  return v_res;
end;

--+--Возвращает значение темпового параметра в типе DATE
function get_tmp$param_value_date(p_param_type varchar2)
return date
as
  v_param_value varchar2(2000) := get_tmp$param_value(p_param_type);
  v_res date;
begin
  if length(v_param_value) = 10 then
    v_res := to_date(v_param_value, 'dd.mm.yyyy');
  else
    v_res := trunc(to_date(v_param_value, 'dd.mm.yyyy hh24:mi:ss'), 'dd');
  end if;
  return v_res;
end;

--+--Возвращает значение темпового параметра в типе DATE_TIME
function get_tmp$param_value_date_time(p_param_type varchar2)
return date
as
  v_res date;
begin
  v_res := to_date(get_tmp$param_value(p_param_type), 'dd.mm.yyyy hh24:mi:ss');
  return v_res;
end;

end;
/

prompt
prompt Creating package body WB_SETT
prompt =============================
prompt
CREATE OR REPLACE PACKAGE BODY WB_SETT as

--+-- Возвращает наименование параметра
function get_name(i_short_name varchar2)
return varchar2
as
  l_res varchar2(32000);
begin
  Select s.name
    into l_res
    from wb_settings s
    where s.short_name = i_short_name
      and s.used       = 1;
  return l_res;
exception
  when NO_DATA_FOUND then
    return null;
end;

--+-- Возвращает значение параметра настройки
function get_settings_val(i_short_name varchar2)
return varchar2
as
  l_res varchar2(32000);
begin
  Select s.value
    into l_res
    from wb_settings s
    where s.short_name = i_short_name
      and s.used       = 1;
  return l_res;
exception
  when NO_DATA_FOUND then
    return null;
end;

--+-- Возвращает значение параметра настройки в типе varchar2
function get_settings_val_char(i_short_name varchar2)
return varchar2
as
  l_res varchar2(32000);
begin
  l_res := to_char(get_settings_val(i_short_name));
  return l_res;
end;

--+-- Возвращает значение параметра настройки в типе number
function get_settings_val_number(i_short_name varchar2)
return number
as
  l_res number;
begin
  l_res := to_number(get_settings_val(i_short_name));
  return l_res;
end;

--+-- Возвращает значение параметра настройки в типе date
function get_settings_val_date(i_short_name varchar2)
return date
as
  l_res date;
begin
  l_res := to_date(get_settings_val(i_short_name), 'dd.mm.yyyy hh24:mi:ss');
  return l_res;
end;


--+-- Возвращает количество действующих параметров настройки
function get_settings_count_used_val(i_short_name varchar2)
return number
as
  l_res number;
begin
  Select count(*)
    into l_res
    from wb_settings s
    where s.short_name = i_short_name
      and s.used       = 1;
  return l_res;
end;


--+-- Возвращает значения параметров настройки в типе varchar2
function get_settings_many_val_char(i_short_name varchar2)
return t_tab_char pipelined
as
begin
  if get_settings_count_used_val(i_short_name) > 0 then
    for i in (select to_char(regexp_substr(val,'[^,]+',1,level)) val
                from (Select to_char(get_settings_val(i_short_name))||',' val
                        from dual)
                connect by instr(val, ',', 1, level) > 0)
      loop
        pipe row (i.val);
      end loop;
  end if;
  return;
end;

--+-- Возвращает значения параметров настройки в типе number
function get_settings_many_val_number(i_short_name varchar2)
return t_tab_number pipelined
as
begin
  if get_settings_count_used_val(i_short_name) > 0 then
    for i in (select to_number(regexp_substr(val,'[^,]+',1,level)) val
                from (Select to_char(get_settings_val(i_short_name))||',' val
                        from dual)
                connect by instr(val, ',', 1, level) > 0)
      loop
        pipe row (i.val);
      end loop;
  end if;
  return;
end;

--+-- Возвращает значения параметров настройки в типе date
function get_settings_many_val_date(i_short_name varchar2)
return t_tab_date pipelined
as
begin
  if get_settings_count_used_val(i_short_name) > 0 then
    for i in (select to_date(regexp_substr(val,'[^,]+',1,level), 'dd.mm.yyyy hh24:mi:ss') val
                from (Select to_char(get_settings_val(i_short_name))||',' val
                        from dual)
                connect by instr(val, ',', 1, level) > 0)
      loop
        pipe row (i.val);
      end loop;
  end if;
  return;
end;

end;
/

prompt
prompt Creating trigger T_A_I_WB_MM_FORM
prompt =================================
prompt
CREATE OR REPLACE TRIGGER T_A_I_WB_MM_FORM
AFTER INSERT
ON WB_MM_FORM
FOR EACH ROW
DECLARE
  l_id_wb_mm_form number        := :new.id_wb_mm_form;
  l_form_type     varchar2(255);
  l_object_name   varchar2(255) := upper(:new.object_name);
BEGIN
  Select ft.name
    into l_form_type
    from wb_form_type ft
    where  ft.id_wb_form_type = :new.id_wb_form_type;

  if substr(l_form_type, 1, 5) = 'GRID_' or  substr(l_form_type, 1, 5) = 'TREE_' then
    -- Обновляем табличку со столбцами
    insert into wb_form_field(id_wb_mm_form, num, name, field_name, field_type, is_read_only, id_wb_form_field_align, width)
    Select l_id_wb_mm_form,
           t.column_id,
           t.name,
           t.column_name,
           t.field_type,
           t.is_read_only,
           t.id_wb_form_field_align,
           t.width
      from (Select decode(tc.column_name, 'CREATE_USER',         91,
                                          'CREATE_DATE',         92,
                                          'LAST_USER',           93,
                                          'LAST_DATE',           94,
                                          'DELETE_USER',         95,
                                          'DELETE_DATE',         96,
                                          'ID_'||l_object_name, 100,
                                                                tc.column_id * 10) column_id,
                   decode(tc.column_name, 'CREATE_USER',        'Создатель',
                                          'CREATE_DATE',        'Дата создания',
                                          'LAST_USER',          'Последний редактор',
                                          'LAST_DATE',          'Дата редактирования',
                                          'DELETE_USER',        'Кто удалил',
                                          'DELETE_DATE',        'Когда удалили',
                                          'ID_'||l_object_name, 'ID (not display)',
                                                                tc.column_name) name,
                   tc.column_name,

                   decode(tc.column_name, 'CREATE_USER',        'S',
                                          'CREATE_DATE',        'D',
                                          'LAST_USER',          'S',
                                          'LAST_DATE',          'D',
                                          'DELETE_USER',        'S',
                                          'DELETE_DATE',        'D',
                                          'ID_'||l_object_name, 'I',
                                                                decode(tc.data_type, 'DATE',     'D',
                                                                                     'VARCHAR2', 'S',
                                                                                     'NUMBER',   'N',
                                                                                                 'S')) field_type,
                   case when tc.column_name in ('CREATE_USER', 'CREATE_DATE', 'LAST_USER', 'LAST_DATE',
                                                'DELETE_USER', 'DELETE_DATE', 'ID_'||l_object_name) then 1
                                                                                                    else 0
                   end  is_read_only,
                   decode(tc.data_type, 'NUMBER', 3, 1) id_wb_form_field_align,
                   case when tc.column_name in ('CREATE_USER', 'LAST_USER', 'DELETE_USER') then 150
                        when tc.column_name in ('CREATE_DATE', 'LAST_DATE', 'DELETE_DATE') then 120
                        when tc.COLUMN_NAME = 'ID_'||l_object_name                         then  80
                                                                                           else 200
                   end width
              from user_tab_columns tc
              where upper(tc.TABLE_NAME) = l_object_name
            union all
            Select 0 column_id,
                   '# п/п (not display)' name,
                   'R_NUM' column_name,
                   'I' field_type,
                   1 is_read_only,
                   3 id_wb_form_field_align,
                   80 width
              from dual) t
    order by t.column_id;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_WB_FIELD_TYPE
prompt =====================================
prompt
create or replace trigger "T_B_IU_WB_FIELD_TYPE"
BEFORE INSERT OR UPDATE
ON WB_FIELD_TYPE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_FIELD_TYPE is null then
      Select GEN_WB_FIELD_TYPE.nextval
        into :new.ID_WB_FIELD_TYPE
        from dual;
    end if;
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
prompt Creating trigger T_B_IU_WB_FORM_CELLS
prompt =====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_FORM_CELLS"
BEFORE INSERT OR UPDATE
ON WB_FORM_CELLS
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_FORM_CELLS is null then
      if :new.id_wb_mm_form < 0 then
        Select -GEN_WB_FORM_CELLS_SYS.nextval
          into :new.ID_WB_FORM_CELLS
         from dual;
      else
        Select GEN_WB_FORM_CELLS.nextval
          into :new.ID_WB_FORM_CELLS
         from dual;
      end if;
    end if;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;

  :new.field_name    := upper(:new.field_name);
END;
/

prompt
prompt Creating trigger T_B_IU_WB_FORM_FIELD
prompt =====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_FORM_FIELD"
BEFORE INSERT OR UPDATE
ON WB_FORM_FIELD
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_FORM_FIELD is null then
      if :new.id_wb_mm_form < 0 then
        Select -GEN_WB_FORM_FIELD_SYS.nextval
          into :new.ID_WB_FORM_FIELD
          from dual;
      else
        Select GEN_WB_FORM_FIELD.nextval
          into :new.ID_WB_FORM_FIELD
          from dual;
      end if;
    end if;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
    :new.FIELD_NAME  := upper(:new.FIELD_NAME);
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
    :new.FIELD_NAME  := upper(:new.FIELD_NAME);
  end if;

  :new.field_name    := upper(:new.field_name);
  if :new.width is null then
    :new.width := 200;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_WB_FORM_FIELD_ALIGN
prompt ===========================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_FORM_FIELD_ALIGN"
BEFORE INSERT OR UPDATE
ON WB_FORM_FIELD_ALIGN
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_FORM_FIELD_ALIGN is null then
      Select GEN_WB_FORM_FIELD_ALIGN.nextval
        into :new.ID_WB_FORM_FIELD_ALIGN
        from dual;
    end if;
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
prompt Creating trigger T_B_IU_WB_FORM_TYPE
prompt ====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_FORM_TYPE"
BEFORE INSERT OR UPDATE
ON WB_FORM_TYPE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_FORM_TYPE is null then
      Select -GEN_WB_FORM_TYPE.nextval
        into :new.ID_WB_FORM_TYPE
        from dual;
    end if;
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
prompt Creating trigger T_B_IU_WB_MAIN_MENU
prompt ====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_MAIN_MENU"
BEFORE INSERT OR UPDATE
ON WB_MAIN_MENU
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_MAIN_MENU is null then
      if :new.id_parent < 0 then
        Select -GEN_WB_MAIN_MENU_SYS.nextval
          into :new.ID_WB_MAIN_MENU
          from dual;
      else
        Select GEN_WB_MAIN_MENU.nextval
          into :new.ID_WB_MAIN_MENU
          from dual;
      end if;
    end if;
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
prompt Creating trigger T_B_IU_WB_MM_FORM
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_MM_FORM"
BEFORE INSERT OR UPDATE
ON WB_MM_FORM
FOR EACH ROW
DECLARE
  function get_form_type_grid(p_id_wb_for_type number)
  return number
  as
    v_res number;
  begin
    select t.id_wb_form_type
      into v_res
      from wb_form_type t
      where (t.name like 'GRID_%' or t.name like 'TREE_GRID_%')
        and t.id_wb_form_type = p_id_wb_for_type;
    return 1;
  exception
    when NO_DATA_FOUND then
      return 0;
  end;
BEGIN
  if INSERTING then
    if :new.ID_WB_MM_FORM is null then
      if :new.id_wb_main_menu < 0 then
        Select -GEN_WB_MM_FORM_SYS.nextval
          into :new.ID_WB_MM_FORM
          from dual;
      else
        Select GEN_WB_MM_FORM.nextval
          into :new.ID_WB_MM_FORM
          from dual;
      end if;
    end if;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;

  :new.object_name := upper(:new.object_name);
  :new.owner       := upper(:new.owner);
  if :new.edit_button is null and
     get_form_type_grid(:new.id_wb_form_type) = 1  then
    :new.edit_button := 'A,E,D';
  end if;
  :new.edit_button := upper(:new.edit_button);
END;
/

prompt
prompt Creating trigger T_B_IU_WB_MM_ROLE
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_MM_ROLE"
BEFORE INSERT OR UPDATE
ON WB_MM_ROLE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_MM_ROLE is null then
      Select GEN_WB_MM_ROLE.nextval
        into :new.ID_WB_MM_ROLE
        from dual;
    end if;
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
prompt Creating trigger T_B_IU_WB_PARAM_TYPE
prompt =====================================
prompt
CREATE OR REPLACE TRIGGER T_B_IU_WB_PARAM_TYPE
BEFORE INSERT OR UPDATE
ON WB_PARAM_TYPE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_PARAM_TYPE is null then
      Select GEN_WB_PARAM_TYPE.nextval
        into :new.ID_WB_PARAM_TYPE
        from dual;
    end if;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;

  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  :new.name      := upper(:new.name);
  :new.save_type := upper(:new.save_type);
  :new.get_type  := upper(:new.get_type);
END;
/

prompt
prompt Creating trigger T_B_IU_WB_ROLE
prompt ===============================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_ROLE"
BEFORE INSERT OR UPDATE
ON WB_ROLE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_ROLE is null then
      Select GEN_WB_ROLE.nextval
        into :new.ID_WB_ROLE
        from dual;
    end if;
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
prompt Creating trigger T_B_IU_WB_ROLE_USER
prompt ====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_WB_ROLE_USER"
BEFORE INSERT OR UPDATE
ON WB_ROLE_USER
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_ROLE_USER is null then
      Select GEN_WB_ROLE_USER.nextval
        into :new.ID_WB_ROLE_USER
        from dual;
    end if;
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
prompt Creating trigger T_B_IU_WB_SETTINGS
prompt ===================================
prompt
CREATE OR REPLACE TRIGGER T_B_IU_WB_SETTINGS
BEFORE INSERT OR UPDATE
ON WB_SETTINGS
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_SETTINGS is null then
      Select GEN_WB_SETTINGS.nextval
        into :new.ID_WB_SETTINGS
        from dual;
    end if;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
  end if;
  :new.short_name := upper(:new.short_name);
END;
/

prompt
prompt Creating trigger T_B_IU_WB_USER
prompt ===============================
prompt
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

prompt
prompt Creating trigger T_B_U_WB_FORM_FIELD_ERR
prompt ========================================
prompt
CREATE OR REPLACE TRIGGER T_B_U_WB_FORM_FIELD_ERR
BEFORE UPDATE
ON WB_FORM_FIELD
FOR EACH row
begin
   if (:old.id_wb_form_field <= 0) then
    raise_application_error(-20001, 'Нельзя изменять строки системных настроек');
  end if;
END;
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
set feedback off
prompt Disabling triggers for WB_ACCESS_TYPE...
alter table WB_ACCESS_TYPE disable all triggers;
prompt Disabling triggers for WB_CHART_TYPE...
alter table WB_CHART_TYPE disable all triggers;
prompt Disabling triggers for WB_FIELD_TYPE...
alter table WB_FIELD_TYPE disable all triggers;
prompt Disabling triggers for WB_FORM_TYPE...
alter table WB_FORM_TYPE disable all triggers;
prompt Disabling triggers for WB_MAIN_MENU...
alter table WB_MAIN_MENU disable all triggers;
prompt Disabling triggers for WB_MM_FORM...
alter table WB_MM_FORM disable all triggers;
prompt Disabling triggers for WB_FORM_CELLS...
alter table WB_FORM_CELLS disable all triggers;
prompt Disabling triggers for WB_FORM_FIELD_ALIGN...
alter table WB_FORM_FIELD_ALIGN disable all triggers;
prompt Disabling triggers for WB_FORM_FIELD...
alter table WB_FORM_FIELD disable all triggers;
prompt Disabling triggers for WB_ROLE...
alter table WB_ROLE disable all triggers;
prompt Disabling triggers for WB_MM_ROLE...
alter table WB_MM_ROLE disable all triggers;
prompt Disabling triggers for WB_PARAM_TYPE...
alter table WB_PARAM_TYPE disable all triggers;
prompt Disabling triggers for WB_USER...
alter table WB_USER disable all triggers;
prompt Disabling triggers for WB_PARAM_VALUE...
alter table WB_PARAM_VALUE disable all triggers;
prompt Disabling triggers for WB_ROLE_USER...
alter table WB_ROLE_USER disable all triggers;
prompt Disabling triggers for WB_SETTINGS...
alter table WB_SETTINGS disable all triggers;
prompt Disabling foreign key constraints for WB_MAIN_MENU...
alter table WB_MAIN_MENU disable constraint FK_WB_MM_PARENT;
prompt Disabling foreign key constraints for WB_MM_FORM...
alter table WB_MM_FORM disable constraint FK_WB_MM_FORM_WB_CHART_TYPE;
alter table WB_MM_FORM disable constraint FK_WB_MM_FORM_WB_FORM_TYPE;
alter table WB_MM_FORM disable constraint FK_WB_MM_FORM_WB_MAIN_MENU;
prompt Disabling foreign key constraints for WB_FORM_CELLS...
alter table WB_FORM_CELLS disable constraint FK_WB_FORM_CELLS_WB_MM_FROM;
prompt Disabling foreign key constraints for WB_FORM_FIELD...
alter table WB_FORM_FIELD disable constraint FK_WB_FORM_FL_WB_FROM_ALG;
alter table WB_FORM_FIELD disable constraint FK_WB_FORM_FL_WB_MM_FROM;
prompt Disabling foreign key constraints for WB_MM_ROLE...
alter table WB_MM_ROLE disable constraint FK_WB_MM_ROLE_WB_ACCESS_TYPE;
alter table WB_MM_ROLE disable constraint FK_WB_MM_ROLE_WB_MM;
alter table WB_MM_ROLE disable constraint FK_WB_MM_ROLE_WB_ROLE;
prompt Disabling foreign key constraints for WB_PARAM_VALUE...
alter table WB_PARAM_VALUE disable constraint FK_WB_PV_TYPE;
alter table WB_PARAM_VALUE disable constraint FK_WB_PV_USER;
prompt Disabling foreign key constraints for WB_ROLE_USER...
alter table WB_ROLE_USER disable constraint FK_WB_ROLE_USER_WB_ROLE;
alter table WB_ROLE_USER disable constraint FK_WB_ROLE_USER_WB_USER;
prompt Loading WB_ACCESS_TYPE...
insert into WB_ACCESS_TYPE (id_wb_access_type, wb_name, name, create_user, create_date, last_user, last_date)
values (-1, 'disable', 'Запрещено', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_ACCESS_TYPE (id_wb_access_type, wb_name, name, create_user, create_date, last_user, last_date)
values (1, 'enable', 'Разрешено', 'LOADER', sysdate, 'LOADER', sysdate);
prompt 2 records loaded
prompt Loading WB_CHART_TYPE...
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (1, 'Pie_3D', 'Круговая 3D Диаграмма', 'FlotCharts', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (2, 'MS_Line_Fuled', 'Линии с заливкой', 'FlotCharts', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (3, 'StackedColumn3D', 'Stacked Column 3D Chart', 'FlotCharts', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (4, 'MS_Line', 'Линии без заливки', 'FlotCharts', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (5, 'MultiLine_Fuled', 'Линии с несколькими шкалами', 'FlotCharts', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (1, 'A', 'Ссылка (<a> href=)', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (2, 'B', 'Переключатель', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (3, 'C', 'Валюта (руб.)', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (4, 'D', 'Дата', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (5, 'DT', 'Дата и время', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (6, 'F', 'Файл', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (7, 'FB', 'Файл в таблице', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (8, 'I', 'Целое', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (9, 'M', 'Многострочный текст', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (10, 'N', 'Дробное', 'LOADER', sysdate, 'LOADER',sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (11, 'NL', 'Дробное (более точное)', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (12, 'P', 'Поле пароля', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (13, 'S', 'Текстовая строка', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (14, 'SB', 'Выпадающий список', 'LOADER', sysdate, 'LOADER', sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (15, 'U01', 'Айпи адрес, маска', 'LOADER', sysdate, 'LOADER', sysdate, '099.099.099.099', 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (16, 'U02', 'MAC адрес, маска', 'LOADER', sysdate, 'LOADER', sysdate, 'AA:AA:AA:AA:AA:AA', 'U');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (17, 'E', 'Электронный адрес', 'LOADER', sysdate, 'LOADER',sysdate, null, 'N');
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date, char_mask, char_case)
values (18, 'U03', 'Телефон с кодом города', 'LOADER', sysdate, 'LOADER', sysdate, '+0 (000) 000-00-00', 'N');
prompt Loading WB_FORM_TYPE...
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-1, 13, 'WIZARD_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'Формальный признак указывающий на то что данные вводятся с помощью мастера');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-2, 13, 'BUTTON_CUSTOM', 'LOADER', sysdate, 'LOADER', sysdate, 'Пользовательская кнопка');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-3, 1, 'INPUT_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'Форма запроса данных');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-4, 3, 'PL_SQL_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'Форма выполнения скрипта');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-5, 4, 'DOWNLOAD_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'Выгрузка файла');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-6, 5, 'GRID_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'Простая табличная форма');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-7, 6, 'CHARTS_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'График');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-8, 7, 'GRID_FORM_MASTER', 'LOADER', sysdate, 'LOADER', sysdate, 'Форма таблиц с дочерней таблицей');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-9, 8, 'GRID_FORM_DETAIL', 'LOADER', sysdate, 'LOADER', sysdate, 'Форма дочерней таблицы');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-10, 10, 'INPUT_FORM_UPLOAD', 'LOADER', sysdate, 'LOADER', sysdate, 'Формальный признак что можно прикреплять файлы к строке');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-11, 11, 'TREE_GRID_FORM', 'LOADER', sysdate, 'LOADER', sysdate, 'Древовидная форма');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-12, 12, 'TREE_GRID_FORM_MASTER', 'LOADER', sysdate, 'LOADER', sysdate, 'Древовидная форма с подтаблицей');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-13, 13, 'GRID_FORM_RELOAD', 'LOADER', sysdate, 'LOADER', sysdate, 'Форма с пренудительной перезагрузкой данных');
prompt 12 records loaded
prompt Loading WB_MAIN_MENU...
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-1, null, 999, 'Администрирование', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-2, -1, 7, 'Доступы', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-3, -1, 2, 'Главное меню', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-4, -1, 3, 'Формы - Столбцы', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-5, -1, 5, 'Типы выравниваний полей', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-6, -1, 4, 'Формы - Ячейки на печать', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-7, -1, 1, 'Глобальные переменные', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-8, -2, 2, 'Пользователи и Права доступа', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-9, -2, 1, 'Роли пользователей и меню', 'LOADER', sysdate, 'LOADER', sysdate, 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-10, -1, 6, 'Описание параметров', 'LOADER', sysdate, 'LOADER', sysdate, 1);
prompt 10 records loaded
prompt Loading WB_MM_FORM...
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-1, -3, 1, 'Главное меню', -11, null, 'WB_MAIN_MENU_VIEW_TREE_USV', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, 0, 0, 0, 100, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-2, -4, 1, 'Формы', -8, null, 'WB_MM_FORM_VIEW', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, null, null, null, 70, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-4, -4, 2, 'Столбцы', -9, null, 'WB_FORM_FIELD_VIEW', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, null, null, null, 30, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-5, -5, 1, 'Типы выравниваний полей', -6, null, 'WB_FORM_FIELD_ALIGN', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, 0, 0, 0, 0, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-6, -6, 2, 'Ячейки', -9, null, 'WB_FORM_CELLS_VIEW', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, null, null, null, 70, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-7, -8, 1, 'Пользователи', -8, null, 'WB_USER', null, null, 'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, null, null, null, null, null, 50, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-8, -9, 1, 'Роли', -8, null, 'WB_ROLE', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, 0, 0, 0, 30, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-9, -8, 2, 'Права доступа', -9, null, 'WB_ROLE_USER', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, 0, 0, 0, 50, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-11, -9, 2, 'Главное меню', -9, null, 'WB_MM_ROLE', null, null, 'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, 0, 0, 0, 70, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-3, -7, 1, 'Глобальные переменные', -11, null, 'WB_SETTINGS_VIEW_TREE', null, null, 'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, null, null, null, null, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-10, -5, 2, 'Формы', -9, null, 'WB_MM_FORM_VIEW', null, null, 'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, null, null, null, null, null, 50, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-12, -6, 1, 'Формы', -8, null, 'WB_MM_FORM_VIEW', null, null, 'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, null, null, null, 30, '', null, 'A,E,D', 0);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in,  xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update)
values (-13, -10, 1, 'Описание сохраняемых параметров', -8, null, 'WB_PARAM_TYPE', null, null,  'LOADER', sysdate, 'LOADER', sysdate, null, null, 0, 0, 0, null, null, null, 100, '', null, 'A,E,D', 0);
prompt 13 records loaded
prompt Loading WB_FORM_CELLS...
prompt Table is empty
prompt Loading WB_FORM_FIELD_ALIGN...
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (1, 'По левому краю', 'left', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (2, 'По центру', 'center', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (3, 'По правому краю', 'right', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (4, 'По ширине ', 'justify', 'LOADER', sysdate, 'LOADER', sysdate);
prompt 4 records loaded
prompt Loading WB_FORM_FIELD...
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-137, -4, 32, 'XLS Верт.позиция', 'XLS_POSITION_ROW', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-136, -4, 33, 'Обязательное поле', 'IS_REQURED', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-143, -4, 15, 'Тип поля', 'FIELD_TYPE', null, 'Select upper(trim(id)) id, name from wb_field_type', 1, 'SB', 0, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-135, -5, 1, 'ID (not display)', 'ID_WB_FORM_FIELD_ALIGN', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-134, -5, 2, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 420, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-133, -5, 3, 'Комментарий', 'HTML_TXT', null, null, 1, 'S', 0, null, 110, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-132, -5, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-131, -5, 94, 'Датаредактирования', 'LAST_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-130, -6, 1, 'ID (not display)', 'ID_WB_FORM_CELLS_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-129, -6, 3, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-128, -6, 10, 'Текст', 'NAME', null, null, 1, 'S', 0, 0, 150, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-127, -6, 11, 'SQL', 'FIELD_TXT', null, null, 1, 'M', 0, 3, 400, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-123, -6, 31, 'XLS Гор.позиция', 'XLS_POSITION_COL', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-122, -6, 32, 'XLS Верт.позиция', 'XLS_POSITION_ROW', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-121, -6, 33, 'XLS Тип', 'XLS_TYPE', null, null, 1, 'S', 0, null, 40, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-125, -6, 17, 'Тип поля', 'FIELD_TYPE', null, 'Select upper(trim(id)) id, name from wb_field_type', 1, 'SB', 0, 0, 80, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-126, -6, 12, 'Алиас поля', 'FIELD_NAME', null, null, 1, 'S', 0, 0, 100, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-124, -6, 21, 'Тип ячейки', 'TYPE_CELLS', null, 'Select id, name  from (Select ''H''  id,  ''H - Шапка отчета''  name from dual union all        Select ''F''  id,  ''F - Подвал отчета'' name from dual)  order by id', 1, 'SB', 0, null, 100, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-119, -7, 1, 'ID (not display)', 'ID_WB_USER', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-118, -7, 3, 'Имя пользователя', 'NAME', null, null, 1, 'S', 0, 0, 300, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-115, -7, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-114, -7, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-113, -7, 94, 'Датаредактирования', 'LAST_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-112, -8, 1, 'ID (not display)', 'ID_WB_ROLE', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-111, -8, 2, 'Наименование', 'WB_NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-110, -8, 3, 'Комментарий', 'NAME', null, null, 1, 'S', 0, null, 630, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-109, -8, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-108, -8, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-107, -8, 93, 'Последнийредактор', 'LAST_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-106, -9, 1, 'ID (not display)', 'ID_WB_ROLE_USER', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-105, -9, 2, 'Наименование роли', 'ID_WB_ROLE', null, 'Select * from (' || chr(10) || '  select t.id_wb_role id,' || chr(10) || '         t.name name ' || chr(10) || '  from wb_role t ' || chr(10) || 'union all' || chr(10) || '  Select null id, ' || chr(10) || '         null name ' || chr(10) || '  from dual) t ' || chr(10) || 'order by t.name nulls first', 1, 'SB', 0, 0, 290, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-104, -9, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-103, -11, 1, 'ID (not display)', 'ID_WB_MM_ROLE', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-102, -11, 2, 'Главное меню', 'ID_WB_MAIN_MENU', null, 'Select mm.id_wb_main_menu_view_tree id, mm.tree_name name,mm.lev lev from wb_main_menu_view_tree mm', 1, 'SB', 0, 0, 300, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-101, -11, 4, 'Тип доступа', 'ID_WB_ACCESS_TYPE', null, 'Select * from (' || chr(10) || 'select t.id_wb_access_type id,' || chr(10) || '       t.name name' || chr(10) || '       from wb_access_type t) t' || chr(10) || 'order by t.name desc', 1, 'SB', 0, null, 110, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-100, -11, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-99, -11, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-98, -11, 93, 'Последнийредактор', 'LAST_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-120, -6, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-4, -3, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-3, -3, 50, 'ID_PARENT', 'ID_PARENT', null, null, 3, 'N', 0, null, 200, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-2, -3, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-45, -12, 34, 'Скрипт пост загрузки', 'ACTION_BAT', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-46, -10, 34, 'Скрипт пост загрузки', 'ACTION_BAT', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-44, -2, 34, 'Скрипт пост загрузки', 'ACTION_BAT', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-1, -3, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-37, -1, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-36, -2, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-35, -2, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-34, -2, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-33, -2, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-32, -4, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-31, -4, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-30, -4, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-29, -4, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-28, -4, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-27, -5, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-26, -5, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-25, -5, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-24, -6, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-23, -6, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-22, -6, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-21, -6, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-20, -7, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-19, -7, 2, 'Login', 'WB_NAME', null, null, 1, 'S', 0, 0, 300, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-18, -7, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-17, -8, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-16, -8, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-15, -9, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-14, -9, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-13, -9, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-12, -9, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-11, -11, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-10, -11, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-9, -12, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-8, -12, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-7, -10, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-6, -10, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-5, -10, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-40, -1, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-39, -1, 6, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 450, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-38, -1, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-43, -1, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-152, -2, 44, 'Графики (Ширина)', 'CHART_X', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-151, -2, 45, 'Графики (Высота)', 'CHART_Y', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-75, -10, 1, 'ID (not display)', 'ID_WB_MM_FORM_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-139, -4, 24, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-140, -4, 23, 'Кол-во элементов', 'COUNT_ELEMENT', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-141, -4, 22, 'Ширина', 'WIDTH', null, null, 3, 'I', 0, null, 60, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-97, -12, 2, 'ID (not display)', 'ID_WB_MM_FORM_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-96, -12, 3, 'Главное меню', 'ID_WB_MAIN_MENU_VIEW_TREE_USV', null, 'select t.id_wb_main_menu_view_tree_usv id, t.tree_name name, t.lev lev from wb_main_menu_view_tree_usv t', 1, 'SB', 0, 0, 400, 0, 0, 1, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-95, -12, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-94, -12, 7, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-93, -12, 11, 'Тип формы', 'ID_WB_FORM_TYPE', null, 'select t.id_wb_form_type id, t.human_name || '' (''|| t.name || '')'' name' || chr(10) || '          from wb_form_type t' || chr(10) || ' order by t.name nulls first', 1, 'SB', 0, 0, 400, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-92, -12, 12, 'Высота формы (%)', 'HEIGHT_RATE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-42, -2, 14, 'Автообновление формы (сек.)', 'AUTO_UPDATE', null, null, 1, 'I', 0, null, 50, null, null, 0, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-41, -10, 14, 'Автообновление формы (сек.)', 'AUTO_UPDATE', null, null, 1, 'I', 0, null, 50, null, null, 0, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-91, -12, 13, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-90, -12, 21, 'SQL блок:', 'ACTION_SQL', null, null, 1, 'M', 0, 10, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-89, -12, 22, 'Схема БД', 'OWNER', null, 'select username as id, username as name ' || chr(10) || 'from sys.all_users', 1, 'SB', 0, 0, 280, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-88, -12, 23, 'Объект БД', 'OBJECT_NAME', null, null, 1, 'S', 0, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-87, -12, 24, 'Условие в запросе', 'FORM_WHERE', null, null, 1, 'M', 0, 3, 250, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-86, -12, 31, 'Имя шаблона xls', 'XSL_FILE_IN', null, null, 1, 'S', 0, null, 220, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-85, -12, 33, 'Кнопки A,E,D', 'EDIT_BUTTON', null, 'Select ''A'' id, ''Добавление строки'' name from dual union all Select ''E'' id, ''Изменение строки'' name from dual union all Select ''С'' id, ''Копирование строки'' name from dual union all Select ''D'' id, ''Удаление строки'' name from dual union all Select ''EXP'' id, ''Экспорт документа'' name from dual' || chr(10) || '', 1, 'SB', 0, 3, 220, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-84, -12, 41, 'Тип графика', 'ID_WB_CHART_TYPE', null, 'select *  from (select t.id_wb_chart_type id,t.description || '' ('' || t.type_chart || ''->'' || t.name|| '')''  name from wb.wb_chart_type t union all select null id, null name from dual) t order by t.name nulls first', 1, 'SB', 0, null, 160, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-83, -12, 42, 'Графики (Показать подписи)', 'CHART_SHOW_NAME', null, null, 2, 'B', 0, null, 130, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-82, -12, 43, 'Графики (Повернуть подписи)', 'CHART_ROTATE_NAME', null, null, 2, 'B', 0, null, 350, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-81, -12, 44, 'Графики (Ширина)', 'CHART_X', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-80, -12, 45, 'Графики (Высота)', 'CHART_Y', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-78, -12, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-77, -12, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-76, -12, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-55, -3, 1, 'ID (not display)', 'ID_WB_SETTINGS_VIEW_TREE', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-54, -3, 3, 'LEV', 'LEV', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-53, -3, 4, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 550, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-52, -3, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-51, -3, 6, 'Уникальный ключ', 'SHORT_NAME', null, null, 1, 'S', 0, 0, 400, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-50, -3, 7, 'Зачение параметра', 'VALUE', null, null, 1, 'M', 0, 4, 400, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-49, -3, 8, 'Используется', 'USED', null, null, 2, 'B', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-48, -3, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-47, -3, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-117, -7, 4, 'e-mail', 'E_MAIL', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-116, -7, 5, 'Телефон', 'PHONE', null, null, 1, 'U03', 0, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-74, -10, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-73, -10, 7, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-72, -10, 8, 'Тип формы', 'ID_WB_FORM_TYPE', null, 'select t.id_wb_form_type id, t.human_name || '' (''|| t.name || '')'' name' || chr(10) || '          from wb_form_type t' || chr(10) || ' order by t.name nulls first', 1, 'SB', 0, 0, 350, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-69, -10, 21, 'SQL блок:', 'ACTION_SQL', null, null, 1, 'M', 0, 10, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-67, -10, 23, 'Объект БД', 'OBJECT_NAME', null, null, 1, 'S', 0, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-65, -10, 31, 'Имя шаблона xls', 'XSL_FILE_IN', null, null, 1, 'S', 0, null, 220, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-64, -10, 33, 'Кнопки A,E,D', 'EDIT_BUTTON', null, 'Select ''A'' id, ''Добавление строки'' name from dual union all Select ''E'' id, ''Изменение строки'' name from dual union all Select ''С'' id, ''Копирование строки'' name from dual union all Select ''D'' id, ''Удаление строки'' name from dual union all Select ''EXP'' id, ''Экспорт документа'' name from dual' || chr(10) || '', 1, 'SB', 0, 3, 350, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-57, -10, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-56, -10, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-172, -1, 3, 'LEV', 'LEV', null, null, 3, 'I', 1, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-68, -10, 22, 'Схема БД', 'OWNER', null, 'select username as id, username as name ' || chr(10) || 'from sys.all_users', 1, 'SB', 0, 0, 280, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-66, -10, 24, 'Условие в запросе', 'FORM_WHERE', null, null, 1, 'M', 0, 3, 250, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-63, -10, 41, 'Тип графика', 'ID_WB_CHART_TYPE', null, 'select *  from (select t.id_wb_chart_type id,t.description || '' ('' || t.type_chart || ''->'' || t.name|| '')''  name from wb.wb_chart_type t union all select null id, null name from dual) t order by t.name nulls first', 1, 'SB', 0, null, 250, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-70, -10, 13, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, 0, 80, 0, 0, 0, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-62, -10, 42, 'Графики (Показать подписи)', 'CHART_SHOW_NAME', null, null, 2, 'B', 0, null, 130, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-61, -10, 43, 'Графики (Повернуть подписи)', 'CHART_ROTATE_NAME', null, null, 2, 'B', 0, null, 350, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-60, -10, 44, 'Графики (Ширина)', 'CHART_X', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-59, -10, 45, 'Графики (Высота)', 'CHART_Y', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-71, -10, 12, 'Высота формы (%)', 'HEIGHT_RATE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-164, -2, 11, 'Тип формы', 'ID_WB_FORM_TYPE', null, 'select t.id_wb_form_type id, t.human_name || '' (''|| t.name || '')'' name' || chr(10) || '          from wb_form_type t' || chr(10) || ' order by t.name nulls first', 1, 'SB', 0, 0, 400, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-163, -2, 12, 'Высота формы (%)', 'HEIGHT_RATE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-162, -2, 13, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-161, -2, 21, 'SQL блок:', 'ACTION_SQL', null, null, 1, 'M', 0, 10, 400, null, null, null, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-160, -2, 22, 'Схема БД', 'OWNER', null, 'select username as id, username as name ' || chr(10) || 'from sys.all_users', 1, 'SB', 0, 0, 280, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-159, -2, 23, 'Объект БД', 'OBJECT_NAME', null, null, 1, 'S', 0, null, 200, null, null, null, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-158, -2, 24, 'Условие в запросе', 'FORM_WHERE', null, null, 1, 'M', 0, 3, 250, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-157, -2, 31, 'Имя шаблона xls', 'XSL_FILE_IN', null, null, 1, 'S', 0, null, 220, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-156, -2, 33, 'Кнопки A,E,D', 'EDIT_BUTTON', null, 'Select ''A'' id, ''Добавление строки'' name from dual union all Select ''E'' id, ''Изменение строки'' name from dual union all Select ''С'' id, ''Копирование строки'' name from dual union all Select ''D'' id, ''Удаление строки'' name from dual union all Select ''EXP'' id, ''Экспорт документа'' name from dual' || chr(10) || '', 1, 'SB', 0, 3, 400, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-155, -2, 41, 'Тип графика', 'ID_WB_CHART_TYPE', null, 'Select * from (select t.id_wb_chart_type id, t.name name from wb_chart_type t union all Select null id, null name from dual) t order by t.name nulls first', 1, 'SB', 0, null, 250, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-154, -2, 42, 'Графики (Показать подписи)', 'CHART_SHOW_NAME', null, null, 2, 'B', 0, null, 130, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-153, -2, 43, 'Графики (Повернуть подписи)', 'CHART_ROTATE_NAME', null, null, 2, 'B', 0, null, 350, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-167, -2, 2, 'Главное меню', 'ID_WB_MAIN_MENU_VIEW_TREE_USV', null, 'Select t.id_wb_main_menu_view_tree_usv id,' || chr(10) || 't.tree_name_ name   ' || chr(10) || ', t.lev lev from wb_main_menu_view_tree_usv t', 1, 'SB', 0, 0, 400, 0, 0, 1, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-174, -1, 1, 'ID (not display)', 'ID_WB_MAIN_MENU_VIEW_TREE_USV', null, null, 1, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-173, -1, 2, 'ID_PARENT', 'ID_PARENT', null, null, 1, 'I', 0, null, 180, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-171, -1, 10, 'Используется', 'USED', null, null, 2, 'B', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-170, -1, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-169, -1, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-168, -2, 1, 'ID (not display)', 'ID_WB_MM_FORM_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-166, -2, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-165, -2, 7, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-149, -2, 93, 'Последнийредактор', 'LAST_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-148, -4, 1, 'ID (not display)', 'ID_WB_FORM_FIELD_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-142, -4, 21, 'Выравнивание', 'ID_WB_FORM_FIELD_ALIGN', null, 'select t.id_wb_form_field_align as id, t.name as name' || chr(10) || '  from wb_form_field_align t' || chr(10) || ' order by t.id_wb_form_field_align', 1, 'SB', 0, 0, 100, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-147, -4, 10, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-146, -4, 11, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 240, 0, 0, 1, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-144, -4, 14, 'Текст поля', 'FIELD_TXT', null, null, 1, 'M', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-145, -4, 12, 'Поле в БД либо Переменная', 'FIELD_NAME', null, null, 1, 'S', 0, 0, 220, 0, 0, 1, null, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-138, -4, 31, 'XLS Гор.позиция', 'XLS_POSITION_COL', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-175, -13, 100, 'ID (not display)', 'ID_WB_PARAM_TYPE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-176, -13, 94, 'Дата редактирования', 'LAST_DATE', null, null, 3, 'D', 0, null, 120, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-177, -13, 93, 'Последний редактор', 'LAST_USER', null, null, 3, 'S', 0, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-178, -13, 92, 'Дата создания', 'CREATE_DATE', null, null, 3, 'D', 0, null, 120, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-179, -13, 91, 'Создатель', 'CREATE_USER', null, null, 3, 'S', 0, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-180, -13, 70, 'Используется', 'USED', null, null, 3, 'B', 0, null, 50, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-181, -13, 60, 'Тип значения получаемого', 'GET_TYPE', null, 'Select id, name from wb_field_type', 3, 'SB', 0, null, 200, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-182, -13, 50, 'Тип значения сохраняемого', 'SAVE_TYPE', null, 'Select id, name from wb_field_type', 3, 'SB', 0, null, 200, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-183, -13, 40, 'Описание', 'DESCRIPTION', null, null, 3, 'S', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-184, -13, 30, 'Имя переменной', 'NAME', null, null, 3, 'S', 0, null, 300, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-185, -13, 20, '№ п.п.', 'NUM', null, null, 3, 'I', 0, null, 60, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-186, -13, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-187, -2, 25, 'Условие сортировки', 'FORM_ORDER', null, null, 1, 'S', 0, null, 250, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-188, -7, 6, 'Пароль', 'PASSWORD', null, null, 1, 'P', 0, null, 150, null, null, null, 0, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date)
values (-189, -4, 13, 'Подсказка к полю', 'ELEMENT_ALT', null, null, 1, 'S', 0, null, 250, null, null, null, 0, 'DB_UPDATE', sysdate, 'DB_UPDATE', sysdate);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date, is_frosen, is_grouping, is_grouping_header)
values (-190, -4, 25, 'Закрепленный столбец', 'IS_FROSEN', null, null, 1, 'B', 0, null, 200, null, null, 0, 'Позволяет закрепить столбец от горизонтальной прокрутки','LOADER', sysdate, 'LOADER', sysdate, 0, 0, null);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date, is_frosen, is_grouping, is_grouping_header)
values (-191, -4, 26, 'Группировать строки', 'IS_GROUPING', null, null, 1, 'B', 0, null, 200, null, null, 0, 'Позволяет сгруппировать записи по данному столбцу в раскрывающееся списки, если выставлено несколько столбцов то они сгруппируются в дерево', 'LOADER', sysdate, 'LOADER', sysdate, 0, 0, null);
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, element_alt, create_user, create_date, last_user, last_date, is_frosen, is_grouping, is_grouping_header)
values (-192, -4, 27, 'Группировать заголовков столбцов', 'IS_GROUPING_HEADER', null, null, 1, 'S', 0, null, 200, null, null, 0, 'Группирует заголовки столбцов таким образом чтобы было понятно что они относятся к одному уровню, необходимо ввести общее имя группы, групирровать можно только рядом стоящие столбци!', 'LOADER', sysdate, 'LOADER', sysdate, 0, 0, null);
prompt 192 records loaded
prompt Loading WB_ROLE...
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (1, 'ADMIN', 'Администраторы', 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (2, 'ADMIN_USER', 'Администратор пользователей и ролей', 'LOADER', sysdate, 'LOADER', sysdate);
prompt 2 records loaded
prompt Loading WB_MM_ROLE...
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-1, -3, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-2, -4, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-3, -5, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-4, -7, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-5, -8, 2, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-6, -9, 2, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-7, -6, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-8, -10, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
prompt 8 records loaded
prompt Loading WB_PARAM_TYPE...
prompt Table is empty
prompt Loading WB_USER...
insert into WB_USER (id_wb_user, wb_name, name, create_user, create_date, last_user, last_date, e_mail, phone, param_view, password)
values (1, 'ADMIN', 'Администратор', 'LOADER', sysdate, 'LOADER', sysdate, 'admin@domen.com', '+7 (999) 999-99-99', '', '');
prompt 1 records loaded
prompt Loading WB_PARAM_VALUE...
prompt Table is empty
prompt Loading WB_ROLE_USER...
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (1, 1, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (2, 2, 1, 'LOADER', sysdate, 'LOADER', sysdate);
prompt 2 records loaded
prompt Loading WB_SETTINGS...
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (16, null, 200, 'Системные', 'SETTINGS', null, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (15, 14, 2, 'Адрес администратора', 'RECIPIENT_ADMIN', null, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (14, null, 100, 'Настройки сервера SMTP', 'SETTINGS_MAIL_SMTP', null, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (13, 14, 1, 'Сервер', 'SETTINGS_MAIL_SMTP_HOST', 'servername.com', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (12, 14, 3, 'Отправитель', 'SETTINGS_MAIL_SMTP_SENDER', 'admin@servername.com', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (11, 14, 4, 'CHARSET', 'SETTINGS_MAIL_SMTP_CHARSET', 'text/plain; charset=koi8-r', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (10, 14, 5, 'ENCODING', 'SETTINGS_MAIL_SMTP_ENCODING', '8bit', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (9, 14, 6, 'Авторизация: Пользователь', 'SETTINGS_MAIL_SMTP_AUTHLOGIN', 'user_for_server', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (8, 14, 7, 'Авторизация: Пароль', 'SETTINGS_MAIL_SMTP_AUTHPWD', null, 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (7, 14, 8, 'Кодировка для конветртации текста', 'SETTINGS_MAIL_SMTP_DESTCSET', 'CL8KOI8R', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (5, 16, 1, 'Служебные поля которые необходимо скрывать', 'SETTINGS_VIEW_INVISIBLE_SYS_FIELDS', 'R_NUM,ID_PARENT,LEV', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (4, 16, 3, 'Поля аудита которые необходимо скрывать', 'SETTINGS_VIEW_INVISIBLE_AUDIT_FIELDS', 'CREATE_USER,CREATE_DATE,LAST_USER,LAST_DATE,DELETE_USER,DELETE_DATE', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (3, 16, 2, 'Скрывать идентификатор записей в таблицах', 'SETTINGS_VIEW_INVISIBL_ID_TABLE', '1', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (2, null, 1, 'Версия конфигурации', 'ROOT_CONFIG_VERSION', '1', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (1, null, 0, 'Наименование конфигурации', 'ROOT_CONFIG_NAME', 'Полностью пустая конфигурация', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (17, null, 2, 'Изображение конфигурации', 'ROOT_CONFIG_LOGO', 'sport_logo.png', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (18, null, 3, 'Иконка конфигурации', 'ROOT_CONFIG_FAVICON', 'sport_icon.png', 1, 'LOADER', sysdate, 'LOADER', sysdate);
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (-1, null, 3, 'Версия БД', 'ROOT_DB_VERSION', '2.1.5', 1, 'LOADER', sysdate, 'LOADER', sysdate);
prompt 15 records loaded
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
         when 'FIELD_TYPE' then             'Тип столбца данных, в случае если это список то необходимо заполнить поле SQL Блок/Текст поля для того чтобы получить данны для списка. Принимаемые значения: id, name, а также lev в случае построения списка с уровнем'
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
update wb_mm_form t set t.owner = user;
prompt Enabling foreign key constraints for WB_MAIN_MENU...
alter table WB_MAIN_MENU enable constraint FK_WB_MM_PARENT;
prompt Enabling foreign key constraints for WB_MM_FORM...
alter table WB_MM_FORM enable constraint FK_WB_MM_FORM_WB_CHART_TYPE;
alter table WB_MM_FORM enable constraint FK_WB_MM_FORM_WB_FORM_TYPE;
alter table WB_MM_FORM enable constraint FK_WB_MM_FORM_WB_MAIN_MENU;
prompt Enabling foreign key constraints for WB_FORM_CELLS...
alter table WB_FORM_CELLS enable constraint FK_WB_FORM_CELLS_WB_MM_FROM;
prompt Enabling foreign key constraints for WB_FORM_FIELD...
alter table WB_FORM_FIELD enable constraint FK_WB_FORM_FL_WB_FROM_ALG;
alter table WB_FORM_FIELD enable constraint FK_WB_FORM_FL_WB_MM_FROM;
prompt Enabling foreign key constraints for WB_MM_ROLE...
alter table WB_MM_ROLE enable constraint FK_WB_MM_ROLE_WB_ACCESS_TYPE;
alter table WB_MM_ROLE enable constraint FK_WB_MM_ROLE_WB_MM;
alter table WB_MM_ROLE enable constraint FK_WB_MM_ROLE_WB_ROLE;
prompt Enabling foreign key constraints for WB_PARAM_VALUE...
alter table WB_PARAM_VALUE enable constraint FK_WB_PV_TYPE;
alter table WB_PARAM_VALUE enable constraint FK_WB_PV_USER;
prompt Enabling foreign key constraints for WB_ROLE_USER...
alter table WB_ROLE_USER enable constraint FK_WB_ROLE_USER_WB_ROLE;
alter table WB_ROLE_USER enable constraint FK_WB_ROLE_USER_WB_USER;
prompt Enabling triggers for WB_ACCESS_TYPE...
alter table WB_ACCESS_TYPE enable all triggers;
prompt Enabling triggers for WB_CHART_TYPE...
alter table WB_CHART_TYPE enable all triggers;
prompt Enabling triggers for WB_FIELD_TYPE...
alter table WB_FIELD_TYPE enable all triggers;
prompt Enabling triggers for WB_FORM_TYPE...
alter table WB_FORM_TYPE enable all triggers;
prompt Enabling triggers for WB_MAIN_MENU...
alter table WB_MAIN_MENU enable all triggers;
prompt Enabling triggers for WB_MM_FORM...
alter table WB_MM_FORM enable all triggers;
prompt Enabling triggers for WB_FORM_CELLS...
alter table WB_FORM_CELLS enable all triggers;
prompt Enabling triggers for WB_FORM_FIELD_ALIGN...
alter table WB_FORM_FIELD_ALIGN enable all triggers;
prompt Enabling triggers for WB_FORM_FIELD...
alter table WB_FORM_FIELD enable all triggers;
prompt Enabling triggers for WB_ROLE...
alter table WB_ROLE enable all triggers;
prompt Enabling triggers for WB_MM_ROLE...
alter table WB_MM_ROLE enable all triggers;
prompt Enabling triggers for WB_PARAM_TYPE...
alter table WB_PARAM_TYPE enable all triggers;
prompt Enabling triggers for WB_USER...
alter table WB_USER enable all triggers;
prompt Enabling triggers for WB_PARAM_VALUE...
alter table WB_PARAM_VALUE enable all triggers;
prompt Enabling triggers for WB_ROLE_USER...
alter table WB_ROLE_USER enable all triggers;
prompt Enabling triggers for WB_SETTINGS...
alter table WB_SETTINGS enable all triggers;
prompt Done.
spool off