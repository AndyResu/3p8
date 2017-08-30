--[[
	TODO: POTATOE HEADS
	characters
		models/breen/breen_face --albino ***
		models/gman/gman_facehirez
		models/kleiner/walter_face --bald
		models/monk/grigori_head
		models/mossman/mossman_face --***
		models/odessa/odessa_face
	rebels
		models/humans/female/group03/chau_facemap
		models/humans/female/group03/joey_facemap
		models/humans/female/group03/kanisha_cylmap --***
		models/humans/female/group03/kim_facemap
		models/humans/female/group03/lakeetra_facemap
		models/humans/female/group03/naomi_facemap

		models/humans/female/group03/naomi_facemap
		models/humans/male/group03/erdim_cylmap --beard
		models/humans/male/group03/erdim_facemap --nobeard
		models/humans/male/group03/eric_facemap
		models/humans/male/group01/eric_facemap --notice group01 BALDIE***
		models/humans/male/group03/joe_facemap --black guy ***
		models/humans/male/group03/mike_facemap
		models/humans/male/group03/sandro_facemap
		models/humans/male/group03/ted_facemap
		models/humans/male/group03/van_facemap
		models/humans/male/group03/vance_facemap

	File theme song: 
	https://www.youtube.com/watch?v=aKfJa2_VIbo
	Love yourself for who you are. 

]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.ItemModel = "models/props_phx/misc/potato.mdl"

ENT.face = {	"models/breen/breen_face", "models/kleiner/walter_face", "models/mossman/mossman_face", "models/humans/female/group03/kanisha_cylmap", 
				"models/humans/male/group03/erdim_facemap", "models/humans/male/group01/eric_facemap", "models/humans/male/group03/joe_facemap"}

function ENT:Use(ply)
	self:GetPhysicsObject():Wake()
end

function ENT:Initialize()

	self.health = 1000

	if SERVER then
		self:SetMaterial(self.face[math.random(#self.face)])
		self:SetModel(self.ItemModel)
		self:PhysicsInitStandard()
		self:SetSolid(6)
		self:SetMoveType(6)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
			phys:SetMass(10)
		end

		--potato clock
		local timer_name = "potatoHeadDepletion_" .. self:EntIndex()
		timer.Create(timer_name,900,0, function()
			chance = math.Rand(0,1)
			if !IsValid(self) then
				self.Remove()
				timer.Remove(timer_name)
			end
		end)
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("ambient/voices/citizen_beaten"..math.random(1,5)..".wav")
		self:Remove()
	end
end
