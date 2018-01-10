--[[
	3p8_kookospahkina_puu
	Uses:		It's a cononut tree.
				Grows on its own up until a certain global number.
					Players can still cultivate it further though.
	
	History:	Refactored version of the old micro_item_salainen_kookospahkina_puu (all 8 of them...)

	Memes:		puu on kaunis
				cocnut21

	Todo:		
				
	Realizations: self:SetSubMaterial(...,...) DOES NOTHING
				fancy timers and fancy genes are hard to do right... something about local vs. self?
]]



AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/hunter/misc/sphere025x025.mdl"

ENT.lastModel = {"models/props_foliage/mall_palm01_medium.mdl", "models/props_foliage/mall_palm01.mdl"}

function ENT:Use(ply)
	--plant the coconut
	if !self.isPlanted then
		self:GetPhysicsObject():Wake()
		self:Upgrayed()
	end
end

function ENT:Initialize()
	if SERVER then
		--global variable for the softcap of "nature" autoplanting coconuts
		GLOBAL_coconut = GLOBAL_coconut + 1

		self:SetMaterial("models/props_pipes/guttermetal01a")
		self:SetModel(self.ItemModel)
		self:PhysicsInitStandard()
		--self:PhysicsInit(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_VPHYSICS)
		--stop movement
		--self:SetMoveType(MOVETYPE_VPHYSICS)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			--phys:Sleep()
			--make float (bouyancy)
			phys:SetBuoyancyRatio(1.0) --0 min, 1 max (wood)
		end
		self.isPlanted = false

		self.numberOfFruitMax = 5

		self.treeLevel = 0
		--self.plantTime = math.random(10, 50)
		self.angle1 = math.random(-9,9)
		self.angle2 = math.random(-179,180)

		self.timer = 0
		self.longTimer = 0

		self.health = 75

		self.chance = math.Rand(0,1)
		self.kids = 0
		self.maxKids = 20
		self.growthTime = 60 + math.random(0,30)
		--print(GLOBAL_coconut .. " global")
		if GLOBAL_coconut <= 15 then
			self.growthTime = 3 + math.random(0,4)
			self.maxKids = 2
		end

		--energy timer
		local timer_name = "treeCoco_" .. self:EntIndex()
		--print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		--print(timer_name)
		--print("growthTime "..self.growthTime)
		--print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		timer.Create(timer_name,self.growthTime,0, function() --every (some amount) seconds, update energy status
			--print("yeah, we doing it now!1")

			self.chance = math.Rand(0,1)
			--print(self.chance)
			if IsValid(self) then
				if self:IsOnFire() then
					self:Remove()
					--timer.Remove(timer_name)
				end
				if !self.isPlanted then
					if !self:OnGroundNotStupidEdition(self:GetPos()) && self.chance > 0.5 then
						--randomly make coconuts fall
						self:GetPhysicsObject():Wake()
					end
					if self.timer == 2 then
						self:Remove()
						--timer.Remove(timer_name)
					end
					self.timer = self.timer + 1
				end
				if self.isPlanted && self.longTimer == 10 then
					self:Remove()
					--timer.Remove(timer_name)
				elseif self.isPlanted then
					self.longTimer = self.longTimer + 1
				end
				--try to autoplant, otherwise if it is planted, upgrayed
				if !self.isPlanted then
					self:Upgrayed()
				elseif self.isPlanted && GLOBAL_coconut < GLOBAL_coconut_max then
					self:Upgrayed()
				end
			elseif !IsValid(self) then
				timer.Remove(timer_name)
			end
		end)
	end
end

if SERVER then

	function ENT:OnRemove()
		GLOBAL_coconut = GLOBAL_coconut - 1
		--PrintTable( self:GetChildren() )
		if self.treeLevel >= 3 then
			--PRODUCE WOOD HERE
			puulle = ents.Create("micro_item_salainen_puulle")
			if ( !IsValid( puulle ) ) then return end
			puulle:SetPos(self:GetPos() + Vector(0,0,100))
			puulle:Spawn()

			--make a stump: kanto
			kanto = ents.Create("micro_item_salainen_kanto")
			if ( !IsValid( kanto ) ) then return end
			kanto:SetPos(self:GetPos() + Vector(0,0,0))
			kanto:Spawn()

			--make leaf gibs...
			--models/props_foliage/fern01.mdl
			--make leaves fall
			--leaf = ents.Create("prop_physics")
			--if ( !IsValid( leaf ) ) then return end
			--leaf:SetModel("models/props_foliage/fern01.mdl")
			--leaf:SetPos(self:GetPos() + Vector(0,0,128))
			--leaf:PhysicsInitStandard()
			--leaf:Spawn()
			--simple timer for like 2 seconds to destroy the new leaf(ves)
		end
	end
