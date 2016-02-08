#--------------------------------------
#ページの出力−管理者専用設定
#&html_edit_system()
#	入力:
#		@config					…設定データ群
#		$file_kokyaku			…顧客情報ファイル名
#		$file_taiou				…対応履歴ファイル名
#		$file_sousa_rireki		…一部操作履歴ファイル
#		$html_sw				…表示内容の切り替え
#		$kanrimode_password		…管理者:セキュリティー用パスワード受け渡し用
#		$search_keyword			…検索:実際に検索するキーワード
#		$search_houhou			…検索:検索方法(1…顧客検索 2…履歴検索)
#		$view_start				…最新順:起動時に記録の上から表示する件数･無設定時
#		フォーム:	(出力とダブるので省略)
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:	change_info			…変更指定:管理者からのお知らせ
#		フォーム:	change_leave_sousarireki
#										…変更指定:一部操作履歴を残す件数
#		フォーム:	change_pass			…変更指定:パスワード
#		フォーム:	change_view			…変更指定:表示する最新入力件数
#		フォーム:	change_view_sousarireki
#										…変更指定:一部操作履歴の表示する件数
#		フォーム:	change_cut_mailissei_rireki
#										…変更指定:一部操作履歴と一斉メール送信履歴で以下省略する改行の数
#		フォーム:	change_view_mailissei_rireki
#										…変更指定:一斉メール送信履歴のここで表示する件数
#		フォーム:	html_sw				…呼び出された(す)各機能
#		フォーム:	kanrimode_check		…管理者モード:セキュリティー用パスワード
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word	…検索：前回検索したキーワード
#		フォーム:	sendmail_sw			…メール一斉送信:どこへ送ろうか選択中か？
#											0…メール一斉送信をそもそもしようとしていない。
#											1…どこに送ろうか選択中。
#											2…メール文章設定他。
sub html_edit_system {
	
	local($next_html_sw);	#設定変更するよう次回実行時に伝える
	local($navigator);	#管理者専用設定内のナビゲート
	
	if($form{'sendmail_sw'}==0) {
		#管理者専用設定内のナビゲートの設定
		$navigator="	<u>= <a href=#sousa_rireki>一部操作履歴</a> / <a href=#soushin_rireki>一斉メール送信</a> / <a href=#download>顧客データのダウンロード</a> / <a href=#setting_systems>管理者設定の変更</a> =</u><br>\n";
		
		$output_html=$output_html."	<br>\n";
		
			#ナビゲータ表示
		$output_html=$output_html.$navigator;
		
			#一部操作履歴
		@kanrimode_rireki=&file_access("<$file_sousa_rireki",15);
		$output_html=$output_html."	<a name=sousa_rireki></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>一部操作履歴</b></td></tr></table><br>\n";
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<table width=80%><tr><td align=left><b>一部操作履歴で最近のもの:</b></td></tr></table>\n";
		$output_html=$output_html."	<table width=80%>\n";
		if($#kanrimode_rireki>0) {
				#サブルーチン群ロード
			require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする。
			local($i);	#ローカルループ用
			
			for($i=$#kanrimode_rireki;($i>$#kanrimode_rireki-$config[4]&&$i>0);$i--) {
				local($j);	#ローカルループ用
				
				&tab_cut($kanrimode_rireki[$i]);
				$output_html=$output_html."	  <tr>\n";
				for($j=0;$j<3;$j++) {
					if($j==2) {
						local($k);
						local(@parts);
						
						@parts=split("<br>",$cut_end[$j]);
						for($k=0,$cut_end[$j]="";$k<$config[8]&&$k<$#parts;$k++) {
							$cut_end[$j]=$cut_end[$j].$parts[$k]."<br>";
						}
						if($#parts>$config[8]) {
							$cut_end[$j]=$cut_end[$j]."(以下略)<br>";
						}
					}
					$output_html=$output_html."		<td align=left valign=top>".$cut_end[$j]."</td>\n";
				}
				$output_html=$output_html."	  </tr>\n";
			}
		} else {
			$output_html=$output_html."	  <tr><td align=center valign=middle>一部操作履歴ファイル '$file_sousa_rireki' の中身が空になっています！<br></td></tr>\n";
		}
		$output_html=$output_html."	</table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>一部操作履歴のここで\表\示する件数:</b><br>\n";
		$output_html=$output_html."		　(現在 $config[4] 件で登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_view_sousarireki value='$config[4]' size=5>件</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>一部操作履歴を残す件数:</b><br>\n";
		$output_html=$output_html."		　(現在 $config[5] 件で登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_leave_sousarireki value='$config[5]' size=5>件</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>一部操作履歴と一斉メール送信履歴で以下省略する改行の数:</b><br>\n";
		$output_html=$output_html."		　(現在 $config[8] つで登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_cut_mailissei_rireki value='$config[8]' size=5>つ</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>一部操作履歴のダウンロード:</b></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom>\n";
		$output_html=$output_html."		<a href=$file_sousa_rireki>ファイルのダウンロード (Excel非対応)</a><br>\n";
		$output_html=$output_html."		<a href=downdata.cgi?loadfile=$file_sousa_rireki>Excel無理矢理対応</a><br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	</tr></table>\n";
		
		$next_html_sw=11;
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' 一部操作履歴設定変更 '>\n";
		$output_html=$output_html."	</form>\n";
		
			#一斉メール送信
		$output_html=$output_html."	<a name=soushin_rireki></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>一斉メール送信</b></td></tr></table><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td align=left><b>一斉メール送信最近の履歴:</b></td></tr></table>\n";
		{
			local($not_found);		#一斉メール送信記録が見つからなかったときのメッセージ
			local($write_count);	#対応する顧客情報を見つけた回数
			local($write_temp);		#複数のメール送信確認用
			
			$not_found="	  <tr><td align=center valign=middle>一斉メール送信が行われた記録はありません。<br></td></tr>\n";
			$output_html=$output_html."	<table width=80%>\n";
				#顧客情報の読み取り
			@rireki_data=&file_access("<$file_taiou",12);
			if(1<$#rireki_data) {
					#サブルーチン群ロード
				require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする。
				
				local($i);	#ローカルループ用
				
				for($i=$#rireki_data,$write_count=0,$write_temp="";(0<$i&&$write_count<$config[7]);$i--) {
					&tab_cut($rireki_data[$i]);
					if($cut_end[0]<0) {
						if($write_temp ne $cut_end[3]) {
							local($k);
							local(@parts);
							
							$output_html=$output_html."	  <tr>\n";
							$output_html=$output_html."		<td align=left valign=top>".$cut_end[3]."</td>\n";
							$output_html=$output_html."		<td align=left valign=top>".$cut_end[2]."</td>\n";
							
							$cut_end[6]=~s /\r\n//g;
							$cut_end[6]=~s /\n//g;
							@parts=split("<br>",$cut_end[6]);
							for($k=0,$cut_end[6]="";$k<$config[8]&&$k<$#parts;$k++) {
								$cut_end[6]=$cut_end[6].$parts[$k]."<br>";
							}
							if($#parts>$config[8]) {
								$cut_end[6]=$cut_end[6]."(以下略)<br>";
							}
							$output_html=$output_html."		<td align=left valign=top>".$cut_end[6]."</td>\n";
							
							$output_html=$output_html."	  </tr>\n";
							$write_count++;
							$write_temp=$cut_end[3];
						} else {
							&tab_cut($rireki_data[$i-1]);
							if($cut_end[3] ne $write_temp) {
								$output_html=$output_html."		<tr><td></td><td></td><td align=left valign=top>(他、複数の方にも同様の内容を送信しました)</td></tr>\n";
							}
						}
					}
				}
			}
			if($write_count==0) {
				$output_html=$output_html."	  <tr><td align=center valign=middle>一斉メール送信が行われた記録はありません。<br></td></tr>\n";
			} else {
				$output_html=$output_html."		<tr><td align=right valign=top colspan=3>\n";
				$output_html=$output_html."		  <a href=$file_taiou>対応履歴をダウンロード (Excel非対応)</a><br>\n";
				$output_html=$output_html."		  <a href=downdata.cgi?loadfile=$file_taiou>Excel無理矢理対応</a><br>\n";
				$output_html=$output_html."		  <font size=-2>※対応履歴の中に一斉メール送信履歴を含んでいます。</font><br>\n";
				$output_html=$output_html."		</td></tr>\n";
			}
			$output_html=$output_html."	</table>\n";
		}
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		
		$output_html=$output_html."	<input type=hidden name=sendmail_sw value=1>\n";
		
		$next_html_sw=0;
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' 新規一斉メール送信をする '>\n";
		$output_html=$output_html."	</form>\n";
		
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<table width=80%>\n";
		$output_html=$output_html."	<tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>一斉メール送信履歴のここで\表\示する件数:</b><br>\n";
		$output_html=$output_html."		　(現在 $config[7] 件で登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_view_mailissei_rireki value='$config[7]' size=5>件</td>\n";
		$output_html=$output_html."	</tr>\n";
		$output_html=$output_html."	<tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>一部操作履歴と一斉メール送信履歴で以下省略する改行の数:</b><br>\n";
		$output_html=$output_html."		　(現在 $config[8] つで登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_cut_mailissei_rireki value='$config[8]' size=5>つ</td>\n";
		$output_html=$output_html."	</tr>\n";
		$output_html=$output_html."	</table>\n";
		
		$next_html_sw=17;
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' 一斉メール送信設定変更 '>\n";
		$output_html=$output_html."	</form>\n";
		
			#ナビゲータ表示
		$output_html=$output_html.$navigator;
		
			#顧客データのダウンロード
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	<a name=download></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>顧客データのダウンロード</b></td></tr></table><br>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>顧客情報:</b></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom>\n";
		$output_html=$output_html."		<a href=$file_kokyaku>ファイルのダウンロード (Excel非対応)</a><br>\n";
		$output_html=$output_html."		<a href=downdata.cgi?loadfile=$file_kokyaku>Excel無理矢理対応</a><br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>対応履歴:</b></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom>\n";
		$output_html=$output_html."		<a href=$file_taiou>ファイルのダウンロード (Excel非対応)</a><br>\n";
		$output_html=$output_html."		<a href=downdata.cgi?loadfile=$file_taiou>Excel無理矢理対応</a><br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	</tr></table>\n";
		
			#管理者設定の変更
		$output_html=$output_html."	<a name=setting_systems></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>管理者設定の変更</b></td></tr></table><br>\n";
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>管理者からのお知らせ:</b><br></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><textarea type=text name=change_info rows=5 cols=40 warp=soft>$config[3]</textarea></td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>最初に\表\示する最新順件数:</b><br>\n";
		$output_html=$output_html."		　(現在 $view_start 件で登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_view value='$view_start' size=5>件</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>対応履歴の保存件数:</b><br>\n";
		$output_html=$output_html."	  　(現在 $config[6] 件で登録されています)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_rireki_kazu value='$config[6]' size=5>件</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>パスワード変更:</b><br></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=password name=change_pass value='$config[1]' size=9></td>\n";
		$output_html=$output_html."	</tr></table>\n";
		
		$next_html_sw=6;
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' 管理者設定の変更 '>\n";
		$output_html=$output_html."	</form>\n";
		
			#ナビゲータ表示
		$output_html=$output_html.$navigator;
	} else {
		#メール送信アドレス選択時には、管理者専用設定は変更できません。
		
		$output_html=$output_html."	<font color=red><strong>一斉メール送信の設定中は、管理者専用設定を変更することは出来ません。</strong></font><br>\n";
		$next_html_sw=5;
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' 一斉メール送信を取り消して、管理者設定画面へ移る '>\n";
		$output_html=$output_html."	</form>\n";
	}
		$output_html=$output_html."	<br>\n";
}
1;
