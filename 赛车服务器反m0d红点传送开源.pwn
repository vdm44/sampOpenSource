#include <a_samp>
/** 

*����:[R_ST]Hygen
*Copyright (c) RaceSpeedTime. All Rights Reserved
*��Ȩ����RaceSpeedTime(RST)�Ŷ��Լ�Hygen���� 
*�����������������÷�m0d�����������ͺ�� 
*�뽫�������������ϵͳ����������ʵĵط�����PraceΪ���� 
*ֱ�ӱ��벻��ȡ�� 
*ԭ��Ϊֱ���ж���ҳԵ�����ٶ�Ϊ0����߼�����ϵͳ����Prace�������ĵ���Ҫ�ѷ�����дǰ��
*��Ȼ��������������ٶ�Ϊ0�������
*�����ԼӸ������ж�GetPlayerPos�����ж���ҵ������CP���������ͬ��һ���˳Ե㲻���ܳ������ģ�����˫���ȵ������ܴ�ġ� 
*https://wiki.sa-mp.com/wiki/GetPlayerPos
*(�����ϴ��͵Ļ��߶Ȼ����һ�㣬���Բ���Ҫ�жϸ߶�ֻ�ж�X,Z����X,Y��ͼ����ٶ�0���У�

*/ 


stock GetSpeed(msg)//��ȡ�ؾ��ٶ� 
{
   	/*new Float:x,Float:y,Float:z,Float:temp;
	GetVehicleVelocity(GetPlayerVehicleID(msg),x,y,z);
	//return floatpower((x * x) + (y * y) + (z * z),0.5) * 180;*/
    new Float:ST[4];
    GetVehicleVelocity(GetPlayerVehicleID(msg),ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 180;
	return floatround(ST[3]);
}
stock GetName(playerid)//��ȡ������� 
{
    new GPlayerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,GPlayerName,sizeof(GPlayerName));
    return GPlayerName;
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(RaceHouse[GameRace[playerid][rgameid]][rstate]==2)
	 {
	 	new msg[128],raid=RaceHouse[GameRace[playerid][rgameid]][rraceid];
		if(GetPlayerState(playerid)==2)
		{
			Race_Cp_Script_Start(playerid,raid,GameRace[playerid][rgamecp]);
		}
		if(GameRace[playerid][rgamecp]>1)
		{
			if (GetSpeed(playerid)==0)//�����Ƿ�����������
			{
				format(msgs,sizeof(msgs),"[ϵͳ] ���: %s ʹ�õ�������������Ӱ������Ϸ��ƽ�� �������׷�ɱ��! ",GetName(playerid));
				SendClientMessageToAll(0xFF0000AA,msgs);
				Kick(playerid);
				break;
			}
		}
	} 
	return 0;
} 
