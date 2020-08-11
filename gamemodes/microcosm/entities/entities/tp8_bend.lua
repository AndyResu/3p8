--[[
	tp8_bend
	Uses:		
	Todo:		rotation problem, make the up rock spell
				
	Models:		shoe:		models/props_junk/Shoe001a.mdl
				hula:		models/props_lab/huladoll.mdl
				soda:		models/props_junk/PopCan01a.mdl
				kettle:		models/props_interiors/pot01a.mdl
				alcohol:	models/props_junk/garbage_glassbottle002a.mdl
				baby:		models/props_c17/doll01.mdl
				tiny rock:	models/props_junk/rock001a.mdl
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/props_junk/Shoe001a.mdl"
ENT.Up = 	{"vo/npc/female01/upthere01.wav", "vo/npc/female01/upthere02.wav"}
ENT.Down = 	{"vo/npc/male01/getdown02.wav"}
ENT.Back = 	{"vo/npc/male01/overhere01.wav"}
ENT.Fwd = 	{"vo/npc/vortigaunt/forward.wav", "vo/npc/vortigaunt/onward.wav", "vo/npc/vortigaunt/yesforward.wav"}
ENT.Left = 	{"vo/ravenholm/shotgun_keepitclose.wav"}
ENT.Right = {"vo/npc/vortigaunt/vanswer12.wav"}
ENT.Gene = 	{"vo/npc/vortigaunt/satisfaction.wav", "vo/npc/vortigaunt/ourplacehere.wav", "vo/npc/vortigaunt/dreamed.wav"}
ENT.Start = -1
ENT.End = -1
ENT.playa = nil
ENT.positions = {}
ENT.timeInterval = 0.05
ENT.isTracking = false
ENT.delta = 0
ENT.timer_name = ""
ENT.tolerancePercentage = 0.99 -- if 1, will divide by zero
ENT.toleranceDistance = 16 --not related to above!
ENT.devMode = true

--q is 27
hook.Add( "PlayerButtonDown", "ButtonUpWikiExample", function( ply, button )
	-- 	print( ply:Nick() .. " pressed " .. (button) )
	if button == 27 && ply.entitty != nil then 
		for i=1,#ply.entitty do
			ply.entitty[i]:startTracking()
		end
	end
end)

function ENT:startTracking()
	if self.isTracking then return end
	self.isTracking = true
	self.positions = {}
	self.tally = 0
	self.Start = CurTime()
	--every x seconds grab player position, insert it into table
	self.timer_name = "bend_" .. self:EntIndex()
	timer.Create(self.timer_name,self.timeInterval,0, function() --every (some amount) seconds, update pos
		--print("time: "..CurTime())
		if IsValid(self) then
			if self.tally < 251 then -- allow only up to 250 entries
				self.tally = self.tally + 1
				table.insert(self.positions, self:GetPos()-self.playa:GetPos())
			end
		elseif !IsValid(self) then
			timer.Remove(self.timer_name)
		end
	end)
	self.trail = util.SpriteTrail(self, 0, self.playa:GetColor(), false, 5, 1, 5, 1/(15+1)*0.5, "trails/plasma.vmt")
end

-- if self:similar(self.movementRecord[1], self.spell1[1], self.tolerancePercentage) then
-- 	--cast spell
-- 	self:cast()
-- end

hook.Add( "PlayerButtonUp", "ButtonUpWikiExample", function( ply, button )
	-- 	print( ply:Nick() .. " released " .. (button) )
	if button == 27 && ply.entitty != nil then 
		for i=1,#ply.entitty do
			ply.entitty[i]:stopTracking()
		end
	end
end)

function ENT:stopTracking()
	print("forzen like Elsa")
	if !self.isTracking then return end
	self.isTracking = false
	self.End = CurTime()
	self.delta = self.End - self.Start
	--check if it was a good spell or not
	self:LookForASpellAndCastIt()
	--remove timer
	timer.Remove(self.timer_name)
	SafeRemoveEntity( self.trail )
end

--Have use set the ply on the ent and ent on ply
--player presses q, sends curtime to start ?on the ent? (where? ply? globalArray[ply, value]?)
	--ENT:startTracking() ent uses this to start tracking own position (solves the syncing problem)
--player releases q, sends curtime to end ?on the ent? (where?)
	--ent uses this to calc time to see if it worked
		--checks if at the right time, the pos is close to an equation's same point at that time.
		--if it works, then cast spell where player is looking or something. Depends on spell. Like fire hands vs. rock toss up and punch
		--DAB SPELL???
		--for two handed motions, just have to make sure both ents passed their part of the spell required movements... might want a global list to pair them...
			--due to this pairing of ents, it is possible to have multiperson spells be made with >2 bendables.

function ENT:LookForASpellAndCastIt()
	--validate amongst various spells
	print("wow, we doing it now!!!")
	--use self.delta to map
	--imagine a line, divided into 0.1 time segments
	local isGoodToCast = true
	local castDone = false
	local spellX = 0
	local spellY = 0
	local spellZ = 0
	local t = 0
	local relativePos = Vector(0,0,0)
	local relativePosSpell = Vector(0,0,0)
	local percentDifference = -1

	--if the player stays still, they do not lose progress
		--in the future, rather than == for perfect match, this could also be a similarDistance check...
	self.plyUniquePos = {}
	for i=1,#self.positions-1 do
		if !(self.positions[i] == self.positions[i+1]) then
			table.insert(self.plyUniquePos, self.positions[i])
		else
			self.delta = self.delta - self.timeInterval
		end
	end

	-- calculate the angles
	for i=1,#self.plyUniquePos-1 do
		table.insert(self.plyAngle, self.plyUniquePos[i]:AngleEx(self.plyUniquePos[i+1]))
	end

	--[[this is how you add a new spell!]]
	if self.devMode && #self.plyUniquePos > 2 then
		local addNewSpellCode = "{"
		local angleStrs = "{"
		for i=1,#self.plyUniquePos-1 do
			addNewSpellCode = 	addNewSpellCode.."Vector("..self.plyUniquePos[i].x	-self.plyUniquePos[1].x..","..self.plyUniquePos[i].y	-self.plyUniquePos[1].y..","..self.plyUniquePos[i].z	-self.plyUniquePos[1].z.."), "
			if i <= #self.plyUniquePos-2 then
				angleStrs = angleStrs.."Angle("..self.plyAngle[i].x..","..self.plyAngle[i].y..","..self.plyAngle[i].z.."), "
			end
			if i > 0 && i % 25 == 0 then
				print(addNewSpellCode)
				print(angleStrs)
				addNewSpellCode = ""
				angleStrs = ""
			end
		end
		addNewSpellCode = 		addNewSpellCode.."Vector("..self.plyUniquePos[#self.plyUniquePos].x	-self.plyUniquePos[1].x..","..self.plyUniquePos[#self.plyUniquePos].y	-self.plyUniquePos[1].y..","..self.plyUniquePos[#self.plyUniquePos].z	-self.plyUniquePos[1].z..")}"
		angleStrs = angleStrs.."Angle("..self.plyAngle[#self.plyUniquePos-1].x..","..self.plyAngle[#self.plyUniquePos-1].y..","..self.plyAngle[#self.plyUniquePos-1].z..")}"
		print(addNewSpellCode)
		print(angleStrs)
	end

	if #self.plyUniquePos > 2 then
		-- analyze if the player's movements match any of the spells...
		for spell=1,#self.spellList do
			if !castDone then
				print("Spell: "..spell.. " ******************************************************************************************")
				isGoodToCast = true
				for i=1,#self.plyUniquePos do
					print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
					t = i / #self.plyUniquePos --normalizes t from 0 to 1
					print("t: "..t)
					self.equalHere = 1
					for equal=1,#self.spellPercent[spell] do
						if self.spellPercent[spell][equal] >= t then
							self.equalHere = equal
							break
						end
					end
					-- then we have to make up a small difference between the two values, find that vector, and compare the resulting vector with the player's equivelent
					--[[if self.equalHere > 1 then
						percentDifference = self.spellPercent[spell][self.equalHere] - t
						print("spell: "..self.spellPercent[spell][self.equalHere])
						print("% diff: "..percentDifference)
						print("(("..self:vectorToString(self.spellList[spell][self.equalHere-1]).." - "..self:vectorToString(self.spellList[spell][self.equalHere])..") * "..(1-percentDifference)..") + "..self:vectorToString(self.spellList[spell][self.equalHere-1]))
						relativePosSpell = ((self.spellList[spell][self.equalHere] - self.spellList[spell][self.equalHere-1]) * (1-percentDifference)) + self.spellList[spell][self.equalHere-1]
					else
						relativePosSpell = self.spellList[spell][self.equalHere]
						--print(spell)
						--print(self.equalHere)
						print("test: "..self:vectorToString(self.spellList[spell][self.equalHere]))
					end

					relativePos = self.plyUniquePos[i]-self.plyUniquePos[1] ]]
					print(#self.plyUniquePos..", "..#self.spellList[spell])

					if !(self:similarDistance(self.plyAngle[i],self.spellAngle[spell][self.equalHere],self.toleranceDistance)) then
						isGoodToCast = false
						print("here is bad")
						break --skips the rest of this spell
					end
				end
				if isGoodToCast then
					castDone = true
					self:cast(spell)
				end
			end
		end
	end
end

function ENT:Initialize()
	self:SetModel(self.Model)
	if SERVER then
		self:SetUseType( SIMPLE_USE )
		--self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableGravity(false)
			--phys:EnableDrag(false)
			phys:SetMass(25)
		end
		self.trail = nil
	end
	self.equalHere = -1
	
	self.devUp = {Vector(0,0,0), Vector(0,0,-4.6227722167969), Vector(0,0,-15.269805908203), Vector(0,0,-30.341888427734), Vector(0,0,-36)}
	--relative to start position {Vector(0,0,0), Vector(0,0,7.7447204589844), Vector(0,0,19.308471679688), Vector(0,0,30.341888427734), Vector(0,0,36)}
	self.circleRight = {Vector(0,0,0), Vector(0.32171630859375,-8.913818359375,0), Vector(-0.824462890625,-17.75927734375,0), Vector(-4.57666015625,-29.03369140625,0), Vector(-8.9598388671875,-36.802001953125,0), Vector(-14.558959960938,-43.745361328125,0), Vector(-23.649047851563,-51.397705078125,0), Vector(-31.445190429688,-55.731201171875,0), Vector(-39.847106933594,-58.7255859375,0), Vector(-51.596069335938,-60.5009765625,0), Vector(-60.507629394531,-60.122314453125,0), Vector(-69.236083984375,-58.28564453125,0), Vector(-80.181213378906,-53.66064453125,0), Vector(-87.581787109375,-48.681396484375,0), Vector(-94.064331054688,-42.5546875,0), Vector(-100.97991943359,-32.892333984375,0), Vector(-104.68829345703,-24.780029296875,0), Vector(-107.01446533203,-16.169189453125,0), Vector(-107.86236572266,-4.317138671875,0), Vector(-106.85717773438,4.478759765625,0.001983642578125), Vector(-104.26983642578,13.094482421875,0), Vector(-98.888854980469,23.615966796875,0.00201416015625), Vector(-93.2568359375,30.630615234375,6.103515625e-05), Vector(-88.913757324219,34.80322265625,0.00201416015625), Vector(-76.553771972656,42.77099609375,0.001983642578125), 
	Vector(-68.086669921875,45.809814453125,6.103515625e-05), Vector(-62.203430175781,47.09814453125,0.00201416015625), Vector(-47.501647949219,47.433837890625,0.001983642578125), Vector(-38.747314453125,45.675537109375,0.001983642578125), Vector(-30.400512695313,42.503662109375,0.001983642578125), Vector(-20.27392578125,36.1396484375,0), Vector(-13.743469238281,30.064208984375,0), Vector(-8.2991333007813,22.998779296875,0), Vector(-2.9801635742188,12.373291015625,0), Vector(-0.58648681640625,3.781005859375,0)}	

	--{Vector(0,0,0), Vector(-1.7374267578125,-8.3466796875,-0.001220703125), Vector(-6.2528076171875,-18.77001953125,0), Vector(-11.093627929688,-25.777587890625,0.0015869140625), Vector(-18.905151367188,-33.709228515625,0), Vector(-26.212158203125,-38.497314453125,0.0015869140625), Vector(-33.924438476563,-42.11865234375,-0.001220703125), Vector(-44.771850585938,-44.68408203125,0), Vector(-53.504028320313,-44.94873046875,0.0015869140625), Vector(-64.609008789063,-43.27001953125,0.001617431640625), Vector(-72.626403808594,-40.406494140625,0.001617431640625), Vector(-82.380493164063,-34.62158203125,0.0015869140625), Vector(-88.736206054688,-28.95556640625,0.001617431640625), Vector(-94.076049804688,-22.3251953125,0.001617431640625), Vector(-99.368957519531,-12.294921875,0.001617431640625), Vector(-101.82897949219,-4.14453125,0.001617431640625), Vector(-102.91741943359,4.299072265625,0.001617431640625), Vector(-102.18957519531,15.616943359375,0.001617431640625), Vector(-100.02856445313,23.851318359375,0.001617431640625), Vector(-96.544860839844,31.619384765625,0.001617431640625), Vector(-90.010681152344,40.8896484375,0.001617431640625), Vector(-83.865539550781,46.781494140625,0.001617431640625), Vector(-76.836364746094,51.58447265625,0.001617431640625), Vector(-66.421691894531,56.07421875,0.001617431640625), Vector(-58.103454589844,57.88720703125,0.001617431640625), 
	--Vector(-49.600463867188,58.309814453125,0.001617431640625), Vector(-38.374633789063,56.6962890625,0.001617431640625), Vector(-30.3349609375,53.895751953125,0.001617431640625), Vector(-22.8642578125,49.813232421875,0.001617431640625), Vector(-14.1357421875,42.572021484375,0.001617431640625), Vector(-8.7440185546875,35.9833984375,0.001617431640625), Vector(-4.5072021484375,28.59912109375,0.001617431640625), Vector(-0.8486328125,17.8642578125,0.001617431640625), Vector(0.3062744140625,9.429443359375,0.001617431640625)}	
	self.spellList = {self.devUp, self.circleRight}
	self.spellDerivativeList = {}
	self.spellAngle = {}
	self.spellDist = {}
	self.spellPercent = {} -- the value at the index represents at what value (the % of the whole) the corresponding index of the spell ends and another begins.
	-- so if you have 10 points evenly spaced, the 1st index is 0% to 10%, and the value is 0.1
	self.plyUniquePos = {}
	self.plyDerivativeList = {}
	self.plyAngle = {}
	self.plyDist = 0
	self.plyPercent = {}

	-- Use this code to calculate the distance each spell is slow... can save CPU by hardcoding these with this information.
	-- https://wiki.facepunch.com/gmod/Vector:DistToSqr is faster than Vector:Distance. Not too different for my purpose...?
	local result = 0
	local derivOfPos = 0
	local angleHere = 0
	local resultStr = ""
	local derivStr = ""
	local percent = 0
	local totalDist = 0
	local cumulativePer = 0
	if self.devMode && (#self.spellDerivativeList < 1 || #self.spellDist < 1 || #self.spellPercent < 1 || #self.spellAngle < 1) then
		-- these arrays may be partially filled. Empty them in preparation for inserts.
		self.spellDerivativeList = {}
		self.spellDist = {}
		self.spellPercent = {}
		self.spellAngle = {}
		for spell=1,#self.spellList do
			-- calculate total distance to use in comparing changes in vector distance
			result = 0
			derivStr = ""
			table.insert(self.spellDerivativeList,{})
			table.insert(self.spellAngle,{})
			for i=1,#self.spellList[spell]-1 do
				derivOfPos = self.spellList[spell][i]:Distance(self.spellList[spell][i+1])
				angleHere = self.spellList[spell][i]:AngleEx(self.spellList[spell][i+1])
				table.insert(self.spellDerivativeList[spell], derivOfPos)
				table.insert(self.spellAngle[spell], angleHere)
				derivStr = derivStr..derivOfPos..", "
				result = result + derivOfPos
			end
			table.insert(self.spellDist, result)
			print("derivatives of the postions: ".. derivStr)
			resultStr = resultStr..result..", "
		end
		print("all (total-distances)^2s: "..resultStr)

		--for every spell, calculate at what percentage of the whole the continous linear piecewise function must go to the next segment
		for spell=1,#self.spellList do
			derivStr = ""
			table.insert(self.spellPercent,{})
			totalDist = self.spellDist[spell]
			cumulativePer = 0
			for i=1,#self.spellList[spell]-1 do
				percent = self.spellDerivativeList[spell][i] / totalDist
				cumulativePer = cumulativePer + percent
				table.insert(self.spellPercent[spell], cumulativePer)
				derivStr = derivStr..cumulativePer..", "
			end
			print("For spell: "..spell..", percents of the postions: ".. derivStr)
		end
	end
end

function ENT:Use(ply)
	self.playa = ply
	if !IsValid(ply.entitty) then ply.entitty = {} end 
	table.insert(ply.entitty, self)
	print("used")
end

function ENT:cast(spell)
	print("cast: "..spell)
	if spell == 1 then
		--devUp
		self:EmitSound(Sound(self.Up[math.random(#self.Up)]))
	elseif spell == 2 then
		--circleRight
		self:EmitSound(Sound(self.Gene[math.random(#self.Gene)]))
		--shoot lightning
			self.playa:GetForward()
	else
		error("Error: spell not defined")
	end

end

function ENT:OnRemove()
	--once ent is removed, remove self from player's entitty table of linked bend(ables) entities.
	if self.playa != nil && self.playa.entitty != nil then
		for i=1,#self.playa.entitty do
			if self.playa.entitty[i] == self then
				table.remove(self.playa.entitty, i)
			end
		end
	end
end

function ENT:similarDistance(new, old, distance)
	--each component may not be more than 'percent' % different + or - from 'orig'
	print("new.x: "..new.x.." - "..old.x.." :old.x")
	print("new.y: "..new.y.." - "..old.y.." :old.y")
	print("new.z: "..new.z.." - "..old.z.." :old.z")
	-- print("new.x - old.x > distance:  "..new.x - old.x.." ? ".. distance)
	-- print("new.x - old.x < -distance: "..new.x - old.x.." ? "..-distance)
	-- print("new.y - old.y > distance:  "..new.y - old.y.." ? ".. distance)
	-- print("new.y - old.y < -distance: "..new.y - old.y.." ? "..-distance)
	-- print("new.z - old.z > distance:  "..new.z - old.z.." ? ".. distance)
	-- print("new.z - old.z < -distance: "..new.z - old.z.." ? "..-distance)
	local truth = true
	if (new.x - old.x > distance) || (new.x - old.x < -distance) then
		truth = false
	end
	if (new.y - old.y > distance) || (new.y - old.y < -distance) then
		truth = false
	end
	if (new.z - old.z > distance) || (new.z - old.z < -distance) then
		truth = false
	end
	--if truth then print("truth") end
	return truth
end

function ENT:vectorToString(vec)
	local toReturn = ""
	toReturn = "("..vec.x..", "..vec.y..", "..vec.z..")"
	return toReturn
end
