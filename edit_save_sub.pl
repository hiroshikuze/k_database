#--------------------------------------
#�������ɲÎ��������
#&edit_save()
#	����:
#		$error_code					�ĥ��顼:���顼������
#		$file_kokyaku				�ĸܵҾ���ե�����̾
#		$file_kokyaku_bak			����1����Хå����å׸ܵҾ���ե�����̾
#		$file_taiou					���б�����ե�����̾
#		$file_taiou_bak				����1����Хå����å׸ܵҾ���ե�����̾
#		$form{'bye'}					�Ĥ��θܵҥǡ������?! 0��No 1��Yes
#		$form{'callno'}				�ĸܵ�����:�ƤӽФ�ID(�����Ǥ��ɲ�Ƚ�������)
#		$form{'input_kokyakudata?'}	�ĥե�����:�����Ϥ��줿�ǡ���
#		$kokyaku_koumokuname		�ĸܵҥǡ���:�ƹ���̾
#		$version					�ĥС���������
#	����:
#		$error_code		�ĥ��顼:���顼������
#		@kokyaku_data	�ĸܵҥǡ���:��
#		@rireki_data	������ǡ���:��
sub edit_save {
	local($i);				#�롼����
	local($error_sw1)=0;	#���顼:�Խ���������Ҥϥǡ����ˤޤ����뤫��(0��No 1��Yes)
	local($kanri_title)="�ܵҥǡ����ν������ɲÎ��������";
							#�����������:����ѥ����ȥ�
	
	#���֥롼���󷲥���
	require 'tab_cut_lib.pl';			#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
	require 'save_kanri_rireki_lib.pl';	#�б�������ɲá��Խ������¸
	require 'seiri_formdata_lib.pl';	#�ե�����Υǡ���������������
	
	#ɬ�ץǡ�����ե�������������
	
	#�ܵҾ�����ɤ߼��
	@kokyaku_data=&file_access("<$file_kokyaku",4);
	
	if($error_code==0) {
		
		#�ܵҥǡ����ΥХå����å�
		&file_access(">$file_kokyaku_bak",6,0,@kokyaku_data);
		
		if($form{'callno'}!=-1) {
			#ID�����å�����Ͽ�Τ�Τ�ƱID������к��
			for($i=0;$i<=$#kokyaku_data;$i++) {
				&tab_cut($kokyaku_data[$i]);
				if($cut_end[0]==$form{'input_kokyakudata0'}) {
					#�����������:��������
					local($comment);	#����
					$comment=$kokyaku_data[$i];
					$comment=~s/\n//g;
					$comment=~s/\t/��/g;
					&save_kanri_rireki($kanri_title,"�ʲ��Υǡ����������ޤ�����<br><br><font size=-2>$comment</font><br>");
					
					$error_sw1=1;
				}
				$kokyaku_data[$i]=$kokyaku_data[$i+$error_sw1];
			}
			if($error_sw1==1) {
				undef($kokyaku_data[$#kokyaku_data]);
			} else {
				$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'input_kokyakudata2'}." ���̤ο�ʪ�ˤ�äƺ������Ƥ��ޤ�����<br>���ΰ��������ѹ���������ϴ�λ�Ǥ��ޤ���Ǥ�����</b></font><br>";
			}
		}
	}
	
	if($form{'bye'}==1) {
		#����������Ƥ��뢪��������ǡ�������
		
		local(@rireki_data2);	#��¸�ǡ�������
		local($j);				#��¸�ǡ���������
		
		#����ǡ������ɤ߼��
		@rireki_data=&file_access("<$file_taiou",12);
		
		#����ǡ����ΥХå����å�
		&file_access(">$file_taiou_bak",13,0,@rireki_data);
		
		if($error_code==0) {
			$rireki_data2[0]=$rireki_data[0];
			for($i=1,$j=1;$i<=$#rireki_data;$i++) {
				&tab_cut($rireki_data[$i]);
				
				if($cut_end[1]!=$form{'input_kokyakudata0'}) {
					$rireki_data2[$j]=$rireki_data[$i];
					$j++;
				}
			}
		}
		
		#����ǡ����ν񤭹���
		&file_access(">$file_taiou",14,$config[6],@rireki_data2);
	}
	
	if($form{'callno'}==-1) {
		#�����ɲä���Ƥ���
		
			#��������
		local($sec);
		local($min);
		local($hour);
		local($day);
		local($mon);
		local($year);
		local($null);
		
		$error_sw1=1;	#�Խ���������Ҥϥǡ�����¸�ߤ����ǧ��������
		
			#ID�γ�꿶��
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
		$mon=$mon+1;
		$year=$year+1900;
		$form{'input_kokyakudata0'}=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
	}
	
	#�ǡ������Խ�����¸
	if($error_sw1==1&&$error_code==0) {
		#���⤽��ǡ������֤������Ƥ����Τ���
			#���ߤλ�������
		local($sec);
		local($min);
		local($hour);
		local($day);
		local($mon);
		local($year);
		local($null);
		local($now_total);	#���ߤλ�����
		local(@file_info);	#�ܵҥե��������
		local($file_total);	#�ܵҥե�����ǽ���¸������
		
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
		$mon=$mon+1;
		$year=$year+1900;
		$now_total=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
		@file_info=stat $systemfile;
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime $file_info[9];
		$mon=$mon+1;
		$year=$year+1900;
		$file_total=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
		if($now_total!=$file_total) {
			
			$kokyaku_data[0]=$kokyaku_koumokuname[0];
			for($i=1;$i<=$#kokyaku_koumokuname;$i++) {
				$kokyaku_data[0]=$kokyaku_data[0]."	".$kokyaku_koumokuname[$i];
			}
			$kokyaku_data[0]=$kokyaku_data[0]."	$version\n";
			
			if($form{'bye'}!=1){
				#�ǡ������ɲä��Խ�
				local($j);	#�񤭹��߰���������
				local($k);	#�ե�����ǡ����ɤ߼����
				local(@option_message);		#��˥塼�γ�����
				local($option_message2);
					#$kokyaku_data_menu���ͤ��б�����ƤӽФ���˥塼��
				
				require 'options_lib.pl';
					#�ܵҴ���DataBase�� �ե�����ǥ�˥塼�������ɽ������ʸ����
				
				$j=$#kokyaku_data+1;
				$kokyaku_data[$j]=$form{'input_kokyakudata0'};
				for($i=1;$i<=$#kokyaku_koumokuname;$i++) {
					&options($i);
					$k="input_kokyakudata".$i;
					if($option_message2==-1) {
						#��˥塼���ܤǤʤ���Τʤ�
						chomp($form{$k});
						$form{$k}=~ s/\r//g;
						$kokyaku_data[$j]=$kokyaku_data[$j]."	".$form{$k};
					} else {
						#��˥塼���ܤʤ�
						$kokyaku_data[$j]=$kokyaku_data[$j]."	".$option_message[$form{$k}];
					}
				}
				$kokyaku_data[$j]=$kokyaku_data[$j]."\n";
				
				#�����������:�ɲá��Խ������
				local($comment);	#����
				$comment=$kokyaku_data[$j];
				$comment=~s/\n//g;
				$comment=~s/\t/��/g;
				&save_kanri_rireki($kanri_title,"�ʲ��Υǡ������ɲ�(�����Խ�)���ޤ�����<br><br><font size=-2>$comment</font><br>");
			}
			
			#�ܵҥǡ����ν񤭹���
			&file_access(">$file_kokyaku",5,0,@kokyaku_data);
		} else {
			$edit_inputerror=$edit_inputerror."<font color=red><b>�̤ο�ʪ�ˤ��Ʊ����˽񤭹��ߤ��Ԥ��ޤ�����<br>���Υ��եȤ�1�ô֤�2��ʾ�ν񤭹��߽����ϤǤ��ޤ���<br>���ΰ��������ѹ���������ϴ�λ�Ǥ��ޤ���Ǥ�����</b></font><br>";
		}
	}
}
1;
