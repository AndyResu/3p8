--[[
	

	TODO: "&& inventory not full"
			secrete YEET sound

	FILE THEME SONG: 
]]

AddCSLuaFile()

SWEP.PrintName = "Inventory"
SWEP.Author = "Sky"
SWEP.Purpose = "Carry everything"
SWEP.Instructions = "Primary Fire is to Collect.\nSecondary Fire is to Open Inventory"
SWEP.Category = "3P8"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Weight = 2 --the hand, it is not heavy weapons man

SWEP.Slot = 2 --is 3 for 3p8
SWEP.SlotPos = 1

SWEP.Primary.ClipSize		= 999
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "slam"
SWEP.Primary.Delay			= 0.25
SWEP.Primary.Recoil			= 0
SWEP.Primary.TakeAmmo		= 1
SWEP.Primary.Spread			= 0.01

SWEP.Secondary.ClipSize	    = 999
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "slam"
SWEP.Secondary.Delay		= 1
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.TakeAmmo		= 1
SWEP.Secondary.Spread		= 0.01

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/c_arms_animations.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["potato"] = { type = "Model", model = "models/props_phx/misc/potato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 3.635, -0.519), angle = Angle(0, 0, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["potato"] = { type = "Model", model = "models/props_phx/misc/potato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.599, 3.599, -0.5), angle = Angle(0, 0, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} }
}

local sound_add = Sound("ambient/levels/canals/windchime2.wav")
local sound_buy = Sound("ambient/levels/citadel/weapon_disintegrate2.wav")

local eat_range = 70

function SWEP:PrimaryAttack()
	--grab items
	local ply = self:GetOwner()
	local shootpos = ply:GetShootPos()
	local endshootpos = shootpos + ply:GetAimVector() * eat_range
	local tmin = Vector(1,1,1)*-10
	local tmax = Vector(1,1,1)*10
	local tr = util.TraceHull( {
		start = shootpos,
		endpos = endshootpos,
		filter = ply,
		mins = tmin,
		maxs = tmax,
		mask = MASK_SHOT_HULL
	} )
	if not IsValid(tr.Entity) then
		tr = util.TraceLine({
			start = shootpos,
			endpos = endshootpos,
			filter = ply,
			mask = MASK_SHOT_HULL
		})
	end
	local ent = tr.Entity
	self.itemID = -2
	self.itIsOnList = false
	if IsValid(ent) then
		self.itIsOnList = self:IsOnList(ent:GetClass())
		print("ent: "..ent:GetClass())
		self.itemID = self:GetItemIDFromEntName(ent:GetClass())
		print(self.itemID)
	end
	if IsValid(ent) && self.itemID > 0 --[[&& inventory not full]] then

		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		ply:SetAnimation(PLAYER_ATTACK1)
		
		if SERVER then
			--need to check if the item has ent.health
			if --[[IsValid(ent.health) && ]]ent.health > 0 then
				if ent.health > 100 && string.find(ent:GetClass(), "tp8_tree") then
					-- give wood instead
					print("is wood")
					self.itemID = self:GetItemIDFromEntName("micro_item_salainen_puulle")
				end
				--add to inventory
				ent.health = ent.health - 100
				ent:OnTakeDamage(DamageInfo(100))
			end
			self:SetNWInt("inv"..self.itemID, self:GetNWInt("inv"..self.itemID)+1)
			print("HP is: ".. ent.health)
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		end
		ply:EmitSound("npc/headcrab_fast/headbite.wav")
	elseif IsValid(ent) && SERVER && ent.health != 0 then
		--might be a rock
		if string.find(ent:GetClass(), "3p8_rock") then
			--add to inventory
			ent.health = ent.health - 100
			ent:OnTakeDamage(DamageInfo(100))
			self.itemID = self:GetItemIDFromEntName("3p8_rock_s")
			self:SetNWInt("inv"..self.itemID, self:GetNWInt("inv"..self.itemID)+1)
			print("HP is: ".. ent.health)
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		end
	elseif !IsValid(ent) then
		--self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		--ply:SetAnimation(PLAYER_ATTACK1)
		--ply:EmitSound("npc/fast_zombie/claw_miss1.wav")
	end
	--delay
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local random = math.random(0,1000)
	if (random >= 1000) then
		--TODO: Yeet sound goes here
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	else
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	--self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	timer.Simple( 0.5, function() self.Weapon:SendWeaponAnim(ACT_VM_IDLE) end )
end

