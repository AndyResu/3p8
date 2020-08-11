--[[
	tp8_tree
	Uses:		It's a tree.
				Grows on its own up until a certain global number.
	
	History:	Refactored version of the old micro_item_salainen_kookospahkina_puu (all 8 of them...)
				Revised to work on a grid instead from 3p8_kookospahkina_puu

	Memes:		

	Todo:		ctrl+f TODO
				also, if want change fruit / tree
					GLOBAL_tree
					GLOBAL_tree_max
					GLOBAL_forest
					GLOBAL_coconut
					GLOBAL_coconut_max
				
	Realizations: self:SetSubMaterial(...,...) DOES NOTHING
				fancy timers and fancy genes are hard to do right... something about local vs. self?
				OnGroundNotStupidEdition may only be used for error checking. Might be optimized without it.
					Might not need the water check either.
					appearently useful for grass. Sometimes grass seeds would setpos off the map
				self:PhysicsInitStandard() caused the ghost log error!!!
					Also is a large source of lag!
				set angles by the angles the trace hits?
				1/500 chance of doing a bird call?
]]



AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/hunter/misc/sphere025x025.mdl"
ENT.secondModel = {"models/props_foliage/urban_small_palm01.mdl"}
ENT.thirdModel = {"models/props_foliage/mall_palmplant02.mdl"}
ENT.lastModel = {"models/props_foliage/mall_palm01_medium.mdl", "models/props_foliage/mall_palm01.mdl"}
ENT.entName = "tp8_tree"
ENT.fruitDistance = 12
ENT.heightOfTree = 128

function ENT:Initialize()
	if SERVER then
		--global variable for the softcap of "nature" autoplanting coconuts
		GLOBAL_tree = GLOBAL_tree + 1

		self:SetMaterial("models/props_pipes/guttermetal01a")
		self:SetModel(self.ItemModel)
		self:PhysicsInitStandard()
		self:SetMoveType(0)
		local phys = self:GetPhysicsObject()
		phys:Sleep()
		if (phys:IsValid()) then
			phys:SetBuoyancyRatio(1.0) --0 min, 1 max (wood)
		end
		self.isPlanted = false

		self.numberOfFruitMax = 1

		self.treeLevel = 0
		--self.plantTime = math.random(10, 50)
		self.angle1 = math.random(-9,9) --pitch
		self.angle2 = math.random(-179,180) --yaw

		self.timer = 0
		self.fruitLifeExpectancy = 1
		self.longTimer = 0
		self.lifeExpectancy = 15

		self.health = 75

		self.kids = 0
		self.maxKids = 20
		self.growthTime = 1 + (GLOBAL_tree / GLOBAL_tree_max)*(60 + math.random(0,60))

		--print(GLOBAL_coconut .. " global")
		-- if GLOBAL_tree <= 100 then
		-- 	self.growthTime = 1 + math.random(0,9)
		-- 	self.maxKids = 100
		-- end

		--used these rather than local variables because not sure if local variables screw things up
		self.testVal = 0
		self.randoPos = Vector(0,0,0)
		self.done = false
		self.xDelta = 0
		self.yDelta = 0
		self.zDelta = 0
		self.randoArray = {}
		self.randoPosAr = {}
		self.newX = 0
		self.newY = 0
		self.newZ = 0
		self.tr = nil

		--energy timer
		local timer_name = "tree_" .. self:EntIndex()
		--print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		--print(timer_name)
		--print("growthTime "..self.growthTime)
		--print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		timer.Create(timer_name,self.growthTime,0, function() --every (some amount) seconds, update energy status
			--print("yeah, we doing it now!1")
			if IsValid(self) then
				-- if self:IsOnFire() then
				-- 	--print("Remove coconut, fire " .. self:GetCreationID())
				-- 	self:Remove()
				-- 	--timer.Remove(timer_name)
				-- end
				if !self.isPlanted then
					--if self.chance > 0.5 then
						--try plant self in an adjacent square of the forest
						--self:lookForAValidPlantPositionAndSendSelfThere(self:GetPos())
						-- do not plant through this, let upgrayed do that?
					--end
					if self.timer == self.fruitLifeExpectancy then
						--print("Remove coconut, time " .. self:GetCreationID())
						self:Remove()
						--timer.Remove(timer_name)
					end
					self.timer = self.timer + 1
				end
				if self.isPlanted && self.longTimer >= self.lifeExpectancy then
					--print("Remove tree, long timer " .. self:GetCreationID())
					self:Remove()
					--timer.Remove(timer_name)
				elseif self.isPlanted then
					self.longTimer = self.longTimer + 1
				end
				--try to autoplant, otherwise if it is planted, upgrayed
				if !self.isPlanted then
					--self:Upgrayed()
					self:lookForAValidPlantPositionAndSendSelfThere(self:GetPos())
				elseif self.isPlanted && GLOBAL_tree < GLOBAL_tree_max then
					self:Upgrayed()
				end
			elseif !IsValid(self) then
				--print("Remove fruit, the timer itself " .. self:GetCreationID())
				timer.Remove(timer_name)
			end
		end)
	end
