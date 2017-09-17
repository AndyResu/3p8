--[[
	3p8_ow_villager
	Uses:		overworld representation of a truck that moves to a position to transfer resources.

	Todo:		maybe give it a small gun to shoot nearby enemies. 
				consider having upgrades for it.
				on death, have the store buy another? respawn it.
				have truck store what it is carrying in an array...

]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"

--maybe use models/props_junk/PopCan01a.mdl as a placeholder
ENT.Model = "models/props_vehicles/truck001a.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(1/32, 0) --make microscale
	self.health = 100

	

	--use current position


	--get closest city (or target) position


end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("npc/zombie_poison/pz_die1.wav")
		--PRODUCE gibs HERE
		--ALSO REMOVE CHILDREN! if any
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	if class == "3p8_rock_s" then
		data.HitEntity:Remove()
		self:EmitSound("ambient/levels/canals/headcrab_canister_ambient4.wav")

	elseif class == "micro_item_salainen_puulle" then
		data.HitEntity:Ignite(0,102)
	end
end
