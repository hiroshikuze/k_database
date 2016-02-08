#--------------------------------------
#ファイルの読み書き部分
#&file_access($filename,$output_errorcode,$lines,@savedata)
#	入力:
#		$error_code…エラー発生時に挿入する値
#		$fileaccess…呼び出し方とファイル名前
#		$lines…セーブ時に残す行
#			0,1…全部 2以上…1行目を除いて最終行から下x行残す
#		@savedata…セーブする値
#	出力:
#		出力値…データロード時に読み込んだ値
#		$error_code…エラー発生時に挿入する値
#		$error_file…呼び出し方とファイル名前
sub file_access {
	local($fileaccess,$error_code,$lines,@savedata)=@_;
							#ロードした各値値
	local(@output);			#データロード時に読み込んだ値
	local($filename);		#ファイル名
	
	$filename=substr($fileaccess,1,length($fileaccess)-1);
	flock($filename,2);
	if(open(DATA,"$fileaccess")==1)	{
		if(substr($fileaccess,0,1) eq '<') {
			#ロード時なら
			@output=<DATA>;
		} else {
			#セーブ時なら
			if($lines>1&&$#savedata>1) {
				local(@sub_savedata);
				local($i);
				local($j);
				
				$sub_savedata[0]=$savedata[0];
				$j=$#savedata-$lines;
				if($j<1) {$j=1;}
				for($i=1;$i<=$#savedata;$i++,$j++) {
					$sub_savedata[$i]=$savedata[$j];
				}
				undef @savedata;
				@savedata=@sub_savedata;
			}
			
			print DATA @savedata;
		}
		close(DATA);
	} else {
		$error_code=$output_errorcode;
		$error_file=$filename;
	}
	flock($filename,8);
	
	return(@output);
}
1;
