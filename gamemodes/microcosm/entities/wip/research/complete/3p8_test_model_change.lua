--[[
	3p8_test_model_change
	Test: 		changing the model after initialization

	Results: 	it works like this.
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_phx/misc/potato.mdl"

function ENT:Use(ply)
	--change model
	self:SetModel("models/maxofs2d/hover_rings.mdl")
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)
end

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