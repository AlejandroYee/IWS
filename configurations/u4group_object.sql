-------------------------------------------------------
-- Export file for user ALYSIKOV                     --
-- Created by Andrey.Lysikov on 09.09.2013, 11:13:23 --
-------------------------------------------------------

set define off
spool u4group_object.log

prompt
prompt Creating table PR_CLIENTS_TYPE
prompt ==============================
prompt
create table PR_CLIENTS_TYPE
(
  id_pr_clients_type NUMBER,
  name               VARCHAR2(2000),
  comments           VARCHAR2(3000)
)
;
create unique index I_PR_CLIENTS_TYPE on PR_CLIENTS_TYPE (ID_PR_CLIENTS_TYPE);
alter table PR_CLIENTS_TYPE
  add constraint PK_PR_CLIENTS_TYPE unique (ID_PR_CLIENTS_TYPE);

prompt
prompt Creating table PR_CLIENTS
prompt =========================
prompt
create table PR_CLIENTS
(
  id_pr_clients      NUMBER,
  id_pr_clients_type NUMBER,
  name               VARCHAR2(4000),
  dogovor            VARCHAR2(1000),
  director           VARCHAR2(2000),
  otvetst            VARCHAR2(2000),
  last_action_date   DATE,
  date_start         DATE,
  email              VARCHAR2(1000),
  phone              VARCHAR2(1000),
  create_user        VARCHAR2(1000),
  create_date        DATE,
  last_user          VARCHAR2(1000),
  last_date          DATE
)
;
comment on column PR_CLIENTS.id_pr_clients
  is 'Формальный ключ';
comment on column PR_CLIENTS.id_pr_clients_type
  is 'Ссылка на тип клиента';
comment on column PR_CLIENTS.name
  is 'Наименование';
comment on column PR_CLIENTS.dogovor
  is 'Номер договора';
comment on column PR_CLIENTS.director
  is 'Руководитель';
comment on column PR_CLIENTS.otvetst
  is 'Ответственное лицо в компании';
comment on column PR_CLIENTS.last_action_date
  is 'Дата последненго заказа';
comment on column PR_CLIENTS.date_start
  is 'Дата начала деятельности';
comment on column PR_CLIENTS.email
  is 'Электронная почта';
comment on column PR_CLIENTS.phone
  is 'Телефоны';
alter table PR_CLIENTS
  add constraint PK_PR_CLIENTS unique (ID_PR_CLIENTS);
alter table PR_CLIENTS
  add constraint ID_PR_CLIENTS_TYPE foreign key (ID_PR_CLIENTS_TYPE)
  references PR_CLIENTS_TYPE (ID_PR_CLIENTS_TYPE);

prompt
prompt Creating table PR_CLIENTS_DOCS
prompt ==============================
prompt
create table PR_CLIENTS_DOCS
(
  id_pr_clients_docs NUMBER not null,
  id_pr_clients      NUMBER,
  file_name          VARCHAR2(2000),
  file_name_content  CLOB,
  comments           VARCHAR2(2000),
  create_user        VARCHAR2(2000),
  create_date        DATE,
  last_user          VARCHAR2(2000),
  last_date          DATE
)
;
alter table PR_CLIENTS_DOCS
  add constraint PK_PR_CLIENTS_DOCS primary key (ID_PR_CLIENTS_DOCS);
alter table PR_CLIENTS_DOCS
  add constraint PK_PR_CLIENTS_2 foreign key (ID_PR_CLIENTS)
  references PR_CLIENTS (ID_PR_CLIENTS);

prompt
prompt Creating table PR_MATERIAL_TYPE
prompt ===============================
prompt
create table PR_MATERIAL_TYPE
(
  id_pr_material_type NUMBER,
  name                VARCHAR2(255),
  create_user         VARCHAR2(255),
  create_date         DATE,
  last_user           VARCHAR2(255),
  last_date           DATE
)
;
alter table PR_MATERIAL_TYPE
  add constraint SYS_00111115 unique (ID_PR_MATERIAL_TYPE);

prompt
prompt Creating table PR_MATERIAL
prompt ==========================
prompt
create table PR_MATERIAL
(
  id_pr_material      NUMBER,
  id_pr_material_type NUMBER,
  material_width      NUMBER,
  material_heigth     NUMBER,
  is_list             NUMBER,
  is_gloss            NUMBER,
  name                VARCHAR2(2000),
  think               NUMBER,
  create_user         VARCHAR2(255),
  create_date         DATE,
  last_user           VARCHAR2(255),
  last_date           DATE,
  value               NUMBER
)
;
alter table PR_MATERIAL
  add constraint SYS_00111116 unique (ID_PR_MATERIAL);
