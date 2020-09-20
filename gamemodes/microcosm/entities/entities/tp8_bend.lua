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
		   
	How to Use:	Press E to 'link' with the entity. Press R to record a starting position, q to draw a line between the previous recorded position, and 
				t to "press okay" and validate the points recorded. Pressing t does not record a new point.
	TODO:		spell gave more pts than ply provided
				
				
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
ENT.isTracking = false
ENT.devMode = true
ENT.maxSpellPoints = 24
ENT.angularTolerance = 15

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

	self.line = {Angle(4.7419967651367,1.0958023071289,0), Angle(17.125537872314,0.0041580200195313,0)}
	self.jay = {Angle(7.375301361084,0.659912109375,0), Angle(-0.33096694946289,-22.220092773438,0)}
	self.joanHex = {Angle(1.634220123291,56.13777923584,0), Angle(0.026218414306641,55.002319335938,0), Angle(-0.85479736328125,61.571804046631,0), Angle(0.84221267700195,-298.59231567383,0), Angle(-0.45262145996094,67.301147460938,0), Angle(-1.55615234375,60.476013183594,0)}

	self.spellAngles = {self.line, self.jay, self.joanHex}
	self.plyAngles = {}
end

--Have use set the ply on the ent and ent on ply
--player presses q
	--ENT:startTracking() ent uses this to start tracking own position (solves the syncing problem)
--player releases q
	--if it works, then cast spell where player is looking or something. Depends on spell. Like fire hands vs. rock toss up and punch
	--DAB SPELL???
	--for two handed motions, just have to make sure both ents passed their part of the spell required movements... might want a global list to pair them...
		--due to this pairing of ents, it is possible to have multiperson spells be made with >2 bendables.

--[[
 ▄               ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
▐░▌             ▐░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
 ▐░▌           ▐░▌ ▐░█▀▀▀▀▀▀▀█░▌▐░▌           ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
  ▐░▌         ▐░▌  ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌          
   ▐░▌       ▐░▌   ▐░█▄▄▄▄▄▄▄█░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ 
    ▐░▌     ▐░▌    ▐░░░░░░░░░░░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
     ▐░▌   ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ 
      ▐░▌ ▐░▌      ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌          
       ▐░▐░▌       ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄  ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ 
        ▐░▌        ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
         ▀          ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀ 

]]
function ENT:validate()
	--validate amongst various spells
		-- analyze if the player's movements match any of the spells...
	print("Validating...")
	--use self.tally for getting what spells to check
		--this should be preprocessed at init.

	local isGoodToCast = false
	local castDone = false

	--calculate angles of positions for player
	self.plyAngles = {}
	for i=1,#self.positions-1 do
		table.insert(self.plyAngles, self.positions[i]:Angle() - self.positions[i+1]:Angle())
	end
	self.plyRotated = self.plyAngles

	--[[prints out the angles the player just recorded
		this is how you add a new spell!]]
	if self.devMode && #self.positions > 1 then
		local addNewSpellCode = "{"
		local angles = "{"
		for i=1,#self.positions-1 do
			addNewSpellCode = 	addNewSpellCode.."Vector("..self.positions[i].x..","..self.positions[i].y..","..self.positions[i].z.."), "
			if i < #self.plyAngles then
				angles = angles.."Angle("..self.plyAngles[i].x..","..self.plyAngles[i].y..","..self.plyAngles[i].z.."), "
			end
			if i > 0 && i % 25 == 0 then
				print(addNewSpellCode)
				print(angles)
				addNewSpellCode = ""
				angles = ""
			end
		end
		addNewSpellCode = 		addNewSpellCode.."Vector("..self.positions[#self.positions].x..	","..self.positions[#self.positions].y..","..self.positions[#self.positions].z..")}"
		print(addNewSpellCode)
		angles = angles.."Angle("..self.plyAngles[#self.plyAngles].x..	","..self.plyAngles[#self.plyAngles].y..","..self.plyAngles[#self.plyAngles].z..")}"
		print(angles)
	end

	for spell=1,#self.spellAngles do
		print("Spell: "..spell.. " ******************************************************************************************")
		if !castDone then
			isGoodToCast = true
			print(#self.plyAngles..", "..#self.spellAngles[spell])
			for i=1,#self.spellAngles[spell] do
				print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
				if !self:similarDistance(self.plyAngles[i], self.spellAngles[spell][i], self.angularTolerance) then
					isGoodToCast = false
					print(i.. ": is bad")
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
		--self:EmitSound(Sound(self.Gene[math.random(#self.Gene)]))
		--shoot lightning
			--self.playa:GetForward()
		self:EmitSound(Sound(self.Jay[math.random(#self.Jay)]))

	else
		error("Error: spell not defined")
	end
end

--[[function ENT:Draw()
	--draw all the lines in a list

	--render.DrawLine( Vector startPos, Vector endPos, table color = Color( 255, 255, 255 ), boolean writeZ = false )
end]]








--q is 27	add
--r is 28	start
--t = 30	end
-- https://wiki.facepunch.com/gmod/Enums/KEY
hook.Add( "PlayerButtonDown", "ButtonUpWikiExample", function( ply, button )
	-- 	print( ply:Nick() .. " pressed " .. (button) )
	if button == 27 && ply.entitty != nil then 
		--update start position via table.insert
		for i=1,#ply.entitty do
			ply.entitty[i]:newVertex()
		end
	elseif button == 28 && ply.entitty != nil then
		--start position
		for i=1,#ply.entitty do
			ply.entitty[i]:startTracking()
		end
	elseif button == 30 && ply.entitty != nil then
		--end position
		for i=1,#ply.entitty do
			ply.entitty[i]:endTracking()
		end
	end
end)

function ENT:startTracking()
	self.isTracking = true
	self.positions = {}
	table.insert(self.positions, self.playa:GetPos() - self:GetPos())
	self.tally = 1
	self.trail = util.SpriteTrail(self, 0, self.playa:GetColor(), false, 5, 1, 5, 1/(15+1)*0.5, "trails/plasma.vmt")
end

function ENT:newVertex()
	if !self.isTracking then return end
	if self.tally < self.maxSpellPoints+1 then -- allow only up to 24 entries
		self.tally = self.tally + 1
		table.insert(self.positions, self.playa:GetPos() - self:GetPos())
		--TODO: some logic here for when the ent is in ?or near? water.
	end
end

function ENT:endTracking()
	if self.isTracking then
		self.isTracking = false
		self:validate()
		SafeRemoveEntity( self.trail )
		self.positions = {}
	end
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
	print("new.x: "..new.x.." - "..old.x.." :old.x   ".."new.y: "..new.y.." - "..old.y.." :old.y   ".."new.z: "..new.z.." - "..old.z.." :old.z")
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
