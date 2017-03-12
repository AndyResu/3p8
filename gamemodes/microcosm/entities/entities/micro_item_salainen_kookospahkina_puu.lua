--shameless copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puu on kaunis
--micro_item_salainen_kookospahkina_puu copy-paste

--TODO: Make sure SERVER and CLIENT stuff are correct...!

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Kookospahkina"
ENT.ItemModel = "models/hunter/misc/sphere025x025.mdl"
ENT.MaxCount = 1

function ENT:Use(ply)
	--plant the coconut
	if !self.isPlanted && self.treeLevel == 0 && self:WaterLevel() == 0 then --TODO: && self:OnGround() 
		self.isPlanted = true
		--stop movement
		self:SetMoveType(0)
		print("FROZEN: ")
		--make sound
		self:EmitSound("phx/eggcrack.wav")
		for i = 1,#self.treeModels do
			timer.Simple( self.growthSpeed, function()
				self:SetModel(i)
				print("TIMER RUNNING?!")
			end )
			self.treeLevel = i
		end
	end
	print("current growthspeed: " .. self.growthSpeed)
	print(self.isPlanted)
	print(self.treeLevel .. " should be 0")
	print(self:WaterLevel() .. " should be 0")
end

function ENT:Initialize()
	self:SetMaterial("models/props_pipes/guttermetal01a")
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	self.isPlanted = false
	self.treeLevel = 0
	self.treeModels = {"models/props_foliage/ferns03.mdl", "models/props_foliage/ferns02.mdl", "models/props/de_dust/palm_tree_head_skybox.mdl", "models/props_foliage/urban_small_palm01.mdl",
						"models/props_foliage/mall_palmplant02.mdl", "models/props_foliage/mall_palm01_medium.mdl", "models/props_foliage/mall_palm01.mdl"}
	self.growthSpeed = 5
	self.numberOfFruit = 2
	self.startingEnergy = 10000
	self.energy = self.startingEnergy

	if SERVER then
		--energy timer
		local timer_name = "treeEnergyDepletion_" .. self:EntIndex()
		timer.Create(timer_name,100,0, function() --every 100s, update energy status
			if IsValid(self) && self.isPlanted then
				self.energy = self.energy - ((1000 * self.growthSpeed) + 0) + 100*self.treelevel --wew?
				print(self.energy)
				-- fruit production
				if treeLevel > 7 && math.rand() < self.growthSpeed then
					--bear fruit
					--Ent create micro_item_salainen_kookospahkina_puu
					newFruit = ents.Create("micro_item_salainen_kookospahkina_puu")
					if ( !IsValid( newFruit ) ) then return end
					for i = 1,self.numberOfFruit do
						newFruit:SetPos(self:GetPos() + Vector(math.Random(-25,25),math.Random(-25,25),256))
						--at position up in the tree (might need some if statements to do bearing fruit earlier/later)
							--maybe use the entity's height subtract some?
						--set new values for growth speed and gestation or w/e on new entity
						newFruit:setGenes(self.growthSpeed, self.numberOfFruit, self.startingEnergy)
						self.energy = self.energy - (self.startingEnergy * self.numberOfFruit)
						newFruit:Spawn()
					end
				end
				--
				if self.energy <= 0 then --KILL FUNCTION; SLAYER
					self:Remove()
				end
			elseif IsValid(self) && treeLevel == 0 && math.Rand() > 0.75 then
				-- autoplant functionality
				if self.energy <= 0 then --make sure plant not really dead somehow
					self:Remove()
				end
				--plant itself.
				self.Use()
				--
			else
				timer.Remove(timer_name)
			end
		end)
	end
end

if SERVER then
	function ENT:setGenes(setGrowthSpeed, setNumberOfFruit, setStartingEnergy)
		newGrowthSpeed = setGrowthSpeed + (math.Random(-2,2)/100) --chance to grow food every 100 seconds
		if newGrowthSpeed < 0.03 then --1 every 3000s, or 50m
			newGrowthSpeed = 0.03
		elseif newGrowthSpeed > 0.34 then --1 every 300s
			newGrowthSpeed = 0.34
		end
		print("old value: " .. self.growthSpeed)
		self.growthSpeed = newGrowthSpeed
		print("new value: " .. self.growthSpeed)

		newNumberOfFruit = setNumberOfFruit + math.Random(-1,1)
		if newNumberOfFruit < 1 then
			newNumberOfFruit = 1
		elseif newNumberOfFruit > 5 then
			newNumberOfFruit = 5
		end
		self.numberOfFruit = newNumberOfFruit

		--setEnergy here, this is to ensure that the plant lives for some time and also dies eventually.
		newStartingEnergy = self.startingEnergy + math.Random(-1,1)
		if newStartingEnergy < 600 then
			newStartingEnergy = 600
		elseif newStartingEnergy > 1000000 then
			newStartingEnergy = 1000000
		end
		self.startingEnergy = newStartingEnergy
		self.energy = self.startingEnergy
	end

	--if fertilizer is introduced like in SS13, then make a getGenes...
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