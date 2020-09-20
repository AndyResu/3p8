--[[
	tp8_bend

   __                 ______         __                                  __ 
  |  \               /      \       |  \                                |  \
 _| $$_     ______  |  $$$$$$\      | $$____    ______   _______    ____| $$
|   $$ \   /      \ | $$__/ $$      | $$    \  /      \ |       \  /      $$
 \$$$$$$  |  $$$$$$\ >$$    $$      | $$$$$$$\|  $$$$$$\| $$$$$$$\|  $$$$$$$
  | $$ __ | $$  | $$|  $$$$$$       | $$  | $$| $$    $$| $$  | $$| $$  | $$
  | $$|  \| $$__/ $$| $$__/ $$      | $$__/ $$| $$$$$$$$| $$  | $$| $$__| $$
   \$$  $$| $$    $$ \$$    $$______| $$    $$ \$$     \| $$  | $$ \$$    $$
    \$$$$ | $$$$$$$   \$$$$$$|      \\$$$$$$$   \$$$$$$$ \$$   \$$  \$$$$$$$
          | $$                \$$$$$$                                       
          | $$                                                              
		   \$$  
		   
	Uses:		
	Todo:		make the up rock spell
				
	Models:		shoe:		models/props_junk/Shoe001a.mdl
				hula:		models/props_lab/huladoll.mdl
				soda:		models/props_junk/PopCan01a.mdl
				kettle:		models/props_interiors/pot01a.mdl
				alcohol:	models/props_junk/garbage_glassbottle002a.mdl
				baby:		models/props_c17/doll01.mdl
				tiny rock:	models/props_junk/rock001a.mdl

	Sounds:		garrysmod/save_load1.wav to 4
				train:		ambient/alarms/razortrain_horn1.wav
							ambient/alarms/train_horn2.wav
							ambient/alarms/train_horn_distant1.wav
				tricity:	ambient/energy/zap5.wav 6 9				weapons/gauss/fire1.wav
				fireball:	ambient/fire/gascan_ignite1.wav         ambient/levels/streetwar/city_battle10.wav
				ignite:		ambient/fire/ignite.wav
				shore:		ambient/levels/canals/shore1.wav 1234
				zap:		ambient/levels/citadel/weapon_disintegrate4.wav 1234
				zap2:		ambient/levels/labs/electric_explosion1.wav 1-6
				wind,windup:ambient/levels/labs/teleport_preblast_suckin1.wav
				thunder:	ambient/levels/labs/teleport_postblast_thunder1.wav    ambient/levels/streetwar/city_battle11.wav
				bleeps:		ambient/levels/prison/radio_random1.wav 1-15
				rocks:		ambient/levels/streetwar/building_rubble1.wav 123
				metalrip:	ambient/levels/streetwar/city_battle12.wav
				distantexplo ambient/levels/streetwar/city_battle17.wav 18 19
				chant:		ambient/levels/streetwar/city_chant1.wav
				metalmove:	ambient/machines/wall_move1.wav 1234
				many metal in this folder ambient/materials/metal_stress3.wav
				punch:		ambient/voices/citizen_punches2.wav
				old msg:	friends/message.wav
				wind:		hl1/ambience/des_wind2.wav
				water: 		npc/ichthyosaur/snap_miss.wav
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
ENT.Jay = 	{"ambient/levels/streetwar/building_rubble1.wav", "ambient/levels/streetwar/building_rubble2.wav", "ambient/levels/streetwar/building_rubble3.wav", "ambient/levels/streetwar/building_rubble4.wav"}
ENT.JayModels = {"models/props_debris/barricade_tall01a.mdl", "models/props_debris/barricade_tall03a.mdl", "models/props_wasteland/rockcliff01k.mdl"}
ENT.playa = nil
ENT.positions = {}
ENT.timeInterval = 0.025
ENT.isTracking = false
ENT.timer_name = ""
ENT.maxLeashLength = 10
ENT.devMode = true

function ENT:Initialize()
	self:SetModel(self.Model)
	if SERVER then
		self:SetUseType( SIMPLE_USE )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableGravity(false)
			phys:SetMass(25)
		end
		self.trail = nil
	end
	self.minDistance = 99999
	
	--self.line = {Vector(0,0,0), Vector(0,0,-4.6227722167969), Vector(0,0,-15.269805908203)}
	self.line = {Vector(0,0,0), Vector(-1.2171020507813,-0.818115234375,1.8574676513672), Vector(-2.1262817382813,-1.520751953125,3.407470703125), Vector(-5.0203247070313,-4.494384765625,7.2359848022461), Vector(-7.4345092773438,-7.84326171875,10.848274230957), Vector(-8.1404418945313,-9.10107421875,12.392646789551), Vector(-9.296630859375,-11.40478515625,14.542472839355), Vector(-10.415161132813,-14.16796875,16.883415222168), Vector(-11.252014160156,-18.0107421875,20.904975891113), Vector(-10.593017578125,-16.6552734375,21.005867004395), Vector(-9.3896484375,-14.574462890625,21.506011962891), Vector(-8.3328247070313,-12.762939453125,21.602149963379), Vector(-7.103271484375,-10.85400390625,21.901870727539), Vector(-4.0596923828125,-7.03271484375,22.700859069824), Vector(-2.7857666015625,-5.652099609375,23.097320556641), Vector(0.82330322265625,-2.033203125,23.683990478516), Vector(0.53192138671875,-1.8740234375,22.580192565918), Vector(-0.44091796875,-2.025146484375,20.486083984375), Vector(-0.906982421875,-2.12646484375,19.377571105957), Vector(-2.0017700195313,-2.618896484375,17.254821777344), Vector(-2.997802734375,-3.212890625,15.128791809082), Vector(-3.9791259765625,-3.854736328125,12.864669799805), Vector(-5.264892578125,-5.05322265625,9.5811538696289), Vector(-6.2841796875,-6.228271484375,6.9905776977539), Vector(-7.3739013671875,-7.85986328125,4.1043472290039)}
	self.circleRight = {Vector(0,0,0), Vector(2.3302001953125,7.8427734375,0), Vector(5.9163818359375,15.1962890625,0), Vector(12.47900390625,23.898193359375,0), Vector(18.563598632813,29.36767578125,0), Vector(23.185180664063,32.497802734375,0), Vector(35.60595703125,37.754638671875,0), Vector(43.651733398438,39.239013671875,0), Vector(51.832092285156,39.382080078125,0), Vector(62.564880371094,37.4853515625,0), Vector(70.200500488281,34.547119140625,0), Vector(77.250183105469,30.394775390625,0), Vector(85.410339355469,23.169677734375,0), Vector(90.385498046875,16.674560546875,0), Vector(94.226867675781,9.450927734375,0), Vector(97.409362792969,-0.97314453125,0), Vector(98.257873535156,-9.11083984375,0), Vector(97.758728027344,-17.27685546875,0), Vector(95.025695800781,-27.827880859375,0), Vector(91.497253417969,-35.20947265625,0), Vector(86.804809570313,-41.91162109375,0), Vector(78.961669921875,-49.4794921875,0), Vector(72.096313476563,-53.929931640625,0), Vector(64.593566894531,-57.19287109375,0), Vector(53.951843261719,-59.547607421875,0), 
	Vector(45.77294921875,-59.7548828125,0), Vector(37.6708984375,-58.61669921875,0), Vector(27.367004394531,-55.064453125,0), Vector(20.284973144531,-50.967529296875,0), Vector(13.9716796875,-45.763671875,0), Vector(7.0423583984375,-37.35107421875,0), Vector(3.144287109375,-30.15771484375,0), Vector(0.48046875,-22.421875,0), Vector(-1.0322265625,-11.62841796875,0)}	
	self.jay = {Vector(0,0,0), Vector(-1.9387817382813,1.428955078125,-0.95860290527344), Vector(-3.6966857910156,3.43798828125,-0.94961547851563), Vector(-6.8099060058594,7.5498046875,-1.1457061767578), Vector(-8.097412109375,9.545166015625,-1.1428527832031), Vector(-10.934265136719,14.927490234375,-1.1394805908203), Vector(-11.537200927734,16.531005859375,-0.94606018066406), Vector(-12.506256103516,19.421630859375,-0.758544921875), Vector(-13.706604003906,22.343994140625,-1.5401916503906), Vector(-14.802154541016,22.359619140625,-4.3479156494141), Vector(-15.177673339844,22.2626953125,-5.5309448242188), Vector(-16.157867431641,22.219482421875,-8.9108734130859), Vector(-16.884582519531,22.035400390625,-12.570083618164), Vector(-17.133728027344,21.97265625,-13.980941772461), Vector(-17.502990722656,21.87939453125,-17.161499023438), Vector(-17.705139160156,21.82861328125,-20.13850402832), Vector(-17.731414794922,21.82177734375,-23.233947753906)}

	self.spellList = {self.line, --[[self.circleRight,]] self.jay}
	self.plyUniquePos = {}
	self.plyRotated = {}
end

--Have use set the ply on the ent and ent on ply
--player presses q
	--ENT:startTracking() ent uses this to start tracking own position (solves the syncing problem)
--player releases q
	--if it works, then cast spell where player is looking or something. Depends on spell. Like fire hands vs. rock toss up and punch
	--DAB SPELL???
	--for two handed motions, just have to make sure both ents passed their part of the spell required movements... might want a global list to pair them...
		--due to this pairing of ents, it is possible to have multiperson spells be made with >2 bendables.

--[[							,
 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ 
▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌               ▐░▌     
▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     
▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     
▐░▌          ▐░▌     ▐░▌  ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌               ▐░▌     
▐░▌          ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     
▐░▌          ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     
 ▀            ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀   
]]
function ENT:LookForASpellAndCastIt()
	--validate amongst various spells: https://en.wikipedia.org/wiki/Fréchet_distance also https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/31922/versions/5/screenshot.jpg
	print("wow, we doing it now!!!")
	local isGoodToCast = true
	local castDone = false
	local t = 0

	--if the player stays still (<1 Hammer Units of movement), they do not lose progress
	self.plyUniquePos = {}
	for i=1,#self.positions-1 do
		if !(self:similarDistance(self.positions[i], self.positions[i+1], 1)) then
			table.insert(self.plyUniquePos, self.positions[i])
		end
	end

	--make all positions relative to the first
	local first = self.plyUniquePos[1]
	for i=1,#self.plyUniquePos do
		self.plyUniquePos[i] = self.plyUniquePos[i] - first
	end

	--[[this is how you add a new spell!]]
	if self.devMode && #self.plyUniquePos > 2 then
		local addNewSpellCode = "{"
		for i=1,#self.plyUniquePos-1 do
			addNewSpellCode = 	addNewSpellCode.."Vector("..self.plyUniquePos[i].x	-self.plyUniquePos[1].x..","..self.plyUniquePos[i].y	-self.plyUniquePos[1].y..","..self.plyUniquePos[i].z	-self.plyUniquePos[1].z.."), "
			if i > 0 && i % 25 == 0 then
				print(addNewSpellCode)
				addNewSpellCode = ""
			end
		end
		addNewSpellCode = 		addNewSpellCode.."Vector("..self.plyUniquePos[#self.plyUniquePos].x	-self.plyUniquePos[1].x..","..self.plyUniquePos[#self.plyUniquePos].y	-self.plyUniquePos[1].y..","..self.plyUniquePos[#self.plyUniquePos].z	-self.plyUniquePos[1].z..")}"
		print(addNewSpellCode)
	end

	if #self.plyUniquePos > 3 then
		-- analyze if the player's movements match any of the spells...
		for spell=1,#self.spellList do
			if !castDone then
				print("Spell: "..spell.. " ******************************************************************************************")
				isGoodToCast = true
				print(#self.plyUniquePos..", "..#self.spellList[spell])
				self.plyRotated = self.plyUniquePos
				--for the current point i, look for the closest point in the current spell. If that "leash length" is greater than self.maxLeashLength, then break.
				for i=2,#self.plyRotated do
					print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
					for j=2,#self.spellList[spell] do
						--always looking for a shorter leash point
						local angle = self.spellList[spell][2]:Angle() - self.plyRotated[i]:Angle() --[[(self.plyRotated[i]):AngleEx(self.spellList[spell][2]:Angle())]]
						--print("Angle: ".. self:vectorToString(angle))
						self.plyRotated[i]:Rotate(angle)
						--^this line rotates the vector, then gets the distance.
						local dist = self.plyRotated[i]:Distance(self.spellList[spell][j])
						if dist < self.minDistance then
							self.minDistance = dist
						end
					end
					print("Shortest Distance is: "..self.minDistance)
					print("plyRotated: "..self:vectorToString(self.plyRotated[i]))
					--if leash is longer than allowed length
					if self.minDistance > self.maxLeashLength then
						isGoodToCast = false
						print(i.. ": is bad")
						break --skips the rest of this spell
					end
					self.minDistance = 99999
				end
				if isGoodToCast then
					castDone = true
					self:cast(spell)
				end
			else break end --once cast, don't even bother comparing...
		end
	end
end


--[[
    ,o888888o.           .8.            d888888o. 8888888 8888888888 
   8888     `88.        .888.         .`8888:' `88.     8 8888       
,8 8888       `8.      :88888.        8.`8888.   Y8     8 8888       
88 8888               . `88888.       `8.`8888.         8 8888       
88 8888              .8. `88888.       `8.`8888.        8 8888       
88 8888             .8`8. `88888.       `8.`8888.       8 8888       
88 8888            .8' `8. `88888.       `8.`8888.      8 8888       
`8 8888       .8' .8'   `8. `88888.  8b   `8.`8888.     8 8888       
   8888     ,88' .888888888. `88888. `8b.  ;8.`8888     8 8888       
    `8888888P'  .8'       `8. `88888. `Y8888P ,88P'     8 8888
]]

function ENT:cast(spell)
	print("cast: "..spell)
	if spell == 1 then
		--line
		self:EmitSound(Sound(self.Up[math.random(#self.Up)]))
	elseif spell == 2 then
		--jay
		self:EmitSound(Sound(self.Jay[math.random(#self.Jay)]))
		local stepsUp = 75
		local height = 55
		if SERVER then
			self.playa:SetPos(self:GetPos() + Vector(0,0,30))
			self.playa:SetVelocity(Vector(0,0,290))
			--raise rock out of ground to lift
			rock = ents.Create("prop_physics")
			if ( !IsValid( rock ) ) then return end
			rock:SetPos(self.playa:GetPos() + Vector(0,0,-1*height-35))
			rock:SetModel(self.JayModels[math.random(#self.JayModels)])
			rock:PhysicsInit( SOLID_VPHYSICS )
			--rock:SetSolid( SOLID_VPHYSICS )
			rock:GetPhysicsObject():EnableGravity(false)
			rock:GetPhysicsObject():SetMass(25)
			rock:SetAngles(Angle(0,math.random(0,359),0))
			rock:Spawn()
			rock:GetPhysicsObject():EnableMotion(false)
			--slide rock up
			for i=1,stepsUp do
				timer.Simple( (i/stepsUp)/3, function() rock:SetPos(rock:GetPos()+Vector(0,0,height/stepsUp)) end )
			end
			--slide rock into ground
			timer.Simple(5, function() 
				for i=1,stepsUp do
					timer.Simple( i/stepsUp, function() rock:SetPos(rock:GetPos()+Vector(0,0,-2.5*height/stepsUp)) end )
				end
			end)
			--remove all rocks ever created. Maybe global array and remove them all if they exist
			timer.Simple( 7, function() 
				rock:Remove()
			end )
		end
	elseif spell == 3 then
		--circleRight
		self:EmitSound(Sound(self.Gene[math.random(#self.Gene)]))
		--shoot lightning
			self.playa:GetForward()
	else
		error("Error: spell not defined")
	end
end










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
	--TODO: some logic here for when the ent is in ?or near? water.
	self.trail = util.SpriteTrail(self, 0, self.playa:GetColor(), false, 5, 1, 5, 1/(15+1)*0.5, "trails/plasma.vmt")
end

hook.Add( "PlayerButtonUp", "ButtonUpWikiExample", function( ply, button )
	-- 	print( ply:Nick() .. " released " .. (button) )
	if button == 27 && ply.entitty != nil then 
		for i=1,#ply.entitty do
			ply.entitty[i]:stopTracking()
		end
	end
end)

function ENT:stopTracking()
	print(" ")
	print(" ")
	print("forzen like Elsa")
	if !self.isTracking then return end
	self.isTracking = false
	--check if it was a good spell or not
	self:LookForASpellAndCastIt()
	--remove timer
	timer.Remove(self.timer_name)
	--TODO: for water grab and throw, logic here:
	--if !self.hasWater then
		SafeRemoveEntity( self.trail )
	--end
end










function ENT:Use(ply)
	self.playa = ply
	if !IsValid(ply.entitty) then ply.entitty = {} end
	table.insert(ply.entitty, self)
	--print("used")
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
	--each component may not be more than 'distance' different + or - from 'orig'
	--print("new.x: "..new.x.." - "..old.x.." :old.x   ".."new.y: "..new.y.." - "..old.y.." :old.y   ".."new.z: "..new.z.." - "..old.z.." :old.z")
	local truth = true
	local nox = math.abs(new.x - old.x)
	local noy = math.abs(new.y - old.y)
	local noz = math.abs(new.z - old.z)
	--the 360-distance fixes the issue where the angle is like -359 due to going over an axis
	if (nox > distance) && (nox < 360-distance) then
		truth = false
	end
	if (noy > distance) && (noy < 360-distance) then
		truth = false
	end
	if (noz > distance) && (noz < 360-distance) then
		truth = false
	end
	--if truth then print("truth") end
	return truth
end

--TODO: for debugging, remove when done
function ENT:vectorToString(vec)
	local toReturn = ""
	toReturn = "("..vec.x..", "..vec.y..", "..vec.z..")"
	return toReturn
end
