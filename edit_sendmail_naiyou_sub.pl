#--------------------------------------
#�᡼����������ݥ᡼����������
#&edit_sendmail_naiyou()
#	����:
#		�ե�����:(���Ϥȶ��̤�����)	��ά
#	����:
#		@kokyaku_data		�ĸܵҥǡ���:��
#		�ե�����:
#			sendmail_sw		�ĥ᡼������������ɤ��������������椫��
sub edit_sendmail_naiyou {
	$form{'sendmail_sw'}=2;
	
	#�ܵҥǡ������ɤ߼��
	if($#kokyaku_data==-1) {
		@kokyaku_data=&file_access("<$file_kokyaku",7);
	}
}
1;
