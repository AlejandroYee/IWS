/* ������� ������ ������������ ��� �������: */
create user USER_NAME  identified by "password"  default tablespace USER_NAME;

/* ���������� ��� ���������� ������ ������� ������ �����: */
grant CREATE JOB, CREATE SESSION , CREATE TRIGGER ,CREATE PROCEDURE ,CREATE SEQUENCE,
	  CREATE SYNONYM, CREATE VIEW, CREATE TABLE, CREATE TYPE, CREATE materialized view,
	  execute on UTL_TCP ,execute on UTL_SMTP, execute on UTL_FILE�to USER_NAME;