end

if SERVER then

	function ENT:OnRemove()
		GLOBAL_tree = GLOBAL_tree - 1
		
		if (self.isPlanted) then
			local coords = self:GetPos()
			local xPos = math.floor(coords.x / GLOBAL_divisionsXY)
			local yPos = math.floor(coords.y / GLOBAL_divisionsXY)
			local zPos = math.floor(coords.z / GLOBAL_divisionsZ)
			GLOBAL_forest[xPos][yPos][zPos] = GLOBAL_forest[xPos][yPos][zPos] + 1
			--print("+1 At "..xPos..", "..yPos..", "..zPos.." : "..GLOBAL_forest[xPos][yPos][zPos])
		end

		if self.treeLevel >= 3 then
			--make a stump: kanto
			kanto = ents.Create("micro_item_salainen_kanto")
			if ( !IsValid( kanto ) ) then return end
			kanto:SetPos(self:GetPos())
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

	if SERVER then
		if !self.isPlanted && self.treeLevel == 0 --[[&& self:OnGroundNotStupidEdition(self:GetPos())]] --[[&& self:WaterLevel() == 0]] then
			--autoplant section
			self.isPlanted = true
			--decrement the forest's value
			local coords = self:GetPos()
			local xPos = math.floor(coords.x / GLOBAL_divisionsXY)
			local yPos = math.floor(coords.y / GLOBAL_divisionsXY)
			local zPos = math.floor(coords.z / GLOBAL_divisionsZ)
			GLOBAL_forest[xPos][yPos][zPos] = GLOBAL_forest[xPos][yPos][zPos] - 1
			--print("-1 At "..xPos..", "..yPos..", "..zPos.." : "..GLOBAL_forest[xPos][yPos][zPos])
			--stop movement
			self:SetMoveType(0)
			--go to next level
			self.treeLevel = self.treeLevel + 1 --1
			--rotate the thing to be upwards
			self:SetAngles( Angle(self.angle1,self.angle2,0))
			--make sound
			self:EmitSound("phx/eggcrack.wav")
		elseif self.treeLevel == 1 then
			self:GetPhysicsObject():EnableCollisions(false)
			self:SetModel(self.secondModel[math.random(#self.secondModel)])
			self:SetMaterial()
			--self:PhysicsInitStandard()
			--self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetMoveType(0)
			self.treeLevel = self.treeLevel + 1 --2
			self.health = 250 * self.treeLevel

			--start scaling
			self:SetModelScale( 0.01, 0) --make the model really small to start
			self:SetModelScale( 1, self.growthTime) --grow the model over self.growthTime time. COOL!
		elseif self.treeLevel == 2 then
			self:GetPhysicsObject():EnableCollisions(false)
			self:SetModel(self.thirdModel[math.random(#self.thirdModel)])
			self:SetMaterial()
			--self:PhysicsInitStandard()
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
			--self:PhysicsInitStandard()
			--self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetMoveType(0)
			self.treeLevel = self.treeLevel + 1 --4
			self.health = 250 * self.treeLevel

			--start scaling
			self:SetModelScale( 0.8, 0) --make the model small to start
			self:SetModelScale( math.random(100, 130)/100, self.growthTime) --grow the model over self.growthTime time. COOL!
		elseif self.treeLevel == 4 && GLOBAL_coconut < 1.5*GLOBAL_coconut_max && self.longTimer < 0.75*self.lifeExpectancy then
			for i = 1,math.random(1,self.numberOfFruitMax) do
				--timer.Simple( 3, function ()
				newFruit = ents.Create(self.entName)
				if ( !IsValid( newFruit ) ) then return end
				newFruit:SetPos(self:GetPos() + Vector(math.random(-self.fruitDistance,self.fruitDistance),math.random(-self.fruitDistance,self.fruitDistance),self.heightOfTree+math.random(0,25)))
				--at position up in the tree (might need some if statements to do bearing fruit earlier/later)
					--maybe use the entity's height subtract some?
				newFruit:Spawn()
				self.kids = self.kids + 1
			end
			if self.kids >= self.maxKids then
				self:Remove()
				--GLOBAL_tree = GLOBAL_tree - 1
				--timer.Remove(timer_name)
			end
		end
	end
end

function ENT:OnGroundNotStupidEdition(position)
	local plantable = false
	local startpos = position
	local endpos = 	startpos + Vector(0,0,-1)*5 --5 is the length here, the others are widths of beam
	local tmin = Vector(1,1,1)*-3
	local tmax = Vector(1,1,1)*3
	local tr = util.TraceHull( {
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = tmin,
		maxs = tmax,
		--mask = MASK_ALL
	} )
	if not IsValid(tr.Entity) then
		tr = util.TraceLine({
			start = startpos,
			endpos = endpos,
			filter = self,
			--mask = MASK_ALL
		})
	end
	local ent = tr.Entity
	if IsValid(ent) && ent:GetClass() == "func_brush" then
		plantable = true
	end

	return plantable
end

function ENT:canBeSeenFrom(position, endPosition)
	local plantable = false
	local startpos = position
	local endpos = endPosition
	local tmin = Vector(1,1,1)*-5
	local tmax = Vector(1,1,1)*5
	local tr = util.TraceHull( {
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = tmin,
		maxs = tmax,
		--mask = MASK_ALL
	} )
	if not IsValid(tr.Entity) then
		tr = util.TraceLine({
			start = startpos,
			endpos = endpos,
			filter = self,
			--mask = MASK_ALL
		})
	end
	local ent = tr.Entity
	if IsValid(ent) && ent:GetClass() == "func_brush" then
		plantable = true
		--print("We can plant! "..endpos.x..", "..endpos.y..", "..endpos.z)
		self.tr = endpos.z
	end
	return plantable
end

function ENT:hasAValidPosition(dx, dy, dz, xPos, yPos, zPos)
	local isGood = false
	self.randoPos = Vector(0,0,0)
	self.newX = xPos + dx
	self.newY = yPos + dy
	self.newZ = zPos + dz
	--min = length of each square * newX or newY
	local xMin = GLOBAL_divisionsXY * self.newX
	--max = length of each square * ((newX or newY)+1)
	local xMax = GLOBAL_divisionsXY * (self.newX+1)
	local yMin = GLOBAL_divisionsXY * self.newY
	local yMax = GLOBAL_divisionsXY * (self.newY+1)
	local zMin = GLOBAL_divisionsZ * self.newZ
	local zMax = GLOBAL_divisionsZ * (self.newZ+1)
	self.done = false
	for i=1,10 do
		if !self.done then
			--generate random positions within other forest square
			self.randoPos = Vector(math.random(xMin,xMax),math.random(yMin,yMax),(self.newZ)*GLOBAL_divisionsZ) --[[math.random(zMin,zMax)]] --[[(zPos)*GLOBAL_divisionsZ]]
			--print("Startpos: "..self:GetPos())
			--print("Endpos: "..self.randoPos.x..", "..self.randoPos.y..", "..self.randoPos.z)
			if(self:canBeSeenFrom(self:GetPos(), self.randoPos)) && self:OnGroundNotStupidEdition(self.randoPos) then
				isGood = true
				self.done = true
				self.randoPos.z = self.tr
			end
		end
	end
	return isGood
end

function ENT:lookForAValidPlantPositionAndSendSelfThere(coords)
	--follows the numpad order
	for i=1,27 do
		self.randoArray[i] = 0
		self.randoPosAr[i] = Vector(0,0,0)
	end
	--get current tree pos in terms of self.globalForest
	local xPos = math.floor(coords.x / GLOBAL_divisionsXY)
	local yPos = math.floor(coords.y / GLOBAL_divisionsXY)
	local zPos = math.floor(coords.z / GLOBAL_divisionsZ)
	--print("Global Forest Pos: "..xPos..", "..yPos..", "..zPos)
	--print("There is room for: "..GLOBAL_forest[xPos][yPos][zPos].." here.")
	--check surrounding XY spots for > 0 value
		--can grow up/down on a slope this way... the tree would go above or below the height threshold
	--print("xPos: "..xPos)
	--print("yPos: "..yPos)
	--print("GLOBAL_forestXYMin: "..GLOBAL_forestXYMin)
	local i = 1
	for dx=-1,1 do 
		for dy=-1,1 do 
			for dz=-1,1 do 
				if 	xPos+dx >= GLOBAL_forestXYMin && xPos+dx < GLOBAL_forestXYMax && 
					yPos+dy >= GLOBAL_forestXYMin && yPos+dy < GLOBAL_forestXYMax && 
					zPos+dz >= GLOBAL_forestZMin && zPos+dz < GLOBAL_forestZMax && 
					GLOBAL_forest[xPos+dx][yPos+dy][zPos+dz] > 0 && self:hasAValidPosition(dx,dy,dz, xPos, yPos, zPos) then
					self.randoArray[i] = 1
					self.randoPosAr[i] = self.randoPos
				end
				i = i+1
			end
		end
	end

	local containsAOne = false
	for i=1,27 do
		if (self.randoArray[i] == 1) then containsAOne = true end
	end
	--pick a random value in self.randoArray to pick the cube to plant the tree in
	if containsAOne then 
		local valid = false
		self.testVal = 0
		while !valid do
			self.testVal = math.random(27)
			if self.randoArray[self.testVal] == 1 then
				valid = true
			end
		end
		-- print("Direction going: "..self.testVal)
	
		local x = self.randoPosAr[self.testVal].x
		local y = self.randoPosAr[self.testVal].y
		local z = self.randoPosAr[self.testVal].z
		--plant self at the TRACE'S x, y, z
		self:SetPos(Vector(x, y, z))
		self:Upgrayed()
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		
		--print("Remove coconut, dmg " .. self:GetCreationID())
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