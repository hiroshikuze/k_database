#!/usr/bin/perl

#-------------------------------------------------------------------------------
#�ܵҴ���DataBase version 0.902D
#	(C)Copyright Hiroshi Kuze 2002-2005.
#

#
#�С���������
local($version) = "�ܵҴ����ǡ����١���_version0.902DbyHiroshiKuze.";
	#�С��������Ѥ����Ȥ����ѹ����Ƥ�������

#
# �Ƽ亮���ƥ�����

local($file_main)="index.cgi";			#���Υᥤ�󥷥��ƥ�ե�����̾

local($file_config)="config.dat";		#������������ե�����̾

local($file_kokyaku)="kokyaku.csv";		#�ܵҾ���ե�����̾
local($file_taiou)="taiou.csv";			#�б�����ե�����̾
local($file_kokyaku_bak)="kokyaku.bak";	#��1����Хå����å׸ܵҾ���ե�����̾
local($file_taiou_bak)="taiou.bak";		#��1����Хå����å��б�����ե�����̾
local($file_sousa_rireki)="sousa_rireki.csv";
										#�����������ե�����

local($kanji_code)="euc";		#���Ѥ�����������ɤˤĤ���

local($kanrimode_crypt)="cr";		#������:�������ƥ����ѥѥ���ɰŹ������
local($kanrimode_name)="������";	#������:�᡼���������������Ͽ�����б�(���)��
local($kanrimode_send)="��������";	#������:�᡼���������������Ͽ�����б�����
local($view_start)=5;			#�ǿ���:��ư���˵�Ͽ�ξ夫��ɽ��������̵�����
local($view_rirekistart)=5;	#�б�����:���٤�ɽ��������

local($mailer_demolock)=1;	#�᡼��:�����ܥ���򲡤�������������������Ρ�
								#0��Yes 1��No
local($mailer_pass)="sendmane.exe";		#�᡼��:semdmail�⤷���ϡ����θߴ��ޤǤΥѥ�
local($mailer_ownaddress)="kuze_work3\@hotmail.com";
							#�᡼��:�����ԤΥ��ɥ쥹(������ɬ���ѹ����Ƥ���������)

#
# �����ѿ�����
local(@config);				#����ǡ�����(Ĺ���ΤǾ�ά)
local($edit_id)=0;			#�َܺ��������ɲÎ����:����ID
local($edit_inputerror)="";	#�َܺ��������ɲÎ����:�ɲäκݤǤΥȥ�֥����äƤ���Τ���
local($error_code)=0;		#���顼:���顼������
local($error_file);			#���顼:���顼��������������ե�����̾
local($error_htmlplus)="";	#���顼:HTML���ϻ����ɲå�å�����
local($error_search)=0;		#���顼:�������ԤˤĤ���
								#0������ 1�ĥ������̤���� 2�ĥ������ȯ���Ǥ���
local(@form_oktag)=0;		#�ե�����ǡ������餽�Τޤ����Ѥ��륿���ˤĤ���
	#���ʸ����³���ʤ�����&gt;�ǲä����Ĥ��Ƥ��äƤ�������
	$form_oktag[ 0]="&lt;font";			#�ե���Ȼ���
	$form_oktag[ 1]="&lt;strong&gt;";	#����
	$form_oktag[ 2]="&lt;b&gt;";		#����
	$form_oktag[ 3]="&lt;em&gt;";		#����
	$form_oktag[ 4]="&lt;i&gt;";		#����
	$form_oktag[ 5]="&lt;u&gt;";		#��������饤��
	$form_oktag[ 6]="&lt;del&gt;";		#���ä��ܦ�
	$form_oktag[ 7]="&lt;s&gt;";		#���ä�
	$form_oktag[ 8]="&lt;strike&gt;";	#���ä�
	$form_oktag[ 9]="&lt;ruby&gt;";		#��Ӵ�Ϣ
	$form_oktag[10]="&lt;rt&gt;";		#��Ӵ�Ϣ
	$form_oktag[11]="&lt;rp&gt;";		#��Ӵ�Ϣ
	$form_oktag[12]="&lt;div";			#���ֻ���
	$form_oktag[13]="&lt;center&gt;";	#���ֻ���
	$form_oktag[14]="&lt;a";			#����
local($kanrimode_password);	#������:�������ƥ����ѥѥ���ɼ����Ϥ���
local($kanrimode_passwordkari);
							#������:�������ƥ����ѥѥ���ɼ����Ϥ��Ѳ�
