#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{
    name = "Detect End Credits",
    author = "D̷A̷N̷G̷E̷R",
    description = "Detects when the credits start at the end of a campaign",
    version = "2.0",
}

public void OnPluginStart()
{
    UserMsg msgStatsCrawl = GetUserMessageId("StatsCrawlMsg");

    if (msgStatsCrawl != INVALID_MESSAGE_ID)
    {
        HookUserMessage(msgStatsCrawl, OnCreditsStart, true);
    }
    else
    {
        PrintToServer("[Creditos] No se pudo encontrar el mensaje 'StatsCrawlMsg'.");
    }
}

public Action OnCreditsStart(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
    CreateTimer(0.1, Timer_CreditsStarted);
    return Plugin_Continue;
}

public Action Timer_CreditsStarted(Handle timer)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && IsClientConnected(i))
        {
            PrintToChat(i, "\x04[Finale] \x01¡The credits have begun!");
        }
    }

    return Plugin_Stop;
}
