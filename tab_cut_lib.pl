#--------------------------------------
#文字列をタブ単位でバラバラにする。
#&tab_cut($対象の文字列)
#	出力:
#		$cut_end[]…ここにバラバラになった文字列が入ってきます。
#		$cut_end[]="end"…その前の文字列が最後のものでした。
#		$tab･･･対象の文字列に含まれるタブの数
sub tab_cut {
	local($cut_moji) = @_;	#入力文字列
	local($i);				#ループ用
	
	undef $cut_end[0];
	for($i=0,$tab=0;$i<length($cut_moji);$i++)	{
		local($k);	#文字判定用
		
		$k=substr($cut_moji,$i,1);
		if($k eq '	')	{
			$tab=$tab+1;
			undef $cut_end[$tab];
		} else {
			$cut_end[$tab]=$cut_end[$tab].$k;
		}
	}
	
	if(substr($cut_end[$tab],length($cut_end[$tab]),1)=="\n")	{
		$tab++;
	}
	$cut_end[$tab]="end";
}
1;
