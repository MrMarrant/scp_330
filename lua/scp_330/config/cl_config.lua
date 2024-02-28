-- Send to all player that spawn, the value of the addon
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.SCP055_LoadPossessor", function(ply)
    scp_330.SetConvarClientSide("ClientRadiusEffect", SCP_330_CONFIG.RadiusEffect:GetInt(), ply)
end)