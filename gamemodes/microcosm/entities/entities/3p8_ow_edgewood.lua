--[[
	3p8_ow_edgewood
	Uses:		overworld representation of the village of edgewood

	Todo:		all

]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"

ENT.Model = "models/props_lab/cactus.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	--self:SetModelScale(1/32, 0) --cactus is small enough as it is


end
