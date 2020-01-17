//////////////////////////////////////////////////////////////
// 酷炫世界出品  www.kuxuansj.com
//作者:明慧      作品:背包+摆摊   本人QQ：805750306  有什么问题问我
//可以添加物品 和一些常用的功能  和玩家自己私人商店
// 版权归酷炫世界所有     by:2015.7.29
//////////////////////////////////////////////////////////////
#include <a_samp>
#include <Dini>
#include <streamer>

#define MAX_Item 30//玩家物品上限
#define MAX_Shop 30//商店上限

#define bag_info 50//背包 dialogID
#define Shop_info 30//商Dialog ID

#define Shop_edit 80//商Dialog ID

enum baginfo
{
	BItem[MAX_Item],//物品ID
	BItems[MAX_Item],//物品数量
};
new PBagInfo[MAX_PLAYERS][baginfo];//背包变量]
////////////////
new bagxuanze[MAX_PLAYERS][MAX_Item];//选择要操作的玩家
new bagcheck[MAX_PLAYERS];//档案查看
/////////////////////////////////////////////////////////////////
new buyxuanze[MAX_PLAYERS][MAX_Item];//购买选择
new buycheck[MAX_PLAYERS];//购买操作面板 (其实就是个临时记录)
new buycheckid[MAX_PLAYERS];//购买的摊位ID

new bagtoshop[MAX_PLAYERS][MAX_Item];//背包里的东西放到摊位里
new shoptobag[MAX_PLAYERS][MAX_Item];//摊位里的东西放到背包里
new shopdid[MAX_PLAYERS];//玩家所在的摊位ID
enum shinfo
{
	Shopid,//商店ID
	ShopOBJ,//商店OBJID
	Shopname[256],//商店名称
	Shopown[256],//商店主人
	Shopmoney,//商店资金
    Float:ShopX,//摊位坐标X
    Float:ShopY,//摊位坐标Y
    Float:ShopZ,//摊位坐标Z
	//////////////
	SItem[MAX_Item],//商店 物品id
	SItems[MAX_Item],//商店 物品数量
	SItemsell[MAX_Item],//商店 出售价格
	SItembuy[MAX_Item],//商店 收购价格
};
new ShopInfo[MAX_Shop][shinfo];//商店变量]
new	ShopLabel[MAX_Shop];//商店文字
	