end --end SERVER

function ENT:Upgrayed()
	--plant the coconut
	--print("%%%%%%%%%%%%%%%%%%%%%%%%")
	--print(self.isPlanted)
	--print("treeLevel "..self.treeLevel)
	--print(self:OnGroundNotStupidEdition(self:GetPos()))
	--print("%%%%%%%%%%%%%%%%%%%%%%%%")

	if self:WaterLevel() == 0 && SERVER then
		if !self.isPlanted && self.treeLevel == 0 && self:OnGroundNotStupidEdition(self:GetPos()) then
			--autoplant section
			self.isPlanted = true
			--stop movement
			self:SetMoveType(0)
			--make sound
			--self:EmitSound("phx/eggcrack.wav")
			--go to next level
			self.treeLevel = self.treeLevel + 1 --1
			--move down to ground for the first time only
			self:SetPos(self:GetPos() + Vector(0,0,-9))
			--rotate the thing to be upwards
			self:SetAngles( Angle(self.angle1,self.angle2,0))
			--make sound
			self:EmitSound("phx/eggcrack.wav")
		elseif self.treeLevel == 1 then
			self:GetPhysicsObject():EnableCollisions(false)
			self:SetModel("models/props_foliage/urban_small_palm01.mdl")
			--PrintTable(self:GetMaterials())
			self:SetMaterial()
			self:PhysicsInitStandard()
			--self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetMoveType(0)
			self.treeLevel = self.treeLevel + 1 --2
			self.health = 250 * self.treeLevel

			--start scaling
			self:SetModelScale( 0.01, 0) --make the model really small to start
			self:SetModelScale( 1, self.growthTime) --grow the model over self.growthTime time. COOL!
		elseif self.treeLevel == 2 then
			self:GetPhysicsObject():EnableCollisions(false)
			self:SetModel("models/props_foliage/mall_palmplant02.mdl")
			--PrintTable(self:GetMaterials())
			self:SetMaterial()
			--print("bad material for leaves")
			self:PhysicsInitStandard()
			--self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetMoveType(0)
			self.treeLevel = self.treeLevel + 1 --3
			self.health = 250 * self.treeLevel
			
			--start scaling
			self:SetModelScale( 0.6, 0) --make the model small to start
			self:SetModelScale( 1.1, self.growthTime) --grow the model over self.growthTime time. COOL!
		elseif self.treeLevel == 3 then
			self:GetPhysicsObject():EnableCollisions(false)
			self:SetModel(self.lastModel[math.random(#self.lastModel)])

			self:SetMaterial()
			self:PhysicsInitStandard()
			--self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetMoveType(0)
			self.treeLevel = self.treeLevel + 1 --4
			self.health = 250 * self.treeLevel

			--start scaling
			self:SetModelScale( 0.8, 0) --make the model small to start
			self:SetModelScale( math.random(90, 120)/100, self.growthTime) --grow the model over self.growthTime time. COOL!
		elseif self.treeLevel == 4 && GLOBAL_coconut < 1.5*GLOBAL_coconut_max then
			for i = 1,math.random(1,self.numberOfFruitMax) do
				--timer.Simple( 3, function ()
				--print("making coconut again")
				newFruit = ents.Create("3p8_kookospahkina_puu")
				if ( !IsValid( newFruit ) ) then return end
				newFruit:SetPos(self:GetPos() + Vector(math.random(-12,12),math.random(-12,12),128+math.random(0,25)))
				--at position up in the tree (might need some if statements to do bearing fruit earlier/later)
					--maybe use the entity's height subtract some?
				newFruit:Spawn()
				--if self.chance >= 0.75 then
					--randomly make coconuts fall
					newFruit:GetPhysicsObject():Wake()
				--end
				self.kids = self.kids + 1
				--end)
			end
			if self.kids >= self.maxKids then
				self:Remove()
				--timer.Remove(timer_name)
			end
		end
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