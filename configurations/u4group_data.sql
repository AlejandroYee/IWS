﻿prompt PL/SQL Developer import file
prompt Created on 9 Сентябрь 2013 г. by Andrey.Lysikov
set feedback off
set define off
prompt Disabling triggers for PR_CLIENTS_TYPE...
alter table PR_CLIENTS_TYPE disable all triggers;
prompt Disabling triggers for PR_CLIENTS...
alter table PR_CLIENTS disable all triggers;
prompt Disabling triggers for PR_MATERIAL_TYPE...
alter table PR_MATERIAL_TYPE disable all triggers;
prompt Disabling triggers for PR_MATERIAL...
alter table PR_MATERIAL disable all triggers;
prompt Disabling triggers for PR_MATERIAL_DYN...
alter table PR_MATERIAL_DYN disable all triggers;
prompt Disabling triggers for PR_PRINTER_TYPE...
alter table PR_PRINTER_TYPE disable all triggers;
prompt Disabling triggers for PR_PRINTER...
alter table PR_PRINTER disable all triggers;
prompt Disabling triggers for PR_PRID_MT...
alter table PR_PRID_MT disable all triggers;
prompt Disabling triggers for PR_RESOLUTION...
alter table PR_RESOLUTION disable all triggers;
prompt Disabling triggers for PR_PRID_PRES...
alter table PR_PRID_PRES disable all triggers;
prompt Disabling triggers for WB_ROLE...
alter table WB_ROLE disable all triggers;
prompt Disabling triggers for WB_USER...
alter table WB_USER disable all triggers;
prompt Disabling triggers for PR_TYPE_LINK_JOB...
alter table PR_TYPE_LINK_JOB disable all triggers;
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
prompt Disabling triggers for WB_MM_ROLE...
alter table WB_MM_ROLE disable all triggers;
prompt Disabling triggers for WB_PARAM_TYPE...
alter table WB_PARAM_TYPE disable all triggers;
prompt Disabling triggers for WB_PARAM_VALUE...
alter table WB_PARAM_VALUE disable all triggers;
prompt Disabling triggers for WB_ROLE_USER...
alter table WB_ROLE_USER disable all triggers;
prompt Disabling triggers for WB_SETTINGS...
alter table WB_SETTINGS disable all triggers;
prompt Disabling foreign key constraints for PR_CLIENTS...
alter table PR_CLIENTS disable constraint ID_PR_CLIENTS_TYPE;
prompt Disabling foreign key constraints for PR_MATERIAL...
alter table PR_MATERIAL disable constraint PK_MATERIAL_TYPE;
prompt Disabling foreign key constraints for PR_MATERIAL_DYN...
alter table PR_MATERIAL_DYN disable constraint PK_PR_CLIENT;
alter table PR_MATERIAL_DYN disable constraint PK_PR_MATERIAL;
prompt Disabling foreign key constraints for PR_PRINTER...
alter table PR_PRINTER disable constraint PK_PR_PR_TYPE;
prompt Disabling foreign key constraints for PR_PRID_MT...
alter table PR_PRID_MT disable constraint PK_ID_MAT;
alter table PR_PRID_MT disable constraint PK_ID_PR;
prompt Disabling foreign key constraints for PR_PRID_PRES...
alter table PR_PRID_PRES disable constraint PK_PR_PRINTER_KEY;
alter table PR_PRID_PRES disable constraint PK_PR_RESOLUTION_KEY;
prompt Disabling foreign key constraints for PR_TYPE_LINK_JOB...
alter table PR_TYPE_LINK_JOB disable constraint PK_ID_PR_PRINTER_TYPE;
alter table PR_TYPE_LINK_JOB disable constraint PK_ID_WB_ROLE;
alter table PR_TYPE_LINK_JOB disable constraint PK_ID_WB_USER;
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
prompt Loading PR_CLIENTS_TYPE...
insert into PR_CLIENTS_TYPE (id_pr_clients_type, name, comments)
values (1, 'Контрагенты - поставщики', 'Данные только о поставщиках и контрагентах');
insert into PR_CLIENTS_TYPE (id_pr_clients_type, name, comments)
values (2, 'ВИП Клиенты', 'Постоянные клиенты и привелигированные заказчики');
insert into PR_CLIENTS_TYPE (id_pr_clients_type, name, comments)
values (3, 'Клиенты', 'Общий список клиентов');
prompt 3 records loaded
prompt Loading PR_CLIENTS...
insert into PR_CLIENTS (id_pr_clients, id_pr_clients_type, name, dogovor, director, otvetst, last_action_date, date_start, email, phone, create_user, create_date, last_user, last_date)
values (1, null, 'Имидж-Про', '120/07-ТД', 'Василий Палыч', 'Павел Георгиевич', null, to_date('01-07-2013', 'dd-mm-yyyy'), null, '+79288840051', 'ALYSIKOV', to_date('26-07-2013 10:55:39', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('26-07-2013 10:55:39', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_CLIENTS (id_pr_clients, id_pr_clients_type, name, dogovor, director, otvetst, last_action_date, date_start, email, phone, create_user, create_date, last_user, last_date)
values (21, 3, 'sdf', 'asdfasdfasdf', 'asdfasdf', 'sdf', null, to_date('07-08-2013', 'dd-mm-yyyy'), null, '445345345', 'ANDREY.LYSIKOV', to_date('20-08-2013 10:02:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:02:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_CLIENTS (id_pr_clients, id_pr_clients_type, name, dogovor, director, otvetst, last_action_date, date_start, email, phone, create_user, create_date, last_user, last_date)
values (3, 1, 'Зенон', null, 'пупкин', 'пупки', null, to_date('01-01-2013', 'dd-mm-yyyy'), null, '+7861740074', 'ANDREY.LYSIKOV', to_date('26-07-2013 12:59:35', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:59:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_CLIENTS (id_pr_clients, id_pr_clients_type, name, dogovor, director, otvetst, last_action_date, date_start, email, phone, create_user, create_date, last_user, last_date)
values (2, 1, 'Прим Тек', '12-45/8', 'Байданов Олег', 'Вася', null, to_date('01-07-2013', 'dd-mm-yyyy'), 'pop@me.com', '+79285550068', 'ANDREY.LYSIKOV', to_date('26-07-2013 11:05:22', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:05:41', 'dd-mm-yyyy hh24:mi:ss'));
prompt 4 records loaded
prompt Loading PR_MATERIAL_TYPE...
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (1, 'Баннер для печати', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:36:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:37:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (2, 'Пленка для печати', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:36:48', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:37:20', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (3, 'Пленка ORACAL', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:37:48', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:37:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (4, 'Бумага для печати', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:38:09', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:38:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (5, 'Постобработка', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:39:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:35:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (21, 'Монтаж', 'ANDREY.LYSIKOV', to_date('25-07-2013 11:39:14', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:39:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_MATERIAL_TYPE (id_pr_material_type, name, create_user, create_date, last_user, last_date)
values (22, 'Доставка', 'ANDREY.LYSIKOV', to_date('25-07-2013 11:39:22', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:39:22', 'dd-mm-yyyy hh24:mi:ss'));
prompt 7 records loaded
prompt Loading PR_MATERIAL...
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (21, 2, 50000, 1370, 0, 1, 'Пленка LG', 100, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:32:09', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:32:09', 'dd-mm-yyyy hh24:mi:ss'), 50);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (22, 3, 30000, 1200, 0, 1, 'HICAL 640', 75, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:54:52', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:54:52', 'dd-mm-yyyy hh24:mi:ss'), 68);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (24, 4, 297, 420, 1, 0, 'COLORIT', 210, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:56:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:56:53', 'dd-mm-yyyy hh24:mi:ss'), 1500);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (25, 2, 297, 420, 1, 1, 'COLORIT', 250, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:18', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:18', 'dd-mm-yyyy hh24:mi:ss'), 500);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (23, 4, 297, 210, 1, 0, 'COLORIT', 100, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:56:20', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:56:20', 'dd-mm-yyyy hh24:mi:ss'), 2500);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (26, 5, 100, 30, 1, 0, 'Клей в тюбиках', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:10:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:36:32', 'dd-mm-yyyy hh24:mi:ss'), 20);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (27, 5, 300, 50, 1, 0, 'Клей резиновый в тюбиках', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:11:19', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:36:21', 'dd-mm-yyyy hh24:mi:ss'), 2);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (1, 1, 50000, 3200, 0, 0, 'Конфлекс', 320, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:49:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:55:10', 'dd-mm-yyyy hh24:mi:ss'), 450);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (2, 1, 50000, 3200, 0, 0, 'Конфлекс', 440, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:51:03', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:51:03', 'dd-mm-yyyy hh24:mi:ss'), 15);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (3, 5, 12, 12, 1, 0, 'Люверсы д.12', null, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:51:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:04:40', 'dd-mm-yyyy hh24:mi:ss'), 500);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (4, 5, 10, 10, 1, 0, 'Люверсы д.10', null, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:54:27', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:04:44', 'dd-mm-yyyy hh24:mi:ss'), 100);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (5, 2, 50000, 1520, 0, 1, 'Пленка LG', 100, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:55:07', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:59:48', 'dd-mm-yyyy hh24:mi:ss'), 300);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (6, 4, 50000, 1600, 0, 0, 'Блеклит', 75, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:57:08', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:57:08', 'dd-mm-yyyy hh24:mi:ss'), 210);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (7, 3, 30000, 1200, 0, 0, 'HICAL 35', 120, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:57:45', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:54:18', 'dd-mm-yyyy hh24:mi:ss'), 17);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (28, 5, 120, 20, 1, 0, 'Ручное лезвие', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:36:07', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:58:14', 'dd-mm-yyyy hh24:mi:ss'), 15);
insert into PR_MATERIAL (id_pr_material, id_pr_material_type, material_width, material_heigth, is_list, is_gloss, name, think, create_user, create_date, last_user, last_date, value)
values (29, 5, 400, 60, 1, 0, 'Автоматическое лезвие', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:38:02', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:38:02', 'dd-mm-yyyy hh24:mi:ss'), 3);
prompt 16 records loaded
prompt Loading PR_MATERIAL_DYN...
insert into PR_MATERIAL_DYN (id_pr_material_dyn, id_pr_material, val, user_ins, date_ins, comments, in_out, id_pr_client, id_zakaz)
values (4, 28, 10, 'Лысиков Андрей Викторович', to_date('26-07-2013 12:58:14', 'dd-mm-yyyy hh24:mi:ss'), 'Магазин наличные', 'I', 2, null);
insert into PR_MATERIAL_DYN (id_pr_material_dyn, id_pr_material, val, user_ins, date_ins, comments, in_out, id_pr_client, id_zakaz)
values (2, 1, 50, 'Лысиков Андрей Викторович', to_date('26-07-2013 12:53:34', 'dd-mm-yyyy hh24:mi:ss'), 'Расход по заказу', 'O', 2, null);
insert into PR_MATERIAL_DYN (id_pr_material_dyn, id_pr_material, val, user_ins, date_ins, comments, in_out, id_pr_client, id_zakaz)
values (3, 1, 150, 'Лысиков Андрей Викторович', to_date('26-07-2013 12:55:10', 'dd-mm-yyyy hh24:mi:ss'), 'Согласно накладной 150', 'I', 2, null);
prompt 3 records loaded
prompt Loading PR_PRINTER_TYPE...
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (1, 'Широкоформатные принтеры', 'Оборудование размером 3,2 метра', 'ANDREY.LYSIKOV', to_date('22-04-2013 21:18:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:18:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (2, 'Интерьерные принтеры', 'Оборудование широкоформатной печати меньше 3,2 метра', 'ANDREY.LYSIKOV', to_date('22-04-2013 21:19:27', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:19:27', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (3, 'Лазерная печать', 'Лазерное оборудование', 'ANDREY.LYSIKOV', to_date('22-04-2013 21:19:56', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:19:56', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (4, 'Оборудование для резки', 'Плоттеры', 'ANDREY.LYSIKOV', to_date('22-04-2013 21:20:21', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:20:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (5, 'Пост-обработка широкоформатки', 'Люверсаторы, проклейщики, итд.', 'ANDREY.LYSIKOV', to_date('22-04-2013 21:24:23', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:31:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (6, 'Пост-обработка полиграфии', 'Вся техника полиграфии', 'ANDREY.LYSIKOV', to_date('22-04-2013 21:25:06', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:31:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (21, 'Доставка', 'Доставка транспортным средством', 'ALYSIKOV', to_date('25-07-2013 10:58:23', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 10:58:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRINTER_TYPE (id_pr_printer_type, name, comments, create_user, create_date, last_user, last_date)
values (22, 'Монтаж', 'Монтаж и сопутсвующие расходы', 'ALYSIKOV', to_date('25-07-2013 10:58:23', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 10:58:23', 'dd-mm-yyyy hh24:mi:ss'));
prompt 8 records loaded
prompt Loading PR_PRINTER...
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (62, 5, 'Проклейка', 'Проклейка метр погонный', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:13:00', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:33:26', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (1, 1, 'Infinity 3206', 'Широкоформатный корейский принтер', 'Печатный цех, подвал', 'U4GROUP', to_date('22-04-2013 21:44:47', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 21:46:34', 'dd-mm-yyyy hh24:mi:ss'), 3200);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (2, 4, 'Star Cutter CM120', 'Китайский плоттер', 'Печатный цех, подвал', 'U4GROUP', to_date('22-04-2013 21:45:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 20:58:20', 'dd-mm-yyyy hh24:mi:ss'), 1200);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (21, 3, 'Konika minolta Paper station', 'Цветной лазерный принтер', 'Печатный цех, подвал', 'ANDREY.LYSIKOV', to_date('24-04-2013 21:01:35', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 21:02:22', 'dd-mm-yyyy hh24:mi:ss'), 420);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (41, 5, 'Люверсатор автоматический', 'Ручной автоматический люверсатор', null, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:27:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:27:01', 'dd-mm-yyyy hh24:mi:ss'), 12);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (42, 5, 'Люверсатор ручной', null, null, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:27:19', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('25-04-2013 21:28:34', 'dd-mm-yyyy hh24:mi:ss'), 12);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (43, 5, 'Люверсатор ручной', null, null, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:27:34', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('25-04-2013 21:28:34', 'dd-mm-yyyy hh24:mi:ss'), 10);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (65, 21, 'Доставка по городу', 'Адресная доставка', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:03:06', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:03:06', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (66, null, 'Доставка вне города', 'Адресная доставка', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:03:22', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:03:22', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (67, 2, 'MIMAKI JVC3', 'Цветной струйный принтер', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:05', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:05', 'dd-mm-yyyy hh24:mi:ss'), 1800);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (68, 22, 'Монтаж на веревку', 'Монтаж на веревку через люверсы', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:43', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:43', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (69, null, 'Монтаж на степлер', 'Монтаж степлер', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:57', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:57', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (70, 21, 'Доставка по региону', 'Доставка ко километражу', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:26:14', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:26:14', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (71, 22, 'Монтаж на степлер', null, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:27:57', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:27:57', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (72, 5, 'Обрезка', 'Обрезка погонного метра', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:34:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:34:29', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (63, 6, 'Резка', 'Резка за погонный метры', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:33:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:33:54', 'dd-mm-yyyy hh24:mi:ss'), null);
insert into PR_PRINTER (id_pr_printer, id_pr_printer_type, name, comments, location, create_user, create_date, last_user, last_date, width)
values (64, 6, 'Проклейка', 'Проклейка метр погонный', null, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:34:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:34:55', 'dd-mm-yyyy hh24:mi:ss'), null);
prompt 17 records loaded
prompt Loading PR_PRID_MT...
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (21, 1, 21, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:48:35', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:48:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (25, 41, 3, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:52:40', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:52:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (23, 43, 4, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:48:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:48:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (24, 42, 3, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:52:35', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:52:35', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (29, 21, 24, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:34', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:34', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (30, 21, 25, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:40', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (31, 21, 23, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:45', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:57:45', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (35, 67, 5, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:03', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (36, 67, 6, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:09', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:05:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (32, 62, 26, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:13:25', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:13:25', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (33, 62, 27, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:13:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:13:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (1, 1, 1, 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (2, 1, 2, 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (3, 1, 5, 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (4, 1, 6, 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (5, 2, 7, 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 23:24:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (26, 2, 22, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:55:07', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:55:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (27, 2, 21, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:55:11', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:55:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (28, 2, 5, 'ANDREY.LYSIKOV', to_date('25-07-2013 09:55:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 09:55:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (34, 67, 21, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:51', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (37, 72, 28, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:36:57', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:36:57', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (38, 63, 28, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:37:08', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:37:08', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (39, 63, 29, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:38:17', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:38:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_MT (id_pr_prid_mt, id_pr_printer, id_pr_material, create_user, create_date, last_user, last_date)
values (40, 64, 27, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:38:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:38:29', 'dd-mm-yyyy hh24:mi:ss'));
prompt 24 records loaded
prompt Loading PR_RESOLUTION...
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (1, 180, 180, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:24', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:24', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (2, 180, 360, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:31', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:31', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (3, 180, 540, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:38', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (4, 360, 360, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:46', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (5, 360, 540, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (6, 360, 720, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:58', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:58', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (7, 720, 720, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:59:05', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:59:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_RESOLUTION (id_pr_resolution, hdpi, wdpi, create_user, create_date, last_user, last_date)
values (8, 720, 1440, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:59:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:19:39', 'dd-mm-yyyy hh24:mi:ss'));
prompt 8 records loaded
prompt Loading PR_PRID_PRES...
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (1, 1, 4, 'U4GROUP', to_date('22-04-2013 21:47:51', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 21:47:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (21, 1, 7, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:19:20', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:19:20', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (41, 1, 5, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:25:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:25:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (42, 21, 7, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:26:11', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:26:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (43, 21, 8, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:26:15', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:26:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (44, 21, 2, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:26:19', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:26:19', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (64, 67, 2, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:22', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:22', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (65, 67, 4, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:28', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:28', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (66, 67, 5, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (67, 67, 6, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:37', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:37', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (68, 67, 7, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:42', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:42', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_PRID_PRES (id_pr_prid_pres, pr_printer, pr_resolution, create_user, create_date, last_user, last_date)
values (69, 67, 8, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:47', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:04:47', 'dd-mm-yyyy hh24:mi:ss'));
prompt 12 records loaded
prompt Loading WB_ROLE...
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (28, 'PRINT_POST', 'Постобработка', 'ANDREY.LYSIKOV', to_date('25-07-2013 15:16:37', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:16:37', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (31, 'MATERIAL', 'Склад, контрагенты, поставщики', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:32:42', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:32:42', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (23, 'PRINT_BIG', 'Широкоформатная печать', 'ANDREY.LYSIKOV', to_date('25-07-2013 12:03:26', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (24, 'PRINT_SMALL', 'Интерьернаня печать', 'ANDREY.LYSIKOV', to_date('25-07-2013 12:03:45', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:24:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (25, 'PRINT_CUTTERS', 'Резка на плоттере', 'ANDREY.LYSIKOV', to_date('25-07-2013 12:04:05', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:24:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (3, 'DIRECTORIES', 'Справочники, настройка подсистемы печати', 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:03', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (1, 'ADMIN', 'Администраторы', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (2, 'ADMIN_USER', 'Администратор пользователей и ролей', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (30, 'PRINT_LAZER', 'Лазерная печать', 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:21', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE (id_wb_role, wb_name, name, create_user, create_date, last_user, last_date)
values (43, 'PRINT_DOCU', 'Документы, клиенты', 'ANDREY.LYSIKOV', to_date('20-08-2013 09:45:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:45:29', 'dd-mm-yyyy hh24:mi:ss'));
prompt 10 records loaded
prompt Loading WB_USER...
insert into WB_USER (id_wb_user, wb_name, name, create_user, create_date, last_user, last_date, e_mail, phone, param_view, password)
values (1, 'ANDREY.LYSIKOV', 'Лысиков Андрей Викторович', 'Администратор', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 13:00:51', 'dd-mm-yyyy hh24:mi:ss'), 'andrey.boomer@gmail.com', '+79288840051', 'theme:dGhlbWVzL3dpbmRvd3M4L2pxdWVyeS11aS0xLjEwLjIuY3VzdG9tLmNzcw==;page_enable:Y2hlY2tlZA==;width_enable:b2Zm;multiselect:b2Zm;editabled:b2Zm;hide_menu:b2Zm;num_mounth:Mw==;cache_enable:Y2hlY2tlZA==;render_type:Mw==;num_reck:MTAw', null);
prompt 1 records loaded
prompt Loading PR_TYPE_LINK_JOB...
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (1, 23, 1, 10, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:20:31', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:20:31', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (2, 23, 5, 20, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:20:57', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:20:57', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (3, 23, 21, 30, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:21:10', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:21:10', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (4, 23, 22, 40, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:21:20', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:21:20', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (5, 25, 4, 10, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:22:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:22:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (6, 25, 5, 20, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:22:51', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:22:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (7, 25, 21, 30, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:23:08', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:23:08', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (8, 25, 22, 40, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:23:17', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:23:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (9, 30, 3, 10, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:45', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:45', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (10, 30, 6, 20, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:56', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:25:56', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (11, 30, 21, 30, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:26:03', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:26:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (15, 24, 21, 30, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:27:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:27:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (13, 24, 2, 10, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:26:48', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:26:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (14, 24, 5, 20, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:26:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:26:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into PR_TYPE_LINK_JOB (id_pr_type_link_job, id_wb_role, id_pr_printer_type, num, id_wb_user, create_user, create_date, last_user, last_date)
values (16, 24, 22, 40, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:27:08', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:27:08', 'dd-mm-yyyy hh24:mi:ss'));
prompt 15 records loaded
prompt Loading WB_ACCESS_TYPE...
insert into WB_ACCESS_TYPE (id_wb_access_type, wb_name, name, create_user, create_date, last_user, last_date)
values (-1, 'disable', 'Запрещено', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ACCESS_TYPE (id_wb_access_type, wb_name, name, create_user, create_date, last_user, last_date)
values (1, 'enable', 'Разрешено', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
prompt 2 records loaded
prompt Loading WB_CHART_TYPE...
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (1, 'Column2D', 'Single Series Column 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (2, 'Column3D', 'Single Series Column 3D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (3, 'Line', 'Single Series Line Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (4, 'Pie3D', 'Single Series Pie 3D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (5, 'Pie2D', 'Single Series Pie 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (6, 'Bar2D', 'Single Series Bar 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (7, 'Area2D', 'Single Series Area 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (8, 'Doughnut2D', 'Single Series Doughnut 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (9, 'MSColumn3D', 'Multi-Series Column 3D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (10, 'MSColumn2D', 'Multi-Series Column 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (11, 'MSArea2D', 'Multi-Series Column 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (12, 'MSLine', 'Multi-Series Line Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (13, 'MSBar2D', 'Multi-Series Bar Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (14, 'StackedColumn2D', 'Stacked Column 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (15, 'StackedColumn3D', 'Stacked Column 3D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (16, 'StackedBar2D', 'Stacked Bar 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (17, 'StackedArea2D', 'Stacked Area 2D Chart', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (18, 'MSColumn3DLineDY', 'Combination Dual Y Chart (Column 3D + Line)', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (19, 'MSColumn2DLineDY', 'Combination Dual Y Chart (Column 2D + Line)', 'FusionCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_CHART_TYPE (id_wb_chart_type, name, description, type_chart, create_user, create_date, last_user, last_date)
values (20, 'MultiAxisLine', 'MultiAxisLine', 'PowerCharts', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
prompt 20 records loaded
prompt Loading WB_FIELD_TYPE...
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (2, 'B', 'Переключатель', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (3, 'C', 'Валюта (руб.)', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (4, 'D', 'Дата', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (5, 'DT', 'Дата и время', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (6, 'E', 'E-mail', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (7, 'F', 'Файл', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (8, 'FB', 'Файл в таблице', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (9, 'I', 'Целое число', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (10, 'M', 'Многострочный текст', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (11, 'N', 'Дробное число', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (12, 'NL', 'Дробное (более точное)', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (13, 'P', 'Поле пароля', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (14, 'S', 'Строковое значение', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FIELD_TYPE (id_wb_field_type, id, name, create_user, create_date, last_user, last_date)
values (15, 'SB', 'Выпадающий список', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
prompt 14 records loaded
prompt Loading WB_FORM_TYPE...
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-1, 13, 'WIZARD_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Формальный признак указывающий на то что данные вводятся с помощью мастера');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-2, 13, 'BUTTON_CUSTOM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Пользовательская кнопка');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-3, 1, 'INPUT_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Форма запроса данных');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-4, 3, 'PL_SQL_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Форма выполнения скрипта');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-5, 4, 'DOWNLOAD_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Выгрузка файла');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-6, 5, 'GRID_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Простая табличная форма');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-7, 6, 'CHARTS_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'График');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-8, 7, 'GRID_FORM_MASTER', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Форма таблиц с дочерней таблицей');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-9, 8, 'GRID_FORM_DETAIL', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Форма дочерней таблицы');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-10, 10, 'INPUT_FORM_UPLOAD', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Формальный признак что можно прикреплять файлы к строке');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-11, 11, 'TREE_GRID_FORM', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Древовидная форма');
insert into WB_FORM_TYPE (id_wb_form_type, num, name, create_user, create_date, last_user, last_date, human_name)
values (-12, 12, 'TREE_GRID_FORM_MASTER', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'Древовидная форма с подтаблицей');
prompt 12 records loaded
prompt Loading WB_MAIN_MENU...
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000044, null, 20, 'Материалы, контрагенты', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:30:25', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:30:25', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000045, 1000044, 10, 'Справочники', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:31:02', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:31:02', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000046, 1000045, 10, 'Контрагенты', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:31:21', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:31:21', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000047, 1000044, 20, 'Остатки материалов, движения материалов', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:31:34', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:54:51', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000062, 1000043, 10, 'Клиенты', 'ANDREY.LYSIKOV', to_date('20-08-2013 09:43:18', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:43:18', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000043, null, 50, 'Документы', 'ANDREY.LYSIKOV', to_date('25-07-2013 15:28:10', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:42:06', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000002, null, 10, 'Системные справочники', 'U4GROUP', to_date('22-04-2013 17:52:27', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:20:18', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000004, 1000048, 10, 'Справочник разрешений печати', 'U4GROUP', to_date('22-04-2013 17:54:18', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 16:41:29', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000005, 1000002, 50, 'Оборудование, постобработка', 'U4GROUP', to_date('22-04-2013 17:54:18', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:35:30', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000006, 1000048, 20, 'Справочник категорий оборудования и работы', 'U4GROUP', to_date('22-04-2013 17:54:18', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 16:41:29', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-1, null, 999, 'Администрирование', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-2, -1, 7, 'Доступы', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('29-04-2013 20:54:59', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-3, -1, 2, 'Главное меню', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-4, -1, 3, 'Формы - Столбцы', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-5, -1, 5, 'Типы выравниваний полей', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-6, -1, 4, 'Формы - Ячейки на печать', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-7, -1, 1, 'Глобальные переменные', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-8, -2, 2, 'Пользователи и Права доступа', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-9, -2, 1, 'Роли пользователей и меню', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000022, 1000048, 15, 'Справочник категорий материалов', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:32:55', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 16:41:29', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000023, 1000002, 25, 'Материалы', 'ANDREY.LYSIKOV', to_date('22-04-2013 22:33:11', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:41:29', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (-10, -1, 6, 'Описание параметров', 'U4GROUP', to_date('29-04-2013 20:39:20', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('29-04-2013 20:55:04', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000048, 1000002, 10, 'Справочники', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:38:05', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:38:05', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000049, 1000048, 30, 'Справочник типов компаний', 'ANDREY.LYSIKOV', to_date('25-07-2013 16:42:06', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:42:06', 'dd-mm-yyyy hh24:mi:ss'), 1);
insert into WB_MAIN_MENU (id_wb_main_menu, id_parent, num, name, create_user, create_date, last_user, last_date, used)
values (1000042, 1000002, 60, 'Типы и последовательности работ', 'ANDREY.LYSIKOV', to_date('25-07-2013 10:36:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:36:53', 'dd-mm-yyyy hh24:mi:ss'), 1);
prompt 25 records loaded
prompt Loading WB_MM_FORM...
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000208, 1000046, 20, 'Документы и файлы по этому контрагенту', -9, null, 'PR_CONTRAGENTS_DOCS', null, null, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 30, 'ALYSIKOV', null, 'A,E,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000205, 1000047, 10, 'Список материалов', -12, null, 'PR_MATERIAL_OSTATOK', null, null, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:12:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 18:00:19', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, 0, 0, null, null, null, 60, 'ALYSIKOV', null, 'EXP', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000221, 1000062, 10, 'Список клиентов', -8, null, 'PR_CLIENTS_VIEW', null, null, null, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 70, 'ALYSIKOV', null, 'A,E', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000222, 1000062, 20, 'Документы по выбранному клиенту', -9, null, 'PR_CLIENTS_W_DOCS', null, null, null, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 30, 'ALYSIKOV', null, 'A,E,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000223, 1000062, 30, 'Формальный обьект для загрузки файлов', -10, null, 'PR_CLIENTS_DOCS', null, null, null, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:04:13', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:04:13', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, null, 'ALYSIKOV', null, null, null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000207, 1000046, 10, 'Контрагенты', -8, null, 'PR_CONTRAGENTS_VIEW', null, null, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 10:54:53', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 70, 'ALYSIKOV', null, 'A,E,D,EXP', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000209, 1000046, 30, 'Формальный обьект для загрузки файла', -10, null, 'PR_CLIENTS_DOCS', null, null, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:22:33', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:22:33', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, 0, 0, null, null, null, 0, 'ALYSIKOV', null, null, null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000201, 1000042, 20, 'Типы и последовательность работы', -9, null, 'PR_TYPE_LINK_JOB', null, null, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:21:41', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 60, 'ALYSIKOV', null, 'A,E,D,EXP', null, 'NUM');
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000203, 1000042, 10, 'Доступные роли работ', -8, null, 'WB_ROLE', null, null, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:18:22', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, 0, 0, null, null, null, 40, 'ALYSIKOV', null, 'A,E,D', null, 'WB_NAME');
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000204, 1000049, 10, 'Типы компаний, включая системные', -6, null, 'PR_CLIENTS_TYPE', null, null, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 100, 'ALYSIKOV', null, 'A,E,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000206, 1000047, 20, 'Динамика материала', -9, null, 'PR_MATERIAL_DYNAMICS', null, null, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:55:33', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 40, 'ALYSIKOV', null, 'A,EXP', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000041, 1000006, 10, 'Типы оборудования (разделы)', -6, null, 'PR_PRINTER_TYPE', null, null, null, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 100, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000121, 1000023, 10, 'Список материалов', -6, null, 'PR_MATERIAL', null, null, null, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:31', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 13:34:49', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 100, 'ALYSIKOV', null, 'A,E,D', null, 'ID_PR_MATERIAL_TYPE');
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000081, 1000005, 10, 'Список оборудования', -12, null, 'PR_PRINTER_VIEW', null, null, null, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 70, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000101, 1000022, 10, 'Типы материалов', -6, null, 'PR_MATERIAL_TYPE', null, null, null, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 100, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000141, 1000005, 20, 'Список поддерживаемых разрешений', -9, null, 'PR_RESOLUTION_VIEW', null, null, null, 'ANDREY.LYSIKOV', to_date('24-04-2013 22:13:28', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 30, 'ALYSIKOV', null, 'A,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-1, -3, 1, 'Главное меню', -11, null, 'WB_MAIN_MENU_VIEW_TREE_USV', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 100, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-2, -4, 1, 'Формы', -8, null, 'WB_MM_FORM_VIEW', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 14:13:00', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 40, 'ALYSIKOV', null, 'A,E,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-4, -4, 2, 'Столбцы', -9, null, 'WB_FORM_FIELD_VIEW', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 60, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-5, -5, 1, 'Типы выравниваний полей', -6, null, 'WB_FORM_FIELD_ALIGN', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 0, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-6, -6, 2, 'Ячейки', -9, null, 'WB_FORM_CELLS_VIEW', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 70, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-7, -8, 1, 'Пользователи', -8, null, 'WB_USER', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 50, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-8, -9, 1, 'Роли', -8, null, 'WB_ROLE', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:17:52', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 30, 'ALYSIKOV', null, 'A,E,D', null, 'WB_NAME');
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-9, -8, 2, 'Права доступа', -9, null, 'WB_ROLE_USER', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 50, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-11, -9, 2, 'Главное меню', -9, null, 'WB_MM_ROLE', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 70, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-3, -7, 1, 'Глобальные переменные', -11, null, 'WB_SETTINGS_VIEW_TREE', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 100, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-10, -5, 2, 'Формы', -9, null, 'WB_MM_FORM_VIEW', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, null, null, null, null, null, 50, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-12, -6, 1, 'Формы', -8, null, 'WB_MM_FORM_VIEW', null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 30, 'ALYSIKOV', null, 'A,E,D', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000001, 1000004, 10, 'Справочник разрешений печати', -6, null, 'PR_RESOLUTION', null, null, null, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 100, 'ALYSIKOV', null, 'A,E,D,EXP', 0, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (1000181, 1000005, 30, 'Справочник материалов', -9, null, 'PR_MATERIAL_VIEW', null, null, null, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:54:41', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, null, null, null, 30, 'ALYSIKOV', null, 'A,D', null, null);
insert into WB_MM_FORM (id_wb_mm_form, id_wb_main_menu, num, name, id_wb_form_type, action_sql, object_name, xsl_file_in, html_img, xsl_file_out, create_user, create_date, last_user, last_date, form_where, id_wb_chart_type, is_read_only, chart_show_name, chart_rotate_name, chart_x, chart_y, chart_dec_prec, height_rate, owner, action_bat, edit_button, auto_update, form_order)
values (-13, -10, 1, 'Описание сохраняемых параметров', -8, null, 'WB_PARAM_TYPE', null, null, null, 'U4GROUP', to_date('29-04-2013 20:39:25', 'dd-mm-yyyy hh24:mi:ss'), 'ALYSIKOV', to_date('25-07-2013 09:07:59', 'dd-mm-yyyy hh24:mi:ss'), null, null, 0, 0, 0, 0, 0, 0, 100, 'ALYSIKOV', null, 'A,E,D', 0, null);
prompt 31 records loaded
prompt Loading WB_FORM_CELLS...
prompt Table is empty
prompt Loading WB_FORM_FIELD_ALIGN...
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (1, 'По левому краю', 'left', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (2, 'По центру', 'center', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (3, 'По правому краю', 'right', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD_ALIGN (id_wb_form_field_align, name, html_txt, create_user, create_date, last_user, last_date)
values (4, 'По ширине ', 'justify', 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
prompt 4 records loaded
prompt Loading WB_FORM_FIELD...
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-127, -6, 11, 'SQL', 'FIELD_TXT', null, null, 1, 'M', 0, 3, 400, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-123, -6, 31, 'XLS Гор.позиция', 'XLS_POSITION_COL', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-122, -6, 32, 'XLS Верт.позиция', 'XLS_POSITION_ROW', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-121, -6, 33, 'XLS Тип', 'XLS_TYPE', null, null, 1, 'S', 0, null, 40, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-125, -6, 17, 'Тип поля', 'FIELD_TYPE', null, 'Select upper(trim(id)) id, name from wb_field_type', 1, 'SB', 0, 0, 80, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-126, -6, 12, 'Алиас поля', 'FIELD_NAME', null, null, 1, 'S', 0, 0, 100, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-124, -6, 21, 'Тип ячейки', 'TYPE_CELLS', null, 'Select id, name  from (Select ''H''  id,  ''H - Шапка отчета''  name from dual union all        Select ''F''  id,  ''F - Подвал отчета'' name from dual)  order by id', 1, 'SB', 0, null, 100, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-119, -7, 1, 'ID (not display)', 'ID_WB_USER', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-118, -7, 3, 'Имя пользователя', 'NAME', null, null, 1, 'S', 0, 0, 300, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-115, -7, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-114, -7, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-113, -7, 94, 'Датаредактирования', 'LAST_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-112, -8, 1, 'ID (not display)', 'ID_WB_ROLE', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-111, -8, 2, 'Наименование', 'WB_NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-110, -8, 3, 'Комментарий', 'NAME', null, null, 1, 'S', 0, null, 630, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-109, -8, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-108, -8, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-107, -8, 93, 'Последнийредактор', 'LAST_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-106, -9, 1, 'ID (not display)', 'ID_WB_ROLE_USER', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-105, -9, 2, 'Наименование роли', 'ID_WB_ROLE', null, 'Select * from (' || chr(10) || '  select t.id_wb_role id,' || chr(10) || '         t.name name ' || chr(10) || '  from wb_role t ' || chr(10) || 'union all' || chr(10) || '  Select null id, ' || chr(10) || '         null name ' || chr(10) || '  from dual) t ' || chr(10) || 'order by t.name nulls first', 1, 'SB', 0, 0, 290, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-104, -9, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-103, -11, 1, 'ID (not display)', 'ID_WB_MM_ROLE', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-102, -11, 2, 'Главное меню', 'ID_WB_MAIN_MENU', null, 'Select t.id, t.name from (Select mm.id_wb_main_menu_view_tree id, mm.tree_name_ name from wb_main_menu_view_tree mm) t', 1, 'SB', 0, 0, 300, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-101, -11, 4, 'Тип доступа', 'ID_WB_ACCESS_TYPE', null, 'Select * from (' || chr(10) || 'select t.id_wb_access_type id,' || chr(10) || '       t.name name' || chr(10) || '       from wb_access_type t) t' || chr(10) || 'order by t.name', 1, 'SB', 0, null, 110, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-100, -11, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-99, -11, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-98, -11, 93, 'Последнийредактор', 'LAST_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-120, -6, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-4, -3, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-3, -3, 50, 'ID_PARENT', 'ID_PARENT', null, null, 3, 'N', 0, null, 200, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-2, -3, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-45, -12, 34, 'Скрипт пост загрузки', 'ACTION_BAT', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-46, -10, 34, 'Скрипт пост загрузки', 'ACTION_BAT', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-44, -2, 34, 'Скрипт пост загрузки', 'ACTION_BAT', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-1, -3, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-37, -1, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-36, -2, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-35, -2, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-34, -2, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-33, -2, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-32, -4, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-31, -4, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-30, -4, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-29, -4, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-28, -4, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-27, -5, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-26, -5, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-25, -5, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-24, -6, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-23, -6, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-22, -6, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-21, -6, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-20, -7, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-19, -7, 2, 'Login', 'WB_NAME', null, null, 1, 'S', 0, 0, 300, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-18, -7, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-17, -8, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-16, -8, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-15, -9, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-14, -9, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-13, -9, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-12, -9, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-11, -11, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-10, -11, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-9, -12, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-172, -1, 3, 'LEV', 'LEV', null, null, 3, 'I', 1, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-68, -10, 22, 'Схема БД', 'OWNER', null, 'select username as id, username as name ' || chr(10) || 'from sys.all_users', 1, 'SB', 0, 0, 280, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000182, 1000201, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000205, 1000204, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000184, 1000201, 30, 'Работы либо оборудование', 'ID_PR_PRINTER_TYPE', null, 'select id_pr_printer_type as id, name' || chr(10) || 'from pr_printer_type ', 2, 'SB', 0, null, 400, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:22:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000185, 1000201, 10, 'Порядок выполнения', 'NUM', null, null, 3, 'I', 0, null, 60, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 13:44:50', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000186, 1000201, 50, 'Ответственный пользователь', 'ID_WB_USER', null, 'select id_wb_user as id, name' || chr(10) || 'from wb_user ', 2, 'SB', 0, null, 400, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:22:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000187, 1000201, 100, 'ID (not display)', 'ID_PR_TYPE_LINK_JOB', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:57:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-195, -2, 25, 'Условие сортировки', 'FORM_ORDER', null, null, 1, 'S', 0, null, 250, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 12:59:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 12:59:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000197, 1000203, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000198, 1000203, 20, 'Идентификатор роли', 'WB_NAME', null, null, 1, 'S', 1, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:10:31', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000199, 1000203, 30, 'Название роли/работ', 'NAME', null, null, 1, 'S', 0, null, 400, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:10:45', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000200, 1000203, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000201, 1000203, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000206, 1000204, 10, 'Наименование', 'NAME', null, null, 1, 'S', 0, null, 400, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:04:29', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000202, 1000203, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000207, 1000204, 100, 'ID (not display)', 'ID_PR_CLIENTS_TYPE', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:43:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000203, 1000203, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000204, 1000203, 100, 'ID (not display)', 'ID_WB_ROLE', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:09:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000208, 1000204, 20, 'Коментарий', 'COMMENTS', null, null, 1, 'S', 0, null, 600, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:04:07', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:04:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000209, 1000205, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'S', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:12:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 18:00:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000210, 1000205, 20, 'Наименование материала', 'NAME', null, null, 1, 'S', 1, null, 600, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:12:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:46:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000211, 1000205, 30, 'Текущий остаток', 'VALUE', null, null, 3, 'N', 0, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:12:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:47:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000212, 1000205, 100, 'ID (not display)', 'ID_PR_MATERIAL_OSTATOK', null, null, 3, 'S', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:12:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:29:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000213, 1000206, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000221, 1000206, 33, 'Поставщик', 'ID_PR_CLIENT', null, 'select p.id_pr_clients as id,' || chr(10) || '       p.name          as name' || chr(10) || '  from pr_clients p' || chr(10) || ' where p.id_pr_clients_type = 1' || chr(10) || '', 1, 'SB', 0, null, 300, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:53:45', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:54:12', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000215, 1000206, 30, 'Значение', 'VAL', null, null, 3, 'N', 0, null, 200, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:45:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000216, 1000206, 40, 'Кто изменил', 'USER_INS', null, null, 1, 'S', 1, null, 300, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:57:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000217, 1000206, 50, 'Дата изменения', 'DATE_INS', null, null, 1, 'DT', 1, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:55:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000218, 1000206, 35, 'Комментарий', 'COMMENTS', null, null, 1, 'S', 0, null, 400, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 17:48:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000219, 1000206, 20, 'Тип', 'IN_OUT', null, 'select ''I'' as id, ''Приход'' as name from dual union all' || chr(10) || 'select ''O'' as id, ''Расход'' as name from dual', 1, 'SB', 0, null, 100, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:52:57', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000220, 1000206, 100, 'ID (not display)', 'ID_PR_MATERIAL_DYNAMICS', null, null, 3, 'S', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-07-2013 17:42:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 12:21:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000222, 1000205, 10, 'ID_PARENT', 'ID_PARENT', null, null, 1, 'S', 1, null, 50, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:28:18', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:28:18', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000223, 1000205, 15, 'LEV', 'LEV', null, null, 1, 'I', 1, null, 50, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:28:34', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:45:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000224, 1000207, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000225, 1000207, 10, 'ID (not display)', 'ID_PR_CONTRAGENTS_VIEW', null, null, 3, 'I', 1, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 10:12:04', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000226, 1000207, 20, 'Наименование', 'NAME', null, null, 1, 'S', 0, null, 400, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:50:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000227, 1000207, 30, 'Договор №', 'DOGOVOR', null, null, 1, 'S', 0, null, 200, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:50:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000228, 1000207, 40, 'Руководитель', 'DIRECTOR', null, null, 1, 'S', 0, null, 200, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:50:37', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000229, 1000207, 50, 'Ответственный по заказам', 'OTVETST', null, null, 1, 'S', 0, null, 200, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:50:57', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000230, 1000207, 60, 'Электронная почта', 'EMAIL', null, null, 1, 'S', 0, null, 250, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:52:22', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000231, 1000207, 70, 'Телефон', 'PHONE', null, null, 1, 'S', 0, null, 130, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:51:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000232, 1000207, 35, 'Дата договора', 'DATE_START', null, null, 1, 'D', 0, null, 100, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:51:58', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000233, 1000207, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000234, 1000207, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000235, 1000207, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000236, 1000207, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 09:48:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000237, 1000208, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000246, 1000209, 10, 'Загрузить файл в таблицу', 'FILE_NAME', null, null, 1, 'FB', 0, null, 200, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:23:15', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:23:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000239, 1000208, 30, 'Ссылка для выгрузки', 'VAL_FILE_NAME_LINK', null, null, 1, 'S', 1, null, 500, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:23:39', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000240, 1000208, 40, 'Комментарий', 'COMMENTS', null, null, 1, 'S', 0, null, 600, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:23:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000241, 1000208, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000242, 1000208, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000243, 1000208, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000244, 1000208, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000245, 1000208, 100, 'ID (not display)', 'ID_PR_CONTRAGENTS_DOCS', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:18:55', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-8, -12, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-7, -10, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-6, -10, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-5, -10, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-40, -1, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-39, -1, 6, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 450, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-38, -1, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-43, -1, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-152, -2, 44, 'Графики (Ширина)', 'CHART_X', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-151, -2, 45, 'Графики (Высота)', 'CHART_Y', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-150, -2, 46, 'Графики (Округление)', 'CHART_DEC_PREC', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-75, -10, 1, 'ID (not display)', 'ID_WB_MM_FORM_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-139, -4, 24, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-140, -4, 23, 'Кол-во элементов', 'COUNT_ELEMENT', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-141, -4, 22, 'Ширина', 'WIDTH', null, null, 3, 'I', 0, null, 60, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-97, -12, 2, 'ID (not display)', 'ID_WB_MM_FORM_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-96, -12, 3, 'Главное меню', 'ID_WB_MAIN_MENU_VIEW_TREE_USV', null, 'select ' || chr(10) || 't.id_wb_main_menu_view_tree_usv id,' || chr(10) || 't.tree_name name,' || chr(10) || 't.lev lev' || chr(10) || 'from wb_main_menu_view_tree_usv t', 1, 'SB', 0, 0, 400, 0, 0, 1, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 10:45:22', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-95, -12, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-94, -12, 7, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-93, -12, 11, 'Тип формы', 'ID_WB_FORM_TYPE', null, 'select t.id_wb_form_type id, t.human_name || '' (''|| t.name || '')'' name' || chr(10) || '          from wb_form_type t' || chr(10) || ' order by t.name nulls first', 1, 'SB', 0, 0, 400, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-92, -12, 12, 'Высота формы (%)', 'HEIGHT_RATE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-42, -2, 14, 'Автообновление формы (сек.)', 'AUTO_UPDATE', null, null, 1, 'I', 0, null, 50, null, null, 0, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-41, -10, 14, 'Автообновление формы (сек.)', 'AUTO_UPDATE', null, null, 1, 'I', 0, null, 50, null, null, 0, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-91, -12, 13, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-90, -12, 21, 'SQL блок', 'ACTION_SQL', null, null, 1, 'M', 0, 10, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-89, -12, 22, 'Схема БД', 'OWNER', null, 'select username as id, username as name ' || chr(10) || 'from sys.all_users', 1, 'SB', 0, 0, 280, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-88, -12, 23, 'Объект БД', 'OBJECT_NAME', null, null, 1, 'S', 0, null, 150, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-87, -12, 24, 'Условие в запросе', 'FORM_WHERE', null, null, 1, 'M', 0, 3, 250, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-86, -12, 31, 'Имя шаблона xls', 'XSL_FILE_IN', null, null, 1, 'S', 0, null, 220, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-85, -12, 33, 'Кнопки A,E,D', 'EDIT_BUTTON', null, 'Select ''A'' id, ''Добавление строки'' name from dual union all Select ''E'' id, ''Изменение строки'' name from dual union all Select ''D'' id, ''Удаление строки'' name from dual union all Select ''EXP'' id, ''Экспорт документа'' name from dual' || chr(10) || '', 1, 'SB', 0, 3, 220, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-84, -12, 41, 'Тип графика', 'ID_WB_CHART_TYPE', null, 'Select * from (select t.id_wb_chart_type id, t.name name from wb_chart_type t union all Select null id, null name from dual) t order by t.name nulls first', 1, 'SB', 0, null, 160, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-83, -12, 42, 'Графики (Показать подписи)', 'CHART_SHOW_NAME', null, null, 2, 'B', 0, null, 130, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-82, -12, 43, 'Графики (Повернуть подписи)', 'CHART_ROTATE_NAME', null, null, 2, 'B', 0, null, 350, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-81, -12, 44, 'Графики (Ширина)', 'CHART_X', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-80, -12, 45, 'Графики (Высота)', 'CHART_Y', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-79, -12, 46, 'Графики (Округление)', 'CHART_DEC_PREC', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-78, -12, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-77, -12, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-76, -12, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-55, -3, 1, 'ID (not display)', 'ID_WB_SETTINGS_VIEW_TREE', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-54, -3, 3, 'LEV', 'LEV', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-53, -3, 4, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 550, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-52, -3, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-51, -3, 6, 'Уникальный ключ', 'SHORT_NAME', null, null, 1, 'S', 0, 0, 400, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-50, -3, 7, 'Зачение параметра', 'VALUE', null, null, 1, 'M', 0, 4, 400, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-49, -3, 8, 'Используется', 'USED', null, null, 2, 'B', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-48, -3, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-47, -3, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-117, -7, 4, 'e-mail', 'E_MAIL', null, null, 1, 'S', 0, null, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-116, -7, 5, 'Телефон', 'PHONE', null, null, 1, 'S', 0, null, 85, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-74, -10, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-73, -10, 7, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-72, -10, 8, 'Тип формы', 'ID_WB_FORM_TYPE', null, 'select t.id_wb_form_type id, t.human_name || '' (''|| t.name || '')'' name' || chr(10) || '          from wb_form_type t' || chr(10) || ' order by t.name nulls first', 1, 'SB', 0, 0, 350, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-69, -10, 21, 'SQL блок', 'ACTION_SQL', null, null, 1, 'M', 0, 10, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-67, -10, 23, 'Объект БД', 'OBJECT_NAME', null, null, 1, 'S', 0, null, 150, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-65, -10, 31, 'Имя шаблона xls', 'XSL_FILE_IN', null, null, 1, 'S', 0, null, 220, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-64, -10, 33, 'Кнопки A,E,D', 'EDIT_BUTTON', null, 'Select ''A'' id, ''Добавление строки'' name from dual union all Select ''E'' id, ''Изменение строки'' name from dual union all Select ''D'' id, ''Удаление строки'' name from dual union all Select ''EXP'' id, ''Экспорт документа'' name from dual' || chr(10) || '', 1, 'SB', 0, 3, 350, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-57, -10, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-56, -10, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-66, -10, 24, 'Условие в запросе', 'FORM_WHERE', null, null, 1, 'M', 0, 3, 250, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-63, -10, 41, 'Тип графика', 'ID_WB_CHART_TYPE', null, 'Select * from (select t.id_wb_chart_type id, t.name name from wb_chart_type t union all Select null id, null name from dual) t order by t.name nulls first', 1, 'SB', 0, null, 160, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-70, -10, 13, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, 0, 80, 0, 0, 0, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-62, -10, 42, 'Графики (Показать подписи)', 'CHART_SHOW_NAME', null, null, 2, 'B', 0, null, 130, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-61, -10, 43, 'Графики (Повернуть подписи)', 'CHART_ROTATE_NAME', null, null, 2, 'B', 0, null, 350, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-60, -10, 44, 'Графики (Ширина)', 'CHART_X', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-59, -10, 45, 'Графики (Высота)', 'CHART_Y', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-58, -10, 46, 'Графики (Округление)', 'CHART_DEC_PREC', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-71, -10, 12, 'Высота формы (%)', 'HEIGHT_RATE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-164, -2, 11, 'Тип формы', 'ID_WB_FORM_TYPE', null, 'select t.id_wb_form_type id, t.human_name || '' (''|| t.name || '')'' name' || chr(10) || '          from wb_form_type t' || chr(10) || ' order by t.name nulls first', 1, 'SB', 0, 0, 400, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-163, -2, 12, 'Высота формы (%)', 'HEIGHT_RATE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-162, -2, 13, 'Только для чтения', 'IS_READ_ONLY', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-161, -2, 21, 'SQL блок', 'ACTION_SQL', null, null, 1, 'M', 0, 10, 400, null, null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-160, -2, 22, 'Схема БД', 'OWNER', null, 'select username as id, username as name ' || chr(10) || 'from sys.all_users', 1, 'SB', 0, 0, 280, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-159, -2, 23, 'Объект БД', 'OBJECT_NAME', null, null, 1, 'S', 0, null, 200, null, null, null, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-158, -2, 24, 'Условие в запросе', 'FORM_WHERE', null, null, 1, 'M', 0, 3, 250, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-157, -2, 31, 'Имя шаблона xls', 'XSL_FILE_IN', null, null, 1, 'S', 0, null, 220, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-156, -2, 33, 'Кнопки A,E,D', 'EDIT_BUTTON', null, 'Select ''A'' id, ''Добавление строки'' name from dual union all Select ''E'' id, ''Изменение строки'' name from dual union all Select ''D'' id, ''Удаление строки'' name from dual union all Select ''EXP'' id, ''Экспорт документа'' name from dual' || chr(10) || '', 1, 'SB', 0, 3, 400, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-155, -2, 41, 'Тип графика', 'ID_WB_CHART_TYPE', null, 'Select * from (select t.id_wb_chart_type id, t.name name from wb_chart_type t union all Select null id, null name from dual) t order by t.name nulls first', 1, 'SB', 0, null, 160, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-154, -2, 42, 'Графики (Показать подписи)', 'CHART_SHOW_NAME', null, null, 2, 'B', 0, null, 130, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-153, -2, 43, 'Графики (Повернуть подписи)', 'CHART_ROTATE_NAME', null, null, 2, 'B', 0, null, 350, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-167, -2, 2, 'Главное меню', 'ID_WB_MAIN_MENU_VIEW_TREE_USV', null, 'select ' || chr(10) || 't.id_wb_main_menu_view_tree_usv id,' || chr(10) || 't.tree_name name,' || chr(10) || 't.lev lev' || chr(10) || 'from wb_main_menu_view_tree_usv t', 1, 'SB', 0, 0, 400, 0, 0, 1, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('30-04-2013 15:43:06', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-174, -1, 1, 'ID (not display)', 'ID_WB_MAIN_MENU_VIEW_TREE_USV', null, null, 1, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-173, -1, 2, 'ID_PARENT', 'ID_PARENT', null, null, 1, 'I', 0, null, 180, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-171, -1, 10, 'Используется', 'USED', null, null, 2, 'B', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-170, -1, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-169, -1, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-168, -2, 1, 'ID (not display)', 'ID_WB_MM_FORM_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-166, -2, 5, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-165, -2, 7, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 310, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-149, -2, 93, 'Последнийредактор', 'LAST_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-148, -4, 1, 'ID (not display)', 'ID_WB_FORM_FIELD_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-142, -4, 21, 'Выравнивание', 'ID_WB_FORM_FIELD_ALIGN', null, 'select t.id_wb_form_field_align as id, t.name as name' || chr(10) || '  from wb_form_field_align t' || chr(10) || ' order by t.id_wb_form_field_align', 1, 'SB', 0, 0, 100, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-147, -4, 10, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-146, -4, 11, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 240, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-144, -4, 14, 'Текст поля', 'FIELD_TXT', null, null, 1, 'M', 0, null, 300, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-145, -4, 12, 'Поле в БД либо Переменная', 'FIELD_NAME', null, null, 1, 'S', 0, 0, 220, 0, 0, 1, null, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-138, -4, 31, 'XLS Гор.позиция', 'XLS_POSITION_COL', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000002, 1000001, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000003, 1000001, 20, 'Разрешение по горизонтали', 'HDPI', null, null, 3, 'I', 0, 0, 250, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:57:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000004, 1000001, 30, 'Разрешение по вертикали', 'WDPI', null, null, 3, 'I', 0, 0, 250, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:58:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000005, 1000001, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000006, 1000001, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000007, 1000001, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000008, 1000001, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000009, 1000001, 100, 'ID (not display)', 'ID_PR_RESOLUTION', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:56:54', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000122, 1000081, 45, 'Ширина', 'WIDTHS', null, null, 1, 'I', 0, null, 120, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('24-04-2013 20:24:55', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:32:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000162, 1000181, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:54:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:54:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000164, 1000181, 30, 'Список доступных материалов', 'MATERIAL', null, 'select pr.id_pr_material id,' || chr(10) || '       pr.name || '' ('' || decode(pr.is_list, 1, pr.material_heigth || ''x'' || pr.material_width || ''мм) '', round(pr.material_heigth / 1000, 2) || ''x'' || round(pr.material_width / 1000, 2) || ''м) '') ||' || chr(10) || '       decode(pr.think, null, '''', decode(pr.is_gloss, 1, ''глянцевый, '', ''матовый, '') || decode(pr.is_list, 1, ''листовой'', ''рулонный'') || '', '' || pr.think || ''гр'') name' || chr(10) || '  from pr_material pr' || chr(10) || '', 1, 'SB', 0, null, 400, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:54:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:05:29', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000165, 1000181, 100, 'ID (not display)', 'ID_PR_MATERIAL_VIEW', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('25-04-2013 21:54:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:54:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-176, -13, 94, 'Дата редактирования', 'LAST_DATE', null, null, 3, 'D', 0, null, 120, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:49:49', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:49:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-177, -13, 93, 'Последний редактор', 'LAST_USER', null, null, 3, 'S', 0, null, 150, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:49:52', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:49:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-178, -13, 92, 'Дата создания', 'CREATE_DATE', null, null, 3, 'D', 0, null, 120, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:49:56', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:49:56', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-179, -13, 91, 'Создатель', 'CREATE_USER', null, null, 3, 'S', 0, null, 150, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:49:59', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:49:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-180, -13, 70, 'Используется', 'USED', null, null, 3, 'B', 0, null, 50, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:01', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-181, -13, 60, 'Тип значения получаемого', 'GET_TYPE', null, 'Select id, name from wb_field_type', 3, 'SB', 0, null, 200, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:03', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:03', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-182, -13, 50, 'Тип значения сохраняемого', 'SAVE_TYPE', null, 'Select id, name from wb_field_type', 3, 'SB', 0, null, 200, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:05', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-183, -13, 40, 'Описание', 'DESCRIPTION', null, null, 3, 'S', 0, null, 300, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:07', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-184, -13, 30, 'Имя переменной', 'NAME', null, null, 3, 'S', 0, null, 300, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:09', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-185, -13, 20, '№ п.п.', 'NUM', null, null, 3, 'I', 0, null, 60, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:11', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-186, -13, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 0, null, 80, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:17', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-175, -13, 100, 'ID (not display)', 'ID_WB_PARAM_TYPE', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'U4GROUP', to_date('29-04-2013 20:50:29', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:50:29', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000022, 1000041, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000023, 1000041, 20, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 300, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:18:05', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000024, 1000041, 30, 'Коментарий', 'COMMENTS', null, null, 1, 'S', 0, 0, 300, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:18:24', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000025, 1000041, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000026, 1000041, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000027, 1000041, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000028, 1000041, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000029, 1000041, 100, 'ID (not display)', 'ID_PR_PRINTER_TYPE', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 21:17:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000082, 1000101, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000062, 1000081, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000063, 1000081, 10, 'ID_PR_PRINTER_VIEW', 'ID_PR_PRINTER_VIEW', null, null, 1, 'S', 1, 0, 200, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 20:44:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000064, 1000081, 30, 'ID_PARENT', 'ID_PARENT', null, null, 1, 'S', 0, 0, 200, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 20:40:37', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000065, 1000081, 20, 'LEV', 'LEV', null, null, 3, 'N', 1, 0, 200, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 20:44:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000066, 1000081, 40, 'Наименование, категория', 'NAME', null, null, 1, 'S', 0, null, 550, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 11:00:45', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000067, 1000081, 50, 'Комментарий', 'COMMENTS', null, null, 2, 'S', 0, 0, 250, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:16:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000068, 1000081, 60, 'Расположение', 'LOCATION', null, null, 2, 'S', 0, 0, 350, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:09:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:15:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000083, 1000101, 20, 'Категория', 'NAME', null, null, 1, 'S', 0, 0, 350, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:36:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000084, 1000101, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000085, 1000101, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000086, 1000101, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000087, 1000101, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000088, 1000101, 100, 'ID (not display)', 'ID_PR_MATERIAL_TYPE', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:35:53', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000102, 1000121, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000103, 1000121, 20, 'Категория', 'ID_PR_MATERIAL_TYPE', null, 'select ' || chr(10) || '  t.id_pr_material_type id,' || chr(10) || '  t.name name' || chr(10) || 'from pr_material_type t', 1, 'SB', 0, 0, 220, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:53:02', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000104, 1000121, 30, 'Длина материала (мм)', 'MATERIAL_WIDTH', null, null, 3, 'I', 0, 0, 100, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:49:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000105, 1000121, 40, 'Ширина материала (мм)', 'MATERIAL_HEIGTH', null, null, 3, 'I', 0, 0, 100, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:49:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000106, 1000121, 50, 'Листовой/Поштучный', 'IS_LIST', null, null, 2, 'B', 0, null, 90, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:07:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000107, 1000121, 60, 'Глянцевый', 'IS_GLOSS', null, null, 2, 'B', 0, 0, 60, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:52:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000108, 1000121, 25, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 450, 0, 0, 1, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:52:48', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000109, 1000121, 80, 'Толщина (гр)', 'THINK', null, null, 3, 'I', 0, 0, 80, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:49:47', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000110, 1000121, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000111, 1000121, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000112, 1000121, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000113, 1000121, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000114, 1000121, 100, 'ID (not display)', 'ID_PR_MATERIAL', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000115, 1000121, 130, 'Остаток (м.кв/шт)', 'VALUE', null, null, 3, 'N', 0, 0, 200, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:43:32', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:50:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000142, 1000141, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('24-04-2013 22:13:28', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 22:13:28', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000144, 1000141, 30, 'Разрешение доступные аппарату', 'DPI', null, 'select id_pr_resolution id,' || chr(10) || '       hdpi || ''x'' || wdpi || ''dpi'' as name' || chr(10) || 'from pr_resolution', 1, 'SB', 0, 0, 400, 0, 0, 0, 0, 'ANDREY.LYSIKOV', to_date('24-04-2013 22:13:28', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-04-2013 21:10:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000145, 1000141, 100, 'ID (not display)', 'ID_PR_RESOLUTION_VIEW', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('24-04-2013 22:13:28', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('24-04-2013 22:13:28', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-137, -4, 32, 'XLS Верт.позиция', 'XLS_POSITION_ROW', null, null, 3, 'I', 0, null, 90, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-136, -4, 33, 'Обязательное поле', 'IS_REQURED', null, null, 2, 'B', 0, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-143, -4, 15, 'Тип поля', 'FIELD_TYPE', null, 'Select upper(trim(id)) id, name from wb_field_type', 1, 'SB', 0, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-135, -5, 1, 'ID (not display)', 'ID_WB_FORM_FIELD_ALIGN', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-134, -5, 2, 'Наименование', 'NAME', null, null, 1, 'S', 0, 0, 420, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-133, -5, 3, 'Комментарий', 'HTML_TXT', null, null, 1, 'S', 0, null, 110, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-132, -5, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, 0, 150, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-131, -5, 94, 'Датаредактирования', 'LAST_DATE', null, null, 1, 'D', 1, 0, 120, 0, 0, 0, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-130, -6, 1, 'ID (not display)', 'ID_WB_FORM_CELLS_VIEW', null, null, 3, 'I', 1, null, 80, null, null, null, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-129, -6, 3, '№ п.п.', 'NUM', null, null, 3, 'I', 0, 0, 30, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (-128, -6, 10, 'Текст', 'NAME', null, null, 1, 'S', 0, 0, 150, 0, 0, 1, 0, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000262, 1000221, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000263, 1000221, 20, 'Наименование', 'NAME', null, null, 1, 'S', 0, null, 300, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:51:58', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000264, 1000221, 30, 'Договор', 'DOGOVOR', null, null, 1, 'S', 0, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:52:09', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000265, 1000221, 40, 'Руководитель', 'DIRECTOR', null, null, 1, 'S', 0, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:52:22', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000266, 1000221, 50, 'Ответсвенное лицо', 'OTVETST', null, null, 1, 'S', 0, null, 200, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:52:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000267, 1000221, 60, 'Почта', 'EMAIL', null, null, 1, 'S', 0, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:52:59', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000268, 1000221, 70, 'Телефон', 'PHONE', null, null, 1, 'S', 0, null, 200, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:53:04', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000269, 1000221, 80, 'Дата подписания договора', 'DATE_START', null, null, 1, 'D', 0, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:53:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000270, 1000221, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000271, 1000221, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000272, 1000221, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000273, 1000221, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000274, 1000221, 100, 'ID (not display)', 'ID_PR_CLIENTS_VIEW', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:48:30', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000276, 1000222, 0, '# п/п (not display)', 'R_NUM', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000278, 1000222, 30, 'Документ', 'VAL_FILE_NAME_LINK', null, null, 1, 'S', 1, null, 200, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:05:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000279, 1000222, 40, 'Комментарий, описание', 'COMMENTS', null, null, 1, 'S', 0, null, 600, null, null, 1, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000280, 1000222, 91, 'Создатель', 'CREATE_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000281, 1000222, 92, 'Дата создания', 'CREATE_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000282, 1000222, 93, 'Последний редактор', 'LAST_USER', null, null, 1, 'S', 1, null, 150, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000283, 1000222, 94, 'Дата редактирования', 'LAST_DATE', null, null, 1, 'D', 1, null, 120, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000284, 1000222, 100, 'ID (not display)', 'ID_PR_CLIENTS_W_DOCS', null, null, 3, 'I', 1, null, 80, null, null, 0, 0, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:01:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000247, 1000206, 60, 'Заказ', 'ID_ZAKAZ', null, null, 1, 'I', 1, null, 120, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('26-07-2013 11:57:25', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('26-07-2013 11:57:25', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000275, 1000221, 10, 'Тип', 'ID_PR_CLIENTS_TYPE', null, 'select ct.id_pr_clients_type as id,' || chr(10) || '       ct.name               as name' || chr(10) || '  from pr_clients_type ct' || chr(10) || ' where ct.id_pr_clients_type != 1 order by id desc' || chr(10) || '', 1, 'SB', 0, null, 150, null, null, 0, null, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:51:36', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:54:06', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_FORM_FIELD (id_wb_form_field, id_wb_mm_form, num, name, field_name, array_name, field_txt, id_wb_form_field_align, field_type, is_read_only, count_element, width, xls_position_col, xls_position_row, is_requred, fl_html_code, create_user, create_date, last_user, last_date)
values (1000285, 1000223, 10, 'Документы', 'FILE_NAME', null, null, 1, 'FB', 0, null, 100, null, null, 1, null, 'ANDREY.LYSIKOV', to_date('20-08-2013 10:04:59', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 10:05:20', 'dd-mm-yyyy hh24:mi:ss'));
prompt 315 records loaded
prompt Loading WB_MM_ROLE...
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (44, 1000046, 31, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:32:58', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:32:58', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (45, 1000047, 31, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:33:13', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:33:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (62, 1000062, 43, 1, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:45:46', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:45:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (43, 1000043, 23, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:28:40', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:28:40', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (2, 1000006, 3, 1, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:11', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:11', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (3, 1000005, 3, 1, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:16', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:16', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (4, 1000004, 3, 1, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:23', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-1, -3, 1, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-2, -4, 1, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-3, -5, 1, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-4, -7, 1, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-5, -8, 2, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-6, -9, 2, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-7, -6, 1, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (22, 1000022, 3, 1, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:33:41', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:33:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (23, 1000023, 3, 1, 'ANDREY.LYSIKOV', to_date('22-04-2013 22:33:51', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 22:33:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (-8, -10, 1, 1, 'U4GROUP', to_date('29-04-2013 20:39:26', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('29-04-2013 20:39:26', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (46, 1000049, 3, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:42:22', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:42:22', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_MM_ROLE (id_wb_mm_role, id_wb_main_menu, id_wb_role, id_wb_access_type, create_user, create_date, last_user, last_date)
values (42, 1000042, 3, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 10:37:46', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 10:37:46', 'dd-mm-yyyy hh24:mi:ss'));
prompt 19 records loaded
prompt Loading WB_PARAM_TYPE...
prompt Table is empty
prompt Loading WB_PARAM_VALUE...
prompt Table is empty
prompt Loading WB_ROLE_USER...
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (24, 31, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 16:33:29', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 16:33:29', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (43, 43, 1, 'ANDREY.LYSIKOV', to_date('20-08-2013 09:46:25', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('20-08-2013 09:46:25', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (23, 23, 1, 'ANDREY.LYSIKOV', to_date('25-07-2013 15:28:52', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('25-07-2013 15:28:52', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (3, 3, 1, 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:44', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 17:55:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (1, 1, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_ROLE_USER (id_wb_role_user, id_wb_role, id_wb_user, create_user, create_date, last_user, last_date)
values (2, 2, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
prompt 6 records loaded
prompt Loading WB_SETTINGS...
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (16, null, 200, 'Системные', 'SETTINGS', null, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (15, 14, 2, 'Адрес администратора', 'RECIPIENT_ADMIN', null, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (14, null, 100, 'Настройки сервера SMTP', 'SETTINGS_MAIL_SMTP', null, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (13, 14, 1, 'Сервер', 'SETTINGS_MAIL_SMTP_HOST', 'servername.com', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (12, 14, 3, 'Отправитель', 'SETTINGS_MAIL_SMTP_SENDER', 'admin@servername.com', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (11, 14, 4, 'CHARSET', 'SETTINGS_MAIL_SMTP_CHARSET', 'text/plain; charset=koi8-r', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (10, 14, 5, 'ENCODING', 'SETTINGS_MAIL_SMTP_ENCODING', '8bit', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (9, 14, 6, 'Авторизация: Пользователь', 'SETTINGS_MAIL_SMTP_AUTHLOGIN', 'user_for_server', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (8, 14, 7, 'Авторизация: Пароль', 'SETTINGS_MAIL_SMTP_AUTHPWD', null, 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (7, 14, 8, 'Кодировка для конветртации текста', 'SETTINGS_MAIL_SMTP_DESTCSET', 'CL8KOI8R', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (5, 16, 1, 'Служебные поля которые необходимо скрывать', 'SETTINGS_VIEW_INVISIBLE_SYS_FIELDS', 'R_NUM,ID_PARENT,LEV', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (4, 16, 3, 'Поля аудита которые необходимо скрывать', 'SETTINGS_VIEW_INVISIBLE_AUDIT_FIELDS', 'CREATE_USER,CREATE_DATE,LAST_USER,LAST_DATE,DELETE_USER,DELETE_DATE', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (3, 16, 2, 'Скрывать идентификатор записей в таблицах', 'SETTINGS_VIEW_INVISIBL_ID_TABLE', '1', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (2, null, 1, 'Версия конфигурации', 'ROOT_CONFIG_VERSION', '1.0', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 16:42:44', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (1, null, 0, 'Наименование конфигурации', 'ROOT_CONFIG_NAME', 'U4GROUP Контроль заказов печати', 1, 'LOADER', to_date('22-04-2013 16:39:49', 'dd-mm-yyyy hh24:mi:ss'), 'ANDREY.LYSIKOV', to_date('22-04-2013 16:43:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (37, null, 3, 'Иконка конфигурации', 'ROOT_CONFIG_FAVICON', 'sport_icon.ico', 1, 'U4GROUP', to_date('23-04-2013 08:49:00', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('23-04-2013 08:53:39', 'dd-mm-yyyy hh24:mi:ss'));
insert into WB_SETTINGS (id_wb_settings, id_parent, num, name, short_name, value, used, create_user, create_date, last_user, last_date)
values (17, null, 2, 'Изображение конфигурации', 'ROOT_CONFIG_LOGO', 'sport_logo.png', 1, 'U4GROUP', to_date('22-04-2013 16:51:28', 'dd-mm-yyyy hh24:mi:ss'), 'U4GROUP', to_date('22-04-2013 16:51:28', 'dd-mm-yyyy hh24:mi:ss'));
prompt 17 records loaded
prompt Enabling foreign key constraints for PR_CLIENTS...
alter table PR_CLIENTS enable constraint ID_PR_CLIENTS_TYPE;
prompt Enabling foreign key constraints for PR_MATERIAL...
alter table PR_MATERIAL enable constraint PK_MATERIAL_TYPE;
prompt Enabling foreign key constraints for PR_MATERIAL_DYN...
alter table PR_MATERIAL_DYN enable constraint PK_PR_CLIENT;
alter table PR_MATERIAL_DYN enable constraint PK_PR_MATERIAL;
prompt Enabling foreign key constraints for PR_PRINTER...
alter table PR_PRINTER enable constraint PK_PR_PR_TYPE;
prompt Enabling foreign key constraints for PR_PRID_MT...
alter table PR_PRID_MT enable constraint PK_ID_MAT;
alter table PR_PRID_MT enable constraint PK_ID_PR;
prompt Enabling foreign key constraints for PR_PRID_PRES...
alter table PR_PRID_PRES enable constraint PK_PR_PRINTER_KEY;
alter table PR_PRID_PRES enable constraint PK_PR_RESOLUTION_KEY;
prompt Enabling foreign key constraints for PR_TYPE_LINK_JOB...
alter table PR_TYPE_LINK_JOB enable constraint PK_ID_PR_PRINTER_TYPE;
alter table PR_TYPE_LINK_JOB enable constraint PK_ID_WB_ROLE;
alter table PR_TYPE_LINK_JOB enable constraint PK_ID_WB_USER;
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
prompt Enabling triggers for PR_CLIENTS_TYPE...
alter table PR_CLIENTS_TYPE enable all triggers;
prompt Enabling triggers for PR_CLIENTS...
alter table PR_CLIENTS enable all triggers;
prompt Enabling triggers for PR_MATERIAL_TYPE...
alter table PR_MATERIAL_TYPE enable all triggers;
prompt Enabling triggers for PR_MATERIAL...
alter table PR_MATERIAL enable all triggers;
prompt Enabling triggers for PR_MATERIAL_DYN...
alter table PR_MATERIAL_DYN enable all triggers;
prompt Enabling triggers for PR_PRINTER_TYPE...
alter table PR_PRINTER_TYPE enable all triggers;
prompt Enabling triggers for PR_PRINTER...
alter table PR_PRINTER enable all triggers;
prompt Enabling triggers for PR_PRID_MT...
alter table PR_PRID_MT enable all triggers;
prompt Enabling triggers for PR_RESOLUTION...
alter table PR_RESOLUTION enable all triggers;
prompt Enabling triggers for PR_PRID_PRES...
alter table PR_PRID_PRES enable all triggers;
prompt Enabling triggers for WB_ROLE...
alter table WB_ROLE enable all triggers;
prompt Enabling triggers for WB_USER...
alter table WB_USER enable all triggers;
prompt Enabling triggers for PR_TYPE_LINK_JOB...
alter table PR_TYPE_LINK_JOB enable all triggers;
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
prompt Enabling triggers for WB_MM_ROLE...
alter table WB_MM_ROLE enable all triggers;
prompt Enabling triggers for WB_PARAM_TYPE...
alter table WB_PARAM_TYPE enable all triggers;
prompt Enabling triggers for WB_PARAM_VALUE...
alter table WB_PARAM_VALUE enable all triggers;
prompt Enabling triggers for WB_ROLE_USER...
alter table WB_ROLE_USER enable all triggers;
prompt Enabling triggers for WB_SETTINGS...
alter table WB_SETTINGS enable all triggers;
set feedback on
set define on
prompt Done.