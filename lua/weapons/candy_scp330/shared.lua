AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "SCP"
SWEP.ViewModel = ""
SWEP.WorldModel = "" -- TODO : Besoin d'un model pour le worldmodel ?

SWEP.ViewModelFOV = 65
SWEP.HoldType = "normal"
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

SWEP.PrimaryCD = 4
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
	
	if (CLIENT) then ply:ChatPrint("Vous mangez le bonbon goût " .. self.CandyPossessed[candySelected] .. ".") end
	self.CandyPossessed[candySelected] = nil
	if ( #self.CandyPossessed == 0 and SERVER) then self:Remove() end
	ply:EmitSound("scp_330/consume_candy.mp3")
	self:SetNextPrimaryFire( CurTime() + self.PrimaryCD )
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