local(@kanrimode_rireki);	#������:��������������ǡ���
local($kanrimode_sw)=0;		#������:�⡼�ɤ�OFF/ON
								#0=OFF 1=ON 2=OFF(Password error) 3=OFF(������������)
local($reload_url);			#�ܵҴ����ǡ����١������ɤ�ľ��
local($search_keyword);		#����:�ºݤ˸������륭�����
local($search_houhou);		#����:������ˡ(1�ĸܵҸ��� 2�����򸡺�)
local($system_loop)=0;		#��ǽ�¹�:������λ�厥¾������¹Ԥ���Τ���
local($system_back)=0;		#��ǽ�¹�:������λ�厥�������ֹ�
local($sw)=0;				#�ե�����ǡ�������ε�ǽ�ڤ��ؤ�
local(@view_kokyaku);		#�ǿ���&�������:����ɽ������ܵҥǡ�����?(0��No 1��Yes)
local(@view_rireki);		#�б�����:����ɽ����������ǡ�����?(0��No 1��Yes)

local(@rireki_data);			#����ǡ���:��
local(@rireki_koumokuname);		#����ǡ���:�ƹ���̾
	$rireki_koumokuname[0]="����ID";
	$rireki_koumokuname[1]="�ܵ�ID";
	$rireki_koumokuname[2]="�ܵ�̾";	#ɽ����
	$rireki_koumokuname[3]="�������";
	$rireki_koumokuname[4]="�б�(���)��";
	$rireki_koumokuname[5]="�б�����";
	$rireki_koumokuname[6]="�������";
local($rireki_viewall)=0;		#����ǡ���:���β��ID�ǳ���ɽ���������Ƥϲ��狼��
local(@kokyaku_data);			#�ܵҥǡ���:��
local(@kokyaku_data_menu);		#�ܵҥǡ���:�ܵҥǡ�����˥塼��ʬ�Ǥν��ɽ������
local(@kokyaku_inputcyuui);	#�ܵҥǡ���:���ϻ�����ե�����
	$kokyaku_inputcyuui[ 0]="";
	$kokyaku_inputcyuui[ 1]="";
	$kokyaku_inputcyuui[ 2]="";
	$kokyaku_inputcyuui[ 3]="";
	$kokyaku_inputcyuui[ 4]="";
	$kokyaku_inputcyuui[ 5]="";
	$kokyaku_inputcyuui[ 6]="";
	$kokyaku_inputcyuui[ 7]="";
	$kokyaku_inputcyuui[ 8]="";
	$kokyaku_inputcyuui[ 9]="";
	$kokyaku_inputcyuui[10]="<br>(Ⱦ�ѿ�����'-'�ʥϥ��ե�)��) <a href='http://search.post.yusei.go.jp/7zip/'>͹���ֹ渡��</a>";
	$kokyaku_inputcyuui[11]="";
	$kokyaku_inputcyuui[12]="<br>(Ⱦ�ѿ�����'-'�ʥϥ��ե�)��) <a href='http://search.post.yusei.go.jp/7zip/'>͹���ֹ渡��</a>";
	$kokyaku_inputcyuui[13]="";
	$kokyaku_inputcyuui[14]="<br>(Ⱦ�ѿ�����'-'�ʥϥ��ե�)��)";
	$kokyaku_inputcyuui[15]="<br>(Ⱦ�ѿ�����'-'�ʥϥ��ե�)��)";
	$kokyaku_inputcyuui[16]="<br>(Ⱦ�ѱѿ�����'\@'(���åȥޡ���)��)";
	$kokyaku_inputcyuui[17]="";
	$kokyaku_inputcyuui[18]="<br>(Ⱦ�ѿ�����'/'(����å���)��)";
	$kokyaku_inputcyuui[19]="<br>��Ⱦ�ѿ����Τߤ�ñ�̤�����";
	$kokyaku_inputcyuui[20]="";
	$kokyaku_inputcyuui[21]="";
	$kokyaku_inputcyuui[22]="";
	$kokyaku_inputcyuui[23]="";
	$kokyaku_inputcyuui[24]="";
	$kokyaku_inputcyuui[25]="";
	$kokyaku_inputcyuui[26]="";
	$kokyaku_inputcyuui[27]="";
	$kokyaku_inputcyuui[28]="<br>��Ⱦ�ѿ����Τߡ�";
	$kokyaku_inputcyuui[29]="";
	$kokyaku_inputcyuui[30]="";
	$kokyaku_inputcyuui[31]="";
	$kokyaku_inputcyuui[32]="";
