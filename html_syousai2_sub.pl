#--------------------------------------
#�ڡ����ν��ϡ��б�������Խ�����
#&html_edit_taiou()
#	����:
#		@addlink				�ĥե�����γ��Ͱ�����
#									[0]�ĥ��󥫡��ˤ���Ͱ��Ϥ�
#									[1]�ĥե�����ˤ���Ͱ��Ϥ�
#									[2]�ĥե�����ˤ���Ͱ��Ϥ�(���Խ���)
#		$file_main				�ĥᥤ��롼����򼨤����ե�����̾
#		$kanrimode_password		�Ĵ�����:�������ƥ����ѥѥ���ɼ����Ϥ���
#		$search_houhou			�ĸ���:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$search_keyword			�ĸ���:�ºݤ˸������륭�����
#		�ե�����:	(���Ϥȥ��֤�ΤǾ�ά)
#	����:
#		$output_html	��HTML�ɲý�����
#		�ե�����:	callno					�ĸܵ�����:�ƤӽФ�ID
#		�ե�����:	html_sw					�ĸƤӽФ��줿(��)�Ƶ�ǽ
#		�ե�����:	kanrimode_check			�Ĵ����ԥ⡼��:�������ƥ����ѥѥ����
#		�ե�����:	rireki_callno			���б�����:�Խ�����Τ�����ID
#		�ե�����:	rireki_command
#						���б�����:�ܵҥǡ�����ɤ����뤫 0�Ŀ����ɲ� 1�ĺ�� 2�Ľ���
#		�ե�����:	rireki_inputid			���б�����:�ܵ�ID��Ͽ
#		�ե�����:	rireki_inputkokyaku		���б�����:�ܵ�̾��Ͽ
#		�ե�����:	rireki_inputnaiyou		���б�����:�б�������Ͽ
#		�ե�����:	rireki_inputsyubetsu	���б�����:�б�������Ͽ
#		�ե�����:	rireki_inputtaiousya	���б�����:�б�����Ͽ
#		�ե�����:	rireki_inputtime		���б�����:���Ϥ��줿����
#		�ե�����:	search_before_houhou
#						�ĸ��������󸡺�������ˡ 1�ĸܵҸ��� 2�����򸡺�
#		�ե�����:	search_before_word		�ĸ��������󸡺������������
sub html_edit_taiou {
	#�ե�����γ��Ͱ��Ϥ��ͽ���
	$addlink[1]=$addlink[1]."<input type=hidden name=callno value=$form{'callno'}>\n";
	$addlink[1]=$addlink[1]."<input type=hidden name=rireki_callno value=$form{'rireki_callno'}>\n";
	$addlink[1]=$addlink[1]."<input type=hidden name=rireki_inputid value=$form{'rireki_inputid'}>\n";
	
	#����ե�����
	$output_html=$output_html."	<div align=center><form action=$file_main method=post>\n";
	$output_html=$output_html."<input type=submit value=' ��������������� '>\n";
	$output_html=$output_html."<input type=hidden name=html_sw value=9>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."<input type=hidden name=rireki_command value=1>\n";
	$output_html=$output_html."	</form></div>\n";
	$output_html=$output_html."	<br>\n";
	
	#��Ͽ�ե�����
	$output_html=$output_html."	<form action=$file_main method=post>\n";
	$output_html=$output_html."	<table border>\n";
	$output_html=$output_html."	<tr><td bgcolor=#ff2222 align=center><b><font color=white>�ᡡ�б�������Խ�����</font></b></td></tr>\n";
	$output_html=$output_html."	<tr><td>\n";
	$output_html=$output_html."	  �� �б�����: \n";
	{
		local($k);	#�롼����
		local($option_selected);	#�б���������Ѥ�
		local(@option_message);		#��˥塼�γ�����
		local($option_message2);	#�ƤӽФ�$kokyaku_data_menu
		
		require'options_lib.pl';
			#�ե�����ǥ�˥塼�������ɽ������ʸ����
		
		&options(-1);
			#�ե�����ǥ�˥塼�������ɽ������ʸ���󷲸ƤӽФ�
		
		$output_html=$output_html."	  <select name=rireki_inputsyubetsu>\n";
		for($k=0,$option_selected=0;$k<=$#option_message;$k++){
			if(($form{'rireki_inputsyubetsu'} eq $option_message[$k]) || ($k==$#option_message && $option_selected==0)) {
				$output_html=$output_html."		<option value='$k' selected>$option_message[$k]</option>\n";
				$option_selected=1;
			} else {
				$output_html=$output_html."		<option value='$k'>$option_message[$k]</option>\n";
			}
		}
		$output_html=$output_html."	  </select>\n";
	}
	$output_html=$output_html."	  �� �б���:<input type=text name=rireki_inputtaiousya value=".$form{'rireki_inputtaiousya'}."><br>\n";
	$output_html=$output_html."	  �����������:<input type=text name=rireki_inputtime value='".$form{'rireki_inputtime'}."' size=23 maxlength=19><br>\n";
	$output_html=$output_html."	  �б�(�䤤��碌)����:<br>\n";
	$output_html=$output_html."	  <div align=center><textarea type=text name=rireki_inputnaiyou rows=5 cols=80 warp=soft>$form{'rireki_inputnaiyou'}</textarea></div>\n";
	$output_html=$output_html."	  <input type=hidden name=rireki_inputkokyaku value=$form{'rireki_inputkokyaku'}>\n";
	$output_html=$output_html."	  <input type=hidden name=html_sw value=9>\n";
	$output_html=$output_html."	  <input type=hidden name=rireki_command value=2>\n";
	$output_html=$output_html.$addlink[1];
	$output_html=$output_html."	</td></tr>\n";
	$output_html=$output_html."	</table>\n";
	
	$output_html=$output_html."	<br><br>\n";
	
	$output_html=$output_html."	<div align=center><input type=submit value=' �������������Ͽ���� '></div>\n";
	$output_html=$output_html."	</form>\n";
}
1;
