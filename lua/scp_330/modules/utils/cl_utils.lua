local AddAlpha = 0.1
local DrawAlphaFC = 0.2
local DrawAlphaOC = 0.5
local DelayFC = 0.05
local DelayOC = 0.1
local tab = {
    [ "$pp_colour_addr" ] = 0,
    [ "$pp_colour_addg" ] = 0,
    [ "$pp_colour_addb" ] = 0,
    [ "$pp_colour_brightness" ] = 0,
    [ "$pp_colour_contrast" ] = 1,
    [ "$pp_colour_colour" ] = 1,
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

net.Receive(SCP_330_CONFIG.SetConvarClientSide, function ()
    local name = net.ReadString()
    local value = net.ReadUInt(14)
    SCP_330_CONFIG[name] = value
end)

net.Receive(SCP_330_CONFIG.PlayClientSound, function ()
    local ply = LocalPlayer()
    local sound = net.ReadString()
    scp_330.PlayClientSound(ply, sound)
end)

net.Receive(SCP_330_CONFIG.BlurrEffect, function ()
    local value = net.ReadUInt(14)
    local ply = LocalPlayer()

    scp_330.BlurrEffect(ply, value)
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
    hook.Remove("Think", "Think.DisplayOverlayBlood_SCP330_".. ply:EntIndex())
    hook.Remove("HUDPaint", "HUDPaint.SCP_330_BlurrEffect".. ply:EntIndex())
    if (ply.SCP330_OverlayBlood) then 
        ply.SCP330_OverlayBlood:Remove()
        ply.SCP330_OverlayBlood = nil
    end
    ply.SCP330_IsDead = true --? Alive() method is not set to false client side on first tick
    timer.Simple(0.1, function()
        if (not IsValid(ply)) then return end
        ply.SCP330_IsDead = nil
    end)
end)

net.Receive(SCP_330_CONFIG.DisplayOverlayBlood, function ()
    local ply = LocalPlayer()
    scp_330.DisplayOverlay(ply)
    local CurentTime = CurTime()
    local totalTime = 0
    local maxTime = 4
    local partTime = maxTime / 2
    local delta = 1
    local alpha = 0
    local alphaMax = 200

    hook.Add("Think", "Think.DisplayOverlayBlood_SCP330_".. ply:EntIndex(), function()
        if (not IsValid(ply)) then return end
        local timePassed = CurTime() - CurentTime
        if timePassed >= partTime then 
            totalTime = totalTime + timePassed
            CurentTime = CurTime()
            timePassed = 0
            alpha = alphaMax
        end
        alpha = totalTime < partTime and alphaMax * (timePassed/partTime) or alphaMax - (alphaMax * (timePassed/partTime))
        ply.SCP330_OverlayBlood:SetImageColor(Color(255, 255, 255, alpha))
        if (totalTime >= maxTime) then
            hook.Remove("Think", "Think.DisplayOverlayBlood_SCP330_".. ply:EntIndex())
            ply.SCP330_OverlayBlood:Remove()
            ply.SCP330_OverlayBlood = nil
        end
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
    if (ply:GetPos():Distance(ent:GetPos()) > maxRange or not ply:Alive() or ply.SCP330_FirstContact or ply.SCP330_IsDead) then return end
    ply.SCP330_FirstContact = true
    ply:EmitSound("scp_330/on_first_contact.mp3")

    local CurentTime = CurTime()
    local alphaMax = 255
    local Alpha = 255
    local maxTime = 4
    local incrementSize = 4
    local size = 0.3
    local sizeVector = Vector( 1, 1, 1 )
    local center = Vector(  SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.5 )

    hook.Add("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex(), function()
        if (not IsValid(ply)) then return end
        local timePassed = CurTime() - CurentTime
        alpha = alphaMax - (alphaMax * (timePassed/maxTime))
        local colorWhite = Color(255,255,255, alpha)
        tab[ "$pp_colour_contrast" ] = math.Clamp(timePassed / maxTime + 0.3, 0, 1)

        local matrixText = Matrix()
        matrixText:Translate( center )
        matrixText:Scale( sizeVector * (size + (incrementSize * (timePassed/maxTime))) )
        matrixText:Translate( -center )

        cam.PushModelMatrix( matrixText )
            draw.DrawText( "n'en prenez pas plus qu'un,", "SCP_330_FCFont", SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.41, colorWhite, TEXT_ALIGN_CENTER )
            draw.DrawText( "s'il vous plait!!", "SCP_330_FCFont", SCP_330_CONFIG.ScrW * 0.5, SCP_330_CONFIG.ScrH * 0.49, colorWhite, TEXT_ALIGN_CENTER )
        cam.PopModelMatrix()

        DrawColorModify( tab )
        cam.Start3D()
            render.SetStencilEnable( true )
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
            render.SetStencilReferenceValue( 1 )
            render.SetStencilFailOperation( STENCIL_KEEP )
            render.SetStencilZFailOperation( STENCIL_KEEP )
    
            render.SetStencilCompareFunction( STENCIL_ALWAYS )
            render.SetStencilPassOperation( STENCIL_REPLACE )
    
            render.SetStencilEnable( false )
        cam.End3D()
    
        DrawMotionBlur( AddAlpha, DrawAlphaFC, DelayFC )

        if (timePassed >= maxTime) then hook.Remove("HUDPaint", "HUDPaint.SCP_330_FirstContact".. ply:EntIndex()) end
    end)
end

function scp_330.BlurrEffect(ply, maxTime)
    if (not IsValid(ply)) then return end

    local CurentTime = CurTime()

    hook.Add("HUDPaint", "HUDPaint.SCP_330_BlurrEffect".. ply:EntIndex(), function()
        if (not IsValid(ply)) then return end
        local timePassed = CurTime() - CurentTime

        DrawColorModify( tab )
        cam.Start3D()
            render.SetStencilEnable( true )
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
            render.SetStencilReferenceValue( 1 )
            render.SetStencilFailOperation( STENCIL_KEEP )
            render.SetStencilZFailOperation( STENCIL_KEEP )
    
            render.SetStencilCompareFunction( STENCIL_ALWAYS )
            render.SetStencilPassOperation( STENCIL_REPLACE )
    
            render.SetStencilEnable( false )
        cam.End3D()
    
        DrawMotionBlur( AddAlpha, DrawAlphaOC, DelayOC )

        if (timePassed >= maxTime) then hook.Remove("HUDPaint", "HUDPaint.SCP_330_BlurrEffect".. ply:EntIndex()) end
    end)
end

function scp_330.DisplayOverlay(ply)
    if (not IsValid(ply)) then return end
    if (ply.SCP330_OverlayBlood) then return end

    local overlayBlood = vgui.Create("DImage")
    overlayBlood:SetImageColor(Color(255, 255, 255, 0))
    overlayBlood:SetSize(SCP_330_CONFIG.ScrW, SCP_330_CONFIG.ScrH)
    overlayBlood:SetImage("scp_330_assets/overlay_blood.png")
    ply.SCP330_OverlayBlood = overlayBlood

    scp_330.PlayClientSound(ply, "scp_330/heavy_breath_".. math.random(1, 3) ..".mp3")
end

function scp_330.PlayClientSound(ply, sound)
    if (not IsValid(ply)) then return end

    ply:EmitSound(Sound(sound))
end