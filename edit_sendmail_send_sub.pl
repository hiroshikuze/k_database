#--------------------------------------
#�᡼����������ݥ᡼������
#&edit_sendmail_send()
#	����:
#		$file_kokyaku			�ĸܵҾ���ե�����̾
#		$file_taiou				���б�����ե�����̾
#		$file_taiou_bak			����1����Хå����å׸ܵҾ���ե�����̾
#		@kokyaku_data			�ĸܵҥǡ���:��
#		@rireki_data			������ǡ���:��
#		$mailer_pass			��semdmail�⤷���ϡ����θߴ��ޤǤΥѥ�
#		$mailer_ownaddress		�Ĵ����ԤΥ᡼�륢�ɥ쥹(������ɬ���ѹ����Ƥ���������)
#		�ե�����:(���Ϥȶ��̤�����)	�Ľ��Ϥȥ��֤�Τ�ά
#			sendmail_honbun	�ĥ᡼�������������������᡼�����ʸ
#			sendmail_title	�ĥ᡼�������������������᡼��Υ����ȥ�
#			sendmail_sw		�ĥ᡼������������ɤ��������������椫��
#								0�ĥ᡼����������򤽤⤽�⤷�褦�Ȥ��Ƥ��ʤ���
#								1�Ĥɤ��������������档
#								2�ĥ᡼��ʸ������¾��
#	����:
#		$error_code�ĥ��顼ȯ����������������
#		$error_file�ĸƤӽФ����ȥե�����̾��
#		@kokyaku_data		�ĸܵҥǡ���:��
#		@rireki_data		������ǡ���:��
#		�ե�����:
#			sendmail_sw		�ĥ᡼������������ɤ��������������椫��
sub edit_sendmail_send {
	#�ѿ������֥롼�������
	require'tab_cut_lib.pl';			#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
	require'save_kanri_rireki_lib.pl';	#��������������¸
	require'encodesubject_lib.pl';		#�᡼������ܸ쥵�֥������Ȥ򥨥󥳡��ɤ���
	local($i);				#�롼����
	local($err);			#�᡼���������顼����
	local(@report);			#�������
								#0�ĤޤȤ�
								#1�ĥ᡼�륿���ȥ�(JIS�Ѵ���)
								#2�ĥ᡼����ʸ(JIS�Ѵ���)
								#3����������ѥ����ȥ�
	local($write_rireki);	#�б�����˽񤭹�������
		#����μ�Ǽ��
	local($year);
	local($mon);
	local($day);
	local($hour);
	local($min);
	local($sec);
	local($null);
	local($data_time);	#���߻���
	local($rireki_syuusei_id);	#�б�����񤭹���:ID����
	
	for($i=0;$i<4;$i++) {
		$report[$i]="";
	}
	$report[3]="�᡼���������";
	
	#�ܵҥǡ������ɤ߼��
	if($#kokyaku_data==-1) {
		@kokyaku_data=&file_access("<$file_kokyaku",7);
	}
	
	#�б�����ǡ������ɤ߼��
	if($#rireki_data==-1) {
		@rireki_data=&file_access("<$file_taiou",9);
		#����ǡ����ΥХå����å�
		&file_access(">$file_taiou_bak",10,@rireki_data);
	}
	
	#�б�����񤭹��߽���
		#���ߤλ���ǡ�����Ͽ
	($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
	$mon=$mon+1;
	$year=$year+1900;
	$data_time=$year*60*60*24*31*12+$mon*60*60*24*31+$day*60*60*24+$hour*60*60+$min*60+$sec;
	$write_rireki=sprintf("%d/%02d/%02d %02d:%02d:%02d	%s	%s	%s",$year,$mon,$day,$hour,$min,$sec,$kanrimode_name,$kanrimode_send,"�ʲ������ƤΥ᡼����������ޤ�����<br><font size=-2><b>�����ȥ�̾:</b><br>$form{'sendmail_title'}<br><b>��ʸ:</b><br>$form{'sendmail_honbun'}</font>");
	$write_rireki=~ s/\\r\\n/<br>/g;
	$write_rireki=~ s/\\n/<br>/g;
	
	#����������
	$report[0]=$report[0]."�ʲ��Τ褦�˥᡼����������ޤ�����<br><br><font size=-2>";
	$report[0]=$report[0]."<b>������:</b><br>";
	
	#�᡼������
	$report[1]=$form{"sendmail_title"};
	jcode::convert(\$form{"sendmail_title"}, "jis");
	$form{"sendmail_title"}=&EncodeSubject($form{"sendmail_title"});
	$report[2]=$form{"sendmail_honbun"};
	$form{"sendmail_honbun"}=~ s/\\r\\n/\r\n/g;
	$form{"sendmail_honbun"}=~ s/\\n/\n/g;
	jcode::convert(\$form{"sendmail_honbun"}, "jis");
	
	$err = 0;
	for($i=$#kokyaku_data,$rireki_syuusei_id=0;$i>0;$i--) {
		if ($err==0) {
			&tab_cut($kokyaku_data[$i]);
			if($form{substr($cut_end[0],0,11)}==1) {
				if(length($cut_end[16])>3) {
					local($rireki_set);		#�б�����񤭹���:�԰���
					local($rireki_setid);	#ID����
					
					open(MAIL, "| $mailer_pass -t") or $err = 1;
					print MAIL "From: $mailer_ownaddress\n";
					print MAIL "To: $cut_end[16]\n";
					print MAIL "Subject: $form{'sendmail_title'}\n";
					print MAIL "MIME-Version: 1.0\n";
					print MAIL "Content-Type: text/plain; charset=iso-2022-jp\n";
					print MAIL "\n";
					print MAIL $form{'sendmail_honbun'};
					print MAIL "\n";
					print MAIL "\n\n" . "." . "\n";
					close(MAIL);
					$report[0]=$report[0]." $cut_end[2] /";
					
					#�б�����˽񤭹���
					$rireki_set=$#rireki_data+2;
					$rireki_setid=-($data_time*100+$rireki_syuusei_id);
					$rireki_data[$rireki_set]=sprintf("%.0f	%.0f	%s	%s\n",$rireki_setid,$cut_end[0],$cut_end[2],$write_rireki);
					
					$rireki_syuusei_id++;
				}
			}
		} else {
			$error_code=16;
			$error_file="";
			$i=0;
		}
	}
	if($err==0) {
		$report[2]=~ s/\\r\\n/<br>/g;
		$report[2]=~ s/\\n/<br>/g;
		$report[0]=$report[0]."<br>";
		$report[0]=$report[0]."<b>�����ȥ�̾:</b><br>";
		$report[0]=$report[0]." $report[1]<br>";
		$report[0]=$report[0]."<b>��ʸ:</b><br>";
		$report[0]=$report[0]." $report[2]<br>";
		
		#�б��������¸
		&file_access(">$file_taiou",9,$config[6],@rireki_data);
	}
	
	#��������Ĥ��롦�񤭹���
	$report[0]=$report[0]."</font>";
	&save_kanri_rireki($report[3],$report[0]);
	
	#���ͤ����������᤹
	$form{"sendmail_sw"}=0;
}
1;
