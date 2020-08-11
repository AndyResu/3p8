--[[
	3p8_pizza
	Uses:		namesake, duh

	Todo:		
]]

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Pizza"
ENT.ItemModel = "models/props_c17/streetsign003b.mdl"
ENT.MaxCount = 100

local sound_heal = Sound("npc/headcrab_fast/headbite.wav")

--overriding this so it will set material
function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	self:SetMaterial("models/props_borealis/mooring_cleat001")
	self.health = 100

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetCount(self.MaxCount)
	end
end

function ENT:Use(ply)
	local hp_needed = ply:GetMaxHealth() - ply:Health()
	local hp_taken = self:TryTake(hp_needed)

	if hp_taken>0 then
		self:EmitSound(sound_heal)
		ply:SetHealth(ply:Health()+hp_taken)
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		--self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		--puulle = ents.Create("prop_physics")
		--if ( !IsValid( puulle ) ) then return end
		--puulle:SetModel("GIB MODEL")
		--puulle:SetPos(self:GetPos())
		--puulle:Spawn()

		self:Remove()
	end
end
