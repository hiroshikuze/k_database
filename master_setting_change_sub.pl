#--------------------------------------
#���������������ڤ��ؤ�
#&master_setting_change($hyouji_sw)
#	����:
#		$hyouji_sw								��(�����ǻ���)�ѹ��������Ƥ�����
#													0�Ĵ�����������ѹ��˴ؤ���
#													1�İ����������˴ؤ���
#													2�İ��ƥ᡼������
#		$file_config							�Ĵ�����������ե�����̾
#		@config									������ե�����:���ǡ���
#		$version								�ĥС���������
#		$form{'change_cut_mailissei_rireki'}	���ѹ�����:�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�
#		$form{'change_info'}					�Ĵ����Ԥ���Τ��Τ餻
#		$form{'change_leave_sousarireki'}		�İ����������򲿷�ޤǻĤ���
#		$form{'change_pass'}					�ĥѥ����
#		$form{'change_rireki_kazu'};			���б��������¸���
#		$form{'change_view'}					�ĺǶ����Ϥ��줿����򲿷�Ť�ɽ�����뤫
#		$form{'change_view_mailissei_rireki'};	�İ��ƥ᡼����������κǽ��ɽ��������
#		$form{'change_view_sousarireki'}		�İ�����������ɽ�����
#	����:
#		@config					������ǡ�����
#		$view_start				�ĺǿ���:��ư���˵�Ͽ�ξ夫��ɽ��������̵�����
sub master_setting_change {
	local($i);	#�롼����
	local(@save_data);	#�����֤�������
	local($record_koumoku)="���������������ڤ��ؤ�";	#�����������:��Ͽ������ܤ����
	
	#�����Υǡ����ɤ߼��
	local($hyouji_sw)=@_;
	
	
	#�ǡ������
		#�ե�����ǡ���������ɤ߽Ф�
	$config[0]=$version." - config_file";				#�ǽ������С������ǡ������ɤ߼��
	if($hyouji_sw==0) {
		#������������ѹ��˴ؤ���
		$config[1]=$form{'change_pass'};					#�ѥ����
		$config[2]=$form{'change_view'};					#�Ƕ����Ϥ��줿����򲿷�Ť�ɽ�����뤫
		$config[3]=$form{'change_info'};					#�����Ԥ���Τ��Τ餻
		$config[6]=$form{'change_rireki_kazu'};				#�б��������¸���
		
			#�����Ԥ���Τ��Τ餻��HTML��������¸��ǽ�ʾ��֤ˤ���
		chomp($config[3]);
		$config[3]=~ s/\r\n/<br>/g;
		$config[3]=~ s/\r//g;
		$config[3]=~ s/\n/<br>/g;
		$config[3]=~ s/"/\"/g;
	} elsif($hyouji_sw==1) {
		#�����������˴ؤ���
		$config[4]=$form{'change_view_sousarireki'};		#������������ɽ�����
		$config[5]=$form{'change_leave_sousarireki'};		#�����������򲿷�ޤǻĤ���
		$config[8]=$form{'change_cut_mailissei_rireki'};
									#�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�
	} elsif($hyouji_sw==2) {
		$config[7]=$form{'change_view_mailissei_rireki'};	#���ƥ᡼����������κǽ��ɽ��������
		$config[8]=$form{'change_cut_mailissei_rireki'};
									#�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�
	}
	
	#�����ֽ񼰤��ɤ߼��
	@save_data=&file_access("<$file_config",1);
	if($error_file==0) {
		#���ν���
		local($i);			#�롼����ʸ����
		local($j);			#���������ѹ�����
		local(@config2);	#����������ʸ����
		
		for($i=0,$j=0;$j<=$#config;$i++) {
			if(substr($save_data[$i],0,2) ne '//') {
				chomp($config[$j]);
				$config[$j]=$config[$j]."\n";
				$save_data[$i]=$config[$j];
				$j++;
			}
		}
		
		#������¸
		&file_access(">$file_config",2,0,@save_data);
		
		for($i=0;$i<=$#save_data;$i++) {
			$save_data[$i]=~ s/\r//g;
			$save_data[$i]=~ s/\n/<br>/g;
		}
		require'save_kanri_rireki_lib.pl';
		&save_kanri_rireki($record_koumoku,"��������������ե����� '$file_config' ��ʲ��Τ褦���ѹ����ޤ�����<br><br><font size=-2>@save_data</font>");
	}
	
	#���β���ɽ���Ǥ⤭����ȿ������ѹ��ͤ�ɽ��������
	$view_start=$config[2];
}
1;
