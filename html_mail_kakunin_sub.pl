#--------------------------------------
#�᡼����������ݥ᡼�����Ƴ�ǧ
#&html_mail_kakunin()
#	����:
#		$file_main				�Ĥ��Υᥤ�󥷥��ƥ�ե�����̾
#		$mailer_demolock		�ĥ᡼��:�����ܥ���򲡤�������������������Ρ�(0��Yes 1��No)
#		@view_rireki			���б�����:����ɽ����������ǡ�����?(0��No 1��Yes)
#		�ե�����:				(���Ϥȥ��֤�ΤǾ�ά)
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:
#			backpage			�ĵ�ǽ��λ�����Ƶ�ǽ
#			callno				�ĸܵ�����:�ƤӽФ�ID
#			firstview_page		�ĺǿ���:���ڡ����ܤ򸫤Ƥ��뤫
#			kanrimode_check		�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#			sendmail_honbun		�ĥ᡼���������������������ʸ
#			sendmail_title		�ĥ᡼�������������������᡼��Υ����ȥ�
sub html_mail_kakunin() {
	#���֥롼���󷲥���
	require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
	
	#�ե�����γ��Ͱ����ͽ���
	
	#���ƥ᡼������:�᡼����������
	$output_html=$output_html."	<br><table border><tr><td align=center bgcolor=#ff8888 width=80%>\n";
	$output_html=$output_html."	<b>���ƥ᡼������</b> : �������ƺǽ���ǧ<br>\n";
	if(length($form{'sendmail_honbun'})>1) {
		$output_html=$output_html."	�ʲ������Ƥ��������ޤ�����ǧ���Ƥ���������\n";
	}
	$output_html=$output_html."	</td></tr></table><br>\n";
	
	#���Υ�å�������ɽ��
	if(length($form{'sendmail_honbun'})>1) {
		local($i);	#�롼����
		
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<table width=500>\n";
		#�����襢�ɥ쥹��ɽ��
		$output_html=$output_html."<tr><td align=left><b>������:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		for($i=$#kokyaku_data;$i>0;$i--) {
			&tab_cut($kokyaku_data[$i]);
			if($form{substr($cut_end[0],0,11)}==1) {
				if(length($cut_end[16])>3) {
					$output_html=$output_html."�� <b><a href=$file_main.$addlink[0].'&html_sw=2&call_no=$cut_end[0]'>$cut_end[2]</a></b> / <a href='mailto:$cut_end[16]'>$cut_end[16]</a><br>\n";
				}
			}
		}
		$output_html=$output_html."</td></tr>\n";
		
		#�������ϥե�����
		$output_html=$output_html."<tr><td><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left><b>��������᡼��Υ����ȥ�:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left>\n";
		$output_html=$output_html.$form{'sendmail_title'}."\n";
		$output_html=$output_html."<input type=hidden name=sendmail_title value=$form{'sendmail_title'}>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."<tr><td><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left><b>��������᡼�����ʸ:</b><br></td></tr>\n";
		$output_html=$output_html."<tr><td align=left height=20>\n";
		{
			local @honbun;
			
			for($i=0;$i<2;$i++) {
				$honbun[$i]=$form{'sendmail_honbun'};
			}
			$honbun[0]=~ s/\n/\\n/g;
			$honbun[0]=~ s/\r/\\r/g;
			$honbun[1]=~ s/\r\n/<br>/g;
			$honbun[1]=~ s/\n/<br>/g;
			$output_html=$output_html."<input type=hidden name=sendmail_honbun value=$honbun[0]>\n";
			$output_html=$output_html.$honbun[1]."\n";
		}
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=16>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."<tr><td align=center>\n";
		if($mailer_demolock==0) {
			$output_html=$output_html."<input type=submit value=' �������Ƥ��������������� '>\n";
		} else {
			$output_html=$output_html."<font color=red>\n";
			$output_html=$output_html."�������᡼�������ˤϥǥ��å����ݤ��äƤ���ٽ���ޤ���<br>\n";
			$output_html=$output_html."ź�դ�<a href=info_use.html#install>��info_use.html��</a>�򻲹ͤ˽������Ʋ�������<br>\n";
			$output_html=$output_html."</font>\n";
		}
		$output_html=$output_html."</td></tr>\n";
		$output_html=$output_html."</table>\n";
		$output_html=$output_html."</form>\n";
	} else {
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."\n";
		$output_html=$output_html."<font color=red><b>��ʸ�����Ϥ���Ƥ��ޤ���</b></font><br>\n";
		$output_html=$output_html."���Υڡ�������äơ���ʸ�����Ϥ��Ƥ���������<br>\n";
		$output_html=$output_html."<br><br>\n";
		$output_html=$output_html."<table><td><form action=$file_main method=post>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$output_html=$output_html."<input type=hidden name=html_sw value=$form{'backpage'}>\n";
		$output_html=$output_html."<input type=hidden name=backpage value=$html_sw>\n";
		$output_html=$output_html."<input type=submit value=' �᡼���������Ϥ���� '>\n";
		$output_html=$output_html."</form></td></table>\n";
	}
}
1;
