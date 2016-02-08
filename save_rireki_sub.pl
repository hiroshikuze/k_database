#--------------------------------------
#対応履歴の追加・編集結果保存
#&save_rireki()
#	入力:
#		$file_taiou						…対応履歴ファイル名
#		$file_taiou_bak					…第1世代バックアップ対応履歴ファイル名
#		@rireki_koumokuname				…履歴データ:各項目名
#		$version						…バージョン情報
#		$form{''}						(出力とダブるので略)
#	出力:
#		@rireki_data					…履歴データ:生
#		$form{'rireki_command'}			…対応履歴:顧客データをどうするか
#											0…新規追加 1…削除 2…修正
#		$form{'rireki_inputid'}			…対応履歴:顧客ID登録
#		$form{'rireki_inputkokyaku'}	…対応履歴:顧客名登録
#		$form{'rireki_inputnaiyou'}		…対応履歴:対応内容登録
#		$form{'rireki_inputsyubetsu'}	…対応履歴:対応種別登録
#		$form{'rireki_inputtaiousya'}	…対応履歴:対応者登録
#		$form{'rireki_inputtime'}		…対応履歴:対応者登録
#		$form{'rireki_inputtaiousya'}		…対応履歴:対応者登録
sub save_rireki {
		#時刻の収納用
	local($year);
	local($mon);
	local($day);
	local($hour);
	local($min);
	local($sec);
	local($data_time);	#現在時間
	
	local($i);	#ループ用
	
		#一部操作履歴:報告用タイトル
	local($kanri_title)="対応履歴の追加・編集結果保存";
	
	require 'save_kanri_rireki_lib.pl';	#対応履歴の追加・編集結果保存
	
	#現在の時刻データ収録
	($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
	$mon=$mon+1;
	$year=$year+1900;
	$data_time=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
	
	#履歴データ読み取り
	@rireki_data=&file_access("<$file_taiou",9);
	
	#履歴データのバックアップ
	&file_access(">$file_taiou_bak",10,0,@rireki_data);
	
	#顧客情報の読み取り
	@kokyaku_data=&file_access("<$file_kokyaku",4);
	
	#顧客データのバックアップ
	&file_access(">$file_kokyaku_bak",6,0,@kokyaku_data);
	
	#データの追加
	if($error_code==0) {
		require 'options_lib.pl';
			#顧客管理DataBase用 フォームでメニュー選択時に表示する文字列群
		
		local($set);			#書き込み：位置設定用
		local($write_id);		#書き込み：履歴ID決定用
		local(@option_message);		#メニューの各要素
		local($option_message2);
			#$kokyaku_data_menuの値に対応する呼び出すメニュー群
		local($check_reload);	#リロードチェック
		
		#書き忘れなら適当に書きます
		if(length($form{'rireki_inputtaiousya'})<1) {
			$form{'rireki_inputtaiousya'}="不明";
		}
		if(length($form{'rireki_inputnaiyou'})<1) {
			$form{'rireki_inputnaiyou'}="ノーコメント";
		}
		
		#0行目の作成
		$rireki_data[0]=$rireki_koumokuname[0];
		for($i=1;$i<=$#rireki_koumokuname;$i++) {
			$rireki_data[0]=$rireki_data[0]."	".$rireki_koumokuname[$i];
		}
		$rireki_data[0]=$rireki_data[0]."	$version\n";
		
		#対応種別データの文字化
		&options(-1);
		$form{'rireki_inputsyubetsu'}=$option_message[$form{'rireki_inputsyubetsu'}];
		
		#改行文字を入れ替える
		chomp($form{'rireki_inputnaiyou'});
		$form{'rireki_inputnaiyou'}=~ s/\r\n/<br>/g;
		$form{'rireki_inputnaiyou'}=~ s/\n/<br>/g;
		$form{'rireki_inputnaiyou'}=~ s/"/\"/g;
		
		#書き込み位置の仮指定
		$set=$#rireki_data+2;
		
		#リロードチェック用データ用意
		require 'tab_cut_lib.pl';	#文字列をタブ単位でバラバラにする。
		&tab_cut($rireki_data[$#rireki_data]);
		$check_reload=sprintf("%s	%s	%s\n",$cut_end[4],$cut_end[5],$cut_end[6]);
		
		if($form{'rireki_command'}==0) {
			#追加書き込み
				#履歴IDの取得
			$write_id=($year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec)*100;
			
				#書き込み準備
			$form{'rireki_inputtime'}=sprintf("%d/%02d/%02d %02d:%02d:%02d",$year,$mon,$day,$hour,$min,$sec);
		} elsif($form{'rireki_command'}==1) {
			#削除のみをする場合
			
			local($j);			#ループ制御用
			local($sw_del)=0;	#邪魔履歴削除制御＆削除データがあるか？ 0=off 1=on
			
			for($j=1;$j<=$#rireki_data;$j++) {
				if($sw_del==1) {
					#スイッチ入っているなら古い履歴削除
					$rireki_data[$j]=$rireki_data[$j+1];
				} else {
					&tab_cut($rireki_data[$j]);
					if(index($cut_end[0],$form{'rireki_callno'})>-1) {
						#一部操作履歴:削除の報告
						local($comment);	#内容
						$comment=$rireki_data[$j];
						$comment=~s/\n//g;
						$comment=~s/\t/　/g;
						&save_kanri_rireki($kanri_title,"以下のデータを削除しました。<br><br><font size=-2>$comment</font><br>");
						
						#削除場所サーチ→スイッチオン
						$sw_del=1;
						$j--;
					}
				}
			}
			if($sw_del==0) {
				$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'rireki_inputtaiousya'}." さんの打ち込んだデータは別の人物によって削除されていました。<br>その為先程の変更・削除操作は完了できませんでした。</b></font><br>";
			} else {
				$rireki_data[$j]=undef;
			}
		} else {
			#修正していく場合
			local($j);					#ループ制御用
			local($sakujyo_syuusei)=0;	
				#削除と修正:	0=どっちもしてない 1=修正 2=削除 3=両方
			local($rireki2_syuusei);	#修正完了置き場:置き場指定
			local(@rireki2_data);		#修正完了置き場:生
			
			$write_id=0;
			$rireki2_data[0]=$rireki_data[0];
			for($j=1,$rireki2_syuusei=1;$j<=$#rireki_data;$j++,$rireki2_syuusei++) {
				&tab_cut($rireki_data[$j]);
				
				if($sakujyo_syuusei<3) {
					#修正場所サーチ
					if($sakujyo_syuusei<1) {
							#時刻の収納用
						local($year2);
						local($mon2);
						local($day2);
						local($hour2);
						local($min2);
						local($sec2);
						local($data_time2);	#その行に記されている時間
						local($data_time3);	#入力データに記された時間
						
						$year2=substr($form{'rireki_inputtime'},0,4);
						$mon2=substr($form{'rireki_inputtime'},5,2);
						$day2=substr($form{'rireki_inputtime'},8,2);
						$hour2=substr($form{'rireki_inputtime'},11,2);
						$min2=substr($form{'rireki_inputtime'},14,2);
						$sec2=substr($form{'rireki_inputtime'},17,2);
						$data_time2=$sec2+$min2*60+$hour2*60*60+$day2*60*60*24+$mon2*60*60*24*31+$year2*60*60*24*31*12;
						$year2=substr($cut_end[3],0,4);
						$mon2=substr($cut_end[3],5,2);
						$day2=substr($cut_end[3],8,2);
						$hour2=substr($cut_end[3],11,2);
						$min2=substr($cut_end[3],14,2);
						$sec2=substr($cut_end[3],17,2);
						$data_time3=$sec2+$min2*60+$hour2*60*60+$day2*60*60*24+$mon2*60*60*24*31+$year2*60*60*24*31*12;
						
						if($data_time2<=$data_time3) {
							$set=$j;
							$write_id=$form{'rireki_callno'};
							$sakujyo_syuusei=$sakujyo_syuusei+1;
							$rireki2_syuusei++;
						}
					}
					
					#削除場所サーチ
					if($cut_end[0]==$form{'rireki_callno'}) {
						$sakujyo_syuusei=$sakujyo_syuusei+2;
						$rireki2_syuusei--;
					}
				}
				
				#修正･削除済みデータを仮置き場に叩き込む
				$rireki2_data[$rireki2_syuusei]=$rireki_data[$j];
			}
			
			if($sakujyo_syuusei<2) {
				$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'rireki_inputtaiousya'}." さんの打ち込んだデータは別の人物によって削除されていました。<br>その為先程の変更・削除操作は完了できませんでした。</b></font><br>";
			}
			@rireki_data=undef;
			@rireki_data=@rireki2_data;
		}
		
		if($form{'rireki_command'}!=1) {
			local($comment);	#内容
			
			#削除でなければ修正データの設定
			$rireki_data[$set]=sprintf("%s	%s	%s	%s	%s	%s	%s",$write_id,$form{'rireki_inputid'},$form{'rireki_inputkokyaku'},$form{'rireki_inputtime'},$form{'rireki_inputtaiousya'},$form{'rireki_inputsyubetsu'},$form{'rireki_inputnaiyou'});
			$rireki_data[$set]=~ s/\r//g;
			$rireki_data[$set]=$rireki_data[$set]."\n";
			
			#一部操作履歴:追加・編集の報告
			$comment=$rireki_data[$set];
			$comment=~s/\n//g;
			$comment=~s/\t/　/g;
			&save_kanri_rireki($kanri_title,"以下のデータを追加(又は編集)しました。<br><br><font size=-2>$comment</font><br>");
		}
		
		#履歴データの書き込み
		if (index($rireki_data[$set],$check_reload)==-1||index($rireki_data[$set],"ノーコメント")>-1) {
			#リロードでなさそうなら
			
				#同時刻による２重以上書き込みチェック
			
				#時刻の収納用
			local($year2);
			local($mon2);
			local($day2);
			local($hour2);
			local($min2);
			local($sec2);
			local($data_time2);	#ファイル時間
			local(@file_info);	#履歴ファイル情報
			
			@file_info=stat $file_taiou;
			($sec2,$min2,$hour2,$day2,$mon2,$year2,$null) = localtime $file_info[9];
			$mon2=$mon2+1;
			$year2=$year2+1900;
			$data_time2=$sec2+$min2*60+$hour2*60*60+$day2*60*60*24+$mon2*60*60*24*31+$year2*60*60*24*31*12;
			
			if($data_time==$data_time2) {
				$edit_inputerror=$edit_inputerror."<font color=red><b>他の方も同時刻に瞬時の差で対応履歴登録されたため処理できませんでした。<br>間を見てもう一度お試しください。</b></font><br>";
			}
			
				#何もエラーが発生しないなら書き込み
			if(length($edit_inputerror)<1) {
				local($j);		#ループ用
				
				&file_access(">$file_taiou",11,$config[6],@rireki_data);
				
				#顧客情報の順番で、履歴データを変更した顧客を順番のトップへ並び替える
				for($i=$#kokyaku_data;0<$i;$i--) {
					&tab_cut($kokyaku_data[$i]);
					if($cut_end[0]==$form{'rireki_inputid'}) {
						local($left_kokyaku_data);		#顧客データの待避先
						
						$left_kokyaku_data=$kokyaku_data[$i];
						for($j=$i;$j<$#kokyaku_data;$j++) {
							$kokyaku_data[$j]=$kokyaku_data[$j+1];
						}
						$kokyaku_data[$#kokyaku_data]=$left_kokyaku_data;
						
						$i=$j;
					}
				}
				
				#顧客データの書き込み
				&file_access(">$file_kokyaku",5,0,@kokyaku_data);
			}
		}
	}
}
1;
