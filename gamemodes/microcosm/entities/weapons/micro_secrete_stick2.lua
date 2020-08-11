--[[
	FILE THEME SONG:
	https://www.youtube.com/watch?v=jNtwb4sP0IA
	STICK STICK STICK STICK

	--I was thinking maybe use driftwood for the stick, OR a pallet gib :^)
	or models/props_canal/mattpipe.mdl

	Todo:
	stick1 becomes stick2...
	add view/world model for magic item.

	money wizard, height wizard, banana wizard, color wizard?, trash wizard, plant wizard (DEATH WEED?), cleric/necro? biomage?, fire (rage) mage
]]

AddCSLuaFile()

SWEP.PrintName = "S.T.I.C.K."
SWEP.Author = "Sky"
SWEP.Purpose = "Spells of Thaumaturgy, Illusion, Conjuration, and Killing" --something tacticool in cilla kombat, small tree...
SWEP.Instructions = "Turns out this is a magical stick..."
SWEP.Category = "Microcosm"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Weight = 3 --it's a stick, what do you expect?

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		    = "GaussEnergy"
SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 0
SWEP.Primary.TakeAmmo		= 0

SWEP.Secondary.ClipSize	    = -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.HoldType = "knife"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/barney_animations.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.11, -34.445, 16.666) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12.223, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -18.889, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 30) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.888, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0.185, -0.186, 0), angle = Angle(-21.112, -36.667, 0) },
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.445, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0.555, -6.112, -2.408), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.778, -38.889, 0) },
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -5.557, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0, 0), angle = Angle(25.555, 10, 5.556) }
}

SWEP.VElements = {
	["None"] = { type = "Model", model = "models/props/cs_office/trash_can_p5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2, -23), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Trash"] = { type = "Model", model = "models/props/cs_office/trash_can_p5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2, -23), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Meme"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2, -23), angle = Angle(0, 0, 0), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["stick"] = { type = "Model", model = "models/props_foliage/driftwood_02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -5.715), angle = Angle(104.026, -19.871, 36.234), size = Vector(0.035, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["None"] = { type = "Model", model = "models/props/cs_office/trash_can_p5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12, 2, -23), angle = Angle(110, -10, -17), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Trash"] = { type = "Model", model = "models/props/cs_office/trash_can_p5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12, 2, -23), angle = Angle(110, -10, -17), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Meme"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12, 2, -23), angle = Angle(180, -10, -17), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["stick"] = { type = "Model", model = "models/props_foliage/driftwood_02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 1.5, -7), angle = Angle(110, -10, -17), size = Vector(0.035, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

local eat_range = 70

function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
	local trash_primary_cost = 5

	if self.current_spells == "Trash" then
		--eat prop_physics items
		--do a trace
		--if prop_physics then eat it and self:SetClip1(self:Clip1()+2)
		--if player or NPC then do a little damage and take ammo.  Maybe shoot trash for 5?
		if CLIENT then return end
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
		if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC()) && self:Clip1() >= trash_primary_cost then
			ply:EmitSound("npc/headcrab_fast/headbite.wav")
			self:SetClip1(self:Clip1()-trash_primary_cost)
			--THANKS (again) AWKEWAINZE
			local d = DamageInfo()
        	d:SetDamage( 25 )
        	d:SetAttacker( ply )
        	ent:TakeDamageInfo( d )
		elseif IsValid(ent) && ent:GetClass() == "prop_physics" then
			ent:Remove()
			self:SetClip1(self:Clip1()+2)
			ply:EmitSound("npc/headcrab_fast/headbite.wav")
		elseif !IsValid(ent) then
			ply:EmitSound("npc/fast_zombie/claw_miss1.wav")
		end
		--self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	elseif self.current_spells == "Meme" then --meme magic
		--spigot toolbar wizard 1 protection from memes 2 roll knowledge nature
		if !meme_protection && CLIENT then 
			self.Owner:ChatPrint("You are now protected from memes.") --maybe put player name?
			meme_protection = true
		elseif meme_protection && CLIENT then
			self.Owner:ChatPrint("You are now unprotected from memes. Please reinstall spigot toolbar to get your system scanned for memes!")
			meme_protection = false
		end
		self.Owner:EmitSound("ambient/machines/train_pass_far.wav")
	else --no magic
		--self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.Weapon:EmitSound("npc/fast_zombie/claw_miss1.wav")
	end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	timer.Simple( 0.5, function() self.Weapon:SendWeaponAnim(ACT_VM_IDLE) end )
