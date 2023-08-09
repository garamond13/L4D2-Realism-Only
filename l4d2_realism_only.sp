#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#define VERSION "1.0.0"

#define REJECT_MESSAGE "The server does not support this gamemode. Only realism is supported"

public Plugin myinfo = {
    name = "L4D2 Realism Only",
    author = "Garamond",
    description = "Reject non realism gamemodes.",
    version = VERSION,
    url = "https://github.com/garamond13/L4D2-Realism-Only"
};

Handle h_mp_gamemode;
bool should_changelevel;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{	
	if(GetEngineVersion() != Engine_Left4Dead2) {
		strcopy(error, err_max, "Plugin only supports Left 4 Dead 2.");
		return APLRes_SilentFailure;
	}
	return APLRes_Success; 
}

public void OnPluginStart()
{
	h_mp_gamemode = FindConVar("mp_gamemode");
}

public void OnMapStart()
{
	char mp_gamemode[32];
	GetConVarString(h_mp_gamemode, mp_gamemode, sizeof(mp_gamemode));
	if (!strcmp(mp_gamemode, "realism"))
		should_changelevel = false;
	else {
		should_changelevel = true;
		CreateTimer(1.0, changelevel);
	}
}

public bool OnClientConnect(int client, char[] rejectmsg, int maxlength)
{
	//reject connections with reject message
	if (should_changelevel && !IsFakeClient(client)) {
		strcopy(rejectmsg, maxlength, REJECT_MESSAGE);
		return false;
	}

	return true;
}

public Action changelevel(Handle timer)
{
	ServerCommand("map c1m1_hotel realism");
	return Plugin_Continue;
}
