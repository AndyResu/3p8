--[[
	tp8_traffic_light
	Uses:		A traffic gamemode's baseship
	Todo:		
				
	Models:		Pole:	models/props_trainstation/trainstation_column001.mdl
				Light:	models/props_junk/metal_paintcan001a.mdl
				Frame:	models/hunter/blocks/cube025x075x025.mdl

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/props_trainstation/trainstation_column001.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetPos(self:GetPos())
	--set angles so it stands up...
	self:PhysicsInitStandard()

	self.armHeight = Vector(0,0,181)

	self.red = Color(255,0,0)

	if SERVER then
		--the horizontal pole
		cosmetic = ents.Create("prop_physics")
		if ( !IsValid( cosmetic ) ) then return end
		cosmetic:SetPos(self:GetPos()+self.armHeight)
		cosmetic:SetAngles(self:GetAngles()+Angle(90,0,0))
		cosmetic:SetModel("models/props_trainstation/trainstation_column001.mdl")
		--cosmetic:SetMaterial("models/props_c17/oil_drum001a")
		cosmetic:Spawn()
		cosmetic:GetPhysicsObject():EnableMotion(false)
		--cosmetic:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		cosmetic:SetSolid(3)

		frame = ents.Create("prop_physics")
		if ( !IsValid( frame ) ) then return end
		frame:SetAngles(self:GetAngles()+Angle(90,90,0))
		local vector_rotated = Vector(0,-7,-7)
		vector_rotated:Rotate(self:GetAngles())
		frame:SetPos(self:GetPos()+self.armHeight+self:GetForward()*256 + vector_rotated)
		frame:SetModel("models/hunter/blocks/cube025x075x025.mdl")
		--frame:SetMaterial("models/props_c17/oil_drum001a")
		frame:Spawn()
		frame:GetPhysicsObject():EnableMotion(false)
		--frame:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		frame:SetSolid(3)
		frame:SetColor(self.red)
		self.lightEnt=frame

		self:GetPhysicsObject():EnableMotion(false)
		self:SetSolid(3)
		self:SetupDataTables()
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", frame, "Light")
end

function ENT:SetTrafficColor(color)
	self:SetColor(color)
end
