--[[
	3p8_collector
	Uses:		Collects entities that would be a pain to move one by one.
				ideally to be used as a base ent by which other collectors can be made easily

	Todo:		

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.HeldObject = "3p8_kookospahkina_puu"
ENT.ItemName = "Collector"
ENT.ItemModel = "models/props_junk/cardboard_box001a.mdl"
ENT.MaxCount = 5
ENT.health = 50

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Count")
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()
	local model = data.HitEntity:GetModel()

	if class == self.HeldObject && self:GetCount() < self.MaxCount then
		data.HitEntity:Remove()
		self:TryTake(-1)

		self:EmitSound("items/ammocrate_close.wav")
	end
	--collision with a shop or factory is handled in the respective ent...
end

--make the entity spawn on top
function ENT:Use(ply)
	self:TryTake(1)
	--produce the contained entity (not actually metal per se)
	metal = ents.Create(self.HeldObject)
	if ( !IsValid( metal ) ) then return end
	metal:SetPos(self:GetPos() + self:GetForward()*48 + Vector(0,0,16))
	metal:SetAngles(Angle(math.random(-179,180), math.random(-179,180), 0))
	metal:Spawn()
	self:EmitSound("items/ammocrate_open.wav")
end

--overwrites the default initialize. Might double up the Phsyics init, I'm not sure tho.
--this is done because self:SetCount(0) must run to ensure that the box starts empty, not full of the entity
function ENT:Initialize()
	self:SetModel(self.ItemModel)
	if(self.Material != nil) then
		self:SetMaterial(self.Material)
	end
	self:PhysicsInitStandard()

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetCount(0)
	end

end

--also overriding this because I don't want it to remove when it hits 0
if SERVER then
	function ENT:TryTake(amount)
		if amount>=self:GetCount()+1 then
			-- prevent possible crash when this is called from a collision hook
			timer.Simple(0,function()
				if IsValid(self) then
					self:Remove()
				end
			end)
			local count = self:GetCount()
			self:SetCount(0)
			return count
		else
			self:SetCount(self:GetCount()-amount)
			return amount
		end
	end
else
	function ENT:DrawTranslucent()
		self:DrawModel()
		if IsValid(self.cmodel) then
			self.cmodel:SetRenderOrigin(self:LocalToWorld(Vector(0,0,11)))
			self.cmodel:SetRenderAngles(self:GetAngles())
			self.cmodel:DrawModel()
		end
	end

	function ENT:GetMicroHudText()
		return self.ItemName..": "..self:GetCount().." / "..self.MaxCount
	end

	function ENT:OnRemove()
		if IsValid(self.cmodel) then
			self.cmodel:Remove()
		end
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 && SERVER then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE
		for i=1,self:GetCount() do
			--produce the contained entity (not actually metal per se)
			metal = ents.Create(self.HeldObject)
			if ( !IsValid( metal ) ) then return end
			metal:SetPos(self:GetPos())
			metal:SetAngles(Angle(math.random(-179,180), math.random(-179,180), 0))
			metal:Spawn()
		end
		self:Remove()
	end
end
