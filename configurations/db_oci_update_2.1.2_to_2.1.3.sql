/*
Файл обновления БД с версии 2.1.3 до версии 2.1.3
*/
update WB_SETTINGS w set w.value = '2.1.3' where w.short_name = 'ROOT_DB_VERSION';
commit;