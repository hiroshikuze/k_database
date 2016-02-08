#--------------------------------------
#修正･追加･削除確認
#&edit_check()
#	入力:
#		$form{'bye'}				…この顧客データ削除?! 0…No 1…Yes
#		$form{'input_kokyakudata?'}	…フォーム:各入力されたデータ
#		$file_kokyaku				…顧客情報ファイル名
#		$form{'callno'}				…顧客履歴:呼び出しID
#	出力:
#		$edit_inputerror	…詳細･修正･追加･削除:追加の際でのトラブルで戻っているのか？
#		@kokyaku_data		…顧客データ:生
#		$edit_id			…詳細･修正･追加･削除:見るID
#		$form{'*'}			…フォーム:各入力されたデータ
sub edit_check {
	if($form{'bye'}!=1) {
		#削除で指示でなければ
		
		#登録データの未入力・禁止文字使用のチェックと修正
		if($form{'input_kokyakudata1'} eq '') {
			$edit_inputerror=$edit_inputerror."屋号 が未入力です。<br>";
		}
		if($form{'input_kokyakudata2'} eq '') {
			$edit_inputerror=$edit_inputerror."会社名 が未入力です。<br>";
		}
		if($form{'input_kokyakudata4'} eq '') {
			$edit_inputerror=$edit_inputerror."\代\表\者名 が未入力です。<br>";
		}
		if($form{'input_kokyakudata10'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."住所-郵便番号 の入力値が異常です。<br>";
		}
		if($form{'input_kokyakudata12'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."書類など送付先-郵便番号 の入力値が異常です。<br>";
		}
		if($form{'input_kokyakudata14'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."TEL の入力値が異常です。<br>";
		}
		if($form{'input_kokyakudata15'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."FAX の入力値が異常です。<br>";
		}
		if($form{'input_kokyakudata16'} =~ /[^!-z]/) {
			$edit_inputerror=$edit_inputerror."E-Mail の入力値が異常です。<br>";
		}
		if($form{'input_kokyakudata18'} =~ /[^0-9\/]/) {
			$edit_inputerror=$edit_inputerror."登記年月日 の入力値が異常です。<br>";
		}
		if($form{'input_kokyakudata19'} =~ /[^0-9]/) {
			$edit_inputerror=$edit_inputerror."資本金 の入力値が異常です。<br>";
		}
		#フォームのデータ群を整理する
		if(length($form{'input_kokyakudata25'})>0) {
			if(index($form{'input_kokyakudata25'},"http://")==-1) {
				if(index($form{'input_kokyakudata25'},"https://")==-1) {
					if(index($form{'input_kokyakudata25'},"ftp://")==-1) {
						#websiteのURL入力に http:// などがない
						$form{'input_kokyakudata25'}="http://".$form{'input_kokyakudata25'};
					}
				}
			}
		}
		if($form{'input_kokyakudata28'} =~ /[^0-9]/) {
			$edit_inputerror=$edit_inputerror."PC台数 の入力値が異常です。<br>";
		}
		if(length($edit_inputerror)>0) {
			$edit_inputerror="	入力した値に以下の問題があります。<br><b><font color=red>".$edit_inputerror."</font></b><br>再度ご確認の上入力し直してください。<br>";
		}
		
		#改行文字を入れ替える
		chomp($form{'input_kokyakudata31'});
		$form{'input_kokyakudata31'}=~ s/\r\n/<br>/g;
		$form{'input_kokyakudata31'}=~ s/\n/<br>/g;
		$form{'input_kokyakudata31'}=~ s/"/\"/g;
		chomp($form{'input_kokyakudata32'});
		$form{'input_kokyakudata32'}=~ s/\r\n/<br>/g;
		$form{'input_kokyakudata32'}=~ s/\n/<br>/g;
		$form{'input_kokyakudata32'}=~ s/"/\"/g;
	} else {
		#削除で指示ならば
		
		local($i);	#ループ用
		
		#サブルーチン群ロード
		require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする
		
		#顧客データの読み取り
		@kokyaku_data=&file_access("<$file_kokyaku",7);
		
		#このデータだけを抜き出して表示するようにする
		for($i=1,$edit_id=-1;$i<=$#kokyaku_data;$i++) {
			&tab_cut($kokyaku_data[$i]);
			if($cut_end[0]==$form{'callno'}) {
				$edit_id=$i-1;
				$i=$#kokyaku_data;
			}
		}
		if($edit_id==-1) {
			$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'input_kokyakudata2'}." は別の人物によって、すでに削除されていました。</b></font><br>";
		} else {
			&tab_cut($kokyaku_data[$edit_id+1]);
			for($i=0;$i<=$#kokyaku_koumokuname;$i++) {
				local($j);	#フォーム入力用
				
				$j="input_kokyakudata".$i;
				$form{$j}=$cut_end[$i];
			}
		}
	}
}
1;
