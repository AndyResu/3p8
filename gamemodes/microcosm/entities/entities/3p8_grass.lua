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


ENT.models = {	"models/props_foliage/swamp_grass01.mdl", "models/props_foliage/swamp_grass_row01.mdl"}

function ENT:Initialize()
	self:SetModel(self.models[math.random(#self.models)])
	self.health = 25
	self:SetModelScale( 0.01, 0) --make the model really small to start

	--[[self.grounder = 0
	--IF IT'S NOT ON THE GROUND, PUT IT ON THE GROUND. (for 128 units, or it will die)
	while(self:OnGroundNotStupidEdition(self:GetPos()) == false && self.grounder <= 128) do
		self:SetPos(self:GetPos()+Vector(0,0,-1))
		print(self:GetPos())
		self.grounder = self.grounder + 1
	end

	--only should run once ever.
	if SERVER && self:OnGroundNotStupidEdition(self:GetPos()) && self.grounder > 10 then
		self:SetPos(self:GetPos()+Vector(0,0,-14))
	end]]

	if SERVER && self:OnGroundNotStupidEdition(self:GetPos()) && self:WaterLevel() == 0 then

		--global variable for the softcap of "nature" autoplanting grass
		GLOBAL_grass = GLOBAL_grass + 1

		self.numberOfVegetables = math.random(1,4)
		self.growthTime = math.random(180, 420)
		if GLOBAL_grass < 15 then
			self.growthTime = 3 + math.random(0,4)
		end

		self.newPos = Vector(0,0,0)
		self.timer = 0

		self.chance = math.Rand(0,1)

		self.growTimer = 300

		--self:SetMaterial("models/props_wasteland/tugboat02")
		self:PhysicsInitStandard()
		self:SetSolid(0)
		self:SetMoveType(0) --0 is none, 6 is normal

		--rotate the thing to be upwards
		self:SetAngles( Angle(math.random(-5,5),math.random(-179,180),0))

		--start scaling
		self:SetModelScale( math.random(25,125)/100, self.growthTime) --grow the model over self.growthTime time. COOL!
		
		timer.Simple( self.growthTime, function ()
			if self:IsValid() then
				for i = 1,self.numberOfVegetables do
					self.newPos = self:GetPos() + Vector(math.random(-256,256),math.random(-256,256),0)
					--if self:OnGroundNotStupidEdition(self.newPos) then
					newVegeH = ents.Create("3p8_grass")
					if ( !IsValid(	newVegeH ) ) then return end
					if newVegeH:WaterLevel() == 0 then
						newVegeH:SetPos(self.newPos)
						newVegeH:Spawn()
						--print("make plant")
					else
						newVegeH:Remove()
						--print("kill plant")
					end
					--end
				end
			end
		end)

		--local phys = self:GetPhysicsObject()
		--if (phys:IsValid()) then
		--	phys:Sleep()
		--	phys:SetMass(10)
		--end

		--grass clock
		local timer_name = "grassDepletion_" .. self:EntIndex()
		timer.Create(timer_name,self.growTimer,0, function()
			self.chance = math.Rand(0,1)
			if !IsValid(self) then
				timer.Remove(timer_name)
			end
			--remove plant
			if IsValid(self) then
				self.timer = self.timer + 1
			end
			if IsValid(self) && self.timer == 2 then
				self:Remove()
				--print("timer == 2 slayer")
				--timer.Remove(timer_name)
			end
		end)
	elseif SERVER then
		self:Remove()
		--print("SLAYER")
	end
end

function ENT:OnGroundNotStupidEdition(position)
	local plantable = false
	local startpos = position + Vector(0,0,1)
	local endpos = 	startpos + Vector(0,0,-1)*11
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
		self:EmitSound("physics/wood/wood_strain4.wav")
		GLOBAL_grass = GLOBAL_grass - 1
		self:Remove()
	end
end
