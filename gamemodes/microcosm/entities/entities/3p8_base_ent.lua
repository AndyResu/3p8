--[[
	3p8_base_ent
	Uses:		All entities may one day extend from this base entity which ensures all the entities "cover their bases" so-to-speak.
				I don't think this even does anything because I overwrite it all the time

	Todo:		

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/food/hotdog.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInitStandard()
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	--self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	self.health = 100
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--produce gibs here
		self:Remove()
	end
end