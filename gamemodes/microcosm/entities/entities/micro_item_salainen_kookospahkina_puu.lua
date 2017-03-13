--shameless copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puu on kaunis
--micro_item_salainen_kookospahkina_puu copy-paste

--TODO: Make coconut float
--		fix the collision models
--		on plantable on ground

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Kookospahkina"
ENT.ItemModel = "models/hunter/misc/sphere025x025.mdl"
ENT.MaxCount = 1

function ENT:Use(ply)
	--plant the coconut
	if !self.isPlanted && self:WaterLevel() == 0 then --TODO: && self:OnGround() 
		self.isPlanted = true
		--stop movement
		self:SetMoveType(0)
		--make sound
		self:EmitSound("phx/eggcrack.wav")
		--go to next level
		newFruit = ents.Create("micro_item_salainen_kookospahkina_puu" .. (self.treeLevel + 1))
		if ( !IsValid( newFruit ) ) then return end
		newFruit:SetPos(self:GetPos() + Vector(0,0,-5))
		--set new values for growth speed and gestation or w/e on new entity
		newFruit:PassOnInfo(self.growthSpeed, self.numberOfFruit, self.startingEnergy, self.energy)
		newFruit:Spawn()
		self:Remove()
	end
	print("growthSpeed at planting: " .. self.growthSpeed)
	print("energy at planting: " .. self.energy)
	--print(self.isPlanted)
	--print(self.treeLevel .. " should be 0")
	--print(self:WaterLevel() .. " should be 0")
end

function ENT:Initialize()
	self:SetMaterial("models/props_pipes/guttermetal01a")
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	self.isPlanted = false

	self.growthSpeed = 5
	self.numberOfFruit = 2
	self.startingEnergy = 10000
	self.energy = self.startingEnergy
	self.treeLevel = 0

	if SERVER then
		--energy timer
		local timer_name = "treeEnergyDepletion_" .. self:EntIndex()
		timer.Create(timer_name,100,0, function() --every 100s, update energy status
			if IsValid(self) && math.Rand(0,1) > 0.67 then
				-- autoplant functionality
				--plant itself. below copy pasted from ENT:Use()
					--plant the coconut
					if !self.isPlanted && self:WaterLevel() == 0 then --TODO: && self:OnGround() 
						self.isPlanted = true
						--stop movement
						self:SetMoveType(0)
						--make sound
						self:EmitSound("phx/eggcrack.wav")
						--go to next level
						newFruit = ents.Create("micro_item_salainen_kookospahkina_puu" .. (self.treeLevel + 1))
						if ( !IsValid( newFruit ) ) then return end
						newFruit:SetPos(self:GetPos() + Vector(0,0,-5))
						--set new values for growth speed and gestation or w/e on new entity
						newFruit:Spawn()
						newFruit:PassOnInfo(self.growthSpeed, self.numberOfFruit, self.startingEnergy, self.energy)
						self:Remove()
					end
					--print("current growthspeed: " .. self.growthSpeed)
					--print(self.isPlanted)
					--print(self.treeLevel .. " should be 0")
					--print(self:WaterLevel() .. " should be 0")
				--
			elseif !IsValid(self) then
				timer.Remove(timer_name)
			end
		end)
	end
end

if SERVER then
	--
	function ENT:SetGenes(setGrowthSpeed, setNumberOfFruit, setStartingEnergy)
		--print("ran on coconut")
		newGrowthSpeed = setGrowthSpeed + math.random(-1,1) --chance to grow food every 100 seconds
		if newGrowthSpeed < 300 then --1 every 300s
			newGrowthSpeed = 300
		elseif newGrowthSpeed > 3000 then --1 every 3000s, or 50m
			newGrowthSpeed = 3000
		end

		self.growthSpeed = newGrowthSpeed
		print("new growthSpeed: " .. self.growthSpeed)

		newNumberOfFruit = setNumberOfFruit + math.random(-1,1)
		if newNumberOfFruit < 1 then
			newNumberOfFruit = 1
		elseif newNumberOfFruit > 5 then
			newNumberOfFruit = 5
		end
		self.numberOfFruit = newNumberOfFruit

		--setEnergy here, this is to ensure that the plant lives for some time and also dies eventually.
		newStartingEnergy = setStartingEnergy + math.random(-1,1)
		if newStartingEnergy < 600 then
			newStartingEnergy = 600
		elseif newStartingEnergy > 1000000 then
			newStartingEnergy = 1000000
		end
		self.startingEnergy = newStartingEnergy
		self.energy = self.startingEnergy
		print("new energy: " .. self.energy)
	end
	--

	--if fertilizer is introduced like in SS13, then make a GetGenes...

	function ENT:PassOnInfo(setGrowthSpeed, setNumberOfFruit, setStartingEnergy, setEnergy)
		self.growthSpeed = setGrowthSpeed
		self.numberOfFruit = setNumberOfFruit
		self.startingEnergy = setStartingEnergy
		self.energy = setEnergy
	end
end

--models/props_forest/log.mdl

--cocnut21
--0 models/hunter/misc/sphere025x025.mdl
	--models/props_pipes/guttermetal01a --material

--from tree thing on workshop
--1 models/props_foliage/ferns03.mdl
--2 models/props_foliage/ferns02.mdl
--3 models/props/de_dust/palm_tree_head_skybox.mdl
--4 models/props_foliage/urban_small_palm01.mdl
--5 models/props_foliage/mall_palmplant02.mdl
--6 models/props_foliage/mall_palm01_medium.mdl
--7 models/props_foliage/mall_palm01.mdl

--http://gamebanana.com/models/3622
--8 models/domitibingen/foliage/palms/d_palm_01/d_palm_s_07.mdl
--9 models/domitibingen/foliage/palms/d_palm_01/d_palm_b_01.mdl