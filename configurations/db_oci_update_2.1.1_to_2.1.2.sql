/*
���� ���������� �� � ������ 2.1.1 �� ������ 2.1.2
*/
update WB_SETTINGS w set w.value = '2.1.2' where w.short_name = 'ROOT_DB_VERSION';
commit;