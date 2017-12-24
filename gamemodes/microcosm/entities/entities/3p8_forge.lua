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
	self:SetModelScale(1.05, 0)

	self:GetPhysicsObject():EnableMotion(false)

	self:SetSolid(3)

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
	elseif class == "micro_item_salainen_puulle" then
		--data.HitEntity:Ignite(5,102)
	end
end
