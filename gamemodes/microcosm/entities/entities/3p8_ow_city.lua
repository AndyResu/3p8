--[[
	3p8_ow_city
	Uses:		a generalization of the overworld representation of a city

	Todo:		use the building skybox models?
				make each villager add two to the population?
					require 2 pop before the town can trade?
				gonna need to edit the shop so that
					the money displayed is not it's own but the player's
					
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.CityName = "Paradise Oasis" --angel oasis?
ENT.Model = nil
ENT.ParentEnt = nil
ENT.StockArray = nil
ENT.StartingMoney = 1000
ENT.StartingPeople = 5
ENT.ShopPos = Vector(-268, 2730, 48)
ENT.ShopEnt = nil

function ENT:Initialize()
	--self:SetModelScale(1/32, 0) --cactus is small enough as it is

	self.ParentEnt = self:GetNWEntity("ParentEnt", "error")

	if SERVER then
		self:SetModel(self.Model)

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:GetPhysicsObject():EnableMotion(false)

		--make money, people, all that into network variables.
		self:SetNWInt("money", self.StartingMoney)
		self:SetNWInt("people", self.StartingPeople)

		--have it create the shop
		oasisShop = ents.Create("3p8_shop")
		if ( !IsValid( oasisShop ) ) then return end
		oasisShop.StockArray = self.StockArray
		oasisShop:SetNWEntity("ParentEnt", self)
		oasisShop.ParentEnt = oasisShop:GetNWEntity("ParentEnt", "error")
		oasisShop:SetPos(self.ShopPos)
		--the shop will have to go parentEnt.parentEnt.ItemList[i] for each item it has in stock
			--deeper than Atlantis
		oasisShop:Spawn()

		self.ShopEnt = oasisShop
	end

	--create a villager to get the ball rolling?
		--from where to where?
end

--override the original
function ENT:OnTakeDamage(damageto) end
