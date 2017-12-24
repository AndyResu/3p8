--3p8_ammo_rocket_socket

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Rockets"
ENT.ItemModel = "models/props/de_prodigy/ammo_can_02.mdl"
ENT.MaxCount = 10
 
local sound_armorup = Sound("items/ammo_pickup.wav")

function ENT:Use(ply)
     local armor_needed = 1
     local armor_taken = self:TryTake(armor_needed)
     
     if armor_taken>0 then
          self:EmitSound(sound_armorup)
          print(ply:GetAmmoCount("RPG_Round"))
          ply:SetAmmo(ply:GetAmmoCount("RPG_Round") + armor_taken, "RPG_Round") 
     end
end
