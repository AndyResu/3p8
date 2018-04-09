--[[
	3p8_ow_villager
	Uses:		overworld representation of a truck that moves to a position to transfer resources.
	Todo:		maybe give it a small gun to shoot nearby enemies. 
				consider having upgrades for it.
				on death, have the store buy another? respawn it.
				have truck store what it is carrying in an array...
				
				Do I need network variables for items?
					Not sure. I don't think we need any because no client? what about when it is spawned in an item?
				On death spawn a box containing its items?
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"

--maybe use models/props_junk/PopCan01a.mdl as a placeholder --models/props_vehicles/truck001a.mdl --models/hunter/misc/sphere025x025.mdl --models/hunter/blocks/cube025x025x025.mdl
ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"
--for inventory
--should shops do the supply/demand stuff or should the villager? both?
--carrying max?
ENT.Items = {
	{
		ent = "Cash",
		stock = 10
	},
	{
		--the villagers can move from city to city.
			--it isn't so much a stock as it is a count... just using consistent words
		ent = "People",
		stock = 2
	}--put comma for more,
}

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)
		self.health = 100
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		--self:SetModelScale(1/32, 0) --make microscale
		self.target = Vector(0,0,0) --might change default later if moved

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

--if each villager is a 1 way trip then the add and remove functions might not need to be used...
function ENT:AddItem(entName, amount)
	--look through items for entName to check if it already exists
	--local isFound = false
	for i=1, #self.Items do
		--if it does, then combine the amounts
		if(self.Items[i].ent == entName) then
			self.Items[i].stock = self.Items[i].stock + amount
			--isFound = true
			return
		end
	end
	--if not found, then add it: items[#items+1] = {...}
		--should there be more parameters?
	--if (!isFound) then
		self.Items[#self.Items+1].ent = entName
		self.Items[#self.Items+1].stock = amount
	--end
end

function ENT:RemoveItem(entName, amount)
	--look through items for entName to check if it exists
	for i=1, #self.Items do
		--if it does, then subtract amount
		if(isValid(self.Items[i]) && self.Items[i].ent == entName && self.Items[i].stock >= amount) then
			self.Items[i].stock = self.Items[i].stock - amount
			--if the spot in the array now has 0 stock, remove it
				--potential problem if #items goes from 1 -> 0?
					--items might not exist anymore... :(
			if(self.Items[i].stock == 0) then
				--hopefully cannot access a .ent if the slot is marked as nil
				--same for stock
				table.remove(self.Items, i)
				--automatically shifts the rest up :D
			end
			return
		end
	end
	
	print("Error in removing an item in 3p8_ow_villager.lua... likely from a 3p8_ow_city?")
	--if not found, then error
end

--for destruction
function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("npc/zombie_poison/pz_die1.wav")
		--drop all the items inside and the cash too...
		self:Remove()
	end
end

--for arrival to a place
function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	if class == "3p8_ow_city" then
		--get the shop for that city and buy/sell
			--this is where the "ai" for it would go. Decides what to buy and sell from its inventory...
				--use ENT:AddItem and stuff
		data.HitEntity.ShopEnt.SellToShopArray(self.Items)
		--change the population of the city
		data.HitEntity:SetNWInt("people", data.HitEntity:GetNWInt("people", -999)+self.Items[2].stock)
		--idk what else to change
			--maybe the 
				--wow, you just left it blank. Probably got a snapchat that distracted you, nerd
	end
end
