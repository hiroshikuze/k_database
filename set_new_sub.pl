#--------------------------------------
#�ǿ��� ?�� �ˤĤ���(�������)
#&set_new()
#	����:
#		$file_kokyaku			�ĸܵҾ���ե�����̾
#		@kokyaku_data			�ĸܵҥǡ���
#		$view_start				�ĺǿ���:��ư���˵�Ͽ�ξ夫��ɽ��������̵�����
#		$form{'firstview_page'}	�ĺǿ���:���ڡ����ܤ򸫤Ƥ��뤫
#	����:
#		@view_kokyaku			�ĺǿ���&�������:����ɽ������ܵҥǡ�����?(0��No 1��Yes)
sub set_new {
	local($i);	#�롼����
	local($j);	#ɽ����������
	
	#ɬ�ץǡ�����ե�������������
		#�ܵҥǡ������ɤ߼��
	if($#kokyaku_data==-1) {
		@kokyaku_data=&file_access("<$file_kokyaku",7);
	}
	
		#�ǿ����ȴ���Ф��褦�ˤ���
	for($i=0;$i<$#kokyaku_data;$i++) {
		$view_kokyaku[$i]=1;
	}
}
1;
