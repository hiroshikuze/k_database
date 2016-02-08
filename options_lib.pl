#--------------------------------------
#顧客管理DataBase用 フォームでメニュー選択時に表示する文字列群
#&options($呼び出す項目)
#	出力:
#		@option_message…メニューの各要素
#		$option_message2…$kokyaku_data_menuの値に対応する呼び出すメニュー群
#			-1…この呼び出し項目はメニューとして表示するものでない
sub options {
	local($i) = @_;	#呼び出す項目
	local($j) = 1;	#返り値用
	
	if($i==-1) {
		$option_message2=-2;
		$option_message[0]="客先訪問(営業)";
		$option_message[1]="客先訪問(サポート)";
		$option_message[2]="TEL(会社 → 客)";
		$option_message[3]="TEL(客 → 会社)";
		$option_message[4]="FAX";
		$option_message[5]="E-Mail";
		$option_message[6]="出張PC教室";
		$option_message[7]="その他";
	} elsif($i==20) {
		$option_message2=0;
		$option_message[0]="−−不明−−";
		$option_message[1]="1億円未満";
		$option_message[2]="1〜3億円";
		$option_message[3]="3〜5億円";
		$option_message[4]="5〜10億円";
		$option_message[5]="10億円以上";
	} elsif($i==21) {
		$option_message2=1;
		$option_message[ 0]="−−不明−−";
		$option_message[ 1]="1〜9人";
		$option_message[ 2]="10〜29人";
		$option_message[ 3]="30〜49人";
		$option_message[ 4]="50〜99人";
		$option_message[ 5]="100〜299人";
		$option_message[ 6]="300〜499人";
		$option_message[ 7]="500〜999人";
		$option_message[ 8]="1000〜2999人";
		$option_message[ 9]="3000〜4999人";
		$option_message[10]="5000人以上";
	} elsif($i==22) {
		$option_message2=2;
		$option_message[ 0]="その他";
		$option_message[ 1]="製造業";
		$option_message[ 2]="商社／卸／小売業";
		$option_message[ 3]="サービス業";
		$option_message[ 4]="金融／証券／保険";
		$option_message[ 5]="建設／不動産";
		$option_message[ 6]="学校／教育機関";
		$option_message[ 7]="運輸／車輌";
		$option_message[ 8]="病院／医療機関";
		$option_message[ 9]="印刷／出版／放送／広告";
		$option_message[10]="農林／水産／鉱業";
		$option_message[11]="官公庁／協会／団体";
		$option_message[12]="通信／情報";
	} elsif($i==27) {
		$option_message2=3;
		$option_message[ 0]="アナログ";
		$option_message[ 1]="ISDNダイアルアップ";
		$option_message[ 2]="フレッツISDN";
		$option_message[ 3]="フレッツADSL";
		$option_message[ 4]="その他ADSL";
		$option_message[ 5]="CATV";
		$option_message[ 6]="FTTH";
		$option_message[ 7]="専用線";
	} elsif($i==29) {
		$option_message2=4;
		$option_message[ 0]="無し";
		$option_message[ 1]="有り";
		$option_message[ 2]="不明";
	} else {
		$option_message2=-1;
	}
}
1;
