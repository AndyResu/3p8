--[[
	3p8_forge
	Uses:		turn metal pieces into sheet metal

	Todo:		


]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ComponentModel = "models/props_c17/substation_transformer01a.mdl"

function ENT:Initialize()
	self:SetModel(self.ComponentModel)
	--self:SetMaterial("models/props_lab/airlock_laser")
	self:PhysicsInitStandard()
	--scaling up means the hitbox is bigger than the parented props...
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(0)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end

	self.metalCounter = 0
	self.metalToMake = 5

	self.health = 750
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		for i = 1,math.random(3,8) do
			gib = ents.Create("3p8_metal")
			if ( !IsValid( gib ) ) then return end
			gib:SetPos(self:GetPos() + Vector(math.random(0,32),math.random(0,32),math.random(20,40)))
			gib:Ignite(math.random(2,6), 0)
			gib:Spawn()
		end

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	if class == "3p8_metal" then
		data.HitEntity:Remove()
		self:EmitSound("physics/metal/metal_solid_strain"..math.random(1,5)..".wav")
		self.metalCounter = self.metalCounter + 1

		if self.metalCounter >= self.metalToMake then
			--produce metal part
			metal = ents.Create("3p8_metal_sheet")
			if ( !IsValid( metal ) ) then return end
			metal:SetPos(self:GetPos() + Vector(72,-8,-8))
			metal:SetAngles(Angle(90, 0, 90))
			metal:Spawn()
			self:EmitSound("physics/metal/metal_sheet_impact_soft2.wav")
			self.metalCounter = self.metalCounter - self.metalToMake
		end
	elseif class == "3p8_rock_s" then
		data.HitEntity:Remove()
		self:EmitSound("ambient/levels/canals/headcrab_canister_ambient4.wav")

		--produce metal part
		metal = ents.Create("3p8_metal")
		if ( !IsValid( metal ) ) then return end
		metal:SetPos(self:GetPos() + Vector(100,-8,-8))
		metal:SetAngles(Angle(90, 0, 90))
		metal:Ignite(math.random(2,6), 0)
		metal:Spawn()
	elseif class == "3p8_collector_metal" then
		self:EmitSound("physics/metal/metal_solid_strain"..math.random(1,5)..".wav")
		self.metalCounter = self.metalCounter + data.HitEntity:GetCount()
		data.HitEntity:SetCount(0)
		if self.metalCounter >= self.metalToMake then
			--produce metal part
			metal = ents.Create("3p8_metal_sheet")
			if ( !IsValid( metal ) ) then return end
			metal:SetPos(self:GetPos() + Vector(72,-8,-8))
			metal:SetAngles(Angle(90, 0, 90))
			metal:Spawn()
			self:EmitSound("physics/metal/metal_sheet_impact_soft2.wav")
			self.metalCounter = self.metalCounter - self.metalToMake
		end
	elseif class == "3p8_collector_rock" then
		self:EmitSound("ambient/levels/canals/headcrab_canister_ambient4.wav")
		for i=1,data.HitEntity:GetCount() do
			--produce metal part
			metal = ents.Create("3p8_metal")
			if ( !IsValid( metal ) ) then return end
			metal:SetPos(self:GetPos() + Vector(100,-8,-8))
			metal:SetAngles(Angle(90, 0, 90))
			metal:Ignite(math.random(2,6), 0)
			metal:Spawn()
		end
		data.HitEntity:SetCount(0)
	end
end
