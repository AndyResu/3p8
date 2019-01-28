--[[
todo:	Teleporter will not work when going between two different ship types. id est std -> ufo
		add teleporter animation?  Like, a bunch of blue text that fills up its client display box.
		(We, in sh_shipinfo.lua) add location for UFO? Normal one could be:
		local tele = ents.Create("micro_comp_teleporter")
		tele:SetPos(micro_ship_origin+Vector(-200,-225,0)) --when facing forward, this is in the lower, back, right of the ship
		tele:Spawn()
--]]

AddCSLuaFile()

DEFINE_BASECLASS("micro_component")
ENT.Base = "micro_component"

ENT.ComponentModel = "models/props_wasteland/interior_fence002e.mdl"
ENT.ComponentScreenWidth = 230 --180
ENT.ComponentScreenHeight = 100 --90
ENT.ComponentScreenOffset = Vector(2,-27,55)
ENT.ComponentScreenRotation = Angle(0,90,90)

local sound_in_range = Sound("npc/overwatch/radiovoice/preparetoreceiveverdict.wav", 125)
local sound_tele_use = Sound("ambient/machines/teleport1.wav")

--variables to change for gameplay
local max_teleport_distance = 125
local teleporter_origin_fix = Vector(0,0,-46) --vector to be added to the origin of the teleporter's prop. Set manually :\
--Under ENT:Initialize() self.teleporter_position_relative_to_the_ship is hardcoded. It's the position of the teleporter relative to the origin and is the reason why this won't work with the ufo
--end variables to change for gameplay

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "InRange")
end

function ENT:GetComponentName()
	return "Teleporter"
end

function ENT:Initialize()
	BaseClass.Initialize(self)
	self.teleporter_distance = 0
	self.teleporter_distance_closest = 9999999
	self.teleporter_guide_of_closest = {}
	self.teleporter_guide_of_closest = 0
	teleporter_origin_fix = teleporter_origin_fix + self:GetForward()*48

	for i=1,#MICRO_SHIP_INFO do
		if self:GetShipInfo() == MICRO_SHIP_INFO[i] then
			self.teamo = i
		end
	end
	self.sound_has_played = false
end

function ENT:Use(ply)
	if not self:IsBroken() then
		--easy way to get the team the teleporter is on
		--[[for i=1,#MICRO_SHIP_INFO do
			if self:GetShipInfo() == MICRO_SHIP_INFO[i] then
				self.teamo = i
			end
		end]]

		if self.teleporter_guide_of_closest != 0 then
			--print("TELESNORT AWAYWAYS ".. self.teleporter_guide_of_closest[self.teamo])
			--ply:SetEyeAngles(ply:GetShootPos():Angle()*-1) --I know, I know, it doesn't work well.
			if self.teleporter_guide_of_closest <= #MICRO_SHIP_INFO then --the closest thing is a ship
				ply:SetPos(MICRO_SHIP_INFO[self.teleporter_guide_of_closest].teleEnt:GetPos() + teleporter_origin_fix)
			else	--the closest thing is a city
				ply:SetPos(OW_CITY_TELE_POS[self.teleporter_guide_of_closest-#MICRO_SHIP_INFO] + teleporter_origin_fix)
			end
			ply:EmitSound(sound_tele_use)
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	if not self:IsBroken() then
		if self.teleporter_guide_of_closest != 0 then
			if self.teleporter_guide_of_closest <= #MICRO_SHIP_INFO then --the closest thing is a ship
				data.HitEntity:SetPos(MICRO_SHIP_INFO[self.teleporter_guide_of_closest].teleEnt:GetPos() + teleporter_origin_fix)
			else	--the closest thing is a city
				data.HitEntity:SetPos(OW_CITY_TELE_POS[self.teleporter_guide_of_closest-#MICRO_SHIP_INFO] + teleporter_origin_fix)
			end
			data.HitEntity:EmitSound(sound_tele_use)
		end
	end
end

function ENT:Think()
	--get smallest distance away
	--7:17 AM - 0x5f3759df: you can use ent:GetShipInfo()
	--7:18 AM - 0x5f3759df: to get the ship info a player or entity is on
	if CLIENT then return end

	self.teleporter_distance_closest = 9999999

	--print("i need less going on: "..tostring(MICRO_SHIP_INFO[self.teamo].entity:GetPos()))
	self.currentPos = MICRO_SHIP_INFO[self.teamo].entity:GetPos()
	--print("22222222222222222222: "..tostring(self.currentPos))
	--t = self.teamo
	for i=1,(#MICRO_SHIP_INFO + #OW_CITY_POS) do
		if i <= #MICRO_SHIP_INFO then --to check spaceships
			self.teleporter_distance = self.currentPos:Distance(MICRO_SHIP_INFO[i].entity:GetPos())
			if self.teamo != i then
				if self.teleporter_distance < max_teleport_distance && self.teleporter_distance <= self.teleporter_distance_closest then
					self.teleporter_distance_closest = self.teleporter_distance
					--print("telepoter distance closet "..teleporter_distance_closest)
					self.teleporter_guide_of_closest = i
					self:SetInRange(true)
					--print("tele guide info ".. self.teleporter_guide_of_closest[t])
				end
			end
		else --to check OW cities
			--print(OW_CITY_POS[i-#MICRO_SHIP_INFO])
			self.teleporter_distance = self.currentPos:Distance(OW_CITY_POS[i-#MICRO_SHIP_INFO])
			if self.teleporter_distance < max_teleport_distance && self.teleporter_distance <= self.teleporter_distance_closest then
				self.teleporter_distance_closest = self.teleporter_distance
				--print("telepoter distance closet "..teleporter_distance_closest)
				self.teleporter_guide_of_closest = i
				self:SetInRange(true)
				--print("tele guide info ".. self.teleporter_guide_of_closest[t])
			end
		end
	end
	if self:GetInRange() && self.teleporter_distance_closest >= max_teleport_distance then
		self:SetInRange(false)
		self.sound_has_played =  false
	end
	if self.teleporter_distance_closest >= max_teleport_distance then
		self.teleporter_guide_of_closest = 0
	end
	if self:GetInRange() && not self.sound_has_played then
		self:EmitSound(sound_in_range)
		self.sound_has_played = true
	end
end

if CLIENT then
	function ENT:GetScreenText()
		local ship = self:GetShipInfo().entity
		local hurt = self:IsBroken()

		if hurt then
			return "Genij telepoty?",Color(255,0,255)
		elseif self:GetInRange() then
			return "In Range",Color(0,255,0)
		elseif ship:GetIsHome() then
			return "Home",Color(0,255,0)
		else
			return "Not In Range",Color(255,0,0)
		end
	end
end

function ENT:drawInfo(ship,broken)
	local text,text_color = self:GetScreenText()
	draw.SimpleText(text,"micro_big",115,80,text_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

--[[
same as
<16:49:11> "[parakeet] rerr^": function ENT:GetComponentName()
<16:49:20> "[parakeet] rerr^": function ENT.GetComponentName(self)

--]]