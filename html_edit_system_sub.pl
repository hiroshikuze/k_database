#--------------------------------------
#�ڡ����ν��ϡݴ�������������
#&html_edit_system()
#	����:
#		@config					������ǡ�����
#		$file_kokyaku			�ĸܵҾ���ե�����̾
#		$file_taiou				���б�����ե�����̾
#		$file_sousa_rireki		�İ����������ե�����
#		$html_sw				��ɽ�����Ƥ��ڤ��ؤ�
#		$kanrimode_password		�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		$search_keyword			�ĸ���:�ºݤ˸������륭�����
#		$search_houhou			�ĸ���:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$view_start				�ĺǿ���:��ư���˵�Ͽ�ξ夫��ɽ��������̵�����
#		�ե�����:	(���Ϥȥ��֤�ΤǾ�ά)
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:	change_info			���ѹ�����:�����Ԥ���Τ��Τ餻
#		�ե�����:	change_leave_sousarireki
#										���ѹ�����:������������Ĥ����
#		�ե�����:	change_pass			���ѹ�����:�ѥ����
#		�ե�����:	change_view			���ѹ�����:ɽ������ǿ����Ϸ��
#		�ե�����:	change_view_sousarireki
#										���ѹ�����:������������ɽ��������
#		�ե�����:	change_cut_mailissei_rireki
#										���ѹ�����:�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�
#		�ե�����:	change_view_mailissei_rireki
#										���ѹ�����:���ƥ᡼����������Τ�����ɽ��������
#		�ե�����:	html_sw				�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	kanrimode_check		�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word	�ĸ��������󸡺������������
#		�ե�����:	sendmail_sw			�ĥ᡼���������:�ɤ��������������椫��
#											0�ĥ᡼����������򤽤⤽�⤷�褦�Ȥ��Ƥ��ʤ���
#											1�Ĥɤ��������������档
#											2�ĥ᡼��ʸ������¾��
sub html_edit_system {
	
	local($next_html_sw);	#�����ѹ�����褦����¹Ի���������
	local($navigator);	#����������������Υʥӥ�����
	
	if($form{'sendmail_sw'}==0) {
		#����������������Υʥӥ����Ȥ�����
		$navigator="	<u>= <a href=#sousa_rireki>�����������</a> / <a href=#soushin_rireki>���ƥ᡼������</a> / <a href=#download>�ܵҥǡ����Υ��������</a> / <a href=#setting_systems>������������ѹ�</a> =</u><br>\n";
		
		$output_html=$output_html."	<br>\n";
		
			#�ʥӥ�����ɽ��
		$output_html=$output_html.$navigator;
		
			#�����������
		@kanrimode_rireki=&file_access("<$file_sousa_rireki",15);
		$output_html=$output_html."	<a name=sousa_rireki></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>�����������</b></td></tr></table><br>\n";
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<table width=80%><tr><td align=left><b>�����������ǺǶ�Τ��:</b></td></tr></table>\n";
		$output_html=$output_html."	<table width=80%>\n";
		if($#kanrimode_rireki>0) {
				#���֥롼���󷲥���
			require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ��롣
			local($i);	#������롼����
			
			for($i=$#kanrimode_rireki;($i>$#kanrimode_rireki-$config[4]&&$i>0);$i--) {
				local($j);	#������롼����
				
				&tab_cut($kanrimode_rireki[$i]);
				$output_html=$output_html."	  <tr>\n";
				for($j=0;$j<3;$j++) {
					if($j==2) {
						local($k);
						local(@parts);
						
						@parts=split("<br>",$cut_end[$j]);
						for($k=0,$cut_end[$j]="";$k<$config[8]&&$k<$#parts;$k++) {
							$cut_end[$j]=$cut_end[$j].$parts[$k]."<br>";
						}
						if($#parts>$config[8]) {
							$cut_end[$j]=$cut_end[$j]."(�ʲ�ά)<br>";
						}
					}
					$output_html=$output_html."		<td align=left valign=top>".$cut_end[$j]."</td>\n";
				}
				$output_html=$output_html."	  </tr>\n";
			}
		} else {
			$output_html=$output_html."	  <tr><td align=center valign=middle>�����������ե����� '$file_sousa_rireki' ����Ȥ����ˤʤäƤ��ޤ���<br></td></tr>\n";
		}
		$output_html=$output_html."	</table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>�����������Τ�����\ɽ\��������:</b><br>\n";
		$output_html=$output_html."		��(���� $config[4] �����Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_view_sousarireki value='$config[4]' size=5>��</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>������������Ĥ����:</b><br>\n";
		$output_html=$output_html."		��(���� $config[5] �����Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_leave_sousarireki value='$config[5]' size=5>��</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�:</b><br>\n";
		$output_html=$output_html."		��(���� $config[8] �Ĥ���Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_cut_mailissei_rireki value='$config[8]' size=5>��</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>�����������Υ��������:</b></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom>\n";
		$output_html=$output_html."		<a href=$file_sousa_rireki>�ե�����Υ�������� (Excel���б�)</a><br>\n";
		$output_html=$output_html."		<a href=downdata.cgi?loadfile=$file_sousa_rireki>Excel̵�������б�</a><br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	</tr></table>\n";
		
		$next_html_sw=11;
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' ����������������ѹ� '>\n";
		$output_html=$output_html."	</form>\n";
		
			#���ƥ᡼������
		$output_html=$output_html."	<a name=soushin_rireki></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>���ƥ᡼������</b></td></tr></table><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td align=left><b>���ƥ᡼�������Ƕ������:</b></td></tr></table>\n";
		{
			local($not_found);		#���ƥ᡼��������Ͽ�����Ĥ���ʤ��ä��Ȥ��Υ�å�����
			local($write_count);	#�б�����ܵҾ���򸫤Ĥ������
			local($write_temp);		#ʣ���Υ᡼��������ǧ��
			
			$not_found="	  <tr><td align=center valign=middle>���ƥ᡼���������Ԥ�줿��Ͽ�Ϥ���ޤ���<br></td></tr>\n";
			$output_html=$output_html."	<table width=80%>\n";
				#�ܵҾ�����ɤ߼��
			@rireki_data=&file_access("<$file_taiou",12);
			if(1<$#rireki_data) {
					#���֥롼���󷲥���
				require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ��롣
				
				local($i);	#������롼����
				
				for($i=$#rireki_data,$write_count=0,$write_temp="";(0<$i&&$write_count<$config[7]);$i--) {
					&tab_cut($rireki_data[$i]);
					if($cut_end[0]<0) {
						if($write_temp ne $cut_end[3]) {
							local($k);
							local(@parts);
							
							$output_html=$output_html."	  <tr>\n";
							$output_html=$output_html."		<td align=left valign=top>".$cut_end[3]."</td>\n";
							$output_html=$output_html."		<td align=left valign=top>".$cut_end[2]."</td>\n";
							
							$cut_end[6]=~s /\r\n//g;
							$cut_end[6]=~s /\n//g;
							@parts=split("<br>",$cut_end[6]);
							for($k=0,$cut_end[6]="";$k<$config[8]&&$k<$#parts;$k++) {
								$cut_end[6]=$cut_end[6].$parts[$k]."<br>";
							}
							if($#parts>$config[8]) {
								$cut_end[6]=$cut_end[6]."(�ʲ�ά)<br>";
							}
							$output_html=$output_html."		<td align=left valign=top>".$cut_end[6]."</td>\n";
							
							$output_html=$output_html."	  </tr>\n";
							$write_count++;
							$write_temp=$cut_end[3];
						} else {
							&tab_cut($rireki_data[$i-1]);
							if($cut_end[3] ne $write_temp) {
								$output_html=$output_html."		<tr><td></td><td></td><td align=left valign=top>(¾��ʣ�������ˤ�Ʊ�ͤ����Ƥ��������ޤ���)</td></tr>\n";
							}
						}
					}
				}
			}
			if($write_count==0) {
				$output_html=$output_html."	  <tr><td align=center valign=middle>���ƥ᡼���������Ԥ�줿��Ͽ�Ϥ���ޤ���<br></td></tr>\n";
			} else {
				$output_html=$output_html."		<tr><td align=right valign=top colspan=3>\n";
				$output_html=$output_html."		  <a href=$file_taiou>�б�������������� (Excel���б�)</a><br>\n";
				$output_html=$output_html."		  <a href=downdata.cgi?loadfile=$file_taiou>Excel̵�������б�</a><br>\n";
				$output_html=$output_html."		  <font size=-2>���б��������˰��ƥ᡼�����������ޤ�Ǥ��ޤ���</font><br>\n";
				$output_html=$output_html."		</td></tr>\n";
			}
			$output_html=$output_html."	</table>\n";
		}
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		
		$output_html=$output_html."	<input type=hidden name=sendmail_sw value=1>\n";
		
		$next_html_sw=0;
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' �������ƥ᡼�������򤹤� '>\n";
		$output_html=$output_html."	</form>\n";
		
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<table width=80%>\n";
		$output_html=$output_html."	<tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>���ƥ᡼����������Τ�����\ɽ\��������:</b><br>\n";
		$output_html=$output_html."		��(���� $config[7] �����Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_view_mailissei_rireki value='$config[7]' size=5>��</td>\n";
		$output_html=$output_html."	</tr>\n";
		$output_html=$output_html."	<tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>�����������Ȱ��ƥ᡼����������ǰʲ���ά������Ԥο�:</b><br>\n";
		$output_html=$output_html."		��(���� $config[8] �Ĥ���Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_cut_mailissei_rireki value='$config[8]' size=5>��</td>\n";
		$output_html=$output_html."	</tr>\n";
		$output_html=$output_html."	</table>\n";
		
		$next_html_sw=17;
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' ���ƥ᡼�����������ѹ� '>\n";
		$output_html=$output_html."	</form>\n";
		
			#�ʥӥ�����ɽ��
		$output_html=$output_html.$navigator;
		
			#�ܵҥǡ����Υ��������
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	<a name=download></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>�ܵҥǡ����Υ��������</b></td></tr></table><br>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>�ܵҾ���:</b></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom>\n";
		$output_html=$output_html."		<a href=$file_kokyaku>�ե�����Υ�������� (Excel���б�)</a><br>\n";
		$output_html=$output_html."		<a href=downdata.cgi?loadfile=$file_kokyaku>Excel̵�������б�</a><br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>�б�����:</b></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom>\n";
		$output_html=$output_html."		<a href=$file_taiou>�ե�����Υ�������� (Excel���б�)</a><br>\n";
		$output_html=$output_html."		<a href=downdata.cgi?loadfile=$file_taiou>Excel̵�������б�</a><br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	</tr></table>\n";
		
			#������������ѹ�
		$output_html=$output_html."	<a name=setting_systems></a><br>\n";
		$output_html=$output_html."	<table width=80%><tr><td bgcolor=#ffdddd align=center><b>������������ѹ�</b></td></tr></table><br>\n";
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>�����Ԥ���Τ��Τ餻:</b><br></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><textarea type=text name=change_info rows=5 cols=40 warp=soft>$config[3]</textarea></td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>�ǽ��\ɽ\������ǿ�����:</b><br>\n";
		$output_html=$output_html."		��(���� $view_start �����Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_view value='$view_start' size=5>��</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top>\n";
		$output_html=$output_html."		<b>�б��������¸���:</b><br>\n";
		$output_html=$output_html."	  ��(���� $config[6] �����Ͽ����Ƥ��ޤ�)<br>\n";
		$output_html=$output_html."	  </td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=text name=change_rireki_kazu value='$config[6]' size=5>��</td>\n";
		$output_html=$output_html."	</tr></table>\n";
		$output_html=$output_html."	<table width=80%><tr>\n";
		$output_html=$output_html."	  <td align=left valign=top><b>�ѥ�����ѹ�:</b><br></td>\n";
		$output_html=$output_html."	  <td align=right valign=bottom><input type=password name=change_pass value='$config[1]' size=9></td>\n";
		$output_html=$output_html."	</tr></table>\n";
		
		$next_html_sw=6;
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' ������������ѹ� '>\n";
		$output_html=$output_html."	</form>\n";
		
			#�ʥӥ�����ɽ��
		$output_html=$output_html.$navigator;
	} else {
		#�᡼���������ɥ쥹������ˤϡ�����������������ѹ��Ǥ��ޤ���
		
		$output_html=$output_html."	<font color=red><strong>���ƥ᡼��������������ϡ�����������������ѹ����뤳�ȤϽ���ޤ���</strong></font><br>\n";
		$next_html_sw=5;
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	<form action=$file_main method=post>\n";
		$output_html=$output_html."	<input type=hidden name=html_sw value=$next_html_sw>\n";
		$output_html=$output_html."	<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$output_html=$output_html."	<input type=hidden name=search_before_word value=$search_keyword>\n";
		$output_html=$output_html."	<input type=submit value=' ���ƥ᡼����������ä��ơ�������������̤ذܤ� '>\n";
		$output_html=$output_html."	</form>\n";
	}
		$output_html=$output_html."	<br>\n";
}
1;