public OnGameModeInit()
{
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	LoadShop();
	print("\n--------------------------------------");
	print("       背包系统          方便玩家，方便生活");
	print("                     酷炫世界                ");
	print("               				            by：明慧 ");
	print("--------------------------------------\n");
	return 1;
}
/////////////////////////////-背包保存/读取-//////////////////////////
forward SavePBag(playerid);
public SavePBag(playerid)
{
	new string[256];
	format(string, sizeof(string),"背包/%s.ini",GetName(playerid));
	if(!dini_Exists(string))
	{
		dini_Create(string);
	}
	for(new id=0;id<MAX_Item;id++)
	{
		new item[256];
		format(item, sizeof(item),"Item%d",id);
		new items[256];
		format(items, sizeof(items),"Itemsome%d",id);
 		dini_IntSet(string,item,PBagInfo[playerid][BItem][id]);
		dini_IntSet(string,items,PBagInfo[playerid][BItems][id]);
		printf("%d",id);
	}
}
forward LoadPBag(playerid);
public LoadPBag(playerid)
{
	new file[64];
 	format(file, sizeof(file),"背包/%s.ini", GetName(playerid));
  	if(dini_Exists(file))
	{
		for(new id=0;id<MAX_Item;id++)
		{
			new item[256];
			format(item, sizeof(item),"Item%d",id);
			new items[256];
			format(items, sizeof(items),"Itemsome%d",id);
	    	PBagInfo[playerid][BItem][id]= dini_Int(file,item);
			PBagInfo[playerid][BItems][id]= dini_Int(file,items);
		}
	}
	else
	{
		SavePBag(playerid);
	}
}
/////////////////////////////-商店保存/读取-//////////////////////////
forward SaveShop(idx);
public SaveShop(idx)
{
	new string[256];
	format(string, sizeof(string),"商店/%d.ini",idx);
	if(!dini_Exists(string))
	{
		dini_Create(string);
	}
	dini_IntSet(string,"ID",ShopInfo[idx][Shopid]);
	dini_Set(string,"Name",ShopInfo[idx][Shopown]);//名字
	dini_Set(string,"Shopname",ShopInfo[idx][Shopname]);//名字
	dini_IntSet(string,"money",ShopInfo[idx][Shopmoney]);//测试
	dini_FloatSet(string,"Spawn_X",ShopInfo[idx][ShopX]);
	dini_FloatSet(string,"Spawn_Y",ShopInfo[idx][ShopY]);
	dini_FloatSet(string,"Spawn_z",ShopInfo[idx][ShopZ]);
	for(new id=0;id<MAX_Item;id++)
	{
		new item[256];
		format(item, sizeof(item),"Item%d",id);
		new items[256];
		format(items, sizeof(items),"Itemsome%d",id);
		new sellitem[256];
		format(sellitem, sizeof(sellitem),"sellItemmoney%d",id);
		new buyitem[256];
		format(buyitem, sizeof(buyitem),"buyItemmoney%d",id);
 		dini_IntSet(string,item,ShopInfo[idx][SItem][id]);
		dini_IntSet(string,items,ShopInfo[idx][SItems][id]);
		dini_IntSet(string,sellitem,ShopInfo[idx][SItemsell][id]);
		dini_IntSet(string,buyitem,ShopInfo[idx][SItembuy][id]);
		printf("%d",id);
	}
}
forward LoadShop();
public LoadShop()
{
	new file[64];
	for(new idx = 1; idx < MAX_Shop; idx++)
	{
	 	format(file, sizeof(file),"商店/%d.ini",idx);
	  	if(dini_Exists(file))
		{
			ShopInfo[idx][Shopid] = dini_Int(file,"ID");
			ShopInfo[idx][Shopmoney] = dini_Int(file,"money");
			strmid(ShopInfo[idx][Shopown], dini_Get(file,"Name"), 0, strlen(dini_Get(file,"Name")), 255);
			strmid(ShopInfo[idx][Shopname], dini_Get(file,"Shopname"), 0, strlen(dini_Get(file,"Shopname")), 255);
  			ShopInfo[idx][ShopX] = dini_Float(file,"Spawn_X");
  			ShopInfo[idx][ShopY] = dini_Float(file,"Spawn_Y");
  			ShopInfo[idx][ShopZ] = dini_Float(file,"Spawn_Z");
			for(new id=0;id<MAX_Item;id++)
			{
				new item[256];
				format(item, sizeof(item),"Item%d",id);
				new items[256];
				format(items, sizeof(items),"Itemsome%d",id);
				new sellitem[256];
				format(sellitem, sizeof(sellitem),"sellItemmoney%d",id);
				new buyitem[256];
				format(buyitem, sizeof(buyitem),"buyItemmoney%d",id);
		    	ShopInfo[idx][SItem][id]= dini_Int(file,item);
				ShopInfo[idx][SItems][id]= dini_Int(file,items);
		    	ShopInfo[idx][SItemsell][id]= dini_Int(file,sellitem);
				ShopInfo[idx][SItembuy][id]= dini_Int(file,buyitem);
			}
			CreateShop(idx);
		}
	}
}
//////////////////////////////////////////////////////////////
public OnPlayerConnect(playerid)//玩家连接
{
	LoadPBag(playerid);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	SavePBag(playerid);
	return 1;
}
public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/bag", cmdtext, true, 10) == 0)
	{
		new id=0;
		new string[256];
		new Smg[128];
		format(Smg, sizeof(Smg), "物品ID\t物品名称\t物品数量\n");
		strcat(string, Smg);
		new itemname[128];
  		for(new a = 0;a<MAX_Item;a++)
  		{
    		if(PBagInfo[playerid][BItem][a]>0)
    		{
    		    format(itemname,sizeof(itemname),"%s",GetItemname(PBagInfo[playerid][BItem][a]));
				format(Smg, sizeof(Smg), "%d\t%s\t%d\t\n",PBagInfo[playerid][BItem][a],itemname,PBagInfo[playerid][BItems][a]);
				strcat(string, Smg);
				bagxuanze[playerid][id]=PBagInfo[playerid][BItem][a];
				id++;
			}
  		}
		ShowPlayerDialog(playerid, bag_info, DIALOG_STYLE_TABLIST_HEADERS, "我的背包", string, "选择","取消");
		return 1;
	}
	if(strcmp("/add1", cmdtext, true, 10) == 0)//临时添加物品指令罢了
	{
		SendClientMessage(playerid, 0xFFFFFFC8, "你给自己添加了10个翔");
		AddItem(playerid,1,10);//给玩家添加了 10个物品ID1 也就是屎
		return 1;
	}
	if(strcmp("/add2", cmdtext, true, 10) == 0)//临时添加物品指令罢了
	{
		SendClientMessage(playerid, 0xFFFFFFC8, "你给自己添加了10个血袋");
		AddItem(playerid,2,10);//给玩家添加了 10个物品ID1 也就是屎
		GivePlayerMoney(playerid,100000);
		return 1;
	}
	if(strcmp("/add3", cmdtext, true, 10) == 0)//临时添加物品指令罢了
	{
		SendClientMessage(playerid, 0xFFFFFFC8, "你给自己添加了10个翔");
		AddItem(playerid,3,10);//给玩家添加了 10个物品ID1 也就是屎
		return 1;
	}
	if(strcmp("/add4", cmdtext, true, 10) == 0)//临时添加物品指令罢了
	{
		//-------------------------------------------------
		new listitems[] = "Weapon\tPrice\tAmmo\n" \
	 	"Deagle\t$5000\t100\n" \
	 	"Sawnoff\t$5000\t100\n" \
		 	 "Pistol\t$1000\t50\n" \
			  	 "M4\t$10000\t100\n" \
				   "MP5\t$7500\t200\n" \
				   	 "Grenade\t$500\t1\n" \
							 "Parachute\t$10000\t1\n" \
							 	 "Lorikeet\t$50000\t500\n";
 	 	ShowPlayerDialog(playerid,2,DIALOG_STYLE_TABLIST_HEADERS,"Buy Weapon",listitems,"Select","Cancel"); //-------------------------------------------------
		return 1;
	}
