#!/usr/bin/perl

#-------------------------------------------------------------------------------
#顧客管理DataBase version 0.902D
#	(C)Copyright Hiroshi Kuze 2002-2005.
#

#
#バージョン情報
local($version) = "顧客管理データベース_version0.902DbyHiroshiKuze.";
	#バージョンを変えたときに変更してください

#
# 各種システム設定

local($file_main)="index.cgi";			#このメインシステムファイル名

local($file_config)="config.dat";		#管理者用設定ファイル名

local($file_kokyaku)="kokyaku.csv";		#顧客情報ファイル名
local($file_taiou)="taiou.csv";			#対応履歴ファイル名
local($file_kokyaku_bak)="kokyaku.bak";	#第1世代バックアップ顧客情報ファイル名
local($file_taiou_bak)="taiou.bak";		#第1世代バックアップ対応履歴ファイル名
local($file_sousa_rireki)="sousa_rireki.csv";
										#一部操作履歴ファイル

local($kanji_code)="euc";		#使用する漢字コードについて

local($kanrimode_crypt)="cr";		#管理者:セキュリティー用パスワード暗号作成値
local($kanrimode_name)="管理者";	#管理者:メール一斉送信時に登録する対応(投稿)者
local($kanrimode_send)="一斉送信";	#管理者:メール一斉送信時に登録する対応種別
local($view_start)=5;			#最新順:起動時に記録の上から表示する件数･無設定時
local($view_rirekistart)=5;	#対応履歴:一度に表示する件数

local($mailer_demolock)=1;	#メール:送信ボタンを押したら本当に送信するの？
								#0…Yes 1…No
local($mailer_pass)="sendmane.exe";		#メール:semdmailもしくは、その互換までのパス
local($mailer_ownaddress)="kuze_work3\@hotmail.com";
							#メール:管理者のアドレス(ココは必ず変更してください！)

#
# 広域変数設定
local(@config);				#設定データ群(長いので省略)
local($edit_id)=0;			#詳細･修正･追加･削除:見るID
local($edit_inputerror)="";	#詳細･修正･追加･削除:追加の際でのトラブルで戻っているのか？
local($error_code)=0;		#エラー:エラーコード
local($error_file);			#エラー:エラーを引き起こしたファイル名
local($error_htmlplus)="";	#エラー:HTML出力時の追加メッセージ
local($error_search)=0;		#エラー:検索失敗について
								#0…成功 1…キーワード未入力 2…キーワード発見できず
local(@form_oktag)=0;		#フォームデータからそのまま利用するタグについて
	#後に文字列が続かない場合は&gt;で加えて閉じていってください
	$form_oktag[ 0]="&lt;font";			#フォント指定
	$form_oktag[ 1]="&lt;strong&gt;";	#太字
	$form_oktag[ 2]="&lt;b&gt;";		#太字
	$form_oktag[ 3]="&lt;em&gt;";		#傾き
	$form_oktag[ 4]="&lt;i&gt;";		#傾き
	$form_oktag[ 5]="&lt;u&gt;";		#アンダーライン
	$form_oktag[ 6]="&lt;del&gt;";		#字消し＋α
	$form_oktag[ 7]="&lt;s&gt;";		#字消し
	$form_oktag[ 8]="&lt;strike&gt;";	#字消し
	$form_oktag[ 9]="&lt;ruby&gt;";		#ルビ関連
	$form_oktag[10]="&lt;rt&gt;";		#ルビ関連
	$form_oktag[11]="&lt;rp&gt;";		#ルビ関連
	$form_oktag[12]="&lt;div";			#位置指定
	$form_oktag[13]="&lt;center&gt;";	#位置指定
	$form_oktag[14]="&lt;a";			#アンカ
local($kanrimode_password);	#管理者:セキュリティー用パスワード受け渡し用
local($kanrimode_passwordkari);
							#管理者:セキュリティー用パスワード受け渡し用仮
