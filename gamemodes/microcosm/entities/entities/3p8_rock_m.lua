--[[
rocks (exhaustable)

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.rockTable = {	"models/props_foliage/rock_forest04.mdl", "models/props_foliage/rock_forest03.mdl", "models/props_wasteland/rockgranite01c.mdl", "models/props_wasteland/rockgranite01b.mdl",
					"models/props_wasteland/rockgranite01a.mdl", "models/props_wasteland/rockcliff01j.mdl", "models/props_wasteland/rockcliff01f.mdl", "models/props_wasteland/rockcliff01e.mdl",
					"models/props_wasteland/rockcliff01c.mdl", "models/props_wasteland/rockcliff01b.mdl"}

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.rockTable[math.random(#self.rockTable)])

		self:PhysicsInitStandard()
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		--stop movement
		self:SetMoveType(0)

		--[[local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep() --stop movement from the get-go
		end]]
	end

	self.health = 1000
end


function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("physics/concrete/boulder_impact_hard"..math.random(4)..".wav")
		for i = 1,math.random(1,3) do
			local ent1 = ents.Create("3p8_rock_s")
			if ( !IsValid( ent1 ) ) then return end
			ent1:SetPos(self:GetPos()+Vector(math.random(-32, 128),math.random(-32, 128),math.random(-32, 128)))
			ent1:Spawn()
		end
		self:Remove()		
	end
end