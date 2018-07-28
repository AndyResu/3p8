--[[
	3p8_ow_tower
	Uses:		a generalization of the overworld representation of a tower

	Todo:		test
					
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.Model = nil
ENT.AttackTime = 3

function ENT:Initialize()
	--self:SetModelScale(1/32, 0) --cactus is small enough as it is
	self.health = 1000

	if SERVER then
		--self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:GetPhysicsObject():EnableMotion(false)
	end
end

if SERVER then
	function ENT:Think()

		local phys = self:GetPhysicsObject()

		for _,info in pairs(MICRO_SHIP_INFO) do
			if !IsValid(info.entity) then continue end

			local dist = info.entity:GetPos():Distance(self:GetPos())

			if dist<150 then
				--print("Dist is: "..dist)
				--This didn't work at first because there is a dmg whitelist in 3p8_ship
				self:FireBullets{
					Src=self:GetPos(),
					Dir=info.entity:GetPos()-self:GetPos(),
					Spread=Vector(.1,.1,.1),
					Damage=55,
					Tracer=1,
					HullSize = 1,
					Num = 1,
					Callback=function(attacker,tr,dmg)
						SendTracer(3,tr.StartPos,tr.HitPos)
					end
				}
			end
		end
		
		self:NextThink(CurTime()+(self.AttackTime))
		return true
	end
end
