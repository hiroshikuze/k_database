#--------------------------------------
#ʸ����򥿥�ñ�̤ǥХ�Х�ˤ��롣
#&tab_cut($�оݤ�ʸ����)
#	����:
#		$cut_end[]�Ĥ����˥Х�Х�ˤʤä�ʸ�������äƤ��ޤ���
#		$cut_end[]="end"�Ĥ�������ʸ���󤬺Ǹ�Τ�ΤǤ�����
#		$tab�������оݤ�ʸ����˴ޤޤ�륿�֤ο�
sub tab_cut {
	local($cut_moji) = @_;	#����ʸ����
	local($i);				#�롼����
	
	undef $cut_end[0];
	for($i=0,$tab=0;$i<length($cut_moji);$i++)	{
		local($k);	#ʸ��Ƚ����
		
		$k=substr($cut_moji,$i,1);
		if($k eq '	')	{
			$tab=$tab+1;
			undef $cut_end[$tab];
		} else {
			$cut_end[$tab]=$cut_end[$tab].$k;
		}
	}
	
	if(substr($cut_end[$tab],length($cut_end[$tab]),1)=="\n")	{
		$tab++;
	}
	$cut_end[$tab]="end";
}
1;
