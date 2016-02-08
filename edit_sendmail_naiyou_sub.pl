#--------------------------------------
#メール一斉送信−メール内容入力
#&edit_sendmail_naiyou()
#	入力:
#		フォーム:(出力と共通するもの)	…略
#	出力:
#		@kokyaku_data		…顧客データ:生
#		フォーム:
#			sendmail_sw		…メール一斉送信：どこに送ろうか選択中か？
sub edit_sendmail_naiyou {
	$form{'sendmail_sw'}=2;
	
	#顧客データの読み取り
	if($#kokyaku_data==-1) {
		@kokyaku_data=&file_access("<$file_kokyaku",7);
	}
}
1;
