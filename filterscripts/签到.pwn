#include <a_samp>
#include <dini>
new PDate[MAX_PLAYERS];//����ȫ�ֱ���PDate
new PDays[MAX_PLAYERS];//ͬ��
new PToday[MAX_PLAYERS];//ͬ��
forward Load(playerid);//�Զ���ص�
forward Save(playerid);//�Զ���ص�
forward Check(playerid);//�Զ���ص�
main()
{
	print("[ǩ���ű�]������� By������36[���ɿ�Դ��]");//���������̨

}
public OnPlayerDisconnect(playerid, reason)//����˳�������ʱ�����¼�
{
    Save(playerid);//�����ص�
    return 1;//���Ƿ���
}

public OnPlayerSpawn(playerid)//��ҳ���ʱ�����¼�
{
    Load(playerid);//�����ص�
    return 1;
}
public OnPlayerConnect(playerid)//������ӵ�������ʱ������
{
	PDays[playerid]=0;//��ֵ0������PDays
}
public OnGameModeInit()//����������ʱ������
{
	SetTimer("Check", 1000,	1);//����һ����ʱ���ص� ���ʹ��ǰ��������forword �Զ���һ���ص� ����1000��ָ1000����=1�� ÿ1��ʹ�������ص�
}
public OnPlayerCommandText(playerid, cmdtext[])//�������ָ��ʱ������
{
    new string[1000];//�����ֲ�����string���Ҹñ�������ֽ�Ϊ1000,������ĸһ��Ϊһ���ֽ�,������˫�ֽ�
    if(!strcmp(cmdtext, "/qd", true))//�ж������ָ���Ƿ�Ϊ/qd
    {
	    if(PToday[playerid]==0)//�жϸñ����Ƿ�Ϊ0
	    {
  			format(string, sizeof(string), "���Ѿ�����ǩ��[%d]��" ,PDays[playerid]);//�����ַ�����straing
		    ShowPlayerDialog(playerid, 30000, DIALOG_STYLE_MSGBOX, "ǩ��״̬", string, "ǩ��", "�ر�");//��ʾ�Ի���,30000�ǶԻ����ID ע�ⲻҪ�ͱ�ĳ�ͻ��
		    return 1;
	    }
 	    if(PToday[playerid]==1)
	    {
  			format(string, sizeof(string), "���Ѿ�ǩ������!");
		    ShowPlayerDialog(playerid, 30001, DIALOG_STYLE_MSGBOX, "ǩ��״̬", string, "�ر�", "");
		    return 1;
	    }
    }
    SendClientMessage(playerid,0x00FF40C8,"ָ�����");//������Ϣ����� 0x0ff40c8�ǽ�����ɫ����
    return 1;
}
public OnDialogResponse(playerid, dialogid,	response, listitem,	inputtext[])//��ҵ���Ի��򴥷���
{
	if(dialogid	== 30000)//�ж϶Ի�ID�Ƿ�Ϊ30000 Ҳ���Ǻ�����Ķ�Ӧ��
	{
		if(response)
		{
		    new sss[128];
			new Y,M,D,H,F,S;
			getdate(Y,M,D);
			gettime(H,F,S);
			{
				PDays[playerid]++;
				format(sss,128,"[ǩ��]���Ѿ�����ǩ��[{FB8004}%d{00FF40}]��.",PDays[playerid]);
				SendClientMessage(playerid,0x00FF40C8,sss);
	    		GivePlayerMoney(playerid, 1000);//�����Ǯ
				PDate[playerid]=D;
            	PToday[playerid]=1;
				return 1;
			}
		}
		else
		{
			{
				return 1;
			}
        }
    }
    return 0;
}
public Check(playerid)//��ʱ��ʱ�䵽�˺󴥷��Ļص�
{
	new Y,M,D,H,F,S;
	getdate(Y,M,D);//��ȡ���������ڲ���ֵ��Y��M��D
	gettime(H,F,S);//��ȡ������ʱ�� ����ͬ��
	if(PDate[playerid]!=D)
	{
	 	if(PToday[playerid]==1)
 		{
 			PToday[playerid]=0;
 		}
	}
 	if(PDays[playerid]==0)
 	{
 	
 	}
}

public Load(playerid)//�Զ���ص�������
{
    new file[64];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "ǩ��/%s.ini", name);
    PDays[playerid] = dini_Int(file,"Days");
    PDate[playerid] = dini_Int(file,"Date");
    PToday[playerid] = dini_Int(file,"Today");
}
public Save(playerid)//�Զ���ص�������
{
    new file[64];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "ǩ��/%s.ini", name);
    if(!dini_Exists(file)) dini_Create(file);
    dini_IntSet(file, "Days", PDays[playerid]);
	dini_IntSet(file, "Date", PDate[playerid]);
	dini_IntSet(file, "Today", PToday[playerid]);
}

