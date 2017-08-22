--https://www.youtube.com/watch?v=CEIGu8V_D8g
--"Is it done, Yuri?" "No comrade Premier, it has only begun."

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/maxofs2d/hover_rings.mdl"

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	--self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(0)

	--make timer for arrival. 
	local ent1 = ents.Create("prop_physics")
    ent1:SetModel(deco[math.random(#deco)])
    ent1:SetPos(self:GetPos()+Vector(0,0,64))
    ent1:Spawn()
end
