#--------------------------------------
#�᡼����������ݥ᡼����������
#&html_mail_naiyou()
#	����:
#		@addlink				�ĥե�����γ��Ͱ�����
#									[0]�ĥ��󥫡��ˤ���Ͱ��Ϥ�
#									[1]�ĥե�����ˤ���Ͱ��Ϥ�
#									[2]�ĥե�����ˤ���Ͱ��Ϥ�(���Խ���)
#		$html_sw				��ɽ�����Ƥ��ڤ��ؤ�
#		$file_main				�Ĥ��Υᥤ�󥷥��ƥ�ե�����̾
#		$output_html			��HTML�ɲý�����
#		$sendmail_kazu			�ĥ᡼���������:�������������ο�
#		�ե�����:				(���Ϥȥ��֤�ΤǾ�ά)
#	����:
#		$output_html				��(���Ϥǽ񤤤��Τ�ά)
#		�ե�����:
#			����					�ĥ᡼���������:��������ܵ���(ID)
#			backpage				�ĵ�ǽ��λ�����Ƶ�ǽ
#			html_sw					�ĸƤӽФ��줿(��)�Ƶ�ǽ
#			firstview_page			�ĺǿ���:���ڡ����ܤ򸫤Ƥ��뤫
#			sendmail_honbun			�ĥ᡼���������:����������ʸ
#			sendmail_title			�ĥ᡼�������������������᡼��Υ����ȥ�
sub html_mail_naiyou() {
	#���֥롼���󷲥���
	require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
	
	#�ե�����γ��Ͱ����ͽ���
	$addlink[0]=~ s/&sendmail_sw=2/&sendmail_sw=1/g;
	$addlink[1]=~ s/name=sendmail_sw value=2/name=sendmail_sw value=1/;
	$addlink[2]=~ s/name=sendmail_sw value=2/name=sendmail_sw value=1/;
	
	#���ƥ᡼������:�᡼����������
	$output_html=$output_html."	<br><table border><tr><td align=center bgcolor=#ff8888 width=80%>\n";
	$output_html=$output_html."	<b>���ƥ᡼������</b> : �᡼����������<br>\n";
	if($sendmail_kazu>0) {
		$output_html=$output_html."	�����������᡼�����Ƥ����Ϥ��Ƥ���������\n";
	}
	$output_html=$output_html."	</td></tr></table><br>\n";
	
	#���Υ�å�������ɽ��
	if($sendmail_kazu>0) {
		local($i);	#�롼����
		
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<table>\n";
		#�����襢�ɥ쥹��ɽ��
		$output_html=$output_html."<tr><td align=left><b>������:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		for($i=$#kokyaku_data;$i>0;$i--) {
			&tab_cut($kokyaku_data[$i]);
			if($form{substr($cut_end[0],0,11)}==1) {
				if(length($cut_end[16])>3) {
					$output_html=$output_html."���� <b><a href=$file_main.$addlink[0].'&html_sw=2&call_no=$cut_end[0]'>$cut_end[2]</a></b> / <a href='mailto:$cut_end[16]'>$cut_end[16]</a><br>\n";
				} else {
					$output_html=$output_html."���� <b><s><a href=$file_main.$addlink[0].'&html_sw=2&call_no=$cut_end[0]'>$cut_end[2]</a></s></b> / �᡼�륢�ɥ쥹̤����ˤ��̵��<br>\n";
				}
			}
		}
		$output_html=$output_html."</td></tr>\n";
		
		#�����ȥ����ϥե�����
		$output_html=$output_html."<tr><td align=left><b>��������᡼��Υ����ȥ�:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>����<input type=text name=sendmail_title size=90></td></tr>\n";
		
		#�������ϥե�����
		$output_html=$output_html."<tr><td><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left><b>��������᡼�����ʸ:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		$output_html=$output_html."<textarea name=sendmail_honbun cols=64 rows=20 warp=soft></textarea>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=15>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."<tr><td align=center>\n";
		$output_html=$output_html."<input type=submit value=' �������Ƥ��������� '>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."</table>\n";
		$output_html=$output_html."</form>\n";
	} else {
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."\n";
		$output_html=$output_html."<font color=red><b>�����襢�ɥ쥹�����ꤵ��Ƥ��ޤ���</b></font><br>\n";
		$output_html=$output_html."�غǿ���١ظ�����̡٤���äơ��������������ɥ쥹�� �� ���դ��Ʋ�������<br>\n";
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."<table><td><form action=$file_main method=post>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=$form{'backpage'}>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."<input type=submit value=' ���ɥ쥹�������� '>\n";
		$output_html=$output_html."</form></td></table>\n";
	}
}
1;
