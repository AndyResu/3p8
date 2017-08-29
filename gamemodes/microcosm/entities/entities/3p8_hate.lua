--https://www.youtube.com/watch?v=CEIGu8V_D8g
--"Is it done, Yuri?" "No comrade Premier, it has only begun."

--An artifact of the black market; the product of a tortured brain. 

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

	--delay for the action so as not to associate with low-life plebs.
	self.baseTime = (42069 - (1337 + 666)) / 69 --1.9 times the half life of uranium-241
	self.randoTime = self.baseTime + math.random(-300, 300) --gimmie or takey 5 minoots

	--make timer for arrival. 

	--find spawn location ents...

	--make friends. via airdrop and knocking down barriers
	local ent1 = ents.Create("CombineElite") --THEY'VE SENT IN THE SUPERS

    ent1:SetPos(self:GetPos()+Vector(128,128,64))
    ent1:Spawn()
end
