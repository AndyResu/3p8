--shameless copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--Visual Representation for the Visual Impaired:
--Visual A.I.D.S. xDDD
--[[
  _                   _
 ( \                 / )
  \ \.-------------./ /
   \(               )/
     `.___________.'
VK [1]

Bibliography (Chicago """CHIRAQ""" Style Citation):
1. "HOTDOG - ASCII ART". Authored by VK. Accessed Feburary 4th, 2017. http://hotdog.ascii.uk/.
]]
--"chiraq not miami but I'm wearing heat like I play for them" -Montana of 300.  Do I have to cite this crap, too?

AddCSLuaFile()

ENT.Base = "micro_item"

ENT.ItemName = "Free Hotdog"
ENT.ItemModel = "models/food/hotdog.mdl"
ENT.MaxCount = 100

local sound_eat = Sound("npc/headcrab_fast/headbite.wav")

function ENT:Use(ply)
    local hp_needed = ply:GetMaxHealth() - ply:Health()
	local hp_taken = self:TryTake(hp_needed)

	if hp_taken>0 then
		self:EmitSound(sound_eat)
		ply:SetHealth(ply:Health()+hp_taken)
	end
end

--Hey Sky, we should use this one, too!
--models/food/burger.mdl
--Great idea, fam!