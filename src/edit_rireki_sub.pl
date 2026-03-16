#--------------------------------------
#対応履歴の編集画面
#&edit_rireki()
#	入力:
#		$form{'rireki_inputnaiyou'}		…対応履歴:対応内容登録
#	出力:
#		$form{'rireki_inputnaiyou'}		…対応履歴:対応内容登録
sub edit_rireki {
	chomp($form{'rireki_inputnaiyou'});
	$form{'rireki_inputnaiyou'}=~ s/&lt;br&gt;/\n/g;
	$form{'rireki_inputnaiyou'}=~ s/\n/\n| /g;
	$form{'rireki_inputnaiyou'}=~ s/"/\"/g;
	$form{'rireki_inputnaiyou'}="以下、 $form{'rireki_inputtime'} に投稿された時の文章です。\n\n| ".$form{'rireki_inputnaiyou'};
}
1;
