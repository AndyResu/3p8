--[[
rocks (exhaustable)

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.rockTable = {	"models/props_foliage/rock_coast02a.mdl", "models/props_foliage/rock_coast02b.mdl", "models/props_foliage/rock_coast02d.mdl", "models/props_foliage/rock_coast02e.mdl", "models/props_foliage/rock_coast02f.mdl",
					"models/props_wasteland/rockcliff06i.mdl", ""}

function ENT:Initialize()
	--self:SetMaterial("models/props_pipes/guttermetal01a")
	self:SetModel(self.rockTable[math.random(#self.rockTable)])
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(1000)
		phys:Sleep() --stop movement from the get-go
	end

	self.health = 3000
end


function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("physics/concrete/boulder_impact_hard"..math.random(4)..".wav")
		for i = 1,math.random(5,10) do
			local ent1 = ents.Create("3p8_rock_s")
			if ( !IsValid( ent1 ) ) then return end
			ent1:SetPos(self:GetPos()+Vector(math.random(-128, 128),math.random(-128, 128),math.random(-128, 128)))
			ent1:Spawn()
		end
		self:Remove()		
	end
end