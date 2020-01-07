#define FILTERSCRIPT

#include <a_samp>

/*forward Race_Game_Start_s(houseid);//倒计时某个比赛房间
public Race_Game_Start_s(houseid)
{
	new msg[128];
	if(RaceHouse[houseid][rstate]==1)
	    {
			if(RaceHouse[houseid][rtimes]==0)
			    {
			        KillTimer(RaceHouse[houseid][rtimer]);请在PRACE此处添加这两行代码←↓
					RaceHouse[houseid][playerrank]  = SetTimerEx("RaceRunRank",200,true,"i",houseid);*/ 
					
/*增加这个
enum racegametype{
					playerrank,//实时排名
					players[6],//实时排名玩家

stock Race_Game_Join(playerid,houseid)//使指定玩家加入指定房间.失败返回-1
{
	if(RaceHouse[houseid][rps]==6)return -1;
	if(RaceHouse[houseid][rraceid]==-1) return -1;
	if(RaceHouse[houseid][rstate]!=0) return -1;
	这下面增加这个
	for(new i = 0; i < 6; i ++)
	{//也是循环所有槽位
		if(RaceHouse[houseid][players][i] == INVALID_PLAYER_ID)
		{//证明这个槽位是空的
			RaceHouse[houseid][players][i] = playerid;//吧这个槽位赋值成这个玩家的id
			break;//结束循环
		}
	}
stock Race_Game_Quit(playerid)//使指定玩家退出房间 放在RaceHouse[playerid][rtimes]=0;上面
{
	for(new i = 0; i < 6; i ++)
	{
		if(RaceHouse[hid][players][i] == playerid)
		{//找到玩家在的槽位
			RaceHouse[hid][players][i] = INVALID_PLAYER_ID;
			break;//把这个槽位清零
		}
	}
	
	
//新建比赛的时候,先把这个房间的players数组清零 排名初始化
放在
format(msg,128,"[赛车]:{33CCFF} %s 创建了关于'%s'的赛道,你可以输入'{FFFF00}/r j %i'{33CCFF}来{FFFF00}加入比赛!",PlayerName[playerid],Race[id][rname],playerid);
SendClientMessageToAll(COLOR,msg);下面


for(new i = 0; i < 6; i ++)
{
	RaceHouse[hid][players][i] = INVALID_PLAYER_ID;
}	
	
	找一个地方写这个
forward RaceRunRank(houseid);
public RaceRunRank(houseid)
{
	new string[128];
	new playerCP[7],//当前cp
	Float:playerDist[7];//距离下一个cp距离
	playerCP[6] = -1;
	new rank[7]={6,6,6,6,6,6,6};//排行,默认6个排行都是player0,也就是基准CP点-1
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
			{//如果已经找到了位置
				test = 0;//重置为0
				break;//跳出循环
			}
			new playera = rank[j];
			if(playerCP[i] < playerCP[playera])//如果 i 的cp小于 排行 j 的cp,就结束本次循环,进行下一次
				continue;
			if(playerCP[i]> playerCP[playera] || (playerCP[i] == playerCP[playera] && playerDist[i] < playerDist[playera]))
			{
				//如果 i 的cp大于排行 j 的cp,或者 i 的cp等于 排行 j的cp,并且 i 的距离 小于排行 j 的距离
				for(new r = 6; r >= j; r --){//从最后一位开始
					if(r == j)
					{//把其他玩家都往下一位,当前的名词就设置为 i 
						rank[r] = i;
						test = 1;//告诉外面的循环,这里已经找到了位置,并重新排序了排名
						break;
					}
					rank[r] = rank[r - 1];//把玩家往下移一位.
				}
			}
		}
	}
	for(new i = 0; i < 6; i ++){
	new idx = RaceHouse[houseid][players][rank[i]];
	if(idx == INVALID_PLAYER_ID) continue;
	format(string, sizeof(string), "房间排名 / %i",(i+1));
	TextDrawSetString(Top[idx], string);//自己弄textdraw
	}
	//printf("房间%d,本次处理实时排名耗时[%i]ms", houseid,GetTickCount() - tick);
	return 0;
}
*/