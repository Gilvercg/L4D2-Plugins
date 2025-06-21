#include <sourcemod>
#include <sdktools>

int g_iPPControl = -1;
int g_iFogVolume = -1;
bool g_bBlurActive = false;

public Plugin myinfo = 
{
    name = "Effect Blur",
    author = "D̷A̷N̷G̷E̷R",
    description = "Te da un efecto borroso para todos",
    version = "3.0",
}

public void OnPluginStart()
{
    RegConsoleCmd("sm_blur", Command_Blur);
}

public Action Command_Blur(int client, int args)
{
    if (g_bBlurActive)
        return Plugin_Handled;

    g_bBlurActive = true;

    float fCenter[3] = {0.0, 0.0, 0.0};

    g_iPPControl = CreateEntityByName("postprocess_controller");
    if (g_iPPControl != -1)
    {
        DispatchKeyValue(g_iPPControl, "targetname", "blur_fx");
        DispatchKeyValue(g_iPPControl, "spawnflags", "1");
        DispatchKeyValue(g_iPPControl, "vignettestart", "1");
        DispatchKeyValue(g_iPPControl, "vignetteend", "4");
        DispatchKeyValue(g_iPPControl, "vignetteblurstrength", "0");
        DispatchKeyValue(g_iPPControl, "topvignettestrength", "1");
        DispatchKeyValue(g_iPPControl, "localcontraststrength", "-1.0");
        DispatchKeyValue(g_iPPControl, "localcontrastedgestrength", "-0.3");
        DispatchKeyValue(g_iPPControl, "grainstrength", "1");
        DispatchKeyValue(g_iPPControl, "fadetime", "3");
        DispatchSpawn(g_iPPControl);
        ActivateEntity(g_iPPControl);
        TeleportEntity(g_iPPControl, fCenter, NULL_VECTOR, NULL_VECTOR);
    }

    g_iFogVolume = CreateEntityByName("fog_volume");
    if (g_iFogVolume != -1)
    {
        DispatchKeyValue(g_iFogVolume, "PostProcessName", "blur_fx");
        DispatchSpawn(g_iFogVolume);
        ActivateEntity(g_iFogVolume);

        // Cubrir todo el mapa con el efecto
        float fFogMins[3] = {-99999.0, -99999.0, -99999.0};
        float fFogMaxs[3] = {99999.0, 99999.0, 99999.0};
        SetEntPropVector(g_iFogVolume, Prop_Send, "m_vecMins", fFogMins);
        SetEntPropVector(g_iFogVolume, Prop_Send, "m_vecMaxs", fFogMaxs);
        TeleportEntity(g_iFogVolume, fCenter, NULL_VECTOR, NULL_VECTOR);
    }

    CreateTimer(30.0, RemoveBlurEffect);
    return Plugin_Handled;
}

public Action RemoveBlurEffect(Handle timer)
{
    if (g_iPPControl != -1 && IsValidEntity(g_iPPControl))
    {
        AcceptEntityInput(g_iPPControl, "Kill");
        g_iPPControl = -1;
    }

    if (g_iFogVolume != -1 && IsValidEntity(g_iFogVolume))
    {
        AcceptEntityInput(g_iFogVolume, "Kill");
        g_iFogVolume = -1;
    }

    g_bBlurActive = false;
    return Plugin_Stop;
}

