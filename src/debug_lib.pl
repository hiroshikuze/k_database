#-------------------------------------------------------------------------------
#debug�Ѳ����ϴ�Ϣ���֥롼���� ver 2002/03/08
#
#					Copyright	Hiroshi Kuze 2002.
#					Website		https://kuje.kousakusyo.info/tools/
#-------------------------------------------------------------------------------


#--------------------------------------
#debug�Ѳ����Ͻ����
#&debug_reset()
#	����:
#		�äˤʤ�
#	����:
#		�äˤʤ�
sub debug_reset {
	local($output_filename)="debug.txt";	#�ƥ��Ƚ����ѥե�����̾
	
	flock($output_filename,2);
	open(DATA,">$output_filename");
		print DATA "";
	close(DATA);
	flock($output_filename,8);
}

#--------------------------------------
#debug�Ѳ�������ʬ
#&debug_output($output_comment)
#	����:
#		$output_comment�Ŀ�������������ƥ�����
#	����:
#		�ѿ��Ȥ��Ƥ��äˤʤ�
sub debug_output {
	local($output_filename)="debug.txt";	#�ƥ��Ƚ����ѥե�����̾
	local($output_comment)=@_;				#��������������ƥ�����
	local(@output_text);					#�����ѥƥ�����
	local(@output_originaltext);			#�����Υƥ��Ƚ����ѥե���������
	local($i);								#�롼����
	
	$output_text[0]=$output_comment."\n\n";
	flock($output_filename,2);
	open(DATA,"<$output_filename");
		@output_originaltext=<DATA>;
	close(DATA);
		
		for($i=0;$i<=$#output_originaltext;$i++) {
			$output_text[$i+1]=$output_originaltext[$i];
		}
		
	open(DATA,">$output_filename");
		print DATA @output_text;
	close(DATA);
	flock($output_filename,8);
}
1;