alter table PR_MATERIAL
  add constraint PK_MATERIAL_TYPE foreign key (ID_PR_MATERIAL_TYPE)
  references PR_MATERIAL_TYPE (ID_PR_MATERIAL_TYPE);

prompt
prompt Creating table PR_MATERIAL_DYN
prompt ==============================
prompt
create table PR_MATERIAL_DYN
(
  id_pr_material_dyn NUMBER,
  id_pr_material     NUMBER,
  val                NUMBER,
  user_ins           VARCHAR2(1000),
  date_ins           DATE,
  comments           VARCHAR2(1000),
  in_out             VARCHAR2(1),
  id_pr_client       NUMBER,
  id_zakaz           NUMBER
)
;
comment on column PR_MATERIAL_DYN.id_pr_material_dyn
  is 'Формальный ключ';
comment on column PR_MATERIAL_DYN.id_pr_material
  is 'Ид материала';
comment on column PR_MATERIAL_DYN.val
  is 'Значение';
comment on column PR_MATERIAL_DYN.user_ins
  is 'Кто изменил значение';
comment on column PR_MATERIAL_DYN.date_ins
  is 'Дата изменения';
comment on column PR_MATERIAL_DYN.comments
  is 'Коментарий';
comment on column PR_MATERIAL_DYN.in_out
  is 'Приход/расход';
comment on column PR_MATERIAL_DYN.id_pr_client
  is 'Клиент';
alter table PR_MATERIAL_DYN
  add constraint PK_PR_MATERIAL_DYN unique (ID_PR_MATERIAL_DYN);
alter table PR_MATERIAL_DYN
  add constraint PK_PR_CLIENT foreign key (ID_PR_CLIENT)
  references PR_CLIENTS (ID_PR_CLIENTS);
alter table PR_MATERIAL_DYN
  add constraint PK_PR_MATERIAL foreign key (ID_PR_MATERIAL)
  references PR_MATERIAL (ID_PR_MATERIAL);

prompt
prompt Creating table PR_PRINTER_TYPE
prompt ==============================
prompt
create table PR_PRINTER_TYPE
(
  id_pr_printer_type NUMBER not null,
  name               VARCHAR2(2000),
  comments           VARCHAR2(2000),
  create_user        VARCHAR2(255),
  create_date        DATE,
  last_user          VARCHAR2(255),
  last_date          DATE
)
;
alter table PR_PRINTER_TYPE
  add constraint SYS_00111112 primary key (ID_PR_PRINTER_TYPE);

prompt
prompt Creating table PR_PRINTER
prompt =========================
prompt
create table PR_PRINTER
(
  id_pr_printer      NUMBER,
  id_pr_printer_type NUMBER,
  name               VARCHAR2(2000),
  comments           VARCHAR2(2000),
  location           VARCHAR2(2000),
  create_user        VARCHAR2(255),
  create_date        DATE,
  last_user          VARCHAR2(255),
  last_date          DATE,
  width              NUMBER
)
;
create unique index IX_PR_PRINTER on PR_PRINTER (ID_PR_PRINTER);
alter table PR_PRINTER
  add constraint SYS_00111111 unique (ID_PR_PRINTER);
alter table PR_PRINTER
  add constraint PK_PR_PR_TYPE foreign key (ID_PR_PRINTER_TYPE)
  references PR_PRINTER_TYPE (ID_PR_PRINTER_TYPE);

prompt
prompt Creating table PR_PRID_MT
prompt =========================
prompt
create table PR_PRID_MT
(
  id_pr_prid_mt  NUMBER,
  id_pr_printer  NUMBER,
  id_pr_material NUMBER,
  create_user    VARCHAR2(255),
  create_date    DATE,
  last_user      VARCHAR2(255),
  last_date      DATE
)
;
alter table PR_PRID_MT
  add constraint SYS_00111117 unique (ID_PR_PRID_MT);
alter table PR_PRID_MT
  add constraint PK_ID_MAT foreign key (ID_PR_MATERIAL)
  references PR_MATERIAL (ID_PR_MATERIAL);
alter table PR_PRID_MT
  add constraint PK_ID_PR foreign key (ID_PR_PRINTER)
  references PR_PRINTER (ID_PR_PRINTER);

prompt
prompt Creating table PR_RESOLUTION
prompt ============================
prompt
create table PR_RESOLUTION
(
  id_pr_resolution NUMBER,
  hdpi             NUMBER,
  wdpi             NUMBER,
  create_user      VARCHAR2(255),
  create_date      DATE,
  last_user        VARCHAR2(255),
  last_date        DATE
)
;
alter table PR_RESOLUTION
  add constraint SYS_00111113 unique (ID_PR_RESOLUTION);

