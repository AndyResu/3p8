--[[
	3p8_pizzakit
	Uses:		make pizza when hit against pizza oven

	Todo:		

]]

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "3 Pizzas Kit"
ENT.ItemModel = "models/Items/BoxMRounds.mdl"
ENT.MaxCount = 3

--overriding this so it will set material
function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	self:SetMaterial("phoenix_storms/life_support/canister_valve")

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetCount(self.MaxCount)
	end
end

--overriding use so nothing happens when use is hit
function ENT:Use(ply)

end
