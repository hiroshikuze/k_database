#--------------------------------------
#�ڡ����ν��ϡݰ����������������ѹ���ǧ
#&html_check_sousarireki($before_html_sw,$next_html_sw)
#	����:
#		$before_kanrimode_sw	��(����������)�����������������Υڡ��������褦����¹Ի���������
#		$html_sw			��ɽ�����Ƥ��ڤ��ؤ�
#		$file_main			�ĥᥤ��롼����򼨤����ե�����̾
#		$next_kanrimode_sw		��(����������)���������������ѹ�����褦����¹Ի���������
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:	change_cut_mailissei_rireki	���ѹ�����:�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�
#		�ե�����:	change_view_sousarireki		���ѹ�����:ɽ������ǿ����Ϸ��
#		�ե�����:	change_leave_sousarireki	���ѹ�����:�ѥ����
#		�ե�����:	html_sw						�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	kanrimode_check				�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word			�ĸ��������󸡺������������
sub html_check_sousarireki {
	
	local($before_html_sw,$next_html_sw)=@_;
	
	$output_html=$output_html."	<b>�ʲ��Τ褦���ѹ����ޤ�����������Ǥ�����</b><br>\n";
	$output_html=$output_html."	<br>\n";
	$output_html=$output_html."	<form action=$file_main method=post>\n";
	$output_html=$output_html."	<b>�����������Τ�����\ɽ\��������:</b>$form{'change_view_sousarireki'}<input type=hidden name=change_view_sousarireki value=$form{'change_view_sousarireki'}><br>\n";
	$output_html=$output_html."	<b>������������Ĥ����:</b>$form{'change_leave_sousarireki'}<input type=hidden name=change_leave_sousarireki value=$form{'change_leave_sousarireki'}><br>\n";
	$output_html=$output_html."	<b>�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�:</b>$form{'change_cut_mailissei_rireki'}<input type=hidden name=change_cut_mailissei_rireki value=$form{'change_cut_mailissei_rireki'}><br>\n";
	
	$output_html=$output_html."	\n";
	$output_html=$output_html."	<table><tr>\n";
	$output_html=$output_html."	  <td>\n";
	$output_html=$output_html."		<input type=hidden name=html_sw value=$next_html_sw>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."		<input type=submit value=' ��������ѹ����롡 '>\n";
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	  <td><form action=$file_main method=post>\n";
	$output_html=$output_html."		<input type=hidden name=html_sw value=$before_html_sw>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."		<input type=submit value=' �⤦�������Ϥ��ʤ��� '>\n";
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	</tr></table>\n";
}
1;