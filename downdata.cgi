#!/usr/bin/perl

#-------------------------------------------------------------------------------
#顧客管理DataBase用Excelデータ変換 version 1.000
#	Copyright Hiroshi Kuze 2003.
#
#	Excel2000で、タブ区切りのCSVデータをロードしようとすると
#	動きが怪しくなるようなので、カンマ区切りに変換して出力します。
#	ExcelXP等は知らん！
#

#
# バージョン情報
local($version) = "顧客管理DataBase用Excel用データ変換version1.000";
	#バージョンを変えたときに変更してください

	#更新履歴
	#	ver 1.000
	#		顧客管理DataBase ver 0.901A に始めて付属


#
# 変数の説明その1 と 初期設定
local($comma) = '.';	#本来のデータにあったカンマを置き換える文字

#
# 変数の説明その2
	#ココは変更しないで下さい --
local($i);					#for用
local($url_ori) = 'http://kuze.tsukaeru.jp/tools/k_database/index.shtml';
		#顧客管理DataBase開発元ページ
local(@data);				#ロードしたファイルデータ
local($file_error);			#ファイルロード時のエラー
local($error_message_name);	#エラー時に表示されるエラー理由
	#ココまで ------------------

#
# 各種データ読み込み
require 'form_lib.pl';			#フォームからの情報を連想配列 %form に入れる

#
#フォームから来るデータを分解
require 'jcode.pl';
&init_form('euc');
		#フォームから来るデータについて
		#loadfile … どのファイルを変換するのか

#
# 他サイトへの移動をここで指定
if(length($form{'loadfile'})>0) {
	require 'file_access_lib.pl';
	
	chomp($form{'loadfile'});
	@data=&file_access("<$form{'loadfile'}",1);
	
	if($error_code==0) {
		#データ変換
		for($i=0;$i<=$#data;$i++) {
			&jcode::convert(\$data[$i], "sjis", "euc"); 
			$data[$i]=~ s/,/$comma/g;
			$data[$i]=~ s/\t/,/g;
		}
		$data[0]="";
		
		#で、データをサーバーからPCへ渡す
		print "Content-type: application/octet-stream; name=".$form{'loadfile'}."\n\n";
		print "@data";
	} else {
		#ファイルがロードできない
		$error_message_name="ファイル'".$form{'loadfile'}."'がロードできません。";
	}
} else {
	#index.cgiから来た場合は html で移動確認
	$error_message_name="ファイルが指定されずに呼び出されました。";
}

#
#ファイルエラーがあるならメッセージ表示
if(length($error_message_name)>0) {
print<<"OUTPUT_HTML";
Content-type: text/html

<html>
<head>
	<title>$version</title>
</head>
<body>
	<h1>$version</h1>
	<br>
	<font color=red>$error_message_name</font><br>
	<br>
	<br>
	どうしてもこのエラーが取れないときは、お手数ですが<br>
	<br>
	<a href=$url_ori>$url_ori</a><br>
	<br>
	からダウンロードし直して再インストールをお試しください。<br>
</body>
</html>
OUTPUT_HTML
}

	#終了
exit(0);
