--[[
industrial product

models/props_debris/metal_panel01a.mdl

models/props_debris/metal_panelchunk01a.mdl
models/props_debris/metal_panelchunk01b.mdl
models/props_debris/metal_panelchunk01e.mdl

TODO:

]]

AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_debris/metal_panel01a.mdl")

		self:PhysicsInitStandard()
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		--stop movement
		self:SetMoveType(6)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetMass(40)
		end
	end

	self.health = 1500
end


function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("physics/metal/metal_sheet_impact_hard"..math.random(6,8)..".wav")
		local ent1 = ents.Create("3p8_metal_sheet_gib1")
			if ( !IsValid( ent1 ) ) then return end
			ent1:SetPos(self:GetPos())
			ent1:SetAngles(self:GetAngles())
			ent1:Spawn()
		local ent2 = ents.Create("3p8_metal_sheet_gib2")
			if ( !IsValid( ent2 ) ) then return end
			ent2:SetPos(self:GetPos())
			ent2:SetAngles(self:GetAngles())
			ent2:Spawn()
		local ent3 = ents.Create("3p8_metal_sheet_gib3")
			if ( !IsValid( ent3 ) ) then return end
			ent3:SetPos(self:GetPos()+Vector(0,0,5))
			ent3:SetAngles(self:GetAngles()*-1)
			ent3:Spawn()
		self:Remove()
	end
end