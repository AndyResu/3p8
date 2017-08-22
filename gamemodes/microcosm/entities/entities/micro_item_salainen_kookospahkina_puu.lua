--shameless copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puu on kaunis
--micro_item_salainen_kookospahkina_puu copy-paste

AddCSLuaFile()

ENT.Base = "micro_item_salainen"

--ENT.ItemName = "Kookospahkina"
ENT.ItemModel = "models/hunter/misc/sphere025x025.mdl"
--ENT.MaxCount = 1

function ENT:Use(ply)
	--plant the coconut
	self:Upgrayed()
	self:GetPhysicsObject():Wake()
end

function ENT:Initialize()
	self:SetMaterial("models/props_pipes/guttermetal01a")
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Sleep()
		--make float (bouyancy)
		phys:SetBuoyancyRatio(1.0) --0 min, 1 max (wood)
	end
	self.isPlanted = false

	self.growthSpeed = 5
	self.numberOfFruit = 4
	self.startingEnergy = 10000
	self.energy = self.startingEnergy
	self.treeLevel = 0
	self.plantTime = math.random(10, 50)

	self.health = 75
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
		--print("new growthSpeed: " .. self.growthSpeed)

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
		--print("new energy: " .. self.energy)

		--energy timer
		local timer_name = "treeEnergyDepletion_" .. self:EntIndex()
		--print(self.plantTime .. " homoeggs")
		timer.Create(timer_name,self.plantTime,0, function() --every (some amount) seconds, update energy status
			--print("yeah, we doing it now!1")
			chance = math.Rand(0,1)
			if IsValid(self) && !self:OnGroundNotStupidEdition(self:GetPos()) then
				--randomly make coconuts fall
				self:GetPhysicsObject():Wake()
			end
			if IsValid(self) && chance > 0.90 then
				-- autoplant functionality
				--plant itself. below copy pasted from ENT:Use()
				self:Upgrayed()
			elseif !IsValid(self) then
				timer.Remove(timer_name)
			end
			if IsValid(self) then
				self.energy = self.energy - self.plantTime
				if self.energy <= 0 then
					self.Remove()
				end
			end
		end)

	end
	--

	--if fertilizer is introduced like in SS13, then make a GetGenes...

	function ENT:PassOnInfo(setGrowthSpeed, setNumberOfFruit, setStartingEnergy, setEnergy)
		self.growthSpeed = setGrowthSpeed
		self.numberOfFruit = setNumberOfFruit
		self.startingEnergy = setStartingEnergy
		self.energy = setEnergy
	end
end --end SERVER

function ENT:Upgrayed()
	--plant the coconut
	if !self.isPlanted && self:WaterLevel() == 0 && self:OnGroundNotStupidEdition(self:GetPos()) then
		self.isPlanted = true
		--debug
		--print("growthSpeed at planting: " .. self.growthSpeed)
		--print("energy at planting: " .. self.energy)
		--print(self.isPlanted)
		--print(self.treeLevel .. " should be 0")
		--print(self:WaterLevel() .. " should be 0")

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
		newFruit.growthSpeed = self.growthSpeed
		newFruit.numberOfFruit = self.numberOfFruit
		newFruit.startingEnergy = self.startingEnergy
		newFruit.energy = newFruit.startingEnergy
		--print(newFruit.energy .. "newFruit Energy")
		
		newFruit:PassOnInfo(self.growthSpeed, self.numberOfFruit, self.startingEnergy, self.energy)
		self:Remove()
	end
end

function ENT:OnGroundNotStupidEdition(position)
	local plantable = false
	local startpos = position
	local endpos = 	startpos + Vector(0,0,-1)*10
	local tmin = Vector(1,1,1)*-5
	local tmax = Vector(1,1,1)*5
	local tr = util.TraceHull( {
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = tmin,
		maxs = tmax,
		mask = MASK_SHOT_HULL
	} )
	if not IsValid(tr.Entity) then
		tr = util.TraceLine({
			start = startpos,
			endpos = endpos,
			filter = self,
			mask = MASK_SHOT_HULL
		})
	end
	local ent = tr.Entity
	if IsValid(ent) && ent:GetClass() == "func_brush" then
		plantable = true
	end

	return plantable
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		self:Remove()
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