#!/usr/bin/perl

#-------------------------------------------------------------------------------
#�ܵҴ���DataBase��Excel�ǡ����Ѵ� version 1.000
#	Copyright Hiroshi Kuze 2003.
#
#	Excel2000�ǡ����ֶ��ڤ��CSV�ǡ�������ɤ��褦�Ȥ����
#	ư�����������ʤ�褦�ʤΤǡ�����޶��ڤ���Ѵ����ƽ��Ϥ��ޤ���
#	ExcelXP�����Τ��
#

#
# �С���������
local($version) = "�ܵҴ���DataBase��Excel�ѥǡ����Ѵ�version1.000";
	#�С��������Ѥ����Ȥ����ѹ����Ƥ�������

	#��������
	#	ver 1.000
	#		�ܵҴ���DataBase ver 0.901A �˻Ϥ����°


#
# �ѿ�����������1 �� �������
local($comma) = '.';	#����Υǡ����ˤ��ä�����ޤ��֤�������ʸ��

#
# �ѿ�����������2
	#�������ѹ����ʤ��ǲ����� --
local($i);					#for��
local($url_ori) = 'http://kuze.tsukaeru.jp/tools/k_database/index.shtml';
		#�ܵҴ���DataBase��ȯ���ڡ���
local(@data);				#���ɤ����ե�����ǡ���
local($file_error);			#�ե�������ɻ��Υ��顼
local($error_message_name);	#���顼����ɽ������륨�顼��ͳ
	#�����ޤ� ------------------

#
# �Ƽ�ǡ����ɤ߹���
require 'form_lib.pl';			#�ե����फ��ξ����Ϣ������ %form �������

#
#�ե����फ�����ǡ�����ʬ��
require 'jcode.pl';
&init_form('euc');
		#�ե����फ�����ǡ����ˤĤ���
		#loadfile �� �ɤΥե�������Ѵ�����Τ�

#
# ¾�����Ȥؤΰ�ư�򤳤��ǻ���
if(length($form{'loadfile'})>0) {
	require 'file_access_lib.pl';
	
	chomp($form{'loadfile'});
	@data=&file_access("<$form{'loadfile'}",1);
	
	if($error_code==0) {
		#�ǡ����Ѵ�
		for($i=0;$i<=$#data;$i++) {
			&jcode::convert(\$data[$i], "sjis", "euc"); 
			$data[$i]=~ s/,/$comma/g;
			$data[$i]=~ s/\t/,/g;
		}
		$data[0]="";
		
		#�ǡ��ǡ����򥵡��С�����PC���Ϥ�
		print "Content-type: application/octet-stream; name=".$form{'loadfile'}."\n\n";
		print "@data";
	} else {
		#�ե����뤬���ɤǤ��ʤ�
		$error_message_name="�ե�����'".$form{'loadfile'}."'�����ɤǤ��ޤ���";
	}
} else {
	#index.cgi�����褿���� html �ǰ�ư��ǧ
	$error_message_name="�ե����뤬���ꤵ�줺�˸ƤӽФ���ޤ�����";
}

#
#�ե����륨�顼������ʤ��å�����ɽ��
if(length($error_message_name)>0) {
print<<"OUTPUT_HTML";
Content-type: text/html

<html>
<head>
	<title>$version</title>
</head>
<body>
	<h1>$version</h1>
	<br>
	<font color=red>$error_message_name</font><br>
	<br>
	<br>
	�ɤ����Ƥ⤳�Υ��顼�����ʤ��Ȥ��ϡ�������Ǥ���<br>
	<br>
	<a href=$url_ori>$url_ori</a><br>
	<br>
	�����������ɤ�ľ���ƺƥ��󥹥ȡ���򤪻����������<br>
</body>
</html>
OUTPUT_HTML
}

	#��λ
exit(0);
