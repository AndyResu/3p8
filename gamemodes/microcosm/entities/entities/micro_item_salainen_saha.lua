--shameless copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--saha: saw or sawmill
--micro_item_salainen_saha

AddCSLuaFile()

ENT.Base = "micro_item_salainen"

--ENT.ItemName = "Sawmill"
ENT.ItemModel = "models/props_lab/kennel_physics.mdl"

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(3)
	--self:SetMoveType(0)

	--TODO: GET MATERIAL SO THIS DOESN'T LOOK DUMB
	self:SetMaterial("phoenix_storms/potato")
	
	self.health = 1000
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	--if self:IsBroken() then return end
	local class = data.HitEntity:GetClass()

	if class == "micro_item_salainen_puulle" then
		--make planks
		self:EmitSound("ambient/machines/hydraulic_1.wav")
		data.HitEntity:Remove()
		--haley said to make little wooden coconut huts. They'd break >:D
			--some kind of pole that sticks on the ground to provide support for roofing
				--Y pole: long and short
				--S roof hook
				--flat walling
	end
end