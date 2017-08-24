AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_wasteland/laundry_washer001a.mdl"

--models for when the tree dies, but the trunk was not cut down?
	--live trees drop 0, 1, 2 acorns...

--sprout phase
--models/props_foliage/grass3.mdl
--models/props_foliage/bush2.mdl
--models/props_foliage/mall_bigleaves_plant03_medium.mdl
--models/props_foliage/mall_bigleaves_plant03.mdl

--childhood
--models/props_foliage/urban_tree01_small.mdl
--models/props_foliage/urban_tree01_medium.mdl
--models/props_foliage/urban_tree01.mdl

--maturity
--models/props_foliage/mall_tree_medium01.mdl
--models/props_foliage/mall_tree_large01.mdl
	--dead model
		--models/props_foliage/tree_city01.mdl

--from here, lots of trees can be used :D

--models/props_foliage/urban_tree_giant01_small.mdl
	--dead model? (chance to die after every growth stage)
		--models/props_foliage/swamp_cypress_stump01.mdl
--models/props_foliage/urban_tree_giant01_medium.mdl
--models/props_foliage/urban_tree_giant_dario.mdl OR models/props_foliage/urban_tree_giant01_a.mdl
	--dead model
		--models/props_foliage/old_tree01.mdl
	--cut model
		--models/props_foliage/tree_trunk_fallen.mdl

--broken trunks
--models/props_foliage/tree_trunk_fallen.mdl --stick up in ground
--models/props_foliage/tree_stump01.mdl --good old stump

--giant ass swamp tree
--models/props_foliage/swamp_cypress_large01_grnd.mdl

--death weed
--models/props_foliage/swamp_cypress_knee01.mdl
--models/props_foliage/swamp_cypress_knee02.mdl

--leaves that fall from tree
--models/props_foliage/bush2.mdl

--need to make a bush
--flowers

--way to get Stick swep...

--cool vines... for a root system
--models/props_foliage/urban_vine04.mdl

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
	self.treeLevel = 0
	self.plantTime = math.random(10, 50)

	self.health = 75
end

function ENT:Upgrayed()
	--plant the coconut
	if !self.isPlanted && self:WaterLevel() == 0 && self:OnGroundNotStupidEdition(self:GetPos()) then
		self.isPlanted = true

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