#--------------------------------------
#�������ɲÎ������ǧ
#&edit_check()
#	����:
#		$form{'bye'}				�Ĥ��θܵҥǡ������?! 0��No 1��Yes
#		$form{'input_kokyakudata?'}	�ĥե�����:�����Ϥ��줿�ǡ���
#		$file_kokyaku				�ĸܵҾ���ե�����̾
#		$form{'callno'}				�ĸܵ�����:�ƤӽФ�ID
#	����:
#		$edit_inputerror	�ľَܺ��������ɲÎ����:�ɲäκݤǤΥȥ�֥����äƤ���Τ���
#		@kokyaku_data		�ĸܵҥǡ���:��
#		$edit_id			�ľَܺ��������ɲÎ����:����ID
#		$form{'*'}			�ĥե�����:�����Ϥ��줿�ǡ���
sub edit_check {
	if($form{'bye'}!=1) {
		#����ǻؼ��Ǥʤ����
		
		#��Ͽ�ǡ�����̤���ϡ��ػ�ʸ�����ѤΥ����å��Ƚ���
		if($form{'input_kokyakudata1'} eq '') {
			$edit_inputerror=$edit_inputerror."���� ��̤���ϤǤ���<br>";
		}
		if($form{'input_kokyakudata2'} eq '') {
			$edit_inputerror=$edit_inputerror."���̾ ��̤���ϤǤ���<br>";
		}
		if($form{'input_kokyakudata4'} eq '') {
			$edit_inputerror=$edit_inputerror."\��\ɽ\��̾ ��̤���ϤǤ���<br>";
		}
		if($form{'input_kokyakudata10'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."����-͹���ֹ� �������ͤ��۾�Ǥ���<br>";
		}
		if($form{'input_kokyakudata12'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."����ʤ�������-͹���ֹ� �������ͤ��۾�Ǥ���<br>";
		}
		if($form{'input_kokyakudata14'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."TEL �������ͤ��۾�Ǥ���<br>";
		}
		if($form{'input_kokyakudata15'} =~ /[^0-9\-]/) {
			$edit_inputerror=$edit_inputerror."FAX �������ͤ��۾�Ǥ���<br>";
		}
		if($form{'input_kokyakudata16'} =~ /[^!-z]/) {
			$edit_inputerror=$edit_inputerror."E-Mail �������ͤ��۾�Ǥ���<br>";
		}
		if($form{'input_kokyakudata18'} =~ /[^0-9\/]/) {
			$edit_inputerror=$edit_inputerror."�е�ǯ���� �������ͤ��۾�Ǥ���<br>";
		}
		if($form{'input_kokyakudata19'} =~ /[^0-9]/) {
			$edit_inputerror=$edit_inputerror."���ܶ� �������ͤ��۾�Ǥ���<br>";
		}
		#�ե�����Υǡ���������������
		if(length($form{'input_kokyakudata25'})>0) {
			if(index($form{'input_kokyakudata25'},"http://")==-1) {
				if(index($form{'input_kokyakudata25'},"https://")==-1) {
					if(index($form{'input_kokyakudata25'},"ftp://")==-1) {
						#website��URL���Ϥ� http:// �ʤɤ��ʤ�
						$form{'input_kokyakudata25'}="http://".$form{'input_kokyakudata25'};
					}
				}
			}
		}
		if($form{'input_kokyakudata28'} =~ /[^0-9]/) {
			$edit_inputerror=$edit_inputerror."PC��� �������ͤ��۾�Ǥ���<br>";
		}
		if(length($edit_inputerror)>0) {
			$edit_inputerror="	���Ϥ����ͤ˰ʲ������꤬����ޤ���<br><b><font color=red>".$edit_inputerror."</font></b><br>���٤���ǧ�ξ����Ϥ�ľ���Ƥ���������<br>";
		}
		
		#����ʸ���������ؤ���
		chomp($form{'input_kokyakudata31'});
		$form{'input_kokyakudata31'}=~ s/\r\n/<br>/g;
		$form{'input_kokyakudata31'}=~ s/\n/<br>/g;
		$form{'input_kokyakudata31'}=~ s/"/\"/g;
		chomp($form{'input_kokyakudata32'});
		$form{'input_kokyakudata32'}=~ s/\r\n/<br>/g;
		$form{'input_kokyakudata32'}=~ s/\n/<br>/g;
		$form{'input_kokyakudata32'}=~ s/"/\"/g;
	} else {
		#����ǻؼ��ʤ��
		
		local($i);	#�롼����
		
		#���֥롼���󷲥���
		require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
		
		#�ܵҥǡ������ɤ߼��
		@kokyaku_data=&file_access("<$file_kokyaku",7);
		
		#���Υǡ���������ȴ���Ф���ɽ������褦�ˤ���
		for($i=1,$edit_id=-1;$i<=$#kokyaku_data;$i++) {
			&tab_cut($kokyaku_data[$i]);
			if($cut_end[0]==$form{'callno'}) {
				$edit_id=$i-1;
				$i=$#kokyaku_data;
			}
		}
		if($edit_id==-1) {
			$edit_inputerror=$edit_inputerror."<font color=red><b>".$form{'input_kokyakudata2'}." ���̤ο�ʪ�ˤ�äơ����Ǥ˺������Ƥ��ޤ�����</b></font><br>";
		} else {
			&tab_cut($kokyaku_data[$edit_id+1]);
			for($i=0;$i<=$#kokyaku_koumokuname;$i++) {
				local($j);	#�ե�����������
				
				$j="input_kokyakudata".$i;
				$form{$j}=$cut_end[$i];
			}
		}
	}
}
1;
