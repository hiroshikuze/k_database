#--------------------------------------
#�ڡ����ν��ϡݽ������ɲÎ������ǧ
#&html_syousai_check()
#	����:
#		@addlink				�ĥե�����γ��Ͱ�����
#									[0]�ĥ��󥫡��ˤ���Ͱ��Ϥ�
#									[1]�ĥե�����ˤ���Ͱ��Ϥ�
#									[2]�ĥե�����ˤ���Ͱ��Ϥ�(���Խ���)
#		$file_main				�ĥᥤ��롼����򼨤����ե�����̾
#		$kanrimode_password		�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		@kokyaku_koumokuname	�ĸܵҥǡ���:�ƹ���̾
#		@kokyaku_inputcyuui		�ĸܵҥǡ���:���ϻ�����ե�����
#		@kokyaku_syousai		�ĸܵҥǡ���:�ܺ١Ļ��Υե����������ϳƼ�ǡ���
#		$search_houhou			�ĸ���:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$search_keyword			�ĸ���:�ºݤ˸������륭�����
#		$system_back			�ĵ�ǽ�¹�:������λ�厥�������ֹ�
#		�ե�����:				(���Ϥȥ��֤�ΤǾ�ά)
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:	backpage				�ĵ�ǽ��λ�����Ƶ�ǽ
#		�ե�����:	bye						�Ĥ��θܵҥǡ������?! 0��No 1��Yes
#		�ե�����:	callno					�ĸܵ�����:�ƤӽФ�ID
#		�ե�����:	html_sw					�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	input_kokyakudata?		�ĳ����Ϥ��줿�ǡ���
#		�ե�����:	kanrimode_check			�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word		�ĸ��������󸡺������������
sub html_syousai_check {
	local(@formbutton_word);	#�ե���������ϥܥ����ɽ������ʸ��
	
	#�ե�����γ��Ͱ��Ϥ��ͽ���
	$addlink[1]=$addlink[1]."<input type=hidden name=backpage value=$system_back>\n";
	$addlink[1]=$addlink[1]."<input type=hidden name=callno value=".$form{'callno'}.">\n";
	
	if($form{'bye'}!=1) {
		$formbutton_word[0]="0";
		$formbutton_word[1]=" �������Ƥ���Ͽ���� ";
		$formbutton_word[2]=" �⤦�������Ϥ��ʤ��� ";
	} else {
		$formbutton_word[0]=$form{'bye'};
		$formbutton_word[1]=" �������Ƥ������� ";
		$formbutton_word[2]=" �⤦��������ľ�� ";
	}
	
	require'options_lib.pl';
		#�ե�����ǥ�˥塼�������ɽ������ʸ����
	
	$output_html=$output_html."<form action=$file_main method=post>\n";
	if($form{'bye'}==1) {
		#�����ǧ�ʤ��å�������Ф�
		$output_html=$output_html."	<table width=70%><tr><td align=center bgcolor=red>\n";
		$output_html=$output_html."		<font color=white><b>�ʲ��Υǡ����������Ƥ������Ǥ�����</b></font>\n";
		$output_html=$output_html."	</td></tr></table>\n";
	} elsif($form{'callno'}==-1) {
		#�ɲó�ǧ�ʤ��å�������Ф�
		$output_html=$output_html."	<table width=70%><tr><td align=center>\n";
		$output_html=$output_html."		<font color=black><b>�ʲ��Υǡ����򿷵��ɲä��Ƥ������Ǥ�����</b></font>\n";
		$output_html=$output_html."	</td></tr></table>\n";
		$output_html=$output_html."	<input type=hidden name=callno value=-1>\n";
	}
	
	$output_html=$output_html."<table border width=80%>\n";
	for($j=0;$j<=$#kokyaku_koumokuname;$j++) {
		$output_html=$output_html."	  <tr>\n";
		$output_html=$output_html."		<td align=left valign=top nowrap><b>$kokyaku_koumokuname[$j]��</b><font size=-2 color=#ff4444>$kokyaku_inputcyuui[$j]</font></td>\n";
		#�ǡ����ˤ�äƥե�����ɤη����Ѥ���
		$output_html=$output_html."		<td align=left valign=middle>";
		if($j==20||$j==21||$j==22||$j==27||$j==29) {
			local($k); #�롼����
			local(@option_message);		#��˥塼�γ�����
			local($option_message2);	#�ƤӽФ���˥塼��ʸ����
			
			&options($j);
				#�ե�����ǥ�˥塼�������ɽ������ʸ���󷲸ƤӽФ�
			
			$output_html=$output_html."		$option_message[$kokyaku_syousai[$j]]<input type=hidden name=input_kokyakudata$j value=$kokyaku_syousai[$j]>\n";
		} else {
			$output_html=$output_html."		$kokyaku_syousai[$j]<input type=hidden name=input_kokyakudata$j value='$kokyaku_syousai[$j]'>\n";
		}
		$output_html=$output_html."		</td>";
		$output_html=$output_html."	  </tr>\n";
	}
	$output_html=$output_html."	</table><br>\n";
	
	$output_html=$output_html."	\n";
	$output_html=$output_html."	<table><tr>\n";
	$output_html=$output_html."	  <td>\n";
	$output_html=$output_html."<input type=hidden name=html_sw value=4>\n";
	$output_html=$output_html."<input type=hidden name=bye value=$formbutton_word[0]>\n";
	$output_html=$output_html."<input type=submit value=$formbutton_word[1]>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	  <td><form action=$file_main method=post>";
	$output_html=$output_html."<input type=hidden name=html_sw value=2>\n";
	$output_html=$output_html."<input type=submit value=$formbutton_word[2]>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."	  </form></td>\n";
	$output_html=$output_html."	</tr></table>\n";
}
1;