/////////////////////////////////////////////////////////
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == bag_info)
	{
		if(!response) return 1;
  		bagcheck[playerid] =bagxuanze[playerid][listitem];
 		ShowPlayerDialog(playerid, bag_info+1, DIALOG_STYLE_LIST, "物品管理", "{FF8000}使用物品\n丢弃物品(单个丢)", "选择", "取消");
	}
		//
	if(dialogid == bag_info+1)
	{
 		if(!response) return 1;
		if(listitem == 0)
		{
		    if(bagcheck[playerid]==1)//要是物品ID是1 就怎么怎么样
		    {
				new string[256];
				format(string, sizeof(string), "{8000FF}你使用了物品:%s 数量:1个",GetItemname(bagcheck[playerid]));
				SendClientMessage(playerid, 0xFFFFFFC8, string);
				SendClientMessage(playerid, 0xFFFFFFC8, "吃屎的嘴:我操 味道还不错!你要不要也来点");
				RemoveItem(playerid,bagcheck[playerid],1);//注意 这1 别写成-1 因为这个就是扣除物品
				return 1;
			}
			else if(bagcheck[playerid]==2)//要是物品ID是2 就怎么怎么样
			{
				new string[256];
				format(string, sizeof(string), "{8000FF}你使用了物品:%s 数量:1个",GetItemname(bagcheck[playerid]));
				SendClientMessage(playerid, 0xFFFFFFC8, string);
				SendClientMessage(playerid, 0xFFFFFFC8, "这个护甲还不错 很重 老子的腿");
				RemoveItem(playerid,bagcheck[playerid],1);//注意 这1 别写成-1 因为这个就是扣除物品
				SetPlayerArmour(playerid, 100);//给玩家设置护甲100
				return 1;
			}
			else if(bagcheck[playerid]==3)//要是物品ID是3 就怎么怎么样
			{
				new string[256];
				format(string, sizeof(string), "{8000FF}你使用了物品:%s 数量:1个",GetItemname(bagcheck[playerid]));
				SendClientMessage(playerid, 0xFFFFFFC8, string);
				SendClientMessage(playerid, 0xFFFFFFC8, "城管： 你的许可证给我看看。");
				SendClientMessage(playerid, 0xFFFFFFC8, "城管： 小子记得每天交保护费，我们会给你专门的保护。");
				RemoveItem(playerid,bagcheck[playerid],1);//注意 这1 别写成-1 因为这个就是扣除物品
				/////////////////
				new Float:x, Float:y, Float:z;
				new newshop = GetShopID();
				new sendername[MAX_PLAYER_NAME];
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(newshop == -1)
				{
					SendClientMessage(playerid, 0xFFFFFFC8, "城管: 不允许摆摊了，摊位都满了。");
					return 0;
                }
				GetPlayerPos(playerid,x,y,z);
				ShopInfo[newshop][Shopid] = newshop;
				ShopInfo[newshop][ShopX] = x;
				ShopInfo[newshop][ShopY] = y;
				ShopInfo[newshop][ShopZ] = z;
				strmid(ShopInfo[newshop][Shopown], sendername, 0, strlen(sendername), 255);
				strmid(ShopInfo[newshop][Shopname], "请修改一下我", 0, strlen("请修改一下我"), 255);
				SaveShop(newshop);
				CreateShop(newshop);
				return 1;
			}
		}
		if(listitem == 1)
		{
			new string[256];
			format(string, sizeof(string), "{8000FF}你丢掉了物品:%s 数量:1个", GetItemname(bagcheck[playerid]));
			SendClientMessage(playerid, 0xFFFFFFC8, string);
			RemoveItem(playerid,bagcheck[playerid],1);//注意 这1 别写成-1 因为这个就是扣除物品
			return 1;
		}
	}
