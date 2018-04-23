--[[
	3p8_ow_planet
	Uses:		3p8 Epicsun
	Todo:		Have 3p8 make a Sun
				Planet spins. Maybe only space level.
					Have an ow_planet that is huge and has the ow on it. 32x the size of sky_planet? hehe
						The sky of the OW would go to the sky_planet
						would the sky of 3p8 be in the OW or a special projection of the sky_planet? hmm.
				
	Extra: 	models/space/asteroid
			ce_ls3additional/asteroids/asteroid_small
			ce_ls3additional/asteroids/asteroid_large
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.Model = "models/hunter/misc/sphere375x375.mdl"
ENT.Material = "models/atmospheres/sun/shell"
ENT.HomeworldOffset = Vector(000,2000,0)
ENT.LeetworldOffset = Vector(000,1000,0)
ENT.Vertworld250Offset = Vector(500,500,500)
ENT.SpinVector = Vector(0,400,0)
ENT.SpinPos = Vector(100,0,0) --relative to self

function ENT:Initialize()
	self.SpinPos = self.SpinPos + self:GetPos()
	if SERVER then
		self:SetModel(self.Model)
		self:SetMaterial(self.Material)

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			--phys:EnableMotion(false)
			phys:EnableGravity(false)
			phys:EnableDrag(false)
			--spin
			phys:ApplyForceOffset(self.SpinVector, self.SpinPos)
			phys:ApplyForceOffset(-1*self.SpinVector, self.SpinPos - 2*(self.SpinPos-self:GetPos()))
		end
		
		--create a planet
		homeworld = ents.Create("3p8_sky_planet")
		if ( !IsValid( homeworld ) ) then return end
		homeworld:SetPos(self:GetPos() + self.HomeworldOffset)
		homeworld.Sun = self --used network variables here in 3p8
		homeworld.TrailColor = Color(255,0,0)
		homeworld.TrailTime = 100
		homeworld.InitialPush = Vector(-400,000,0)
		homeworld:Spawn()

		--create leetworld
		leetworld = ents.Create("3p8_sky_planet")
		if ( !IsValid( leetworld ) ) then return end
		leetworld:SetPos(self:GetPos() + self.LeetworldOffset)
		leetworld.Sun = self --used network variables here in 3p8
		leetworld.TrailColor = Color(0,0,255)
		leetworld.TrailTime = 60
		leetworld.InitialPush = Vector(-400,000,100)
		leetworld:Spawn()

		--create vertworld250
		vertworld250 = ents.Create("3p8_sky_planet")
		if ( !IsValid( vertworld250 ) ) then return end
		vertworld250:SetPos(self:GetPos() + self.Vertworld250Offset)
		vertworld250.Sun = self --used network variables here in 3p8
		vertworld250.TrailColor = Color(0,255,0)
		vertworld250.TrailTime = 30
		vertworld250.InitialPush = Vector(-300,-200,300)
		vertworld250:Spawn()
	end
end

--override the original
function ENT:OnTakeDamage(damageto) end
