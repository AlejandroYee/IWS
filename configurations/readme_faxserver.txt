�������� ������ �� ������ ���������
������ 1 �� 21.03.2014�.

1. ��������� ���������� 
 �) linux ������ �� ������ ����� �������������� �������
 �) ����������� ����� ��� ������ �������, ���������� ������������ pop � smtp ������� �� ������������ ������� (25 � 110)

 
2. ���������:
 �) ��������� ���������� asterisk �� ���� ������ � ����� � ���� ����� ������������ spandsp (�������� ����������).
 �) ���������� ������� IWS ������ �� ����� ������������ (�������������� ������ ������ ����� ������ oci_db), � ����� ������������ faxserver_db_oci_conf.sql
	����������� ������ �� ������� �� ���� 2.1.0 (���� ���� ���������� �� �� ����� ��������� IWS ����� �������� ���� ������������)
 �) ���������� Libreoffice � libreoffice-headless ��� ��������� �������� ����� ��������
 �) ���������� � /usr/bin ���� unoconv �� �����������: https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv, ���� ��� ����� �� ����������.
 �) ��������� ���� console_fax.php � ������ ������� IWS, ���� ��� ����� �� ���������� � ��������� ���������� ������ ����� �������� ������������.
 �) ��������� �������� ������ ������ � ����������, � ����� ������ ���� ���� �� �������:
 
		  ; ���� ��������� ������� ISW: /var/www/html/
		 [fax_rx] ; �������� ����
			exten => _X.,1,Answer()
			 same => n,set(PICT=/tmp/${CALLERID(number)}_${STRFTIME(${EPOCH},,%Y%m%d_%H%M%S)}.tif)
			 same => n,set(NUMB=${EXTEN})
			 same => n,System(/var/www/html/console_fax.php --number=${EXTEN} --from=${CALLERID(number)} --status=INCOMING  --file="${PICT}")
			 same => n,ReceiveFax(${PICT})
			 same => n,set(FAX_ERR=${FAXERROR})
			 same => n,HangUp()
			exten => h,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${CALLERID(number)} --status=RESIVED --error="${FAX_ERR}" --file="${PICT}")
			exten => g,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${CALLERID(number)} --status=RESIVED --error="${FAX_ERR}" --file="${PICT}")
		 
		 [fax_out] ; ��������� ����
			exten => _X.,1,Answer()
			 same => n,set(NUMB=${EXTEN})
			 same => n,SendFAX(${PICTURE})
			 same => n,set(FAX_ERR=${FAXERROR})
			 same => n,Hangup()
			exten => h,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${TEL_NUMB} --status=SEND --error="${FAX_ERR}" --file=${PICTURE})
			exten => g,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${TEL_NUMB} --status=SEND --error="${FAX_ERR}" --file=${PICTURE})
			
 �) ������������ � ������� IWS, � ������� �������� ������ � ������������� �������� ����� admin_settings.doc, � ����� ������� ��������� ����������� � pop ������� � "���������� ����������"
 