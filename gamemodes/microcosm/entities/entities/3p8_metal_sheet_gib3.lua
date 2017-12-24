--[[
industrial product

]]

AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_debris/metal_panelchunk01e.mdl")

		self:PhysicsInitStandard()
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		--stop movement
		self:SetMoveType(6)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetMass(10)
		end
	end

	self.health = 100
end


function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("physics/metal/metal_sheet_impact_hard"..math.random(6,8)..".wav")
		local ent1 = ents.Create("3p8_metal")
			if ( !IsValid( ent1 ) ) then return end
			ent1:SetPos(self:GetPos()+Vector(0,0,2))
			ent1:SetAngles(self:GetAngles())
			ent1:Spawn()
		self:Remove()
	end
end