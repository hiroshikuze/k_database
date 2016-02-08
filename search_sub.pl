#--------------------------------------
#検索結果
#&search()
#	入力:
#		$file_kokyaku			…顧客情報ファイル名
#		$file_taiou				…対応履歴ファイル名
#		@kokyaku_data			…顧客データ
#		$search_houhou			…検索方法(1…顧客検索 2…履歴検索)
#		$form{'keyword_kokyaku'}…顧客データ検索キーワード
#		$form{'keyword_rireki'}	…履歴データ検索キーワード
#	出力:
#		$error_search			…エラー:検索失敗について
#									0…成功 1…キーワード未入力 2…キーワード発見できず
#		@kokyaku_data			…顧客データ:生
#		@rireki_data			…履歴データ:生
#		$search_houhou			…検索方法(1…顧客検索 2…履歴検索)
#		@view_kokyaku	…該当表示する顧客データか?(0…No 1…Yes)
#		@view_rireki	…該当表示する履歴データか?(0…No 1…Yes)
sub search {
	#サブルーチン群ロード
	require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする
	
	local($i);				#ループ用
	local(@search_data);	#検索ネタデータ収納先
	
	#顧客データの読み取り
	@kokyaku_data=&file_access("<$file_kokyaku",8);
	
	if(length($form{'keyword_kokyaku'})>0||$search_houhou==1) {
		#顧客データ検索準備
		@search_data=@kokyaku_data;
		
		#キーワードの設定
		if($search_houhou==0) {
			$search_keyword=$form{'keyword_kokyaku'};
		}
		$search_houhou=1;
	} elsif(length($form{'keyword_rireki'})>0||$search_houhou==2) {
		#履歴データ検索準備
			#履歴データの読み取り
		
		@rireki_data=&file_access("<$file_taiou",12);
		@search_data=@rireki_data;
		
			#キーワードの設定
		if($search_houhou==0) {
			$search_keyword=$form{'keyword_rireki'};
		}
		$search_houhou=2;
	} else {
		#キーワード未入力
		
		$search_houhou=0;
		$error_search=1;
	}
	
	if($error_code==0&&$error_search==0) {
		$error_search=2;
		
			#肝心の検索エンジン
		for($i=1;$i<=$#search_data;$i++) {
			if(index($search_data[$i],$search_keyword)>-1) {
				if($search_houhou==1) {
					#顧客検索の場合
					$view_kokyaku[$i-1]=1;
				} else {
					#履歴検索の場合
					$view_rireki[$i-1]=1;
				}
				$error_search=0;
			} else {
				if($view_kokyaku[$i]!=1) {
					$view_kokyaku[$i]=0;
				}
			}
		}
	}
}
1;
