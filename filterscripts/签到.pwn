#include <a_samp>
#include <dini>
new PDate[MAX_PLAYERS];//新增全局变量PDate
new PDays[MAX_PLAYERS];//同上
new PToday[MAX_PLAYERS];//同上
forward Load(playerid);//自定义回调
forward Save(playerid);//自定义回调
forward Check(playerid);//自定义回调
main()
{
	print("[签到脚本]加载完毕 By：臭猪36[贴吧开源版]");//输出到控制台

}
public OnPlayerDisconnect(playerid, reason)//玩家退出服务器时触发事件
{
    Save(playerid);//触发回调
    return 1;//这是返回
}

public OnPlayerSpawn(playerid)//玩家出生时触发事件
{
    Load(playerid);//触发回调
    return 1;
}
public OnPlayerConnect(playerid)//玩家连接到服务器时触发的
{
	PDays[playerid]=0;//赋值0到变量PDays
}
public OnGameModeInit()//服务器启动时触发的
{
	SetTimer("Check", 1000,	1);//新增一个定时器回调 这个使用前必须先有forword 自定义一个回调 后面1000是指1000毫秒=1秒 每1秒就触发这个回调
}
public OnPlayerCommandText(playerid, cmdtext[])//玩家输入指令时触发的
{
    new string[1000];//新增局部变量string并且该变量最大字节为1000,数字字母一般为一个字节,汉字是双字节
    if(!strcmp(cmdtext, "/qd", true))//判断输入的指令是否为/qd
    {
	    if(PToday[playerid]==0)//判断该变量是否为0
	    {
  			format(string, sizeof(string), "你已经连续签到[%d]天" ,PDays[playerid]);//定义字符串到straing
		    ShowPlayerDialog(playerid, 30000, DIALOG_STYLE_MSGBOX, "签到状态", string, "签到", "关闭");//显示对话框,30000是对话框的ID 注意不要和别的冲突了
		    return 1;
	    }
 	    if(PToday[playerid]==1)
	    {
  			format(string, sizeof(string), "你已经签到过了!");
		    ShowPlayerDialog(playerid, 30001, DIALOG_STYLE_MSGBOX, "签到状态", string, "关闭", "");
		    return 1;
	    }
    }
    SendClientMessage(playerid,0x00FF40C8,"指令错误");//发送消息给玩家 0x0ff40c8是进制颜色代码
    return 1;
}
public OnDialogResponse(playerid, dialogid,	response, listitem,	inputtext[])//玩家点击对话框触发的
{
	if(dialogid	== 30000)//判断对话ID是否为30000 也就是和上面的对应了
	{
		if(response)
		{
		    new sss[128];
			new Y,M,D,H,F,S;
			getdate(Y,M,D);
			gettime(H,F,S);
			{
				PDays[playerid]++;
				format(sss,128,"[签到]你已经连续签到[{FB8004}%d{00FF40}]天.",PDays[playerid]);
				SendClientMessage(playerid,0x00FF40C8,sss);
	    		GivePlayerMoney(playerid, 1000);//给玩家钱
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
public Check(playerid)//定时器时间到了后触发的回调
{
	new Y,M,D,H,F,S;
	getdate(Y,M,D);//获取服务器日期并赋值到Y、M、D
	gettime(H,F,S);//获取服务器时间 上面同理
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

public Load(playerid)//自定义回调触发了
{
    new file[64];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "签到/%s.ini", name);
    PDays[playerid] = dini_Int(file,"Days");
    PDate[playerid] = dini_Int(file,"Date");
    PToday[playerid] = dini_Int(file,"Today");
}
public Save(playerid)//自定义回调触发了
{
    new file[64];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "签到/%s.ini", name);
    if(!dini_Exists(file)) dini_Create(file);
    dini_IntSet(file, "Days", PDays[playerid]);
	dini_IntSet(file, "Date", PDate[playerid]);
	dini_IntSet(file, "Today", PToday[playerid]);
}

