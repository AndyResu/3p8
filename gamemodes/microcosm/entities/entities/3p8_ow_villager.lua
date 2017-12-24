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

--maybe use models/props_junk/PopCan01a.mdl as a placeholder --models/props_vehicles/truck001a.mdl --models/hunter/misc/sphere025x025.mdl --models/hunter/blocks/cube025x025x025.mdl
ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self.health = 100
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	--self:SetModelScale(1/32, 0) --make microscale
	self.target = Vector(0,0,0) --GLOBAL_towns[1].pos --might change default later if moved

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(1)
			phys:Wake()
		end
	end

	--use current position
		--get a home pos?


	--get closest city (or target) position

end

--for movement...?
function ENT:SetTarget(pos)
	self.target = pos
	--print(self.target.x .. " " .. self.target.y .. " " .. self.target.z .. " " .. "self.target")
	--rotate the model to face the target. maybe
	--self:SetAngles((self.target.x - self:GetPos().x, self.target.y - self:GetPos().y, self.target.z - self:GetPos().z):Angle())
end

function ENT:Think()
	if CLIENT then return end
	--go
	--get the direction
	local memelord421 = Vector(self.target.x - self:GetPos().x, self.target.y - self:GetPos().y, self.target.z - self:GetPos().z):GetNormalized()*50 + Vector(0,0,40)

	local phys = self:GetPhysicsObject()
	phys:ApplyForceCenter(memelord421)
end


--for inventory
	--should shops do the supply/demand stuff or should the villager? both?
	--carrying max?
local items = {
	
}

function ENT:AddItem(entName, amount)
	--look through items for entName to check if it already exists
		--if it does, then combine the amounts
		--if not, then add it: items[#items+1] = {...}
			--should there be more parameters?
	--add money to shop, subtract money from villager
end

function ENT:RemoveItem(entName, amount)
	--look through items for entName to check if it exists
		--if it does, then subtract amount
		--if not, then error
	--add money to villager, subtract money from shop
end

--for destruction
function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("npc/zombie_poison/pz_die1.wav")
		--PRODUCE gibs HERE
		--ALSO REMOVE CHILDREN! if any
		self:Remove()
	end
end

--for arrival to a place
function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	if class == "3p8_ow_edgewood" then
		--get the shop for that city and buy/sell
			--this is where the "ai" for it would go. Decides what to buy and sell from its inventory...
				--use ENT:AddItem and stuff

		--set new target location

		--go
		self:SetTarget(GLOBAL_towns[2].pos)

	elseif class == "3p8_ow_blacklabs" then
		--same as above except for blacklabs.
		self:SetTarget(GLOBAL_towns[1].pos)
	end
end
