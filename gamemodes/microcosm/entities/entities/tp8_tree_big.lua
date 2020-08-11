--[[
	tp8_tree_big
	Uses:		It's a tree, but huge.
				Grows on its own up until a certain global number.

	Memes:		

	Todo:		
				
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "tp8_tree"

ENT.ItemModel = "models/props_junk/PopCan01a.mdl"
ENT.secondModel = {"models/props_foliage/urban_tree01.mdl", "models/props_foliage/urban_tree01_medium.mdl", "models/props_foliage/urban_tree01_small.mdl"}
ENT.thirdModel = {"models/props_foliage/urban_tree_giant01_small.mdl", "models/props_foliage/mall_tree_medium01.mdl", "models/props_foliage/mall_tree_large01.mdl"}
ENT.lastModel = {"models/props_foliage/urban_tree_giant01.mdl", "models/props_foliage/urban_tree_giant01_a.mdl", "models/props_foliage/urban_tree_giant01_medium.mdl", "models/props_foliage/urban_tree_giant_dario.mdl"}
ENT.entName = "tp8_tree_big"
ENT.fruitDistance = 24
ENT.heightOfTree = 192
