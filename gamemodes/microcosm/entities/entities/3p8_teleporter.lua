--[[
	3p8_teleporter
	Uses:		The non-ship teleporter

	Todo:		Make it link up in memory to the micro_comp_teleporter. 
				Maybe make a list of teleporter-containing entities
					
]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ComponentModel = "models/props_wasteland/interior_fence002e.mdl"
ENT.ComponentScreenWidth = 230 --180
ENT.ComponentScreenHeight = 100 --90
ENT.ComponentScreenOffset = Vector(2,-27,55)
ENT.ComponentScreenRotation = Angle(0,90,90)

ENT.CityNumber = nil

local sound_in_range = Sound("npc/overwatch/radiovoice/preparetoreceiveverdict.wav", 125)
local sound_tele_use = Sound("ambient/machines/teleport1.wav")

--variables to change for gameplay
local max_teleport_distance = 125
local teleporter_origin_fix = Vector(0,0,-48) --vector to be added to the origin of the teleporter's prop. Set manually :\
--Under ENT:Initialize() self.teleporter_position_relative_to_the_ship is hardcoded. It's the position of the teleporter relative to the origin and is the reason why this won't work with the ufo
--end variables to change for gameplay

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "InRange")
end

function ENT:GetComponentName()
	return "Teleporter"
end

function ENT:Initialize()
	self:SetModel(self.ComponentModel)
	self:PhysicsInitStandard()
	
	self.teleporter_distance = 0
	self.teleporter_distance_closest = 9999999
	self.teleporter_guide_of_closest = {}
	self.teleporter_guide_of_closest = 0

	self.sound_has_played = false

	if SERVER then
		self:GetPhysicsObject():EnableMotion(false)
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:Use(ply)
	if self.teleporter_guide_of_closest != 0 then
		--print("TELESNORT AWAYWAYS ".. self.teleporter_guide_of_closest[self.teamo])
		ply:SetEyeAngles(ply:GetShootPos():Angle()*-1) --I know, I know, it doesn't work well.
		ply:SetPos(MICRO_SHIP_INFO[self.teleporter_guide_of_closest].teleEnt:GetPos() + teleporter_origin_fix)
		ply:EmitSound(sound_tele_use)
	end
end

function ENT:Think()
	--get smallest distance away
	--7:17 AM - 0x5f3759df: you can use ent:GetShipInfo()
	--7:18 AM - 0x5f3759df: to get the ship info a player or entity is on
	if CLIENT then return end

	self.teleporter_distance_closest = 9999999
	self.currentPos = OW_CITY_POS[self.CityNumber]
	for i=1,#MICRO_SHIP_INFO do
		self.teleporter_distance = self.currentPos:Distance(MICRO_SHIP_INFO[i].entity:GetPos())
		if self.teleporter_distance < max_teleport_distance && self.teleporter_distance <= self.teleporter_distance_closest then
			self.teleporter_distance_closest = self.teleporter_distance
			--print("telepoter distance closet "..teleporter_distance_closest)
			self.teleporter_guide_of_closest = i
			self:SetInRange(true)
			--print("tele guide info ".. self.teleporter_guide_of_closest[t])
		elseif self.teleporter_distance_closest >= max_teleport_distance then
			self.teleporter_guide_of_closest = 0
		end
		if self:GetInRange() && self.teleporter_distance_closest >= max_teleport_distance then
			self:SetInRange(false)
			self.sound_has_played =  false
		end
	end
	if self:GetInRange() && not self.sound_has_played then
		self:EmitSound(sound_in_range)
		self.sound_has_played = true
	end
end

if CLIENT then
	function ENT:GetScreenText()
		local ship = self:GetShipInfo().entity
		
		if self:GetInRange() then
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

--stuff from component
function ENT:Draw()
	local is_controlling = LocalPlayer().proxyctrls_ent == self

	self:DrawModel()
		cam.Start3D2D(self:LocalToWorld(self.ComponentScreenOffset),self:LocalToWorldAngles(self.ComponentScreenRotation), .25 )
			self:drawScreenTele()
		cam.End3D2D()

end

hook.Add("HUDPaint","Genji's Teleporter",function()
	local control_ent = LocalPlayer().proxyctrls_ent

	if IsValid(control_ent) and control_ent.drawScreenToHud and isfunction(control_ent.drawScreenTele) then

		local matrix = Matrix()
		matrix:Translate(Vector(ScrW()-control_ent.ComponentScreenWidth,ScrH()-control_ent.ComponentScreenHeight,0))
		--matrix:Scale(Vector(2,2,2))
		cam.PushModelMatrix(matrix)
		control_ent:drawScreenTele()
		cam.PopModelMatrix()
		--end
	end
end)

function ENT:drawScreenTele()
	local color = Color(0,0,0)
	local width = self.ComponentScreenWidth
	local height = self.ComponentScreenHeight

	surface.SetDrawColor(color)
	surface.DrawRect( 0, 0, width, height)

	surface.SetDrawColor(Color(0,0,0))
	
	local function startStencil()
		render.SetStencilEnable(true)
		render.ClearStencil()
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	end

	if self.ComponentHideName then
		startStencil()
		surface.DrawRect( 3, 3, width-6, height-6)
	else
		surface.DrawRect( 3, 3, width-6, 35)
		draw.SimpleText(self:GetComponentName(),"micro_big",width/2,20,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		startStencil()
		surface.DrawRect( 3, 41, width-6, height-44)
	end

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

	--self:drawInfo()

	render.SetStencilEnable(false)
end
