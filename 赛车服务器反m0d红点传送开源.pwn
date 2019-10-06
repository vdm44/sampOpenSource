#include <a_samp>
/** 

*作者:[R_ST]Hygen
*Copyright (c) RaceSpeedTime. All Rights Reserved
*版权归属RaceSpeedTime(RST)团队以及Hygen所有 
*建议所有赛车服采用反m0d等作弊器传送红点 
*请将检测代码放入赛车系统检测点代码块合适的地方，以Prace为例。 
*直接编译不可取。 
*原理为直接判断玩家吃到点的速度为0，如高级赛车系统例如Prace带函数的点需要把反作弊写前面
*不然如果有设置赛车速度为0就误封了
*还可以加个坐标判断GetPlayerPos，即判断玩家的坐标和CP点的坐标相同（一般人吃点不可能吃正中心，而且双精度的坐标差很大的。 
*https://wiki.sa-mp.com/wiki/GetPlayerPos
*(理论上传送的话高度会大于一点，所以不需要判断高度只判断X,Z还是X,Y轴就加上速度0就行）

*/ 


stock GetSpeed(msg)//获取载具速度 
{
   	/*new Float:x,Float:y,Float:z,Float:temp;
	GetVehicleVelocity(GetPlayerVehicleID(msg),x,y,z);
	//return floatpower((x * x) + (y * y) + (z * z),0.5) * 180;*/
    new Float:ST[4];
    GetVehicleVelocity(GetPlayerVehicleID(msg),ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 180;
	return floatround(ST[3]);
}
stock GetName(playerid)//获取玩家名字 
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
			if (GetSpeed(playerid)==0)//这里是反作弊主代码
			{
				format(msgs,sizeof(msgs),"[系统] 玩家: %s 使用第三方辅助严重影响了游戏公平性 被反作弊封杀了! ",GetName(playerid));
				SendClientMessageToAll(0xFF0000AA,msgs);
				Kick(playerid);
				break;
			}
		}
	} 
	return 0;
} 
