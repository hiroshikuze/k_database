#--------------------------------------
#ページの出力−詳細(･修正･追加･削除)情報表示
#&html_syousai_info()
#	入力:
#		@addlink				…フォームの各値引渡値
#									[0]…アンカーによる値引渡し
#									[1]…フォームによる値引渡し
#									[2]…フォームによる値引渡し(改行除去)
#		$edit_id				…詳細･修正･追加･削除:見るID
#		$edit_inputerror		…詳細･修正･追加･削除:追加の際でのトラブルで戻っている？
#		$file_main				…メインルーチンを示したファイル名
#		$html_sw				…表示内容の切り替え
#		$kanrimode_password		…管理者:セキュリティー用パスワード受け渡し用
#		@kokyaku_koumokuname	…顧客データ:各項目名
#		@kokyaku_inputcyuui		…顧客データ:入力時の注意コメント
#		@kokyaku_syousai		…顧客データ:詳細…時のフォーム初期入力各種データ
#		@rireki_data			…履歴データ:生(出力用に一部加工)
#		@rireki_koumokuname		…履歴データ:各項目名
#		$rireki_viewall			…履歴データ:この会社IDで該当表示する内容は何件か？
#		$search_houhou			…検索:検索方法(1…顧客検索 2…履歴検索)
#		$search_keyword			…検索:実際に検索するキーワード
#		$system_back			…機能実行:処理終了後･戻る処理番号
#		@view_rireki			…対応履歴:該当表示する履歴データか?(0…No 1…Yes)
#		$view_rirekistart		…対応履歴:一度に表示する件数
#		フォーム:				(出力とダブるので省略)
#	出力:
#		$output_html	…HTML追加出力用
#		フォーム:	backpage				…機能終了後戻る各機能
#		フォーム:	callno					…顧客履歴:呼び出しID
#		フォーム:	html_sw					…呼び出された(す)各機能
#		フォーム:	input_kokyakudata?		…各入力されたデータ
#		フォーム:	kanrimode_check			…管理者モード:セキュリティー用パスワード
#		フォーム:	rireki_callno			…対応履歴:編集するのは履歴ID
#		フォーム:	rireki_command			…対応履歴:顧客データをどうするか
#												0…新規追加 1…削除 2…修正
#		フォーム:	rireki_inputkokyaku		…対応履歴:顧客名登録
#		フォーム:	rireki_inputid			…対応履歴:顧客ID登録
#		フォーム:	rireki_inputnaiyou		…対応履歴:対応内容登録
#		フォーム:	rireki_inputsyubetsu	…対応履歴:対応種別登録
#		フォーム:	rireki_inputtaiousya	…対応履歴:対応者登録
#		フォーム:	rireki_inputtime		…対応履歴:入力された時間
#		フォーム:	rireki_viewpage			…対応履歴:見ているページについて
#		フォーム:	search_before_houhou
#						…検索：前回検索した方法 1…顧客検索 2…履歴検索
#		フォーム:	search_before_word		…検索：前回検索したキーワード
sub html_syousai_info {
	local($j);	#ループ制御用
	
	if($form{'callno'}==-1) {
		#新規追加なら
		$output_html=$output_html."	<table width=70%><tr><td align=center bgcolor=#88ff88>\n";
		$output_html=$output_html."		<b>＝ サポートする会社の新規追加 ＝</b>\n";
		$output_html=$output_html."	</td></tr></table>\n";
	}
	
	
	$output_html=$output_html."	<table><tr>\n";
	
	
	#顧客データについて
	$output_html=$output_html."	  <td align=left valign=top><div align=center>\n";
	$output_html=$output_html."		<form action=$file_main method=post>\n";
	$output_html=$output_html."		<table border>\n";
	
	require'options_lib.pl';
		#フォームでメニュー選択時に表示する文字列群
	
	$output_html=$output_html."		  <tr><td colspan=2 align=center bgcolor=ffdddd><b>顧客データ</b></td></tr>\n";
	for($j=0;$j<=$#kokyaku_koumokuname;$j++) {
		$output_html=$output_html."		  <tr>\n";
		$output_html=$output_html."			<td align=left valign=top><b><font size=-1>$kokyaku_koumokuname[$j]：</font></b><font size=-2 color=#ff4444>$kokyaku_inputcyuui[$j]</font></td>\n";
		#データによってフィールドの形を変える
		$output_html=$output_html."			<td align=left valign=middle>";
		if($j==0) {
			if($form{'callno'}!=-1) {
				$output_html=$output_html.$edit_id."<input type=hidden name=input_kokyakudata0 value=$edit_id>";
			} else {
				$output_html=$output_html."<input type=hidden name=callno value=-1>";
				$output_html=$output_html."? 登録開始時に決定 ?<input type=hidden name=input_kokyakudata0 value='? 登録開始時に決定 ?'>";
			}
			$kokyaku_syousai[$j]=$edit_id;
		} elsif($j==20||$j==21||$j==22||$j==27||$j==29) {
			local($k); #ループ用
			local(@option_message);		#メニューの各要素
			local($option_message2);	#呼び出す$kokyaku_data_menu
			
			&options($j);
				#フォームでメニュー選択時に表示する文字列群呼び出し
			
			$output_html=$output_html."<select name=input_kokyakudata$j>\n";
			for($k=0;$k<=$#option_message;$k++){
				if($kokyaku_data_menu[$option_message2]==$k) {
					$output_html=$output_html."<option selected value='$k'>$option_message[$k]</option>\n";
				} else {
					$output_html=$output_html."<option value='$k'>$option_message[$k]</option>\n";
				}
			}
			$output_html=$output_html."</select>\n";
		} elsif($j==31||$j==32) {
			$kokyaku_syousai[$j]=~ s/&lt;br&gt;/\n/g;
			$output_html=$output_html."<textarea type=text name=input_kokyakudata$j rows=5 cols=30 warp=soft>$kokyaku_syousai[$j]</textarea>\n";
		} else {
			$output_html=$output_html."<input type=text name=input_kokyakudata$j value='$kokyaku_syousai[$j]' size=30>\n";
		}
		$output_html=$output_html."			</td>";
		$output_html=$output_html."		  </tr>\n";
	}
	$output_html=$output_html."		</table><br>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."<input type=hidden name=html_sw value=3>\n";
	$output_html=$output_html."<input type=hidden name=backpage value=$system_back>\n";
	$output_html=$output_html."<input type=submit value=' この内容で登録する '>\n";
	$output_html=$output_html."		</form>\n";
	$output_html=$output_html."	  </div></td>\n";
	
	
	#対応履歴について
	if($form{'callno'}!=-1) {
		$output_html=$output_html."	  <td align=left valign=top><div align=center>\n";
		
		#対応履歴の入力
		$output_html=$output_html."		<table border>\n";
		$output_html=$output_html."		<tr><td bgcolor=ffdddd align=center><b>対応履歴</b></td></tr>\n";
		$output_html=$output_html."		<tr><td><form action=$file_main method=post>\n";
		$output_html=$output_html."		  ■ 対応種別: \n";
		{
			local($k); #ループ用
			local(@option_message);		#メニューの各要素
			local($option_message2);	#呼び出す$kokyaku_data_menu
			
			&options(-1);
				#フォームでメニュー選択時に表示する文字列群呼び出し
			
			$output_html=$output_html."<select name=rireki_inputsyubetsu>\n";
			for($k=0;$k<=$#option_message;$k++){
				$output_html=$output_html."<option value='$k'>$option_message[$k]</option>\n";
			}
			$output_html=$output_html."</select>\n";
		}
		$output_html=$output_html."		<br>\n";
		$output_html=$output_html."　　対応者:<input type=text name=rireki_inputtaiousya value='$kokyaku_syousai[$j]' size=15><br>\n";
		$output_html=$output_html."		  対応(問い合わせ)内容:<br>\n";
		$output_html=$output_html."<div align=center><textarea type=text name=rireki_inputnaiyou rows=5 cols=40 warp=soft></textarea></div>\n";
		$output_html=$output_html."<input type=hidden name=callno value=$form{'callno'}>\n";
		$output_html=$output_html."<input type=hidden name=rireki_command value=0>\n";
		$output_html=$output_html."<input type=hidden name=rireki_inputid value=$edit_id>\n";
		$output_html=$output_html."<input type=hidden name=rireki_inputkokyaku value=$kokyaku_syousai[2]>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=html_sw value=9>\n";
		$output_html=$output_html."<div align=center><input type=submit value=' 履歴を登録する '></div>\n";
		$output_html=$output_html."		</form></td></tr>\n";
		$output_html=$output_html."		</table>\n";
		
		if($rireki_viewall>0) {
			#対応履歴の表示
			
			local($k)=0;		#表示個所についてカウント変数
			
			$addlink[0]=$addlink[0]."&html_sw=2&backpage=$html_sw&callno=".$form{'callno'};
			
			$output_html=$output_html."		<br>\n";
			$output_html=$output_html."		<b>現在 ".($form{'rireki_viewpage'}+1)." ページ目です。</b><br>\n";
			$output_html=$output_html."		<table border>\n";
			for($j=$#view_rireki;0<=$j;$j--) {
				if($view_rireki[$j]==1) {
					if($form{'rireki_viewpage'}*$view_rirekistart<=$k) {
						&tab_cut($rireki_data[$j]);
						
						$output_html=$output_html."		<tr><td>\n";
						$output_html=$output_html."		  <form action=$file_main method=post>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_callno value=$cut_end[0]>\n";
						$output_html=$output_html."		  <table width=100%><tr>\n";
						$output_html=$output_html."			<td align=left><b><font size=-1>$rireki_koumokuname[5]</font></b><br> $cut_end[5] </td>\n";
						$output_html=$output_html."			<td align=center><b><font size=-1>$rireki_koumokuname[4]:</font></b><br> $cut_end[4] </td>\n";
						$output_html=$output_html."			<td align=right><b><font size=-1>$rireki_koumokuname[3]:</font></b><br> $cut_end[3]</td>\n";
						$output_html=$output_html."		  </tr></table>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputsyubetsu value=$cut_end[5]>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputtaiousya value='".$cut_end[4]."'>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputtime value='".$cut_end[3]."'>\n";
						chomp($cut_end[6]);
						$output_html=$output_html."		  <font size=-1><br>\n";
						$output_html=$output_html."		  $cut_end[6]\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputnaiyou value='".$cut_end[6]."'\n";
						$output_html=$output_html."		  </font><br>\n";
						$output_html=$output_html."		  <div align=right><input type=submit value=' 履歴/編集・削除 '></div>\n";
						$output_html=$output_html."		  <input type=hidden name=callno value=$form{'callno'}>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputid value=$edit_id>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputkokyaku value=$kokyaku_syousai[2]>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_viewpage value=$form{'rireki_viewpage'}>\n";
						$output_html=$output_html."		  <input type=hidden name=html_sw value=10>\n";
						$output_html=$output_html.$addlink[1];
						$output_html=$output_html."		  </form>\n";
						$output_html=$output_html."		</td></tr>\n";
					}
					
					if($k==($form{'rireki_viewpage'}+1)*$view_rirekistart-1) {
						$j=0;
					} else {
						$k++;
					}
				}
			}
			$output_html=$output_html."		</table>\n";
			$output_html=$output_html."		<div align=right>";
			
			if($form{'rireki_viewpage'}>0) {
				local($k);			#前ページ表示用
				local($addlink_plus)="";#アンカへの値引渡書き込み各事項2
				
				$k=$form{'rireki_viewpage'}-1;
				$addlink_plus=$addlink[0]."&rireki_viewpage=$k";
				$output_html=$output_html."<a href='$file_main?$addlink_plus'>&lt;&lt;前のページへ</a> |";
			} else {
				$output_html=$output_html."<font color=#999999><s>&lt;&lt;前のページへ</s></font> |";
			}
			if(($form{'rireki_viewpage'}+1)*$view_rirekistart<$rireki_viewall) {
				local($k);	#次ページ表示用
				local($addlink_plus)="";#アンカへの値引渡書き込み各事項2
				
				$k=$form{'rireki_viewpage'}+1;
				$addlink_plus=$addlink[0]."&rireki_viewpage=$k";
				$output_html=$output_html." <a href='$file_main?$addlink_plus'>次のページへ&gt;&gt;</a>";
			} else {
				$output_html=$output_html." <font color=#999999><s>次のページへ&gt;&gt;</s></font>";
			}
			$output_html=$output_html."</div>\n";
		} else {
			$output_html=$output_html."		<br>\n";
			$output_html=$output_html."		<font color=red><b>この会社に該当する対応履歴は見つかりませんでした。</b></font><br>\n";
			$output_html=$output_html."		<br>\n";
		}
		$output_html=$output_html."	  </div></td>\n";
	}
	$output_html=$output_html."	</tr></table>\n";
}
1;
