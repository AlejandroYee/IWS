Почтовый сервер на основе астериска
версия 1 от 21.03.2014г.

1. Системные требования 
 а) linux сервер на основе любой предпочитаемой системы
 б) электронный адрес для работы системы, необходимо использовать pop и smtp сервера со стандартными портами (25 и 110)

 
2. Установка:
 а) Неоходимо установить asterisk на вашу машину а также к нему нужно доустановить spandsp (факсовое приложение).
 б) Установить систему IWS исходя из вашей конфигурации (поддерживатеся работа только через модуль oci_db), а также конфигурацию faxserver_db_oci_conf.sql
	минимальная версия БД системы не ниже 2.1.0 (если есть обновления бд то после установки IWS Нужно обновить вашу конфигурацию)
 в) Установить Libreoffice и libreoffice-headless для поддержки большого числа форматов
 г) Установить в /usr/bin файл unoconv из репозитария: https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv, дать ему права на выполнение.
 д) Поместить файл console_fax.php в корень системы IWS, дать ему права на выполнение и настроить переменные внутри файла согласно комментариям.
 е) Настроить астериск указав каналы и экстеншены, а также создав диал план по примеру:
 
		  ; путь установки системы ISW: /var/www/html/
		 [fax_rx] ; Входящий факс
			exten => _X.,1,Answer()
			 same => n,set(PICT=/tmp/${CALLERID(number)}_${STRFTIME(${EPOCH},,%Y%m%d_%H%M%S)}.tif)
			 same => n,set(NUMB=${EXTEN})
			 same => n,System(/var/www/html/console_fax.php --number=${EXTEN} --from=${CALLERID(number)} --status=INCOMING  --file="${PICT}")
			 same => n,ReceiveFax(${PICT})
			 same => n,set(FAX_ERR=${FAXERROR})
			 same => n,HangUp()
			exten => h,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${CALLERID(number)} --status=RESIVED --error="${FAX_ERR}" --file="${PICT}")
			exten => g,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${CALLERID(number)} --status=RESIVED --error="${FAX_ERR}" --file="${PICT}")
		 
		 [fax_out] ; Исходящий факс
			exten => _X.,1,Answer()
			 same => n,set(NUMB=${EXTEN})
			 same => n,SendFAX(${PICTURE})
			 same => n,set(FAX_ERR=${FAXERROR})
			 same => n,Hangup()
			exten => h,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${TEL_NUMB} --status=SEND --error="${FAX_ERR}" --file=${PICTURE})
			exten => g,1,System(/var/www/html/console_fax.php --number=${NUMB} --from=${TEL_NUMB} --status=SEND --error="${FAX_ERR}" --file=${PICTURE})
			
 ж) Залогиниться в систему IWS, и создать описание факсов и пользователей согласно файлу admin_settings.doc, а также указать параметры подключения к pop серверу в "глобальных переменных"
 