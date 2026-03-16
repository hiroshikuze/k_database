#--------------------------------------
#メール一斉送信−メール内容入力
#&html_mail_naiyou()
#	入力:
#		@addlink				…フォームの各値引渡値
#									[0]…アンカーによる値引渡し
#									[1]…フォームによる値引渡し
#									[2]…フォームによる値引渡し(改行除去)
#		$html_sw				…表示内容の切り替え
#		$file_main				…このメインシステムファイル名
#		$output_html			…HTML追加出力用
#		$sendmail_kazu			…メール一斉送信:送信する相手先の数
#		フォーム:				(入力とダブるので省略)
#	出力:
#		$output_html				…(入力で書いたので略)
#		フォーム:
#			数字					…メール一斉送信:送信する顧客先(ID)
#			backpage				…機能終了後戻る各機能
#			html_sw					…呼び出された(す)各機能
#			firstview_page			…最新順:何ページ目を見ているか
#			sendmail_honbun			…メール一斉送信:送信する本文
#			sendmail_title			…メール一斉送信：送信するメールのタイトル
sub html_mail_naiyou() {
	#サブルーチン群ロード
	require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする
	
	#フォームの各値引渡値修正
	$addlink[0]=~ s/&sendmail_sw=2/&sendmail_sw=1/g;
	$addlink[1]=~ s/name=sendmail_sw value=2/name=sendmail_sw value=1/;
	$addlink[2]=~ s/name=sendmail_sw value=2/name=sendmail_sw value=1/;
	
	#一斉メール送信:メール内容入力
	$output_html=$output_html."	<br><table border><tr><td align=center bgcolor=#ff8888 width=80%>\n";
	$output_html=$output_html."	<b>一斉メール送信</b> : メール内容入力<br>\n";
	if($sendmail_kazu>0) {
		$output_html=$output_html."	送信先に送るメール内容を入力してください。\n";
	}
	$output_html=$output_html."	</td></tr></table><br>\n";
	
	#本体メッセージを表示
	if($sendmail_kazu>0) {
		local($i);	#ループ用
		
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<table>\n";
		#送信先アドレスの表示
		$output_html=$output_html."<tr><td align=left><b>送信先:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		for($i=$#kokyaku_data;$i>0;$i--) {
			&tab_cut($kokyaku_data[$i]);
			if($form{substr($cut_end[0],0,11)}==1) {
				if(length($cut_end[16])>3) {
					$output_html=$output_html."　・ <b><a href=$file_main.$addlink[0].'&html_sw=2&call_no=$cut_end[0]'>$cut_end[2]</a></b> / <a href='mailto:$cut_end[16]'>$cut_end[16]</a><br>\n";
				} else {
					$output_html=$output_html."　・ <b><s><a href=$file_main.$addlink[0].'&html_sw=2&call_no=$cut_end[0]'>$cut_end[2]</a></s></b> / メールアドレス未指定により無効<br>\n";
				}
			}
		}
		$output_html=$output_html."</td></tr>\n";
		
		#タイトル入力フォーム
		$output_html=$output_html."<tr><td align=left><b>送信するメールのタイトル:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>　　<input type=text name=sendmail_title size=90></td></tr>\n";
		
		#内容入力フォーム
		$output_html=$output_html."<tr><td><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left><b>送信するメールの本文:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		$output_html=$output_html."<textarea name=sendmail_honbun cols=64 rows=20 warp=soft></textarea>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=15>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."<tr><td align=center>\n";
		$output_html=$output_html."<input type=submit value=' この内容で送信する '>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."</table>\n";
		$output_html=$output_html."</form>\n";
	} else {
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."\n";
		$output_html=$output_html."<font color=red><b>送信先アドレスが指定されていません。</b></font><br>\n";
		$output_html=$output_html."『最新順』『検索結果』へ戻って、送信したいアドレスに ○ を付けて下さい。<br>\n";
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."<table><td><form action=$file_main method=post>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=$form{'backpage'}>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."<input type=submit value=' アドレス選択へ戻る '>\n";
		$output_html=$output_html."</form></td></table>\n";
	}
}
1;
