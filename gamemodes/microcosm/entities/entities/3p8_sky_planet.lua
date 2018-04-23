--[[
	3p8_ow_planet
	Uses:		3p8 world.com
	Todo:		
					
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.Model = "models/hunter/misc/sphere025x025.mdl"
ENT.Sun = nil
ENT.TrailColor = nil
ENT.TrailTime = nil
ENT.InitialPush = nil
ENT.SpinVector = Vector(0,-1,0)
ENT.SpinPos = Vector(1,0,0) --relative to self

function ENT:Initialize()
	self.SpinPos = self.SpinPos + self:GetPos()
	if SERVER then
		self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			--phys:EnableMotion(false)
			phys:EnableGravity(false)
			phys:EnableDrag(false)
			
			--initial push to send it around the Sun
			phys:ApplyForceCenter(self.InitialPush)
			
			--spin
				--if this doesn't work, try hitting both sides
			phys:ApplyForceOffset(self.SpinVector, self.SpinPos)
			phys:ApplyForceOffset(-1*self.SpinVector, self.SpinPos - 2*(self.SpinPos-self:GetPos()))
		end
		local masse1 = self:GetPhysicsObject():GetMass()
		--print("Mass1: " .. masse1)
		local masse2 = self.Sun:GetPhysicsObject():GetMass()
		--print("Mass2: " .. masse1)
		local trail = util.SpriteTrail(self, 0, self.TrailColor, false, 15, 1, self.TrailTime , 1/(15+1)*0.5, "trails/plasma.vmt")
	end
end

--override the original
function ENT:OnTakeDamage(damageto) end

function ENT:Think()
	if CLIENT then return end
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		--gravitate around ja boy the sun (Force due to Gravity)
		local mass1 = self:GetPhysicsObject():GetMass() --5
		local mass2 = 50000									--self.Sun:GetPhysicsObject():GetMass() --mass of 5
		--print("Mass2: " .. mass2)
		local Gconst = 6.674*10^1										--6.674*10^-11 --N* (m/kg)^2
		local radius = math.sqrt((self.Sun:GetPos().x - self:GetPos().x)^2 + (self.Sun:GetPos().y - self:GetPos().y)^2 + (self.Sun:GetPos().z - self:GetPos().z)^2)
		local force = (Gconst*mass1*mass2)/(radius^2)
		local directionVector = Vector(self.Sun:GetPos().x - self:GetPos().x, self.Sun:GetPos().y - self:GetPos().y, self.Sun:GetPos().z - self:GetPos().z):GetNormalized()
		local gravity = force*directionVector

		phys:ApplyForceCenter(gravity)
		
		--local airbud = (force*-0.001)*(directionVector)
		--airbud:Rotate(Angle(0,90,0))

		--phys:ApplyForceCenter(airbud)
	end
end
