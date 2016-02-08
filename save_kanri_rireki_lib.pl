#--------------------------------------
#一部操作履歴の保存
#&save_kanri_rireki($record_koumoku,$record_comment)
#	入力変数:
#		@config…設定データ群
#		$file_sousa_rireki…一部操作履歴ファイル名 
#		$record_koumoku…(関数より指定)記録する項目
#		$record_comment…(関数より指定)記録内容
#		$version…システムバージョン情報
#	出力変数:
#		$error_code…エラー発生時に挿入する値
#		$error_file…エラーを引き起こしたファイル名
#		@kanrimode_rireki…管理者:一部操作履歴生データ
sub save_kanri_rireki {
	local($output_errorcode)=15;	#ファイルエラーが発生時に返すエラーコード
	local($record_koumoku,$record_comment)=@_;	#ロードした各値値
	
		#時刻の収納用
	local($year);
	local($mon);
	local($day);
	local($hour);
	local($min);
	local($sec);	#現在時間
	local($null);	#使用しない
	
	local($set);	#書き込み位置設定用
	
	#一部操作履歴の読み取り
	@kanrimode_rireki=&file_access("<$file_sousa_rireki",15);
	if($error_code==0) {
		#書き込み行位置読み込み
		$set=$#kanrimode_rireki;
		
		#現在の時刻データ収録
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
		$mon=$mon+1;
		$year=$year+1900;
		
		#ファイルが空ならコメント文をつける
		if($set<0) {
			$kanrimode_rireki[0]=$version." - 一部操作履歴\n";
			$set++;
		}
		
		#新規履歴の追加
		$set++;
		$kanrimode_rireki[$set]=sprintf("%d/%02d/%02d %02d:%02d:%02d	$record_koumoku	$record_comment\n",$year,$mon,$day,$hour,$min,$sec);
		
		#一定件数を過ぎたら削除
		$set++;
		if($set-2>$config[5]) {
			local(@temp_kanrimode_rireki);	#一部操作履歴生データ
			local($i);	#ループ用
			local($j);	#ループ用
			
			$temp_kanrimode_rireki[0]=$kanrimode_rireki[0];
			for($i=$set-$config[5],$j=2;$i-2<$#kanrimode_rireki;$i++,$j++) {
				$temp_kanrimode_rireki[$j]=$kanrimode_rireki[$i];
			}
			@kanrimode_rireki=@temp_kanrimode_rireki;
		}
		
		#ファイルへの保存
		&file_access(">$file_sousa_rireki",$output_errorcode,$config[5],@kanrimode_rireki);
	}
}
1;
