--pretty much copy pasta of Parakeet's micro_item, but this one doens't have that weird title thing when the player looks at it

--micro_item_salainen

AddCSLuaFile()

ENT.Type = "anim"

--ENT.ItemName = "TOP SECRETE"
ENT.ItemModel = "models/props_junk/watermelon01.mdl"

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

if CLIENT then
	function ENT:OnRemove()
		if IsValid(self.cmodel) then
			self.cmodel:Remove()
		end
	end
end