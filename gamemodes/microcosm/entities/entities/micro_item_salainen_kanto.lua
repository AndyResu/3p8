--shameless copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--kanto: stump

AddCSLuaFile()

ENT.Type = "anim"

--ENT.ItemName = "Kanto"
ENT.ItemModel = "models/props_docks/channelmarker_gib01.mdl" --"models/props/de_venice/canal_poles/canal_pole_3.mdl" --csgo model

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:SetMaterial("models/props_foliage/trees_city")
	--self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--self:SetMoveType(0)
	
	self.health = 400

	--energy timer
	local timer_name = "kantoEnergyDepletion_" .. self:EntIndex()
	timer.Create(timer_name,100,0, function() --every 100s, update energy status
		--print("100 seconds pass")
		if IsValid(self)then
			self.health = self.health - 100
			if self.health <= 0 then --KILL FUNCTION; SLAYER
				self:Remove()
			end
			if self:IsOnFire() then
				self:Remove()
			end
		else
			timer.Remove(timer_name)
		end
	end)
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	self:SetHealth(self.health) --make invincible?
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		--puulle = ents.Create("prop_physics")
		--if ( !IsValid( puulle ) ) then return end
		--puulle:SetModel("GIB MODEL")
		--puulle:SetPos(self:GetPos() + Vector(0,0,5))
		--puulle:Spawn()

		self:Remove()
	end
end