
--[[
FILE THEME SONG: https://www.youtube.com/watch?v=hF9Gr5waAJg
--death squad's off to disney land

Say your prayers little one
Don't forget my son
To include everyone

I set you up, weak teams
Keep you free from memes
'Til the Death Squad comes

With your third eye open
Blame SkyLight

Exit light
Enter fight
Take my gun
Death Squad's off to Disney Land

Something's wrong, shut the light
War thoughts tonight
Know your tank is fight

Dreams of war, dreams of liars
Dreams of purifying fire
And of things that will bite, yeah

With your third eye open
Blame SkyLight

Exit light
Enter fight
Take my gun
Death Squad's off to Disney Land

Now I lay me down to sleep
Now I lay me down to sleep
Pray Parakeet my soul to keep
Pray Parakeet my soul to keep

If I bleed before I wake
If I bleed before I wake
Pray Teemo my soul to take --blood god?
Pray Teemo my soul to take

Hush my friend don't say a word
And never mind those shots you heard
It's just the wewlad under your bed
In your closet in your head

Exit light
Enter fight
Bit of Sun

Exit light
Enter fight
Take my gun
Death Squad's off to Disney Land

Boom
! Yeah yeah!

Death Squad's off to Disney Land
Take my gun
Death Squad's off to Disney Land
Take my gun

Death Squad's off to Disney Land
Death Squad's off to Disney Land
They're off to never-never land
--]]

--This weapon is so strong it has two themes:
--https://www.youtube.com/watch?v=MISEMo8xxII

--the ultimate, ancient, sumerian man who became a god, Ihuicatl Tonauac's master-form jihadblade of suprememe (!) power #RARE
--maximum blood genij approved

--requires the 5 pieces of Ihuicatl Tonauac --worldmodel
--Severed Head of Ihuicatl Tonauac		--models/props/cs_office/snowman_head.mdl
--Energy Shield of Ihuicatl Tonauac		--models/slyfo/pallet_battery.mdl
--Genome of Ihuicatl Tonauac			--models/props/de_tides/vending_tshirt.mdl
--Dual Blasters of Ihuicatl Tonauac		--models/slyfo_2/rocketpod_turbo_full.mdl
--Light Sneakers of Ihuicatl Tonauac	--models/props_c17/SuitCase001a.mdl
--combinator							--models/props_lab/servers.mdl					--probably is own entity, like shop. call comb lol

--Robot Claw?
--carte blanche? give money https://www.youtube.com/watch?v=NSoumHfgIqc --lodsa mone?
--golden gun? made from new roleplayer prop crate?
--drop money from shop for robbing ships
--sword of some sort, maybe with shield

--[[
function ENT:PhysicsCollide(data, phys)
	--if self:IsBroken() then return end
	local class = data.HitEntity:GetClass()

	if class:sub(1,17)=="micro_item_shell_" then
		local type = tonumber(class:sub(18))

		local ammo_needed = self["Ammo"..type.."Max"] - self["GetAmmo"..type](self)
		local ammo_taken = data.HitEntity:TryTake(ammo_needed)

		if ammo_taken>0 then
			self:EmitSound(sound_reload)
			self["SetAmmo"..type](self,self["GetAmmo"..type](self)+ammo_taken)
		end
	end
end
--]]

--todo:
--spawned in initialization of the swep. 
	--also slow player down by like, 1/3rd when in use!
--make tracers work ffs
--make it so bullets fired by this gun do not collide with this gun. 
--1. fix the SetParent?
--2. ask parakeet about how to fix the serverside/clientside spamming glitch
--3. consider using http://wiki.garrysmod.com/page/Entity/PhysicsInitSphere & http://wiki.garrysmod.com/page/Entity/PassesDamageFilter maybe use traces instead of bullets
-- if you switch off the weapon, it will still have the shield there in the air...
--SWEP:Holster( Entity weapon ) 

AddCSLuaFile()

SWEP.PrintName = "I.T."
SWEP.Author = "Ihuicatl Tonauac" --Sky of the Light in Nahuatl
SWEP.Purpose = "The Infinite Terror of Ihuicatl Tonauac"
SWEP.Instructions = "Primary Fire to Destroy. Secondary Fire to Protect."
SWEP.Category = "Microcosm"
SWEP.Weight = 50000 --it is beyond powerful!

