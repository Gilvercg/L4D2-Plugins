#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{
    name = "No Credits",
    author = "D̷A̷N̷G̷E̷R",
    description = "removes the end credits",
    version = "1.5",
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if (StrEqual(classname, "env_outtro_stats"))
    {
        PrintToServer("[Finale] env_outtro_stats creado.");

        // Esperamos un pequeño delay por seguridad antes de eliminarlo
        CreateTimer(0.1, Timer_RemoveOuttroStats, EntIndexToEntRef(entity));
    }
}

public Action Timer_RemoveOuttroStats(Handle timer, any ref)
{
    int entity = EntRefToEntIndex(ref);
    if (entity != INVALID_ENT_REFERENCE && IsValidEntity(entity))
    {
        RemoveEdict(entity);
        PrintToServer("[Finale] env_outtro_stats eliminado, pantalla negra y créditos evitados.");
    }
    return Plugin_Stop;
}
