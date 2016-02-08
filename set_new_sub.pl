#--------------------------------------
#最新順 ?件 について(初期画面)
#&set_new()
#	入力:
#		$file_kokyaku			…顧客情報ファイル名
#		@kokyaku_data			…顧客データ
#		$view_start				…最新順:起動時に記録の上から表示する件数･無設定時
#		$form{'firstview_page'}	…最新順:何ページ目を見ているか
#	出力:
#		@view_kokyaku			…最新順&検索結果:該当表示する顧客データか?(0…No 1…Yes)
sub set_new {
	local($i);	#ループ用
	local($j);	#表示数制御用
	
	#必要データ類ファイルダウンロード
		#顧客データの読み取り
	if($#kokyaku_data==-1) {
		@kokyaku_data=&file_access("<$file_kokyaku",7);
	}
	
		#最新順を抜き出すようにする
	for($i=0;$i<$#kokyaku_data;$i++) {
		$view_kokyaku[$i]=1;
	}
}
1;
