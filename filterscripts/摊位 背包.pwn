//////////////////////////////////////////////////////////////
// ���������Ʒ  www.kuxuansj.com
//����:����      ��Ʒ:����+��̯   ����QQ��805750306  ��ʲô��������
//���������Ʒ ��һЩ���õĹ���  ������Լ�˽���̵�
// ��Ȩ�������������     by:2015.7.29
//////////////////////////////////////////////////////////////
#include <a_samp>
#include <Dini>
#include <streamer>

#define MAX_Item 30//�����Ʒ����
#define MAX_Shop 30//�̵�����

#define bag_info 50//���� dialogID
#define Shop_info 30//��Dialog ID

#define Shop_edit 80//��Dialog ID

enum baginfo
{
	BItem[MAX_Item],//��ƷID
	BItems[MAX_Item],//��Ʒ����
};
new PBagInfo[MAX_PLAYERS][baginfo];//��������]
////////////////
new bagxuanze[MAX_PLAYERS][MAX_Item];//ѡ��Ҫ���������
new bagcheck[MAX_PLAYERS];//�����鿴
/////////////////////////////////////////////////////////////////
new buyxuanze[MAX_PLAYERS][MAX_Item];//����ѡ��
new buycheck[MAX_PLAYERS];//���������� (��ʵ���Ǹ���ʱ��¼)
new buycheckid[MAX_PLAYERS];//�����̯λID

new bagtoshop[MAX_PLAYERS][MAX_Item];//������Ķ����ŵ�̯λ��
new shoptobag[MAX_PLAYERS][MAX_Item];//̯λ��Ķ����ŵ�������
new shopdid[MAX_PLAYERS];//������ڵ�̯λID
enum shinfo
{
	Shopid,//�̵�ID
	ShopOBJ,//�̵�OBJID
	Shopname[256],//�̵�����
	Shopown[256],//�̵�����
	Shopmoney,//�̵��ʽ�
    Float:ShopX,//̯λ����X
    Float:ShopY,//̯λ����Y
    Float:ShopZ,//̯λ����Z
	//////////////
	SItem[MAX_Item],//�̵� ��Ʒid
	SItems[MAX_Item],//�̵� ��Ʒ����
	SItemsell[MAX_Item],//�̵� ���ۼ۸�
	SItembuy[MAX_Item],//�̵� �չ��۸�
};
new ShopInfo[MAX_Shop][shinfo];//�̵����]
new	ShopLabel[MAX_Shop];//�̵�����
	