prompt
prompt Creating table PR_PRID_PRES
prompt ===========================
prompt
create table PR_PRID_PRES
(
  id_pr_prid_pres NUMBER,
  pr_printer      NUMBER,
  pr_resolution   NUMBER,
  create_user     VARCHAR2(255),
  create_date     DATE,
  last_user       VARCHAR2(255),
  last_date       DATE
)
;
alter table PR_PRID_PRES
  add constraint SYS_00111114 unique (ID_PR_PRID_PRES);
alter table PR_PRID_PRES
  add constraint PK_PR_PRINTER_KEY foreign key (PR_PRINTER)
  references PR_PRINTER (ID_PR_PRINTER);
alter table PR_PRID_PRES
  add constraint PK_PR_RESOLUTION_KEY foreign key (PR_RESOLUTION)
  references PR_RESOLUTION (ID_PR_RESOLUTION);

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
  phone       VARCHAR2(12),
  param_view  VARCHAR2(2000),
  password    VARCHAR2(2000)
)
;
create unique index IX_WB_USER_1 on WB_USER (WB_NAME);
alter table WB_USER
  add primary key (ID_WB_USER);

prompt
prompt Creating table PR_TYPE_LINK_JOB
prompt ===============================
prompt
create table PR_TYPE_LINK_JOB
(
  id_pr_type_link_job NUMBER,
  id_wb_role          NUMBER,
  id_pr_printer_type  NUMBER,
  num                 NUMBER,
  id_wb_user          NUMBER,
  create_user         VARCHAR2(2000),
  create_date         DATE,
  last_user           VARCHAR2(2000),
  last_date           DATE
)
;
comment on column PR_TYPE_LINK_JOB.id_pr_type_link_job
  is 'Уникальный индекс';
comment on column PR_TYPE_LINK_JOB.id_wb_role
  is 'Связь с ролями и пользователями';
comment on column PR_TYPE_LINK_JOB.id_pr_printer_type
  is 'Связь с категориями работы';
comment on column PR_TYPE_LINK_JOB.num
  is 'Порядок работ';
comment on column PR_TYPE_LINK_JOB.id_wb_user
  is 'Ответственный за работы';
create unique index ID_TYPE_LINK_JOB on PR_TYPE_LINK_JOB (ID_PR_TYPE_LINK_JOB);
alter table PR_TYPE_LINK_JOB
  add constraint SYS_00111118 unique (ID_PR_TYPE_LINK_JOB);
alter table PR_TYPE_LINK_JOB
  add constraint PK_ID_PR_PRINTER_TYPE foreign key (ID_PR_PRINTER_TYPE)
  references PR_PRINTER_TYPE (ID_PR_PRINTER_TYPE);
alter table PR_TYPE_LINK_JOB
  add constraint PK_ID_WB_ROLE foreign key (ID_WB_ROLE)
  references WB_ROLE (ID_WB_ROLE);
alter table PR_TYPE_LINK_JOB
  add constraint PK_ID_WB_USER foreign key (ID_WB_USER)
  references WB_USER (ID_WB_USER);

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
  html_img          VARCHAR2(255),
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
  auto_update       NUMBER default 0,
  form_order        VARCHAR2(2000)
)
;
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
  field_type       VARCHAR2(2) default 'N',
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
  field_type             VARCHAR2(2) default 'N',
  is_read_only           NUMBER default 0 not null,
  count_element          NUMBER,
  width                  NUMBER,
  xls_position_col       NUMBER,
  xls_position_row       NUMBER,
  is_requred             NUMBER default 0,
  fl_html_code           NUMBER default 0,
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
prompt Creating sequence GEN_PR_CLIENTS
prompt ================================
prompt
create sequence GEN_PR_CLIENTS
minvalue 1
maxvalue 99999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_CLIENTS_DOCS
prompt =====================================
prompt
create sequence GEN_PR_CLIENTS_DOCS
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_CLIENTS_TYPE
prompt =====================================
prompt
create sequence GEN_PR_CLIENTS_TYPE
minvalue 1
maxvalue 9999999999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_MATERIAL
prompt =================================
prompt
create sequence GEN_PR_MATERIAL
minvalue 1
maxvalue 99999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_MATERIAL_DYN
prompt =====================================
prompt
create sequence GEN_PR_MATERIAL_DYN
minvalue 1
maxvalue 999999999999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_MATERIAL_TYPE
prompt ======================================
prompt
create sequence GEN_PR_MATERIAL_TYPE
minvalue 1
maxvalue 9999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_PRID_MT
prompt ================================
prompt
create sequence GEN_PR_PRID_MT
minvalue 1
maxvalue 999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_PRID_PRES
prompt ==================================
prompt
create sequence GEN_PR_PRID_PRES
minvalue 1
maxvalue 999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_PRINTER
prompt ================================
prompt
create sequence GEN_PR_PRINTER
minvalue 1
maxvalue 99999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_PRINTER_TYPE
prompt =====================================
prompt
create sequence GEN_PR_PRINTER_TYPE
minvalue 1
maxvalue 999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_RESOLUTION
prompt ===================================
prompt
create sequence GEN_PR_RESOLUTION
minvalue 1
maxvalue 99999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_PR_TYPE_LINK_JOB
prompt ======================================
prompt
create sequence GEN_PR_TYPE_LINK_JOB
minvalue 1
maxvalue 99999999999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_FIELD_TYPE
prompt ===================================
prompt
create sequence GEN_WB_FIELD_TYPE
minvalue 1
maxvalue 999999999999
start with 16
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
start with 1000302
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
start with 215
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
start with 1000082
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MAIN_MENU_SYS
prompt ======================================
prompt
create sequence GEN_WB_MAIN_MENU_SYS
minvalue 1
maxvalue 9999
start with 10
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MM_FORM
prompt ================================
prompt
create sequence GEN_WB_MM_FORM
minvalue 1000001
maxvalue 9999999999999999999999999999
start with 1000241
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MM_FORM_SYS
prompt ====================================
prompt
create sequence GEN_WB_MM_FORM_SYS
minvalue 1
maxvalue 9999
start with 13
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_MM_ROLE
prompt ================================
prompt
create sequence GEN_WB_MM_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 82
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
start with 63
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_ROLE_USER
prompt ==================================
prompt
create sequence GEN_WB_ROLE_USER
minvalue 1
maxvalue 9999999999999999999999999999
start with 63
increment by 1
cache 20;

