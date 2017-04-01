--shameless copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puule

AddCSLuaFile()

ENT.Base = "micro_item_salainen"

--ENT.ItemName = "Puulle"
ENT.ItemModel = "models/props/de_venice/canal_poles/canal_pole_2.mdl"

--models/props_foliage/driftwood_01a.mdl
--scale to 1/2 or 1/3

--deciduous tree, good at falling over
--models/props_foliage/tree_city01.mdl



function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--self:SetMoveType(0)
	
	self.health = 1000
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		puulle = ents.Create("prop_physics")
		if ( !IsValid( puulle ) ) then return end
		puulle:SetModel("GIB MODEL")
		puulle:SetPos(self:GetPos())
		puulle:Spawn()

		self:Remove()
	end
end