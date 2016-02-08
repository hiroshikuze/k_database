#--------------------------------------
#管理者専用設定の確認表示準備
#&master_check_edit()
#	入力:
#		@config	…設定データ群
#			[0]…解説文（本編では使用しない）
#			[1]…現在登録されているパスワード
#			[2]…起動時などに表示される最近登録された件数
#			[3]…最新順などに表示される管理者からのお知らせ
#		$form{''}
#			出力とダブるので略
#	出力:
#		@config	…設定データ群
#			[0]…解説文（本編では使用しない）
#			[1]…現在登録されているパスワード
#			[2]…起動時などに表示される最近登録された件数
#			[3]…最新順などに表示される管理者からのお知らせ
#		$form{''}
#			change_info…	変更指定:管理者からのお知らせ
sub master_check_edit {
	
	#管理者からのお知らせをHTML形式で表示可能な状態にする
	$config[3]=$form{'change_info'};
	chomp($config[3]);
	$config[3]=~ s/\r\n/<br>/g;
	$config[3]=~ s/\r//g;
	$config[3]=~ s/\n/<br>/g;
	$config[3]=~ s/"/\"/g;
	chomp($form{'change_info'});
	$form{'change_info'}=~ s/\r\n/\n/g;
	$form{'change_info'}=~ s/\r//g;
}
1;
