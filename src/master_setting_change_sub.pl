#--------------------------------------
#管理者専用設定切り替え
#&master_setting_change($hyouji_sw)
#	入力:
#		$hyouji_sw								…(括弧内で指定)変更する内容の選択
#													0…管理者設定の変更に関して
#													1…一部操作履歴に関して
#													2…一斉メール送信
#		$file_config							…管理者用設定ファイル名
#		@config									…設定ファイル:生データ
#		$version								…バージョン情報
#		$form{'change_cut_mailissei_rireki'}	…変更指定:一部操作履歴と一斉メール送信履歴で以下省略する改行の数
#		$form{'change_info'}					…管理者からのお知らせ
#		$form{'change_leave_sousarireki'}		…一部操作履歴を何件まで残すか
#		$form{'change_pass'}					…パスワード
#		$form{'change_rireki_kazu'};			…対応履歴の保存件数
#		$form{'change_view'}					…最近入力された件数を何件づつ表示するか
#		$form{'change_view_mailissei_rireki'};	…一斉メール送信履歴の最初に表示する件数
#		$form{'change_view_sousarireki'}		…一部操作履歴の表示件数
#	出力:
#		@config					…設定データ群
#		$view_start				…最新順:起動時に記録の上から表示する件数･無設定時
sub master_setting_change {
	local($i);	#ループ用
	local(@save_data);	#セーブする内容
	local($record_koumoku)="管理者専用設定切り替え";	#一部操作履歴:記録する項目の定義
	
	#括弧内のデータ読み取り
	local($hyouji_sw)=@_;
	
	
	#データ定義
		#フォームデータからの読み出し
	$config[0]=$version." - config_file";				#最終作成バージョンデーター読み取り
	if($hyouji_sw==0) {
		#管理者設定の変更に関して
		$config[1]=$form{'change_pass'};					#パスワード
		$config[2]=$form{'change_view'};					#最近入力された件数を何件づつ表示するか
		$config[3]=$form{'change_info'};					#管理者からのお知らせ
		$config[6]=$form{'change_rireki_kazu'};				#対応履歴の保存件数
		
			#管理者からのお知らせをHTML形式で保存可能な状態にする
		chomp($config[3]);
		$config[3]=~ s/\r\n/<br>/g;
		$config[3]=~ s/\r//g;
		$config[3]=~ s/\n/<br>/g;
		$config[3]=~ s/"/\"/g;
	} elsif($hyouji_sw==1) {
		#一部操作履歴に関して
		$config[4]=$form{'change_view_sousarireki'};		#一部操作履歴の表示件数
		$config[5]=$form{'change_leave_sousarireki'};		#一部操作履歴を何件まで残すか
		$config[8]=$form{'change_cut_mailissei_rireki'};
									#一部操作履歴と一斉メール送信履歴で以下省略する改行の数
	} elsif($hyouji_sw==2) {
		$config[7]=$form{'change_view_mailissei_rireki'};	#一斉メール送信履歴の最初に表示する件数
		$config[8]=$form{'change_cut_mailissei_rireki'};
									#一部操作履歴と一斉メール送信履歴で以下省略する改行の数
	}
	
	#セーブ書式を読み取る
	@save_data=&file_access("<$file_config",1);
	if($error_file==0) {
		#注釈の除去
		local($i);			#ループ用文字列
		local($j);			#代理入力用行設定
		local(@config2);	#代理入力用文字列
		
		for($i=0,$j=0;$j<=$#config;$i++) {
			if(substr($save_data[$i],0,2) ne '//') {
				chomp($config[$j]);
				$config[$j]=$config[$j]."\n";
				$save_data[$i]=$config[$j];
				$j++;
			}
		}
		
		#設定保存
		&file_access(">$file_config",2,0,@save_data);
		
		for($i=0;$i<=$#save_data;$i++) {
			$save_data[$i]=~ s/\r//g;
			$save_data[$i]=~ s/\n/<br>/g;
		}
		require'save_kanri_rireki_lib.pl';
		&save_kanri_rireki($record_koumoku,"管理者専用設定ファイル '$file_config' を以下のように変更しました。<br><br><font size=-2>@save_data</font>");
	}
	
	#次の画面表示でもきちんと新設定変更値を表示させる
	$view_start=$config[2];
}
1;
