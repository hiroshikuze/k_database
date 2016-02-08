#--------------------------------------
#ページの出力−管理者機能のスイッチON/OFFについて
#&html_kanrimode_switch()
#	入力:
#		$kanrimode_sw	…管理者:モードのOFF/ON
#	出力:
#		$output_html	…HTML追加出力用
sub html_kanrimode_switch {
	
	if($kanrimode_sw==0) {
		$output_html=$output_html."	<b>管理者モードを OFF にしました。</b><br>\n";
	} elsif($kanrimode_sw==1) {
		$output_html=$output_html."	<b>管理者モードを ON にしました。</b><br>\n";
	} elsif($kanrimode_sw==2) {
		$output_html=$output_html."	<font color=red><b>パスワードエラー</b></font><br>\n";
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	管理者用パスワードが登録のものと一致しません。<br>\n";
		$output_html=$output_html."	ご確認ください。<br>\n";
	} elsif($kanrimode_sw==3) {
		$output_html=$output_html."	<font color=red><b>不正アクセス</b></font><br>\n";
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	管理者用モードへの侵入は管理者パスワード入力からでお願いします。<br>\n";
	}
}
1;
