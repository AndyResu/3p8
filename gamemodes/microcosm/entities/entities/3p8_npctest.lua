--[[
	3p8_npctest
	Uses:		tests how npc targeting works

	Todo:		

	Lore:		
	
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.rockTable = {	"models/props_wasteland/rockgranite03c.mdl", "models/props_wasteland/rockgranite03c.mdl", "models/props_wasteland/rockgranite03b.mdl", "models/props_wasteland/rockgranite03a.mdl", 
					"models/props_wasteland/rockgranite02c.mdl", "models/props_wasteland/rockgranite02b.mdl", "models/props_wasteland/rockgranite02a.mdl"}

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.rockTable[math.random(#self.rockTable)])

		self:PhysicsInitStandard()
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

	end

	self.fovToggle = false
	self.health = 250
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("physics/concrete/boulder_impact_hard"..math.random(4)..".wav")
		self:Remove()		
	end
end

function ENT:Use(ply)
	local ent1 = ents.Create("npc_combine_s") --THEY'VE SENT IN THE (not) SUPERS
	if(self.fovToggle) then
		self.fovToggle = false
		--create npc
		ent1:SetPos(self:GetPos()+Vector(math.random(-512,512),math.random(-512,512),0))
		--ent1:CallOnRemove( "Casualty", function( ent ) self:TryTake(1) end )
		ent1:Spawn()
		--have it go to random nearby vector
	else
		self.fovToggle = true
		ent1:NavSetGoal(self:GetPos() + Vector(256,256,0))
	end
end
