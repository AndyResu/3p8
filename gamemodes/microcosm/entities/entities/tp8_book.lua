--[[
	tp8_book
	Uses:		
	Todo:		
				
	Models:		no tag:
					models/props_lab/binderblue.mdl
					models/props_lab/bindergreen.mdl
				tag:
					models/props_lab/binderbluelabel.mdl
					models/props_lab/bindergraylabel01a.mdl
					models/props_lab/bindergraylabel01b.mdl
					models/props_lab/bindergreenlabel.mdlq
					models/props_lab/binderredlabel.mdl

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/props_combine/breenglobe.mdl" -- TODO

function ENT:Initialize()
	self:SetModel(self.Model)
	if SERVER then
		--self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
	end
end

function ENT:Use(ply)

end
