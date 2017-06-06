--shameless copy-pasta of SkyLight's micro_item_salainen_saha which was a copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--radio
--micro_item_salainen_radio
--maybe have jake be the radio dj
--dj archieball'd and trapstaar geovainni
--if the secrete mixtape is found, that can be put inside to play the super secrete mixtape. also ejaculable <---- SMArt!!!!!

AddCSLuaFile()

ENT.Base = "micro_item_salainen"

--ENT.ItemName = "Radio"
ENT.ItemModel = "models/props/cs_office/radio.mdl" --chose CS:S radio. make unbreakable....?!!!

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(3)
	--self:SetMoveType(0)

	--self:SetMaterial("phoenix_storms/potato")
	
	self.health = 1000

	self.containsMixtape = false
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("player/bhit_helmet-1.wav")
		--PRODUCE gibs HERE

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	--if self:IsBroken() then return end
	local class = data.HitEntity:GetClass()

	if class == "micro_item_salainen_mixtape" then
		--play the mixtape
			--ambient/machines/zap1.wav .. 2, 3 for entry sound
		self:EmitSound("ambient/machines/hydraulic_1.wav") --
		self.containsMixtape = true
		data.HitEntity:Remove()
	end
end

function ENT:Use(ply)

	if self.containsMixtape then
		
	end
end

--ambient/guit1.wav
--ambient/opera.wav
--paul wall chatter
	--ambient/chatter/cb_radio_chatter_1.wav
	--ambient/chatter/cb_radio_chatter_2.wav
	--ambient/chatter/cb_radio_chatter_3.wav
--ambient/music/bongo.wav
--ambient/music/country_rock_am_radio_loop.wav
--ambient/music/cubanmusic1.wav
--ambient/music/dustmusic1.wav
--ambient/music/dustmusic2.wav
--ambient/music/dustmusic3.wav
--ambient/music/flamenco.wav
--ambient/music/latin.wav
--ambient/music/mirame_radio_thru_wall.wav
--ambient/music/piano1.wav
--ambient/music/piano2.wav