#--------------------------------------
#�ե�������ɤ߽���ʬ
#&file_access($filename,$output_errorcode,$lines,@savedata)
#	����:
#		$error_code�ĥ��顼ȯ����������������
#		$fileaccess�ĸƤӽФ����ȥե�����̾��
#		$lines�ĥ����ֻ��˻Ĥ���
#			0,1������ 2�ʾ��1���ܤ�����ƺǽ��Ԥ��鲼x�ԻĤ�
#		@savedata�ĥ����֤�����
#	����:
#		�����͡ĥǡ������ɻ����ɤ߹������
#		$error_code�ĥ��顼ȯ����������������
#		$error_file�ĸƤӽФ����ȥե�����̾��
sub file_access {
	local($fileaccess,$error_code,$lines,@savedata)=@_;
							#���ɤ���������
	local(@output);			#�ǡ������ɻ����ɤ߹������
	local($filename);		#�ե�����̾
	
	$filename=substr($fileaccess,1,length($fileaccess)-1);
	flock($filename,2);
	if(open(DATA,"$fileaccess")==1)	{
		if(substr($fileaccess,0,1) eq '<') {
			#���ɻ��ʤ�
			@output=<DATA>;
		} else {
			#�����ֻ��ʤ�
			if($lines>1&&$#savedata>1) {
				local(@sub_savedata);
				local($i);
				local($j);
				
				$sub_savedata[0]=$savedata[0];
				$j=$#savedata-$lines;
				if($j<1) {$j=1;}
				for($i=1;$i<=$#savedata;$i++,$j++) {
					$sub_savedata[$i]=$savedata[$j];
				}
				undef @savedata;
				@savedata=@sub_savedata;
			}
			
			print DATA @savedata;
		}
		close(DATA);
	} else {
		$error_code=$output_errorcode;
		$error_file=$filename;
	}
	flock($filename,8);
	
	return(@output);
}
1;
