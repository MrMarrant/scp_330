function scp_330.SetConvarClientSide(name, value, ply)
    if (type( value ) == "boolean") then value = value and 1 or 0 end
    net.Start(SCP_330_CONFIG.SetConvarClientSide)
        net.WriteString(name)
        net.WriteUInt(value, 14)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function scp_330.SetVarClientSide(name, value, ply)
    local typeValue = type( value )
    if (typeValue == "boolean") then value = value and 1 or 0 end
    net.Start(SCP_330_CONFIG.SetVarClientSide)
        net.WriteString(name)
        net.WriteString(typeValue)
        net.WriteUInt(value, 14)
    net.Send(ply)
end

function scp_330.RemoveClientEffect(ply)
    net.Start(SCP_330_CONFIG.RemoveClientEffect)
    net.Send(ply)
end


function scp_330.RemoveEffect(ply)
    if (not IsValid(ply)) then return end

    ply.SCP330_HandCut = nil 
    ply.SCP330_CandyTaken = nil
    timer.Remove("SCP055_DeepBleeding".. ply:EntIndex())
    scp_330.RemoveClientEffect(ply)
    
end

function scp_330.DeepBleeding(ply)
    if (not IsValid(ply)) then return end

    local recurrence = SCP_330_CONFIG.RecurrenceBleeding:GetInt()
    local duration = SCP_330_CONFIG.DurationBleeding:GetInt()
    local damageBleed = SCP_330_CONFIG.BleedDamage:GetInt()

    timer.Create("SCP055_DeepBleeding".. ply:EntIndex(), recurrence, duration/recurrence, function()
        if (not IsValid(ply)) then return end
        
        ply:TakeDamage(damageBleed)
        util.Decal( "Blood", ply:GetPos() - Vector(0, 0, 1), ply:GetPos() + Vector(0, 0, 1), ply )
    end)
end

function scp_330.SetTableEntitie(ply, ent, name, value)
    timer.Simple(engine.TickInterval(), function()
        if (not IsValid(ply)) then return end

        table.insert( ent[name], value )
        net.Start(SCP_330_CONFIG.SetTableEntitie)
            net.WriteEntity(ent)
            net.WriteString(name)
            net.WriteString(value)
        net.Send(ply)
    end)
end

function scp_330.SendNotification(ply, message)
    net.Start(SCP_330_CONFIG.SendNotification)
        net.WriteString(message)
    net.Send(ply)
end