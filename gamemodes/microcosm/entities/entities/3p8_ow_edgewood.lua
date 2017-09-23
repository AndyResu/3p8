--[[
	3p8_ow_edgewood
	Uses:		overworld representation of the village of edgewood

	File Theme:	Trouble - Where I'm From (Edgewood)
				https://www.youtube.com/watch?v=AHQ3ZiQ96Jc

	Todo:		details in the init
					do the same to blacklabs...
						make a base city?
				add position to GLOBAL_towns in 3p8

]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"

ENT.Model = "models/props_lab/cactus.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	--self:SetModelScale(1/32, 0) --cactus is small enough as it is
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:GetPhysicsObject():EnableMotion(false)

	--find the local shop in edgewood.
	GLOBAL_towns[1] = {
		name	= "Edgewood",
		pos		= self:GetPos()
	}



end

--make a function that can add/remove from the shops inventory.
	--maybe just keep inventory here?
