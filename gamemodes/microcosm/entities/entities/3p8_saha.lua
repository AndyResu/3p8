

--[[
	3p8_saha
	Uses:		turn logs into wood products

	Todo:		

	Etymology:	saha: saw or sawmill in Finnish

	History:	--shameless copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
				--gottem
]]

AddCSLuaFile()

ENT.Type = "anim"

--ENT.ItemName = "Sawmill"
ENT.ComponentModel = "models/props_wasteland/laundry_washer003.mdl"

function ENT:Initialize()
	if CLIENT then return end
	self:SetModel(self.ComponentModel)
	--self:SetMaterial("models/props_lab/airlock_laser")
	self:PhysicsInitStandard()
	--scaling up means the hitbox is bigger than the parented props...
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(0)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end

	self.woodCounter = 0
	self.woodToMake = 5
	
	self.health = 750
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		for i = 1,math.random(2,4) do
			gib = ents.Create("3p8_metal")
			if ( !IsValid( gib ) ) then return end
			gib:SetPos(self:GetPos() + Vector(math.random(0,32),math.random(0,32),math.random(20,40)))
			--gib:Ignite(math.random(2,6), 0)
			gib:Spawn()
		end

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()
	local model = data.HitEntity:GetModel()

	if class == "micro_item_salainen_puulle" then
		data.HitEntity:Remove()
		--haley said to make little wooden coconut huts. They'd break >:D
			--some kind of pole that sticks on the ground to provide support for roofing
				--Y pole: long and short
				--S roof hook
				--flat walling

		self:EmitSound("physics/wood/wood_box_break"..math.random(1,2)..".wav")
		self.woodCounter = self.woodCounter + 1

		if self.woodCounter == self.woodToMake then
			--produce metal part
			wood = ents.Create("prop_physics")
			if ( !IsValid( wood ) ) then return end
			wood:SetPos(self:GetPos() + Vector(0,0,32))
			wood:SetAngles(Angle(90, 0, 0))
			wood:SetModel("models/props_wasteland/wood_fence01a.mdl")
			wood:Spawn()
			self:EmitSound("ambient/machines/hydraulic_1.wav")
			self.woodCounter = self.woodCounter - self.woodToMake
		end
	elseif class == "prop_physics" then
		--furnature plus a coconut = wood crate, dressor, idk
		if model == "" then
			data.HitEntity:Remove()
			self:EmitSound("ambient/levels/canals/headcrab_canister_ambient4.wav")

			--produce metal part
			metal = ents.Create("3p8_metal")
			if ( !IsValid( metal ) ) then return end
			metal:SetPos(self:GetPos() + Vector(100,-8,-8))
			metal:SetAngles(Angle(90, 0, 90))
			metal:Spawn()
		elseif model == "" then
			
		end
	end
end
