--[[
	tp8_traffic_sol
	Uses:		Core entity that sets up the gamemode.
	Todo:		
				
	Models:		

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/props_combine/breenglobe.mdl"

ENT.trafficLightPos = {Vector(288, -288, 0), 	Vector(-288, 288, 0)}
ENT.trafficLightAng = {Angle(0,90,0), 			Angle(0,0,0)}
ENT.trafficLight = {}

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMaterial("models/effects/splodeglass_sheet") --make invis
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) --make nocollide
	self:SetModelScale(0.01, 0) --make super small
	TRAFFIC_SOL_ENT_ID = self:EntIndex()

	if SERVER then
		--make entities
		for i=1,#self.trafficLightPos do
			light = ents.Create("tp8_traffic_light")
			if ( !IsValid( light ) ) then return end
			light:SetPos(self.trafficLightPos[i])
			light:SetAngles(self.trafficLightAng[i])
			light:Spawn()
			table.insert(self.trafficLight, i, light)
		end
	end
end

function ENT:Think()
	for i=1,#self.trafficLight do
		self.trafficLight[i].SetColor(Color(math.random(0,255),math.random(0,255),math.random(0,255)))
	end
end
