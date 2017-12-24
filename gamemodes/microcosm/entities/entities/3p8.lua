--[[
	3p8
	Uses:		Required for the gamemode to work.
				Initializes all the global variables.
				Spawns plants

	Todo:		

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/props_combine/breenglobe.mdl"

--controls if the potatos should automatically plant themselves or not.
GLOBAL_potato = 		0
GLOBAL_potato_max = 	50

--controls if the coconuts should automatically plant themselves or not.
GLOBAL_coconut = 		0
GLOBAL_coconut_max =	75

--controls if grass should automatically plant themselves or not.
GLOBAL_grass = 			0
GLOBAL_grass_max =		150

GLOBAL_towns = {
	--each town ent adds itself.

}

function ENT:Initialize()
	self.distanceToGround = -68

	self:SetModel(self.Model)
	self:SetMaterial("models/effects/splodeglass_sheet") --make invis
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) --make nocollide
	self:SetModelScale(0.01, 0) --make super small

	if SERVER then
		for i = 1,10 do
			--print("making coconut again")
			newFruit = ents.Create("3p8_kookospahkina_puu")
			if ( !IsValid( newFruit ) ) then return end
			newFruit:SetPos(self:GetPos() + Vector(math.random(-512,512),math.random(-512,512),128+math.random(0,25)))
			--might spawn coconuts off map...
			newFruit:Spawn()
			newFruit:GetPhysicsObject():Wake()
		end
		for i = 1,10 do
			newFruit = ents.Create("3p8_potato_ent")
			if ( !IsValid( newFruit ) ) then return end
			newFruit:SetPos(self:GetPos() + Vector(math.random(-512,512),math.random(-512,512),math.random(0,25)))
			--might spawn off map...
			newFruit:Spawn()
			newFruit:GetPhysicsObject():Wake()
		end
		--for j = -16,16 do
			for i = 1,15 do
				newFruit = ents.Create("3p8_grass")
				if ( !IsValid( newFruit ) ) then return end
				newFruit:SetPos(self:GetPos() + Vector(math.random(-512,512),math.random(-512,512),self.distanceToGround))
				if !newFruit:OnGroundNotStupidEdition(newFruit:GetPos()) && newFruit:WaterLevel() != 0 then
					newFruit:Remove()
				else
					--might spawn off map...
					newFruit:Spawn()
					--print(j+self.distanceToGround)
				end
			end
		--end
	end
end