function SWEP:SecondaryAttack()
	--open inventory
	if SERVER then
		self:GetOwner():SendLua("INVENTORY(Entity("..self:EntIndex().."))")
	end
end

function SWEP:AddCash(amount)
	self.cash = self.cash+amount
	self:EmitSound(sound_add)
	return true
end

function SWEP:GetItemSpawn()
	return self:GetPos() + self:GetForward()*64 + Vector(0,0,64)
end

function SWEP:CheckBlocked()
	local r = 9
	local tr = util.TraceHull{start=self:GetItemSpawn(),endpos=self:GetItemSpawn(),mins=Vector(-1,-1,-1)*r, maxs=Vector(1,1,1)*r, filter=self}
	return tr.Hit
end

if CLIENT then
	function SWEP:GetScreenText()
		return "Ready",Color(0,255,0)
	end
end

function SWEP:drawInfo()
	local cash = self.cash

	draw.SimpleText("$"..cash,"micro_big",88,80,Color(255,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	local text,text_color = self:GetScreenText()
	draw.SimpleText(text,"micro_big",88,130,text_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

-- This is bad.
concommand.Add("tp8_spawn",function(ply,_,args)
	local shop_ent = Entity(tonumber(args[1]) or 0)

	local n = tonumber(args[2])
	if !ply:Alive() or !isnumber(n) or Entity(THREEPATE_ENT_ID).ItemList[n]==nil or !IsValid(shop_ent) then return end
	if shop_ent:GetPos():Distance(ply:GetPos())>200 then return end
	if isstring(Entity(THREEPATE_ENT_ID).ItemList[n].ent) then
		if shop_ent:CheckBlocked() then return end
	end
	-- point of no return
	local stocky = shop_ent:GetNWInt("inv"..n, -999)
	if stocky <= 0 then return end
	--shop_ent.inventory[n] = shop_ent.inventory[n] - 1
	shop_ent:SetNWInt("inv"..n, stocky-1)

	shop_ent:EmitSound(sound_buy)

	if isstring(Entity(THREEPATE_ENT_ID).ItemList[n].ent) then
		local ent = ents.Create(Entity(THREEPATE_ENT_ID).ItemList[n].ent)
		if !IsValid(ent) then error("FAILED to make bought entity!") end
		--ent:SetModel("models/Items/item_item_crate.mdl")
		ent:SetPos(shop_ent:GetItemSpawn())
		ent:Spawn()
		print("testecal")
	end
end)

function INVENTORY(ent)
	--have deposit button?
	local blocked

	local panel = vgui.Create("DFrame")
	panel:SetDraggable(false)
	panel:SetSizable(false)
	panel:SetTitle("Inventory")
	panel:SetSize(640,480)
	panel:Center()
	panel:MakePopup()

	panel.Think = function(self)
		if !LocalPlayer():Alive() then
			self:Close()
		else
			blocked = ent:CheckBlocked()
		end
	end
	
	panel.PaintOver = function(self)
		local color = team.GetColor(LocalPlayer():Team())

		surface.SetDrawColor(Color( 0, 0, 0))
		surface.DrawRect(285, 30, 330, 40)

		surface.SetDrawColor(color)
		surface.DrawOutlinedRect(285, 30, 330, 40)

		draw.SimpleText("$"..ent.cash,"micro_big",605,50,Color(255,255,0),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		
		local text,text_color = ent:GetScreenText()
		draw.SimpleText(text,"micro_big",380,50,text_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	local scroll = panel:Add("DScrollPanel")
	scroll:Dock(FILL)
	scroll:DockMargin(0,50,0,0)

	local notThere = 0
	for i in pairs(ent.inventory) do
		local stocke = ent:GetNWInt("inv"..i, -404)
		if (stocke>0) then
			local y_base = (i-notThere-1)*90

			local panel = scroll:Add("DPanel")
			panel:SetPos(0, y_base)
			panel:SetSize(610,80)

			local title = panel:Add("DLabel")
			title:SetPos(100,0)
			title:SetFont("DermaLarge")
			title:SetText(Entity(THREEPATE_ENT_ID).ItemList[i].name)
			title:SetDark(true) 
			title:SizeToContents()

			local stock = panel:Add("DLabel")
			--stock:SetFont("DermaLarge")
			stock:SetText("Stock: "..stocke.." ")
			stock:SetDark(true)
			stock:SizeToContents()
			stock:SetPos(530-stock:GetWide(),60)

			local icon = panel:Add("DModelPanel")
			icon:SetSize(70, 70)
			icon:SetPos(0,0)
			icon:SetModel(Entity(THREEPATE_ENT_ID).ItemList[i].pv)
			icon:SetLookAt( Vector(0,0,0) )
			icon:SetFOV(1.5*icon:GetEntity():GetModelRadius())

			local desc = panel:Add("DLabel")
			desc:SetPos(100,40)
			desc:SetText(Entity(THREEPATE_ENT_ID).ItemList[i].desc)
			desc:SetDark(true) 
			desc:SizeToContents()

			local button = panel:Add("DButton")
			button:SetText("Drop")
			button:SetPos(540,50)

			function button:DoClick()
				print("ent:EntIndex(): "..ent:EntIndex()..", i: "..i)
				--print("ent:GetOwner(): "..ent:GetOwner()..", i: "..i)
				RunConsoleCommand("tp8_spawn",ent:EntIndex(),i)
			end

			function button:Think()
				local cash = ent.cash
				stocke = ent:GetNWInt("inv"..i, -999)

				-- WARNING! SLOW! DOES A TRACE FOR EVERY BUTTON!
				if (Entity(THREEPATE_ENT_ID).ItemList[i].ent and blocked) or (stocke <= 0) then
					self:SetDisabled(true)
				else
					self:SetDisabled(false)
				end
			end
		else
			notThere = notThere + 1
		end
	end
end

function SWEP:Reload()
	
end

function SWEP:GetItemIDFromEntName(entName)
	local itemID = -1
	for i = 1, #Entity(THREEPATE_ENT_ID).ItemList do
		if entName == Entity(THREEPATE_ENT_ID).ItemList[i].ent then
			itemID = i
		end
	end
	return itemID
end

function SWEP:IsOnList(entName)
	local isTrue = false
	for i = 1, #Entity(THREEPATE_ENT_ID).ItemList do
		if entName == Entity(THREEPATE_ENT_ID).ItemList[i].ent then
			isTrue = true
		end
	end
	return isTrue
end















--saved as potato in SCK
--[[/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/--]]

function SWEP:Initialize()

	--sky added
	self.HeadMaterial = ""

	-- other initialize code goes here
	self:SetWeaponHoldType(self.HoldType)

	self.inventory = {}
	for i = 1, #Entity(THREEPATE_ENT_ID).ItemList do -- THREEPATE_ENT_ID Entity(13)
		self.inventory[i] = 0
	end
	self.cash = 0

	if true then
		for i = 1, #Entity(THREEPATE_ENT_ID).ItemList do -- THREEPATE_ENT_ID Entity(13)
			self:SetNWInt("inv"..i, 0)
		end
	end

	if CLIENT then
		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		-- init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				-- Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end


		--loop through the possible network entity names and reconnstruct the array clientside
		for i = 1, #Entity(THREEPATE_ENT_ID).ItemList do -- THREEPATE_ENT_ID Entity(13)
			local stock = self:GetNWInt("inv"..i, -900)
			print("stock is: ".. stock)
			if(stock >= 0) then
				--the value exists, and the stock should be set 
				self.inventory[i] = stock
			elseif(stock < 0) then
				self.inventory[i] = -1
			end
		end

		for k,v in ipairs(self.inventory) do
			print(k,v)
		end
		print("Setup the network variables!")
	end
end

function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		if (!self.VElements) then return end
		self:UpdateBonePositions(vm)
		if (!self.vRenderOrder) then
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}
			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
		end
		for k, name in ipairs( self.vRenderOrder ) do
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if (!v.bone) then continue end
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			if (!pos) then continue end
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == "Sprite" and sprite) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif (v.type == "Quad" and v.draw_func) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
		end
	end
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		if (!self.WElements) then return end
		if (!self.wRenderOrder) then
			self.wRenderOrder = {}
			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end
		for k, name in pairs( self.wRenderOrder ) do
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			local pos, ang
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end
			if (!pos) then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r -- Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				-- make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			-- !! WORKAROUND !! --
			-- We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			-- !! ----------- !! --
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				-- !! WORKAROUND !! --
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				-- !! ----------- !! --
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	--[[**************************
		Global utility code
	**************************--]]

	-- Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	-- Does not copy entities of course, only copies their reference.
	-- WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) -- recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end
