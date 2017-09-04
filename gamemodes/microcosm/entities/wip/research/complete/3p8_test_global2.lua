--[[
	3p8_test_global2
	Test: 		To become globally offensive, one must find out how to use global variables and if they work accross entities.
				This is the entity that will read the global variable

	Results: 	check 3p8_test_global

	Uses:		could be used to control the autoplant functionality to prevent too many of one entity from being in existance...

]]

AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	print(nasheed)
end