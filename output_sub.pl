#--------------------------------------
#顧客管理DataBase用 HTML出力部分
#&output($html_sw)
#	入力(フォーム入力データは省略):
#		@config				…設定データ群
#			0…解説文（本編では使用しない）
#			1…現在登録されているパスワード
#			2…起動時などに表示される最近登録された件数
#			3…最新順などに表示される管理者からのお知らせ
#		$edit_id			…詳細〜:見るID
#		$edit_inputerror	…詳細〜:追加の際でのトラブルで戻っているのか？
#		$error_code			…エラー:エラーコード
#		$error_file			…エラー:エラーを引き起こしたファイル名
#		$error_htmlplus		…エラー:HTML出力時の追加メッセージ
#		$error_search		…エラー:検索失敗について
#		$file_kokyaku		…顧客情報ファイル名
#		$file_kokyaku_bak	…第1世代バックアップ顧客情報ファイル名
#		$file_main			…メインルーチンを示したファイル名
#		$file_taiou			…対応履歴ファイル名
#		$file_taiou_bak		…第1世代バックアップ対応履歴ファイル名
#		$html_sw…表示内容の切り替え
#			0…最新 ?件 について(初期画面)
#			1…検索結果
#			2…詳細(･修正･追加･削除)情報表示
#			3…修正･追加･削除確認
#			4…NULL
#			5…システム管理機能
#			6…システム管理機能確認
#			7…NULL
#			8…管理者機能ON/OFF切り替え確認表示
#			9…NULL
#			10…対応履歴の編集画面
#			11…一部操作履歴の設定変更確認
#			12…NULL
#			13…一斉メール送信設定変更
#			14…NULL
#		$kanji_code			…使用する漢字コードについて
#		$kanrimode_crypt	…管理者:セキュリティー用パスワード暗号作成値
#		$kanrimode_password		…管理者:セキュリティー用パスワード受け渡し用
#		$kanrimode_passwordkari	…管理者:セキュリティー用パスワード受け渡し用仮
#		$kanrimode_sw			…管理者モードのOFF/ON 0=OFF
#		@kokyaku_data			…顧客データ:生
#		@kokyaku_data_menu		…顧客データ:顧客データメニュー部分での初期表示内容
#		@kokyaku_koumokuname	…顧客データ:各項目名
#		@kokyaku_inputcyuui		…顧客データ:入力時の注意コメント
#		@kokyaku_syousai		…顧客データ:詳細…時のフォーム初期入力各種データ
#		$reload_url				…顧客管理データベースの読み直し
#		@rireki_data			…履歴データ:生
#		@rireki_koumokuname		…履歴データ:各項目名
#		$rireki_viewall			…履歴データ:この会社IDで該当表示する内容は何件か？
#		$search_keyword		…検索:実際に検索するキーワード
#		$search_houhou		…検索:検索方法(1…顧客検索 2…履歴検索)
#		$system_back		…機能実行:処理終了後･戻る処理番号
#		@taiou_koumokuname		…対応データ:各項目名
#		$version			…システムバージョン情報
#		@view_kokyaku		…最新順&検索結果:該当表示する顧客データか?(0…No 1…Yes)
#		@view_rireki		…対応履歴:該当表示する履歴データか?(0…No 1…Yes)
#		$view_rirekistart	…対応履歴:表示時一度に出てくる件数･初期値
#		$view_start			…最新順:起動時に記録の上から表示する件数･無設定時
#		$form{''}			(出力とダブるので略)
#	出力:
#		$form{'backpage'}				…機能終了後戻る各機能
#		$form{'bye'}					…顧客履歴:この顧客データ削除?! 0…No 1…Yes
#		$form{'callno'}					…顧客履歴:呼び出しID
#		$form{'change_info'}			…変更指定:管理者からのお知らせ
#		$form{'change_pass'}			…変更指定:パスワード
#		$form{'change_view'}			…変更指定:表示する最新入力件数
#		$form{'firstview_page'}			…最新順:何ページ目を見ているか
#		$form{'html_sw'}				…呼び出された(す)各機能
#		$form{'kanrimode_check'}		…管理者モード:セキュリティー用パスワード
#		$form{'kanrimode_change'}		…管理者モード:起動用パスワード入力された文字
#		$form{'kanrimode_pass'}			…管理者モード:管理者モード侵入へ入力された
#										パスワード
#		$form{'keyword_kokyaku'}		…検索：顧客データから検索するキーワード
#		$form{'keyword_rireki'}			…検索：履歴データから検索するキーワード
#		$form{'input_kokyakudata?'}		…フォーム:各入力されたデータ
#		$form{'rireki_callno'}			…対応履歴:編集するのは履歴ID
#		$form{'rireki_command	'}		…対応履歴:顧客データをどうするか
#										0…新規追加 1…削除 2…修正
#		$form{'rireki_inputtime'}		…対応履歴:入力された時間
#		$form{'rireki_inputsyubetsu'}	…対応履歴:対応種別登録
#		$form{'rireki_inputid	'}		…対応履歴:顧客ID登録
#		$form{'rireki_inputkokyaku'}	…対応履歴:顧客名登録
#		$form{'rireki_inputtaiousya'}	…対応履歴:対応者登録
#		$form{'rireki_inputnaiyou'}		…対応履歴:対応内容登録
#		$form{'rireki_viewpage	'}		…対応履歴:見ているページについて
#		$form{'search_before_houhou'}	…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		$form{'search_before_word'}		…検索：前回検索したキーワード
#		$form{'sendmail_sw'}			…メール一斉送信:どこへ送ろうか選択中か？
#											0…メール一斉送信をそもそもしようとしていない。
#											1…どこに送ろうか選択中。
#											2…メール文章設定他。
sub output {
	#データの引継ぎ
	local($html_sw)=@_;	#フォームデータからの機能切り替え
	
	#各種ローカル変数の指定
	local(@loaded_templatehtml);	#テンプレートデータ収納所
	local($i);	#ループ制御用
	local($output_html)="";		#HTML追加出力用
	local($output_html2)="";	#HTML出力最終準備用
	
	#フォームの各値引渡値
	local(@addlink);		#フォームの各値引渡値
	local($sendmail_kazu);	#メール一斉送信:送信する相手先の数
	{
		#一斉メール送信:送信先指定読み取り
		local(@keys);	#ハッシュ内のキーリスト取得用
		
		if($form{'sendmail_sw'}>0) {
			local($i);		#ループ用
			
			$sendmail_kazu=0;
			@keys=sort keys %form;
			for($i=0;$i<=$#keys;$i++) {
				if(length($keys[$i])>0&&$keys[$i]==0) {
					splice(@keys,$i,1);
					$i--;
				} else {
					$sendmail_kazu++;
				}
			}
		}
		
		#使いまわすフォーム送信データ
			#アンカーに追加
		$addlink[0]="";
		if($kanrimode_sw==1) {
			$addlink[0]=$addlink[0]."&kanrimode_check=$kanrimode_password";
		}
		if($form{'sendmail_sw'}>0) {
			local($i);
			$addlink[0]=$addlink[0]."&sendmail_sw=1";
			for($i=0;$i<=$#keys;$i++) {
				$addlink[0]=$addlink[0]."&$keys[$i]=1";
			}
		}
		if($search_houhou>0) {
			local($search_keyword_encode);
			
		    $search_keyword_encode=$search_keyword;
		    $search_keyword_encode=~ s/(\W)/'%' . unpack('H2', $1)/eg;
			$addlink[0]=$addlink[0]."&search_before_houhou=".$search_houhou."&search_before_word=".$search_keyword_encode;
		}
			#フォームに追加(全体)
		$addlink[1]="";
		$addlink[1]=$addlink[1]."<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$addlink[1]=$addlink[1]."<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$addlink[1]=$addlink[1]."<input type=hidden name=search_before_word value=$search_keyword>\n";
		if($form{'sendmail_sw'}>0) {
			local($i);
			$addlink[1]=$addlink[1]."<input type=hidden name=sendmail_sw value=$form{'sendmail_sw'}>\n";
			for($i=0;$i<=$#keys;$i++) {
				$addlink[1]=$addlink[1]."<input type=hidden name=$keys[$i] value=1>\n";
			}
		}
			#フォームに追加(一行に纏めたもの)
		$addlink[2]=$addlink[1];
		$addlink[2]=~ s/\n//g;
			#フォームに追加(検索機能用)
		$addlink[3]=$addlink[1];
		$addlink[3]=~ s/<input type=hidden name=search_before_houhou value=$search_houhou>\n//g;
		$addlink[3]=~ s/<input type=hidden name=search_before_word value=$search_keyword>\n//g;
			#リロード対策
		if(length($reload_url)>0) {
			$reload_url=$reload_url."?html_sw=".$sw;
			if($kanrimode_sw==1) {
				$reload_url=$reload_url."&kanrimode_check=$kanrimode_password";
			}
			if($search_houhou>0) {
				$reload_url=$reload_url."&search_before_houhou=".$search_houhou."&search_before_word=".$search_keyword;
			}
		}
	}
	
	if(length($error_htmlplus)>0||length($reload_url)>0) {
		#メインルーチン内で何らかのエラーが発生していた
		$output_html=$error_htmlplus;
	} else {
		#検索欄・実行中の操作などの上部の描画
		$output_html=$output_html."<div align=right>$version</div>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<table width=100% bgcolor=#cccccc>\n";
		$output_html=$output_html."  <tr>\n";
		if($kanrimode_sw!=1) {
			$output_html=$output_html."	<td align=right width=50%><b><font color=red>管理者モード：OFF</font></b></td>\n";
			$output_html=$output_html."	<td align=right width=50%>パスワード： <input type=password name=kanrimode_pass value='' size=9> <input type=submit value=' 管理者モード起動 '></td>\n";
		} else {
			$output_html=$output_html."	<td align=right width=50%><b><font color=red>管理者モード：ON</font></b></td>\n";
			$output_html=$output_html."	<td align=right width=50%><input type=submit value=' 管理者モード終了 '></td>\n";
		}
		$output_html=$output_html."  </tr>\n";
		$output_html=$output_html."</table>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=html_sw value=8>\n";
		$output_html=$output_html."</form>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<div align=center>\n";
		$output_html=$output_html."<b>顧客検索</b> <input type=text name=keyword_kokyaku value='' size=40> <input type=submit value=' 検索 '><br>\n";
		$output_html=$output_html."<b>履歴検索</b> <input type=text name=keyword_rireki value='' size=40> <input type=submit value=' 検索 '><br>\n";
		$output_html=$output_html."</div>\n";
		$output_html=$output_html.$addlink[3];
		$output_html=$output_html."<input type=hidden name=html_sw value=1>\n";
		$output_html=$output_html."</form>\n";
		
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<table width=100% border=0 cellpadding=0 cellspacing=0>\n";
		{
			local($j);	#ループ制御用
			local(@function);		#表示する各種機能名
			local(@function_red);	#背景を赤で表示するか(1=Yes)？
			
			$output_html=$output_html."  <tr>\n";
			
				#最新順について
			$function[0]="最新順　(<b>$view_start 件</b>ずつ)";
			if($html_sw==0) {
				$function_red[0]=1;
			} else {
				$function[0]="<a href='$file_main?html_sw=0$addlink[0]'>$function[0]</a>";
			}
				#検索結果
			$function[1]="検索結果";
			if(length($search_keyword)>0) {
				$function[1]="'".$search_keyword."' の検索結果";
			}
			if($html_sw==1) {
				$function_red[1]=1;
			} elsif(length($search_keyword)>0) {
				$function[1]="<a href='$file_main?html_sw=1$addlink[0]'>$function[1]</a>";
			}
				#詳細･修正･追加･削除
			if($kanrimode_sw!=1) {
				$function[2]="詳細･修正";
			} else {
				$function[2]="詳細･修正･追加･削除";
			}
			if($html_sw==2||$html_sw==3||$html_sw==10) {
				$function_red[2]=1;
			}
				#管理者専用設定
			if($kanrimode_sw==1) {
				$function[3]="管理者専用設定";
				if($html_sw==5||$html_sw==6) {
					$function_red[3]=1;
				} else {
					$function[3]="<a href='$file_main?html_sw=5$addlink[0]'>$function[3]</a>";
				}
			}
			
			for($j=0;$j<=$#function;$j++) {
				if($function_red[$j]==1) {
					$output_html=$output_html."	<td align=center bgcolor=#ff8888>$function[$j]</td>\n";
				} else {
					$output_html=$output_html."	<td align=center>$function[$j]</td>\n";
				}
			}
			
			$output_html=$output_html."  </tr>\n";
		}
		
		$output_html=$output_html."  <tr><td bgcolor=#ff4444 colspan=4></td></tr>\n";
		$output_html=$output_html."  <tr>\n";
		$output_html=$output_html."	<td align=center bgcolor=#ffffff colspan=4>\n";
		$output_html=$output_html."	<br>\n";
		if($kanrimode_sw==1&&(!($form{'callno'}==-1&&(2<=$html_sw&&$html_sw<=4)))) {
			$output_html=$output_html."	<table><tr>\n";
			# サポートする会社の新規追加
			$output_html=$output_html."	<td><form action=$file_main method=post><input type=submit value=' サポートする会社の新規追加 '><input type=hidden name=html_sw value=2><input type=hidden name=callno value=-1><input type=hidden name=backpage value=$system_back>".$addlink[2]."</form></td>\n";
			if($html_sw==2) {
				$output_html=$output_html."	<td><form action=$file_main method=post><input type=submit value=' この会社を削除する '><input type=hidden name=html_sw value=3><input type=hidden name=callno value=$form{'callno'}><input type=hidden name=backpage value=$system_back><input type=hidden name=bye value=1>".$addlink[2]."</form></td>\n";
			}
			$output_html=$output_html."	</tr></table>\n";
		}
		$output_html=$output_html."	<br>\n";
		
		
			#警告文がある場合は表示
		if(length($edit_inputerror)>0) {
			$output_html=$output_html."	$edit_inputerror\n";
		}
		
			#一斉メール送信:送信先アドレス指定中
		if($form{'sendmail_sw'}==1) {
			$output_html=$output_html."	<br><table border><tr><td align=center bgcolor=#ff8888 width=80%>\n";
			$output_html=$output_html."	<b>一斉メール送信</b> : 送信先の指定<br>\n";
			$output_html=$output_html."	『最新順』・『検索結果』表示へ切り替えて、送信をしたい会社に『○』を入れてください。\n";
			$output_html=$output_html."	</td></tr></table><br>\n";
		}
		
		#各機能ごとの処理
		if($html_sw==0||$html_sw==1) {
			#最新順について-----------------------------------------------------
			#検索結果-----------------------------------------------------------
			require 'html_new&search_sub.pl';
			&html_new_and_search();
		} elsif($html_sw== 2) {
			#詳細(･修正･追加･削除)情報表示--------------------------------------
			require 'html_syousai0_sub.pl';
			&html_syousai_info();
		} elsif($html_sw== 3) {
			#修正･追加･削除確認-------------------------------------------------
			require 'html_syousai1_sub.pl';
			&html_syousai_check();
		} elsif($html_sw== 5) {
			#管理者専用設定-----------------------------------------------------
			require 'html_edit_system_sub.pl';
			&html_edit_system();
		} elsif($html_sw== 6) {
			#管理者専用設定変更確認---------------------------------------------
			require 'html_check_system_sub.pl';
			&html_check_system(5,7);
		} elsif($html_sw==11) {
			#一部操作履歴の設定変更確認-----------------------------------------
			require 'html_check_sousarireki_sub.pl';
			&html_check_sousarireki(5,12);
		} elsif($html_sw==17) {
			#一斉メール送信設定変更---------------------------------------------
			require 'html_check_set_sendmail_sub.pl';
			&html_check_set_sendmail(5,14);
		} elsif($html_sw==13) {
			#メール内容入力-----------------------------------------------------
			require 'html_mail_naiyou_sub.pl';
			&html_mail_naiyou();
		} elsif($html_sw==15) {
			#メール内容確認-----------------------------------------------------
			require 'html_mail_kakunin_sub.pl';
			&html_mail_kakunin();
		} elsif($html_sw== 8) {
			#管理者機能のスイッチON/OFFについて---------------------------------
			require 'html_kanrimode_switch_sub.pl';
			&html_kanrimode_switch();
		} elsif($html_sw==10) {
			#対応履歴の編集画面-------------------------------------------------
			require 'html_syousai2_sub.pl';	
			&html_edit_taiou();
		}
		
		#検索欄・実行中の操作などの終端を描画
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	</td>\n";
		$output_html=$output_html."  </tr>\n";
		$output_html=$output_html."  <tr>\n";
		$output_html=$output_html."	<td bgcolor=#ff4444 colspan=4></td>\n";
		$output_html=$output_html."  </tr>\n";
		$output_html=$output_html."</table>\n";
	}
	
	if(length($reload_url)>0) {
		#ファイルをリロードすることで、「更新」を押しても2重動作しないようにする
		local($http_httphost);
		local($http_documenturi);
		$http_httphost=$ENV{"HTTP_HOST"};
		$http_documenturi=$ENV{"REQUEST_URI"};
		for($i=length($http_documenturi);substr($http_documenturi,$i,1) ne '/';$i--) {
			$http_documenturi=substr($http_documenturi,0,$i);
		}
		$reload_url="http://".$http_httphost.$http_documenturi.$reload_url;
		
		#ヘッダの出力
		print "Location: $reload_url\n\n";
	} else {
		#ヘッダの出力
		print "Content-type: text/html;charset=$kanji_code\n\n";
		
		#表示全体のレイアウト設定
$output_html2 = <<"end";
<html>
<head>
<title>$version</title>
<LINK REL="SHORTCUT ICON" href="favicon.ico">
<meta http-equiv="Content-Type" content="text/html; charset=$kanji_code">
<style type="text/css">
<!--
body {font-family:"ＭＳ Ｐゴシック","ＭＳ ゴシック",sans-serif; line-height:normal; color:black; font-style:normal; font-weight:normal; text-decoration:normal;
	margin-top: 5px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px;}
h1 {  padding-bottom: 3px; border-color: white red red white; font-family: "ＭＳ ゴシック", "Osaka−等幅"; border-style: solid; border-top-width: 0px; border-right-width: 15px; border-bottom-width: 3px; border-left-width: 0px}

address {line-height:normal; color:black; text-align:right; font-style:italic;
	margin-top: 12px; margin-right: 12px}
a.address {font-family:sans-serif; line-height:normal; color:blue; font-style:italic; font-weight:bold; text-decoration:normal;}
-->
</style>
</head>
<body bgcolor="#ffeeee" text="#000000" link="#0000aa" vlink="#0000aa" alink="#ff0000">
<h1><img src="icon_k_database.gif" width="64" height="64" alt="(icon)">　$version</h1>
<div align=center> 
  <table width="730" border="0">
	<tr> 
	  <td> 
		<div align=right><a href="info_use.html#play">info_use.html (ヘルプ) を読む</a></div>
		<br>
		
$output_html
		
	  </td>
	</tr>
  </table>
</div>
<br>
<table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td bgcolor="#aaaaaa" bordercolor="0" valign="middle" align="left" nowrap> 
	  <b><font size="-1"><a href="http://kuze.tsukaeru.jp/tools/" class=vector target="_parent">▲▲ 
	  ジグソーTools（作者のサイト）へ</a></font>　<font size="-1"><a href="http://kuze.tsukaeru.jp/tools/k_database/" class=vector target="_parent">▲   このソフトのサポートページへ</a></font></b> </td>
	<td width="25">　</td>
  </tr>
</table>
<br>
<table border="0" width="100%">
  <tr> 
	<td width="10"> </td>
	<td bgcolor="#aaaaaa" align="right"> 
	  <address><font color="#FFFFFF">&copy;Copyright <strong><a href="mailto:kuze_work\@hotmail.com">Hiroshi 
	  Kuze</a></strong> 2002-2004.<br>
	  御意見御感想その他もろもろは <a href="http://kuze.tsukaeru.jp/tools/bbs/"><b>掲示板</b></a> 
	  か <a href="mailto:kuze_work\@hotmail.com"><b>kuze_work\@hotmail.com</b></a> 
	  へ</font> </address>
	</td>
  </tr>
</table>
</body>
</html>
end
	}

	#他サイトへのクリックされた場合、HTTP_REFERERでデータが流出されないように
	#ダミーページへまず送るようにする
	$output_html2=~ s/href=\"http:/href=\"dummy.cgi?move_url=http:/g;
	$output_html2=~ s/href=\'http:/href=\'dummy.cgi?move_url=http:/g;

	#HTML出力
	print $output_html2;

}
1;
