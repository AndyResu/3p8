--[[
	tp8_book
	Uses:		
	Todo:		
				
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
ENT.toleranceDistance = 10 --not related to above!
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
	self.Start = CurTime()
	--every x seconds grab player position, insert it into table
	self.timer_name = "bend_" .. self:EntIndex()
	timer.Create(self.timer_name,self.timeInterval,0, function() --every (some amount) seconds, update pos
		--print("time: "..CurTime())
		if IsValid(self) then
			table.insert(self.positions, self:GetPos())
		elseif !IsValid(self) then
			timer.Remove(self.timer_name)
		end
	end)
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
	local spellX = 0
	local spellY = 0
	local spellZ = 0
	local t = 0
	local relativePos = Vector(0,0,0)
	local skip = 0
	local uniquePos = {}

	--if the player stays still, they do not lose progress
		--in the future, rather than == for perfect match, this could also be a similarDistance check...
	for i=1,#self.positions-1 do
		if !(self.positions[i] == self.positions[i+1]) then
			table.insert(uniquePos, self.positions[i])
		else
			self.delta = self.delta - self.timeInterval
		end
	end

	--[[this is how you add a new spell!]]
	if self.devMode && #uniquePos > 2 then
		local addNewSpellCode = "{"
		for i=1,#uniquePos-1 do
			addNewSpellCode = 	addNewSpellCode.."Vector("..uniquePos[i].x			-uniquePos[1].x..","..uniquePos[i].y			-uniquePos[1].y..","..uniquePos[i].z			-uniquePos[1].z.."), "
		end
		addNewSpellCode = 		addNewSpellCode.."Vector("..uniquePos[#uniquePos].x	-uniquePos[1].x..","..uniquePos[#uniquePos].y	-uniquePos[1].y..","..uniquePos[#uniquePos].z	-uniquePos[1].z..")}"
		print(addNewSpellCode)
	end

	
	-- calculate total distance to use in comparing changes in vector distance
	for i=1,#uniquePos do
		
	end

	t = 0
	if #uniquePos > 2 then
		for spell=1,#self.spellList do
			print("Spell: "..spell.. " ******************************************************************************************")
			local spellStep=2
			for i=1,#uniquePos-1 do
				--t = (self.timeInterval * i) / self.delta --normalizes t from 0 to 1
				t = t + 



				print("i: ".. i.. ", spellStep: ".. spellStep)
				print(#uniquePos..", "..#self.spellList[spell])
				--might want to use the absolute value of all these x and y... hacky fix for causing the circle front, circle back problem (success depends where you start)
				spellX = self.spellList[spell][spellStep].x	*t + self.spellList[spell][spellStep-1].x
				spellY = self.spellList[spell][spellStep].y	*t + self.spellList[spell][spellStep-1].y
				spellZ = self.spellList[spell][spellStep].z *t + self.spellList[spell][spellStep-1].z
				relativePos = uniquePos[i]-uniquePos[1]
				if !(self:similarDistance(relativePos,Vector(spellX,spellY,spellZ),self.toleranceDistance)) then
				--if !(self:cosineSimilarity(relativePos,Vector(spellX,spellY,spellZ),self.tolerancePercentage)) then
					isGoodToCast = false
					print("here is bad")
					break --skips the rest of this spell
				end
				if((i/#uniquePos) > (spellStep)/#self.spellList[spell] && spellStep < #self.spellList[spell]) then --[[ Set the spell point based on time. Note, both spell and spellList are synchronized time-wise]]
					spellStep = spellStep + 1
				end
			end
			if isGoodToCast then
				self:cast(spell)
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
		local trail = util.SpriteTrail(self, 0, Color(125,125,255), false, 15, 1, 5, 1/(15+1)*0.5, "trails/plasma.vmt")
	end
	
	self.devUp = {Vector(0,0,0), Vector(0,0,36)}
	self.circleRight = {Vector(0,0,0), Vector(-8.493408203125,-17.801025390625,0), Vector(-23.04833984375,-31.111083984375,0), Vector(-38.75244140625,-37.445556640625,0), Vector(-58.468994140625,-37.95947265625,0), Vector(-76.9365234375,-31.03369140625,0), Vector(-89.710205078125,-19.916748046875,0), Vector(-99.118896484375,-2.58251953125,0), Vector(-101.33178710938,17.016357421875,0), Vector(-97.225830078125,33.444580078125,0), Vector(-86.05224609375,49.697509765625,0), Vector(-69.59423828125,60.567138671875,0), Vector(-53.0927734375,64.366943359375,0), Vector(-33.538330078125,61.789794921875,0), Vector(-16.382080078125,52.060302734375,0), Vector(-5.504638671875,39.082275390625,0), Vector(1.07666015625,20.4892578125,0)}
	self.spellList = {self.devUp, self.circleRight}
	self.spellDerivativeList = {}
	self.spellDist = {}

	-- TODO: When you use a ratio of these DistToSqr AKA self.spellDerivativeList[i], be sure to square the value at i! 
		-- https://www.wolframalpha.com/input/?i=%283%5E2%29+%2F+%2812%5E2%29
	-- Use this code to calculate the distance each spell is... can save CPU by hardcoding these with this information.
	-- https://wiki.facepunch.com/gmod/Vector:DistToSqr is faster than Vector:Distance. Not too different for my purpose.
	local result = 0
	local derivOfPos = 0
	local resultStr = ""
	local derivStr = ""
	if self.devMode && (#self.spellDerivativeList < 1 || #self.spellDist < 1) then
		self.spellDerivativeList = {}
		self.spellDist = {}
		for spell=1,#self.spellList do
			-- calculate total distance to use in comparing changes in vector distance
			result = 0
			derivStr = ""
			for i=1,#self.spellList[spell]-1 do
				derivOfPos = self.spellList[spell][i]:DistToSqr(self.spellList[spell][i+1])
				table.insert(self.spellDerivativeList[spell][i], derivOfPos)
				derivStr = derivStr..derivOfPos..", "
				result = result + derivOfPos
			end
			table.insert(self.spellDist, result)
			print("derivatives of the postions: ".. derivStr)
			resultStr = resultStr..result..", "
		end
		print("all (total-distances)^2s: "..resultStr)
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







function ENT:cosineSimilarity(new, old, percent)
	-- https://en.wikipedia.org/wiki/Cosine_similarity
	local truth = true
	local dotty = new:Dot(old)
	local a = math.sqrt(new:Dot(new))
	local b = math.sqrt(old:Dot(old))
	local cosSim = dotty / (a*b)
	cosSim = cosSim
	print("~~~~~~~~~~~~~~~~~~~~~~~ "..CurTime().." ~~~~~~~~~~~~~~~~~~~~~~~")
	print("new.x: "..new.x.." v "..old.x.." :old.x")
	print("new.y: "..new.y.." v "..old.y.." :old.y")
	print("new.z: "..new.z.." v "..old.z.." :old.z")
	print("Cosine Similarity: "..cosSim)
	print("is true if: "..1+percent.." > "..cosSim.." > "..1-percent)
	if cosSim ~= cosSim || cosSim > (1+percent) || cosSim < 1-percent then 
		truth = false
	end
	return truth
end

function ENT:dotProduct(new, old, percent)
	local truth = true
	local dotty = new:Dot(old)
	print("~~~~~~~~~~~~~~~~~~~~~~~ "..CurTime().." ~~~~~~~~~~~~~~~~~~~~~~~")
	print("new.x: "..new.x.." v "..old.x.." :old.x")
	print("new.y: "..new.y.." v "..old.y.." :old.y")
	print("new.z: "..new.z.." v "..old.z.." :old.z")
	print("dot: "..dotty)
	print("is true if: "..1+percent.." > "..dotty.." > "..1-percent)
	if dotty > (1+percent) || dotty < 1-percent then 
		truth = false
	end
	return truth
end

function ENT:similarPercent(new, old, percent)
	--each component may not be more than 'percent' % different + or - from 'orig'
	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	print("new.x: "..new.x.." - "..old.x.." :old.x")
	print("new.y: "..new.y.." - "..old.y.." :old.y")
	print("new.z: "..new.z.." - "..old.z.." :old.z")
	print("new.x - old.x > 1+percent * old.x: "..new.x - old.x.." ? ".. 1+percent* old.x)
	print("new.x - old.x < 1-percent * old.x: "..new.x - old.x.." ? ".. 1-percent* old.x)
	print("new.y - old.y > 1+percent * old.y: "..new.y - old.y.." ? ".. 1+percent* old.y)
	print("new.y - old.y < 1-percent * old.y: "..new.y - old.y.." ? ".. 1-percent* old.y)
	print("new.z - old.z > 1+percent * old.z: "..new.z - old.z.." ? ".. 1+percent* old.z)
	print("new.z - old.z < 1-percent * old.z: "..new.z - old.z.." ? ".. 1-percent* old.z)
	local truth = true
	if (new.x - old.x > 1+percent * old.x) || (new.x - old.x < 1-percent * old.x) then
		truth = false
	end
	if (new.y - old.y > 1+percent * old.y) || (new.y - old.y < 1-percent * old.y) then
		truth = false
	end
	if (new.z - old.z > 1+percent * old.z) || (new.z - old.z < 1-percent * old.z) then
		truth = false
	end
	if truth then print("truth") end
	return truth
end

function ENT:similarDistance(new, old, distance)
	--each component may not be more than 'percent' % different + or - from 'orig'
	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
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
