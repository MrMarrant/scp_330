net.Receive(SCP_330_CONFIG.SetConvarClientSide, function ()
    local name = net.ReadString()
    local value = net.ReadUInt(14)
    SCP_330_CONFIG[name] = value
end)

net.Receive(SCP_330_CONFIG.SetVarClientSide, function ()
    local name = net.ReadString()
    local typeVar = net.ReadString()
    local value = net.ReadUInt(14)
    local ply = LocalPlayer()

    if(typeVar == "boolean") then value = tobool(value) end
    ply[name] = value
end)

net.Receive(SCP_330_CONFIG.RemoveClientEffect, function ()
    local ply = LocalPlayer()
    ply.SCP330_FirstContact = false 
    hook.Remove("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex())
    ply.SCP330IsDead = true --? Alive() method is not set to false client side on first tick
    timer.Simple(0.1, function()
        if (not IsValid(ply)) then return end
        ply.SCP330IsDead = nil
    end)
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
    if (ply:GetPos():Distance(ent:GetPos()) > maxRange or not ply:Alive() or ply.SCP330_FirstContact or ply.SCP330IsDead) then return end
    ply.SCP330_FirstContact = true
    -- TODO : Trouver un SFX
    -- ply:EmitSound("")
    local CurentTime = CurTime()
    local alphaMax = 255
    local Alpha = 255
    local maxTime = 5
    local incrementSize = 25
    local size = 5
    local custom_vector = Vector( 1, 1, 1 )

    hook.Add("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex(), function()
        if (not IsValid(ply)) then hook.Remove("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex()) return end
        local timePassed = CurTime() - CurentTime
        alpha = alphaMax - (alphaMax * (timePassed/maxTime))
        local m = Matrix()
        local center = Vector(  SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.5 )
        local colorWhite = Color(255,255,255, alpha)

        m:Translate( center )
        m:Scale( custom_vector * (size + (incrementSize * (timePassed/maxTime))) )
        m:Translate( -center )

        cam.PushModelMatrix( m )
            draw.DrawText( "n'en prenez pas plus qu'un,", "DermaDefault", SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.49, colorWhite, TEXT_ALIGN_CENTER )
            draw.DrawText( "s'il vous plait!!", "DermaDefault", SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.5, colorWhite, TEXT_ALIGN_CENTER )
        cam.PopModelMatrix()
        --draw.DrawText( "n'en prenez pas plus qu'un, s'il vous plait!!", "DermaDefault", SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.5, Color(255, 255, 255, Alpha), TEXT_ALIGN_CENTER )
        --
        
        if (timePassed >= 5) then hook.Remove("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex()) end
    end)
end