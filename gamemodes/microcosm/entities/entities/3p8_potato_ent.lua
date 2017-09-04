--[[
	3p8_potato_ent
	TODO:	--predator?
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_phx/misc/potato.mdl"

function ENT:Use(ply)
	--plant the potato
	self:Upgrayed()
	self:GetPhysicsObject():Wake()
	--make sound
	self:EmitSound("phx/eggcrack.wav")
end

function ENT:Initialize()
	--global variable for the softcap of "nature" autoplanting potatos
	GLOBAL_potato = GLOBAL_potato + 1

	self.isPlanted = false

	self.numberOfVegetables = math.random(1,4)
	self.growthTime = math.random(180, 420)

	self.headder = 0
	self.timer = 0

	self.health = 25

	self.chance = math.Rand(0,1)

	self.growTimer = 300

	if SERVER then
		self:SetMaterial("models/props_wasteland/tugboat02")
		self:SetModel(self.ItemModel)
		self:PhysicsInitStandard()
		self:SetSolid(6)
		self:SetMoveType(6)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
			phys:SetMass(10)
		end

		--potato clock
		local timer_name = "potatoDepletion_" .. self:EntIndex()
		timer.Create(timer_name,self.growTimer,0, function()
			self.chance = math.Rand(0,1)
			-- autoplant functionality
			if IsValid(self) && !self.isPlanted && self.chance > 0.35 && GLOBAL_potato < GLOBAL_potato_max then
				--plant itself.
				self:Upgrayed()
			elseif !IsValid(self) then
				timer.Remove(timer_name)
			end
			--remove potato
			if IsValid(self) && !self.isPlanted then
				self:Remove()
				--timer.Remove(timer_name)
			end
			--remove plant
			if IsValid(self) then
				self.timer = self.timer + 1
			end
			if IsValid(self) && self.isPlanted && self.timer == 2 then
				self:Remove()
				--timer.Remove(timer_name)
			end
		end)
		if GLOBAL_potato <= 15 then
			timer.Simple( math.random(3,7), function ()
				self:Upgrayed()
			end)
		end
	end
end

function ENT:Upgrayed()
	--plant the potato
	if !self.isPlanted && SERVER && self:WaterLevel() == 0 && self:OnGroundNotStupidEdition(self:GetPos()) then
		self.isPlanted = true	

    	self:GetPhysicsObject():EnableCollisions(false) 

		--make sound
		--self:EmitSound("phx/eggcrack.wav")

		--change to plant model
		self:SetMaterial("models/props_foliage/mall_trees_branches01")
		self:SetModel("models/props_foliage/mall_big_plant01.mdl")
		self:PhysicsInitStandard()
		self:SetSolid(6) --SOLID_VPHYSICS
		--stop movement
		self:SetMoveType(0)

		--move plant down just a little.
		self:SetPos(self:GetPos() + Vector(0,0,-2))
		--rotate the thing to be upwards
		self:SetAngles( Angle(math.random(-9,9),math.random(-179,180),0))

		--start scaling
		self:SetModelScale( 0.01, 0) --make the model really small to start
		self:SetModelScale( math.random(50,80)/100, self.growthTime) --grow the model over self.growthTime time. COOL!
		
		timer.Simple( self.growthTime, function ()
			for i = 1,self.numberOfVegetables do
				self.headder = math.random(1,1000)
				if self.headder >= 1000 then
					newVegeH = ents.Create("3p8_potato_head")
					if ( !IsValid(	newVegeH ) ) then return end
					newVegeH:SetPos(self:GetPos() + Vector(math.random(-32,32),math.random(-32,32),math.random(4,5)))
					newVegeH:Spawn()
				else
					newVege = ents.Create("3p8_potato_ent")
					if ( !IsValid(	newVege ) ) then return end
					newVege:SetPos(self:GetPos() + Vector(math.random(-32,32),math.random(-32,32),math.random(4,5)))
					newVege:Spawn()
				end
			end
		end)
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
		self:EmitSound("ambient/levels/canals/toxic_slime_gurgle2.wav")
		GLOBAL_potato = GLOBAL_potato - 1
		self:Remove()
	end
end
