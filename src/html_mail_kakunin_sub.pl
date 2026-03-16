#--------------------------------------
#メール一斉送信−メール内容確認
#&html_mail_kakunin()
#	入力:
#		$file_main				…このメインシステムファイル名
#		$mailer_demolock		…メール:送信ボタンを押したら本当に送信するの？(0…Yes 1…No)
#		@view_rireki			…対応履歴:該当表示する履歴データか?(0…No 1…Yes)
#		フォーム:				(出力とダブるので省略)
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:
#			backpage			…機能終了後戻る各機能
#			callno				…顧客履歴:呼び出しID
#			firstview_page		…最新順:何ページ目を見ているか
#			kanrimode_check		…管理者モード:セキュリティー用パスワード
#			sendmail_honbun		…メール一斉送信：送信する本文
#			sendmail_title		…メール一斉送信：送信するメールのタイトル
sub html_mail_kakunin() {
	#サブルーチン群ロード
	require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする
	
	#フォームの各値引渡値修正
	
	#一斉メール送信:メール内容入力
	$output_html=$output_html."	<br><table border><tr><td align=center bgcolor=#ff8888 width=80%>\n";
	$output_html=$output_html."	<b>一斉メール送信</b> : 送信内容最終確認<br>\n";
	if(length($form{'sendmail_honbun'})>1) {
		$output_html=$output_html."	以下の内容で送信します。確認してください。\n";
	}
	$output_html=$output_html."	</td></tr></table><br>\n";
	
	#本体メッセージを表示
	if(length($form{'sendmail_honbun'})>1) {
		local($i);	#ループ用
		
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<table width=500>\n";
		#送信先アドレスの表示
		$output_html=$output_html."<tr><td align=left><b>送信先:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		for($i=$#kokyaku_data;$i>0;$i--) {
			&tab_cut($kokyaku_data[$i]);
			if($form{substr($cut_end[0],0,11)}==1) {
				if(length($cut_end[16])>3) {
					$output_html=$output_html."・ <b><a href=$file_main.$addlink[0].'&html_sw=2&call_no=$cut_end[0]'>$cut_end[2]</a></b> / <a href='mailto:$cut_end[16]'>$cut_end[16]</a><br>\n";
				}
			}
		}
		$output_html=$output_html."</td></tr>\n";
		
		#内容入力フォーム
		$output_html=$output_html."<tr><td><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left><b>送信するメールのタイトル:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		$output_html=$output_html.$form{'sendmail_title'}."\n";
		$output_html=$output_html."<input type=hidden name=sendmail_title value=$form{'sendmail_title'}>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."<tr><td><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left><b>送信するメールの本文:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left height=20>\n";
		{
			local @honbun;
			
			for($i=0;$i<2;$i++) {
				$honbun[$i]=$form{'sendmail_honbun'};
			}
			$honbun[0]=~ s/\n/\\n/g;
			$honbun[0]=~ s/\r/\\r/g;
			$honbun[1]=~ s/\r\n/<br>/g;
			$honbun[1]=~ s/\n/<br>/g;
			$output_html=$output_html."<input type=hidden name=sendmail_honbun value=$honbun[0]>\n";
			$output_html=$output_html.$honbun[1]."\n";
		}
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=16>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."<tr><td align=center>\n";
		if($mailer_demolock==0) {
			$output_html=$output_html."<input type=submit value=' この内容で本当に送信する '>\n";
		} else {
			$output_html=$output_html."<font color=red>\n";
			$output_html=$output_html."只今、メール送信にはデモロックが掛かっている為出来ません。<br>\n";
			$output_html=$output_html."添付の<a href=info_use.html#install>『info_use.html』</a>を参考に修正して下さい。<br>\n";
			$output_html=$output_html."</font>\n";
		}
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."</table>\n";
		$output_html=$output_html."</form>\n";
	} else {
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."\n";
		$output_html=$output_html."<font color=red><b>本文が入力されていません。</b></font><br>\n";
		$output_html=$output_html."前のページへ戻って、本文を入力してください。<br>\n";
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."<table><td><form action=$file_main method=post>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=$form{'backpage'}>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."<input type=submit value=' メール内容入力へ戻る '>\n";
		$output_html=$output_html."</form></td></table>\n";
	}
}
1;
