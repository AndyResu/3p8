--[[
	3p8_ow_tower
	Uses:		a generalization of the overworld representation of a jet

	Todo:		test
				models/xqm/jetbody3.mdl
					
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.Model = nil
ENT.AttackTime = 3
ENT.Home = Vector(100, 604, 1488)
ENT.Target = nil
ENT.GuardDist = 750
ENT.HoverDist = 300
ENT.WayPointCounter = 1
ENT.AttackRange = 250

function ENT:Initialize()
	self.Target = self.Home + Vector(self.GuardDist,self.GuardDist,self.HoverDist)
	self.health = 250

	if SERVER then
		--self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableGravity(false)
			--phys:EnableDrag(false)
			phys:SetMass(25)
		end
		local trail = util.SpriteTrail(self, 0, Color(200,200,200), false, 15, 1, --[[self.TrailTime]] 45 , 1/(15+1)*0.5, "trails/smoke.vmt")
		self:SetModelScale(1/8, 1)
	end
end

if SERVER then
	function ENT:Think()

		local phys = self:GetPhysicsObject()
		self:NextThink(CurTime()+(0.5))

		for _,info in pairs(MICRO_SHIP_INFO) do
			if !IsValid(info.entity) then continue end

			local dist = info.entity:GetPos():Distance(self:GetPos())

			if dist<self.AttackRange then
				--print("Dist is: "..dist)
				--This didn't work at first because there is a dmg whitelist in 3p8_ship
				
				local rocket = ents.Create( "rpg_missile" )
				rocket:SetPos( self:GetPos() + Vector(0,0,-8) --[[+ self:GetForward()*16]] )
				rocket:SetVelocity(self:GetVelocity())
				rocket:SetAngles((info.entity:GetPos() - self:GetPos() + Vector(0,0,32)):Angle())
				rocket:SetKeyValue( "damage", 100 )
				rocket:SetSaveValue( "m_flDamage", 100 ) 
				rocket:Spawn()
				rocket:Activate()
				rocket:SetOwner( self )

				self:NextThink(CurTime()+(self.AttackTime))
			end
			--GHETTO Waypoint COUNTA
				--Should form a box around the home point at the set hover height
			self.WayPointCounter = self.WayPointCounter%4 + 1 --increase by 1 until it is 4, then wrap back to 1
			if (self.WayPointCounter == 1) then
				self.Target = self.Home + Vector(self.GuardDist,self.GuardDist,self.HoverDist+math.random(-250,250))
			elseif(self.WayPointCounter == 2) then
				self.Target = self.Home + Vector(self.GuardDist,-self.GuardDist,self.HoverDist+math.random(-250,250))
			elseif(self.WayPointCounter == 3) then
				self.Target = self.Home + Vector(-self.GuardDist,-self.GuardDist,self.HoverDist+math.random(-250,250))
			elseif(self.WayPointCounter == 4) then
				self.Target = self.Home + Vector(-self.GuardDist,self.GuardDist,self.HoverDist+math.random(-250,250))
			end

			if phys:IsValid() then
				local memelord422 = Vector(self.Target.x - self:GetPos().x, self.Target.y - self:GetPos().y, self.Target.z - self:GetPos().z):GetNormalized()*3000*math.random(-1,2)

				local phys = self:GetPhysicsObject()
				phys:ApplyForceCenter(memelord422)
				--self:SetAngles((self.Target - self:GetPos()):Angle())
			end
		end
		
		return true
	end
end
