#--------------------------------------
#�б�������Խ�����
#&edit_rireki()
#	����:
#		$form{'rireki_inputnaiyou'}		���б�����:�б�������Ͽ
#	����:
#		$form{'rireki_inputnaiyou'}		���б�����:�б�������Ͽ
sub edit_rireki {
	chomp($form{'rireki_inputnaiyou'});
	$form{'rireki_inputnaiyou'}=~ s/&lt;br&gt;/\n/g;
	$form{'rireki_inputnaiyou'}=~ s/\n/\n| /g;
	$form{'rireki_inputnaiyou'}=~ s/"/\"/g;
	$form{'rireki_inputnaiyou'}="�ʲ��� $form{'rireki_inputtime'} ����Ƥ��줿����ʸ�ϤǤ���\n\n| ".$form{'rireki_inputnaiyou'};
}
1;
