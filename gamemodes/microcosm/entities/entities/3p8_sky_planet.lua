--[[
	3p8_ow_planet
	Uses:		3p8 world.com

	Todo:		
					
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.Model = "models/hunter/misc/sphere025x025.mdl"

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:GetPhysicsObject():EnableMotion(false)


	end


end

--override the original
function ENT:OnTakeDamage(damageto) end

function ENT:Think()
	--in here make it gravitate around ja boy the sun
end
