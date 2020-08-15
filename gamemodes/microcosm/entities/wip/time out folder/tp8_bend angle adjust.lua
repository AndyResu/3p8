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
				table.insert(self.positions, self.playa:GetPos() - self:GetPos())
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
	local t = 0

	--if the player stays still (<4 Hammer Units of movement), they do not lose progress
	self.plyUniquePos = {}
	for i=1,#self.positions-1 do
		if !(self:similarDistance(self.positions[i], self.positions[i+1], 4)) then
			table.insert(self.plyUniquePos, self.positions[i])
		else
			self.delta = self.delta - self.timeInterval
		end
	end

	local first = self.plyUniquePos[1] -- this step is important. Otherwise I just subtract everything by the first value after the first value has been made into nothing...
	for i=1,#self.plyUniquePos do
		self.plyUniquePos[i] = self.plyUniquePos[i] - first
	end

	-- calculate the angles
	self.plyAngle = {}
	self.plyAngleDeriv = {}
	for i=1,#self.plyUniquePos-1 do
		--table.insert(self.plyAngle, self.spellList[2][i]:AngleEx(self.spellList[2][i+1]))
		--print("tha unique pos: "..self:vectorToString(self.plyUniquePos[i])..", and "..self:vectorToString(self.plyUniquePos[i+1]))
		table.insert(self.plyAngle, self.plyUniquePos[i]:AngleEx(self.plyUniquePos[i+1]))
	end
	for i=1,#self.plyAngle-1 do
		table.insert(self.plyAngleDeriv, self.plyAngle[i]-self.plyAngle[i+1])
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
				--print(angleStrs)
				addNewSpellCode = ""
				angleStrs = ""
			end
		end
		addNewSpellCode = 		addNewSpellCode.."Vector("..self.plyUniquePos[#self.plyUniquePos].x	-self.plyUniquePos[1].x..","..self.plyUniquePos[#self.plyUniquePos].y	-self.plyUniquePos[1].y..","..self.plyUniquePos[#self.plyUniquePos].z	-self.plyUniquePos[1].z..")}"
		angleStrs = angleStrs.."Angle("..self.plyAngle[#self.plyUniquePos-1].x..","..self.plyAngle[#self.plyUniquePos-1].y..","..self.plyAngle[#self.plyUniquePos-1].z..")}"
		print(addNewSpellCode)
		--print(angleStrs)
	end

	local adjusted = {}
	if #self.plyUniquePos > 2 then
		local second = self.plyAngleDeriv[2]
		-- analyze if the player's movements match any of the spells...
		for spell=1,#self.spellList do
			if !castDone then
				print("Spell: "..spell.. " ******************************************************************************************")
				--rotate the playa recording to be like the spell
					--add the difference between the 2nd values
				adjusted = {}
				table.insert(adjusted, self.plyAngleDeriv[2])
				print("Adjusted: "..self:vectorToString(adjusted[1] - self.spellAngleDeriv[spell][2])..", "..1)
				for i=2,#self.plyAngleDeriv do
					table.insert(adjusted, self.plyAngleDeriv[i] - self.spellAngleDeriv[spell][2])
					print("Adjusted: "..self:vectorToString(adjusted[i])..", ".. i)
				end

				isGoodToCast = true
				print(#self.plyUniquePos..", "..#self.spellList[spell])
				for i=1,#adjusted do
					print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
					t = i / #adjusted --normalizes t from 0 to 1
					print("t: "..t)
					if t >= 1 then break end
					self.equalHere = 1
					for equal=1,#self.spellAngleDeriv[spell] do
						if equal / #self.spellAngleDeriv[spell] >= t then
							self.equalHere = equal
							break
						end
					end
					print("eql: "..self.equalHere / #self.spellAngleDeriv[spell])

					--TODO: || here for similiarDistance with a small distance tolerance for those tiny movements... and flexibility
						-- requires the vectors to be rotated :|
						-- maybe use similar distance when recording. Only record values with a change > say, 4 units?
					if !(self:similarDistance(adjusted[i],self.spellAngleDeriv[spell][self.equalHere],self.toleranceDistance)) then
						isGoodToCast = false
						print("here is bad")
						break --skips the rest of this spell
					end
				end
				if isGoodToCast then
					castDone = true
					self:cast(spell)
				end
			else break end --once cast, don't even bother comparing...
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
	
	self.devUp = {Vector(0,0,0), Vector(0,0,4.6227722167969), Vector(0,0,15.269805908203), Vector(0,0,30.341888427734), Vector(0,0,36)}
	--relative to start position {Vector(0,0,0), Vector(0,0,7.7447204589844), Vector(0,0,19.308471679688), Vector(0,0,30.341888427734), Vector(0,0,36)}
	self.circleRight = {Vector(0,0,0), Vector(2.2052001953125,8.490478515625,0), Vector(7.249267578125,19.02978515625,0), Vector(10.655395507813,23.901611328125,0.001220703125), Vector(16.659912109375,30.2958984375,0), Vector(26.113891601563,37.156494140625,0), Vector(34.064208984375,40.855224609375,0), Vector(42.514038085938,43.19775390625,0), Vector(54.159545898438,44.108154296875,0), Vector(65.558959960938,42.560302734375,0.001220703125), Vector(73.9287109375,39.632568359375,0), Vector(79.232299804688,36.94677734375,0.001220703125), Vector(90.401611328125,28.291015625,-0.00048828125), Vector(96.1650390625,21.4228515625,0.00164794921875), Vector(100.66711425781,13.56689453125,0.00164794921875), Vector(104.40673828125,2.5908203125,3.0517578125e-05), Vector(105.61804199219,-6.097900390625,0), Vector(105.6328125,-12.042724609375,0.001220703125), Vector(102.92309570313,-26.19873046875,0.001220703125), Vector(99.34765625,-34.313232421875,0), Vector(92.7158203125,-43.933837890625,0), Vector(86.448486328125,-50.0703125,0), Vector(79.258544921875,-55.094482421875,0), Vector(68.577392578125,-59.83251953125,0), Vector(60.02734375,-61.7900390625,0), 
	Vector(51.271728515625,-62.317138671875,0), Vector(39.689086914063,-60.77587890625,0), Vector(34.013671875,-59.013916015625,0), Vector(23.635620117188,-53.85400390625,3.0517578125e-05), Vector(14.564819335938,-46.48583984375,0), Vector(8.9388427734375,-39.75634765625,0), Vector(4.494384765625,-32.19482421875,0), Vector(0.609130859375,-21.174560546875,0)}

	--{Vector(0,0,0), Vector(0,0,-4.6227722167969), Vector(0,0,-15.269805908203), Vector(0,0,-30.341888427734), Vector(0,0,-36)}

	--{Vector(0,0,0), Vector(0.32171630859375,-8.913818359375,0), Vector(-0.824462890625,-17.75927734375,0), Vector(-4.57666015625,-29.03369140625,0), Vector(-8.9598388671875,-36.802001953125,0), Vector(-14.558959960938,-43.745361328125,0), Vector(-23.649047851563,-51.397705078125,0), Vector(-31.445190429688,-55.731201171875,0), Vector(-39.847106933594,-58.7255859375,0), Vector(-51.596069335938,-60.5009765625,0), Vector(-60.507629394531,-60.122314453125,0), Vector(-69.236083984375,-58.28564453125,0), Vector(-80.181213378906,-53.66064453125,0), Vector(-87.581787109375,-48.681396484375,0), Vector(-94.064331054688,-42.5546875,0), Vector(-100.97991943359,-32.892333984375,0), Vector(-104.68829345703,-24.780029296875,0), Vector(-107.01446533203,-16.169189453125,0), Vector(-107.86236572266,-4.317138671875,0), Vector(-106.85717773438,4.478759765625,0.001983642578125), Vector(-104.26983642578,13.094482421875,0), Vector(-98.888854980469,23.615966796875,0.00201416015625), Vector(-93.2568359375,30.630615234375,6.103515625e-05), Vector(-88.913757324219,34.80322265625,0.00201416015625), Vector(-76.553771972656,42.77099609375,0.001983642578125), 
	--Vector(-68.086669921875,45.809814453125,6.103515625e-05), Vector(-62.203430175781,47.09814453125,0.00201416015625), Vector(-47.501647949219,47.433837890625,0.001983642578125), Vector(-38.747314453125,45.675537109375,0.001983642578125), Vector(-30.400512695313,42.503662109375,0.001983642578125), Vector(-20.27392578125,36.1396484375,0), Vector(-13.743469238281,30.064208984375,0), Vector(-8.2991333007813,22.998779296875,0), Vector(-2.9801635742188,12.373291015625,0), Vector(-0.58648681640625,3.781005859375,0)}	

	self.spellList = {self.devUp, self.circleRight}
	self.spellAngle = {}
	self.spellAngleDeriv = {}
	self.plyUniquePos = {}
	self.plyAngle = {}
	self.plyAngleDeriv = {}

	local angleHere = 0
	if self.devMode && #self.spellAngle < 1 then
		-- these arrays may be partially filled. Empty them in preparation for inserts.
		self.spellAngle = {}
		self.spellAngleDeriv = {}
		for spell=1,#self.spellList do
			table.insert(self.spellAngle,{})
			table.insert(self.spellAngleDeriv,{})
			for i=1,#self.spellList[spell]-1 do
				angleHere = self.spellList[spell][i]:AngleEx(self.spellList[spell][i+1])
				table.insert(self.spellAngle[spell], angleHere)
				print("tha spell angle: "..self:vectorToString(angleHere))
			end
			for i=1,#self.spellAngle[spell]-1 do
				table.insert(self.spellAngleDeriv[spell], self.spellAngle[spell][i] - self.spellAngle[spell][i+1])
			end
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
	local truth = true
	if (new.x - old.x > distance) || (new.x - old.x < -distance) then
	--if (math.abs(new.x) - math.abs(old.x) > distance) then
		truth = false
	end
	if (new.y - old.y > distance) || (new.y - old.y < -distance) then
	--if (math.abs(new.y) - math.abs(old.y) > distance) then
		truth = false
	end
	if (new.z - old.z > distance) || (new.z - old.z < -distance) then
	--if (math.abs(new.z) - math.abs(old.z) > distance) then
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
