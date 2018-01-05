--[[
	3p8_tickets_friendly
	Uses:		Show the resistance of 3p8 how many friendlies are remaining.

	Todo:		


]]

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Enemy Tickets"
ENT.ItemModel = "models/props_lab/citizenradio.mdl"
ENT.MaxCount = 2

function ENT:Use(ply)
	--find spawn location ents...

	if SERVER then
		--make friends. via airdrop and knocking down barriers
		local ent1 = ents.Create("Rebel") --THEY'VE SENT IN THE (not) SUPERS

		ent1:SetPos(self:GetPos()+Vector(128,128,64))
		ent1:CallOnRemove( "Casualty", function( ent ) self:TryTake(1) end )
		ent1:Spawn()
	end
end
