	/*
    	Copyright (c) 2015,  Funny City
    	FilterScript - Funny Town Register
		Author - Anson         				 */
	
	#include <a_samp>
	
	#define _ANSTI_USER_COMMANDS_
	#define _SIZE_FILE_NUM_ (1000)
	
	#include "AnsTi.inc"

	#define DIALOG_LOGIN     (0)
	#define DIALOG_REGISTER  (1)
	#define DIALOG_MESSAGEOX (2)
	
	#define MIN_PASSWORD  	 (6)

	struct _PlayerInfo{
		bool:Login,
		int:Score,
		int:Money,
		NSVAL PSaverFile,
		Pname[MAX_PLAYER_NAME]
	}register PlayerInfo[MAX_PLAYERS][_PlayerInfo];

	public OnFilterScriptInit(){
		AnsTi_Update();
		AnsTi_SetKeySaver(0, "����");
		AnsTi_SetKeySaver(1, "����");
		AnsTi_SetKeySaver(2, "��Ǯ");
	}
	
	public OnPlayerConnect(playerid){
		AnsTi_SetSeek(playerid);	/*  Change Seek to The Player's id  */
		GetPlayerName(playerid, PlayerInfo[playerid][Pname], MAX_PLAYER_NAME);
		if(AnsTi_Exists(PlayerInfo[playerid][Pname])){
		    PlayerInfo[playerid][PSaverFile] = AnsTi_Open(PlayerInfo[playerid][Pname]);
		    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "LOGIN(��¼)", "��ӭ���������ǣ����¼", "��¼", "");
		}else
		{
			AnsTi_Create(PlayerInfo[playerid][Pname]);
            PlayerInfo[playerid][PSaverFile] = AnsTi_Open(PlayerInfo[playerid][Pname]);
		    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "REGISTER(ע��)", "��ӭ���������ǣ���ע��", "ע��", "");
		}
		return 1;
	}
	
	public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	    if(response){
	        if(!dialogid){
	            if(!strcmp(inputtext, AnsTi_ReadString(PlayerInfo[playerid][PSaverFile], _K("����")), true)){
	                PlayerInfo[playerid][Login] = true;
             		SetPlayerScore(playerid, (PlayerInfo[playerid][Score] = NSVAL AnsTi_ReadInt(PlayerInfo[playerid][PSaverFile], _K("����"))));
					GivePlayerMoney(playerid, (PlayerInfo[playerid][Money] = NSVAL AnsTi_ReadInt(PlayerInfo[playerid][PSaverFile], _K("��Ǯ"))));
				}else Kick(playerid);
		    }else if(dialogid){
	            if(MIN_PASSWORD < strlen(inputtext)){
	                AnsTi_WriteString(PlayerInfo[playerid][PSaverFile], _K("����"), inputtext);
                    PlayerInfo[playerid][Login] = true;
             		SetPlayerScore(playerid, (PlayerInfo[playerid][Score] = NSVAL(0)));
					GivePlayerMoney(playerid, (PlayerInfo[playerid][Money] = NSVAL(0)));
	            }
                else ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "REGISTER(ע��)", "���벻�ܶ���6λ!", "ע��", "");
	        }
	        ShowPlayerDialog(playerid, DIALOG_MESSAGEOX, DIALOG_STYLE_MSGBOX, "�����ɹ�", "��ӭ�ع�", "���", "");
	    }
 		return 1;
	}
	
	public OnPlayerDisconnect(playerid, reason){
	    AnsTi_WriteInt(PlayerInfo[playerid][PSaverFile], PlayerInfo[playerid][Score], _K("����"));
	    AnsTi_WriteInt(PlayerInfo[playerid][PSaverFile], PlayerInfo[playerid][Money], _K("��Ǯ"));
	    AnsTi_Close(PlayerInfo[playerid][PSaverFile]);
	    return 1;
	}

