#!/usr/bin/perl

#-------------------------------------------------------------------------------
#�ܵҴ���DataBase��DummyFile version 1.000
#	Copyright Hiroshi Kuze 2002-2003.
#	�����Υץ�����फ�鳰���ذ�ư���뤳�Ȥˤ�äƸܵҴ����ǡ����١���
#	����ɤ����Ƥ�ή�Ф��롢�ɤΥ����Ȥ����ư�����Τ��򼨤��Ķ��ѿ�
#	HTTP_REFERER���ͤ����ޤ���
#

#
# �С���������
local($version) = "�ܵҴ���DataBase��DummyFile_version1.000";
	#�С��������Ѥ����Ȥ����ѹ����Ƥ�������

	#��������
	#	ver 1.000
	#		�ܵҴ���DataBase ver 0.900F �˻Ϥ����°


#
# �ѿ��ν������
$gokurou_url='https://kuje.kousakusyo.info/tools/k_database/';
	#HTTP_REFERER�򻲹ͤ�ľ�����줿����ͶƳ����URL

#
# �Ƽ�ǡ����ɤ߹���
require 'form_lib.pl';			#�ե����फ��ξ����Ϣ������ %form �������

	#�ե����फ�����ǡ�����ʬ��
require 'jcode.pl';
&init_form('euc');
		#�ե����फ�����ǡ����ˤĤ���
		#move_url �� �ɤ�URL�����Ф��Τ�

#
# ¾�����Ȥؤΰ�ư�򤳤��ǻ���
if(length($form{'move_url'})>0) {
	#�ܵҴ���DataBase�������줿�ʤ�
	local($i);			#�롼����
	local($moved);		#��ư��
	local($key);		#�ե�����ϥå��������
	local($value);
	local($linked);		#��ư���󥯤��ɲä������
	
		#��󥯾������
	$moved=$form{'move_url'};
	delete $form{'move_url'};
	$linked=$moved;
	$i=0;
	while(($key,$value)=each %form) {
		#URL���󥳡���
		$value =~ s/(\W)/'%'.unpack("H2", $1)/ego;
		$value =~ tr/ /+/;
		
		#���󥫡������Υե�������ʬ����
		if($i==0) {
			$linked=$linked."?".$key."=".$value;
		} else {
			$linked=$linked."&".$key."=".$value;
		}
		$i++;
	}
	
		#��ư��ǧ
	print "Content-type: text/html\n\n";
print <<"end";
<html>
<head>
	<title>$moved �ذ�ư���ޤ�����</title>
</head>
<body>
	<a href=$linked>$moved</a> �ذ�ư���ޤ�����<br>
	<br>
	<hr>
	<br>
	<a href=$linked>$linked</a><br>
	�ذ�ư���褦�Ȥ��Ƥ��ޤ���<br>
	<br>
	���������� <a href=$linked>������򥯥�å�</a> ����<br>
	<br>
	�������Ǥʤ���Х֥饦���Ρ����Ϥ򥯥�å����ꤤ���ޤ���<br>
</body>
</html>
end
} else {
	#HTTP_REFERER����é���Ƥ�����綯����ư
	print "Location: $gokurou_url\n\n";
}


	#��λ
exit(0);