////////////////////////////////////////////////////////////////////////////////////////
	if(dialogid == Shop_info)
	{
		if(!response) return 1;
  		buycheck[playerid] =buyxuanze[playerid][listitem];
 		ShowPlayerDialog(playerid, Shop_info+1, DIALOG_STYLE_LIST, "地摊", "{FF8000}购买物品(单个购买)", "选择", "取消");
	}
	if(dialogid == Shop_info+1)
	{
 		if(!response) return 1;
		if(listitem == 0)
		{
		    if(buycheck[playerid]>=0)
		    {
		        new sid=buycheckid[playerid];
		        for(new i=0;i<MAX_Item;i++)
		        {
					if(ShopInfo[sid][SItem][i]==buycheck[playerid])
					{
					    if(ShopInfo[sid][SItemsell][i]>0)//出售价钱大于0 那就说嘛它是出售状态
					    {
					        if(GetPlayerMoney(playerid)<ShopInfo[sid][SItemsell][i])
					        {
					        	SendClientMessage(playerid, 0xFFFFFFC8, "地摊贩：没钱还敢来买？");
					        	return 0;
					        }
							AddItem(playerid,buycheck[playerid],1);//玩家物品+1
							ShopRemoveItem(sid,buycheck[playerid],1);//摊子东西-1
							new string[256];
							format(string, sizeof(string), "{8000FF}你从[%s]摊位购买了[%s]*1", ShopInfo[sid][Shopname],GetItemname(buycheck[playerid]));
							SendClientMessage(playerid, 0xFFFFFFC8, string);
							ShopInfo[sid][Shopmoney]+=ShopInfo[sid][SItemsell][i];
							return 1;
					    }
					    else
					    {
					        if(ShopInfo[sid][Shopmoney]<ShopInfo[sid][SItembuy][i])
					        {
					        	SendClientMessage(playerid, 0xFFFFFFC8, "地摊贩： 这个摊位没钱收购东西了");
					        	return 0;
					        }
							ShopAddItem(sid,buycheck[playerid],1);//玩家物品-1
							RemoveItem(playerid,buycheck[playerid],1);//摊子东西+1
							new string[256];
							format(string, sizeof(string), "{8000FF}你卖给[%s]摊位[%s] 一个", ShopInfo[sid][Shopname],GetItemname(buycheck[playerid]));
							SendClientMessage(playerid, 0xFFFFFFC8, string);
							ShopInfo[sid][Shopmoney]-=ShopInfo[sid][SItembuy][i];
							return 1;
					    }
					}
				}
		    }
		}
	}
	if(dialogid == Shop_edit)
	{
 		if(!response) return 1;
		if(listitem == 0)
		{
			new id=0;
			new string[256];
			new Smg[128];
			format(Smg, sizeof(Smg), "物品ID\t物品名称\t物品数量\n");
			strcat(string, Smg);
			new itemname[128];
	  		for(new a = 0;a<MAX_Item;a++)
	  		{
	    		if(PBagInfo[playerid][BItem][a]>0)
	    		{
	    		    format(itemname,sizeof(itemname),"%s",GetItemname(PBagInfo[playerid][BItem][a]));
					format(Smg, sizeof(Smg), "　%d\t%s\t%d\n",PBagInfo[playerid][BItem][a],itemname,PBagInfo[playerid][BItems][a]);
					strcat(string, Smg);
					bagtoshop[playerid][id]=PBagInfo[playerid][BItem][a];
					id++;
				}
	  		}
			ShowPlayerDialog(playerid, Shop_edit+1,DIALOG_STYLE_TABLIST_HEADERS, "将物品放入摊位出售", string, "出售","取消");
		}
		if(listitem == 1)
		{
			new id=0;
			new string[256];
			new Smg[128];
			format(Smg, sizeof(Smg), "物品ID\t物品名称\t物品数量\n");
			strcat(string, Smg);
			new itemname[128];
	  		for(new a = 0;a<MAX_Item;a++)
	  		{
	    		if(PBagInfo[playerid][BItem][a]>0)
	    		{
	    		    format(itemname,sizeof(itemname),"%s",GetItemname(PBagInfo[playerid][BItem][a]));
					format(Smg, sizeof(Smg), "　%d\t%s\t%d\n",PBagInfo[playerid][BItem][a],itemname,PBagInfo[playerid][BItems][a]);
					strcat(string, Smg);
					bagtoshop[playerid][id]=PBagInfo[playerid][BItem][a];
					id++;
				}
	  		}
			ShowPlayerDialog(playerid, Shop_edit+2, DIALOG_STYLE_TABLIST_HEADERS, "将物品放入摊位收购", string, "收购","取消");
		}
		if(listitem == 2)
		{
			new id=0;
			new string[256];
			new Smg[128];
   			format(Smg, sizeof(Smg), "{0080FF}物品ID\t物品名称\t数量\t状态|价格\n");
			strcat(string, Smg);
			new itemname[128];
			for(new s = 1;s<MAX_Shop;s++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1, ShopInfo[s][ShopX],ShopInfo[s][ShopY],ShopInfo[s][ShopZ]))
				{
					for(new a = 0;a<MAX_Item;a++)
					{
						if(ShopInfo[s][SItem][a]>0)
						{
							new sellbuy[128];
							if(ShopInfo[s][SItemsell][a]>0){ sellbuy="{00FF40}出售{FF0000}";}
							else if(ShopInfo[s][SItembuy][a]>0){ sellbuy="{FF0000}收购{FF0000}";}
						    new money;
						    if(ShopInfo[s][SItemsell][a]>0){ money=ShopInfo[s][SItemsell][a]; }
						    else if(ShopInfo[s][SItembuy][a]>0){ money=ShopInfo[s][SItembuy][a]; }
				  			format(itemname,sizeof(itemname),"%s",GetItemname(ShopInfo[s][SItem][a]));
							format(Smg, sizeof(Smg), "{FFFF80}　%d\t%s\t%d\t%s|%d\n",ShopInfo[s][SItem][a],itemname,ShopInfo[s][SItems][a],sellbuy,money);
							strcat(string, Smg);
							shoptobag[playerid][id]=ShopInfo[s][SItem][a];
							id++;
						}
					}
					ShowPlayerDialog(playerid, Shop_edit+3,DIALOG_STYLE_TABLIST_HEADERS, "从摊位下架物品", string, "下架","取消");
				}
			}
		}
		if(listitem == 3)
		{
            new sid=shopdid[playerid];
            new money=ShopInfo[sid][Shopmoney];
            ShopInfo[sid][Shopmoney]=0;
            GivePlayerMoney(playerid,money);
            SendClientMessage(playerid, 0xFFFFFFC8, "[摊位]从摊位中取走了所有钱");
		}
		if(listitem == 4)
		{
            new sid=shopdid[playerid];
            ShopInfo[sid][Shopmoney]+=10000;
			SendClientMessage(playerid, 0xFFFFFFC8, "[摊位]我存了10000元进入摊位用于收购");
		}
	}
	if(dialogid == Shop_edit+1)
	{
 		if(!response) return 1;
        new iid,sid;//临时变量
        iid=bagtoshop[playerid][listitem];
        sid=shopdid[playerid];
        new bagmany;//玩家所拥有的物品数量
		for(new a = 0;a<MAX_Item;a++)
		{
			if(PBagInfo[playerid][BItem][a]==iid)
			{
   				bagmany=PBagInfo[playerid][BItems][a];
				ShopAddItem(sid,iid,bagmany);//摊位物品+
				RemoveItem(playerid,iid,bagmany);//玩家物品—
				ShopInfo[sid][SItemsell][a]=100;//出售的价格
				a=99999;
			}
		}
	}
	if(dialogid == Shop_edit+2)
	{
 		if(!response) return 1;
        new iid,sid;//临时变量
        iid=bagtoshop[playerid][listitem];
        sid=shopdid[playerid];
 		for(new a = 0;a<MAX_Item;a++)
 		{
 			if(PBagInfo[playerid][BItem][a]==iid)
			{
				ShopAddItem(sid,iid,1);//玩家物品+
				RemoveItem(playerid,iid,1);//摊子东西+1
				ShopInfo[sid][SItembuy][a]=100;//收购的价格
				a=99999;
			}
		}
	}
	if(dialogid == Shop_edit+3)
	{
 		if(!response) return 1;
        new iid,sid;//临时变量
        iid=shoptobag[playerid][listitem];
        sid=shopdid[playerid];
        new bagmany;//玩家/摊位 所拥有的物品数量
 		for(new a = 0;a<MAX_Item;a++)
 		{
			if(ShopInfo[sid][SItem][a]==iid)
			{
   				bagmany=ShopInfo[sid][SItems][a];
				AddItem(playerid,iid,bagmany);//玩家物品+
				ShopRemoveItem(sid,iid,bagmany);//摊位物品减
				ShopInfo[sid][SItembuy][a]=0;
				ShopInfo[sid][SItemsell][a]=0;
				a=99999;
			}
		}
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)//按键
{
    if((newkeys == KEY_CROUCH))
    {
    	for(new idx = 1; idx < MAX_Shop; idx++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5, ShopInfo[idx][ShopX],ShopInfo[idx][ShopY],ShopInfo[idx][ShopZ]))
			{
            	if(strcmp(GetName(playerid),ShopInfo[idx][Shopown])==0)//如果你是摊位主人 那就直接进入管理界面
            	{
            	    new string[256];
            	    format(string, sizeof(string), "放入商品[出售]\n放入商品[收购]\n商品下架\n取出金钱[%d]\n存入金钱",ShopInfo[idx][Shopmoney]);
            		ShowPlayerDialog(playerid, Shop_edit, DIALOG_STYLE_LIST, "摊位管理", string, "选择","取消");
            		shopdid[playerid]=idx;
            	}
            	else
            	{
					OpenShop(playerid);
					idx=9999;
				}
			}
		}
    }
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
}
////////////////////////////////
forward CreateShop(ID);
public CreateShop(ID)
{
    ShopInfo[ID][ShopOBJ] = CreateObject(1570,ShopInfo[ID][ShopX]+0.5,ShopInfo[ID][ShopY],ShopInfo[ID][ShopZ], 0,0,0);
    new PropertyString[256];
    format(PropertyString,sizeof(PropertyString),"{FF8000}[%s小摊位]\n{00FF80}摊位ID:%d\n摊位主人:%s\n按[C]键查看摊位",ShopInfo[ID][Shopname],ID,ShopInfo[ID][Shopown]);
	ShopLabel[ID] = Create3DTextLabel(PropertyString ,0x006600FF,ShopInfo[ID][ShopX],ShopInfo[ID][ShopY],ShopInfo[ID][ShopZ],15, 0, 1);
	return 1;
}
forward OpenShop(playerid);
public OpenShop(playerid)
{
	new id=0;
	new string[256];
	new Smg[128];
	format(Smg, sizeof(Smg), "{0080FF}物品ID\t物品名称\t数量\t状态|价格\t\n");
	strcat(string, Smg);
	new itemname[128];
	for(new s = 1;s<MAX_Shop;s++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, ShopInfo[s][ShopX],ShopInfo[s][ShopY],ShopInfo[s][ShopZ]))
		{
			for(new a = 0;a<MAX_Item;a++)
			{
				if(ShopInfo[s][SItem][a]>0)
				{
					new sellbuy[128];
					if(ShopInfo[s][SItemsell][a]>0){ sellbuy="{00FF40}出售{FF0000}";}
					else if(ShopInfo[s][SItembuy][a]>0){ sellbuy="{FF0000}收购{FF0000}";}
					new money;
					if(ShopInfo[s][SItemsell][a]>0){ money=ShopInfo[s][SItemsell][a]; }
					else if(ShopInfo[s][SItembuy][a]>0){ money=ShopInfo[s][SItembuy][a]; }
					format(itemname,sizeof(itemname),"%s",GetItemname(ShopInfo[s][SItem][a]));
					format(Smg, sizeof(Smg), "{FFFF80}　%d\t%s\t%d\t%s|%d\n",ShopInfo[s][SItem][a],itemname,ShopInfo[s][SItems][a],sellbuy,money);
					strcat(string, Smg);
					buyxuanze[playerid][id]=ShopInfo[s][SItem][a];
					buycheckid[playerid]=s;
					id++;
				}
			}
			ShowPlayerDialog(playerid, Shop_info, DIALOG_STYLE_TABLIST_HEADERS, "摊位", string, "选择","取消");
		}
	}
	return 1;
}
stock GetName(playerid)//获取玩家名字
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
stock GetItemname(id)//获取物品名称 也就是说在这加入你服务器的新物品
// id是物品id  要想加入新的 那就在 retrun nm上面加入
// 例子:物品id x        else if(id == x){format(nm,sizeof(nm), "你想要的名称 ");}
//当然玩家的PBagInfo[playerid][BItem] 的数据就是对应这的ID
//要是玩家数据PBagInfo[playerid][BItem]=0 那服务器自然断定为他这一栏没物品
//最上面的 MAX_Item就是代表这里物品ID的上限 玩家可以自己修改
{
	new nm[128];
	if(id == 1){format(nm,sizeof(nm), "　大粪　");}
	else if(id == 2){format(nm,sizeof(nm), "　护甲　");}
	else if(id == 3){format(nm,sizeof(nm), "营业执照");}
	return nm;
}
/////////////////////////背包w
stock RemoveItem(playerid,itemid,number)//扣物品数量  玩家id,物品id,数量
{
    for(new i = 0;i<MAX_Item;i++)
    {
		if(PBagInfo[playerid][BItem][i]==itemid)
		{
		    PBagInfo[playerid][BItems][i] -=number;
		    if(PBagInfo[playerid][BItems][i]<1)//如果玩家物品某一栏数量小于1
		    {
		        PBagInfo[playerid][BItem][i]=0;//则设置玩家物品某一栏为0 也就是玩家没了这个物品
		    }
		    break;
	    }
    }
    return 1;
}
stock AddItem(playerid,itemid,number)//增加物品数量   玩家id,物品id,数量
{
    for(new i = 0;i<MAX_Item;i++)
    {
	    if(PBagInfo[playerid][BItem][i]==itemid)
	    {
      		PBagInfo[playerid][BItems][i] +=number;
		    break;
     	}
   		else if(PBagInfo[playerid][BItem][i]==0)//如果玩家物品某一栏物品为0
   		{
	    	PBagInfo[playerid][BItem][i]=itemid;//设置玩家物品某一栏为物品id
	    	PBagInfo[playerid][BItems][i] +=number;
	    	break;
	    }
    }
    return 1;
}
/////////////////////////摊位w
stock ShopRemoveItem(id,itemid,number)//扣物品数量  玩家id,物品id,数量
{
    for(new i = 0;i<MAX_Item;i++)
    {
		if(ShopInfo[id][SItem][i]==itemid)
		{
		    ShopInfo[id][SItems][i] -=number;
		    if(ShopInfo[id][SItems][i]<1)//如果玩家物品某一栏数量小于1
		    {
		        ShopInfo[id][SItem][i]=0;//则设置玩家物品某一栏为0 也就是玩家没了这个物品
		    }
		    break;
     	}
    }
    return 1;
}
stock ShopAddItem(id,itemid,number)//增加物品数量   玩家id,物品id,数量
{
    for(new i = 0;i<MAX_Item;i++)
    {
	    if(ShopInfo[id][SItem][i]==itemid)
	    {
      		ShopInfo[id][SItems][i] +=number;
		    break;
	    }
	    else if(ShopInfo[id][SItem][i]==0)//如果商店物品某一栏物品为0
   		{
	    	ShopInfo[id][SItem][i]=itemid;//设置玩家商店某一栏为物品id
	    	ShopInfo[id][SItems][i] +=number;
	    	break;
   		}
    }
    return 1;
}
stock GetShopID()
{
	for(new i=1;i<MAX_Shop;i++)
	{
	    if(ShopInfo[i][Shopid]==0)
	    {
			return i;
		}
	}
	return -1;
}
