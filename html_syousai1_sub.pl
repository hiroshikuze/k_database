#--------------------------------------
#ページの出力−修正･追加･削除確認
#&html_syousai_check()
#	入力:
#		@addlink				…フォームの各値引渡値
#									[0]…アンカーによる値引渡し
#									[1]…フォームによる値引渡し
#									[2]…フォームによる値引渡し(改行除去)
#		$file_main				…メインルーチンを示したファイル名
#		$kanrimode_password		…管理者:セキュリティー用パスワード受け渡し用
#		@kokyaku_koumokuname	…顧客データ:各項目名
#		@kokyaku_inputcyuui		…顧客データ:入力時の注意コメント
#		@kokyaku_syousai		…顧客データ:詳細…時のフォーム初期入力各種データ
#		$search_houhou			…検索:検索方法(1…顧客検索 2…履歴検索)
#		$search_keyword			…検索:実際に検索するキーワード
#		$system_back			…機能実行:処理終了後･戻る処理番号
#		フォーム:				(出力とダブるので省略)
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:	backpage				…機能終了後戻る各機能
#		フォーム:	bye						…この顧客データ削除?! 0…No 1…Yes
#		フォーム:	callno					…顧客履歴:呼び出しID
#		フォーム:	html_sw					…呼び出された(す)各機能
#		フォーム:	input_kokyakudata?		…各入力されたデータ
#		フォーム:	kanrimode_check			…管理者モード:セキュリティー用パスワード
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word		…検索：前回検索したキーワード
sub html_syousai_check {
	local(@formbutton_word);	#フォームの入力ボタンに表示する文字
	
	#フォームの各値引渡し値修正
	$addlink[1]=$addlink[1]."<input type=hidden name=backpage value=$system_back>\n";
	$addlink[1]=$addlink[1]."<input type=hidden name=callno value=".$form{'callno'}.">\n";
	
	if($form{'bye'}!=1) {
		$formbutton_word[0]="0";
		$formbutton_word[1]=" この内容で登録する ";
		$formbutton_word[2]=" もう一度入力しなおす ";
	} else {
		$formbutton_word[0]=$form{'bye'};
		$formbutton_word[1]=" この内容を削除する ";
		$formbutton_word[2]=" もう一度選び直す ";
	}
	
	require'options_lib.pl';
		#フォームでメニュー選択時に表示する文字列群
	
	$output_html=$output_html."<form action=$file_main method=post>\n";
	if($form{'bye'}==1) {
		#削除確認ならメッセージを出す
		$output_html=$output_html."	<table width=70%><tr><td align=center bgcolor=red>\n";
		$output_html=$output_html."		<font color=white><b>以下のデータを削除してもよろしいですか？</b></font>\n";
		$output_html=$output_html."	</td></tr></table>\n";
	} elsif($form{'callno'}==-1) {
		#追加確認ならメッセージを出す
		$output_html=$output_html."	<table width=70%><tr><td align=center>\n";
		$output_html=$output_html."		<font color=black><b>以下のデータを新規追加してもよろしいですか？</b></font>\n";
		$output_html=$output_html."	</td></tr></table>\n";
		$output_html=$output_html."	<input type=hidden name=callno value=-1>\n";
	}
	
	$output_html=$output_html."<table border width=80%>\n";
	for($j=0;$j<=$#kokyaku_koumokuname;$j++) {
		$output_html=$output_html."	  <tr>\n";
		$output_html=$output_html."		<td align=left valign=top nowrap><b>$kokyaku_koumokuname[$j]：</b><font size=-2 color=#ff4444>$kokyaku_inputcyuui[$j]</font></td>\n";
		#データによってフィールドの形を変える
		$output_html=$output_html."		<td align=left valign=middle>";
		if($j==20||$j==21||$j==22||$j==27||$j==29) {
			local($k); #ループ用
			local(@option_message);		#メニューの各要素
			local($option_message2);	#呼び出すメニューの文字列
			
			&options($j);
				#フォームでメニュー選択時に表示する文字列群呼び出し
			
			$output_html=$output_html."		$option_message[$kokyaku_syousai[$j]]<input type=hidden name=input_kokyakudata$j value=$kokyaku_syousai[$j]>\n";
		} else {
			$output_html=$output_html."		$kokyaku_syousai[$j]<input type=hidden name=input_kokyakudata$j value='$kokyaku_syousai[$j]'>\n";
		}
		$output_html=$output_html."		</td>";
		$output_html=$output_html."	  </tr>\n";
	}
	$output_html=$output_html."	</table><br>\n";
	
	$output_html=$output_html."	\n";
	$output_html=$output_html."	<table><tr>\n";
	$output_html=$output_html."	  <td>\n";
	$output_html=$output_html."<input type=hidden name=html_sw value=4>\n";
	$output_html=$output_html."<input type=hidden name=bye value=$formbutton_word[0]>\n";
	$output_html=$output_html."<input type=submit value=$formbutton_word[1]>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	  <td><form action=$file_main method=post>";
	$output_html=$output_html."<input type=hidden name=html_sw value=2>\n";
	$output_html=$output_html."<input type=submit value=$formbutton_word[2]>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	</tr></table>\n";
}
1;
