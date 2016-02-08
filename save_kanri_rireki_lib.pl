#--------------------------------------
#��������������¸
#&save_kanri_rireki($record_koumoku,$record_comment)
#	�����ѿ�:
#		@config������ǡ�����
#		$file_sousa_rireki�İ����������ե�����̾ 
#		$record_koumoku��(�ؿ�������)��Ͽ�������
#		$record_comment��(�ؿ�������)��Ͽ����
#		$version�ĥ����ƥ�С���������
#	�����ѿ�:
#		$error_code�ĥ��顼ȯ����������������
#		$error_file�ĥ��顼��������������ե�����̾
#		@kanrimode_rireki�Ĵ�����:��������������ǡ���
sub save_kanri_rireki {
	local($output_errorcode)=15;	#�ե����륨�顼��ȯ�������֤����顼������
	local($record_koumoku,$record_comment)=@_;	#���ɤ���������
	
		#����μ�Ǽ��
	local($year);
	local($mon);
	local($day);
	local($hour);
	local($min);
	local($sec);	#���߻���
	local($null);	#���Ѥ��ʤ�
	
	local($set);	#�񤭹��߰���������
	
	#�������������ɤ߼��
	@kanrimode_rireki=&file_access("<$file_sousa_rireki",15);
	if($error_code==0) {
		#�񤭹��߹԰����ɤ߹���
		$set=$#kanrimode_rireki;
		
		#���ߤλ���ǡ�����Ͽ
		($sec,$min,$hour,$day,$mon,$year,$null) = localtime;
		$mon=$mon+1;
		$year=$year+1900;
		
		#�ե����뤬���ʤ饳����ʸ��Ĥ���
		if($set<0) {
			$kanrimode_rireki[0]=$version." - �����������\n";
			$set++;
		}
		
		#����������ɲ�
		$set++;
		$kanrimode_rireki[$set]=sprintf("%d/%02d/%02d %02d:%02d:%02d	$record_koumoku	$record_comment\n",$year,$mon,$day,$hour,$min,$sec);
		
		#��������᤮������
		$set++;
		if($set-2>$config[5]) {
			local(@temp_kanrimode_rireki);	#��������������ǡ���
			local($i);	#�롼����
			local($j);	#�롼����
			
			$temp_kanrimode_rireki[0]=$kanrimode_rireki[0];
			for($i=$set-$config[5],$j=2;$i-2<$#kanrimode_rireki;$i++,$j++) {
				$temp_kanrimode_rireki[$j]=$kanrimode_rireki[$i];
			}
			@kanrimode_rireki=@temp_kanrimode_rireki;
		}
		
		#�ե�����ؤ���¸
		&file_access(">$file_sousa_rireki",$output_errorcode,$config[5],@kanrimode_rireki);
	}
}
1;