--destroy
SWEP.Primary.Sound			= "weapons/tmp/tmp-1.wav"
SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "Battery"
SWEP.Primary.Delay			= 0.15
SWEP.Primary.Recoil			= 0.25
SWEP.Primary.TakeAmmo		= 0

SWEP.Primary.Damage			= 75
SWEP.Primary.Spread 		= 0.2
SWEP.Primary.NumberofShots 	= 2
SWEP.Primary.Force			= 10

--protect
SWEP.Secondary.ClipSize		= 20
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.TakeAmmo		= 0

SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/barney_animations.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["gun_right"] = { type = "Model", model = "models/slyfo_2/weap_prover_industrialspiker.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.5, 1.5, -2.5), angle = Angle(0, 0, 135), size = Vector(0.55, 0.55, 0.55), color = Color(147, 110, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun_right+"] = { type = "Model", model = "models/slyfo_2/weap_prover_industrialspiker.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(11.5, 1.5, 2.9), angle = Angle(0, 0, 45), size = Vector(0.55, 0.55, 0.55), color = Color(147, 110, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield"] = { type = "Model", model = "models/hunter/misc/shell2x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 0, 0), size = Vector(1, 1, 1), color = Color(160, 215, 255, 0), surpresslightning = false, material = "models/spawn_effect2", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["gun_right+"] = { type = "Model", model = "models/slyfo_2/weap_prover_industrialspiker.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(12, 1, 0), angle = Angle(0, 0, 45), size = Vector(0.55, 0.55, 0.55), color = Color(147, 110, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shoe_right+"] = { type = "Model", model = "models/props_junk/Shoe001a.mdl", bone = "ValveBiped.Bip01_R_Foot", rel = "", pos = Vector(3.635, -0.519, -1.558), angle = Angle(0, -35, 90), size = Vector(1.25, 1.25, 0.497), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["hat"] = { type = "Model", model = "models/slyfo_2/p_acsry_shelmet2.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.25, 0, 0), angle = Angle(0, -90, -90), size = Vector(1.25, 1.25, 1.25), color = Color(75, 75, 75, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shoe_upper_right+"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_L_Foot", rel = "", pos = Vector(3.635, 0.518, -0.519), angle = Angle(0, -35, 0), size = Vector(0.15, 0.15, 0.15), color = Color(75, 75, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shoe_upper_right"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Foot", rel = "", pos = Vector(3.635, 0.518, 0.518), angle = Angle(0, -35, 0), size = Vector(0.15, 0.15, 0.15), color = Color(75, 75, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield_gen"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.558, 3, 0), angle = Angle(180, 100, 90), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun_right"] = { type = "Model", model = "models/slyfo_2/weap_prover_industrialspiker.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12, 1, 0), angle = Angle(0, 0, 135), size = Vector(0.55, 0.55, 0.55), color = Color(147, 110, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shoe_right++"] = { type = "Model", model = "models/props_junk/Shoe001a.mdl", bone = "ValveBiped.Bip01_L_Foot", rel = "", pos = Vector(3.635, -0.519, -1.558), angle = Angle(0, -35, 90), size = Vector(1.25, 1.25, 0.497), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }--[[,
	["shield"] = { type = "Model", model = "models/hunter/misc/sphere2x2.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(0, -10, 0), angle = Angle(90, 0, 0), size = Vector(1, 1, 1), color = Color(160, 215, 255, 0), surpresslightning = false, material = "models/spawn_effect2", skin = 0, bodygroup = {} }]]
}

local shield_on = false
local gun_flip = false

--secrete code to prevent people from get in other gamemode! KEEP IT AN EASTER EGG!!!
SWEP.Spawnable = false --how get???!!
SWEP.AdminSpawnable = false --not even andman can get it in sandbox!!

function SWEP:PrimaryAttack()

	--if ( !self:CanPrimaryAttack() ) then return end

	local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 76) --(self.Owner:GetAimVector() + Vector(0,20,-22))
		--IMPORTANT: this spawns bullets ahead of the player... you can actually shoot through thin walls at close range. 
		--Fix for this would be a bullet filter for bullets that are made by the user. 
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 0
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo
 
	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)

	self:ShootEffects()

	self.Owner:FireBullets( bullet )
	self:EmitSound(Sound(self.Primary.Sound))
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:Think()
	if shield_on && self:Clip1() < 1 then --for when the shield runs out of power by decay
		print("timer powered off")
		self:EmitSound(Sound("items/nvg_off.wav"))
		self.VElements["shield"].color.a = 0
		if SERVER && shield_ent:IsValid() then
			shield_ent:Remove()
		end
		shield_on = false
	end
	--helps deal with server/client disconnect?
	if shield_on && self.VElements["shield"].color.a == 0 then
		self.VElements["shield"].color.a = 42
		self:EmitSound(Sound("items/nvg_on.wav"))
	elseif !shield_on && self.VElements["shield"].color.a == 42 then
		self.VElements["shield"].color.a = 0
		self:EmitSound(Sound("items/nvg_off.wav"))
	end
	--updates the shields position so I don't have to use parenting which is affected by angles. this is not affected by angles.
	if SERVER && shield_on && shield_ent:IsValid() then
		shield_ent:SetPos(self.Owner:GetPos() + (self.Owner:GetAimVector() * 1) + Vector(0,0,40))
	end
end



function SWEP:SecondaryAttack() --protect
	--toggle shiled
	--if (!self:CanSecondaryAttack()) then return end

		if shield_on then
			self:EmitSound(Sound("items/nvg_off.wav"))
			--turn shield off
			print("turnt off")
			self.VElements["shield"].color.a = 0
			if SERVER && shield_ent:IsValid() then
				shield_ent:Remove()
			end
			--turn off invincibility
			shield_on = false
		elseif !shield_on && self:Clip1() >= 5 then
			self:EmitSound(Sound("items/nvg_on.wav"))
			--turn shield on
			print("turnt on")
			self.VElements["shield"].color.a = 42
			if SERVER then
				--local vector_rotate = Vector(0,0,32)
				--vector_rotate:Rotate(self.Owner:GetAngles())


				--The following commands are in alphabetical order.

				
				shield_ent = ents.Create("micro_secrete_shield")
				--shield_ent:SetParent(self.Owner, -1) --try using ENT:Think() to continously update pos?
				shield_ent:SetPos(self.Owner:GetPos()) -- + vector_rotate
				shield_ent:SetPower(self:Clip1()*4)
				shield_ent:Spawn()
			end
			--turn on invincibility
			shield_on = true
		end
	
end

function SWEP:ShootEffects()
	if gun_flip then
		--self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) -- View model animation
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		gun_flip = false
	else
		--self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) -- View model animation
		self.Owner:SetAnimation( PLAYER_ATTACK1 ) --there isn't 2 animation lol
		gun_flip = true
	end
	--self.Owner:MuzzleFlash()
	
end

--saved as it in SCK
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
	self.Weapon:EmitSound("buttons/weapon_confirm.wav")
	--be sure to turn shield off here

	if SERVER then
		local timer_name = "shield_regen_"..self:EntIndex()
		timer.Create(timer_name,1,0, function()
			if IsValid(self) then
				if self:Clip1()<self.Primary.ClipSize then
					self:SetClip1(self:Clip1()+1)
				end
			else
				timer.Destroy(timer_name)
			end
		end)

		local timer_name = "shield_deplete_"..self:EntIndex()
		timer.Create(timer_name,1,0, function()
			if IsValid(self) then
				--print(self:Clip1() .." clip1")
				if shield_on && self:Clip1() >= 1 then --for causing the shield decay
					print("timer decay")
					self:SetClip1(self:Clip1()-2)
					if SERVER && shield_ent:IsValid() then
						shield_ent:SetPower(shield_ent:GetPower()-1)
						self:SetClip1(shield_ent:GetPower())
						--prevents ammo from going negative when the shield is shot at low power.
						if self:Clip1() < 0 then
							self:SetClip1(0)
						end
					end
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