local(@kokyaku_koumokuname);	#�ܵҥǡ���:�ƹ���̾
	$kokyaku_koumokuname[ 0]="ID";
	$kokyaku_koumokuname[ 1]="����";
	$kokyaku_koumokuname[ 2]="���̾";
	$kokyaku_koumokuname[ 3]="���̾�դ꤬��";
	$kokyaku_koumokuname[ 4]="\��\ɽ\��";
	$kokyaku_koumokuname[ 5]="\��\ɽ\�Ԥդ꤬��";
	$kokyaku_koumokuname[ 6]="��";
	$kokyaku_koumokuname[ 7]="ô����";
	$kokyaku_koumokuname[ 8]="ô���Ԥդ꤬��";
	$kokyaku_koumokuname[ 9]="ô������";
	$kokyaku_koumokuname[10]="����-͹���ֹ�";
	$kokyaku_koumokuname[11]="����-̾��";
	$kokyaku_koumokuname[12]="����ʤ�������-͹���ֹ�";
	$kokyaku_koumokuname[13]="����ʤ�������-̾��";
	$kokyaku_koumokuname[14]="TEL";
	$kokyaku_koumokuname[15]="FAX";
	$kokyaku_koumokuname[16]="E-Mail";
	$kokyaku_koumokuname[17]="�е�����";
	$kokyaku_koumokuname[18]="�е�ǯ����";
	$kokyaku_koumokuname[19]="���ܶ�";
	$kokyaku_koumokuname[20]="ǯ��";
	$kokyaku_koumokuname[21]="���Ȱ�";
	$kokyaku_koumokuname[22]="�ȼ�";
	$kokyaku_koumokuname[23]="��������";
	$kokyaku_koumokuname[24]="�ץ�Х���̾";
	$kokyaku_koumokuname[25]="Website";
	$kokyaku_koumokuname[26]="�����С�";
	$kokyaku_koumokuname[27]="��������";
	$kokyaku_koumokuname[28]="PC���";
	$kokyaku_koumokuname[29]="LAN�Ķ�";
	$kokyaku_koumokuname[30]="�Ķ�ô����̾";
	$kokyaku_koumokuname[31]="����";
	$kokyaku_koumokuname[32]="��ʾ���";
local(@kokyaku_syousai);		#�ܵҥǡ���:�ܺ١Ļ��Υե����������ϳƼ�ǡ���
local(@taiou_koumokuname);	#�б��ǡ���:�ƹ���̾
	$taiou_koumokuname[0]="����ID";
	$taiou_koumokuname[1]="�ܵ�ID";
	$taiou_koumokuname[2]="�ܵ�̾";
	$taiou_koumokuname[3]="�����";
	$taiou_koumokuname[4]="��Ƽ�";
	$taiou_koumokuname[5]="�б�����";
	$taiou_koumokuname[6]="�������";

#
#�ᥤ��롼����
	#ɬ�ܥ��֥롼���󷲥���
require 'form_lib.pl';			#�ե����फ��ξ����Ϣ������ %form �������
require 'jcode.pl';				#�����������Ѵ�
require 'file_access_lib.pl';	#�ե�������ɤ߽���ʬ
require 'output_sub.pl';		#HTML������ʬ

	#�Ķ��ǡ������ɤ߼�������
@config=&file_access("<$file_config",1);
if($error_file==0) {
	#���ν���
	local($i);			#�롼����ʸ����
	local($j);			#���������ѹ�����
	local(@config2);	#����������ʸ����
	for($i=0,$j=0;$i<=$#config;$i++) {
		if(substr($config[$i],0,2) ne '//') {
			$config2[$j]=$config[$i];
			$j++;
		}
	}
	@config=@config2;
	
	#��ư���ʤɤ�ɽ�������Ƕ���Ͽ���줿���������
	if($config[2]>0) {
		$view_start=$config[2];
	}
}
	#�ե����फ�����ǡ�����ʬ��
&init_form($kanji_code);

	#�Ȥꤢ�����Ƽ��ͤ�����
		#�Ƶ�ǽ�ؤ�ľ�ܥ�󥯤�����å����줿���ɤ����ˤĤ���
if(length($form{'html_sw'})>0) {
	$sw=$form{'html_sw'};
}
		#�־ܺ١ġ����ϸ�ɤ��Υڡ������ᤵ���Τ���
