#--------------------------------------
#�ܵҴ���DataBase�� �ե�����Υǡ���������������
#&seiri_formdata()
#	���ϡ�
#		@form�ĥե����फ���褿�ǡ����򤽤줾��ʬ�򤷤����
#	����:
#		@kokyaku_syousai	�ĸܵҥǡ���:�ܺ١Ļ��Υե����������ϳƼ�ǡ���
#		@kokyaku_data_menu	�ĸܵҥǡ���:�ܵҥǡ�����˥塼��ʬ�Ǥν��ɽ������
sub seiri_formdata {
	local($i);	#�롼����
	local(@kokyaku_data_menu_fromform);
		#kokyaku_data_menu�إե�����ǡ���������ɤ߹��߽�����
	local($fromform);	#�ե�����ǡ�������ƤӽФ��Ѥ�ʸ����
	
	$kokyaku_data_menu_fromform[0]=20;
	$kokyaku_data_menu_fromform[1]=21;
	$kokyaku_data_menu_fromform[2]=27;
	$kokyaku_data_menu_fromform[3]=29;
	
	for($i=0;$i<=$#kokyaku_koumokuname;$i++){
		$fromform="input_kokyakudata".$i;
		$kokyaku_syousai[$i]=$form{$fromform};
	}
	for($i=0;$i<=$#kokyaku_data_menu_fromform;$i++) {
		$fromform="input_kokyakudata".$kokyaku_data_menu_fromform[$i];
		$kokyaku_data_menu[$i]=$form{$fromform};
	}
}
1;