prompt
prompt Creating sequence GEN_WB_SETTINGS
prompt =================================
prompt
create sequence GEN_WB_SETTINGS
minvalue 1
maxvalue 9999999999999999999999999999
start with 57
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
prompt Creating view PR_CLIENTS_VIEW
prompt =============================
prompt
create or replace force view pr_clients_view as
select cl.id_pr_clients as id_pr_clients_view,
       cl.name,
       cl.dogovor,
       cl.director,
       cl.otvetst,
       cl.email,
       cl.phone,
       cl.date_start,
       cl.create_user,
       cl.create_date,
       cl.last_user,
       cl.last_date,
       cl.id_pr_clients_type
  from pr_clients cl
 where cl.id_pr_clients_type <> 1;

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
prompt Creating view PR_CLIENTS_W_DOCS
prompt ===============================
prompt
create or replace force view pr_clients_w_docs as
select cl.id_pr_clients_docs as id_pr_clients_w_docs,
       cl.id_pr_clients as id_pr_clients_view,
       nvl2(cl.file_name, wb.create_download_link('ajax.download_file.php?id=' || cl.id_pr_clients_docs || '&data=pr_clients_docs&name=file_name', cl.file_name), null) val_file_name_link,
       cl.comments,
       cl.create_user,
       cl.create_date,
       cl.last_user,
       cl.last_date
  from pr_clients_docs cl;

prompt
prompt Creating view PR_CONTRAGENTS_DOCS
prompt =================================
prompt
create or replace force view pr_contragents_docs as
select cl.id_pr_clients_docs as id_pr_contragents_docs,
       cl.id_pr_clients as id_pr_contragents_view,
       nvl2(cl.file_name, wb.create_download_link('ajax.download_file.php?id=' || cl.id_pr_clients_docs || '&data=pr_clients_docs&name=file_name', cl.file_name), null) val_file_name_link,
       cl.comments,
       cl.create_user,
       cl.create_date,
       cl.last_user,
       cl.last_date
  from pr_clients_docs cl;

prompt
prompt Creating view PR_CONTRAGENTS_VIEW
prompt =================================
prompt
create or replace force view pr_contragents_view as
select cl.id_pr_clients as id_pr_contragents_view,
       cl.name,
       cl.dogovor,
       cl.director,
       cl.otvetst,
       cl.email,
       cl.phone,
       cl.date_start,
       cl.create_user,
       cl.create_date,
       cl.last_user,
       cl.last_date
  from pr_clients cl
 where cl.id_pr_clients_type = 1;

prompt
prompt Creating view PR_MATERIAL_DYNAMICS
prompt ==================================
prompt
create or replace force view pr_material_dynamics as
select pr.id_pr_material_dyn as id_pr_material_dynamics,
       'P_' || pr.id_pr_material as id_pr_material_ostatok,
       abs(pr.val) as val,
       pr.user_ins,
       pr.date_ins,
       pr.comments,
       pr.id_pr_client,
       pr.id_zakaz,
       pr.in_out
  from pr_material_dyn pr order by pr.date_ins desc;

