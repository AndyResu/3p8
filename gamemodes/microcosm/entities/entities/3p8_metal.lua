--[[
	TODO:


	File theme song: 
	https://www.youtube.com/watch?v=9K0wJEcte-8
	TAIVAS~

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.models = {	"models/props_c17/oildrumchunk01a.mdl", "models/props_c17/oildrumchunk01b.mdl", "models/props_c17/oildrumchunk01c.mdl", 
				"models/props_c17/oildrumchunk01d.mdl", "models/props_c17/oildrumchunk01e.mdl"}

function ENT:Initialize()

	self.health = 75

	if SERVER then
		self:SetModel(self.models[math.random(#self.models)])
		self:PhysicsInitStandard()
		self:SetSolid(6)
		self:SetMoveType(6)

		--removal clock
		local timer_name = "metalClock_" .. self:EntIndex()
		timer.Create(timer_name,600,0, function()
			if IsValid(self) then
				self:Remove()
				timer.Remove(timer_name)
			else
				timer.Remove(timer_name)
			end
		end)
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("ambient/materials/roust_crash"..math.random(1,2)..".wav")
		self:Remove()
	end
end
