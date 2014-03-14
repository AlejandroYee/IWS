/*
Файл обновления БД с версии 2.1.0 до версии 2.1.1
*/
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR DISABLE;
update WB_SETTINGS w set w.value = '2.1.1' where w.short_name = 'ROOT_DB_VERSION';
update wb_form_field t set t.element_alt = 'Тип столбца данных, в случае если это список то необходимо заполнить поле SQL Блок/Текст поля для того чтобы получить данны для списка. Принимаемые значения: id, name, а также lev в случае построения списка с уровнем'
where t.id_wb_form_field < 0 and t.field_name = 'FIELD_TYPE';
update wb_form_field t set t.field_txt = 'select to_char(' || t.field_txt || ', ''dd.mm.yyyy'') def_date from dual' where t.field_txt like 'nvl%' or t.field_txt like 'sysdate%';
ALTER TRIGGER T_B_U_WB_FORM_FIELD_ERR ENABLE;
commit;