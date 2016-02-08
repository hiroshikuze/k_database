#--------------------------------------
#フォームからの情報を連想配列 %form に入れる
#&init_form(漢字コード)
#	入力変数:
#		@form_oktag	…フォームデータからそのまま利用するタグについて
#		フォーム群については省略
#	出力変数:
#		$form{'フォームで入力したname'}	…フォームから入力された内容
sub init_form {
	local($query, @assocarray, $assoc, $property, $value, $charcode, $method);
	$charcode = $_[0];
	$method = $ENV{'REQUEST_METHOD'};
	$method =~ tr/A-Z/a-z/;
	if ($method eq 'post') {
		read(STDIN, $query, $ENV{'CONTENT_LENGTH'});
	} else {
		$query = $ENV{'QUERY_STRING'};
	}
	@assocarray = split(/&/, $query);
	foreach $assoc (@assocarray) {
		local($i);	#ループ用
		
		($property, $value) = split(/=/, $assoc);
		$value =~ s/\+/ /g;
		$value =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
		&jcode'convert(*value, $charcode);
		
		#タグ対策
		if(index($value,"<")>-1) {
				#とりあえずタグ破壊
			$value =~ s/</&lt;/g;
			$value =~ s/>/&gt;/g;
			$value =~ s/'/\'/g;
				#@form_oktag で指定したタグのみ復活
			for($i=0;$i<=$#form_oktag;$i++) {
				local($okikae0);		#置き換え:置換対象文字
				local($okikae1);		#置き換え:置換完了文字
				local($tag_start);		#タグ:開始タグの数
				local($tag_end);		#タグ:終了タグの数
				
				if(index($value,$form_oktag[$i])>-1) {
					$value=$value." ";	#タグの数を正確に数える為に1文字足す
					
					#終了タグ
					if(index($form_oktag[$i],"&gt;")==-1) {
						$okikae0="$form_oktag[$i]&gt;";
						$okikae1="$form_oktag[$i]>";
					} else {
						$okikae0=$form_oktag[$i];
						$okikae1=$form_oktag[$i];
					}
					$okikae0=~ s/&lt;/&lt;\//g;
					$okikae1=~ s/&lt;/<\//g;
					$tag_end=split(/$okikae0/,$value)-1;
					$value =~ s/$okikae0/$okikae1/ig;
					
					#開始タグ
					$okikae0=$form_oktag[$i];
					$okikae1=$form_oktag[$i];
					$okikae1=~ s/&lt;/</g;
					$okikae1=~ s/&gt;/>/g;
					$tag_start=split(/$okikae0/,$value)-1;
					$value =~ s/$okikae0([^&]+)?(&gt;)?/$okikae1$1>/ig;
					
					$value=substr($value,0,length($value)-1);
										#最初に足した1文字を消す
					
					#終了タグの数が開始タグの数より少なければ付け足す
					if($tag_start>$tag_end) {
						local($j);			#ループ用
						local($putwords);	#付け足す文字列
						
						$putwords="$form_oktag[$i]>";
						$putwords=~ s/&gt;//g;
						$putwords=~ s/&lt;/<\//g;
						for($j=0;$j<$tag_start-$tag_end;$j++) {
							$value=$value.$putwords;
						}
					}
				}
			}
		}
		
		
		$form{$property} = $value;
	}
}
1;
