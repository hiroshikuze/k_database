#--------------------------------------
#�ڡ����ν��ϡݴ����Ե�ǽ�Υ����å�ON/OFF�ˤĤ���
#&html_kanrimode_switch()
#	����:
#		$kanrimode_sw	�Ĵ�����:�⡼�ɤ�OFF/ON
#	����:
#		$output_html	��HTML�ɲý�����
sub html_kanrimode_switch {
	
	if($kanrimode_sw==0) {
		$output_html=$output_html."	<b>�����ԥ⡼�ɤ� OFF �ˤ��ޤ�����</b><br>\n";
	} elsif($kanrimode_sw==1) {
		$output_html=$output_html."	<b>�����ԥ⡼�ɤ� ON �ˤ��ޤ�����</b><br>\n";
	} elsif($kanrimode_sw==2) {
		$output_html=$output_html."	<font color=red><b>�ѥ���ɥ��顼</b></font><br>\n";
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	�������ѥѥ���ɤ���Ͽ�Τ�ΤȰ��פ��ޤ���<br>\n";
		$output_html=$output_html."	����ǧ����������<br>\n";
	} elsif($kanrimode_sw==3) {
		$output_html=$output_html."	<font color=red><b>������������</b></font><br>\n";
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	�������ѥ⡼�ɤؤο����ϴ����ԥѥ�������Ϥ���Ǥ��ꤤ���ޤ���<br>\n";
	}
}
1;
