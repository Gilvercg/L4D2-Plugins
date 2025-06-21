#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

#define FFADE_IN 0x0001
#define FFADE_PURGE 0x0010

public Plugin myinfo = 
{
    name = "Flash Effect Command",
    author = "D̷A̷N̷G̷E̷R",
    description = "Aplica un efecto de destello con un comando",
    version = "1.1",
};

public OnPluginStart()
{
    RegConsoleCmd("sm_luz", Cmd_FlashEffect, "Aplica un efecto de flash a todos los jugadores");
}

void PerformFade(int client, int iDuration, int iColor[3], int iAlpha)
{
    int iFullBlindDuration = iDuration / 4;
    Handle hFadeClient = StartMessageOne("Fade", client);
    if (hFadeClient != INVALID_HANDLE)
    {
        BfWriteShort(hFadeClient, iDuration - iFullBlindDuration);
        BfWriteShort(hFadeClient, iFullBlindDuration);
        BfWriteShort(hFadeClient, (FFADE_PURGE | FFADE_IN));
        BfWriteByte(hFadeClient, iColor[0]);
        BfWriteByte(hFadeClient, iColor[1]);
        BfWriteByte(hFadeClient, iColor[2]);
        BfWriteByte(hFadeClient, iAlpha);
        EndMessage();
    }
}

public Action Cmd_FlashEffect(int client, int args)
{
    int iDuration = 5000; // Duración en milisegundos
    int iColor[3] = {255, 255, 255}; 
    int iAlpha = 255; 

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && IsPlayerAlive(i) && (GetClientTeam(i) == 2))
        {
            PerformFade(i, iDuration, iColor, iAlpha);
        }
    }

    return Plugin_Handled;
}

