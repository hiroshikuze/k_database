#!/usr/bin/perl

#-------------------------------------------------------------------------------
#顧客管理DataBase用DummyFile version 1.000
#	Copyright Hiroshi Kuze 2002-2003.
#	※このプログラムから外部へ移動することによって顧客管理データベース
#	からどうしても流出する、どのサイトから移動したのかを示す環境変数
#	HTTP_REFERERの値を除去します。
#

#
# バージョン情報
local($version) = "顧客管理DataBase用DummyFile_version1.000";
	#バージョンを変えたときに変更してください

	#更新履歴
	#	ver 1.000
	#		顧客管理DataBase ver 0.900F に始めて付属


#
# 変数の初期設定
$gokurou_url='http://kuze.tsukaeru.jp/tools/k_database/';
	#HTTP_REFERERを参考に直接来られた方を誘導するURL

#
# 各種データ読み込み
require 'form_lib.pl';			#フォームからの情報を連想配列 %form に入れる

	#フォームから来るデータを分解
require 'jcode.pl';
&init_form('euc');
		#フォームから来るデータについて
		#move_url … どのURLへ飛ばすのか

#
# 他サイトへの移動をここで指定
if(length($form{'move_url'})>0) {
	#顧客管理DataBaseから来られたなら
	local($i);			#ループ用
	local($moved);		#移動先
	local($key);		#フォームハッシュ解析用
	local($value);
	local($linked);		#移動先リンクに追加する情報
	
		#リンク情報作成
	$moved=$form{'move_url'};
	delete $form{'move_url'};
	$linked=$moved;
	$i=0;
	while(($key,$value)=each %form) {
		#URLエンコード
		$value =~ s/(\W)/'%'.unpack("H2", $1)/ego;
		$value =~ tr/ /+/;
		
		#アンカータグのフォーム部分作成
		if($i==0) {
			$linked=$linked."?".$key."=".$value;
		} else {
			$linked=$linked."&".$key."=".$value;
		}
		$i++;
	}
	
		#移動確認
	print "Content-type: text/html\n\n";
print <<"end";
<html>
<head>
	<title>$moved へ移動しますか？</title>
</head>
<body>
	<a href=$linked>$moved</a> へ移動しますか？<br>
	<br>
	<hr>
	<br>
	<a href=$linked>$linked</a><br>
	へ移動しようとしています。<br>
	<br>
	よろしければ <a href=$linked>こちらをクリック</a> ！。<br>
	<br>
	※そうでなければブラウザの［戻る］をクリックお願いします。<br>
</body>
</html>
end
} else {
	#HTTP_REFERERから辿られてきた場合強制移動
	print "Location: $gokurou_url\n\n";
}


	#終了
exit(0);
