--[[
	TODO: done <3
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_phx/misc/potato.mdl"

function ENT:Use(ply)
	--plant the potato
	self:Upgrayed()
	self:GetPhysicsObject():Wake()
end

function ENT:Initialize()

	self.isPlanted = false

	self.numberOfVegetables = math.random(1,4)
	self.growthTime = math.random(120, 300)

	self.headder = 0

	self.health = 75

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
		timer.Create(timer_name,600,0, function()
			chance = math.Rand(0,1)
			if !self.isPlanted && IsValid(self) && chance > 0.90 then
				-- autoplant functionality
				--plant itself.
				self:Upgrayed()
			elseif !IsValid(self) then
				timer.Remove(timer_name)
			end
			if !self.isPlanted && IsValid(self) then
				self.Remove()
				timer.Remove(timer_name)
			end
		end)
	end
end

function ENT:Upgrayed()
	--plant the potato
	if !self.isPlanted && SERVER && self:WaterLevel() == 0 && self:OnGroundNotStupidEdition(self:GetPos()) then
		self.isPlanted = true	

    	self:GetPhysicsObject():EnableCollisions(false) 

		--make sound
		self:EmitSound("phx/eggcrack.wav")

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
					newVegeH:SetPos(self:GetPos() + Vector(math.random(-6,6),math.random(-6,6),math.random(3,4)))
					newVegeH:Spawn()
				else
					newVege = ents.Create("3p8_potato_ent")
					if ( !IsValid(	newVege ) ) then return end
					newVege:SetPos(self:GetPos() + Vector(math.random(-6,6),math.random(-6,6),math.random(3,4)))
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
		self:Remove()
	end
end
