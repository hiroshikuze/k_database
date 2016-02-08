#--------------------------------------
#ページの出力−対応履歴の編集画面
#&html_edit_taiou()
#	入力:
#		@addlink				…フォームの各値引渡値
#									[0]…アンカーによる値引渡し
#									[1]…フォームによる値引渡し
#									[2]…フォームによる値引渡し(改行除去)
#		$file_main				…メインルーチンを示したファイル名
#		$kanrimode_password		…管理者:セキュリティー用パスワード受け渡し用
#		$search_houhou			…検索:検索方法(1…顧客検索 2…履歴検索)
#		$search_keyword			…検索:実際に検索するキーワード
#		フォーム:	(出力とダブるので省略)
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:	callno					…顧客履歴:呼び出しID
#		フォーム:	html_sw					…呼び出された(す)各機能
#		フォーム:	kanrimode_check			…管理者モード:セキュリティー用パスワード
#		フォーム:	rireki_callno			…対応履歴:編集するのは履歴ID
#		フォーム:	rireki_command
#						…対応履歴:顧客データをどうするか 0…新規追加 1…削除 2…修正
#		フォーム:	rireki_inputid			…対応履歴:顧客ID登録
#		フォーム:	rireki_inputkokyaku		…対応履歴:顧客名登録
#		フォーム:	rireki_inputnaiyou		…対応履歴:対応内容登録
#		フォーム:	rireki_inputsyubetsu	…対応履歴:対応種別登録
#		フォーム:	rireki_inputtaiousya	…対応履歴:対応者登録
#		フォーム:	rireki_inputtime		…対応履歴:入力された時間
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word		…検索：前回検索したキーワード
sub html_edit_taiou {
	#フォームの各値引渡し値修正
	$addlink[1]=$addlink[1]."<input type=hidden name=callno value=$form{'callno'}>\n";
	$addlink[1]=$addlink[1]."<input type=hidden name=rireki_callno value=$form{'rireki_callno'}>\n";
	$addlink[1]=$addlink[1]."<input type=hidden name=rireki_inputid value=$form{'rireki_inputid'}>\n";
	
	#削除フォーム
	$output_html=$output_html."	<div align=center><form action=$file_main method=post>\n";
	$output_html=$output_html."<input type=submit value=' この履歴を削除する '>\n";
	$output_html=$output_html."<input type=hidden name=html_sw value=9>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."<input type=hidden name=rireki_command value=1>\n";
	$output_html=$output_html."	</form></div>\n";
	$output_html=$output_html."	<br>\n";
	
	#登録フォーム
	$output_html=$output_html."	<form action=$file_main method=post>\n";
	$output_html=$output_html."	<table border>\n";
	$output_html=$output_html."	<tr><td bgcolor=#ff2222 align=center><b><font color=white>＝　対応履歴の編集　＝</font></b></td></tr>\n";
	$output_html=$output_html."	<tr><td>\n";
	$output_html=$output_html."	  ■ 対応種別: \n";
	{
		local($k);	#ループ用
		local($option_selected);	#対応種別選択済み
		local(@option_message);		#メニューの各要素
		local($option_message2);	#呼び出す$kokyaku_data_menu
		
		require'options_lib.pl';
			#フォームでメニュー選択時に表示する文字列群
		
		&options(-1);
			#フォームでメニュー選択時に表示する文字列群呼び出し
		
		$output_html=$output_html."	  <select name=rireki_inputsyubetsu>\n";
		for($k=0,$option_selected=0;$k<=$#option_message;$k++){
			if(($form{'rireki_inputsyubetsu'} eq $option_message[$k]) || ($k==$#option_message && $option_selected==0)) {
				$output_html=$output_html."		<option value='$k' selected>$option_message[$k]</option>\n";
				$option_selected=1;
			} else {
				$output_html=$output_html."		<option value='$k'>$option_message[$k]</option>\n";
			}
		}
		$output_html=$output_html."	  </select>\n";
	}
	$output_html=$output_html."	  　 対応者:<input type=text name=rireki_inputtaiousya value=".$form{'rireki_inputtaiousya'}."><br>\n";
	$output_html=$output_html."	  　　投稿日時:<input type=text name=rireki_inputtime value='".$form{'rireki_inputtime'}."' size=23 maxlength=19><br>\n";
	$output_html=$output_html."	  対応(問い合わせ)内容:<br>\n";
	$output_html=$output_html."	  <div align=center><textarea type=text name=rireki_inputnaiyou rows=5 cols=80 warp=soft>$form{'rireki_inputnaiyou'}</textarea></div>\n";
	$output_html=$output_html."	  <input type=hidden name=rireki_inputkokyaku value=$form{'rireki_inputkokyaku'}>\n";
	$output_html=$output_html."	  <input type=hidden name=html_sw value=9>\n";
	$output_html=$output_html."	  <input type=hidden name=rireki_command value=2>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."	</td></tr>\n";
	$output_html=$output_html."	</table>\n";
	
	$output_html=$output_html."	<br><br>\n";
	
	$output_html=$output_html."	<div align=center><input type=submit value=' 履歴を修正して登録する '></div>\n";
	$output_html=$output_html."	</form>\n";
}
1;