prompt
prompt Creating view PR_MATERIAL_OSTATOK
prompt =================================
prompt
create or replace force view pr_material_ostatok as
select tt.id_pr_material_ostatok,
       tt.id_parent id_parent,
       level        lev,
       tt.name,
       tt.value
  from (select 'T_' || prt.id_pr_material_type as id_pr_material_ostatok,
               null id_parent,
               prt.name name,
               null value
          from pr_material_type prt
        union all
        select 'P_' || pr.id_pr_material as id_pr_material_ostatok,
               'T_' || pr.id_pr_material_type as id_parent,
               pr.name || ' (' || decode(pr.is_list, 1, pr.material_heigth || 'x' || pr.material_width || 'мм) ', round(pr.material_heigth / 1000, 2) || 'x' || round(pr.material_width / 1000, 2) || 'м) ') || decode(pr.think, null, '', decode(pr.is_gloss, 1, 'глянцевый, ', 'матовый, ') || decode(pr.is_list, 1, 'листовой', 'рулонный') || ', ' || pr.think || 'гр') name,
               pr.value
          from pr_material pr) tt
 start with tt.id_parent is null
connect by prior tt.id_pr_material_ostatok = tt.id_parent
 order siblings by tt.name;

prompt
prompt Creating view PR_MATERIAL_VIEW
prompt ==============================
prompt
create or replace force view pr_material_view as
select 'P_' || prpr.id_pr_printer id_pr_printer_view,
       pr_prid.id_pr_prid_mt  id_pr_material_view,
       prmt.id_pr_material material
from pr_printer prpr
inner join pr_prid_mt pr_prid on pr_prid.id_pr_printer = prpr.id_pr_printer
inner join pr_material prmt on prmt.id_pr_material = pr_prid.id_pr_material;

prompt
prompt Creating view PR_PRINTER_VIEW
prompt =============================
prompt
create or replace force view pr_printer_view as
select
    tt.id id_pr_printer_view,
    tt.id_parent id_parent,
    level lev,
    tt.name,
    tt.widths,
    tt.comments,
    tt.location
from (  select 'T_' || prt.id_pr_printer_type id,
                     null id_parent,
                     prt.name name,
                     null comments,
                     null widths,
                     null location
              from pr_printer_type prt
              union all
              select 'P_' || prpr.id_pr_printer id,
                     'T_' || prpr.id_pr_printer_type id_parent,
                     prpr.name name,
                     prpr.comments comments,
                     prpr.width widths,
                     prpr.location location
              from pr_printer prpr
              ) tt
start with tt.id_parent is null
connect by prior tt.id = tt.id_parent
order siblings by tt.name;

prompt
prompt Creating view PR_RESOLUTION_VIEW
prompt ================================
prompt
create or replace force view pr_resolution_view as
select 'P_' || prpr.id_pr_printer id_pr_printer_view,
       pr_prid.id_pr_prid_pres  id_pr_resolution_view,
       prres.id_pr_resolution dpi
from pr_printer prpr
inner join pr_prid_pres pr_prid on pr_prid.pr_printer = prpr.id_pr_printer
inner join pr_resolution prres on prres.id_pr_resolution = pr_prid.pr_resolution;

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
create or replace force view wb_form_field_ as
select t.id_wb_mm_form,
       t.num,
       t.name,
       t.field_name,
       t.id_wb_form_field_align,
       t.xls_position_col,
       t.xls_position_row,
       t.fl_html_code,
       t.field_type
  from wb_form_field t;

prompt
prompt Creating view WB_FORM_FIELD_VIEW
prompt ================================
prompt
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
       t.fl_html_code,
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
       t.html_img,
       nvl(t.auto_update,0) auto_update,
       t.xsl_file_out,
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
       t.chart_y,
       t.form_order,
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
function get_tmp$param_value_str      (p_param_type varchar2) return varchar2;

--+--Возвращает значение темпового параметра в типе NUMBER
function get_tmp$param_value_num      (p_param_type varchar2) return number;

--+--Возвращает значение темпового параметра в типе INTEGER
function get_tmp$param_value_int      (p_param_type varchar2) return number;

--+--Возвращает значение темпового параметра в типе DATE
function get_tmp$param_value_date     (p_param_type varchar2) return date;

--+--Возвращает значение темпового параметра в типе DATE_TIME
function get_tmp$param_value_date_time(p_param_type varchar2) return date;

end;
/

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
prompt Creating package body WB
prompt ========================
prompt
CREATE OR REPLACE PACKAGE BODY WB is

