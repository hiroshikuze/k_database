#--------------------------------------
#�ڡ����ν��ϡݺǿ���ˤĤ���&�������
#&html_new_and_search()
#	����:
#		@config					������ǡ�����
#		$error_search			�ĥ��顼:�������ԤˤĤ���
#		$file_main				�ĥᥤ��롼����򼨤����ե�����̾
#		$form{'firstview_page'}	�ĺǿ���:���ڡ����ܤ򸫤Ƥ��뤫
#		$html_sw				��ɽ�����Ƥ��ڤ��ؤ�
#		$kanrimode_password		�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		$kanrimode_sw			�Ĵ����ԥ⡼�ɤ�OFF/ON 0=OFF
#		@kokyaku_data			�ĸܵҥǡ���:��
#		@kokyaku_koumokuname	�ĸܵҥǡ���:�ƹ���̾
#		@rireki_data			������ǡ���:��(�����Ѥ˰����ù�)
#		$search_houhou			�ĸ���:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$search_keyword			�ĸ���:�ºݤ˸������륭�����
#		$sendmail_kazu			�ĥ᡼���������:�������������ο�
#		$view_rireki			���б�����:����ɽ����������ǡ�����?(0��No 1��Yes)
#		$view_rirekistart		���б�����:���٤�ɽ��������
#		@view_kokyaku			�ĺǿ���&�������:����ɽ������ܵҥǡ�����?(0��No 1��Yes)
#		$view_start				�ĺǿ���:��ư���˵�Ͽ�ξ夫��ɽ��������̵�����
#		�ե�����:	(���Ϥȥ��֤�Τ�ά)
#	����:
#		@addlink		�ĥե�����γ��Ͱ�����
#							[0]�ĥ��󥫡��ˤ���Ͱ��Ϥ�
#							[1]�ĥե�����ˤ���Ͱ��Ϥ�
#							[2]�ĥե�����ˤ���Ͱ��Ϥ�(���Խ���)
#		$output_html	��HTML�ɲý�����
#		@rireki_data	������ǡ���:��(�����Ѥ˰����ù�)
#		�ե�����:	ADDR				��mapfan���Ѱ��Ϥ���
#		�ե�����:	backpage			�ĵ�ǽ��λ�����Ƶ�ǽ
#		�ե�����:	callno				�ĸܵ�����:�ƤӽФ�ID
#		�ե�����:	firstview_page		�ĺǿ���:���ڡ����ܤ򸫤Ƥ��뤫
#		�ե�����:	html_sw				�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	kanrimode_check		�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	move_url			�ĳ���URL�ؤΰ�ư:��ư��URL�λ���
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word	�ĸ��������󸡺������������
#		�ե�����:	sendmail_addlist	�İ��ƥ᡼������:�����ꥹ�Ȥ��ɲä����ֹ�(ID�ֹ�ǻ���)
#		�ե�����:	sendmail_all		�İ��ƥ᡼������:�����ꥹ�����Τ��Ф������
#		�ե�����:	sendmail_dellist	�İ��ƥ᡼������:�����ꥹ�Ȥ����������ֹ�(ID�ֹ�ǻ���)
#		�ե�����:	sendmail_sw	�ĥ᡼������������ɤ��������������椫��
sub html_new_and_search {
	local($write_before_next);	#������Ͽ ���Υڡ����� & ���Υڡ�����
	local($sendmail_button);	#���ƥ᡼������:�᡼�������ʤɤΥܥ���ɽ��
	
	#���֥롼���󷲥���
	require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
	
	#���ƥ᡼���������������������ʤ�
	if($form{'sendmail_sw'}>0) {
		$sendmail_button="";
		$sendmail_button=$sendmail_button."\n\n<table><tr>\n";
		$sendmail_button=$sendmail_button."<td>\n";
		$sendmail_button=$sendmail_button."<form action=$file_main method=post>\n";
		$sendmail_button=$sendmail_button.$addlink[1];
		$sendmail_button=$sendmail_button."<input type=hidden name=html_sw value=13>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=backpage value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=submit value=�������Ϥذܤ�>\n";
		$sendmail_button=$sendmail_button."</form>\n";
		$sendmail_button=$sendmail_button."</td>\n";
		$sendmail_button=$sendmail_button."<td>\n";
		$sendmail_button=$sendmail_button."<form action=$file_main method=post>\n";
		$sendmail_button=$sendmail_button.$addlink[1];
		$sendmail_button=$sendmail_button."<input type=hidden name=html_sw value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=backpage value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=sendmail_all value=2>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$sendmail_button=$sendmail_button."<input type=submit value=����Ͽ�ܵҤ��>\n";
		$sendmail_button=$sendmail_button."</form>\n";
		$sendmail_button=$sendmail_button."</td>\n";
		$sendmail_button=$sendmail_button."<td>\n";
		$sendmail_button=$sendmail_button."<form action=$file_main method=post>\n";
		$sendmail_button=$sendmail_button.$addlink[1];
		$sendmail_button=$sendmail_button."<input type=hidden name=html_sw value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=backpage value=$html_sw>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=sendmail_all value=1>\n";
		$sendmail_button=$sendmail_button."<input type=hidden name=firstview_page value=$form{'firstview_page'}>\n";
		$sendmail_button=$sendmail_button."<input type=submit value=���ơߤ��᤹>\n";
		$sendmail_button=$sendmail_button."</form>\n";
		$sendmail_button=$sendmail_button."</td>\n";
		$sendmail_button=$sendmail_button."</tr></table>\n\n";
	}
	
	#���ƥ᡼���������������ꥻ�åȤʤɤ����
	if($form{'sendmail_sw'}>0) {
		$output_html=$output_html.$sendmail_button;
		$output_html=$output_html."<br>\n";
	}
	
	#�������Υ��顼�����å�
	if($error_search==1) {
		$output_html=$output_html."	<b><font color=red>����������ɤ����Ϥ���Ƥ��ޤ���</font></b><br>\n";
	} elsif($error_search==2) {
		$output_html=$output_html."	<b><font color=red>����������ɤ˳��������Ҥ����Ĥ���ޤ���Ǥ�����</font></b><br>\n";
	} else {
		#�������Υ��顼���ʤ���С�
		#ɽ�����ꤷ���ܵҎ�����ǡ�����ɽ������
		local($i);	#�롼��������
		local($j);
		
		if($html_sw==1&&$search_houhou==2) {
			#����ǡ����Ľ��ɽ��������
			
				#�ե�����γ��Ͱ����ͽ�������
			$addlink[0]="backpage=$html_sw&".$addlink[0];
			$addlink[1]=$addlink[1]."<input name=backpage type=hidden value=$html_sw>\n";
			$addlink[2]=$addlink[1];
			$addlink[2]=~ s/\n//g;
			
				#�б�����:�ܵҥǡ����ƤӽФ�ID��Կ�+1
			$output_html=$output_html."	<table>\n";
			$output_html=$output_html."	  <tr><td></td><td></td><td align=center bgcolor=ffdddd><b>�����</b></td><td align=center  bgcolor=ffdddd><b>��ƻ���</b></td><td align=center bgcolor=ffdddd><b>��Ƽ�</b></td><td align=center bgcolor=ffdddd><b>�б�����</b></td><td align=center bgcolor=ffdddd><b>������</b></td></tr>\n";
			for($j=$#view_rireki;$j>-1;$j--) {
				$output_html=$output_html."	  <tr>\n";
				if($view_rireki[$j]==1) {
					local($okikae);	#�֤�����ʸ��
					
					&tab_cut($rireki_data[$j]);
					
					$okikae="<a href='$file_main?html_sw=2&callno=$cut_end[1]&$addlink[0]'>$search_keyword<\/a>";
					$rireki_data[$j+1]=~ s/$search_keyword/$okikae/g;
					&tab_cut($rireki_data[$j+1]);
					
					$output_html=$output_html."		<td valign=top align=left>��</td>\n";
					$output_html=$output_html."<form action=$file_main method='POST'>\n";
					$output_html=$output_html."		<td valign=top align=left>\n";
					$output_html=$output_html."<input name=html_sw type=hidden value=1>\n";
					$output_html=$output_html.$addlink[1];
					if($form{'sendmail_all'}==1) {
						if($form{substr($cut_end[1],0,11)}==1) {
							$output_html=$output_html."<input name=sendmail_dellist type=hidden value=$cut_end[1]>\n";
							$output_html=$output_html."<input type=submit value=��>\n";
						} else {
							$output_html=$output_html."<input name=sendmail_addlist type=hidden value=$cut_end[1]>\n";
							$output_html=$output_html."<input type=submit value=��>\n";
						}
					}
					$output_html=$output_html."		</td>\n";
					$output_html=$output_html."</form>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[2]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[3]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[4]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[5]</td>\n";
					$output_html=$output_html."		<td valign=top align=left>$cut_end[6]</td>\n";
				}
				$output_html=$output_html."	  </tr>\n";
			}
			$output_html=$output_html."	</table>\n";
		} else {
			#�ܵҥǡ����Ľ��ɽ��������
			
			#�ե�����γ��Ͱ����ͽ�������
			$addlink[0]="html_sw=$html_sw&backpage=$html_sw&".$addlink[0];
			$addlink[1]=$addlink[1]."<input name=backpage type=hidden value=$html_sw>\n";
			$addlink[1]=$addlink[1]."<input name=firstview_page type=hidden value=$form{'firstview_page'}>\n";
			$addlink[2]=$addlink[1];
			$addlink[2]=~ s/\n//g;
			
			local($addlink)="";	#�����˥ǡ�����ã
			if($html_sw==0) {
				if($form{'firstview_page'}==0&&length($config[3])>1) {
					$output_html=$output_html."	<div align=right><table border>\n";
					$output_html=$output_html."	  <tr><td align=center bgcolor=FF9999 nowrap><b>�����Ԥ���Τ��Τ餻</b></td></tr>\n";
					$output_html=$output_html."	  <tr><td>$config[3]</td></tr>\n";
					$output_html=$output_html."	</table></div>\n";
					$output_html=$output_html."	<br>\n";
				}
				$output_html=$output_html."	<b>���� ".($form{'firstview_page'}+1)." �ڡ����ܤǤ�</b><br>\n";
			}
			
			#���Υڡ����� & ���Υڡ����� �ˤĤ���
			$write_before_next=$write_before_next."	<br>\n";
			$write_before_next=$write_before_next."	<div align=right>\n";
			
			if(0<$form{'firstview_page'}) {
				$write_before_next=$write_before_next."	  <a href='$file_main?firstview_page=".($form{'firstview_page'}-1)."&$addlink[0]'>&lt;&lt;���Υڡ�����</a> |";
			} else {
				$write_before_next=$write_before_next."	  <font color=#999999><s>&lt;&lt;���Υڡ�����</s></font> |";
			}
			for($i=0,$j=-($form{'firstview_page'}+1)*$view_start;$i<=$#view_kokyaku;$i++) {
				$j=$j+$view_kokyaku[$i];
			}
			if($j>=0) {
				$write_before_next=$write_before_next." <a href='$file_main?firstview_page=".($form{'firstview_page'}+1)."&$addlink[0]'>���Υڡ�����&gt;&gt;</a>\n";
			} else {
				$write_before_next=$write_before_next." <font color=#999999><s>���Υڡ�����&gt;&gt;</s></font>\n";
			}
			$write_before_next=$write_before_next."	</div>\n";
			$write_before_next=$write_before_next."	<br>\n";
			
			$output_html=$output_html.$write_before_next;
			for($i=0,$j=$#view_kokyaku;$j>-1;$j--) {
				if($view_kokyaku[$j]==1) {
					if($form{'firstview_page'}*$view_start<=$i&&$i<($form{'firstview_page'}+1)*$view_start) {
						local($k);					#�롼��������
						local($kokyaku_syousai);	#�ƸܵҾܺپ���
						
						&tab_cut($kokyaku_data[$j+1]);
						for($k=0;$k<$#cut_end;$k++) {
							$kokyaku_syousai[$k]=$cut_end[$k];
						}
						
						$output_html=$output_html."	<table border=1 CELLPADDING=4 CELLSPACING=0 width=640 align=center>\n";
						$output_html=$output_html."	  <tr bgcolor=FF9999>\n";
						$output_html=$output_html."		<td width=70% colspan=2>$kokyaku_koumokuname[ 1] �� <b>$kokyaku_syousai[1]</b></td>\n";
						$output_html=$output_html."		<td width=30%>$kokyaku_koumokuname[22] �� $kokyaku_syousai[22]</td>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	  <tr bgcolor=#ffdddd>\n";
						$output_html=$output_html."		<td width=70% colspan=2>\n";
						$output_html=$output_html."		  <table width=100% border=0><tr>\n";
						if($form{'sendmail_sw'}==1) {
							$output_html=$output_html."			<td align=left valign=middle>\n";
							$output_html=$output_html."<form action=$file_main method='POST'>\n";
							$output_html=$output_html."<input name=html_sw type=hidden value=0>\n";
							$output_html=$output_html.$addlink[1];
							if($sendmail_kazu>0) {
								if($form{substr($kokyaku_syousai[0],0,11)}==1) {
									$output_html=$output_html."<input name=sendmail_dellist type=hidden value=$kokyaku_syousai[0]>\n";
									$output_html=$output_html."<input type=submit value=��>\n";
								} else {
									$output_html=$output_html."<input name=sendmail_addlist type=hidden value=$kokyaku_syousai[0]>\n";
									$output_html=$output_html."<input type=submit value=��>\n";
								}
							} else {
								$output_html=$output_html."<input name=sendmail_addlist type=hidden value=$kokyaku_syousai[0]>\n";
								$output_html=$output_html."<input type=submit value=��>\n";
							}
							$output_html=$output_html."			  $kokyaku_koumokuname[ 2] �� <b><font size=+1>$kokyaku_syousai[2]</font></b>\n";
							$output_html=$output_html."</form>\n";
							$output_html=$output_html."			</td>\n";
						} else {
							$output_html=$output_html."			<td align=left valign=middle>\n";
							$output_html=$output_html."			  $kokyaku_koumokuname[ 2] �� <b><font size=+1>$kokyaku_syousai[2]</font></b>\n";
							$output_html=$output_html."			</td>\n";
						}
						if(length($kokyaku_syousai[25])>0) {
							$output_html=$output_html."			<td width=32><a href='$kokyaku_syousai[25]'><img src='icon_website.gif' border=0></a></td>\n";
						}
						if(length($kokyaku_syousai[16])>0) {
							$output_html=$output_html."			<td width=32><a href='mailto:$kokyaku_syousai[16]'><img src='icon_mail.gif' border=0></a></td>\n";
						}
						$output_html=$output_html."		  </tr></table>\n";
						$output_html=$output_html."		</td>\n";
						$output_html=$output_html."		<td width=30%>$kokyaku_koumokuname[30] �� $kokyaku_syousai[30]</td>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	  <tr>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[ 4] �� $kokyaku_syousai[4]</td>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[ 7] �� $kokyaku_syousai[7]</td>\n";
						$output_html=$output_html."		<form action='dummy.cgi' method=get name=_brank>\n";
						$output_html=$output_html."		<td width=30% colspan=1 align=right>\n";
						if(length($kokyaku_syousai[11])>0) {
							$output_html=$output_html."		  <input type=hidden name=move_url value=http://www.mapfan.com/index.cgi>\n";
							$output_html=$output_html."		  <input type=hidden name=ADDR value=$kokyaku_syousai[11]>\n";
							$output_html=$output_html."		  <input type=submit value=' MapFan ��� '>\n";
						} else {
							$output_html=$output_html."		  '����-̾��'��̤����\n";
						}
						$output_html=$output_html."		</td>\n";
						$output_html=$output_html."		</form>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	  <tr>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[14] �� $kokyaku_syousai[14]</td>\n";
						$output_html=$output_html."		<td width=35%>$kokyaku_koumokuname[15] �� $kokyaku_syousai[15]</td>\n";
						$output_html=$output_html."		<form action=$file_main method='POST'>\n";
						$output_html=$output_html."		<td width=30% colspan=1 align=right>\n";
						$output_html=$output_html.$addlink[1];
						$output_html=$output_html."<input name=html_sw type=hidden value=2>\n";
						$output_html=$output_html."<input name=callno type=hidden value=$kokyaku_syousai[0]>\n";
						$output_html=$output_html."<input type=submit value=' �ܺپ���\ɽ\�� '>\n";
						$output_html=$output_html."		</td>\n";
						$output_html=$output_html."		</form>\n";
						$output_html=$output_html."	  </tr>\n";
						$output_html=$output_html."	</table>\n";
						$output_html=$output_html."	<br>\n";
					}
					$i++;
				}
			}
			$output_html=$output_html.$write_before_next;
		}
	}
	
	#���ƥ᡼���������������ꥻ�åȤʤɤ����
	if($form{'sendmail_sw'}>0) {
		$output_html=$output_html.$sendmail_button;
	}
}
1;
