--[[
	3p8_pizzaoven
	Uses:		make pizza

	Todo:		
				change the sound it makes when hit with a pizza kit
					maybe a sizzling sound

				pizza kit and pizza itself
				pizza: 
					mat: models/props_borealis/mooring_cleat001 
					model: models/props_c17/streetsign003b.mdl

				kit:
					mat: phoenix_storms/life_support/canister_valve
					model: models/Items/BoxMRounds.mdl
					makes 3 pizzas?
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ComponentModel = "models/props_wasteland/kitchen_stove001a.mdl"

function ENT:Initialize()
	if CLIENT then return end
	self:SetModel(self.ComponentModel)
	self:PhysicsInitStandard()
	self:SetMoveType(0)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	
	self.health = 500
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		for i = 1,math.random(2,4) do
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
	local model = data.HitEntity:GetModel()

	if class == "3p8_pizzakit" then
		local duhCount = data.HitEntity:GetCount()
		data.HitEntity:TryTake(duhCount)

		self:EmitSound("physics/wood/wood_box_break"..math.random(1,2)..".wav")

		for i = 1, duhCount do
			--produce metal part
			pizza = ents.Create("3p8_pizza")
			if ( !IsValid( pizza ) ) then return end
			pizza:SetPos(self:GetPos() + Vector(0,0,60))
			pizza:SetAngles(Angle(0, math.random(-179, 180), 0))
			pizza:Spawn()
		end
	end
end
