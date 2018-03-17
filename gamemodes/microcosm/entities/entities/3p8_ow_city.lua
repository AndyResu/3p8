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
ENT.Model = "models/props_lab/cactus.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	--self:SetModelScale(1/32, 0) --cactus is small enough as it is
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:GetPhysicsObject():EnableMotion(false)

	--find the local shop in edgewood.
		--when the shop spawns maybe find the town it should be and set the shop = to self?
	GLOBAL_towns[#GLOBAL_towns+1] = {
		name	= self.CityName,
		pos		= self:GetPos()
		shop	= nil --I think the shop's entity reference
		--the base amount of people in the city... think the mayor and shop people I guess
		basePop	= 5
		--other citizens
		people	= 0
		money	= 1000
	}
	self.ID = #GLOBAL_towns

end

--make a function that can add/remove from the shops inventory.
function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()
	local entity = data.HitEntity
	local items = entity.getItems()

	if class == "3p8_ow_villager" then
		--get the shop for that city and buy/sell
		for i=1, #items do
			for j=1, #GLOBAL_items_edgewood do
				itemToSell = GLOBAL_items_edgewood[j].ent
				if(items[i].ent == "People") then
					--add the population to the city
					--take the number of people and add it to the city
					GLOBAL_towns[self.ID].people = items[i].stock + GLOBAL_towns[self.ID].people
				elseif(items[i].ent == itemToSell) then
					--j is the itemID
					--i is the items's ID
					GLOBAL_towns[self.ID].shop:ow_sellToShop(j, items[i].stock)
				end
			end
		end
		--delete the villager
		entity.remove()

	elseif class == "3p8_ow_blacklabs" then
		--same as above except for blacklabs. ???
		
	elseif class == "the_vehicle_ent_name_placeholder" then
		--connect the teleporter to the teleporter of the town...
	
	end
end