end

function SWEP:SecondaryAttack()
	--used for creating a secondary spell
	local trash_secondary_cost = 10
	if self.current_spells == "Trash" && self:Clip1() >= trash_secondary_cost then
		--produce armor item
		if CLIENT then return end
		local ent = ents.Create("micro_item_armorkit")
		local vector_rotated = Vector(0,0,40)
		vector_rotated:Rotate(self.Owner:GetAngles())
		ent:SetPos(self.Owner:GetPos() + vector_rotated)
		ent:SetAngles(self.Owner:EyeAngles())
		ent:SetModel("models/items/battery.mdl")
		ent:Spawn()
		self:SetClip1(self:Clip1()-trash_secondary_cost)
	elseif self.current_spells == "Meme" && SERVER then --meme magic
		self.Owner:ChatPrint("Rolling a D20: ".. math.random(1,20))
		self.Onwer:EmitSount("ambient/animal/rodent_scratch_short_2.wav")
	else

	end
	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	timer.Simple( 0.5, function() self.Weapon:SendWeaponAnim(ACT_VM_IDLE) end )
end

function SWEP:Think()
	--spins the current spell item like a globe!
	if self.current_spells == "Trash" then
		self.VElements["Trash"].angle.y = self.VElements["Trash"].angle.y + 0.5
		self.WElements["Trash"].angle.y = self.WElements["Trash"].angle.y + 0.5
	elseif self.current_spells == "Meme" then
		self.VElements["Meme"].angle.y = self.VElements["Meme"].angle.y + 0.5
		self.WElements["Meme"].angle.y = self.WElements["Meme"].angle.y + 0.5
	end
end

