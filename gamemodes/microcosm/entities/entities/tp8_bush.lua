--[[
	tp8_bush
	TODO:	
	models/props_foliage/grass3.mdl
	models/props_foliage/grass_cluster01.mdl
	models/props_foliage/grass_cluster01a.mdl
	models/props_foliage/swamp_grass01.mdl
	models/props_foliage/swamp_grass_row01.mdl

	Flowers:
	models/props_foliage/potted_plant1_p1.mdl --dirt --CS:S
	models/props_foliage/potted_plant2.mdl --pot --CS:S
	models/props_foliage/potted_plant3.mdl --pot --CS:S
	
	Bushes:
	models/props_foliage/urban_bigplant01.mdl
	models/props_foliage/mall_bigleaves_plant01_medium.mdl
	models/props_foliage/mall_bigleaves_plant01.mdl
	models/props_foliage/mall_bigleaves_plant03.mdl

	HAS DIRT BALL!
	models/props_foliage/mall_big_plant01_dirt.mdl
	models/props_foliage/mall_bigleaves_plant03_dirt.mdl --make bigger?
	possible grass replacement? models/props_foliage/mall_grass_bush01_dirt.mdl
	
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "tp8_tree"

ENT.seedModel = "models/hunter/plates/plate.mdl"
ENT.models = {	"models/props_foliage/urban_bigplant01.mdl", "models/props_foliage/mall_bigleaves_plant01_medium.mdl", "models/props_foliage/mall_bigleaves_plant01.mdl"}

function ENT:Initialize()
	if CLIENT then return end
	GLOBAL_bush = GLOBAL_bush + 1

	self:SetModel(self.seedModel)
	self:SetMaterial("models/alyx/hairbits")
	self.health = 25
	self.isPlanted = false

	--self:PhysicsInitStandard()
	self:SetMoveType(0)

	self.numberOfFruitMax = 1

	self.treeLevel = 0
	--self.plantTime = math.random(10, 50)
	self.angle1 = math.random(-4,4) --pitch
	self.angle2 = math.random(-179,180) --yaw

	self.timer = 0
	self.fruitLifeExpectancy = 1
	self.longTimer = 0
	self.lifeExpectancy = 10

	self.kids = 0
	self.maxKids = 20
	self.growthTime = 1 + (GLOBAL_bush / GLOBAL_bush_max)*(60 + math.random(0,60))

	self.minSize = 90
	self.maxSize = 250

	self.entName = "tp8_bush"
	-- if GLOBAL_bush <= 100 then
	-- 	self.growthTime = 1 + math.random(0,9)
	-- 	self.maxKids = 100
	-- end
	self.heightOfTree = 5

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

	--grass timer
	local timer_name = "bush_" .. self:EntIndex()
	timer.Create(timer_name,self.growthTime,0, function()
		if IsValid(self) then
			if self:IsOnFire() then
				self:Remove()
			end
			if !self.isPlanted then
				if self.timer == self.fruitLifeExpectancy then
					self:Remove()
				end
				self.timer = self.timer + 1
			end
			if self.isPlanted && self.longTimer >= self.lifeExpectancy then
				self:Remove()
			elseif self.isPlanted then
				self.longTimer = self.longTimer + 1
			end
			--try to autoplant, otherwise if it is planted, upgrayed
			if !self.isPlanted then
				--self:Upgrayed()
				self:lookForAValidPlantPositionAndSendSelfThere(self:GetPos())
			elseif self.isPlanted && GLOBAL_bush < GLOBAL_bush_max then
				self:Upgrayed()
			end
		elseif !IsValid(self) then
			timer.Remove(timer_name)
		end
	end)
end

function ENT:Upgrayed()
	if self.treeLevel == 0 --[[&& self:OnGroundNotStupidEdition(self:GetPos())]] then
		--plant the seed
		self.isPlanted = true
		local coords = self:GetPos()
		local xPos = math.floor(coords.x / GLOBAL_divisionsXY)
		local yPos = math.floor(coords.y / GLOBAL_divisionsXY)
		local zPos = math.floor(coords.z / GLOBAL_divisionsZ)
		GLOBAL_bushGrid[xPos][yPos][zPos] = GLOBAL_bushGrid[xPos][yPos][zPos] - 1
		self:SetModel(self.models[math.random(#self.models)])
		self:SetModelScale( 0.01, 0) --make the model really small to start
		self:SetMaterial() --should set the material to the model's material
		--rotate the thing to be upwards
		self:SetAngles( Angle(self.angle1,self.angle2,0))
		self.treeLevel = self.treeLevel + 1 --1
		--start scaling
		self:SetModelScale( math.random(self.minSize,self.maxSize)/100, self.growthTime) --grow the model over self.growthTime time. COOL!
	elseif self.treeLevel == 1 && self.longTimer < 0.75*self.lifeExpectancy then
		--rebroduce
		for i = 1,math.random(1,self.numberOfFruitMax) do
			newFruit = ents.Create(self.entName)
			if ( !IsValid( newFruit ) ) then return end
			newFruit:SetPos(self:GetPos() + Vector(math.random(-24,24),math.random(-24,24),self.heightOfTree))
			newFruit:SetAngles(Angle(math.random(-5,5),math.random(-179,180),0))
			newFruit:Spawn()
			self.kids = self.kids + 1
		end
		if self.kids >= self.maxKids then
			self:Remove()
		end
	end
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
	--check surrounding XY spots for > 0 value
		--can grow up/down on a slope this way... the tree would go above or below the height threshold
	local i = 1
	for dx=-1,1 do 
		for dy=-1,1 do 
			for dz=-1,1 do 
				if 	xPos+dx >= GLOBAL_bushXYMin && xPos+dx < GLOBAL_bushXYMax && 
					yPos+dy >= GLOBAL_bushXYMin && yPos+dy < GLOBAL_bushXYMax && 
					zPos+dz >= GLOBAL_bushZMin && zPos+dz < GLOBAL_bushZMax && 
					GLOBAL_bushGrid[xPos+dx][yPos+dy][zPos+dz] > 0 && self:hasAValidPosition(dx,dy,dz, xPos, yPos, zPos) then
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

if SERVER then
	function ENT:OnRemove()
		GLOBAL_bush = GLOBAL_bush - 1
			
		if (self.isPlanted) then
			local coords = self:GetPos()
			local xPos = math.floor(coords.x / GLOBAL_divisionsXY)
			local yPos = math.floor(coords.y / GLOBAL_divisionsXY)
			local zPos = math.floor(coords.z / GLOBAL_divisionsZ)
			GLOBAL_bushGrid[xPos][yPos][zPos] = GLOBAL_bushGrid[xPos][yPos][zPos] + 1
		end
	end
end
