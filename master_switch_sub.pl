#--------------------------------------
#�����ԥ⡼�ɤΥ����å�ON/OFF�ˤĤ���
#&master_switch()
#	����:
#		@config					������ǡ�����
#		$kanrimode_passwordkari	�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ��Ѳ�
#		$kanrimode_sw			�Ĵ�����:�⡼�ɤ�OFF/ON
#		$form{'kanrimode_pass'}	�Ĵ����ԥ⡼�ɿ��������Ϥ��줿�ѥ����
#		$form{'sendmail_sw'}	�ĥ᡼������������ɤ��������������椫��
#	����:
#		$kanrimode_password	�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		$kanrimode_sw		�Ĵ�����:�⡼�ɤ�OFF/ON
sub master_switch {
	local($record_koumoku)="�����ԥ⡼�ɤΥ����å�ON/OFF";	#�ܺ�����:��Ͽ������ܤ����
	require'save_kanri_rireki_lib.pl';
	
	$form{'sendmail_sw'}=0;
	if($kanrimode_sw==0) {
		#�����å�OFF��ON
		
			#�ѥ���ɥ����å�
		chomp($form{'kanrimode_pass'});
		chomp($config[1]);
		$config[1]=~ s/\r//g;
		
		if($form{'kanrimode_pass'} eq $config[1]) {
			$kanrimode_sw=1;
			$kanrimode_password=$kanrimode_passwordkari;
		
			#��Ͽ
			&save_kanri_rireki($record_koumoku,"�����ԥ⡼�ɤؤΥ����å��� ON �ˤʤ�ޤ�����");
		} else {
			$kanrimode_sw=2;
		
			#��Ͽ
			&save_kanri_rireki($record_koumoku,"�����ԥ⡼�ɤؤο�������ߤ��ޤ��������ѥ���ɥ��顼���֤���ޤ�����");
		}
	} elsif($kanrimode_sw==1) {
		#�����å�ON��OFF
		$kanrimode_sw=0;
		$kanrimode_password="";
		
			#��Ͽ
		&save_kanri_rireki($record_koumoku,"�����ԥ⡼�ɤؤΥ����å��� OFF �ˤʤ�ޤ�����");
	}
	
}
1;
