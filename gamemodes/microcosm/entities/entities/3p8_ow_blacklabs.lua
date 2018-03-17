--[[
	3p8_ow_blacklabs
	Names:		blackforest? dark dogs (like diamond dogs) + black water -> black labs?
				black labs could provide the advance technology like the samurai... DANK?!
				the name black labs would be hard to google for relevant information too... WOWOWOWOWOWOO
	
	Uses:		placeholder for where edgewood trades with
				what if this place was a mercenary encampment. Contracted by the rival of Axis of Evil (Guam ofc). 
					provides a reason to sell them food ALL THE TIME (also might be on a mountain/hill)
					provides a reason for AoE to attack edgewood
						us being near them, supplying them, even as independents, made us a target
					also provides a reason for edgewood to be able to buy mercenaries to bolster it's ranks.
					also provides a reason for edgewood to have access to advanced weaponry faster than it would otherwise.
					brain drain from blacklabs wanted to retire in the peaceful place... duuuudeeee
					AoE's Death Squad would also have a reason to be nearby

	File Theme Song: 
				Foals - Mountain at my Gates
				https://www.youtube.com/watch?v=yirNS7W8qFw

	Todo:		find good model for it


]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.CityName = "Black Labs"
--maybe use models/props_junk/PopCan01a.mdl as a placeholder
ENT.Model = "models/props_c17/suitcase001a.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(7/10, 0)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:GetPhysicsObject():EnableMotion(false)

	--find the local shop in blacklabs.
	GLOBAL_towns[#GLOBAL_towns+1] = {
		name	= self.CityName,
		pos		= self:GetPos()
		shop	= nil --I think the shop's entity reference
		--the base amount of people in the city... think the mayor and shop people I guess
		basePop	= 5
		--other citizens
		people	= 0
		money	= 1000
	}



end