local(@kanrimode_rireki);	#管理者:一部操作履歴生データ
local($kanrimode_sw)=0;		#管理者:モードのOFF/ON
								#0=OFF 1=ON 2=OFF(Password error) 3=OFF(不正アクセス)
local($reload_url);			#顧客管理データベースの読み直し
local($search_keyword);		#検索:実際に検索するキーワード
local($search_houhou);		#検索:検索方法(1…顧客検索 2…履歴検索)
local($system_loop)=0;		#機能実行:処理終了後･他処理も実行するのか？
local($system_back)=0;		#機能実行:処理終了後･戻る処理番号
local($sw)=0;				#フォームデータからの機能切り替え
local(@view_kokyaku);		#最新順&検索結果:該当表示する顧客データか?(0…No 1…Yes)
local(@view_rireki);		#対応履歴:該当表示する履歴データか?(0…No 1…Yes)

local(@rireki_data);			#履歴データ:生
local(@rireki_koumokuname);		#履歴データ:各項目名
	$rireki_koumokuname[0]="履歴ID";
	$rireki_koumokuname[1]="顧客ID";
	$rireki_koumokuname[2]="顧客名";	#表示用
	$rireki_koumokuname[3]="投稿日時";
	$rireki_koumokuname[4]="対応(投稿)者";
	$rireki_koumokuname[5]="対応種別";
	$rireki_koumokuname[6]="投稿内容";
local($rireki_viewall)=0;		#履歴データ:この会社IDで該当表示する内容は何件か？
local(@kokyaku_data);			#顧客データ:生
local(@kokyaku_data_menu);		#顧客データ:顧客データメニュー部分での初期表示内容
local(@kokyaku_inputcyuui);	#顧客データ:入力時の注意コメント
	$kokyaku_inputcyuui[ 0]="";
	$kokyaku_inputcyuui[ 1]="";
	$kokyaku_inputcyuui[ 2]="";
	$kokyaku_inputcyuui[ 3]="";
	$kokyaku_inputcyuui[ 4]="";
	$kokyaku_inputcyuui[ 5]="";
	$kokyaku_inputcyuui[ 6]="";
	$kokyaku_inputcyuui[ 7]="";
	$kokyaku_inputcyuui[ 8]="";
	$kokyaku_inputcyuui[ 9]="";
	$kokyaku_inputcyuui[10]="<br>(半角数字と'-'（ハイフン)で) <a href='http://search.post.yusei.go.jp/7zip/'>郵便番号検索</a>";
	$kokyaku_inputcyuui[11]="";
	$kokyaku_inputcyuui[12]="<br>(半角数字と'-'（ハイフン)で) <a href='http://search.post.yusei.go.jp/7zip/'>郵便番号検索</a>";
	$kokyaku_inputcyuui[13]="";
	$kokyaku_inputcyuui[14]="<br>(半角数字と'-'（ハイフン)で)";
	$kokyaku_inputcyuui[15]="<br>(半角数字と'-'（ハイフン)で)";
	$kokyaku_inputcyuui[16]="<br>(半角英数字と'\@'(アットマーク)で)";
	$kokyaku_inputcyuui[17]="";
	$kokyaku_inputcyuui[18]="<br>(半角数字と'/'(スラッシュ)で)";
	$kokyaku_inputcyuui[19]="<br>（半角数字のみで単位は万）";
	$kokyaku_inputcyuui[20]="";
	$kokyaku_inputcyuui[21]="";
	$kokyaku_inputcyuui[22]="";
	$kokyaku_inputcyuui[23]="";
	$kokyaku_inputcyuui[24]="";
	$kokyaku_inputcyuui[25]="";
	$kokyaku_inputcyuui[26]="";
	$kokyaku_inputcyuui[27]="";
	$kokyaku_inputcyuui[28]="<br>（半角数字のみ）";
	$kokyaku_inputcyuui[29]="";
	$kokyaku_inputcyuui[30]="";
	$kokyaku_inputcyuui[31]="";
	$kokyaku_inputcyuui[32]="";
