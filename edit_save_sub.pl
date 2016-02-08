#--------------------------------------
#修正･追加･削除処理
#&edit_save()
#	入力:
#		$error_code					…エラー:エラーコード
#		$file_kokyaku				…顧客情報ファイル名
#		$file_kokyaku_bak			…第1世代バックアップ顧客情報ファイル名
#		$file_taiou					…対応履歴ファイル名
#		$file_taiou_bak				…第1世代バックアップ顧客情報ファイル名
#		$form{'bye'}					…この顧客データ削除?! 0…No 1…Yes
#		$form{'callno'}				…顧客履歴:呼び出しID(ここでは追加判定に利用)
#		$form{'input_kokyakudata?'}	…フォーム:各入力されたデータ
#		$kokyaku_koumokuname		…顧客データ:各項目名
#		$version					…バージョン情報
#	出力:
#		$error_code		…エラー:エラーコード
#		@kokyaku_data	…顧客データ:生
#		@rireki_data	…履歴データ:生
sub edit_save {
	local($i);				#ループ用
	local($error_sw1)=0;	#エラー:編集したい会社はデータにまだあるか？(0…No 1…Yes)
	local($kanri_title)="顧客データの修正･追加･削除処理";
							#一部操作履歴:報告用タイトル
	
	#サブルーチン群ロード
	require 'tab_cut_lib.pl';			#文字列をタブ単位でバラバラにする
	require 'save_kanri_rireki_lib.pl';	#対応履歴の追加・編集結果保存
	require 'seiri_formdata_lib.pl';	#フォームのデータ群を整理する
	
	#必要データ類ファイルダウンロード
	
	#顧客情報の読み取り
	@kokyaku_data=&file_access("<$file_kokyaku",4);
	
	if($error_code==0) {
		
		#顧客データのバックアップ
		&file_access(">$file_kokyaku_bak",6,0,@kokyaku_data);
		
		if($form{'callno'}!=-1) {
			#IDチェック−登録のものと同IDがあれば削除
			for($i=0;$i<=$#kokyaku_data;$i++) {
				&tab_cut($kokyaku_data[$i]);
				if($cut_end[0]==$form{'input_kokyakudata0'}) {
					#一部操作履歴:削除の報告
					local($comment);	#内容
					$comment=$kokyaku_data[$i];
					$comment=~s/\n//g;
					$comment=~s/\t/　/g;
					&save_kanri_rireki($kanri_title,"以下のデータを削除しました。<br><br><font size=-2>$comment</font><br>");
					
					$error_sw1=1;
				}
				$kokyaku_data[$i]=$kokyaku_data[$i+$error_sw1];
			}
			if($error_sw1==1) {
				undef($kokyaku_data[$#kokyaku_data]);
			} else {
				$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'input_kokyakudata2'}." は別の人物によって削除されていました。<br>その為先程の変更・削除操作は完了できませんでした。</b></font><br>";
			}
		}
	}
	
	if($form{'bye'}==1) {
		#削除指定で来ている→該当履歴データも削除
		
		local(@rireki_data2);	#保存データ準備
		local($j);				#保存データ指定用
		
		#履歴データの読み取り
		@rireki_data=&file_access("<$file_taiou",12);
		
		#履歴データのバックアップ
		&file_access(">$file_taiou_bak",13,0,@rireki_data);
		
		if($error_code==0) {
			$rireki_data2[0]=$rireki_data[0];
			for($i=1,$j=1;$i<=$#rireki_data;$i++) {
				&tab_cut($rireki_data[$i]);
				
				if($cut_end[1]!=$form{'input_kokyakudata0'}) {
					$rireki_data2[$j]=$rireki_data[$i];
					$j++;
				}
			}
		}
		
		#履歴データの書き込み
		&file_access(">$file_taiou",14,$config[6],@rireki_data2);
	}
	
	if($form{'callno'}==-1) {
		#新規追加で来ている
		
			#時刻入れ
		local($sec);
		local($min);
		local($hour);
		local($day);
		local($mon);
		local($year);
		local($null);
		
		$error_sw1=1;	#編集したい会社はデータに存在すると認識させる
		
			#IDの割り振り
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
		$mon=$mon+1;
		$year=$year+1900;
		$form{'input_kokyakudata0'}=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
	}
	
	#データの編集と保存
	if($error_sw1==1&&$error_code==0) {
		#そもそもデータを置き換えていいのか？
			#現在の時刻入れ
		local($sec);
		local($min);
		local($hour);
		local($day);
		local($mon);
		local($year);
		local($null);
		local($now_total);	#現在の時刻値
		local(@file_info);	#顧客ファイル情報
		local($file_total);	#顧客ファイル最終保存時刻値
		
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
		$mon=$mon+1;
		$year=$year+1900;
		$now_total=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
		@file_info=stat $systemfile;
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime $file_info[9];
		$mon=$mon+1;
		$year=$year+1900;
		$file_total=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
		if($now_total!=$file_total) {
			
			$kokyaku_data[0]=$kokyaku_koumokuname[0];
			for($i=1;$i<=$#kokyaku_koumokuname;$i++) {
				$kokyaku_data[0]=$kokyaku_data[0]."	".$kokyaku_koumokuname[$i];
			}
			$kokyaku_data[0]=$kokyaku_data[0]."	$version\n";
			
			if($form{'bye'}!=1){
				#データの追加と編集
				local($j);	#書き込み位置設定用
				local($k);	#フォームデータ読み取り用
				local(@option_message);		#メニューの各要素
				local($option_message2);
					#$kokyaku_data_menuの値に対応する呼び出すメニュー群
				
				require 'options_lib.pl';
					#顧客管理DataBase用 フォームでメニュー選択時に表示する文字列群
				
				$j=$#kokyaku_data+1;
				$kokyaku_data[$j]=$form{'input_kokyakudata0'};
				for($i=1;$i<=$#kokyaku_koumokuname;$i++) {
					&options($i);
					$k="input_kokyakudata".$i;
					if($option_message2==-1) {
						#メニュー項目でないものなら
						chomp($form{$k});
						$form{$k}=~ s/\r//g;
						$kokyaku_data[$j]=$kokyaku_data[$j]."	".$form{$k};
					} else {
						#メニュー項目なら
						$kokyaku_data[$j]=$kokyaku_data[$j]."	".$option_message[$form{$k}];
					}
				}
				$kokyaku_data[$j]=$kokyaku_data[$j]."\n";
				
				#一部操作履歴:追加・編集の報告
				local($comment);	#内容
				$comment=$kokyaku_data[$j];
				$comment=~s/\n//g;
				$comment=~s/\t/　/g;
				&save_kanri_rireki($kanri_title,"以下のデータを追加(又は編集)しました。<br><br><font size=-2>$comment</font><br>");
			}
			
			#顧客データの書き込み
			&file_access(">$file_kokyaku",5,0,@kokyaku_data);
		} else {
			$edit_inputerror=$edit_inputerror."<font color=red><b>別の人物により同時刻に書き込みが行われました。<br>このソフトは1秒間に2件以上の書き込み処理はできません。<br>その為先程の変更・削除操作は完了できませんでした。</b></font><br>";
		}
	}
}
1;