public OnGameModeInit()
{
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	LoadShop();
	print("\n--------------------------------------");
	print("       ����ϵͳ          ������ң���������");
	print("                     ��������                ");
	print("               				            by������ ");
	print("--------------------------------------\n");
	return 1;
}
/////////////////////////////-��������/��ȡ-//////////////////////////
forward SavePBag(playerid);
public SavePBag(playerid)
{
	new string[256];
	format(string, sizeof(string),"����/%s.ini",GetName(playerid));
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
 	format(file, sizeof(file),"����/%s.ini", GetName(playerid));
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
/////////////////////////////-�̵걣��/��ȡ-//////////////////////////
forward SaveShop(idx);
public SaveShop(idx)
{
	new string[256];
	format(string, sizeof(string),"�̵�/%d.ini",idx);
	if(!dini_Exists(string))
	{
		dini_Create(string);
	}
	dini_IntSet(string,"ID",ShopInfo[idx][Shopid]);
	dini_Set(string,"Name",ShopInfo[idx][Shopown]);//����
	dini_Set(string,"Shopname",ShopInfo[idx][Shopname]);//����
	dini_IntSet(string,"money",ShopInfo[idx][Shopmoney]);//����
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
	 	format(file, sizeof(file),"�̵�/%d.ini",idx);
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
public OnPlayerConnect(playerid)//�������
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
		format(Smg, sizeof(Smg), "��ƷID\t��Ʒ����\t��Ʒ����\n");
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
		ShowPlayerDialog(playerid, bag_info, DIALOG_STYLE_TABLIST_HEADERS, "�ҵı���", string, "ѡ��","ȡ��");
		return 1;
	}
	if(strcmp("/add1", cmdtext, true, 10) == 0)//��ʱ�����Ʒָ�����
	{
		SendClientMessage(playerid, 0xFFFFFFC8, "����Լ������10����");
		AddItem(playerid,1,10);//���������� 10����ƷID1 Ҳ����ʺ
		return 1;
	}
	if(strcmp("/add2", cmdtext, true, 10) == 0)//��ʱ�����Ʒָ�����
	{
		SendClientMessage(playerid, 0xFFFFFFC8, "����Լ������10��Ѫ��");
		AddItem(playerid,2,10);//���������� 10����ƷID1 Ҳ����ʺ
		GivePlayerMoney(playerid,100000);
		return 1;
	}
	if(strcmp("/add3", cmdtext, true, 10) == 0)//��ʱ�����Ʒָ�����
	{
		SendClientMessage(playerid, 0xFFFFFFC8, "����Լ������10����");
		AddItem(playerid,3,10);//���������� 10����ƷID1 Ҳ����ʺ
		return 1;
	}
	if(strcmp("/add4", cmdtext, true, 10) == 0)//��ʱ�����Ʒָ�����
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
 		ShowPlayerDialog(playerid, bag_info+1, DIALOG_STYLE_LIST, "��Ʒ����", "{FF8000}ʹ����Ʒ\n������Ʒ(������)", "ѡ��", "ȡ��");
	}
		//
	if(dialogid == bag_info+1)
	{
 		if(!response) return 1;
		if(listitem == 0)
		{
		    if(bagcheck[playerid]==1)//Ҫ����ƷID��1 ����ô��ô��
		    {
				new string[256];
				format(string, sizeof(string), "{8000FF}��ʹ������Ʒ:%s ����:1��",GetItemname(bagcheck[playerid]));
				SendClientMessage(playerid, 0xFFFFFFC8, string);
				SendClientMessage(playerid, 0xFFFFFFC8, "��ʺ����:�Ҳ� ζ��������!��Ҫ��ҪҲ����");
				RemoveItem(playerid,bagcheck[playerid],1);//ע�� ��1 ��д��-1 ��Ϊ������ǿ۳���Ʒ
				return 1;
			}
			else if(bagcheck[playerid]==2)//Ҫ����ƷID��2 ����ô��ô��
			{
				new string[256];
				format(string, sizeof(string), "{8000FF}��ʹ������Ʒ:%s ����:1��",GetItemname(bagcheck[playerid]));
				SendClientMessage(playerid, 0xFFFFFFC8, string);
				SendClientMessage(playerid, 0xFFFFFFC8, "������׻����� ���� ���ӵ���");
				RemoveItem(playerid,bagcheck[playerid],1);//ע�� ��1 ��д��-1 ��Ϊ������ǿ۳���Ʒ
				SetPlayerArmour(playerid, 100);//��������û���100
				return 1;
			}
			else if(bagcheck[playerid]==3)//Ҫ����ƷID��3 ����ô��ô��
			{
				new string[256];
				format(string, sizeof(string), "{8000FF}��ʹ������Ʒ:%s ����:1��",GetItemname(bagcheck[playerid]));
				SendClientMessage(playerid, 0xFFFFFFC8, string);
				SendClientMessage(playerid, 0xFFFFFFC8, "�ǹܣ� ������֤���ҿ�����");
				SendClientMessage(playerid, 0xFFFFFFC8, "�ǹܣ� С�Ӽǵ�ÿ�콻�����ѣ����ǻ����ר�ŵı�����");
				RemoveItem(playerid,bagcheck[playerid],1);//ע�� ��1 ��д��-1 ��Ϊ������ǿ۳���Ʒ
				/////////////////
				new Float:x, Float:y, Float:z;
				new newshop = GetShopID();
				new sendername[MAX_PLAYER_NAME];
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(newshop == -1)
				{
					SendClientMessage(playerid, 0xFFFFFFC8, "�ǹ�: �������̯�ˣ�̯λ�����ˡ�");
					return 0;
                }
				GetPlayerPos(playerid,x,y,z);
				ShopInfo[newshop][Shopid] = newshop;
				ShopInfo[newshop][ShopX] = x;
				ShopInfo[newshop][ShopY] = y;
				ShopInfo[newshop][ShopZ] = z;
				strmid(ShopInfo[newshop][Shopown], sendername, 0, strlen(sendername), 255);
				strmid(ShopInfo[newshop][Shopname], "���޸�һ����", 0, strlen("���޸�һ����"), 255);
				SaveShop(newshop);
				CreateShop(newshop);
				return 1;
			}
		}
		if(listitem == 1)
		{
			new string[256];
			format(string, sizeof(string), "{8000FF}�㶪������Ʒ:%s ����:1��", GetItemname(bagcheck[playerid]));
			SendClientMessage(playerid, 0xFFFFFFC8, string);
			RemoveItem(playerid,bagcheck[playerid],1);//ע�� ��1 ��д��-1 ��Ϊ������ǿ۳���Ʒ
			return 1;
		}
	}