local(@kokyaku_koumokuname);	#顧客データ:各項目名
	$kokyaku_koumokuname[ 0]="ID";
	$kokyaku_koumokuname[ 1]="屋号";
	$kokyaku_koumokuname[ 2]="会社名";
	$kokyaku_koumokuname[ 3]="会社名ふりがな";
	$kokyaku_koumokuname[ 4]="\代\表\者";
	$kokyaku_koumokuname[ 5]="\代\表\者ふりがな";
	$kokyaku_koumokuname[ 6]="役職";
	$kokyaku_koumokuname[ 7]="担当者";
	$kokyaku_koumokuname[ 8]="担当者ふりがな";
	$kokyaku_koumokuname[ 9]="担当者役職";
	$kokyaku_koumokuname[10]="住所-郵便番号";
	$kokyaku_koumokuname[11]="住所-名前";
	$kokyaku_koumokuname[12]="書類など送付先-郵便番号";
	$kokyaku_koumokuname[13]="書類など送付先-名前";
	$kokyaku_koumokuname[14]="TEL";
	$kokyaku_koumokuname[15]="FAX";
	$kokyaku_koumokuname[16]="E-Mail";
	$kokyaku_koumokuname[17]="登記住所";
	$kokyaku_koumokuname[18]="登記年月日";
	$kokyaku_koumokuname[19]="資本金";
	$kokyaku_koumokuname[20]="年商";
	$kokyaku_koumokuname[21]="従業員";
	$kokyaku_koumokuname[22]="業種";
	$kokyaku_koumokuname[23]="事業内容";
	$kokyaku_koumokuname[24]="プロバイダ名";
	$kokyaku_koumokuname[25]="Website";
	$kokyaku_koumokuname[26]="サーバー";
	$kokyaku_koumokuname[27]="回線種別";
	$kokyaku_koumokuname[28]="PC台数";
	$kokyaku_koumokuname[29]="LAN環境";
	$kokyaku_koumokuname[30]="営業担当者名";
	$kokyaku_koumokuname[31]="備考";
	$kokyaku_koumokuname[32]="主な商材";
local(@kokyaku_syousai);		#顧客データ:詳細…時のフォーム初期入力各種データ
local(@taiou_koumokuname);	#対応データ:各項目名
	$taiou_koumokuname[0]="履歴ID";
	$taiou_koumokuname[1]="顧客ID";
	$taiou_koumokuname[2]="顧客名";
	$taiou_koumokuname[3]="投稿日";
	$taiou_koumokuname[4]="投稿者";
	$taiou_koumokuname[5]="対応種別";
	$taiou_koumokuname[6]="投稿内容";

#
#メインルーチン
	#必須サブルーチン群ロード
require 'form_lib.pl';			#フォームからの情報を連想配列 %form に入れる
require 'jcode.pl';				#漢字コード変換
require 'file_access_lib.pl';	#ファイルの読み書き部分
require 'output_sub.pl';		#HTML出力部分

	#環境データの読み取りと設定
@config=&file_access("<$file_config",1);
if($error_file==0) {
	#注釈の除去
	local($i);			#ループ用文字列
	local($j);			#代理入力用行設定
	local(@config2);	#代理入力用文字列
	for($i=0,$j=0;$i<=$#config;$i++) {
		if(substr($config[$i],0,2) ne '//') {
			$config2[$j]=$config[$i];
			$j++;
		}
	}
	@config=@config2;
	
	#起動時などに表示される最近登録された件数の設定
	if($config[2]>0) {
		$view_start=$config[2];
	}
}
	#フォームから来るデータを分解
&init_form($kanji_code);

	#とりあえず各種値の設定
		#各機能への直接リンクがクリックされたかどうかについて
if(length($form{'html_sw'})>0) {
	$sw=$form{'html_sw'};
}
		#「詳細…」入力後どこのページへ戻されるのか？
if(length($form{'backpage'})>0) {
	$system_back=$form{'backpage'};
}
		#前回検索した方法の読み取り
