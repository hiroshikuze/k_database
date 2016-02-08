#--------------------------------------
#管理者モードのスイッチON/OFFについて
#&master_switch()
#	入力:
#		@config					…設定データ群
#		$kanrimode_passwordkari	…管理者:セキュリティー用パスワード受け渡し用仮
#		$kanrimode_sw			…管理者:モードのOFF/ON
#		$form{'kanrimode_pass'}	…管理者モード侵入へ入力されたパスワード
#		$form{'sendmail_sw'}	…メール一斉送信：どこへ送ろうか選択中か？
#	出力:
#		$kanrimode_password	…管理者:セキュリティー用パスワード受け渡し用
#		$kanrimode_sw		…管理者:モードのOFF/ON
sub master_switch {
	local($record_koumoku)="管理者モードのスイッチON/OFF";	#捜査履歴:記録する項目の定義
	require'save_kanri_rireki_lib.pl';
	
	$form{'sendmail_sw'}=0;
	if($kanrimode_sw==0) {
		#スイッチOFF→ON
		
			#パスワードチェック
		chomp($form{'kanrimode_pass'});
		chomp($config[1]);
		$config[1]=~ s/\r//g;
		
		if($form{'kanrimode_pass'} eq $config[1]) {
			$kanrimode_sw=1;
			$kanrimode_password=$kanrimode_passwordkari;
		
			#記録
			&save_kanri_rireki($record_koumoku,"管理者モードへのスイッチが ON になりました。");
		} else {
			$kanrimode_sw=2;
		
			#記録
			&save_kanri_rireki($record_koumoku,"管理者モードへの進入が試みられましたが、パスワードエラーで返されました。");
		}
	} elsif($kanrimode_sw==1) {
		#スイッチON→OFF
		$kanrimode_sw=0;
		$kanrimode_password="";
		
			#記録
		&save_kanri_rireki($record_koumoku,"管理者モードへのスイッチが OFF になりました。");
	}
	
}
1;
