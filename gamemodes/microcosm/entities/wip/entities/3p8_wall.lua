--shameless copy-pasta of SkyLight's 3p8_planet which was a copy-pasta of SkyLight's 3p8_time which was a copy-pasta of SkyLight's micro_gamecoob which was a copy-pasta of SkyLight's micro_item_salainen_radio which was a copy-pasta of SkyLight's micro_item_salainen_saha which was a copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--wall that break sorta like r6
--3p8_wall


AddCSLuaFile()

ENT.Base = "base_brush"
ENT.Type = "brush"

--ENT.ItemName = "3P8 Wall"
--ENT.ItemModel = "models/hunter/misc/sphere375x375.mdl"

--apply a decal, and make that decal be an entity teleporter to it's linked?
--maybe just make the entire entity be shootable and apply a layer of not shootable.

function ENT:Initialize()
	--self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false) 
	end

end