////////////////////////////////////////////////////////////////////////////////////////
	if(dialogid == Shop_info)
	{
		if(!response) return 1;
  		buycheck[playerid] =buyxuanze[playerid][listitem];
 		ShowPlayerDialog(playerid, Shop_info+1, DIALOG_STYLE_LIST, "��̯", "{FF8000}������Ʒ(��������)", "ѡ��", "ȡ��");
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
					    if(ShopInfo[sid][SItemsell][i]>0)//���ۼ�Ǯ����0 �Ǿ�˵�����ǳ���״̬
					    {
					        if(GetPlayerMoney(playerid)<ShopInfo[sid][SItemsell][i])
					        {
					        	SendClientMessage(playerid, 0xFFFFFFC8, "��̯����ûǮ��������");
					        	return 0;
					        }
							AddItem(playerid,buycheck[playerid],1);//�����Ʒ+1
							ShopRemoveItem(sid,buycheck[playerid],1);//̯�Ӷ���-1
							new string[256];
							format(string, sizeof(string), "{8000FF}���[%s]̯λ������[%s]*1", ShopInfo[sid][Shopname],GetItemname(buycheck[playerid]));
							SendClientMessage(playerid, 0xFFFFFFC8, string);
							ShopInfo[sid][Shopmoney]+=ShopInfo[sid][SItemsell][i];
							return 1;
					    }
					    else
					    {
					        if(ShopInfo[sid][Shopmoney]<ShopInfo[sid][SItembuy][i])
					        {
					        	SendClientMessage(playerid, 0xFFFFFFC8, "��̯���� ���̯λûǮ�չ�������");
					        	return 0;
					        }
							ShopAddItem(sid,buycheck[playerid],1);//�����Ʒ-1
							RemoveItem(playerid,buycheck[playerid],1);//̯�Ӷ���+1
							new string[256];
							format(string, sizeof(string), "{8000FF}������[%s]̯λ[%s] һ��", ShopInfo[sid][Shopname],GetItemname(buycheck[playerid]));
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
			format(Smg, sizeof(Smg), "��ƷID\t��Ʒ����\t��Ʒ����\n");
			strcat(string, Smg);
			new itemname[128];
	  		for(new a = 0;a<MAX_Item;a++)
	  		{
	    		if(PBagInfo[playerid][BItem][a]>0)
	    		{
	    		    format(itemname,sizeof(itemname),"%s",GetItemname(PBagInfo[playerid][BItem][a]));
					format(Smg, sizeof(Smg), "��%d\t%s\t%d\n",PBagInfo[playerid][BItem][a],itemname,PBagInfo[playerid][BItems][a]);
					strcat(string, Smg);
					bagtoshop[playerid][id]=PBagInfo[playerid][BItem][a];
					id++;
				}
	  		}
			ShowPlayerDialog(playerid, Shop_edit+1,DIALOG_STYLE_TABLIST_HEADERS, "����Ʒ����̯λ����", string, "����","ȡ��");
		}
		if(listitem == 1)
		{
			new id=0;
			new string[256];
			new Smg[128];
			format(Smg, sizeof(Smg), "��ƷID\t��Ʒ����\t��Ʒ����\n");
			strcat(string, Smg);
			new itemname[128];
	  		for(new a = 0;a<MAX_Item;a++)
	  		{
	    		if(PBagInfo[playerid][BItem][a]>0)
	    		{
	    		    format(itemname,sizeof(itemname),"%s",GetItemname(PBagInfo[playerid][BItem][a]));
					format(Smg, sizeof(Smg), "��%d\t%s\t%d\n",PBagInfo[playerid][BItem][a],itemname,PBagInfo[playerid][BItems][a]);
					strcat(string, Smg);
					bagtoshop[playerid][id]=PBagInfo[playerid][BItem][a];
					id++;
				}
	  		}
			ShowPlayerDialog(playerid, Shop_edit+2, DIALOG_STYLE_TABLIST_HEADERS, "����Ʒ����̯λ�չ�", string, "�չ�","ȡ��");
		}
		if(listitem == 2)
		{
			new id=0;
			new string[256];
			new Smg[128];
   			format(Smg, sizeof(Smg), "{0080FF}��ƷID\t��Ʒ����\t����\t״̬|�۸�\n");
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
							if(ShopInfo[s][SItemsell][a]>0){ sellbuy="{00FF40}����{FF0000}";}
							else if(ShopInfo[s][SItembuy][a]>0){ sellbuy="{FF0000}�չ�{FF0000}";}
						    new money;
						    if(ShopInfo[s][SItemsell][a]>0){ money=ShopInfo[s][SItemsell][a]; }
						    else if(ShopInfo[s][SItembuy][a]>0){ money=ShopInfo[s][SItembuy][a]; }
				  			format(itemname,sizeof(itemname),"%s",GetItemname(ShopInfo[s][SItem][a]));
							format(Smg, sizeof(Smg), "{FFFF80}��%d\t%s\t%d\t%s|%d\n",ShopInfo[s][SItem][a],itemname,ShopInfo[s][SItems][a],sellbuy,money);
							strcat(string, Smg);
							shoptobag[playerid][id]=ShopInfo[s][SItem][a];
							id++;
						}
					}
					ShowPlayerDialog(playerid, Shop_edit+3,DIALOG_STYLE_TABLIST_HEADERS, "��̯λ�¼���Ʒ", string, "�¼�","ȡ��");
				}
			}
		}
		if(listitem == 3)
		{
            new sid=shopdid[playerid];
            new money=ShopInfo[sid][Shopmoney];
            ShopInfo[sid][Shopmoney]=0;
            GivePlayerMoney(playerid,money);
            SendClientMessage(playerid, 0xFFFFFFC8, "[̯λ]��̯λ��ȡ��������Ǯ");
		}
		if(listitem == 4)
		{
            new sid=shopdid[playerid];
            ShopInfo[sid][Shopmoney]+=10000;
			SendClientMessage(playerid, 0xFFFFFFC8, "[̯λ]�Ҵ���10000Ԫ����̯λ�����չ�");
		}
	}
	if(dialogid == Shop_edit+1)
	{
 		if(!response) return 1;
        new iid,sid;//��ʱ����
        iid=bagtoshop[playerid][listitem];
        sid=shopdid[playerid];
        new bagmany;//�����ӵ�е���Ʒ����
		for(new a = 0;a<MAX_Item;a++)
		{
			if(PBagInfo[playerid][BItem][a]==iid)
			{
   				bagmany=PBagInfo[playerid][BItems][a];
				ShopAddItem(sid,iid,bagmany);//̯λ��Ʒ+
				RemoveItem(playerid,iid,bagmany);//�����Ʒ��
				ShopInfo[sid][SItemsell][a]=100;//���۵ļ۸�
				a=99999;
			}
		}
	}
	if(dialogid == Shop_edit+2)
	{
 		if(!response) return 1;
        new iid,sid;//��ʱ����
        iid=bagtoshop[playerid][listitem];
        sid=shopdid[playerid];
 		for(new a = 0;a<MAX_Item;a++)
 		{
 			if(PBagInfo[playerid][BItem][a]==iid)
			{
				ShopAddItem(sid,iid,1);//�����Ʒ+
				RemoveItem(playerid,iid,1);//̯�Ӷ���+1
				ShopInfo[sid][SItembuy][a]=100;//�չ��ļ۸�
				a=99999;
			}
		}
	}
	if(dialogid == Shop_edit+3)
	{
 		if(!response) return 1;
        new iid,sid;//��ʱ����
        iid=shoptobag[playerid][listitem];
        sid=shopdid[playerid];
        new bagmany;//���/̯λ ��ӵ�е���Ʒ����
 		for(new a = 0;a<MAX_Item;a++)
 		{
			if(ShopInfo[sid][SItem][a]==iid)
			{
   				bagmany=ShopInfo[sid][SItems][a];
				AddItem(playerid,iid,bagmany);//�����Ʒ+
				ShopRemoveItem(sid,iid,bagmany);//̯λ��Ʒ��
				ShopInfo[sid][SItembuy][a]=0;
				ShopInfo[sid][SItemsell][a]=0;
				a=99999;
			}
		}
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)//����
{
    if((newkeys == KEY_CROUCH))
    {
    	for(new idx = 1; idx < MAX_Shop; idx++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5, ShopInfo[idx][ShopX],ShopInfo[idx][ShopY],ShopInfo[idx][ShopZ]))
			{
            	if(strcmp(GetName(playerid),ShopInfo[idx][Shopown])==0)//�������̯λ���� �Ǿ�ֱ�ӽ���������
            	{
            	    new string[256];
            	    format(string, sizeof(string), "������Ʒ[����]\n������Ʒ[�չ�]\n��Ʒ�¼�\nȡ����Ǯ[%d]\n�����Ǯ",ShopInfo[idx][Shopmoney]);
            		ShowPlayerDialog(playerid, Shop_edit, DIALOG_STYLE_LIST, "̯λ����", string, "ѡ��","ȡ��");
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
    format(PropertyString,sizeof(PropertyString),"{FF8000}[%sС̯λ]\n{00FF80}̯λID:%d\n̯λ����:%s\n��[C]���鿴̯λ",ShopInfo[ID][Shopname],ID,ShopInfo[ID][Shopown]);
	ShopLabel[ID] = Create3DTextLabel(PropertyString ,0x006600FF,ShopInfo[ID][ShopX],ShopInfo[ID][ShopY],ShopInfo[ID][ShopZ],15, 0, 1);
	return 1;
}
forward OpenShop(playerid);
public OpenShop(playerid)
{
	new id=0;
	new string[256];
	new Smg[128];
	format(Smg, sizeof(Smg), "{0080FF}��ƷID\t��Ʒ����\t����\t״̬|�۸�\t\n");
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
					if(ShopInfo[s][SItemsell][a]>0){ sellbuy="{00FF40}����{FF0000}";}
					else if(ShopInfo[s][SItembuy][a]>0){ sellbuy="{FF0000}�չ�{FF0000}";}
					new money;
					if(ShopInfo[s][SItemsell][a]>0){ money=ShopInfo[s][SItemsell][a]; }
					else if(ShopInfo[s][SItembuy][a]>0){ money=ShopInfo[s][SItembuy][a]; }
					format(itemname,sizeof(itemname),"%s",GetItemname(ShopInfo[s][SItem][a]));
					format(Smg, sizeof(Smg), "{FFFF80}��%d\t%s\t%d\t%s|%d\n",ShopInfo[s][SItem][a],itemname,ShopInfo[s][SItems][a],sellbuy,money);
					strcat(string, Smg);
					buyxuanze[playerid][id]=ShopInfo[s][SItem][a];
					buycheckid[playerid]=s;
					id++;
				}
			}
			ShowPlayerDialog(playerid, Shop_info, DIALOG_STYLE_TABLIST_HEADERS, "̯λ", string, "ѡ��","ȡ��");
		}
	}
	return 1;
}
stock GetName(playerid)//��ȡ�������
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
stock GetItemname(id)//��ȡ��Ʒ���� Ҳ����˵��������������������Ʒ
// id����Ʒid  Ҫ������µ� �Ǿ��� retrun nm�������
// ����:��Ʒid x        else if(id == x){format(nm,sizeof(nm), "����Ҫ������ ");}
//��Ȼ��ҵ�PBagInfo[playerid][BItem] �����ݾ��Ƕ�Ӧ���ID
//Ҫ���������PBagInfo[playerid][BItem]=0 �Ƿ�������Ȼ�϶�Ϊ����һ��û��Ʒ
//������� MAX_Item���Ǵ���������ƷID������ ��ҿ����Լ��޸�
{
	new nm[128];
	if(id == 1){format(nm,sizeof(nm), "����ࡡ");}
	else if(id == 2){format(nm,sizeof(nm), "�����ס�");}
	else if(id == 3){format(nm,sizeof(nm), "Ӫҵִ��");}
	return nm;
}
/////////////////////////����w
stock RemoveItem(playerid,itemid,number)//����Ʒ����  ���id,��Ʒid,����
{
    for(new i = 0;i<MAX_Item;i++)
    {
		if(PBagInfo[playerid][BItem][i]==itemid)
		{
		    PBagInfo[playerid][BItems][i] -=number;
		    if(PBagInfo[playerid][BItems][i]<1)//��������Ʒĳһ������С��1
		    {
		        PBagInfo[playerid][BItem][i]=0;//�����������Ʒĳһ��Ϊ0 Ҳ�������û�������Ʒ
		    }
		    break;
	    }
    }
    return 1;
}
stock AddItem(playerid,itemid,number)//������Ʒ����   ���id,��Ʒid,����
{
    for(new i = 0;i<MAX_Item;i++)
    {
	    if(PBagInfo[playerid][BItem][i]==itemid)
	    {
      		PBagInfo[playerid][BItems][i] +=number;
		    break;
     	}
   		else if(PBagInfo[playerid][BItem][i]==0)//��������Ʒĳһ����ƷΪ0
   		{
	    	PBagInfo[playerid][BItem][i]=itemid;//���������Ʒĳһ��Ϊ��Ʒid
	    	PBagInfo[playerid][BItems][i] +=number;
	    	break;
	    }
    }
    return 1;
}
/////////////////////////̯λw
stock ShopRemoveItem(id,itemid,number)//����Ʒ����  ���id,��Ʒid,����
{
    for(new i = 0;i<MAX_Item;i++)
    {
		if(ShopInfo[id][SItem][i]==itemid)
		{
		    ShopInfo[id][SItems][i] -=number;
		    if(ShopInfo[id][SItems][i]<1)//��������Ʒĳһ������С��1
		    {
		        ShopInfo[id][SItem][i]=0;//�����������Ʒĳһ��Ϊ0 Ҳ�������û�������Ʒ
		    }
		    break;
     	}
    }
    return 1;
}
stock ShopAddItem(id,itemid,number)//������Ʒ����   ���id,��Ʒid,����
{
    for(new i = 0;i<MAX_Item;i++)
    {
	    if(ShopInfo[id][SItem][i]==itemid)
	    {
      		ShopInfo[id][SItems][i] +=number;
		    break;
	    }
	    else if(ShopInfo[id][SItem][i]==0)//����̵���Ʒĳһ����ƷΪ0
   		{
	    	ShopInfo[id][SItem][i]=itemid;//��������̵�ĳһ��Ϊ��Ʒid
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
