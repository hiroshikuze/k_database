#--------------------------------------
#�ե����फ��ξ����Ϣ������ %form �������
#&init_form(����������)
#	�����ѿ�:
#		@form_oktag	�ĥե�����ǡ������餽�Τޤ����Ѥ��륿���ˤĤ���
#		�ե����ෲ�ˤĤ��ƤϾ�ά
#	�����ѿ�:
#		$form{'�ե���������Ϥ���name'}	�ĥե����फ�����Ϥ��줿����
sub init_form {
	local($query, @assocarray, $assoc, $property, $value, $charcode, $method);
	$charcode = $_[0];
	$method = $ENV{'REQUEST_METHOD'};
	$method =~ tr/A-Z/a-z/;
	if ($method eq 'post') {
		read(STDIN, $query, $ENV{'CONTENT_LENGTH'});
	} else {
		$query = $ENV{'QUERY_STRING'};
	}
	@assocarray = split(/&/, $query);
	foreach $assoc (@assocarray) {
		local($i);	#�롼����
		
		($property, $value) = split(/=/, $assoc);
		$value =~ s/\+/ /g;
		$value =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
		&jcode'convert(*value, $charcode);
		
		#�����к�
		if(index($value,"<")>-1) {
				#�Ȥꤢ���������˲�
			$value =~ s/</&lt;/g;
			$value =~ s/>/&gt;/g;
			$value =~ s/'/\'/g;
				#@form_oktag �ǻ��ꤷ�������Τ�����
			for($i=0;$i<=$#form_oktag;$i++) {
				local($okikae0);		#�֤�����:�ִ��о�ʸ��
				local($okikae1);		#�֤�����:�ִ���λʸ��
				local($tag_start);		#����:���ϥ����ο�
				local($tag_end);		#����:��λ�����ο�
				
				if(index($value,$form_oktag[$i])>-1) {
					$value=$value." ";	#�����ο������Τ˿�����٤�1ʸ��­��
					
					#��λ����
					if(index($form_oktag[$i],"&gt;")==-1) {
						$okikae0="$form_oktag[$i]&gt;";
						$okikae1="$form_oktag[$i]>";
					} else {
						$okikae0=$form_oktag[$i];
						$okikae1=$form_oktag[$i];
					}
					$okikae0=~ s/&lt;/&lt;\//g;
					$okikae1=~ s/&lt;/<\//g;
					$tag_end=split(/$okikae0/,$value)-1;
					$value =~ s/$okikae0/$okikae1/ig;
					
					#���ϥ���
					$okikae0=$form_oktag[$i];
					$okikae1=$form_oktag[$i];
					$okikae1=~ s/&lt;/</g;
					$okikae1=~ s/&gt;/>/g;
					$tag_start=split(/$okikae0/,$value)-1;
					$value =~ s/$okikae0([^&]+)?(&gt;)?/$okikae1$1>/ig;
					
					$value=substr($value,0,length($value)-1);
										#�ǽ��­����1ʸ����ä�
					
					#��λ�����ο������ϥ����ο���꾯�ʤ�����դ�­��
					if($tag_start>$tag_end) {
						local($j);			#�롼����
						local($putwords);	#�դ�­��ʸ����
						
						$putwords="$form_oktag[$i]>";
						$putwords=~ s/&gt;//g;
						$putwords=~ s/&lt;/<\//g;
						for($j=0;$j<$tag_start-$tag_end;$j++) {
							$value=$value.$putwords;
						}
					}
				}
			}
		}
		
		
		$form{$property} = $value;
	}
}
1;
