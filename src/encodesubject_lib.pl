#--------------------------------------
#メールの日本語サブジェクトをエンコードする。
#　※futomi's CGI Cafe ( http://www.futomi.com/subroutine/encodesubject.html )様
#　　から、そのまま拝借させていただいています。
#&EncodeSubject($サブジェクト文字列)
#	出力:
#		返り値…RFC2047に従いBASE64 Bエンコードされたサブジェクト。
sub EncodeSubject {
	my($String) = @_;
	&jcode::convert(\$String, "euc");
	my($Base64Table) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	                      'abcdefghijklmnopqrstuvwxyz'.
	                      '0123456789+/';
	my($chunk, $ByteChunk, $PackedByteChunk, $DecimalNum, $EncodedString);
	my($SplitedWord, @SplitedWordList, $i, $Byte, $Buff);
	my($KI) = 0;
	my($KO) = 0;
	my($CharNum) = 0;
	my($CharType) = 0;
	my($LineLength) = 0;
	my($CharEndFlag) = 1;
	if($String =~ /[^a-zA-Z0-9\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\/\^\_\~ ]/) {
		$i = 0;
		@SplitedWordList = ();
		while($i < length($String)) {
			$Byte = substr($String, $i, 1);
			if($Byte =~ /[\x8E\xA1-\xFE]/) {
				unless($CharType eq 'K') {$KI ++;}
				$CharType = 'K';
				if($CharEndFlag) {
					$CharEndFlag = 0;
				} else {
					$CharEndFlag = 1;
				}
			} else {
				if($CharType eq 'K') {$KO ++;}
				$CharType = 'A';
				$CharEndFlag = 1;
			}
			$Buff .= $Byte;
			$CharNum += 1;
			$LineLength = 27 + ($CharNum*4/3) + (($KI+$KO)*4) + 2;
			if($CharType eq 'K') {$LineLength += 4;}
			if($CharEndFlag && $LineLength>=70) {
				&jcode::convert(\$Buff, "jis");
				push(@SplitedWordList, $Buff);
				$Buff = '';
				$CharNum = 0;
				$CharType = 0;
				$KI = 0;
				$KO = 0;
			}
			$i ++;
		}
		&jcode::convert(\$Buff, "jis");
		push(@SplitedWordList, $Buff);

		for $SplitedWord (@SplitedWordList) {
			$EncodedString .= '=?ISO-2022-JP?B?';
			$BitStream = unpack("B*", $SplitedWord);
			$i = 0;
			while($chunk = substr($BitStream, $i*6, 6)) {
				unless(length($chunk) == 6) {
					$chunk = pack("B6", $chunk);
					$chunk = unpack("B6", $chunk);
				}
				$ByteChunk = sprintf("%08d", $chunk);
				$PackedByteChunk = pack("B8", $ByteChunk);
				$DecimalNum = unpack("C", $PackedByteChunk);
				$EncodedString .= substr($Base64Table, $DecimalNum, 1);
				$i++;
			}
			if(length($SplitedWord) % 3 == 1) {
				$EncodedString .= '==';
			} elsif(length($SplitedWord) % 3 == 2) {
				$EncodedString .= '=';
			}
			$EncodedString .= '?='."\n ";
		}
		$EncodedString =~ s/\n $//;
	} else {
		$EncodedString = $String;
	}
	return $EncodedString;
}
1;
