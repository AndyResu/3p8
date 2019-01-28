--[[
	3p8_tickets_invasion
	Uses:		Spawn a bunch of combine for fighting

	Todo:		


]]

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Spawn 64 enemies"
ENT.ItemModel = "models/props_lab/citizenradio.mdl"
ENT.MaxCount = 64

function ENT:Use(ply)
	--find spawn location ents...
	--self:TryTake(-2) it works, you can use this to give tickets

	if SERVER then
		--make friends. via airdrop and knocking down barriers
		for i = 1,64 do
			local ent1 = ents.Create("npc_combine_s") --THEY'VE SENT IN THE (not) SUPERS
			ent1:SetPos(self:GetPos()+Vector(math.random(-512,512),math.random(-512,512),math.random(128,512)))
			--ent1:CallOnRemove( "Casualty", function( ent ) self:TryTake(1) end )
			ent1:Spawn()
		end
	end
end
