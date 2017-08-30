--[[

todo:


unrelated but cool
ambient/levels/prison/radio_random15.wav --1 to 15

generator
models/props_vehicles/generatortrailer01.mdl

oil for generator
models/props_c17/oildrum001.mdl
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ComponentModel = "models/props_c17/truss02h.mdl"

function ENT:Initialize()
	self:SetModel(self.ComponentModel)
	--set angles so it stands up...
	self:PhysicsInitStandard()

	if SERVER then
		self:GetPhysicsObject():EnableMotion(false)

		self:SetSolid(3)
	end
	self.health = 1250
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	if class == "3p8_metal" then
		data.HitEntity:Remove()
		self:EmitSound("ambient/levels/canals/headcrab_canister_ambient4.wav")

		--add new part to tower.

	end
end
