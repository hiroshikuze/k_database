#--------------------------------------
#�б�������ɲá��Խ������¸
#&save_rireki()
#	����:
#		$file_taiou						���б�����ե�����̾
#		$file_taiou_bak					����1����Хå����å��б�����ե�����̾
#		@rireki_koumokuname				������ǡ���:�ƹ���̾
#		$version						�ĥС���������
#		$form{''}						(���Ϥȥ��֤�Τ�ά)
#	����:
#		@rireki_data					������ǡ���:��
#		$form{'rireki_command'}			���б�����:�ܵҥǡ�����ɤ����뤫
#											0�Ŀ����ɲ� 1�ĺ�� 2�Ľ���
#		$form{'rireki_inputid'}			���б�����:�ܵ�ID��Ͽ
#		$form{'rireki_inputkokyaku'}	���б�����:�ܵ�̾��Ͽ
#		$form{'rireki_inputnaiyou'}		���б�����:�б�������Ͽ
#		$form{'rireki_inputsyubetsu'}	���б�����:�б�������Ͽ
#		$form{'rireki_inputtaiousya'}	���б�����:�б�����Ͽ
#		$form{'rireki_inputtime'}		���б�����:�б�����Ͽ
#		$form{'rireki_inputtaiousya'}		���б�����:�б�����Ͽ
sub save_rireki {
		#����μ�Ǽ��
	local($year);
	local($mon);
	local($day);
	local($hour);
	local($min);
	local($sec);
	local($data_time);	#���߻���
	
	local($i);	#�롼����
	
		#�����������:����ѥ����ȥ�
	local($kanri_title)="�б�������ɲá��Խ������¸";
	
	require 'save_kanri_rireki_lib.pl';	#�б�������ɲá��Խ������¸
	
	#���ߤλ���ǡ�����Ͽ
	($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
	$mon=$mon+1;
	$year=$year+1900;
	$data_time=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
	
	#����ǡ����ɤ߼��
	@rireki_data=&file_access("<$file_taiou",9);
	
	#����ǡ����ΥХå����å�
	&file_access(">$file_taiou_bak",10,0,@rireki_data);
	
	#�ܵҾ�����ɤ߼��
	@kokyaku_data=&file_access("<$file_kokyaku",4);
	
	#�ܵҥǡ����ΥХå����å�
	&file_access(">$file_kokyaku_bak",6,0,@kokyaku_data);
	
	#�ǡ������ɲ�
	if($error_code==0) {
		require 'options_lib.pl';
			#�ܵҴ���DataBase�� �ե�����ǥ�˥塼�������ɽ������ʸ����
		
		local($set);			#�񤭹��ߡ�����������
		local($write_id);		#�񤭹��ߡ�����ID������
		local(@option_message);		#��˥塼�γ�����
		local($option_message2);
			#$kokyaku_data_menu���ͤ��б�����ƤӽФ���˥塼��
		local($check_reload);	#����ɥ����å�
		
		#��˺��ʤ�Ŭ���˽񤭤ޤ�
		if(length($form{'rireki_inputtaiousya'})<1) {
			$form{'rireki_inputtaiousya'}="����";
		}
		if(length($form{'rireki_inputnaiyou'})<1) {
			$form{'rireki_inputnaiyou'}="�Ρ�������";
		}
		
		#0���ܤκ���
		$rireki_data[0]=$rireki_koumokuname[0];
		for($i=1;$i<=$#rireki_koumokuname;$i++) {
			$rireki_data[0]=$rireki_data[0]."	".$rireki_koumokuname[$i];
		}
		$rireki_data[0]=$rireki_data[0]."	$version\n";
		
		#�б����̥ǡ�����ʸ����
		&options(-1);
		$form{'rireki_inputsyubetsu'}=$option_message[$form{'rireki_inputsyubetsu'}];
		
		#����ʸ���������ؤ���
		chomp($form{'rireki_inputnaiyou'});
		$form{'rireki_inputnaiyou'}=~ s/\r\n/<br>/g;
		$form{'rireki_inputnaiyou'}=~ s/\n/<br>/g;
		$form{'rireki_inputnaiyou'}=~ s/"/\"/g;
		
		#�񤭹��߰��֤β�����
		$set=$#rireki_data+2;
		
		#����ɥ����å��ѥǡ����Ѱ�
		require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ��롣
		&tab_cut($rireki_data[$#rireki_data]);
		$check_reload=sprintf("%s	%s	%s\n",$cut_end[4],$cut_end[5],$cut_end[6]);
		
		if($form{'rireki_command'}==0) {
			#�ɲý񤭹���
				#����ID�μ���
			$write_id=($year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec)*100;
			
				#�񤭹��߽���
			$form{'rireki_inputtime'}=sprintf("%d/%02d/%02d %02d:%02d:%02d",$year,$mon,$day,$hour,$min,$sec);
		} elsif($form{'rireki_command'}==1) {
			#����Τߤ򤹤���
			
			local($j);			#�롼��������
			local($sw_del)=0;	#�������������������ǡ��������뤫�� 0=off 1=on
			
			for($j=1;$j<=$#rireki_data;$j++) {
				if($sw_del==1) {
					#�����å����äƤ���ʤ�Ť�������
					$rireki_data[$j]=$rireki_data[$j+1];
				} else {
					&tab_cut($rireki_data[$j]);
					if(index($cut_end[0],$form{'rireki_callno'})>-1) {
						#�����������:��������
						local($comment);	#����
						$comment=$rireki_data[$j];
						$comment=~s/\n//g;
						$comment=~s/\t/��/g;
						&save_kanri_rireki($kanri_title,"�ʲ��Υǡ����������ޤ�����<br><br><font size=-2>$comment</font><br>");
						
						#�����ꥵ�����������å�����
						$sw_del=1;
						$j--;
					}
				}
			}
			if($sw_del==0) {
				$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'rireki_inputtaiousya'}." ������Ǥ�������ǡ������̤ο�ʪ�ˤ�äƺ������Ƥ��ޤ�����<br>���ΰ��������ѹ���������ϴ�λ�Ǥ��ޤ���Ǥ�����</b></font><br>";
			} else {
				$rireki_data[$j]=undef;
			}
		} else {
			#�������Ƥ������
			local($j);					#�롼��������
			local($sakujyo_syuusei)=0;	
				#����Ƚ���:	0=�ɤä��⤷�Ƥʤ� 1=���� 2=��� 3=ξ��
			local($rireki2_syuusei);	#������λ�֤���:�֤������
			local(@rireki2_data);		#������λ�֤���:��
			
			$write_id=0;
			$rireki2_data[0]=$rireki_data[0];
			for($j=1,$rireki2_syuusei=1;$j<=$#rireki_data;$j++,$rireki2_syuusei++) {
				&tab_cut($rireki_data[$j]);
				
				if($sakujyo_syuusei<3) {
					#������ꥵ����
					if($sakujyo_syuusei<1) {
							#����μ�Ǽ��
						local($year2);
						local($mon2);
						local($day2);
						local($hour2);
						local($min2);
						local($sec2);
						local($data_time2);	#���ιԤ˵�����Ƥ������
						local($data_time3);	#���ϥǡ����˵����줿����
						
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
					
					#�����ꥵ����
					if($cut_end[0]==$form{'rireki_callno'}) {
						$sakujyo_syuusei=$sakujyo_syuusei+2;
						$rireki2_syuusei--;
					}
				}
				
				#����������Ѥߥǡ������֤����á������
				$rireki2_data[$rireki2_syuusei]=$rireki_data[$j];
			}
			
			if($sakujyo_syuusei<2) {
				$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'rireki_inputtaiousya'}." ������Ǥ�������ǡ������̤ο�ʪ�ˤ�äƺ������Ƥ��ޤ�����<br>���ΰ��������ѹ���������ϴ�λ�Ǥ��ޤ���Ǥ�����</b></font><br>";
			}
			@rireki_data=undef;
			@rireki_data=@rireki2_data;
		}
		
		if($form{'rireki_command'}!=1) {
			local($comment);	#����
			
			#����Ǥʤ���н����ǡ���������
			$rireki_data[$set]=sprintf("%s	%s	%s	%s	%s	%s	%s",$write_id,$form{'rireki_inputid'},$form{'rireki_inputkokyaku'},$form{'rireki_inputtime'},$form{'rireki_inputtaiousya'},$form{'rireki_inputsyubetsu'},$form{'rireki_inputnaiyou'});
			$rireki_data[$set]=~ s/\r//g;
			$rireki_data[$set]=$rireki_data[$set]."\n";
			
			#�����������:�ɲá��Խ������
			$comment=$rireki_data[$set];
			$comment=~s/\n//g;
			$comment=~s/\t/��/g;
			&save_kanri_rireki($kanri_title,"�ʲ��Υǡ������ɲ�(�����Խ�)���ޤ�����<br><br><font size=-2>$comment</font><br>");
		}
		
		#����ǡ����ν񤭹���
		if (index($rireki_data[$set],$check_reload)==-1||index($rireki_data[$set],"�Ρ�������")>-1) {
			#����ɤǤʤ������ʤ�
			
				#Ʊ����ˤ�룲�Űʾ�񤭹��ߥ����å�
			
				#����μ�Ǽ��
			local($year2);
			local($mon2);
			local($day2);
			local($hour2);
			local($min2);
			local($sec2);
			local($data_time2);	#�ե��������
			local(@file_info);	#����ե��������
			
			@file_info=stat $file_taiou;
			($sec2,$min2,$hour2,$day2,$mon2,$year2,$null) = localtime $file_info[9];
			$mon2=$mon2+1;
			$year2=$year2+1900;
			$data_time2=$sec2+$min2*60+$hour2*60*60+$day2*60*60*24+$mon2*60*60*24*31+$year2*60*60*24*31*12;
			
			if($data_time==$data_time2) {
				$edit_inputerror=$edit_inputerror."<font color=red><b>¾������Ʊ����˽ֻ��κ����б�������Ͽ���줿��������Ǥ��ޤ���Ǥ�����<br>�֤򸫤Ƥ⤦���٤������������</b></font><br>";
			}
			
				#���⥨�顼��ȯ�����ʤ��ʤ�񤭹���
			if(length($edit_inputerror)<1) {
				local($j);		#�롼����
				
				&file_access(">$file_taiou",11,$config[6],@rireki_data);
				
				#�ܵҾ���ν��֤ǡ�����ǡ������ѹ������ܵҤ���֤Υȥåפ��¤��ؤ���
				for($i=$#kokyaku_data;0<$i;$i--) {
					&tab_cut($kokyaku_data[$i]);
					if($cut_end[0]==$form{'rireki_inputid'}) {
						local($left_kokyaku_data);		#�ܵҥǡ�����������
						
						$left_kokyaku_data=$kokyaku_data[$i];
						for($j=$i;$j<$#kokyaku_data;$j++) {
							$kokyaku_data[$j]=$kokyaku_data[$j+1];
						}
						$kokyaku_data[$#kokyaku_data]=$left_kokyaku_data;
						
						$i=$j;
					}
				}
				
				#�ܵҥǡ����ν񤭹���
				&file_access(">$file_kokyaku",5,0,@kokyaku_data);
			}
		}
	}
}
1;
