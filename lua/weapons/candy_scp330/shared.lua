AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "SCP"
SWEP.ViewModel = Model( "models/weapons/scp_330/v_scp_330.mdl" )
SWEP.WorldModel = Model( "models/weapons/scp_330/w_scp_330.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "slam"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.AutoSwitch = false
SWEP.Automatic = false

SWEP.PrimaryCD = 1
SWEP.SecondaryCD = 2
SWEP.CandyPossessed = {
}

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	-- TODO : (Effet du bonbon)
	local ply = self:GetOwner()
	local candySelected = #self.CandyPossessed
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local VMAnim = ply:GetViewModel()
	local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 

	if (CLIENT) then ply:ChatPrint("Vous mangez le bonbon goût " .. self.CandyPossessed[candySelected] .. ".") end
	self:SetNextPrimaryFire( CurTime() + NexIdle + self.PrimaryCD )
	self.CandyPossessed[candySelected] = nil
	timer.Simple(NexIdle, function()
		if(!self:IsValid()) then return end
		if ( #self.CandyPossessed == 0 and SERVER) then 
			self:Remove() 
		else
			self:PlayDeployAnimation()
		end
	end)
	ply:EmitSound("scp_330/consume_candy.mp3")
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()
	if (CLIENT) then
		ply:ChatPrint("Vous avez en votre possesion " .. #self.CandyPossessed .. " bonbons.")
		for key, value in ipairs(self.CandyPossessed) do
			ply:ChatPrint("Parfum : " .. value)
		end
	end
	self:SetNextSecondaryFire( CurTime() + self.SecondaryCD )
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Deploy()
	self:PlayDeployAnimation()
	return true
end

function SWEP:PlayDeployAnimation()
	local ply = self:GetOwner()
	local speedAnimation = GetConVarNumber( "sv_defaultdeployspeed" )
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetPlaybackRate( speedAnimation )
	local VMAnim = ply:GetViewModel()
	local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 
	self:SetNextPrimaryFire( CurTime() + NexIdle + 0.1 ) --? We add 0.1s for avoid to cancel primary animation
	self:SetNextSecondaryFire( CurTime() + NexIdle )
	timer.Simple(NexIdle, function()
		if(!self:IsValid()) then return end
		self:SendWeaponAnim( ACT_VM_IDLE )
	end)
end