if($form{'search_before_houhou'}>0) {
	$search_houhou=$form{'search_before_houhou'};
	$search_keyword=$form{'search_before_word'};
}
		#管理者モードのOn/Off受け渡し
$kanrimode_passwordkari=crypt($config[1],$kanrimode_crypt);
if(length($form{'kanrimode_check'})>0) {
	if($form{'kanrimode_check'} eq $kanrimode_passwordkari) {
		$kanrimode_sw=1;
		$kanrimode_password=$form{'kanrimode_check'};
		
		#一斉メール送信で送信リストに追加・削除するかどうか(ID番号で指定)
		if(length($form{'sendmail_addlist'})>0) {
			$form{$form{'sendmail_addlist'}}=1;
		} elsif(length($form{'sendmail_dellist'})>0) {
			delete $form{$form{'sendmail_dellist'}};
		} elsif($form{'sendmail_all'}==1) {
			#送信リスト全体を空に戻す
			local(@keys);	#ハッシュ内のキーリスト取得用
			local($i);		#ループ用
			
			@keys=keys %form;
			for($i=0;$i<=$#keys;$i++) {
				if(length($keys[$i])>0&&$keys[$i]!=0) {
					delete $form{$keys[$i]};
				}
			}
		} elsif($form{'sendmail_all'}==2) {
			#送信リストへ登録アドレス全て追加
			local($i);		#ループ用
			require 'tab_cut_lib.pl';
			
			if($#kokyaku_data==-1) {
				@kokyaku_data=&file_access("<$file_kokyaku",7);
			}
			for($i=1;$i<=$#kokyaku_data;$i++) {
				&tab_cut($kokyaku_data[$i]);
				$form{$cut_end[0]}=1;
			}
		}
	} else {
		$sw=8;
		$kanrimode_sw=3;
	}
}
		#管理者モード起動用のパスワードが入力された！
if($form{'myaction'} eq "kanrimode_change") {
	$sw=8;
}


	#各種機能の実行
