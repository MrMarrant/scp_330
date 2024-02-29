include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
end

function ENT:Think()
    -- TODO : Afficher la première fois que le joueur s'approche de l'entité, 
    -- TODO : affichez le texte d'avertissement qui s'efface rapidement avec un sfx et set le param SCP330_FirstContact
    scp_330.ProximityEffect(self)
end

function ENT:OnRemove()
end