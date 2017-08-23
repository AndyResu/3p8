AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_wasteland/laundry_washer001a.mdl"

--rocks (exhaustable)

function ENT:Initialize()
	--self:SetMaterial("models/props_pipes/guttermetal01a")
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Sleep() --stop movement from the get-go
	end

	self.health = 2500
end


function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		self:Remove()
	end
end