function SWEP:Reload()
	--used to change what spell the player is on (current_spells) by using a trace to find what prop_physics the player is aiming at and eating it >:)
	--print("Current Spells "..current_spells)
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
	if IsValid(ent) && ent:GetClass() == "prop_physics" then
		self.VElements[self.current_spells].color.a = 0
		self.WElements[self.current_spells].color.a = 0
		--the client is not allowed access to this command...
		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		ply:SetAnimation(PLAYER_ATTACK1)
		model_eaten = ent:GetModel()
		if string.match(model_eaten, "trash") || string.match(model_eaten, "dumpster") || string.match(model_eaten, "ruin") || string.match(model_eaten, "debris") then
			--trash wizard
			self.current_spells = "Trash"
			self.VElements["Trash"].color.a = 255
			self.WElements["Trash"].color.a = 255
			if CLIENT then self.Owner:ChatPrint("You are now a Trash Wizard!") end
		elseif string.match(model_eaten, "blastdoor" || model_eaten == "models/props_junk/ravenholmsign.mdl") then
			self.current_spells = "Meme"
			self.VElements["Meme"].color.a = 255
			self.WElements["Meme"].color.a = 255
			if CLIENT then self.Owner:ChatPrint("You are now a Spigot Toolbar Wizard!") end
		elseif string.match(model_eaten, "explosive") || string.match(model_eaten, "gas") || string.match(model_eaten, "ropane") || string.match(model_eaten, "fire") then
		--rage mage aka pyro aka fire mage
			--shoot fireball (flaming explosive barrel?)
			--set on fire for 10 seconds?

		--balloon wizard?
			--1 spawn balloon animal
			--2 launch balloon animal towards location


		--magic tree in detail
		--Wizard 1 produce light 2 spend mana to add max mana 
			--maybe try using a fancy color/material?
			--item for make wizard
				--models/props_phx/misc/egg.mdl
				--models/props/cs_italy/orange.mdl
				--models/props/cs_italy/bananna.mdl
				--models/props/de_inferno/crate_fruit_break_gib2.mdl
				--gnome? pumpkin?
				
			--flower models to be placed underground as static props?
				--models/props/de_inferno/potted_plant1_p1.mdl
				--models/props/de_inferno/potted_plant2_p1.mdl
				--models/props/de_inferno/potted_plant3_p1.mdl

			--cool stuff for map
				--models/props/de_inferno/laundrylineacross.mdl
				--models/props/de_inferno/laundrylineflat.mdl
			--Life Wizard (cleric) 1 heal 2 armor?... ideally resurrect. maybe add max hp?
				--plant wizard 1 make plant 2 make fancy plant. maybe death weed 3 maybe shoot stick. stick win everytime
					--death weedzard
					--ant/bug wizard 1 shoot spit 2 drop edible grub or spawn antlion grub
						--height wizard 1 make smaller 2 make bigger
						--Culture/Color wizard 1 change color 2 change material
							--money wizard 1 turn to gold? 2 make monies & dance
							--balloon wizard 1 spawn balloon animal 2 launch baloon animal towards location
							--noise/music wizard 1 play random sound 2 play random music/ambience
							--install wizard
								--1 dialup sounds? 2 shoot computer?
								--spigot toolbar wizard 1 2 done
								--parakeet "JavaScript" wizard
								--SkyLight "Taivas" wizard 1 make random required prop 2 make immortal?
							--OSHA/Safety Wizard
								--1 spawn construction barricade/cone maybe make a ladder?
									--models/props_junk/TrafficCone001a.mdl
									--models/props_wasteland/barricade001a.mdl
									--models/props_wasteland/barricade002a.mdl
								--2 shoot not-safe objects like sawblades and hooks and harpoons
				--blood wizard 1 life steal 2 SLAY?
					--blood powered weapons
				--lust wizard 1 shoot paintcan fast 2 change playermodel, either self or enemy AKA booty wizard
			--Element Wizard 1 magic missle? 2 force push?
				--fire wizard 1 ignite 2 firebarrel
					--electricity wizard 1 shoot electricity 2 produce light???
				--"air jordan" on the wizards 1 run speed 2 high jump
					--maybe flying "sky" wizard... or maybe for balloon?
				--dirt wizard 1 shoot rock bullet 2 drop rock from sky?
					--stone wizard 1 make wall 2 ???
				--water wizard 1 fish swarm (shotgun) 2 shield?
					--SNOW WIZARD 1 shoots snowball 2 turns into snowman for 10 seconds
				--trash wizard 1 2 done

		--gun wizard not sure I should have one because guns are not magic
		--sleep, detect players, give more maxhp, damp lazer, aggressive ray, illusion, teleport, become water, polymoprh
		--door wizard
		--suomi wizard?
		--Hyphy [BASED] wizard...
		--space wizard?
		--EXODUS WIZARD
		--interdimensional psychic vampire
			--telports between ship
		--immortality wizard?



		--confusion wizard 1 spin target 2 move target in random directions
		--probably should restructure the tree so crappy stuff comes first...
		--maybe instead of a tree, just have the steam ID pick one, or one of the starter classes. 
			--split between helpful and harmful?
		--wizard wizard -BAirborne, spawns mimics 
		--rpg wizard? level up, ding, useless crap?
			--really uses an RPG
		--maybe have the tree advancement be based on props being spawned by certain wizards... like wizard 1 spawns this object, makes you into wizard 2... to 4 then you become
			--super wizard...


		elseif string.match(model_eaten, "banana") || string.match(model_eaten, "doll") || string.match(model_eaten, "orange") || string.match(model_eaten, "hotdog") then
			--lust wizard
			--shoot paintcan fast
			--change playermodel --changeling or maybe change other people

		elseif string.match(model_eaten, "paint") then
			--color wizard
			--change color
			--change material?
		else
			self.current_spells = "None"
			if CLIENT then self.Owner:ChatPrint("This lacks magic...") end
		end
		if SERVER then --maybe disable and leave for the trash wizard to clean up.
			ent:Remove()
		end
		ply:EmitSound("npc/headcrab_fast/headbite.wav") --magical sound garrysmod/save_load1.wav 1-4 are all magical!!!
	elseif !IsValid(ent) then
		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:EmitSound("npc/fast_zombie/claw_miss1.wav")
	end
	timer.Simple( 0.5, function() self.Weapon:SendWeaponAnim(ACT_VM_IDLE) end )
end

--saved as stick in SCK
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
	-- other initialize code goes here
	self:SetWeaponHoldType(self.HoldType)
	self.current_spells = "None"
	self.model_eaten = ""
	self.meme_protection = false

	if SERVER then
		local timer_name = "magic_regen_"..self:EntIndex()
		timer.Create(timer_name,10,0, function()
			if IsValid(self) then
				if self:Clip1()<self.Primary.ClipSize then
					self:SetClip1(self:Clip1()+1)
				end
			else
				timer.Destroy(timer_name)
			end
		end)
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