--shameless copy-pasta of SkyLight's micro_item_salainen_saha which was a copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--3p8_radio
--formerly micro_item_salainen_radio
--maybe have jake be the radio dj
--dj archieball'd and trapstaar geovainni
--if the secrete mixtape is found, that can be put inside to play the super secrete mixtape. also ejaculable <---- SMArt!!!!!
--test/temp/soundscape_test/tv_music.wav loop

AddCSLuaFile()

ENT.Base = "micro_item_salainen"

--ENT.ItemName = "Radio"
ENT.ItemModel = "models/props/cs_office/radio.mdl" --chose CS:S radio. make unbreakable....?!!!

ENT.Music = {"ambient/guit1.wav", "ambient/opera.wav", "ambient/music/bongo.wav", "ambient/music/country_rock_am_radio_loop.wav", "ambient/music/cubanmusic1.wav",
			 "ambient/music/dustmusic1.wav", "ambient/music/dustmusic2.wav", "ambient/music/dustmusic3.wav", "ambient/music/flamenco.wav", "ambient/music/latin.wav", 
			 "ambient/music/mirame_radio_thru_wall.wav", "ambient/music/piano1.wav", "ambient/music/piano2.wav"}

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
	self.isOff = true
	self.currentSong = self.Music[math.random(1,#self.Music)]
	if SERVER then
		self:SetUseType( SIMPLE_USE )
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("player/bhit_helmet-1.wav")
		--PRODUCE gibs HERE
		self:StopSound(self.currentSong)
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
	--https://wiki.garrysmod.com/page/sound/Add
	--^use this instead^
	if self.isOff then
		self.isOff = false
		if self.containsMixtape then
			--play mixtape
				--play HL2 music?
			
		else
			--play normal music
			self.currentSong = self.Music[math.random(1,#self.Music)]
			print("On: "..self.currentSong)
			self:EmitSound(self.currentSong)
		end
	else
		--stop music
		print("Off: "..self.currentSong)
		--doesn't work as of now, use the comment at the start of the method
		self:StopSound(self.currentSong)
		self.isOff = true
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
