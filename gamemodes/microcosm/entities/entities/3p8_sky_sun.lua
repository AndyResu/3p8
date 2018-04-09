--[[
	3p8_ow_planet
	Uses:		3p8 Epicsun

	Todo:		

	Extra: 	models/space/asteroid
			ce_ls3additional/asteroids/asteroid_small
			ce_ls3additional/asteroids/asteroid_large

]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.Model = "models/hunter/misc/sphere375x375.mdl"
ENT.Material = "models/atmospheres/sun/shell"

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)
		self:SetMaterial(self.Material)

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:GetPhysicsObject():EnableMotion(false)


	end


end

--override the original
function ENT:OnTakeDamage(damageto) end

function ENT:Think()
	--the sun
end
