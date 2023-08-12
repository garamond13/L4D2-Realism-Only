#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#define VERSION "1.1.2"

//dot at the end of the message will be auto added
#define REJECT_MESSAGE "The server does not support this gamemode. Only realism is supported"

Handle h_mp_gamemode;
bool is_rejected;

public Plugin myinfo = {
    name = "L4D2 Realism Only",
    author = "Garamond",
    description = "Reject non realism gamemodes.",
    version = VERSION,
    url = "https://github.com/garamond13/L4D2-Realism-Only"
};

public void OnPluginStart()
{
	h_mp_gamemode = FindConVar("mp_gamemode");
}

public void OnMapStart()
{
	char mp_gamemode[32];
	GetConVarString(h_mp_gamemode, mp_gamemode, sizeof(mp_gamemode));
	if (!strcmp(mp_gamemode, "realism"))
		is_rejected = false;
	else {
		is_rejected = true;
		CreateTimer(1.0, changelevel);
	}
}

public bool OnClientConnect(int client, char[] rejectmsg, int maxlength)
{
	//reject connections with reject message
	if (is_rejected && !IsFakeClient(client)) {
		strcopy(rejectmsg, maxlength, REJECT_MESSAGE);
		return false;
	}

	return true;
}

Action changelevel(Handle timer)
{
	ServerCommand("sm_cvar mp_gamemode realism;changelevel c1m1_hotel");
	return Plugin_Continue;
}
