#--------------------------------------
#�ڡ����ν��ϡݴ��������������ѹ���ǧ
#&html_check_system($before_kanrimode_sw,$next_kanrimode_sw)
#	����:
#		$before_kanrimode_sw	��(����������)�����������������Υڡ��������褦����¹Ի���������
#		$file_main				�ĥᥤ��롼����򼨤����ե�����̾
#		$html_sw				��ɽ�����Ƥ��ڤ��ؤ�
#		$next_kanrimode_sw		��(����������)���������������ѹ�����褦����¹Ի���������
#		�ե�����:				�Ľ��Ϥȥ��֤�ΤǾ�ά
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:	change_info			���ѹ�����:�����Ԥ���Τ��Τ餻
#		�ե�����:	change_rireki_kazu	���ѹ�����:�б��������¸���
#		�ե�����:	change_pass			���ѹ�����:�ѥ����
#		�ե�����:	change_view			���ѹ�����:ɽ������ǿ����Ϸ��
#		�ե�����:	html_sw				�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	kanrimode_check		�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word	�ĸ��������󸡺������������
sub html_check_system {
	
	local($before_html_sw,$next_html_sw)=@_;
	
	$output_html=$output_html."	<b>�ʲ��Τ褦���ѹ����ޤ���������Ǥ�����</b><br>\n";
	$output_html=$output_html."	<br>\n";
	$output_html=$output_html."	<form action=$file_main method=post>\n";
	$output_html=$output_html."	<b>�����Ԥ���Τ��Τ餻:</b><br>\n";
	if(length($form{'change_info'})>0) {
		$output_html=$output_html."	  <table border><tr><td align=left>$config[3]</td></tr></table><input type=hidden name=change_info value='".$form{'change_info'}."'><br>\n";
	} else {
		$output_html=$output_html."	  �äˤʤ�<br>\n";
	}
	$output_html=$output_html."	<b>�ǽ��\ɽ\������ǿ����Ϸ��:</b>$form{'change_view'}<input type=hidden name=change_view value=$form{'change_view'}><br>\n";
	$output_html=$output_html."	<b>�б��������¸���:</b>$form{'change_rireki_kazu'}<input type=hidden name=change_rireki_kazu value=$form{'change_rireki_kazu'}><br>\n";
	$output_html=$output_html."	<b>�ѥ�����ѹ�:</b>$form{'change_pass'}<input type=hidden name=change_pass value=$form{'change_pass'}><br>\n";
	
	$output_html=$output_html."	\n";
	$output_html=$output_html."	<table><tr>\n";
	$output_html=$output_html."	  <td>\n";
	$output_html=$output_html."		<input type=hidden name=html_sw value=$next_html_sw>\n";
	$output_html=$output_html."		<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_houhou value=$search_houhou>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_word value=$search_keyword>\n";
	$output_html=$output_html."		<input type=submit value=' ��������ѹ����롡 '>\n";
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	  <td><form action=$file_main method=post>\n";
	$output_html=$output_html."		<input type=hidden name=html_sw value=$before_html_sw>\n";
	$output_html=$output_html."		<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_houhou value=$search_houhou>\n";
	$output_html=$output_html."		<input type=hidden name=search_before_word value=$search_keyword>\n";
	$output_html=$output_html."		<input type=submit value=' �⤦�������Ϥ��ʤ��� '>\n";
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	</tr></table>\n";
}
1;
