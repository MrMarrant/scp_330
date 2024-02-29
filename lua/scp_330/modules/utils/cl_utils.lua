net.Receive(SCP_330_CONFIG.SetConvarClientSide, function ()
    local name = net.ReadString()
    local value = net.ReadUInt(14)
    print(name, value)
    SCP_330_CONFIG[name] = value
end)

net.Receive(SCP_330_CONFIG.SendNotification, function ()
    local message = net.ReadString()
    notification.AddLegacy( message, NOTIFY_GENERIC, 5 )
end)

net.Receive(SCP_330_CONFIG.SetTableEntitie, function ()
    local ent = net.ReadEntity()
    local name = net.ReadString()
    local value = net.ReadString()

    table.insert( ent[name], value )
end)

function scp_330.ProximityEffect(ent)
    local ply = LocalPlayer()
    local maxRange = SCP_330_CONFIG.ClientRadiusEffect

    if (ply:GetPos():Distance(ent:GetPos()) > maxRange or not ply:Alive() or ply.SCP330_FirstContact) then return end
    ply.SCP330_FirstContact = true
    -- TODO : Trouver un SFX
    -- ply:EmitSound("")
    local CurentTime = CurTime()
    local alphaMax = 255
    local Alpha = 255
    local maxTime = 5
    hook.Add("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex(), function()
        if (not IsValid(ply)) then hook.Remove("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex()) return end
        draw.DrawText( "n'en prenez pas plus qu'un, s'il vous plait!!", "DermaDefault", SCP_055_CONFIG.ScrW * 0.5, SCP_055_CONFIG.ScrH * 0.5, Color(255, 255, 255, Alpha), TEXT_ALIGN_CENTER )
        local timePassed = CurTime() - CurentTime
        Alpha = alphaMax - (alphaMax * (timePassed/maxTime))

        if (timePassed == 5) then hook.Remove("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex()) end
    end)
end