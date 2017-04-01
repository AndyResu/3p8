--shameless copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--puu on kaunis

AddCSLuaFile()

ENT.Base = "micro_item_salainen"

--ENT.ItemName = "Kookospahkina Puu"
ENT.ItemModel = "models/props_foliage/mall_palmplant02.mdl"
--ENT.MaxCount = 1

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(0)
	self.treeLevel = 5
	self.hasLeveled = false

	self.growthSpeed = 105
	self.numberOfFruit = 2
	self.startingEnergy = 10000
	self.energy = self.startingEnergy

	self.health = 250 * self.treeLevel

	self:SetCollisionBounds(Vector(-5,-5,0), Vector(5,5,140))
	self:SetSolid(3)
end

if SERVER then
	function ENT:Think()
		if !self.hasLeveled then
			self.hasLeveled = true
			timer.Simple( self.growthSpeed, function() 
				newFruit = ents.Create("micro_item_salainen_kookospahkina_puu" .. (self.treeLevel + 1))
				if ( !IsValid( newFruit ) ) then return end
				newFruit:SetPos(self:GetPos())
				--set new values for growth speed and gestation or w/e on new entity
				newFruit:Spawn()
				newFruit:PassOnInfo(self.growthSpeed, self.numberOfFruit, self.startingEnergy, self.energy)
				self:Remove()
			end )
		end
		
	end

	function ENT:PassOnInfo(setGrowthSpeed, setNumberOfFruit, setStartingEnergy, setEnergy)
		self.growthSpeed = setGrowthSpeed
		self.numberOfFruit = setNumberOfFruit
		self.startingEnergy = setStartingEnergy
		self.energy = setEnergy

		--energy timer
		local timer_name = "treeEnergyDepletion_" .. self:EntIndex()
		timer.Create(timer_name,100,0, function() --every 100s, update energy status
			if IsValid(self)then
				self.energy = self.energy - ((100 / self.growthSpeed) + 0) + 100*self.treeLevel --wew?
				--print(self.energy)
				if self.energy <= 0 then --KILL FUNCTION; SLAYER
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