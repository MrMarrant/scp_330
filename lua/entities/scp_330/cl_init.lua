include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
    scp_330.ProximityEffect(self)
end