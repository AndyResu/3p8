--shameless copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puu on kaunis

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Kookospahkina Puu"
ENT.ItemModel = "models/props_foliage/mall_palm01.mdl"
ENT.MaxCount = 1

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	self:SetMoveType(0)
	self.treeLevel = 7
	self.hasLeveled = false

	self.growthSpeed = 105
	self.numberOfFruit = 2
	self.startingEnergy = 10000
	self.energy = self.startingEnergy

	if SERVER then
		--energy timer
		local timer_name = "treeEnergyDepletion_" .. self:EntIndex()
		timer.Create(timer_name,100,0, function() --every 100s, update energy status
			print("100 seconds pass")
			if IsValid(self)then
				self.energy = self.energy - ((100 / self.growthSpeed) + 0) + 100*self.treeLevel --wew?
				print(self.energy)
				-- fruit production
				--if math.Rand() < self.growthSpeed then
					--bear fruit
					for i = 1,self.numberOfFruit do
						print("making coconut again")
						newFruit = ents.Create("micro_item_salainen_kookospahkina_puu")
						if ( !IsValid( newFruit ) ) then return end
						newFruit:SetPos(self:GetPos() + Vector(math.random(-20,20),math.random(-20,20),128))
						--at position up in the tree (might need some if statements to do bearing fruit earlier/later)
							--maybe use the entity's height subtract some?
						self.energy = self.energy - (self.startingEnergy * self.numberOfFruit)
						newFruit:Spawn()
						--set new values for growth speed and gestation or w/e on new entity
						newFruit:SetGenes(self.growthSpeed, self.numberOfFruit, self.startingEnergy)
					end
				--end
				--
				if self.energy <= 0 then --KILL FUNCTION; SLAYER
					self:Remove()
				end
			else
				timer.Remove(timer_name)
			end
		end)
	end
end

if SERVER then
	--this code is used to level up the tree. This is the last level currently implemented, so keep it commented.
	--[[function ENT:Think()
		if !self.hasLeveled then
			self.hasLeveled = true
			timer.Simple( self.growthSpeed, function() 
				newFruit = ents.Create("micro_item_salainen_kookospahkina_puu" .. (self.treeLevel + 1))
				if ( !IsValid( newFruit ) ) then return end
				newFruit:SetPos(self:GetPos())
				--set new values for growth speed and gestation or w/e on new entity
				newFruit:PassOnInfo(self.growthSpeed, self.numberOfFruit, self.startingEnergy, self.energy)
				newFruit:Spawn()
				self:Remove()
			end )
		end
	end
	--]]

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