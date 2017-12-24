AddCSLuaFile()

SWEP.PrintName 		= "Nail ?Gun?"
SWEP.UseHands		= true

SWEP.ViewModel		= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel		= "models/weapons/w_toolgun.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		    = "nail"
 
SWEP.Secondary.ClipSize	    = -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

function SWEP:Initialize()
	self.swing_sound = "npc/fast_zombie/claw_miss1.wav"
	self.hit_sound = "npc/fast_zombie/claw_strike1.wav"
	--self.nail_sound = "doors/vent_open1.wav" --2 and 3
	self.range = 70
	self.nail_length = 3
	self.nail_strength = 150
end

function SWEP:PrimaryAttack() --position 1
	if CLIENT then return end
	
	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local shootpos = ply:GetShootPos()
	local endshootpos = shootpos + ply:GetAimVector() * self.range
	local tmin = Vector(1,1,1)*-2
	local tmax = Vector(1,1,1)*2

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
	--local hit = tr.Hit

	if IsValid(ent) && (!ent:IsPlayer() && !ent:IsNPC()) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)

		ply:EmitSound(self.hit_sound)
		
		--make another trace filtering the 1st obj found,
		if (tr.Hit) then
			local tr2 = util.TraceHull( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (self.range+self.nail_length) ),
				filter = {self.Owner, ent},
				mins = Vector( -10, -10, -10 ),
				maxs = Vector( 10, 10, 10 ),
				mask = MASK_SHOT_HULL
			} )
			--if the second trace hits something new 10 units behind it, make a ballsocket constraint
			if(tr2.Hit) then
				--take 1 ammo
				self:TakePrimaryAmmo(1)
				print(tr.Entity)
				print(tr2.Entity)


				--tr.HitPos & tr2.HitPos
				--constraint.AdvBallsocket( ent, tr2.Entity, 0, 0, tr.HitPos, tr2.HitPos, self.nail_strength, self.nail_strength, -360, -360, -360, 360, 360, 360, 0.1, 0.1, 0.1, 0, 0 )
				--constraint.Rope( ent, tr2.Entity, 0, 0, tr.HitPos, tr2.HitPos, 10, 1, self.nail_strength, 3, "cable/cable_back", false )
				constraint.Weld( ent, tr2.Entity, 0, 0, self.nail_strength, false, false)

				--make nail sound
				ply:EmitSound("doors/vent_open"..math.random(1,3)..".wav")
			end
		end
	elseif !IsValid(ent) then
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:EmitSound(self.swing_sound)
	end


	--delay
	self:SetNextPrimaryFire(CurTime() + 0.5)

	ply:LagCompensation(false)
end
