#--------------------------------------
#詳細(･修正･追加･削除)情報表示
#&syousai()
#	入力:
#		$edit_inputerror		…追加の際でのトラブルでココへ戻っているのか？
#		$file_kokyaku			…顧客情報ファイル名
#		$file_taiou				…対応履歴ファイル名
#		$form{'rireki_inputid'}	…対応履歴:顧客ID登録
#		$form{'callno'}			…顧客履歴:呼び出しID
#	出力:
#		$edit_id			…見るID
#		@kokyaku_data		…顧客データ:生
#		@kokyaku_data_menu	…顧客データメニュー部分での初期表示内容
#		@kokyaku_syousai	…フォーム初期入力各種データ
#		@rireki_data		…履歴データ:生
#		$rireki_viewall=0	…履歴データ:この会社IDで該当表示する内容は何件か？
sub syousai {
	#HTML出力準備
	if(index($edit_inputerror,"未入力")>0) {
		#実はフォーム入力エラーでここへ戻ってきているなら
		
		require 'seiri_formdata_lib.pl';	#フォームのデータ群を整理する
		&seiri_formdata();	#フォームのデータ群を整理する
	} else {
		#普通にココへ来ているなら
		#必要データ類ファイルダウンロード
		
		#サブルーチン追加読み込み
		require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする
		
		#顧客データ読み取り
		local($i);	#ループ用
		
		@kokyaku_data=&file_access("<$file_kokyaku",3);
		
		if($form{'rireki_inputid'}>0) {
			$form{'rireki_inputid'}--;
			for($i=0;$i<=$#kokyaku_data;$i++) {
				&tab_cut($kokyaku_data[$i+1]);
				if($form{'rireki_inputid'}==$cut_end[0]) {
					$form{'callno'}=$i;
					$i=$#kokyaku_data;
				}
			}
		}
		
		#呼出し番号指定
		if($form{'callno'}==-1) {
			#新規作成の場合
			
			$kokyaku_syousai[31]="特になし・不明";
			$kokyaku_syousai[32]="特になし・不明";
		} else {
			#修正の場合
			
			local($i);	#ループ用
			local(@menu_settei);	#メニューデータ設定項目
			local(@option_message);		#メニューの各要素
			local($option_message2);
				#$kokyaku_data_menuの値に対応する呼び出すメニュー群
			
			$menu_settei[0]=20;
			$menu_settei[1]=21;
			$menu_settei[2]=22;
			$menu_settei[3]=27;
			$menu_settei[4]=29;
			
			require 'options_lib.pl';
				#フォームでメニュー選択時に表示する文字列群
			
			$edit_id=$form{'callno'};
			
			#参照データ検索
			for($i=1;$edit_id!=$cut_end[0];$i++) {
				&tab_cut($kokyaku_data[$i]);
			}
			
				#フォームデータ確定
			for($i=0;$i<=$#kokyaku_koumokuname;$i++) {
				$kokyaku_syousai[$i]=$cut_end[$i];
			}
			
			$edit_id=$kokyaku_syousai[0];
			
				#改行文字を入れ替える
			chomp($kokyaku_syousai[31]);
			$kokyaku_syousai[31]=~ s/<br>/\n/g;
			$kokyaku_syousai[31]=~ s/\"/"/g;
			chomp($kokyaku_syousai[32]);
			$kokyaku_syousai[32]=~ s/<br>/\n/g;
			$kokyaku_syousai[32]=~ s/\"/"/g;
			for($i=0;$i<=$#menu_settei;$i++) {
				local($j);
				
				&options($menu_settei[$i]);
				$kokyaku_data_menu[$i]=0;
				for($j=0;$j<=$#option_message;$j++) {
					if (index($cut_end[$menu_settei[$i]],$option_message[$j])>-1) {
						$kokyaku_data_menu[$i]=$j;
						$j=$#option_message;
					}
				}
			}
			
			#対応履歴表示準備
				#履歴データ読み取り
			@rireki_data=&file_access("<$file_taiou",9);
			
				#表示個所
			for($i=1,$rireki_viewall=0;$i<=$#rireki_data;$i++) {
				&tab_cut($rireki_data[$i]);
				if($edit_id==$cut_end[1]) {
					$view_rireki[$i]=1;
					$rireki_viewall++;
				} else {
					$view_rireki[$i]=0;
				}
			}
		}
	}
}
1;
