--[[
	3p8_mow
	Uses:		get rid of the grass for real

	Todo:		
	
	Etymology:	Men of War, old teamspeak joke

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_junk/cardboard_box001a.mdl"
ENT.Health = 50

--make the entity spawn on top
function ENT:Use(ply)

end

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 && SERVER then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		self:Remove()
	end
end
