#--------------------------------------
#ページの出力−管理者専用設定変更確認
#&html_check_system($before_kanrimode_sw,$next_kanrimode_sw)
#	入力:
#		$before_kanrimode_sw	…(括弧内へ入力)管理者専用設定初期のページへ戻るよう次回実行時に伝える
#		$file_main				…メインルーチンを示したファイル名
#		$html_sw				…表示内容の切り替え
#		$next_kanrimode_sw		…(括弧内へ入力)管理者専用設定変更するよう次回実行時に伝える
#		フォーム:				…出力とダブるので省略
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:	change_info			…変更指定:管理者からのお知らせ
#		フォーム:	change_rireki_kazu	…変更指定:対応履歴の保存件数
#		フォーム:	change_pass			…変更指定:パスワード
#		フォーム:	change_view			…変更指定:表示する最新入力件数
#		フォーム:	html_sw				…呼び出された(す)各機能
#		フォーム:	kanrimode_check		…管理者モード:セキュリティー用パスワード
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word	…検索：前回検索したキーワード
sub html_check_system {
	
	local($before_html_sw,$next_html_sw)=@_;
	
	$output_html=$output_html."	<b>以下のように変更します。よろしいですか？</b><br>\n";
	$output_html=$output_html."	<br>\n";
	$output_html=$output_html."	<form action=$file_main method=post>\n";
	$output_html=$output_html."	<b>管理者からのお知らせ:</b><br>\n";
	if(length($form{'change_info'})>0) {
		$output_html=$output_html."	  <table border><tr><td align=left>$config[3]</td></tr></table><input type=hidden name=change_info value='".$form{'change_info'}."'><br>\n";
	} else {
		$output_html=$output_html."	  特になし<br>\n";
	}
	$output_html=$output_html."	<b>最初に\表\示する最新入力件数:</b>$form{'change_view'}<input type=hidden name=change_view value=$form{'change_view'}><br>\n";
	$output_html=$output_html."	<b>対応履歴の保存件数:</b>$form{'change_rireki_kazu'}<input type=hidden name=change_rireki_kazu value=$form{'change_rireki_kazu'}><br>\n";
	$output_html=$output_html."	<b>パスワード変更:</b>$form{'change_pass'}<input type=hidden name=change_pass value=$form{'change_pass'}><br>\n";
	
	$output_html=$output_html."	\n";
	$output_html=$output_html."	<table><tr>\n";
	$output_html=$output_html."	  <td>\n";
	$output_html=$output_html."		<input type=hidden name=html_sw value=$next_html_sw>\n";
	$output_html=$output_html."		<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_houhou value=$search_houhou>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_word value=$search_keyword>\n";
	$output_html=$output_html."		<input type=submit value=' 　設定を変更する　 '>\n";
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	  <td><form action=$file_main method=post>\n";
	$output_html=$output_html."		<input type=hidden name=html_sw value=$before_html_sw>\n";
	$output_html=$output_html."		<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_houhou value=$search_houhou>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_word value=$search_keyword>\n";
	$output_html=$output_html."		<input type=submit value=' もう一度入力しなおす '>\n";
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	</tr></table>\n";
}
1;
