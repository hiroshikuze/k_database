#--------------------------------------
#�ܺ�(���������ɲÎ����)����ɽ��
#&syousai()
#	����:
#		$edit_inputerror		���ɲäκݤǤΥȥ�֥�ǥ�������äƤ���Τ���
#		$file_kokyaku			�ĸܵҾ���ե�����̾
#		$file_taiou				���б�����ե�����̾
#		$form{'rireki_inputid'}	���б�����:�ܵ�ID��Ͽ
#		$form{'callno'}			�ĸܵ�����:�ƤӽФ�ID
#	����:
#		$edit_id			�ĸ���ID
#		@kokyaku_data		�ĸܵҥǡ���:��
#		@kokyaku_data_menu	�ĸܵҥǡ�����˥塼��ʬ�Ǥν��ɽ������
#		@kokyaku_syousai	�ĥե����������ϳƼ�ǡ���
#		@rireki_data		������ǡ���:��
#		$rireki_viewall=0	������ǡ���:���β��ID�ǳ���ɽ���������Ƥϲ��狼��
sub syousai {
	#HTML���Ͻ���
	if(index($edit_inputerror,"̤����")>0) {
		#�¤ϥե��������ϥ��顼�Ǥ�������äƤ��Ƥ���ʤ�
		
		require 'seiri_formdata_lib.pl';	#�ե�����Υǡ���������������
		&seiri_formdata();	#�ե�����Υǡ���������������
	} else {
		#���̤˥�������Ƥ���ʤ�
		#ɬ�ץǡ�����ե�������������
		
		#���֥롼�����ɲ��ɤ߹���
		require 'tab_cut_lib.pl';	#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ���
		
		#�ܵҥǡ����ɤ߼��
		local($i);	#�롼����
		
		@kokyaku_data=&file_access("<$file_kokyaku",3);
		
		if($form{'rireki_inputid'}>0) {
			$form{'rireki_inputid'}--;
			for($i=0;$i<=$#kokyaku_data;$i++) {
				&tab_cut($kokyaku_data[$i+1]);
				if($form{'rireki_inputid'}==$cut_end[0]) {
					$form{'callno'}=$i;
					$i=$#kokyaku_data;
				}
			}
		}
		
		#�ƽФ��ֹ����
		if($form{'callno'}==-1) {
			#���������ξ��
			
			$kokyaku_syousai[31]="�äˤʤ�������";
			$kokyaku_syousai[32]="�äˤʤ�������";
		} else {
			#�����ξ��
			
			local($i);	#�롼����
			local(@menu_settei);	#��˥塼�ǡ����������
			local(@option_message);		#��˥塼�γ�����
			local($option_message2);
				#$kokyaku_data_menu���ͤ��б�����ƤӽФ���˥塼��
			
			$menu_settei[0]=20;
			$menu_settei[1]=21;
			$menu_settei[2]=22;
			$menu_settei[3]=27;
			$menu_settei[4]=29;
			
			require 'options_lib.pl';
				#�ե�����ǥ�˥塼�������ɽ������ʸ����
			
			$edit_id=$form{'callno'};
			
			#���ȥǡ�������
			for($i=1;$edit_id!=$cut_end[0];$i++) {
				&tab_cut($kokyaku_data[$i]);
			}
			
				#�ե�����ǡ�������
			for($i=0;$i<=$#kokyaku_koumokuname;$i++) {
				$kokyaku_syousai[$i]=$cut_end[$i];
			}
			
			$edit_id=$kokyaku_syousai[0];
			
				#����ʸ���������ؤ���
			chomp($kokyaku_syousai[31]);
			$kokyaku_syousai[31]=~ s/<br>/\n/g;
			$kokyaku_syousai[31]=~ s/\"/"/g;
			chomp($kokyaku_syousai[32]);
			$kokyaku_syousai[32]=~ s/<br>/\n/g;
			$kokyaku_syousai[32]=~ s/\"/"/g;
			for($i=0;$i<=$#menu_settei;$i++) {
				local($j);
				
				&options($menu_settei[$i]);
				$kokyaku_data_menu[$i]=0;
				for($j=0;$j<=$#option_message;$j++) {
					if (index($cut_end[$menu_settei[$i]],$option_message[$j])>-1) {
						$kokyaku_data_menu[$i]=$j;
						$j=$#option_message;
					}
				}
			}
			
			#�б�����ɽ������
				#����ǡ����ɤ߼��
			@rireki_data=&file_access("<$file_taiou",9);
			
				#ɽ���Ľ�
			for($i=1,$rireki_viewall=0;$i<=$#rireki_data;$i++) {
				&tab_cut($rireki_data[$i]);
				if($edit_id==$cut_end[1]) {
					$view_rireki[$i]=1;
					$rireki_viewall++;
				} else {
					$view_rireki[$i]=0;
				}
			}
		}
	}
}
1;