--+--Сохраняет текущего пользователя
procedure save_wb_user(i_user varchar2)
as
begin
  wb.wb_user := i_user;
  -- Для использования других БД через DBLink's
  /*
  begin
    wb.save_wb_user@vm(wb.wb_user);
  exception
    when OTHERS then null;
  end;*/
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
    return null;
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
prompt Creating trigger T_B_IU_PR_CLIENTS
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_CLIENTS"
BEFORE INSERT OR UPDATE
ON PR_CLIENTS
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_CLIENTS is null then
      Select GEN_PR_CLIENTS.nextval
        into :new.ID_PR_CLIENTS
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
prompt Creating trigger T_B_IU_PR_CLIENTS_DOCS
prompt =======================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_CLIENTS_DOCS"
BEFORE INSERT OR UPDATE
ON PR_CLIENTS_DOCS
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_CLIENTS_DOCS is null then
      Select GEN_PR_CLIENTS_DOCS.nextval
        into :new.ID_PR_CLIENTS_DOCS
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
prompt Creating trigger T_B_IU_PR_CLIENTS_TYPE
prompt =======================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_CLIENTS_TYPE"
BEFORE insert
ON PR_CLIENTS_TYPE
FOR EACH ROW
begin
  if :new.ID_PR_CLIENTS_TYPE is null then
    Select GEN_PR_CLIENTS_TYPE.nextval
      into :new.ID_PR_CLIENTS_TYPE
      from dual;
  end if;
END;
/

prompt
prompt Creating trigger T_B_IU_PR_MATERIAL
prompt ===================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_MATERIAL"
BEFORE INSERT OR UPDATE
ON PR_MATERIAL
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_MATERIAL is null then
      Select GEN_PR_MATERIAL.nextval
        into :new.ID_PR_MATERIAL
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
prompt Creating trigger T_B_IU_PR_MATERIAL_DYN
prompt =======================================
prompt
create or replace trigger "T_B_IU_PR_MATERIAL_DYN"
   before insert or update on pr_material_dyn
   for each row
declare
   user_name wb_user.name%type;
begin
   if inserting then
      if :new.id_pr_material_dyn is null then
         select gen_pr_material_dyn.nextval into :new.id_pr_material_dyn from dual;
      end if;

      select u.name into user_name from wb_user u where lower(u.wb_name) = lower(nvl(wb.get_wb_user, user));
      :new.user_ins := user_name;
      :new.date_ins := sysdate;
   end if;
   if updating then
      :new.date_ins := sysdate;
   end if;
end;
/

prompt
prompt Creating trigger T_B_IU_PR_MATERIAL_TYPE
prompt ========================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_MATERIAL_TYPE"
BEFORE INSERT OR UPDATE
ON PR_MATERIAL_TYPE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_MATERIAL_TYPE is null then
      Select GEN_PR_MATERIAL_TYPE.nextval
        into :new.ID_PR_MATERIAL_TYPE
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
prompt Creating trigger T_B_IU_PR_PRID_MT
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_PRID_MT"
BEFORE INSERT OR UPDATE
ON PR_PRID_MT
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_PRID_MT is null then
      Select GEN_PR_PRID_MT.nextval
        into :new.ID_PR_PRID_MT
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
prompt Creating trigger T_B_IU_PR_PRID_PRES
prompt ====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_PRID_PRES"
BEFORE INSERT OR UPDATE
ON PR_PRID_PRES
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_PRID_PRES is null then
      Select GEN_PR_PRID_PRES.nextval
        into :new.ID_PR_PRID_PRES
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
prompt Creating trigger T_B_IU_PR_PRINTER
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_PRINTER"
BEFORE INSERT OR UPDATE
ON PR_PRINTER
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_PRINTER is null then
      Select GEN_PR_PRINTER.nextval
        into :new.ID_PR_PRINTER
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
prompt Creating trigger T_B_IU_PR_PRINTER_TYPE
prompt =======================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_PRINTER_TYPE"
BEFORE INSERT OR UPDATE
ON PR_PRINTER_TYPE
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_PRINTER_TYPE is null then
      Select GEN_PR_PRINTER_TYPE.nextval
        into :new.ID_PR_PRINTER_TYPE
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
prompt Creating trigger T_B_IU_PR_RESOLUTION
prompt =====================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_RESOLUTION"
BEFORE INSERT OR UPDATE
ON PR_RESOLUTION
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_RESOLUTION is null then
      Select GEN_PR_RESOLUTION.nextval
        into :new.ID_PR_RESOLUTION
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
prompt Creating trigger T_B_IU_PR_TYPE_LINK_JOB
prompt ========================================
prompt
CREATE OR REPLACE TRIGGER "T_B_IU_PR_TYPE_LINK_JOB"
BEFORE INSERT OR UPDATE
ON PR_TYPE_LINK_JOB
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_PR_TYPE_LINK_JOB is null then
      Select GEN_PR_TYPE_LINK_JOB.nextval
        into :new.ID_PR_TYPE_LINK_JOB
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
CREATE OR REPLACE TRIGGER "T_B_IU_WB_USER"
BEFORE INSERT OR UPDATE
ON WB_USER
FOR EACH ROW
BEGIN
  if INSERTING then
    if :new.ID_WB_USER is null then
      Select GEN_WB_USER.nextval
        into :new.ID_WB_USER
        from dual;
    end if;
    :new.CREATE_USER := nvl(wb.get_wb_user, USER);
    :new.CREATE_DATE := sysdate;
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
    :new.wb_name     := upper(:new.wb_name);
  end if;
  if UPDATING then
    :new.LAST_USER   := nvl(wb.get_wb_user, USER);
    :new.LAST_DATE   := sysdate;
    :new.wb_name     := upper(:new.wb_name);
  end if;
