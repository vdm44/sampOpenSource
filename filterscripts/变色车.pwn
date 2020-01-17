//尼斯城-V0.3服务器专用脚本
#include <a_samp>


#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_BLACK 0x000000AA
#define COLOR_TRANS 0xFFFFFF00
new CTimer1;
new CTimer2;
new CTimer3;
new CTimer4;
new CTimer5;
forward Color1(playerid);
forward Color2(playerid);
forward Color3(playerid);
forward Color4(playerid);
forward Color5(playerid);

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" 变色车脚本-123456-Coolke_Red		");
	print("--------------------------------------\n");
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
//变色车开启
    new str[128];
	if (strcmp("/bsc", cmdtext, true, 10) == 0)
	{
	return 1;
        if(IsPlayerInAnyVehicle(playerid))
        {
			SendClientMessage(playerid, COLOR_RED, "[七彩变色车]你成功打开变色车系统,输入/bscoff 关闭变色车！");
			KillTimer(CTimer2);
 			KillTimer(CTimer3);
 			KillTimer(CTimer4);
 			KillTimer(CTimer5);
			CTimer1 = SetTimerEx("Color1", 500, 0, "d" ,playerid);
		}
	}
//变色车关闭
	if (strcmp("/bscoff", cmdtext, true, 10) == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
	    	SendClientMessage(playerid, COLOR_RED, "[七彩变色车]你成功关闭了变色车系统,输入/bsc 打开变色车！");
			KillTimer(CTimer1);
			KillTimer(CTimer2);
			KillTimer(CTimer3);
			KillTimer(CTimer4);
			KillTimer(CTimer5);
		}
	}
}
public Color1(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   KillTimer(CTimer1);
   ChangeVehicleColor(vehicleid, 1, 1);
   CTimer2 = SetTimerEx("Color2", 500, 0, "d" ,playerid);
}

public Color2(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   KillTimer(CTimer2);
   ChangeVehicleColor(vehicleid, 2, 2);
   CTimer3 = SetTimerEx("Color3", 500, 0, "d" ,playerid);
}

public Color3(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   KillTimer(CTimer3);
   ChangeVehicleColor(vehicleid, 3, 3);
   CTimer4 = SetTimerEx("Color4", 500, 0, "d", playerid);
}

public Color4(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   KillTimer(CTimer4);
   ChangeVehicleColor(vehicleid, 4, 4);
   CTimer5 = SetTimerEx("Color5", 500, 0, "d" ,playerid);
}

public Color5(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   KillTimer(CTimer5);
   ChangeVehicleColor(vehicleid, 5, 5);
   SetTimerEx("Color1", 500, 0, "d" ,playerid);
}

