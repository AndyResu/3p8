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
	if SERVER then
		--global variable for the softcap of "nature" autoplanting potatos
		GLOBAL_potato = GLOBAL_potato + 1

		self.isPlanted = false

		self.numberOfVegetables = math.random(1,4)
		self.growthTime = math.random(180, 420)
		if GLOBAL_potato <= 15 then
			self.growthTime = 3 + math.random(0,4)
		end

		self.headder = 0
		self.timer = 0
		self.longTimer = 0

		self.health = 25

		self:SetMaterial("models/props_wasteland/tugboat02")
		self:SetModel(self.ItemModel)
		self:PhysicsInitStandard()
		self:SetSolid(6)
		self:SetMoveType(6)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			--phys:Sleep()
			phys:SetMass(10)
			timer.Simple( 3, function ()
				phys:Sleep()
			end)
		end

		--potato timer
		local timer_name = "potato_" .. self:EntIndex()
		timer.Create(timer_name,self.growthTime,0, function()
			if IsValid(self) then
				if self:IsOnFire() then
					self:Remove()
				end
				if !self.isPlanted then
					--try to autoplant
					if self:OnGroundNotStupidEdition(self:GetPos()) && self:WaterLevel() == 0 then
						self:Upgrayed()
					else
						self.timer = self.timer + 1

						--seed unplanted for too long removal
						if self.timer == 1 then
							--print("Remove coconut, time " .. self:GetCreationID())
							self:Remove()
							--timer.Remove(timer_name)
						end
					end
				end
				if self.isPlanted then
					if self.longTimer == 10 then
						--death by age
						self:Remove()
					elseif self.longTimer == 5 then
						--reproduce
						if self:IsValid() then
							for i = 1,self.numberOfVegetables do
								if GLOBAL_potato < GLOBAL_potato_max then
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
								end
							end
						end
					end
					--increase age
					self.longTimer = self.longTimer + 1
				end
			elseif !IsValid(self) then
				timer.Remove(timer_name)
			end
		end)
	end
end

function ENT:Upgrayed()
	--plant the potato
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
end

function ENT:OnGroundNotStupidEdition(position)
	local plantable = false
	local startpos = position
	local endpos = 	startpos + Vector(0,0,-1)*5
	local tmin = Vector(1,1,1)*-5
	local tmax = Vector(1,1,1)*5
	local tr = util.TraceHull( {
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = tmin,
		maxs = tmax,
		mask = MASK_ALL
	} )
	if not IsValid(tr.Entity) then
		tr = util.TraceLine({
			start = startpos,
			endpos = endpos,
			filter = self,
			mask = MASK_ALL
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
		--print("Remove potato, dmg " .. self:GetCreationID())
		self:Remove()
	end
end
