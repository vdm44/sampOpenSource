#define FILTERSCRIPT

#include <a_samp>

/*forward Race_Game_Start_s(houseid);//����ʱĳ����������
public Race_Game_Start_s(houseid)
{
	new msg[128];
	if(RaceHouse[houseid][rstate]==1)
	    {
			if(RaceHouse[houseid][rtimes]==0)
			    {
			        KillTimer(RaceHouse[houseid][rtimer]);����PRACE�˴���������д������
					RaceHouse[houseid][playerrank]  = SetTimerEx("RaceRunRank",200,true,"i",houseid);*/ 
					
/*�������
enum racegametype{
					playerrank,//ʵʱ����
					players[6],//ʵʱ�������

stock Race_Game_Join(playerid,houseid)//ʹָ����Ҽ���ָ������.ʧ�ܷ���-1
{
	if(RaceHouse[houseid][rps]==6)return -1;
	if(RaceHouse[houseid][rraceid]==-1) return -1;
	if(RaceHouse[houseid][rstate]!=0) return -1;
	�������������
	for(new i = 0; i < 6; i ++)
	{//Ҳ��ѭ�����в�λ
		if(RaceHouse[houseid][players][i] == INVALID_PLAYER_ID)
		{//֤�������λ�ǿյ�
			RaceHouse[houseid][players][i] = playerid;//�������λ��ֵ�������ҵ�id
			break;//����ѭ��
		}
	}
stock Race_Game_Quit(playerid)//ʹָ������˳����� ����RaceHouse[playerid][rtimes]=0;����
{
	for(new i = 0; i < 6; i ++)
	{
		if(RaceHouse[hid][players][i] == playerid)
		{//�ҵ�����ڵĲ�λ
			RaceHouse[hid][players][i] = INVALID_PLAYER_ID;
			break;//�������λ����
		}
	}
	
	
//�½�������ʱ��,�Ȱ���������players�������� ������ʼ��
����
format(msg,128,"[����]:{33CCFF} %s �����˹���'%s'������,���������'{FFFF00}/r j %i'{33CCFF}��{FFFF00}�������!",PlayerName[playerid],Race[id][rname],playerid);
SendClientMessageToAll(COLOR,msg);����


for(new i = 0; i < 6; i ++)
{
	RaceHouse[hid][players][i] = INVALID_PLAYER_ID;
}	
	
	��һ���ط�д���
forward RaceRunRank(houseid);
public RaceRunRank(houseid)
{
	new string[128];
	new playerCP[7],//��ǰcp
	Float:playerDist[7];//������һ��cp����
	playerCP[6] = -1;
	new rank[7]={6,6,6,6,6,6,6};//����,Ĭ��6�����ж���player0,Ҳ���ǻ�׼CP��-1
	new test;
	//new tick = GetTickCount();
	new trcp[racecptype];
	for(new i = 0; i < 6; i ++)
	{
		new player=RaceHouse[houseid][players][i];
		if(player == INVALID_PLAYER_ID) continue;
		playerCP[i] = GameRace[player][rgamecp];
		if(playerCP[i]==Race[RaceHouse[GameRace[player][rgameid]][rraceid]][rcps]) continue;
		Race_GetCp(RaceHouse[GameRace[player][rgameid]][rraceid],GameRace[player][rgamecp],trcp);
		playerDist[i] = GetPlayerDistanceFromPoint(player,trcp[rcpx],trcp[rcpy],trcp[rcpz]);
	}
	for(new i = 0; i < 6; i ++)
	{
		for(new j = 0; j < 6; j ++)
		{
			if(test == 1)
			{//����Ѿ��ҵ���λ��
				test = 0;//����Ϊ0
				break;//����ѭ��
			}
			new playera = rank[j];
			if(playerCP[i] < playerCP[playera])//��� i ��cpС�� ���� j ��cp,�ͽ�������ѭ��,������һ��
				continue;
			if(playerCP[i]> playerCP[playera] || (playerCP[i] == playerCP[playera] && playerDist[i] < playerDist[playera]))
			{
				//��� i ��cp�������� j ��cp,���� i ��cp���� ���� j��cp,���� i �ľ��� С������ j �ľ���
				for(new r = 6; r >= j; r --){//�����һλ��ʼ
					if(r == j)
					{//��������Ҷ�����һλ,��ǰ�����ʾ�����Ϊ i 
						rank[r] = i;
						test = 1;//���������ѭ��,�����Ѿ��ҵ���λ��,����������������
						break;
					}
					rank[r] = rank[r - 1];//�����������һλ.
				}
			}
		}
	}
	for(new i = 0; i < 6; i ++){
	new idx = RaceHouse[houseid][players][rank[i]];
	if(idx == INVALID_PLAYER_ID) continue;
	format(string, sizeof(string), "�������� / %i",(i+1));
	TextDrawSetString(Top[idx], string);//�Լ�Ūtextdraw
	}
	//printf("����%d,���δ���ʵʱ������ʱ[%i]ms", houseid,GetTickCount() - tick);
	return 0;
}
*/