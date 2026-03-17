#--------------------------------------
#�ܵҴ���DataBase�� HTML������ʬ
#&output($html_sw)
#	����(�ե��������ϥǡ����Ͼ�ά):
#		@config				������ǡ�����
#			0�Ĳ���ʸ�����ԤǤϻ��Ѥ��ʤ���
#			1�ĸ�����Ͽ����Ƥ���ѥ����
#			2�ĵ�ư���ʤɤ�ɽ�������Ƕ���Ͽ���줿���
#			3�ĺǿ���ʤɤ�ɽ�����������Ԥ���Τ��Τ餻
#		$edit_id			�ľܺ١�:����ID
#		$edit_inputerror	�ľܺ١�:�ɲäκݤǤΥȥ�֥����äƤ���Τ���
#		$error_code			�ĥ��顼:���顼������
#		$error_file			�ĥ��顼:���顼��������������ե�����̾
#		$error_htmlplus		�ĥ��顼:HTML���ϻ����ɲå�å�����
#		$error_search		�ĥ��顼:�������ԤˤĤ���
#		$file_kokyaku		�ĸܵҾ���ե�����̾
#		$file_kokyaku_bak	����1����Хå����å׸ܵҾ���ե�����̾
#		$file_main			�ĥᥤ��롼����򼨤����ե�����̾
#		$file_taiou			���б�����ե�����̾
#		$file_taiou_bak		����1����Хå����å��б�����ե�����̾
#		$html_sw��ɽ�����Ƥ��ڤ��ؤ�
#			0�ĺǿ� ?�� �ˤĤ���(�������)
#			1�ĸ������
#			2�ľܺ�(���������ɲÎ����)����ɽ��
#			3�Ľ������ɲÎ������ǧ
#			4��NULL
#			5�ĥ����ƥ������ǽ
#			6�ĥ����ƥ������ǽ��ǧ
#			7��NULL
#			8�Ĵ����Ե�ǽON/OFF�ڤ��ؤ���ǧɽ��
#			9��NULL
#			10���б�������Խ�����
#			11�İ����������������ѹ���ǧ
#			12��NULL
#			13�İ��ƥ᡼�����������ѹ�
#			14��NULL
#		$kanji_code			�Ļ��Ѥ�����������ɤˤĤ���
#		$kanrimode_crypt	�Ĵ�����:�������ƥ����ѥѥ���ɰŹ������
#		$kanrimode_password		�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		$kanrimode_passwordkari	�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ��Ѳ�
#		$kanrimode_sw			�Ĵ����ԥ⡼�ɤ�OFF/ON 0=OFF
#		@kokyaku_data			�ĸܵҥǡ���:��
#		@kokyaku_data_menu		�ĸܵҥǡ���:�ܵҥǡ�����˥塼��ʬ�Ǥν��ɽ������
#		@kokyaku_koumokuname	�ĸܵҥǡ���:�ƹ���̾
#		@kokyaku_inputcyuui		�ĸܵҥǡ���:���ϻ������ե�����
#		@kokyaku_syousai		�ĸܵҥǡ���:�ܺ١Ļ��Υե����������ϳƼ�ǡ���
#		$reload_url				�ĸܵҴ����ǡ����١������ɤ�ľ��
#		@rireki_data			������ǡ���:��
#		@rireki_koumokuname		������ǡ���:�ƹ���̾
#		$rireki_viewall			������ǡ���:���β��ID�ǳ���ɽ���������Ƥϲ��狼��
#		$search_keyword		�ĸ���:�ºݤ˸������륭�����
#		$search_houhou		�ĸ���:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$system_back		�ĵ�ǽ�¹�:������λ�厥�������ֹ�
#		@taiou_koumokuname		���б��ǡ���:�ƹ���̾
#		$version			�ĥ����ƥ�С���������
#		@view_kokyaku		�ĺǿ���&�������:����ɽ������ܵҥǡ�����?(0��No 1��Yes)
#		@view_rireki		���б�����:����ɽ����������ǡ�����?(0��No 1��Yes)
#		$view_rirekistart	���б�����:ɽ�������٤˽ФƤ����􎥽����
#		$view_start			�ĺǿ���:��ư���˵�Ͽ�ξ夫��ɽ��������̵�����
#		$form{''}			(���Ϥȥ��֤�Τ�ά)
#	����:
#		$form{'backpage'}				�ĵ�ǽ��λ�����Ƶ�ǽ
#		$form{'bye'}					�ĸܵ�����:���θܵҥǡ������?! 0��No 1��Yes
#		$form{'callno'}					�ĸܵ�����:�ƤӽФ�ID
#		$form{'change_info'}			���ѹ�����:�����Ԥ���Τ��Τ餻
#		$form{'change_pass'}			���ѹ�����:�ѥ����
#		$form{'change_view'}			���ѹ�����:ɽ������ǿ����Ϸ��
#		$form{'firstview_page'}			�ĺǿ���:���ڡ����ܤ򸫤Ƥ��뤫
#		$form{'html_sw'}				�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		$form{'kanrimode_check'}		�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		$form{'kanrimode_change'}		�Ĵ����ԥ⡼��:��ư�ѥѥ�������Ϥ��줿ʸ��
#		$form{'kanrimode_pass'}			�Ĵ����ԥ⡼��:�����ԥ⡼�ɿ��������Ϥ��줿
#										�ѥ����
#		$form{'keyword_kokyaku'}		�ĸ������ܵҥǡ������鸡�����륭�����
#		$form{'keyword_rireki'}			�ĸ���������ǡ������鸡�����륭�����
#		$form{'input_kokyakudata?'}		�ĥե�����:�����Ϥ��줿�ǡ���
#		$form{'rireki_callno'}			���б�����:�Խ�����Τ�����ID
#		$form{'rireki_command	'}		���б�����:�ܵҥǡ�����ɤ����뤫
#										0�Ŀ����ɲ� 1�ĺ�� 2�Ľ���
#		$form{'rireki_inputtime'}		���б�����:���Ϥ��줿����
#		$form{'rireki_inputsyubetsu'}	���б�����:�б�������Ͽ
#		$form{'rireki_inputid	'}		���б�����:�ܵ�ID��Ͽ
#		$form{'rireki_inputkokyaku'}	���б�����:�ܵ�̾��Ͽ
#		$form{'rireki_inputtaiousya'}	���б�����:�б�����Ͽ
#		$form{'rireki_inputnaiyou'}		���б�����:�б�������Ͽ
#		$form{'rireki_viewpage	'}		���б�����:���Ƥ���ڡ����ˤĤ���
#		$form{'search_before_houhou'}	�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		$form{'search_before_word'}		�ĸ��������󸡺������������
#		$form{'sendmail_sw'}			�ĥ᡼���������:�ɤ����������������椫��
#											0�ĥ᡼����������򤽤⤽�⤷�褦�Ȥ��Ƥ��ʤ���
#											1�Ĥɤ����������������档
#											2�ĥ᡼��ʸ������¾��
sub output {
	#�ǡ����ΰ��Ѥ�
	local($html_sw)=@_;	#�ե�����ǡ�������ε�ǽ�ڤ��ؤ�
	
	#�Ƽ���������ѿ��λ���
	local(@loaded_templatehtml);	#�ƥ�ץ졼�ȥǡ�����Ǽ��
	local($i);	#�롼��������
	local($output_html)="";		#HTML�ɲý�����
	local($output_html2)="";	#HTML���Ϻǽ�������
	
	#�ե�����γ��Ͱ�����
	local(@addlink);		#�ե�����γ��Ͱ�����
	local($sendmail_kazu);	#�᡼���������:�������������ο�
	{
		#���ƥ᡼������:����������ɤ߼��
		local(@keys);	#�ϥå�����Υ����ꥹ�ȼ�����
		
		if($form{'sendmail_sw'}>0) {
			local($i);		#�롼����
			
			$sendmail_kazu=0;
			@keys=sort keys %form;
			for($i=0;$i<=$#keys;$i++) {
				if(length($keys[$i])>0&&$keys[$i]==0) {
					splice(@keys,$i,1);
					$i--;
				} else {
					$sendmail_kazu++;
				}
			}
		}
		
		#�Ȥ��ޤ魯�ե����������ǡ���
			#���󥫡����ɲ�
		$addlink[0]="";
		if($kanrimode_sw==1) {
			$addlink[0]=$addlink[0]."&kanrimode_check=$kanrimode_password";
		}
		if($form{'sendmail_sw'}>0) {
			local($i);
			$addlink[0]=$addlink[0]."&sendmail_sw=1";
			for($i=0;$i<=$#keys;$i++) {
				$addlink[0]=$addlink[0]."&$keys[$i]=1";
			}
		}
		if($search_houhou>0) {
			local($search_keyword_encode);
			
		    $search_keyword_encode=$search_keyword;
		    $search_keyword_encode=~ s/(\W)/'%' . unpack('H2', $1)/eg;
			$addlink[0]=$addlink[0]."&search_before_houhou=".$search_houhou."&search_before_word=".$search_keyword_encode;
		}
			#�ե�������ɲ�(����)
		$addlink[1]="";
		$addlink[1]=$addlink[1]."<input type=hidden name=kanrimode_check value=$kanrimode_password>\n";
		$addlink[1]=$addlink[1]."<input type=hidden name=search_before_houhou value=$search_houhou>\n";
		$addlink[1]=$addlink[1]."<input type=hidden name=search_before_word value=$search_keyword>\n";
		if($form{'sendmail_sw'}>0) {
			local($i);
			$addlink[1]=$addlink[1]."<input type=hidden name=sendmail_sw value=$form{'sendmail_sw'}>\n";
			for($i=0;$i<=$#keys;$i++) {
				$addlink[1]=$addlink[1]."<input type=hidden name=$keys[$i] value=1>\n";
			}
		}
			#�ե�������ɲ�(��Ԥ�Ż�᤿���)
		$addlink[2]=$addlink[1];
		$addlink[2]=~ s/\n//g;
			#�ե�������ɲ�(������ǽ��)
		$addlink[3]=$addlink[1];
		$addlink[3]=~ s/<input type=hidden name=search_before_houhou value=$search_houhou>\n//g;
		$addlink[3]=~ s/<input type=hidden name=search_before_word value=$search_keyword>\n//g;
			#��������к�
		if(length($reload_url)>0) {
			$reload_url=$reload_url."?html_sw=".$sw;
			if($kanrimode_sw==1) {
				$reload_url=$reload_url."&kanrimode_check=$kanrimode_password";
			}
			if($search_houhou>0) {
				$reload_url=$reload_url."&search_before_houhou=".$search_houhou."&search_before_word=".$search_keyword;
			}
		}
	}
	
	if(length($error_htmlplus)>0||length($reload_url)>0) {
		#�ᥤ��롼������ǲ��餫�Υ��顼��ȯ�����Ƥ���
		$output_html=$error_htmlplus;
	} else {
		#�����󡦼¹�������ʤɤξ���������
		$output_html=$output_html."<div align=right>$version</div>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<table width=100% bgcolor=#cccccc>\n";
		$output_html=$output_html."  <tr>\n";
		if($kanrimode_sw!=1) {
			$output_html=$output_html."	<td align=right width=50%><b><font color=red>�����ԥ⡼�ɡ�OFF</font></b></td>\n";
			$output_html=$output_html."	<td align=right width=50%>�ѥ���ɡ� <input type=password name=kanrimode_pass value='' size=9> <input type=submit value=' �����ԥ⡼�ɵ�ư '></td>\n";
		} else {
			$output_html=$output_html."	<td align=right width=50%><b><font color=red>�����ԥ⡼�ɡ�ON</font></b></td>\n";
			$output_html=$output_html."	<td align=right width=50%><input type=submit value=' �����ԥ⡼�ɽ�λ '></td>\n";
		}
		$output_html=$output_html."  </tr>\n";
		$output_html=$output_html."</table>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=html_sw value=8>\n";
		$output_html=$output_html."</form>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<form action=$file_main method=post>\n";
		$output_html=$output_html."<div align=center>\n";
		$output_html=$output_html."<b>�ܵҸ���</b> <input type=text name=keyword_kokyaku value='' size=40> <input type=submit value=' ���� '><br>\n";
		$output_html=$output_html."<b>���򸡺�</b> <input type=text name=keyword_rireki value='' size=40> <input type=submit value=' ���� '><br>\n";
		$output_html=$output_html."</div>\n";
		$output_html=$output_html.$addlink[3];
		$output_html=$output_html."<input type=hidden name=html_sw value=1>\n";
		$output_html=$output_html."</form>\n";
		
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<br>\n";
		$output_html=$output_html."<table width=100% border=0 cellpadding=0 cellspacing=0>\n";
		{
			local($j);	#�롼��������
			local(@function);		#ɽ������Ƽﵡǽ̾
			local(@function_red);	#�طʤ��֤�ɽ�����뤫(1=Yes)��
			
			$output_html=$output_html."  <tr>\n";
			
				#�ǿ���ˤĤ���
			$function[0]="�ǿ��硡(<b>$view_start ��</b>����)";
			if($html_sw==0) {
				$function_red[0]=1;
			} else {
				$function[0]="<a href='$file_main?html_sw=0$addlink[0]'>$function[0]</a>";
			}
				#�������
			$function[1]="�������";
			if(length($search_keyword)>0) {
				$function[1]="'".$search_keyword."' �θ������";
			}
			if($html_sw==1) {
				$function_red[1]=1;
			} elsif(length($search_keyword)>0) {
				$function[1]="<a href='$file_main?html_sw=1$addlink[0]'>$function[1]</a>";
			}
				#�َܺ��������ɲÎ����
			if($kanrimode_sw!=1) {
				$function[2]="�َܺ�����";
			} else {
				$function[2]="�َܺ��������ɲÎ����";
			}
			if($html_sw==2||$html_sw==3||$html_sw==10) {
				$function_red[2]=1;
			}
				#��������������
			if($kanrimode_sw==1) {
				$function[3]="��������������";
				if($html_sw==5||$html_sw==6) {
					$function_red[3]=1;
				} else {
					$function[3]="<a href='$file_main?html_sw=5$addlink[0]'>$function[3]</a>";
				}
			}
			
			for($j=0;$j<=$#function;$j++) {
				if($function_red[$j]==1) {
					$output_html=$output_html."	<td align=center bgcolor=#ff8888>$function[$j]</td>\n";
				} else {
					$output_html=$output_html."	<td align=center>$function[$j]</td>\n";
				}
			}
			
			$output_html=$output_html."  </tr>\n";
		}
		
		$output_html=$output_html."  <tr><td bgcolor=#ff4444 colspan=4></td></tr>\n";
		$output_html=$output_html."  <tr>\n";
		$output_html=$output_html."	<td align=center bgcolor=#ffffff colspan=4>\n";
		$output_html=$output_html."	<br>\n";
		if($kanrimode_sw==1&&(!($form{'callno'}==-1&&(2<=$html_sw&&$html_sw<=4)))) {
			$output_html=$output_html."	<table><tr>\n";
			# ���ݡ��Ȥ����Ҥο����ɲ�
			$output_html=$output_html."	<td><form action=$file_main method=post><input type=submit value=' ���ݡ��Ȥ����Ҥο����ɲ� '><input type=hidden name=html_sw value=2><input type=hidden name=callno value=-1><input type=hidden name=backpage value=$system_back>".$addlink[2]."</form></td>\n";
			if($html_sw==2) {
				$output_html=$output_html."	<td><form action=$file_main method=post><input type=submit value=' ���β�Ҥ������� '><input type=hidden name=html_sw value=3><input type=hidden name=callno value=$form{'callno'}><input type=hidden name=backpage value=$system_back><input type=hidden name=bye value=1>".$addlink[2]."</form></td>\n";
			}
			$output_html=$output_html."	</tr></table>\n";
		}
		$output_html=$output_html."	<br>\n";
		
		
			#�ٹ�ʸ���������ɽ��
		if(length($edit_inputerror)>0) {
			$output_html=$output_html."	$edit_inputerror\n";
		}
		
			#���ƥ᡼������:�����襢�ɥ쥹������
		if($form{'sendmail_sw'}==1) {
			$output_html=$output_html."	<br><table border><tr><td align=center bgcolor=#ff8888 width=80%>\n";
			$output_html=$output_html."	<b>���ƥ᡼������</b> : ������λ���<br>\n";
			$output_html=$output_html."	�غǿ���١��ظ�����̡�ɽ�����ڤ��ؤ��ơ������򤷤�����Ҥˡء��٤�����Ƥ���������\n";
			$output_html=$output_html."	</td></tr></table><br>\n";
		}
		
		#�Ƶ�ǽ���Ȥν���
		if($html_sw==0||$html_sw==1) {
			#�ǿ���ˤĤ���-----------------------------------------------------
			#�������-----------------------------------------------------------
			require 'html_new&search_sub.pl';
			&html_new_and_search();
		} elsif($html_sw== 2) {
			#�ܺ�(���������ɲÎ����)����ɽ��--------------------------------------
			require 'html_syousai0_sub.pl';
			&html_syousai_info();
		} elsif($html_sw== 3) {
			#�������ɲÎ������ǧ-------------------------------------------------
			require 'html_syousai1_sub.pl';
			&html_syousai_check();
		} elsif($html_sw== 5) {
			#��������������-----------------------------------------------------
			require 'html_edit_system_sub.pl';
			&html_edit_system();
		} elsif($html_sw== 6) {
			#���������������ѹ���ǧ---------------------------------------------
			require 'html_check_system_sub.pl';
			&html_check_system(5,7);
		} elsif($html_sw==11) {
			#�����������������ѹ���ǧ-----------------------------------------
			require 'html_check_sousarireki_sub.pl';
			&html_check_sousarireki(5,12);
		} elsif($html_sw==17) {
			#���ƥ᡼�����������ѹ�---------------------------------------------
			require 'html_check_set_sendmail_sub.pl';
			&html_check_set_sendmail(5,14);
		} elsif($html_sw==13) {
			#�᡼����������-----------------------------------------------------
			require 'html_mail_naiyou_sub.pl';
			&html_mail_naiyou();
		} elsif($html_sw==15) {
			#�᡼�����Ƴ�ǧ-----------------------------------------------------
			require 'html_mail_kakunin_sub.pl';
			&html_mail_kakunin();
		} elsif($html_sw== 8) {
			#�����Ե�ǽ�Υ����å�ON/OFF�ˤĤ���---------------------------------
			require 'html_kanrimode_switch_sub.pl';
			&html_kanrimode_switch();
		} elsif($html_sw==10) {
			#�б�������Խ�����-------------------------------------------------
			require 'html_syousai2_sub.pl';	
			&html_edit_taiou();
		}
		
		#�����󡦼¹�������ʤɤν�ü������
		$output_html=$output_html."	<br>\n";
		$output_html=$output_html."	</td>\n";
		$output_html=$output_html."  </tr>\n";
		$output_html=$output_html."  <tr>\n";
		$output_html=$output_html."	<td bgcolor=#ff4444 colspan=4></td>\n";
		$output_html=$output_html."  </tr>\n";
		$output_html=$output_html."</table>\n";
	}
	
	if(length($reload_url)>0) {
		#�ե�����������ɤ��뤳�Ȥǡ��ֹ����פ򲡤��Ƥ�2��ư��ʤ��褦�ˤ���
		local($http_httphost);
		local($http_documenturi);
		$http_httphost=$ENV{"HTTP_HOST"};
		$http_documenturi=$ENV{"REQUEST_URI"};
		for($i=length($http_documenturi);substr($http_documenturi,$i,1) ne '/';$i--) {
			$http_documenturi=substr($http_documenturi,0,$i);
		}
		$reload_url="http://".$http_httphost.$http_documenturi.$reload_url;
		
		#�إå��ν���
		print "Location: $reload_url\n\n";
	} else {
		#�إå��ν���
		print "Content-type: text/html;charset=$kanji_code\n\n";
		
		#ɽ�����ΤΥ쥤����������
$output_html2 = <<"end";
<html>
<head>
<title>$version</title>
<LINK REL="SHORTCUT ICON" href="favicon.ico">
<meta http-equiv="Content-Type" content="text/html; charset=$kanji_code">
<style type="text/css">
<!--
body {font-family:"�ͣ� �Х����å�","�ͣ� �����å�",sans-serif; line-height:normal; color:black; font-style:normal; font-weight:normal; text-decoration:normal;
	margin-top: 5px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px;}
h1 {  padding-bottom: 3px; border-color: white red red white; font-family: "�ͣ� �����å�", "Osaka������"; border-style: solid; border-top-width: 0px; border-right-width: 15px; border-bottom-width: 3px; border-left-width: 0px}

address {line-height:normal; color:black; text-align:right; font-style:italic;
	margin-top: 12px; margin-right: 12px}
a.address {font-family:sans-serif; line-height:normal; color:blue; font-style:italic; font-weight:bold; text-decoration:normal;}
-->
</style>
</head>
<body bgcolor="#ffeeee" text="#000000" link="#0000aa" vlink="#0000aa" alink="#ff0000">
<h1><img src="icon_k_database.gif" width="64" height="64" alt="(icon)">��$version</h1>
<div align=center> 
  <table width="730" border="0">
	<tr> 
	  <td> 
		<div align=right><a href="info_use.html#play">info_use.html (�إ��) ���ɤ�</a></div>
		<br>
		
$output_html
		
	  </td>
	</tr>
  </table>
</div>
<br>
<table width="100%" height="16" border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td bgcolor="#aaaaaa" bordercolor="0" valign="middle" align="left" nowrap> 
	  <b><font size="-1"><a href="https://kuje.kousakusyo.info/tools/" class=vector target="_parent">����
	  ��������Tools�ʺ�ԤΥ����ȡˤ�</a></font>��<font size="-1"><a href="https://kuje.kousakusyo.info/tools/k_database/" class=vector target="_parent">��   ���Υ��եȤΥ��ݡ��ȥڡ�����</a></font></b> </td>
	<td width="25">��</td>
  </tr>
</table>
<br>
<table border="0" width="100%">
  <tr> 
	<td width="10"> </td>
	<td bgcolor="#aaaaaa" align="right"> 
	  <address><font color="#FFFFFF">&copy;Copyright <strong><a href="mailto:kuze_work\@hotmail.com">Hiroshi 
	  Kuze</a></strong> 2002-2004.<br>
	  ��ո��洶�ۤ���¾�������� <a href="http://kuze.tsukaeru.jp/tools/bbs/"><b>�Ǽ���</b></a> 
	  �� <a href="mailto:kuze_work\@hotmail.com"><b>kuze_work\@hotmail.com</b></a> 
	  ��</font> </address>
	</td>
  </tr>
</table>
</body>
</html>
end
	}

	#¾�����ȤؤΥ���å����줿��硢HTTP_REFERER�ǥǡ�����ή�Ф���ʤ��褦��
	#���ߡ��ڡ����ؤޤ�����褦�ˤ���
	$output_html2=~ s/href=\"http:/href=\"dummy.cgi?move_url=http:/g;
	$output_html2=~ s/href=\'http:/href=\'dummy.cgi?move_url=http:/g;

	#HTML����
	print $output_html2;

}
1;
