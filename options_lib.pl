#--------------------------------------
#�ܵҴ���DataBase�� �ե�����ǥ�˥塼�������ɽ������ʸ����
#&options($�ƤӽФ�����)
#	����:
#		@option_message�ĥ�˥塼�γ�����
#		$option_message2��$kokyaku_data_menu���ͤ��б�����ƤӽФ���˥塼��
#			-1�Ĥ��θƤӽФ����ܤϥ�˥塼�Ȥ���ɽ�������ΤǤʤ�
sub options {
	local($i) = @_;	#�ƤӽФ�����
	local($j) = 1;	#�֤�����
	
	if($i==-1) {
		$option_message2=-2;
		$option_message[0]="����ˬ��(�Ķ�)";
		$option_message[1]="����ˬ��(���ݡ���)";
		$option_message[2]="TEL(��� �� ��)";
		$option_message[3]="TEL(�� �� ���)";
		$option_message[4]="FAX";
		$option_message[5]="E-Mail";
		$option_message[6]="��ĥPC����";
		$option_message[7]="����¾";
	} elsif($i==20) {
		$option_message2=0;
		$option_message[0]="�ݡ������ݡ�";
		$option_message[1]="1����̤��";
		$option_message[2]="1��3����";
		$option_message[3]="3��5����";
		$option_message[4]="5��10����";
		$option_message[5]="10���߰ʾ�";
	} elsif($i==21) {
		$option_message2=1;
		$option_message[ 0]="�ݡ������ݡ�";
		$option_message[ 1]="1��9��";
		$option_message[ 2]="10��29��";
		$option_message[ 3]="30��49��";
		$option_message[ 4]="50��99��";
		$option_message[ 5]="100��299��";
		$option_message[ 6]="300��499��";
		$option_message[ 7]="500��999��";
		$option_message[ 8]="1000��2999��";
		$option_message[ 9]="3000��4999��";
		$option_message[10]="5000�Ͱʾ�";
	} elsif($i==22) {
		$option_message2=2;
		$option_message[ 0]="����¾";
		$option_message[ 1]="��¤��";
		$option_message[ 2]="���ҡ����������";
		$option_message[ 3]="�����ӥ���";
		$option_message[ 4]="��ͻ���ڷ����ݸ�";
		$option_message[ 5]="���ߡ���ư��";
		$option_message[ 6]="�ع������鵡��";
		$option_message[ 7]="��͢������";
		$option_message[ 8]="�±������ŵ���";
		$option_message[ 9]="���������ǡ�����������";
		$option_message[10]="���ӡ��建���۶�";
		$option_message[11]="����ģ����������";
		$option_message[12]="�̿�������";
	} elsif($i==27) {
		$option_message2=3;
		$option_message[ 0]="���ʥ�";
		$option_message[ 1]="ISDN�������륢�å�";
		$option_message[ 2]="�ե�å�ISDN";
		$option_message[ 3]="�ե�å�ADSL";
		$option_message[ 4]="����¾ADSL";
		$option_message[ 5]="CATV";
		$option_message[ 6]="FTTH";
		$option_message[ 7]="������";
	} elsif($i==29) {
		$option_message2=4;
		$option_message[ 0]="̵��";
		$option_message[ 1]="ͭ��";
		$option_message[ 2]="����";
	} else {
		$option_message2=-1;
	}
}
1;
