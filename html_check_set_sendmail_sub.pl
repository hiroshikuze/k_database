#--------------------------------------
#ページの出力−一斉メール送信設定変更
#&html_check_set_sendmail($before_html_sw,$next_html_sw)
#	入力:
#		$before_kanrimode_sw	…(括弧内へ入力)管理者専用設定初期のページへ戻るよう次回実行時に伝える
#		$file_main				…メインルーチンを示したファイル名
#		$next_kanrimode_sw		…(括弧内へ入力)管理者専用設定変更するよう次回実行時に伝える
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:	change_cut_mailissei_rireki
#										…変更指定:一部操作履歴と一斉メール送信履歴で以下省略する改行の数
#		フォーム:	change_view_mailissei_rireki
#										…変更指定:一斉メール送信履歴のここで表示する件数
#		フォーム:	html_sw				…呼び出された(す)各機能
#		フォーム:	kanrimode_check		…管理者モード:セキュリティー用パスワード
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word	…検索：前回検索したキーワード
sub html_check_set_sendmail {
	
	local($before_html_sw,$next_html_sw)=@_;
	
	$output_html=$output_html."	<b>以下のように変更します。よろしいですか？</b><br>\n";
	$output_html=$output_html."	<br>\n";
	$output_html=$output_html."	<form action=$file_main method=post>\n";
	$output_html=$output_html."	<b>一斉メール送信履歴のここで\表\示する件数:</b>$form{'change_view_mailissei_rireki'}<input type=hidden name=change_view_mailissei_rireki value=$form{'change_view_mailissei_rireki'}><br>\n";
	$output_html=$output_html."	<b>一部操作履歴と一斉メール送信履歴で以下省略する改行の数:</b>$form{'change_cut_mailissei_rireki'}<input type=hidden name=change_cut_mailissei_rireki value=$form{'change_cut_mailissei_rireki'}><br>\n";
	
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
