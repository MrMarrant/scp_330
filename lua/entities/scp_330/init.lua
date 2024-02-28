AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "" )
	self:InitVar()
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
		ply.SCP330_HandCut = true
		scp_330.DeepBleeding(ply)
		ply:StripWeapons()
	elseif (ply:HasWeapon("candy_scp330")) then
		local candy = ply:GetWeapon("candy_scp330")
		table.insert( candy.CandyPossessed, SCP_330_CONFIG.FlavorCandy[math.random(1, #SCP_330_CONFIG.FlavorCandy)] )
	else
		local candy = ply:Give("candy_scp330")
		table.insert( candy.CandyPossessed, SCP_330_CONFIG.FlavorCandy[math.random(1, #SCP_330_CONFIG.FlavorCandy)] )
	end
end

-- Intialise every var related to the entity
function ENT:InitVar( )
end
