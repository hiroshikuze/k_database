#--------------------------------------
#ページの出力−最新順について&検索結果
#&html_new_and_search()
#	入力:
#		@config					…設定データ群
#		$error_search			…エラー:検索失敗について
#		$file_main				…メインルーチンを示したファイル名
#		$form{'firstview_page'}	…最新順:何ページ目を見ているか
#		$html_sw				…表示内容の切り替え
#		$kanrimode_password		…管理者:セキュリティー用パスワード受け渡し用
#		$kanrimode_sw			…管理者モードのOFF/ON 0=OFF
#		@kokyaku_data			…顧客データ:生
#		@kokyaku_koumokuname	…顧客データ:各項目名
#		@rireki_data			…履歴データ:生(出力用に一部加工)
#		$search_houhou			…検索:検索方法(1…顧客検索 2…履歴検索)
#		$search_keyword			…検索:実際に検索するキーワード
#		$sendmail_kazu			…メール一斉送信:送信する相手先の数
#		$view_rireki			…対応履歴:該当表示する履歴データか?(0…No 1…Yes)
#		$view_rirekistart		…対応履歴:一度に表示する件数
#		@view_kokyaku			…最新順&検索結果:該当表示する顧客データか?(0…No 1…Yes)
#		$view_start				…最新順:起動時に記録の上から表示する件数･無設定時
#		フォーム:	(出力とダブるので略)
#	出力:
#		@addlink		…フォームの各値引渡値
#							[0]…アンカーによる値引渡し
#							[1]…フォームによる値引渡し
#							[2]…フォームによる値引渡し(改行除去)
#		$output_html	…HTML追加出力用
#		@rireki_data	…履歴データ:生(出力用に一部加工)
#		フォーム:	ADDR				…mapfan様用引渡し値
#		フォーム:	backpage			…機能終了後戻る各機能
#		フォーム:	callno				…顧客履歴:呼び出しID
#		フォーム:	firstview_page		…最新順:何ページ目を見ているか
#		フォーム:	html_sw				…呼び出された(す)各機能
#		フォーム:	kanrimode_check		…管理者モード:セキュリティー用パスワード
#		フォーム:	move_url			…外部URLへの移動:移動先URLの指定
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word	…検索：前回検索したキーワード
#		フォーム:	sendmail_addlist	…一斉メール送信:送信リストに追加する番号(ID番号で指定)
#		フォーム:	sendmail_all		…一斉メール送信:送信リスト全体に対する操作
#		フォーム:	sendmail_dellist	…一斉メール送信:送信リストから削除する番号(ID番号で指定)
#		フォーム:	sendmail_sw	…メール一斉送信：どこへ送ろうか選択中か？
sub html_new_and_search {
	local($write_before_next);	#描写登録 前のページへ & 次のページへ
	local($sendmail_button);	#一斉メール送信:メール送信などのボタン表示
	
	#サブルーチン群ロード
	require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする
	
	#一斉メール送信：送信相手設定中なら
	if($form{'sendmail_sw'}>0) {
		$sendmail_button="";
		$sendmail_button=$sendmail_button."\n\n<table><tr>\n";
		$sendmail_button=$sendmail_button."<td>\n";
		$sendmail_button=$sendmail_button."<form action=$file_main method=post>\n";
		$sendmail_button=$sendmail_button.$addlink[1];
		$sendmail_button=$sendmail_button."<input type=hidden name=html_sw value=13>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=backpage value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=submit value=内容入力へ移る>\n";
		$sendmail_button=$sendmail_button."</form>\n";
		$sendmail_button=$sendmail_button."</td>\n";
		$sendmail_button=$sendmail_button."<td>\n";
		$sendmail_button=$sendmail_button."<form action=$file_main method=post>\n";
		$sendmail_button=$sendmail_button.$addlink[1];
		$sendmail_button=$sendmail_button."<input type=hidden name=html_sw value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=backpage value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=sendmail_all value=2>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$sendmail_button=$sendmail_button."<input type=submit value=全登録顧客を○>\n";
		$sendmail_button=$sendmail_button."</form>\n";
		$sendmail_button=$sendmail_button."</td>\n";
		$sendmail_button=$sendmail_button."<td>\n";
		$sendmail_button=$sendmail_button."<form action=$file_main method=post>\n";
		$sendmail_button=$sendmail_button.$addlink[1];
		$sendmail_button=$sendmail_button."<input type=hidden name=html_sw value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=backpage value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=sendmail_all value=1>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$sendmail_button=$sendmail_button."<input type=submit value=全て×に戻す>\n";
		$sendmail_button=$sendmail_button."</form>\n";
		$sendmail_button=$sendmail_button."</td>\n";
		$sendmail_button=$sendmail_button."</tr></table>\n\n";
	}
	
	#一斉メール送信：送信・リセットなどの操作
	if($form{'sendmail_sw'}>0) {
		$output_html=$output_html.$sendmail_button;
		$output_html=$output_html."<br>\n";
	}
	
	#検索時のエラーチェック
	if($error_search==1) {
		$output_html=$output_html."	<b><font color=red>検索キーワードが入力されていません</font></b><br>\n";
	} elsif($error_search==2) {
		$output_html=$output_html."	<b><font color=red>検索キーワードに該当する会社が見つかりませんでした。</font></b><br>\n";
	} else {
		#検索時のエラーがなければ、
		#表示指定した顧客･履歴データを表示する
		local($i);	#ループ制御用
		local($j);
		
		if($html_sw==1&&$search_houhou==2) {
			#履歴データ個所を表示する場合
			
				#フォームの各値引渡値修正事項
			$addlink[0]="backpage=$html_sw&".$addlink[0];
			$addlink[1]=$addlink[1]."<input name=backpage type=hidden value=$html_sw>\n";
			$addlink[2]=$addlink[1];
			$addlink[2]=~ s/\n//g;
			
				#対応履歴:顧客データ呼び出しID先行数+1
			$output_html=$output_html."	<table>\n";
			$output_html=$output_html."	  <tr><td></td><td></td><td align=center bgcolor=ffdddd><b>投稿先</b></td><td align=center  bgcolor=ffdddd><b>投稿時間</b></td><td align=center bgcolor=ffdddd><b>投稿者</b></td><td align=center bgcolor=ffdddd><b>対応種別</b></td><td align=center bgcolor=ffdddd><b>コメント</b></td></tr>\n";
			for($j=$#view_rireki;$j>-1;$j--) {
				$output_html=$output_html."	  <tr>\n";
				if($view_rireki[$j]==1) {
					local($okikae);	#置き換え文字
					
					&tab_cut($rireki_data[$j]);
					
					$okikae="<a href='$file_main?html_sw=2&callno=$cut_end[1]&$addlink[0]'>$search_keyword<\/a>";
					$rireki_data[$j+1]=~ s/$search_keyword/$okikae/g;
					&tab_cut($rireki_data[$j+1]);
					
					$output_html=$output_html."		<td valign=top align=left>・</td>\n";
					$output_html=$output_html."<form action=$file_main method='POST'>\n";
					$output_html=$output_html."		<td valign=top align=left>\n";
					$output_html=$output_html."<input name=html_sw type=hidden value=1>\n";
					$output_html=$output_html.$addlink[1];
					if($form{'sendmail_all'}==1) {
						if($form{substr($cut_end[1],0,11)}==1) {
							$output_html=$output_html."<input name=sendmail_dellist type=hidden value=$cut_end[1]>\n";
							$output_html=$output_html."<input type=submit value=○>\n";
						} else {
							$output_html=$output_html."<input name=sendmail_addlist type=hidden value=$cut_end[1]>\n";
							$output_html=$output_html."<input type=submit value=×>\n";
						}
					}
					$output_html=$output_html."		</td>\n";
					$output_html=$output_html."</form>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[2]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[3]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[4]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[5]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[6]</td>\n";
				}
				$output_html=$output_html."	  </tr>\n";
			}
			$output_html=$output_html."	</table>\n";
		} else {
			#顧客データ個所を表示する場合
			
			#フォームの各値引渡値修正事項
			$addlink[0]="html_sw=$html_sw&backpage=$html_sw&".$addlink[0];
			$addlink[1]=$addlink[1]."<input name=backpage type=hidden value=$html_sw>\n";
			$addlink[1]=$addlink[1]."<input name=firstview_page type=hidden value=$form{'firstview_page'}>\n";
			$addlink[2]=$addlink[1];
			$addlink[2]=~ s/\n//g;
			
			local($addlink)="";	#リンク先にデータ伝達
			if($html_sw==0) {
				if($form{'firstview_page'}==0&&length($config[3])>1) {
					$output_html=$output_html."	<div align=right><table border>\n";
					$output_html=$output_html."	  <tr><td align=center bgcolor=FF9999 nowrap><b>管理者からのお知らせ</b></td></tr>\n";
					$output_html=$output_html."	  <tr><td>$config[3]</td></tr>\n";
					$output_html=$output_html."	</table></div>\n";
					$output_html=$output_html."	<br>\n";
				}
				$output_html=$output_html."	<b>現在 ".($form{'firstview_page'}+1)." ページ目です</b><br>\n";
			}
			
			#前のページへ & 次のページへ について
			$write_before_next=$write_before_next."	<br>\n";
			$write_before_next=$write_before_next."	<div align=right>\n";
			
			if(0<$form{'firstview_page'}) {
				$write_before_next=$write_before_next."	  <a href='$file_main?firstview_page=".($form{'firstview_page'}-1)."&$addlink[0]'>&lt;&lt;前のページへ</a> |";
			} else {
				$write_before_next=$write_before_next."	  <font color=#999999><s>&lt;&lt;前のページへ</s></font> |";
			}
			for($i=0,$j=-($form{'firstview_page'}+1)*$view_start;$i<=$#view_kokyaku;$i++) {
				$j=$j+$view_kokyaku[$i];
			}
			if($j>=0) {
				$write_before_next=$write_before_next." <a href='$file_main?firstview_page=".($form{'firstview_page'}+1)."&$addlink[0]'>次のページへ&gt;&gt;</a>\n";
			} else {
				$write_before_next=$write_before_next." <font color=#999999><s>次のページへ&gt;&gt;</s></font>\n";
			}
			$write_before_next=$write_before_next."	</div>\n";
			$write_before_next=$write_before_next."	<br>\n";
			
			$output_html=$output_html.$write_before_next;
			for($i=0,$j=$#view_kokyaku;$j>-1;$j--) {
				if($view_kokyaku[$j]==1) {
					if($form{'firstview_page'}*$view_start<=$i&&$i<($form{'firstview_page'}+1)*$view_start) {
						local($k);					#ループ制御用
						local($kokyaku_syousai);	#各顧客詳細情報
						
						&tab_cut($kokyaku_data[$j+1]);
						for($k=0;$k<$#cut_end;$k++) {
							$kokyaku_syousai[$k]=$cut_end[$k];
						}
						
						$output_html=$output_html."	<table border=1 CELLPADDING=4 CELLSPACING=0 width=640 align=center>\n";
						$output_html=$output_html."	  <tr bgcolor=FF9999>\n";
						$output_html=$output_html."		<td width=70% colspan=2>$kokyaku_koumokuname[ 1] ： <b>$kokyaku_syousai[1]</b></td>\n";
						$output_html=$output_html."		<td width=30%>$kokyaku_koumokuname[22] ： $kokyaku_syousai[22]</td>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	  <tr bgcolor=#ffdddd>\n";
						$output_html=$output_html."		<td width=70% colspan=2>\n";
						$output_html=$output_html."		  <table width=100% border=0><tr>\n";
						if($form{'sendmail_sw'}==1) {
							$output_html=$output_html."			<td align=left valign=middle>\n";
							$output_html=$output_html."<form action=$file_main method='POST'>\n";
							$output_html=$output_html."<input name=html_sw type=hidden value=0>\n";
							$output_html=$output_html.$addlink[1];
							if($sendmail_kazu>0) {
								if($form{substr($kokyaku_syousai[0],0,11)}==1) {
									$output_html=$output_html."<input name=sendmail_dellist type=hidden value=$kokyaku_syousai[0]>\n";
									$output_html=$output_html."<input type=submit value=○>\n";
								} else {
									$output_html=$output_html."<input name=sendmail_addlist type=hidden value=$kokyaku_syousai[0]>\n";
									$output_html=$output_html."<input type=submit value=×>\n";
								}
							} else {
								$output_html=$output_html."<input name=sendmail_addlist type=hidden value=$kokyaku_syousai[0]>\n";
								$output_html=$output_html."<input type=submit value=×>\n";
							}
							$output_html=$output_html."			  $kokyaku_koumokuname[ 2] ： <b><font size=+1>$kokyaku_syousai[2]</font></b>\n";
							$output_html=$output_html."</form>\n";
							$output_html=$output_html."			</td>\n";
						} else {
							$output_html=$output_html."			<td align=left valign=middle>\n";
							$output_html=$output_html."			  $kokyaku_koumokuname[ 2] ： <b><font size=+1>$kokyaku_syousai[2]</font></b>\n";
							$output_html=$output_html."			</td>\n";
						}
						if(length($kokyaku_syousai[25])>0) {
							$output_html=$output_html."			<td width=32><a href='$kokyaku_syousai[25]'><img src='icon_website.gif' border=0></a></td>\n";
						}
						if(length($kokyaku_syousai[16])>0) {
							$output_html=$output_html."			<td width=32><a href='mailto:$kokyaku_syousai[16]'><img src='icon_mail.gif' border=0></a></td>\n";
						}
						$output_html=$output_html."		  </tr></table>\n";
						$output_html=$output_html."		</td>\n";
						$output_html=$output_html."		<td width=30%>$kokyaku_koumokuname[30] ： $kokyaku_syousai[30]</td>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	  <tr>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[ 4] ： $kokyaku_syousai[4]</td>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[ 7] ： $kokyaku_syousai[7]</td>\n";
						$output_html=$output_html."		<form action='dummy.cgi' method=get name=_brank>\n";
						$output_html=$output_html."		<td width=30% colspan=1 align=right>\n";
						if(length($kokyaku_syousai[11])>0) {
							$output_html=$output_html."		  <input type=hidden name=move_url value=http://www.mapfan.com/index.cgi>\n";
							$output_html=$output_html."		  <input type=hidden name=ADDR value=$kokyaku_syousai[11]>\n";
							$output_html=$output_html."		  <input type=submit value=' MapFan リンク '>\n";
						} else {
							$output_html=$output_html."		  '住所-名前'が未入力\n";
						}
						$output_html=$output_html."		</td>\n";
						$output_html=$output_html."		</form>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	  <tr>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[14] ： $kokyaku_syousai[14]</td>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[15] ： $kokyaku_syousai[15]</td>\n";
						$output_html=$output_html."		<form action=$file_main method='POST'>\n";
						$output_html=$output_html."		<td width=30% colspan=1 align=right>\n";
						$output_html=$output_html.$addlink[1];
						$output_html=$output_html."<input name=html_sw type=hidden value=2>\n";
						$output_html=$output_html."<input name=callno type=hidden value=$kokyaku_syousai[0]>\n";
						$output_html=$output_html."<input type=submit value=' 詳細情報\表\示 '>\n";
						$output_html=$output_html."		</td>\n";
						$output_html=$output_html."		</form>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	</table>\n";
						$output_html=$output_html."	<br>\n";
					}
					$i++;
				}
			}
			$output_html=$output_html.$write_before_next;
		}
	}
	
	#一斉メール送信：送信・リセットなどの操作
	if($form{'sendmail_sw'}>0) {
		$output_html=$output_html.$sendmail_button;
	}
}
1;