END;
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
prompt Creating trigger T_I_IUD_PR_CLIENTS_VIEW
prompt ========================================
prompt
create or replace trigger t_i_iud_pr_clients_view
   instead of insert or update or delete on pr_clients_view
   for each row
declare
   l_id number := :old.id_pr_clients_view;
begin
   if inserting then
      insert into pr_clients (id_pr_clients, id_pr_clients_type, name, dogovor, date_start, director, otvetst, email, phone) values (null, :new.id_pr_clients_type, :new.name, :new.dogovor, :new.date_start, :new.director, :new.otvetst, :new.email, :new.phone) returning id_pr_clients into l_id;
      dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

   elsif updating then
      update pr_clients mm
         set mm.name         = :new.name,
             mm.dogovor      = :new.dogovor,
             mm.id_pr_clients_type = :new.id_pr_clients_type,
             mm.director     = :new.director,
             mm.otvetst      = :new.otvetst,
             mm.date_start   = :new.date_start,
             mm.email        = :new.email,
             mm.phone        = :new.phone
       where mm.id_pr_clients = l_id;
   else
      delete from pr_clients mm where mm.id_pr_clients = l_id;
   end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_PR_CLIENTS_W_DOCS
prompt ==========================================
prompt
create or replace trigger t_i_iud_pr_clients_w_docs
   instead of insert or update or delete on pr_clients_w_docs
   for each row
declare
   l_id number := :old.id_pr_clients_w_docs;
begin
   if inserting then
      insert into pr_clients_docs (id_pr_clients_docs,id_pr_clients,comments) values (null, :new.id_pr_clients_view, :new.comments) returning id_pr_clients_docs into l_id;
      dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

   elsif updating then
      update pr_clients_docs mm
         set mm.comments     = :new.comments
       where mm.id_pr_clients_docs = l_id;
   else
      delete from pr_clients_docs mm where mm.id_pr_clients_docs = l_id;
   end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_PR_CONTRAGENTS_DOCS
prompt ============================================
prompt
create or replace trigger t_i_iud_pr_contragents_docs
   instead of insert or update or delete on pr_contragents_docs
   for each row
declare
   l_id number := :old.id_pr_contragents_docs;
begin
   if inserting then
      insert into pr_clients_docs (id_pr_clients_docs,id_pr_clients,comments) values (null, :new.id_pr_contragents_view, :new.comments) returning id_pr_clients_docs into l_id;
      dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

   elsif updating then
      update pr_clients_docs mm
         set mm.comments     = :new.comments
       where mm.id_pr_clients_docs = l_id;
   else
      delete from pr_clients_docs mm where mm.id_pr_clients_docs = l_id;
   end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_PR_CONTRAGENTS_VIEW
prompt ============================================
prompt
create or replace trigger t_i_iud_pr_contragents_view
   instead of insert or update or delete on pr_contragents_view
   for each row
declare
   l_id number := :old.id_pr_contragents_view;
begin
   if inserting then
      insert into pr_clients (id_pr_clients, id_pr_clients_type, name, dogovor, date_start, director, otvetst, email, phone) values (null, 1, :new.name, :new.dogovor, :new.date_start, :new.director, :new.otvetst, :new.email, :new.phone) returning id_pr_clients into l_id;
      dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);
   
   elsif updating then
      update pr_clients mm
         set mm.name         = :new.name,
             mm.dogovor      = :new.dogovor,
             mm.director     = :new.director,
             mm.otvetst      = :new.otvetst,
             mm.date_start   = :new.date_start,
             mm.email        = :new.email,
             mm.phone        = :new.phone
       where mm.id_pr_clients = l_id;
   else
      delete from pr_clients mm where mm.id_pr_clients = l_id;
   end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_PR_MATERIAL_DYNAMICS
prompt =============================================
prompt
create or replace trigger t_i_iud_pr_material_dynamics
   instead of insert on pr_material_dynamics
   for each row
