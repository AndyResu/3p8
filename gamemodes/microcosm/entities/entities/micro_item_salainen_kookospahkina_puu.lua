--shameless copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puu on kaunis
--micro_item_salainen_kookospahkina_puu copy-paste

--TODO: Make sure SERVER and CLIENT stuff are correct...!
--have a timer that detracts energy based on traits and adds energy based on traits also

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Puu"
ENT.ItemModel = "models/hunter/misc/sphere025x025.mdl"
ENT.MaxCount = 1

function ENT:Use(ply)
	--plant the coconut
	--[[if !self.isPlanted then --TODO: check material beneathe to make sure it's on land that can support growing a tree. Also check to make sure there is enough horizontal room?
		self.isPlanted = true
		print("homo fagest")
		print(self.treeModels)
		PrintTable(self.treeModels)
		for i = 1,#self.treeModels do
			timer.Simple( self.growthSpeed, function()
				self:SetModel(i)
			end )
			self.treeLevel = i
		end
	end]]
end

function ENT:Initialize()
	self:SetMaterial("models/props_pipes/guttermetal01a")
	self:PhysicsInitStandard()
	self.isPlanted = false
	self.treeLevel = 0
	self.treeModels = {"models/props_foliage/ferns03.mdl", "models/props_foliage/ferns02.mdl", "models/props/de_dust/palm_tree_head_skybox.mdl", "models/props_foliage/urban_small_palm01.mdl",
						"models/props_foliage/mall_palmplant02.mdl", "models/props_foliage/mall_palm01_medium.mdl", "models/props_foliage/mall_palm01.mdl"}
	self.growthSpeed = 5
	self.numberOfFruit = 1
	self.energy = 10000

	if SERVER then
		local timer_name = "treeEnergyDepletion_" .. self:EntIndex()
		timer.Create(timer_name,120,0, function() --every two minutes, update energy status
			if IsValid(self) then
				self.energy = self.energy - (120 / self.growthSpeed) --wew?
				--[[ fruit production
				if treeLevel > a certain number then
					--bear fruit
					Ent create micro_item_salainen_kookospahkina_puu
						--at position up in the tree (might need some if statements to do bearing fruit earlier/later)
							--maybe use the entity's height subtract some?
						--set new values for growth speed and gestation or w/e on new entity
						self.setGenes(1, 2, 3)
				end
				--]]
				--[[ autoplant functionality
				if treeLevel == 0 then
					timer.Simple( self.growthSpeed, function()
						if math.Rand() > 0.75 then
							--plant itself. 
							self.Use()
						end
					end )
				end
				--]]
			else
				timer.Remove(timer_name)
			end
		end)
	end
end

if SERVER then
	function ENT:setGenes(setGrowthSpeed, setNumberOfFruit, setEnergy)
		newGrowthSpeed = setGrowthSpeed + math.Random(-1,1)
		if newGrowthSpeed < 5 then --5 seconds for debugging. 10 minute days, 600 IRL seconds / day, so 300 is half a day.
			newGrowthSpeed = 5
		elseif newGrowthSpeed > 3000 then
			newGrowthSpeed = 3000 --55 minutes IRL, or 5 days in game at 600 IRL seconds / day
		end
		self.growthSpeed = newGrowthSpeed

		newNumberOfFruit = setNumberOfFruit + math.Random(-1,1)
		if newNumberOfFruit < 1 then
			newNumberOfFruit = 1
		elseif newNumberOfFruit > 5 then
			newNumberOfFruit = 5
		end
		self.numberOfFruit = newNumberOfFruit

		--setEnergy here, this is to ensure that the plant lives for some time and also dies eventually.
		newEnergy = self.energy + math.Random(-1,1)
		if newGrowthSpeed < 600 then
			newGrowthSpeed = 600
		elseif newGrowthSpeed > 1000000 then
			newGrowthSpeed = 1000000
		end
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