if(length($form{'backpage'})>0) {
	$system_back=$form{'backpage'};
}
		#���󸡺�������ˡ���ɤ߼��
if($form{'search_before_houhou'}>0) {
	$search_houhou=$form{'search_before_houhou'};
	$search_keyword=$form{'search_before_word'};
}
		#�����ԥ⡼�ɤ�On/Off�����Ϥ�
$kanrimode_passwordkari=crypt($config[1],$kanrimode_crypt);
if(length($form{'kanrimode_check'})>0) {
	if($form{'kanrimode_check'} eq $kanrimode_passwordkari) {
		$kanrimode_sw=1;
		$kanrimode_password=$form{'kanrimode_check'};
		
		#���ƥ᡼�������������ꥹ�Ȥ��ɲá�������뤫�ɤ���(ID�ֹ�ǻ���)
		if(length($form{'sendmail_addlist'})>0) {
			$form{$form{'sendmail_addlist'}}=1;
		} elsif(length($form{'sendmail_dellist'})>0) {
			delete $form{$form{'sendmail_dellist'}};
		} elsif($form{'sendmail_all'}==1) {
			#�����ꥹ�����Τ�����᤹
			local(@keys);	#�ϥå�����Υ����ꥹ�ȼ�����
			local($i);		#�롼����
			
			@keys=keys %form;
			for($i=0;$i<=$#keys;$i++) {
				if(length($keys[$i])>0&&$keys[$i]!=0) {
					delete $form{$keys[$i]};
				}
			}
		} elsif($form{'sendmail_all'}==2) {
			#�����ꥹ�Ȥ���Ͽ���ɥ쥹�����ɲ�
			local($i);		#�롼����
			require 'tab_cut_lib.pl';
			
			if($#kokyaku_data==-1) {
				@kokyaku_data=&file_access("<$file_kokyaku",7);
			}
			for($i=1;$i<=$#kokyaku_data;$i++) {
				&tab_cut($kokyaku_data[$i]);
				$form{$cut_end[0]}=1;
			}
		}
	} else {
		$sw=8;
		$kanrimode_sw=3;
	}
}
		#�����ԥ⡼�ɵ�ư�ѤΥѥ���ɤ����Ϥ��줿��
if($form{'myaction'} eq "kanrimode_change") {
	$sw=8;
}


	#�Ƽﵡǽ�μ¹�
