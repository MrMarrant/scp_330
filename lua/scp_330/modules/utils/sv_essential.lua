-- SCP-330, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2025 MrMarrant.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
    timer.Remove("SCP055_DeepBleeding" .. ply:EntIndex())
    scp_330.RemoveClientEffect(ply)
end

function scp_330.DeepBleeding(ply)
    if (not IsValid(ply)) then return end

    local recurrence = SCP_330_CONFIG.RecurrenceBleeding:GetInt()
    local duration = SCP_330_CONFIG.DurationBleeding:GetInt()
    local damageBleed = SCP_330_CONFIG.BleedDamage:GetInt()
    scp_330.BlurrEffect(ply, 7)
    scp_330.DisplayOverlayBlood(ply)

    timer.Create("SCP055_DeepBleeding" .. ply:EntIndex(), recurrence, duration / recurrence, function()
        if (not IsValid(ply)) then return end

        ply:TakeDamage(damageBleed)
        scp_330.BlurrEffect(ply, 3)
        scp_330.DisplayOverlayBlood(ply)
    end)
end

function scp_330.DisplayOverlayBlood(ply)
    util.Decal( "Blood", ply:GetPos() - Vector(0, 0, 1), ply:GetPos() + Vector(0, 0, 1), ply )
    net.Start(SCP_330_CONFIG.DisplayOverlayBlood)
    net.Send(ply)
end

function scp_330.SetTableEntitie(ply, ent, name, value)
    timer.Simple(1, function() --? Delay to avoid errors cauz fking client is not set yet when the ent is created
        if (not IsValid(ply) or not IsValid(ent)) then return end

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

function scp_330.BlurrEffect(ply, maxTime)
    net.Start(SCP_330_CONFIG.BlurrEffect)
        net.WriteUInt(maxTime, 14)
    net.Send(ply)
end

function scp_330.GetCandy()
    local langUsed = SCP_330_CONFIG.LangServer
    if not SCP_330_LANG[langUsed] then
        langUsed = "en" -- Default lang is EN.
    end
    local candies = SCP_330_CONFIG.FlavorCandy[langUsed]
    return table.Random(candies)
end

--NET MESSAGES
net.Receive(SCP_330_CONFIG.SetConvarInt, function ( len, ply )
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then
        local name = net.ReadString()
        local value = net.ReadUInt(14)
        SCP_330_CONFIG[name]:SetInt(value)

        scp_330.SetConvarClientSide("Client" .. name, value) --? The value clientside start with Client
    end
end)