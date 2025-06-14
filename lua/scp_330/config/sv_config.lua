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

SCP_330_CONFIG.RadiusEffect = CreateConVar( "SCP330_RadiusEffect", 150, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Radius effect of the text message display at player to warning them", 0, 9999 )
SCP_330_CONFIG.RecurrenceBleeding = CreateConVar( "SCP330_RecurrenceBleeding", 10, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Defined every x seconds, bleeding damage is applied.", 1, 600 )
SCP_330_CONFIG.DurationBleeding = CreateConVar( "SCP330_DurationBleeding", 900, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Define how long the bleeding will last in seconds", 10, 9999 )
SCP_330_CONFIG.BleedDamage = CreateConVar( "SCP330_BleedDamage", 5, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Define the damage to apply when player bleed.", 1, 9999 )

util.AddNetworkString(SCP_330_CONFIG.SetConvarClientSide)
util.AddNetworkString(SCP_330_CONFIG.SetVarClientSide)
util.AddNetworkString(SCP_330_CONFIG.SendNotification)
util.AddNetworkString(SCP_330_CONFIG.SetTableEntitie)
util.AddNetworkString(SCP_330_CONFIG.RemoveClientEffect)
util.AddNetworkString(SCP_330_CONFIG.DisplayOverlayBlood)
util.AddNetworkString(SCP_330_CONFIG.PlayClientSound)
util.AddNetworkString(SCP_330_CONFIG.BlurrEffect)
util.AddNetworkString(SCP_330_CONFIG.SetConvarInt)

-- Send to all player that spawn, the value of the addon
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.SCP330_SetConvarClientSide", function(ply)
    scp_330.SetConvarClientSide("ClientRadiusEffect", SCP_330_CONFIG.RadiusEffect:GetInt(), ply)
end)