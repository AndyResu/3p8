--[[
	3p8_ow_blacklabs
	Names:		blackforest? dark dogs (like diamond dogs) -> black labs?
				black labs could provide the advance technology like the samurai... DANK?!
				the name black labs would be hard to google for relevant information too... WOWOWOWOWOWOO
	
	Uses:		placeholder for where edgewood trades with
				what if this place was a mercenary encampment. Contracted by the rival of Axis of Evil (Guam ofc). 
					provides a reason to sell them food ALL THE TIME
					provides a reason for AoE to attack edgewood
						us being near them, supplying them, even as independents, made us a target
					also provides a reason for edgewood to be able to buy mercenaries to bolster it's ranks.
					also provides a reason for edgewood to have access to advanced weaponry faster than it would otherwise.
					brain drain from blacklabs wanted to retire in the peaceful place... duuuudeeee
					AoE's Death Squad would also have a reason to be nearby

	Todo:		all


]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"

--maybe use models/props_junk/PopCan01a.mdl as a placeholder
ENT.Model = "models/props_vehicles/truck001a.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(1/32, 0) --make microscale

	



end
