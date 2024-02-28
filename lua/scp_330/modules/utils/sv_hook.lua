-- Remove every params to player
hook.Add( "PlayerDeath", "PlayerDeath.Remove_SCP330", scp_330.RemoveEffect )

hook.Add( "PlayerChangedTeam", "PlayerChangedTeam.Remove_SCP330", scp_330.RemoveEffect )

hook.Add( "PlayerSpawn", "PlayerSpawn.Remove_SCP330", scp_330.RemoveEffect )

hook.Add( "PlayerCanPickupWeapon", "PlayerCanPickupWeapon.HasHands_SCP_330", function( ply, weapon )
    if (ply.SCP330_HandCut) then return false end
end )