#--------------------------------------
#�ڡ����ν��ϡݾܺ�(���������ɲÎ����)����ɽ��
#&html_syousai_info()
#	����:
#		@addlink				�ĥե�����γ��Ͱ�����
#									[0]�ĥ��󥫡��ˤ���Ͱ��Ϥ�
#									[1]�ĥե�����ˤ���Ͱ��Ϥ�
#									[2]�ĥե�����ˤ���Ͱ��Ϥ�(���Խ���)
#		$edit_id				�ľَܺ��������ɲÎ����:����ID
#		$edit_inputerror		�ľَܺ��������ɲÎ����:�ɲäκݤǤΥȥ�֥����äƤ��롩
#		$file_main				�ĥᥤ��롼����򼨤����ե�����̾
#		$html_sw				��ɽ�����Ƥ��ڤ��ؤ�
#		$kanrimode_password		�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		@kokyaku_koumokuname	�ĸܵҥǡ���:�ƹ���̾
#		@kokyaku_inputcyuui		�ĸܵҥǡ���:���ϻ�����ե�����
#		@kokyaku_syousai		�ĸܵҥǡ���:�ܺ١Ļ��Υե����������ϳƼ�ǡ���
#		@rireki_data			������ǡ���:��(�����Ѥ˰����ù�)
#		@rireki_koumokuname		������ǡ���:�ƹ���̾
#		$rireki_viewall			������ǡ���:���β��ID�ǳ���ɽ���������Ƥϲ��狼��
#		$search_houhou			�ĸ���:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$search_keyword			�ĸ���:�ºݤ˸������륭�����
#		$system_back			�ĵ�ǽ�¹�:������λ�厥�������ֹ�
#		@view_rireki			���б�����:����ɽ����������ǡ�����?(0��No 1��Yes)
#		$view_rirekistart		���б�����:���٤�ɽ��������
#		�ե�����:				(���Ϥȥ��֤�ΤǾ�ά)
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:	backpage				�ĵ�ǽ��λ�����Ƶ�ǽ
#		�ե�����:	callno					�ĸܵ�����:�ƤӽФ�ID
#		�ե�����:	html_sw					�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	input_kokyakudata?		�ĳ����Ϥ��줿�ǡ���
#		�ե�����:	kanrimode_check			�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	rireki_callno			���б�����:�Խ�����Τ�����ID
#		�ե�����:	rireki_command			���б�����:�ܵҥǡ�����ɤ����뤫
#												0�Ŀ����ɲ� 1�ĺ�� 2�Ľ���
#		�ե�����:	rireki_inputkokyaku		���б�����:�ܵ�̾��Ͽ
#		�ե�����:	rireki_inputid			���б�����:�ܵ�ID��Ͽ
#		�ե�����:	rireki_inputnaiyou		���б�����:�б�������Ͽ
#		�ե�����:	rireki_inputsyubetsu	���б�����:�б�������Ͽ
#		�ե�����:	rireki_inputtaiousya	���б�����:�б�����Ͽ
#		�ե�����:	rireki_inputtime		���б�����:���Ϥ��줿����
#		�ե�����:	rireki_viewpage			���б�����:���Ƥ���ڡ����ˤĤ���
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word		�ĸ��������󸡺������������
sub html_syousai_info {
	local($j);	#�롼��������
	
	if($form{'callno'}==-1) {
		#�����ɲäʤ�
		$output_html=$output_html."	<table width=70%><tr><td align=center bgcolor=#88ff88>\n";
		$output_html=$output_html."		<b>�� ���ݡ��Ȥ����Ҥο����ɲ� ��</b>\n";
		$output_html=$output_html."	</td></tr></table>\n";
	}
	
	
	$output_html=$output_html."	<table><tr>\n";
	
	
	#�ܵҥǡ����ˤĤ���
	$output_html=$output_html."	  <td align=left valign=top><div align=center>\n";
	$output_html=$output_html."		<form action=$file_main method=post>\n";
	$output_html=$output_html."		<table border>\n";
	
	require'options_lib.pl';
		#�ե�����ǥ�˥塼�������ɽ������ʸ����
	
	$output_html=$output_html."		  <tr><td colspan=2 align=center bgcolor=ffdddd><b>�ܵҥǡ���</b></td></tr>\n";
	for($j=0;$j<=$#kokyaku_koumokuname;$j++) {
		$output_html=$output_html."		  <tr>\n";
		$output_html=$output_html."			<td align=left valign=top><b><font size=-1>$kokyaku_koumokuname[$j]��</font></b><font size=-2 color=#ff4444>$kokyaku_inputcyuui[$j]</font></td>\n";
		#�ǡ����ˤ�äƥե�����ɤη����Ѥ���
		$output_html=$output_html."			<td align=left valign=middle>";
		if($j==0) {
			if($form{'callno'}!=-1) {
				$output_html=$output_html.$edit_id."<input type=hidden name=input_kokyakudata0 value=$edit_id>";
			} else {
				$output_html=$output_html."<input type=hidden name=callno value=-1>";
				$output_html=$output_html."? ��Ͽ���ϻ��˷��� ?<input type=hidden name=input_kokyakudata0 value='? ��Ͽ���ϻ��˷��� ?'>";
			}
			$kokyaku_syousai[$j]=$edit_id;
		} elsif($j==20||$j==21||$j==22||$j==27||$j==29) {
			local($k); #�롼����
			local(@option_message);		#��˥塼�γ�����
			local($option_message2);	#�ƤӽФ�$kokyaku_data_menu
			
			&options($j);
				#�ե�����ǥ�˥塼�������ɽ������ʸ���󷲸ƤӽФ�
			
			$output_html=$output_html."<select name=input_kokyakudata$j>\n";
			for($k=0;$k<=$#option_message;$k++){
				if($kokyaku_data_menu[$option_message2]==$k) {
					$output_html=$output_html."<option selected value='$k'>$option_message[$k]</option>\n";
				} else {
					$output_html=$output_html."<option value='$k'>$option_message[$k]</option>\n";
				}
			}
			$output_html=$output_html."</select>\n";
		} elsif($j==31||$j==32) {
			$kokyaku_syousai[$j]=~ s/&lt;br&gt;/\n/g;
			$output_html=$output_html."<textarea type=text name=input_kokyakudata$j rows=5 cols=30 warp=soft>$kokyaku_syousai[$j]</textarea>\n";
		} else {
			$output_html=$output_html."<input type=text name=input_kokyakudata$j value='$kokyaku_syousai[$j]' size=30>\n";
		}
		$output_html=$output_html."			</td>";
		$output_html=$output_html."		  </tr>\n";
	}
	$output_html=$output_html."		</table><br>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."<input type=hidden name=html_sw value=3>\n";
	$output_html=$output_html."<input type=hidden name=backpage value=$system_back>\n";
	$output_html=$output_html."<input type=submit value=' �������Ƥ���Ͽ���� '>\n";
	$output_html=$output_html."		</form>\n";
	$output_html=$output_html."	  </div></td>\n";
	
	
	#�б�����ˤĤ���
	if($form{'callno'}!=-1) {
		$output_html=$output_html."	  <td align=left valign=top><div align=center>\n";
		
		#�б����������
		$output_html=$output_html."		<table border>\n";
		$output_html=$output_html."		<tr><td bgcolor=ffdddd align=center><b>�б�����</b></td></tr>\n";
		$output_html=$output_html."		<tr><td><form action=$file_main method=post>\n";
		$output_html=$output_html."		  �� �б�����: \n";
		{
			local($k); #�롼����
			local(@option_message);		#��˥塼�γ�����
			local($option_message2);	#�ƤӽФ�$kokyaku_data_menu
			
			&options(-1);
				#�ե�����ǥ�˥塼�������ɽ������ʸ���󷲸ƤӽФ�
			
			$output_html=$output_html."<select name=rireki_inputsyubetsu>\n";
			for($k=0;$k<=$#option_message;$k++){
				$output_html=$output_html."<option value='$k'>$option_message[$k]</option>\n";
			}
			$output_html=$output_html."</select>\n";
		}
		$output_html=$output_html."		<br>\n";
		$output_html=$output_html."�����б���:<input type=text name=rireki_inputtaiousya value='$kokyaku_syousai[$j]' size=15><br>\n";
		$output_html=$output_html."		  �б�(�䤤��碌)����:<br>\n";
		$output_html=$output_html."<div align=center><textarea type=text name=rireki_inputnaiyou rows=5 cols=40 warp=soft></textarea></div>\n";
		$output_html=$output_html."<input type=hidden name=callno value=$form{'callno'}>\n";
		$output_html=$output_html."<input type=hidden name=rireki_command value=0>\n";
		$output_html=$output_html."<input type=hidden name=rireki_inputid value=$edit_id>\n";
		$output_html=$output_html."<input type=hidden name=rireki_inputkokyaku value=$kokyaku_syousai[2]>\n";
		$output_html=$output_html.$addlink[1];
		$output_html=$output_html."<input type=hidden name=html_sw value=9>\n";
		$output_html=$output_html."<div align=center><input type=submit value=' �������Ͽ���� '></div>\n";
		$output_html=$output_html."		</form></td></tr>\n";
		$output_html=$output_html."		</table>\n";
		
		if($rireki_viewall>0) {
			#�б������ɽ��
			
			local($k)=0;		#ɽ���Ľ�ˤĤ��ƥ�������ѿ�
			
			$addlink[0]=$addlink[0]."&html_sw=2&backpage=$html_sw&callno=".$form{'callno'};
			
			$output_html=$output_html."		<br>\n";
			$output_html=$output_html."		<b>���� ".($form{'rireki_viewpage'}+1)." �ڡ����ܤǤ���</b><br>\n";
			$output_html=$output_html."		<table border>\n";
			for($j=$#view_rireki;0<=$j;$j--) {
				if($view_rireki[$j]==1) {
					if($form{'rireki_viewpage'}*$view_rirekistart<=$k) {
						&tab_cut($rireki_data[$j]);
						
						$output_html=$output_html."		<tr><td>\n";
						$output_html=$output_html."		  <form action=$file_main method=post>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_callno value=$cut_end[0]>\n";
						$output_html=$output_html."		  <table width=100%><tr>\n";
						$output_html=$output_html."			<td align=left><b><font size=-1>$rireki_koumokuname[5]</font></b><br> $cut_end[5] </td>\n";
						$output_html=$output_html."			<td align=center><b><font size=-1>$rireki_koumokuname[4]:</font></b><br> $cut_end[4] </td>\n";
						$output_html=$output_html."			<td align=right><b><font size=-1>$rireki_koumokuname[3]:</font></b><br> $cut_end[3]</td>\n";
						$output_html=$output_html."		  </tr></table>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputsyubetsu value=$cut_end[5]>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputtaiousya value='".$cut_end[4]."'>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputtime value='".$cut_end[3]."'>\n";
						chomp($cut_end[6]);
						$output_html=$output_html."		  <font size=-1><br>\n";
						$output_html=$output_html."		  $cut_end[6]\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputnaiyou value='".$cut_end[6]."'\n";
						$output_html=$output_html."		  </font><br>\n";
						$output_html=$output_html."		  <div align=right><input type=submit value=' ����/�Խ������ '></div>\n";
						$output_html=$output_html."		  <input type=hidden name=callno value=$form{'callno'}>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputid value=$edit_id>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_inputkokyaku value=$kokyaku_syousai[2]>\n";
						$output_html=$output_html."		  <input type=hidden name=rireki_viewpage value=$form{'rireki_viewpage'}>\n";
						$output_html=$output_html."		  <input type=hidden name=html_sw value=10>\n";
						$output_html=$output_html.$addlink[1];
						$output_html=$output_html."		  </form>\n";
						$output_html=$output_html."		</td></tr>\n";
					}
					
					if($k==($form{'rireki_viewpage'}+1)*$view_rirekistart-1) {
						$j=0;
					} else {
						$k++;
					}
				}
			}
			$output_html=$output_html."		</table>\n";
			$output_html=$output_html."		<div align=right>";
			
			if($form{'rireki_viewpage'}>0) {
				local($k);			#���ڡ���ɽ����
				local($addlink_plus)="";#���󥫤ؤ��Ͱ��Ͻ񤭹��߳ƻ���2
				
				$k=$form{'rireki_viewpage'}-1;
				$addlink_plus=$addlink[0]."&rireki_viewpage=$k";
				$output_html=$output_html."<a href='$file_main?$addlink_plus'>&lt;&lt;���Υڡ�����</a> |";
			} else {
				$output_html=$output_html."<font color=#999999><s>&lt;&lt;���Υڡ�����</s></font> |";
			}
			if(($form{'rireki_viewpage'}+1)*$view_rirekistart<$rireki_viewall) {
				local($k);	#���ڡ���ɽ����
				local($addlink_plus)="";#���󥫤ؤ��Ͱ��Ͻ񤭹��߳ƻ���2
				
				$k=$form{'rireki_viewpage'}+1;
				$addlink_plus=$addlink[0]."&rireki_viewpage=$k";
				$output_html=$output_html." <a href='$file_main?$addlink_plus'>���Υڡ�����&gt;&gt;</a>";
			} else {
				$output_html=$output_html." <font color=#999999><s>���Υڡ�����&gt;&gt;</s></font>";
			}
			$output_html=$output_html."</div>\n";
		} else {
			$output_html=$output_html."		<br>\n";
			$output_html=$output_html."		<font color=red><b>���β�Ҥ˳��������б�����ϸ��Ĥ���ޤ���Ǥ�����</b></font><br>\n";
			$output_html=$output_html."		<br>\n";
		}
		$output_html=$output_html."	  </div></td>\n";
	}
	$output_html=$output_html."	</tr></table>\n";
}
1;
