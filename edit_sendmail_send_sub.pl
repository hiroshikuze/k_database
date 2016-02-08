#--------------------------------------
#メール一斉送信−メール送信
#&edit_sendmail_send()
#	入力:
#		$file_kokyaku			…顧客情報ファイル名
#		$file_taiou				…対応履歴ファイル名
#		$file_taiou_bak			…第1世代バックアップ顧客情報ファイル名
#		@kokyaku_data			…顧客データ:生
#		@rireki_data			…履歴データ:生
#		$mailer_pass			…semdmailもしくは、その互換までのパス
#		$mailer_ownaddress		…管理者のメールアドレス(ココは必ず変更してください！)
#		フォーム:(出力と共通するもの)	…出力とダブるので略
#			sendmail_honbun	…メール一斉送信：送信するメールの本文
#			sendmail_title	…メール一斉送信：送信するメールのタイトル
#			sendmail_sw		…メール一斉送信：どこへ送ろうか選択中か？
#								0…メール一斉送信をそもそもしようとしていない。
#								1…どこに送ろうか選択中。
#								2…メール文章設定他。
#	出力:
#		$error_code…エラー発生時に挿入する値
#		$error_file…呼び出し方とファイル名前
#		@kokyaku_data		…顧客データ:生
#		@rireki_data		…履歴データ:生
#		フォーム:
#			sendmail_sw		…メール一斉送信：どこに送ろうか選択中か？
sub edit_sendmail_send {
	#変数・サブルーチン定義
	require'tab_cut_lib.pl';			#文字列をタブ単位でバラバラにする
	require'save_kanri_rireki_lib.pl';	#一部操作履歴の保存
	require'encodesubject_lib.pl';		#メールの日本語サブジェクトをエンコードする
	local($i);				#ループ用
	local($err);			#メール送信エラー管理
	local(@report);			#送信報告
								#0…まとめ
								#1…メールタイトル(JIS変換前)
								#2…メール本文(JIS変換前)
								#3…送信報告用タイトル
	local($write_rireki);	#対応履歴に書き込む内容
		#時刻の収納用
	local($year);
	local($mon);
	local($day);
	local($hour);
	local($min);
	local($sec);
	local($null);
	local($data_time);	#現在時間
	local($rireki_syuusei_id);	#対応履歴書き込み:ID修正
	
	for($i=0;$i<4;$i++) {
		$report[$i]="";
	}
	$report[3]="メール一斉送信";
	
	#顧客データの読み取り
	if($#kokyaku_data==-1) {
		@kokyaku_data=&file_access("<$file_kokyaku",7);
	}
	
	#対応履歴データの読み取り
	if($#rireki_data==-1) {
		@rireki_data=&file_access("<$file_taiou",9);
		#履歴データのバックアップ
		&file_access(">$file_taiou_bak",10,@rireki_data);
	}
	
	#対応履歴書き込み準備
		#現在の時刻データ収録
	($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
	$mon=$mon+1;
	$year=$year+1900;
	$data_time=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
	$write_rireki=sprintf("%d/%02d/%02d %02d:%02d:%02d	%s	%s	%s",$year,$mon,$day,$hour,$min,$sec,$kanrimode_name,$kanrimode_send,"以下の内容のメールを送信しました。<br><font size=-2><b>タイトル名:</b><br>$form{'sendmail_title'}<br><b>本文:</b><br>$form{'sendmail_honbun'}</font>");
	$write_rireki=~ s/\\r\\n/<br>/g;
	$write_rireki=~ s/\\n/<br>/g;
	
	#送信報告準備
	$report[0]=$report[0]."以下のようにメールを送信しました。<br><br><font size=-2>";
	$report[0]=$report[0]."<b>送信先:</b><br>";
	
	#メール送信
	$report[1]=$form{"sendmail_title"};
	jcode::convert(\$form{"sendmail_title"}, "jis");
	$form{"sendmail_title"}=&EncodeSubject($form{"sendmail_title"});
	$report[2]=$form{"sendmail_honbun"};
	$form{"sendmail_honbun"}=~ s/\\r\\n/\r\n/g;
	$form{"sendmail_honbun"}=~ s/\\n/\n/g;
	jcode::convert(\$form{"sendmail_honbun"}, "jis");
	
	$err = 0;
	for($i=$#kokyaku_data,$rireki_syuusei_id=0;$i>0;$i--) {
		if ($err==0) {
			&tab_cut($kokyaku_data[$i]);
			if($form{substr($cut_end[0],0,11)}==1) {
				if(length($cut_end[16])>3) {
					local($rireki_set);		#対応履歴書き込み:行位置
					local($rireki_setid);	#ID指定
					
					open(MAIL, "| $mailer_pass -t") or $err = 1;
					print MAIL "From: $mailer_ownaddress\n";
					print MAIL "To: $cut_end[16]\n";
					print MAIL "Subject: $form{'sendmail_title'}\n";
					print MAIL "MIME-Version: 1.0\n";
					print MAIL "Content-Type: text/plain; charset=iso-2022-jp\n";
					print MAIL "\n";
					print MAIL $form{'sendmail_honbun'};
					print MAIL "\n";
					print MAIL "\n\n" . "." . "\n";
					close(MAIL);
					$report[0]=$report[0]." $cut_end[2] /";
					
					#対応履歴に書き込み
					$rireki_set=$#rireki_data+2;
					$rireki_setid=-($data_time*100+$rireki_syuusei_id);
					$rireki_data[$rireki_set]=sprintf("%.0f	%.0f	%s	%s\n",$rireki_setid,$cut_end[0],$cut_end[2],$write_rireki);
					
					$rireki_syuusei_id++;
				}
			}
		} else {
			$error_code=16;
			$error_file="";
			$i=0;
		}
	}
	if($err==0) {
		$report[2]=~ s/\\r\\n/<br>/g;
		$report[2]=~ s/\\n/<br>/g;
		$report[0]=$report[0]."<br>";
		$report[0]=$report[0]."<b>タイトル名:</b><br>";
		$report[0]=$report[0]." $report[1]<br>";
		$report[0]=$report[0]."<b>本文:</b><br>";
		$report[0]=$report[0]." $report[2]<br>";
		
		#対応履歴の保存
		&file_access(">$file_taiou",9,$config[6],@rireki_data);
	}
	
	#送信報告閉じる・書き込み
	$report[0]=$report[0]."</font>";
	&save_kanri_rireki($report[3],$report[0]);
	
	#各値を送信前に戻す
	$form{"sendmail_sw"}=0;
}
1;
