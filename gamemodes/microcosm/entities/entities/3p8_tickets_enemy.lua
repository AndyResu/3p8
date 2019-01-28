--[[
	3p8_tickets_enemy
	Uses:		Show the resistance of 3p8 how many enemies are incoming.

	Todo:		


]]

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Enemy Tickets"
ENT.ItemModel = "models/props_lab/citizenradio.mdl"
ENT.MaxCount = 20

function ENT:Use(ply)
	--find spawn location ents...
	--self:TryTake(-2) it works, you can use this to give tickets

	if SERVER then
		--make friends. via airdrop and knocking down barriers
		local ent1 = ents.Create("npc_combine_s") --THEY'VE SENT IN THE (not) SUPERS

		ent1:SetPos(self:GetPos()+Vector(math.random(-128,128),math.random(-128,128),128))
		ent1:CallOnRemove( "Casualty", function( ent ) self:TryTake(1) end )
		ent1:Spawn()
	end
end
