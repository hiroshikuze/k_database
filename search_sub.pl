#--------------------------------------
#�������
#&search()
#	����:
#		$file_kokyaku			�ĸܵҾ���ե�����̾
#		$file_taiou				���б�����ե�����̾
#		@kokyaku_data			�ĸܵҥǡ���
#		$search_houhou			�ĸ�����ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		$form{'keyword_kokyaku'}�ĸܵҥǡ��������������
#		$form{'keyword_rireki'}	������ǡ��������������
#	����:
#		$error_search			�ĥ��顼:�������ԤˤĤ���
#									0������ 1�ĥ������̤���� 2�ĥ������ȯ���Ǥ���
#		@kokyaku_data			�ĸܵҥǡ���:��
#		@rireki_data			������ǡ���:��
#		$search_houhou			�ĸ�����ˡ(1�ĸܵҸ��� 2�����򸡺�)
#		@view_kokyaku	�ĳ���ɽ������ܵҥǡ�����?(0��No 1��Yes)
#		@view_rireki	�ĳ���ɽ����������ǡ�����?(0��No 1��Yes)
sub search {
	#���֥롼���󷲥���
	require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
	
	local($i);				#�롼����
	local(@search_data);	#�����ͥ��ǡ�����Ǽ��
	
	#�ܵҥǡ������ɤ߼��
	@kokyaku_data=&file_access("<$file_kokyaku",8);
	
	if(length($form{'keyword_kokyaku'})>0||$search_houhou==1) {
		#�ܵҥǡ�����������
		@search_data=@kokyaku_data;
		
		#������ɤ�����
		if($search_houhou==0) {
			$search_keyword=$form{'keyword_kokyaku'};
		}
		$search_houhou=1;
	} elsif(length($form{'keyword_rireki'})>0||$search_houhou==2) {
		#����ǡ�����������
			#����ǡ������ɤ߼��
		
		@rireki_data=&file_access("<$file_taiou",12);
		@search_data=@rireki_data;
		
			#������ɤ�����
		if($search_houhou==0) {
			$search_keyword=$form{'keyword_rireki'};
		}
		$search_houhou=2;
	} else {
		#�������̤����
		
		$search_houhou=0;
		$error_search=1;
	}
	
	if($error_code==0&&$error_search==0) {
		$error_search=2;
		
			#�ο��θ������󥸥�
		for($i=1;$i<=$#search_data;$i++) {
			if(index($search_data[$i],$search_keyword)>-1) {
				if($search_houhou==1) {
					#�ܵҸ����ξ��
					$view_kokyaku[$i-1]=1;
				} else {
					#���򸡺��ξ��
					$view_rireki[$i-1]=1;
				}
				$error_search=0;
			} else {
				if($view_kokyaku[$i]!=1) {
					$view_kokyaku[$i]=0;
				}
			}
		}
	}
}
1;