if($error_code==0) {
	while($system_loop==0) {
		if($sw==0) {
			#最新順 ?件 について(初期画面)--------------------------------------
			
			require 'set_new_sub.pl';	#サブルーチン:最新順 ?件 について(初期画面)
			&set_new();
			
				#HTML出力に移動等
			$system_loop++;
			$system_back=0;
		} elsif($sw==1) {
			#検索結果-----------------------------------------------------------
			
			require 'search_sub.pl';	#サブルーチン:検索結果
			&search();
			
				#HTML出力に移動等
			$system_loop++;
			$system_back=1;
		} elsif($sw==2) {
			#詳細(･修正･追加･削除)情報表示--------------------------------------
			
			require 'syousai_sub.pl';
				#サブルーチン:詳細(･修正･追加･削除)情報表示
			&syousai();
			
				#HTML出力に移動等
			$system_loop++;
		} elsif($sw==3) {
			#修正･追加･削除確認-------------------------------------------------
			
			require 'edit_check_sub.pl';	#サブルーチン:修正･追加･削除確認
			&edit_check();
			
				#他の処理へは移るのか？
			if(length($edit_inputerror)>0) {
				#もし入力エラーがあるなら入力画面に戻る
				$sw=2;
				$edit_id=$form{'input_kokyakudata0'};
			} else {
				#エラーがないなら正式にデータ登録
				require 'seiri_formdata_lib.pl';	#フォームのデータ群を整理する
				&seiri_formdata();	#フォームのデータ群を整理する
				
				#HTML出力に移動等
				$system_loop++;
			}
		} elsif($sw==4) {
			#修正･追加･削除処理-------------------------------------------------
			
			require 'edit_save_sub.pl';	#サブルーチン:修正･追加･削除確認
			&edit_save();
			undef(@kokyaku_data);		#顧客データを一旦リセット
			
				#他の処理へ移る
			$sw=$system_back;
			$system_loop=0;
		} elsif($sw==5) {
			#管理者専用設定の現在の状態表示準備---------------------------------
			
			require 'master_edit_info_sub.pl';	#管理者機能の現在の状態表示準備
			&master_edit_info();
			
				#HTML出力に移動等
			$system_back=5;
			$system_loop++;
		} elsif($sw==6) {
			#管理者専用設定確認-------------------------------------------------
			
			require 'master_check_edit_sub.pl';	#管理者機能の確認表示準備
			&master_check_edit();
			
				#HTML出力に移動等
			$system_back=6;
			$system_loop++;
		} elsif($sw==7||$sw==12||$sw==14) {
			#管理者専用設定切り替え---------------------------------------------
			#兼、一部操作履歴設定切り替え---------------------------------------
			#兼、一斉メール送信設定切り替え-------------------------------------
			
			require 'master_setting_change_sub.pl';	#管理者専用設定切り替え
			if($sw==7) {&master_setting_change(0);}
			elsif($sw==12) {&master_setting_change(1);}
			elsif($sw==14) {&master_setting_change(2);}
			
				#管理者専用設定へ移る
			$sw=5;
		} elsif($sw==8) {
			#管理者モードのスイッチON/OFFについて-------------------------------
			
			require 'master_switch_sub.pl';
				#サブルーチン:管理者機能のスイッチON/OFFについて
			&master_switch();
			
				#HTML出力に移動等
			$system_back=0;	#詳細…を実行後もこのページへは戻らない
			$system_loop++;
		} elsif($sw==10) {
			#対応履歴の編集画面-------------------------------------------------
			
			require 'edit_rireki_sub.pl';
				#サブルーチン:対応履歴の編集画面
			&edit_rireki();
			
				#詳細表示へ戻る
			$system_back=2;	#詳細…を実行後もこのページへは戻らない
			$system_loop++;
		} elsif($sw==9) {
			#対応履歴の追加・編集結果保存---------------------------------------
			
			require 'save_rireki_sub.pl';
				#サブルーチン:対応履歴の追加・編集結果保存
			&save_rireki();
			
				#詳細表示へ戻る
			$sw=2;
			$system_loop=0;
		} elsif($sw==13||$sw==15) {
			#メール一斉送信−メール内容入力-------------------------------------
			#一斉メール送信内容確認($sw=15)-------------------------------------
			
			require 'edit_sendmail_naiyou_sub.pl';
				#サブルーチン:メール内容入力
			&edit_sendmail_naiyou();
			
				#詳細表示へ戻る
			$system_back=13;
			$system_loop++;
		} elsif($sw==16) {
			#メール一斉送信−メール送信-----------------------------------------
			
			require 'edit_sendmail_send_sub.pl';
				#サブルーチン:メール送信
			&edit_sendmail_send();
			
				#リロード準備
			$reload_url=$file_main;
			
				#管理者専用設定へ戻る
			$sw=5;
			$system_loop++;
		} else {
			#一部操作履歴の設定変更確認($sw=11)---------------------------------
			#メール一斉送信−メール送信履歴表示設定変更確認($sw=17)-------------
			
				#詳細表示へ戻る
			$system_back=$html_sw;
			$system_loop++;
		}
	}
}

	#エラーメッセージ
if($error_code>0) {
	$error_htmlplus=$error_htmlplus."<hr>\n";
	$error_htmlplus=$error_htmlplus."$version<br>\n";
	$error_htmlplus=$error_htmlplus."ERROR code $error_code.<br>\n";
	$error_htmlplus=$error_htmlplus."Can't open file '$error_file'.<br>\n";
	$error_htmlplus=$error_htmlplus."ファイル '$error_file' が読め(もしくは書き込め)ません.<br>\n";
	$error_htmlplus=$error_htmlplus."管理者もしくは開発元に問い合わせの上、問題を解決してから再度起動させてください。<br>\n";
	$error_htmlplus=$error_htmlplus."<hr>\n";
}

	#HTML出力
&output($sw);

	#終了
exit(0);
