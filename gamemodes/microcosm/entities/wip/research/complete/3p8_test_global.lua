--[[
	3p8_test_global
	Test: 		To become globally offensive, one must find out how to use global variables and if they work accross entities.

	Results: 	it works like this confirmed. careful of the server/clientside tho.
				((
					] give 3p8_test_global
					] give 3p8_test_global2
					5
					3534
					] give 3p8_test_global2
					12
					6853
				))

	Uses:		could be used to control the autoplant functionality to prevent too many of one entity from being in existance...

]]

AddCSLuaFile()

ENT.Type = "anim"

nasheed = 0

function ENT:Initialize()
	
end

function ENT:Think()
	nasheed = nasheed + 1
end