--[[
	3p8_test_base
	Test: 		might want to try to make a base ent that holds the default ENT:OnTakeDamage code
				would also want to test if a dependent file can just change self.health in initialization... weird.

	Results: 	unknown: it's unfinished

	Uses:		would allow me to change the default sound accross all the files without copy and pasting a bajillion times.
					self:EmitSound("weapons/debris1.wav") -> self:EmitSound("weapons/debris"..math.random(1,3)..".wav")
						I think debris2 and 3 exist... no proof though.

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_phx/misc/potato.mdl"

function ENT:Initialize()
	self:SetMaterial("models/props_wasteland/tugboat02")
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Sleep()
		--make float (bouyancy)
		phys:SetBuoyancyRatio(1.0) --0 min, 1 max (wood)
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		self:Remove()
	end
end