if($error_code==0) {
	while($system_loop==0) {
		if($sw==0) {
			#�ǿ��� ?�� �ˤĤ���(�������)--------------------------------------
			
			require 'set_new_sub.pl';	#���֥롼����:�ǿ��� ?�� �ˤĤ���(�������)
			&set_new();
			
				#HTML���Ϥ˰�ư��
			$system_loop++;
			$system_back=0;
		} elsif($sw==1) {
			#�������-----------------------------------------------------------
			
			require 'search_sub.pl';	#���֥롼����:�������
			&search();
			
				#HTML���Ϥ˰�ư��
			$system_loop++;
			$system_back=1;
		} elsif($sw==2) {
			#�ܺ�(���������ɲÎ����)����ɽ��--------------------------------------
			
			require 'syousai_sub.pl';
				#���֥롼����:�ܺ�(���������ɲÎ����)����ɽ��
			&syousai();
			
				#HTML���Ϥ˰�ư��
			$system_loop++;
		} elsif($sw==3) {
			#�������ɲÎ������ǧ-------------------------------------------------
			
			require 'edit_check_sub.pl';	#���֥롼����:�������ɲÎ������ǧ
			&edit_check();
			
				#¾�ν����ؤϰܤ�Τ���
			if(length($edit_inputerror)>0) {
				#�⤷���ϥ��顼������ʤ����ϲ��̤����
				$sw=2;
				$edit_id=$form{'input_kokyakudata0'};
			} else {
				#���顼���ʤ��ʤ������˥ǡ�����Ͽ
				require 'seiri_formdata_lib.pl';	#�ե�����Υǡ���������������
				&seiri_formdata();	#�ե�����Υǡ���������������
				
				#HTML���Ϥ˰�ư��
				$system_loop++;
			}
		} elsif($sw==4) {
			#�������ɲÎ��������-------------------------------------------------
			
			require 'edit_save_sub.pl';	#���֥롼����:�������ɲÎ������ǧ
			&edit_save();
			undef(@kokyaku_data);		#�ܵҥǡ������ö�ꥻ�å�
			
				#¾�ν����ذܤ�
			$sw=$system_back;
			$system_loop=0;
		} elsif($sw==5) {
			#��������������θ��ߤξ���ɽ������---------------------------------
			
			require 'master_edit_info_sub.pl';	#�����Ե�ǽ�θ��ߤξ���ɽ������
			&master_edit_info();
			
				#HTML���Ϥ˰�ư��
			$system_back=5;
			$system_loop++;
		} elsif($sw==6) {
			#���������������ǧ-------------------------------------------------
			
			require 'master_check_edit_sub.pl';	#�����Ե�ǽ�γ�ǧɽ������
			&master_check_edit();
			
				#HTML���Ϥ˰�ư��
			$system_back=6;
			$system_loop++;
		} elsif($sw==7||$sw==12||$sw==14) {
			#���������������ڤ��ؤ�---------------------------------------------
			#�󡢰���������������ڤ��ؤ�---------------------------------------
			#�󡢰��ƥ᡼�����������ڤ��ؤ�-------------------------------------
			
			require 'master_setting_change_sub.pl';	#���������������ڤ��ؤ�
			if($sw==7) {&master_setting_change(0);}
			elsif($sw==12) {&master_setting_change(1);}
			elsif($sw==14) {&master_setting_change(2);}
			
				#��������������ذܤ�
			$sw=5;
		} elsif($sw==8) {
			#�����ԥ⡼�ɤΥ����å�ON/OFF�ˤĤ���-------------------------------
			
			require 'master_switch_sub.pl';
				#���֥롼����:�����Ե�ǽ�Υ����å�ON/OFF�ˤĤ���
			&master_switch();
			
				#HTML���Ϥ˰�ư��
			$system_back=0;	#�ܺ١Ĥ�¹Ը�⤳�Υڡ����ؤ����ʤ�
			$system_loop++;
		} elsif($sw==10) {
			#�б�������Խ�����-------------------------------------------------
			
			require 'edit_rireki_sub.pl';
				#���֥롼����:�б�������Խ�����
			&edit_rireki();
			
				#�ܺ�ɽ�������
			$system_back=2;	#�ܺ١Ĥ�¹Ը�⤳�Υڡ����ؤ����ʤ�
			$system_loop++;
		} elsif($sw==9) {
			#�б�������ɲá��Խ������¸---------------------------------------
			
			require 'save_rireki_sub.pl';
				#���֥롼����:�б�������ɲá��Խ������¸
			&save_rireki();
			
				#�ܺ�ɽ�������
			$sw=2;
			$system_loop=0;
		} elsif($sw==13||$sw==15) {
			#�᡼����������ݥ᡼����������-------------------------------------
			#���ƥ᡼���������Ƴ�ǧ($sw=15)-------------------------------------
			
			require 'edit_sendmail_naiyou_sub.pl';
				#���֥롼����:�᡼����������
			&edit_sendmail_naiyou();
			
				#�ܺ�ɽ�������
			$system_back=13;
			$system_loop++;
		} elsif($sw==16) {
			#�᡼����������ݥ᡼������-----------------------------------------
			
			require 'edit_sendmail_send_sub.pl';
				#���֥롼����:�᡼������
			&edit_sendmail_send();
			
				#����ɽ���
			$reload_url=$file_main;
			
				#������������������
			$sw=5;
			$system_loop++;
		} else {
			#�����������������ѹ���ǧ($sw=11)---------------------------------
			#�᡼����������ݥ᡼����������ɽ�������ѹ���ǧ($sw=17)-------------
			
				#�ܺ�ɽ�������
			$system_back=$html_sw;
			$system_loop++;
		}
	}
}

	#���顼��å�����
if($error_code>0) {
	$error_htmlplus=$error_htmlplus."<hr>\n";
	$error_htmlplus=$error_htmlplus."$version<br>\n";
	$error_htmlplus=$error_htmlplus."ERROR code $error_code.<br>\n";
	$error_htmlplus=$error_htmlplus."Can't open file '$error_file'.<br>\n";
	$error_htmlplus=$error_htmlplus."�ե����� '$error_file' ���ɤ�(�⤷���Ͻ񤭹���)�ޤ���.<br>\n";
	$error_htmlplus=$error_htmlplus."�����Ԥ⤷���ϳ�ȯ�����䤤��碌�ξ塢������褷�Ƥ�����ٵ�ư�����Ƥ���������<br>\n";
	$error_htmlplus=$error_htmlplus."<hr>\n";
}

	#HTML����
&output($sw);

	#��λ
exit(0);
