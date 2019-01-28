--[[

	the hat of Big Stunt
	tp8_hat

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ComponentModel = "models/props_c17/pulleywheels_small01.mdl"

function ENT:Initialize()
	self:SetModel(self.ComponentModel)
	self:SetMaterial("models/food/hotdog")
	self:PhysicsInitStandard()
end

function ENT:Use(ply)
	ply:Give("tp8_oddjob", false)
	ply:GiveAmmo(1, "Battery", true)
	ply:SetAnimation(PLAYER_ATTACK1)
	
	--remove the ground hat
	if SERVER then
		self:Remove()
	end
end
