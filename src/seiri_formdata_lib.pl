#--------------------------------------
#顧客管理DataBase用 フォームのデータ群を整理する
#&seiri_formdata()
#	入力：
#		@form…フォームから来たデータをそれぞれ分解したもの
#	出力:
#		@kokyaku_syousai	…顧客データ:詳細…時のフォーム初期入力各種データ
#		@kokyaku_data_menu	…顧客データ:顧客データメニュー部分での初期表示内容
sub seiri_formdata {
	local($i);	#ループ用
	local(@kokyaku_data_menu_fromform);
		#kokyaku_data_menuへフォームデータからの読み込み準備用
	local($fromform);	#フォームデータから呼び出し用の文字列
	
	$kokyaku_data_menu_fromform[0]=20;
	$kokyaku_data_menu_fromform[1]=21;
	$kokyaku_data_menu_fromform[2]=27;
	$kokyaku_data_menu_fromform[3]=29;
	
	for($i=0;$i<=$#kokyaku_koumokuname;$i++){
		$fromform="input_kokyakudata".$i;
		$kokyaku_syousai[$i]=$form{$fromform};
	}
	for($i=0;$i<=$#kokyaku_data_menu_fromform;$i++) {
		$fromform="input_kokyakudata".$kokyaku_data_menu_fromform[$i];
		$kokyaku_data_menu[$i]=$form{$fromform};
	}
}
1;
