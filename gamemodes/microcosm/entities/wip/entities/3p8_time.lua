--shameless copy-pasta of SkyLight's micro_gamecoob which was a copy-pasta of SkyLight's micro_item_salainen_radio which was a copy-pasta of SkyLight's micro_item_salainen_saha which was a copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--time object... controls growth maybe?
--3p8_time
--should be like my own console swag


AddCSLuaFile()

ENT.Type = "anim"
ENT.ItemName = "time"
ENT.ItemModel = "models/props_lab/harddrive01.mdl"

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()

	--make an array that acts like a queue with a pointer to where the current time is. 
	self.pointer = 1 --lua starts arrays at 1
	self.timeObjects = {}
	--the more items, this will act as the one timer for them all... oue
end

function ENT:AddEnt(entityNumber)
	--adds object to the back of the line

end

function ENT:AddEnt(entityNumber, position)
	--adds object to the specific position in the queue.
		--relative to the pointer?
			--at a certain time...?
	
end

function ENT:Think()
	--execute and increment
	self.timeObjects[self.pointer]:Remove()

	--wind effect?

	self.pointer = self.pointer + 1
end

function ENT:Cancer()
	--shifts the weapons to cancer mode... >:)
	
end