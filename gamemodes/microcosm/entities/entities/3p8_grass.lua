--[[
	3p8_grass
	TODO:	
	models/props_foliage/grass3.mdl
	models/props_foliage/grass_cluster01.mdl
	models/props_foliage/grass_cluster01a.mdl
	models/props_foliage/swamp_grass01.mdl
	models/props_foliage/swamp_grass_row01.mdl
	
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.seedModel = "models/space/unit_sphere.mdl"
ENT.models = {	"models/props_foliage/swamp_grass01.mdl", "models/props_foliage/swamp_grass_row01.mdl"}
--ENT.meme = nil

function ENT:Initialize()
	if CLIENT then return end
	GLOBAL_grass = GLOBAL_grass + 1

	self:SetModel(self.seedModel)
	self:SetMaterial("models/alyx/hairbits")
	self.health = 25
	self.isPlanted = false

	self.timer = 0
	self.longTimer = 0

	self:PhysicsInitStandard()

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		--phys:Sleep()
		--make float (bouyancy)
		phys:SetBuoyancyRatio(1.0) --0 min, 1 max (wood)

		timer.Simple( 3, function ()
			phys:Sleep()
		end)
	end



	self.numberOfVegetables = math.random(1,4)
	self.growthTime = math.random(30, 90)
	if GLOBAL_grass < 15 then
		self.growthTime = 3 + math.random(0,4)
	end

	self.newPos = Vector(0,0,0)
	self.chance = math.Rand(0,1)

	--grass timer
	local timer_name = "grass_" .. self:EntIndex()
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
				elseif self.longTimer%4 == 0 then
					--reproduce
					if self:IsValid() then
						for i = 1,self.numberOfVegetables do
							if GLOBAL_grass < GLOBAL_grass_max then
								self.newPos = self:GetPos() + Vector(math.random(-384,384),math.random(-384,384),32)
								newVegeH = ents.Create("3p8_grass")
								if ( !IsValid(	newVegeH ) ) then return end
								newVegeH:SetPos(self.newPos)
								newVegeH:Spawn()
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

function ENT:OnGroundNotStupidEdition(position)
	local plantable = false
	local startpos = position + Vector(0,0,1)
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
		self:EmitSound("physics/wood/wood_strain4.wav")
		GLOBAL_grass = GLOBAL_grass - 1
		self:Remove()

	end
end

function ENT:Use(ply)
	--plant the seed
	--[[if SERVER && !self.isPlanted && self:OnGroundNotStupidEdition(self:GetPos()) && self:WaterLevel() == 0 then
		self:Upgrayed()
	end]]
end

function ENT:Upgrayed()
	--plant the seed
	self.isPlanted = true
	self:SetPos(self:GetPos() + Vector(0,0,-2))
	self:SetModel(self.models[math.random(#self.models)])
	self:SetModelScale( 0.01, 0) --make the model really small to start
	self:SetMaterial() --should set the material to the model's material
	self:SetMoveType(0)
	self:SetSolid(0)
	--rotate the thing to be upwards
	self:SetAngles( Angle(math.random(-5,5),math.random(-179,180),0))

	--start scaling
	self:SetModelScale( math.random(25,125)/100, self.growthTime) --grow the model over self.growthTime time. COOL!

	--make invis grass "mound"
	--dirt = ents.Create("prop_physics")
	--if ( !IsValid(	dirt ) ) then return end
	----dirt:PhysicsInitStandard()
	--dirt:SetModel("models/hunter/plates/plate3x3.mdl")
	----dirt:SetColor(Color(0,0,0,0)) --make invis
	--dirt:SetPos(self:GetPos() + Vector(0,0,1))
	--dirt:Spawn()
	--dirt:SetMoveType(0)
	----dirt:SetSolid(0)
	--self.meme = dirt
end

function ENT:OnRemove()
	--if SERVER && IsValid(self.meme) then
	--	self.meme:Remove() --remove dirt
	--end
end
