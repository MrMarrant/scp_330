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

-- TODO : Trouver des SFX
-- Use specially for the physics sounds
function ENT:PhysicsCollide( data, physobj )
	if data.DeltaTime > 0.2 then
		if data.Speed > 250 then
			--self:EmitSound( "scp_055/hard_briefcase.mp3", 75, math.random( 100, 110 ) )	
		else
			--self:EmitSound( "scp_055/soft_briefcase.mp3", 75, math.random( 100, 110 ) )		
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
		-- TODO : spawn les props de mains
		-- TODO : SFX Cris de douleur
		-- TODO : Effet de sang HUD
		ply.SCP330_HandCut = true
		scp_330.DeepBleeding(ply)
		ply:StripWeapons()
	else
		local candySwep = ply:HasWeapon("candy_scp330") and ply:GetWeapon("candy_scp330") or ply:Give("candy_scp330")
		local value, candyTaken = table.Random( SCP_330_CONFIG.FlavorCandy )
		scp_330.SetTableEntitie(ply, candySwep, "CandyPossessed", candyTaken)
		scp_330.SendNotification(ply, "Vous avez pris un bonbon de SCP-330 au parfum de " .. candyTaken .. " !")
	end
end