-- Remove every params to player
hook.Add( "PlayerDeath", "PlayerDeath.Remove_SCP330", scp_330.RemoveEffect )

hook.Add( "PlayerChangedTeam", "PlayerChangedTeam.Remove_SCP330", scp_330.RemoveEffect )

hook.Add( "PlayerSpawn", "PlayerSpawn.Remove_SCP330", scp_330.RemoveEffect )