#-------------------------------------------------------------------------------
#debug用仮出力関連サブルーチン ver 2002/03/08
#
#					Copyright	Hiroshi Kuze 2002.
#					Website		http://kuze.tsukaeru.jp/tools/requires/
#-------------------------------------------------------------------------------


#--------------------------------------
#debug用仮出力初期化
#&debug_reset()
#	入力:
#		特になし
#	出力:
#		特になし
sub debug_reset {
	local($output_filename)="debug.txt";	#テスト出力用ファイル名
	
	flock($output_filename,2);
	open(DATA,">$output_filename");
		print DATA "";
	close(DATA);
	flock($output_filename,8);
}

#--------------------------------------
#debug用仮出力部分
#&debug_output($output_comment)
#	入力:
#		$output_comment…新たに挿入するテキスト
#	出力:
#		変数としては特になし
sub debug_output {
	local($output_filename)="debug.txt";	#テスト出力用ファイル名
	local($output_comment)=@_;				#新たに挿入するテキスト
	local(@output_text);					#出力用テキスト
	local(@output_originaltext);			#元々のテスト出力用ファイル内容
	local($i);								#ループ用
	
	$output_text[0]=$output_comment."\n\n";
	flock($output_filename,2);
	open(DATA,"<$output_filename");
		@output_originaltext=<DATA>;
	close(DATA);
		
		for($i=0;$i<=$#output_originaltext;$i++) {
			$output_text[$i+1]=$output_originaltext[$i];
		}
		
	open(DATA,">$output_filename");
		print DATA @output_text;
	close(DATA);
	flock($output_filename,8);
}
1;
