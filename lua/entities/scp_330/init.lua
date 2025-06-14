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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/scp_330/scp_330.mdl" )
	self:RebuildPhysics()
end

-- Intialise the physic of the entity
function ENT:RebuildPhysics( )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

-- Use specially for the physics sounds
function ENT:PhysicsCollide( data, physobj )
	if data.DeltaTime > 0.2 then
		if data.Speed > 250 then
			self:EmitSound( "physics/glass/glass_bottle_impact_hard" .. math.random(1, 3) .. ".wav", 75, math.random( 100, 110 ) )
		else
			self:EmitSound( "physics/glass/glass_impact_soft" .. math.random(1, 3) .. ".wav", 75, math.random( 100, 110 ) )
		end
	end
end


function ENT:Use(ply)
	if (not IsValid(ply)) then return end
	if (ply.SCP330_HandCut) then return end

	if (ply.SCP330_CandyTaken) then ply.SCP330_CandyTaken = ply.SCP330_CandyTaken + 1
	else ply.SCP330_CandyTaken = 1
	end

	if (ply.SCP330_CandyTaken >= 3) then
		ply.SCP330_HandCut = true
		ply:EmitSound("scp_330/cut_hands.mp3")
		local rightHand = ents.Create("prop_physics")
		local leftHand = ents.Create("prop_physics")
		leftHand:SetModel("models/scp_330/scp_330_hand.mdl")
		leftHand:SetPos( ply:GetPos() + (-40 * ply:GetRight()) )
		leftHand:Spawn()
		rightHand:SetModel("models/scp_330/scp_330_hand.mdl")
		rightHand:SetPos( ply:GetPos() + (40 * ply:GetRight()) )
		rightHand:Spawn()
		net.Start(SCP_330_CONFIG.PlayClientSound)
			net.WriteString("scp_330/you_got_what_you_deserve.mp3")
		net.Send(ply)
		scp_330.DeepBleeding(ply)
		ply:StripWeapons()

		util.Decal( "Blood", ply:GetPos() - Vector(0, 0, 1), ply:GetPos() + Vector(0, 0, 1), ply )

		timer.Simple( 300, function()
			if (IsValid(leftHand)) then leftHand:Remove() end
			if (IsValid(rightHand)) then rightHand:Remove() end
		end)
	else
		local candySwep = ply:HasWeapon("candy_scp330") and ply:GetWeapon("candy_scp330") or ply:Give("candy_scp330")
		local value, candyTaken = scp_330.GetCandy()
		scp_330.SetTableEntitie(ply, candySwep, "CandyPossessed", candyTaken)
		scp_330.SendNotification(ply, scp_330.GetTranslation("pick_candy") .. candyTaken .. " !")
		ply:EmitSound( "scp_330/pick_candy.mp3", 75, math.random( 90, 110 ) )
	end
end