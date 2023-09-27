#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "1.2.0"

bool is_gamemode_rejected;

public Plugin myinfo = {
    name = "L4D2 Realism Only",
    author = "Garamond",
    description = "Reject non realism gamemodes.",
    version = VERSION,
    url = "https://github.com/garamond13/L4D2-Realism-Only"
};

public void OnMapStart()
{
	char buffer[32];
	GetConVarString(FindConVar("mp_gamemode"), buffer, sizeof(buffer));
	if (!strcmp(buffer, "realism"))
		is_gamemode_rejected = false;
	else {
		is_gamemode_rejected = true;
		CreateTimer(1.0, changelevel, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public bool OnClientConnect(int client, char[] rejectmsg, int maxlength)
{
	if (is_gamemode_rejected && !IsFakeClient(client)) {

		//a dot at the end of the message will be auto added
		strcopy(rejectmsg, maxlength, "Server doesn't support this gamemode. Only realism is supported");

		return false;
	}
	return true;
}

Action changelevel(Handle timer)
{
	ServerCommand("sm_cvar mp_gamemode realism; changelevel c1m1_hotel");
	return Plugin_Continue;
}