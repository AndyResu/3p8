--[[

	the fire can

todo:	make this be crafted... not spawn as is...


possible material:
models/props_c17/oil_drum_chunks001a --hides the lower part...

generator
models/props_vehicles/generatortrailer01.mdl

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ComponentModel = "models/props_c17/oildrum001.mdl"

function ENT:Initialize()
	self:SetModel(self.ComponentModel)
	self:SetMaterial("models/props_lab/airlock_laser")
	self:PhysicsInitStandard()

	--scaling up means the hitbox is bigger than the parented props...
	self:SetModelScale(1.05, 0)

	if SERVER then
		--the barrel that you see.
		cosmetic = ents.Create("prop_physics")
		if ( !IsValid( cosmetic ) ) then return end
		cosmetic:SetPos(self:GetPos())
		cosmetic:SetModel("models/props_phx/empty_barrel.mdl")
		cosmetic:SetMaterial("models/props_c17/oil_drum001a")
		cosmetic:Spawn()
		cosmetic:GetPhysicsObject():EnableMotion(false)
		cosmetic:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		--the trash
		trash = ents.Create("prop_physics")
		if ( !IsValid( trash ) ) then return end
		trash:SetPos(self:GetPos() + Vector(0,0,28))
		trash:SetAngles(Angle(90,0,0))
		trash:SetModel("models/XQM/cylinderx1medium.mdl")
		trash:SetMaterial("models/props_junk/garbage001a_01")
		trash:Spawn()
		trash:GetPhysicsObject():EnableMotion(false)
		trash:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		--the can to ignite
		can = ents.Create("prop_physics")
		if ( !IsValid( can ) ) then return end
		can:SetPos(self:GetPos() + Vector(0,0,40))
		can:SetModel("models/props_junk/garbage_metalcan002a.mdl")
		can:Ignite(999999, 0) --ignite forever?
		can:Spawn()
		can:GetPhysicsObject():EnableMotion(false)
		can:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		self:GetPhysicsObject():EnableMotion(false)

		self:SetSolid(3)
	end
	self.health = 750
end

function ENT:OnTakeDamage(damageto)
	if damageto:GetDamageType() != DMG_BURN then
		self.health = self.health - damageto:GetDamage()
		if self.health <= 0 then
			self:EmitSound("weapons/debris1.wav")
			--PRODUCE gibs HERE
			for i = 1,math.random(1,3) do
				gib = ents.Create("3p8_metal")
				if ( !IsValid( gib ) ) then return end
				gib:SetPos(self:GetPos() + Vector(math.random(-10,10),math.random(-10,10),math.random(20,40)))
				gib:Ignite(math.random(2,6), 0)
				gib:Spawn()
			end

			--ALSO REMOVE CHILDREN!
			cosmetic:Remove()
			trash:Remove()
			can:Remove()
			self:Remove()
		end
	end
	
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	if class == "3p8_rock_s" then
		data.HitEntity:Remove()
		self:EmitSound("ambient/levels/canals/headcrab_canister_ambient4.wav")

		--produce metal part
		metal = ents.Create("3p8_metal")
		if ( !IsValid( metal ) ) then return end
		metal:SetPos(self:GetPos() + Vector(0,0,64))
		metal:SetAngles(Angle(90, math.random(-179, 180), 0))
		metal:Ignite(math.random(2,6), 0)
		metal:Spawn()
	elseif class == "prop_physics" then
		data.HitEntity:Ignite(5,102)
	elseif class == "micro_item_salainen_puulle" then
		data.HitEntity:Ignite(5,102)
	end
end

--nothing below is ever used
function ENT:GetItemSpawn()
	return self:GetPos()+Vector(32,32,24)
end

function ENT:CheckBlocked()
	local r = 18
	local tr = util.TraceHull{start=self:GetItemSpawn(),endpos=self:GetItemSpawn(),mins=Vector(-1,-1,-1)*r, maxs=Vector(1,1,1)*r, filter=self}
	return tr.Hit
end