declare
   l_id number := substr(:old.id_pr_material_dynamics, 3);
   l_id_new number := substr(:new.id_pr_material_ostatok, 3);
   l_val_tmp pr_material.value%type;
begin
   if inserting then
     
      -- смотрим приход или расход
      if :new.in_out = 'I' then
        l_val_tmp:=  abs(:new.val);
      else 
        l_val_tmp:=  abs(:new.val) * -1;
      end if;
      
      -- обновляем табличку материалов
      update pr_material m set m.value = m.value + l_val_tmp where m.id_pr_material = l_id_new;
      
      -- Добавляем запись аудита
      insert into pr_material_dyn
         (id_pr_material_dyn, id_pr_material, val, in_out, id_pr_client, comments, id_zakaz)      
      values
         (null, l_id_new, abs(:new.val), :new.in_out, :new.id_pr_client, :new.comments, :new.id_zakaz)
      returning id_pr_material_dyn into l_id;
   
      dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);   
   end if;
end;
/

prompt
prompt Creating trigger T_I_IUD_PR_PRINTER_VIEW
prompt ========================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_pr_printer_view
INSTEAD OF INSERT OR UPDATE OR DELETE
ON pr_printer_view
FOR EACH ROW
DECLARE
  l_id number := substr(:old.id_pr_printer_view, 3);
begin

  if INSERTING then
    insert into pr_printer(id_pr_printer,id_pr_printer_type,name,width,comments,location)
                   values (null, substr(:new.id_parent, 3), :new.name, :new.widths,:new.comments, :new.location)
             returning id_pr_printer into l_id;
    dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);

  elsif UPDATING then
    update pr_printer fc set
      fc.name            = :new.name,
      fc.width           = :new.widths,
      fc.comments        = :new.comments,
      fc.location        = :new.location
      where fc.id_pr_printer = l_id;
  else
    delete
      from pr_printer fc
      where fc.id_pr_printer = l_id;
  end if;
END;
/

prompt
prompt Creating trigger T_I_IUD_PR_PRINTER_VIEW_MT
prompt ===========================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_pr_printer_view_mt
INSTEAD OF insert OR DELETE
ON pr_material_view
FOR EACH ROW
DECLARE
  l_id number := :old.id_pr_material_view;
begin

  if INSERTING then
    insert into PR_PRID_MT(id_pr_prid_mt,id_pr_printer,id_pr_material)
                   values (null, substr(:new.id_pr_printer_view, 3), :new.material)
             returning id_pr_prid_mt into l_id;
    dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);
   else
    delete
      from PR_PRID_MT fc
      where fc.id_pr_prid_mt = l_id;
  end if;
END;
/

prompt
prompt Creating trigger T_I_IUD_PR_RESOLUTION_VIEW
prompt ===========================================
prompt
CREATE OR REPLACE TRIGGER T_I_IUD_pr_resolution_view
INSTEAD OF insert OR DELETE
ON pr_resolution_view
FOR EACH ROW
DECLARE
  l_id number := :old.id_pr_resolution_view;
begin

  if INSERTING then
    insert into PR_PRID_PRES(id_pr_prid_pres, pr_printer, pr_resolution)
                   values (null, substr(:new.id_pr_printer_view, 3), :new.dpi)
             returning id_pr_prid_pres into l_id;
    dbms_session.set_context('CLIENTCONTEXT', 'rowid', l_id);
   else
    delete
      from PR_PRID_PRES fc
      where fc.id_pr_prid_pres = l_id;
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
                             is_read_only,count_element,width,xls_position_col,xls_position_row,is_requred,fl_html_code)
      values (null,:new.id_wb_mm_form_view,:new.num,:new.name,:new.field_name,:new.field_txt,:new.id_wb_form_field_align,:new.field_type,
              :new.is_read_only,:new.count_element,:new.width,:new.xls_position_col,:new.xls_position_row,:new.is_requred,:new.fl_html_code)
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
      ff.fl_html_code           = :new.fl_html_code
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
    insert into wb_mm_form(id_wb_mm_form, id_wb_main_menu,num,name,id_wb_form_type,action_sql,object_name,xsl_file_in,html_img,
                             xsl_file_out,form_where,id_wb_chart_type,is_read_only,chart_show_name,chart_rotate_name,
                             chart_x,chart_y,chart_dec_prec,height_rate,owner,edit_button,auto_update,form_order)
      values (null,n_id,:new.num,:new.name,:new.id_wb_form_type,:new.action_sql,:new.object_name,:new.xsl_file_in,:new.html_img,
              :new.xsl_file_out,:new.form_where,:new.id_wb_chart_type,:new.is_read_only,:new.chart_show_name,:new.chart_rotate_name,
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
      mf.html_img          = :new.html_img,
      mf.xsl_file_out      = :new.xsl_file_out,
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


spool off
