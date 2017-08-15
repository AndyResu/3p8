--shameless copy-pasta of SkyLight's 3p8_time which was a copy-pasta of SkyLight's micro_gamecoob which was a copy-pasta of SkyLight's micro_item_salainen_radio which was a copy-pasta of SkyLight's micro_item_salainen_saha which was a copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--gravity for spheres ay lamo
--3p8_planet

--I think the sphere will repulse you sometimes because the center of mass is not the origin... xD


AddCSLuaFile()

ENT.Type = "anim"
ENT.ItemName = "3P8 Homeworld"
ENT.ItemModel = "models/hunter/misc/sphere375x375.mdl"

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--stop movement
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false) 
	end

	self.meme = Vector(0,0,0)
	--g = (6.674×10^−11 N(m/kg)2) --it's a constant, might need to make my own for gmod to make it dank, thanks wikipedia
	self.g = 6.674/10^(11)
	--m1 = player mass = ? PhysObj:GetMass() ? = 128 --because I said so, bitch
	self.me = 128
	--m2 = planet mass = ur mom = M⊕ = (5.9722±0.0006)×10^24 kg --wikipedia
	self.meplanet = (5.9722)*10^(15)
	--r = |(planet center - player center)|
	self.raddude = 1
	--F = g(m1)(m2)/r^2 = the magnitude of the vector I want to set the player's velocity to
	self.mag = 0
	self.delta = Vector(0,0,0)
	self.vect = Vector(0,0,0)

	--print("initialized planet")
end

if SERVER then
	function ENT:Think()
		
		--set ply velocity based on newtonian physics F = -g(m1)(m2)/r^2

		--F = g(m1)(m2)/r^2 = the magnitude of the vector I want to set the player's velocity to
		--self.mag = self.g*self.me*self.meplanet/(self.raddude^2)
		
		--local dank = ents.GetAll()

		for i,ent in pairs(ents.GetAll()) do
			local phys = ent:GetPhysicsObject()
			if ( IsValid( phys ) ) then -- Always check with IsValid! The ent might not have physics!
				self.me =  phys:GetMass()
				self.raddude = math.abs(self.meme:Distance(phys:GetPos()))
				self.mag = self.g*self.me*self.meplanet/(self.raddude^2)
				self.meme = phys:LocalToWorld( phys:GetMassCenter() )
				--largest number should be 1, smallest should be -1?
				--divide by |largest| number :P
				self.delta = (phys:GetPos() - self.meme)
				if self.delta != Vector(0,0,0) then --ignores itself
					if math.abs(self.delta.x) > math.abs(self.delta.y) && math.abs(self.delta.x) > math.abs(self.delta.z) then
						self.vect = self.delta / self.delta.x
					elseif math.abs(self.delta.y) > math.abs(self.delta.x) && math.abs(self.delta.y) > math.abs(self.delta.z) then
						self.vect = self.delta / self.delta.y
					elseif math.abs(self.delta.z) > math.abs(self.delta.y) && math.abs(self.delta.z) > math.abs(self.delta.x) then
						self.vect = self.delta / self.delta.z
					else
						print("ERROR: 3p8_planet resultant gravity vector... non-existant?")
						print(self.vect.x ..", ".. self.vect.y ..", ".. self.vect.z .. " vect " .. self.delta.x ..", ".. self.delta.y ..", ".. self.delta.z .. " delta")
					end
					--print(dank[1].ClassName .. " ************************************************")
					print(self.vect.x ..", ".. self.vect.y ..", ".. self.vect.z .. " vect " .. self.delta.x ..", ".. self.delta.y ..", ".. self.delta.z .. " delta")
					ent:SetVelocity(self.mag*self.vect) --has to be a vector, not a number...
				end
			end
		end
			

		--set player angle (rotate them like we in portal)
		--get the normal relative to the center of the planet and the player

		--ply:SetAngle()
		--nahmeen?
		--print("ply: "..self.ply.." mag: "..self.mag.." velo: "..self.meme.." angel: "..self.meme)
	end
end