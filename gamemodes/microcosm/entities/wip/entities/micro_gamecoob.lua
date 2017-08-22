--shameless copy-pasta of SkyLight's micro_item_salainen_radio which was a copy-pasta of SkyLight's micro_item_salainen_saha which was a copy-pasta of SkyLight's micro_item_salainen_kanto which was a copy-pasta of SkyLight's micro_item_salainen_puulle which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu7 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu6 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu5 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu4 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu3 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu2 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu1 which was a copy-pasta of SkyLight's micro_item_salainen_kookospahkina_puu which was a copy-pasta of SkyLight's micro_item_secrete_hd which was a copy-pasta of SkyLight's micro_collectable_food which was a copy-pasta of SkyLight's micro_item_armorkit.lua which was a copy-pasta of Parakeet's micro_item_medkit.lua
--gottem

--cheat code swag
--micro_gamecoob
--lets you spawn all the new memes

AddCSLuaFile()

ENT.Base = "micro_item_salainen"
ENT.ItemName = "GameCoob"
ENT.ItemModel = "models/props_lab/harddrive01.mdl"

local sound_add = Sound("ambient/levels/canals/windchime2.wav")
local sound_buy = Sound("ambient/levels/citadel/weapon_disintegrate2.wav")

function ENT:Initialize()
	self:SetModel(self.ItemModel)
	self:PhysicsInitStandard()
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(3)
	--self:SetMoveType(0)

	--self:SetMaterial("phoenix_storms/potato")
	
	self.health = 1000
end

function ENT:Use(ply)
	if not self:IsBroken() then
		ply:SendLua("MICRO_SHOW_SHOP(Entity("..self:EntIndex().."))")
	end
end

function ENT:GetItemSpawn()
	return self:GetPos()+Vector(0,0,24)
end

-- rerr!

local items = {
	{
		name="micro_item_salainen_kookospahkina_puu",
		desc="dank af cocnut for spawn !",
		pv="models/hunter/misc/sphere025x025.mdl",
		ent="micro_item_salainen_kookospahkina_puu"
	},
	{
		name="micro_item_salainen_saha",
		desc="turn those logs into noting at the moment. might copy-paste this code to make it act like a wood shop",
		pv="models/props_lab/kennel_physics.mdl",
		ent="micro_item_salainen_saha"
	},
	{
		name="micro_item_salainen_radio",
		desc="will play music eventually, core story piece",
		pv="models/props/cs_office/radio.mdl",
		ent="micro_item_salainen_radio"
	},
	{
		name="clip with the stendo",
		desc="cap a mofucka",
		pv="models/weapons/w_pistol.mdl",
		ent="micro_clip_with_stendo"
	},
	{
		name="coordinate finder",
		desc="read the instructions with it xD",
		pv="models/weapons/w_toolgun.mdl",
		ent="micro_coordfinder"
	},
	{
		name="D.W.A.R.F.",
		desc="melee is broken?? pray to parkaeet for forgiveness and help",
		pv="models/zombie/classic_torso.mdl",
		ent="micro_secrete_dwarf"
	},
	{
		name="I.T.",
		desc="???",
		pv="models/dav0r/buttons/button.mdl",
		ent="micro_secrete_it"
	},
	{
		name="O.C.D.",
		desc="wip Orbital Cheeseburger Deployment",
		pv="models/food/burger.mdl",
		ent="micro_secrete_ocd"
	},
	{
		name="stick1",
		desc="plain old stick. LIL B - STICK",
		pv="models/props_foliage/driftwood_02a.mdl",
		ent="micro_secrete_stick1"
	},
	{
		name="stick2",
		desc="How 2 become a Wizard (look it up) FLIPENDO",
		pv="models/props_foliage/driftwood_02a.mdl",
		ent="micro_secrete_stick2"
	},
	{
		name="S.U.C.K. prototype",
		desc="wip. placeholder name. might be final version tho too.",
		pv="models/gibs/agibs.mdl",
		ent="micro_secrete_suck"
	},
	{
		name="T.A.F.H.E.",
		desc="how to slay slurs for real",
		pv="models/food/hotdog.mdl",
		ent="micro_secrete_tafhe"
	}
}

if SERVER then
	-- This is shitty. REMIXXX

	concommand.Add("micro_shop_bui",function(ply,_,args)
		local shop_ent = Entity(tonumber(args[1]) or 0)

		local n = tonumber(args[2])

		if !ply:Alive() or !isnumber(n) or items[n]==nil or !IsValid(shop_ent) or shop_ent:GetClass()!="micro_item_salainen_gamecoob" then return end

		if shop_ent:GetPos():Distance(ply:GetPos())>200 then return end

		local item = items[n]

		if isstring(item.ent) then
			--if shop_ent:CheckBlocked() then return end
		elseif !isfunction(item.func) then return end

		shop_ent:EmitSound(sound_buy)

		if isstring(item.ent) then
			local ent = ents.Create(item.ent)
			if !IsValid(ent) then error("FAILED to make bought entity!") end
			--ent:SetModel("models/Items/item_item_crate.mdl")
			ent:SetPos(shop_ent:GetItemSpawn())
			ent:Spawn()
			print("spawning micro_gamecoob")
		else
			print("Error: wew laddy? in micro_gamecoob")
			--item.func(ship)
		end

	end)
else
	function MICRO_SHOW_SHOP(ent)
		local blocked

		local panel = vgui.Create("DFrame")
		panel:SetDraggable(false)
		panel:SetSizable(false)
		panel:SetTitle("Shop")
		panel:SetSize(640,480)
		panel:Center()
		panel:MakePopup()

		panel.Think = function(self)
			if !LocalPlayer():Alive() then
				self:Close()
			--else
				--blocked = ent:CheckBlocked()
			end
		end
		
		panel.PaintOver = function(self)
			local color = team.GetColor(LocalPlayer():Team())

			surface.SetDrawColor(Color( 0, 0, 0))
			surface.DrawRect(285, 30, 330, 40)

			surface.SetDrawColor(color)
			surface.DrawOutlinedRect(285, 30, 330, 40)
		end

		local scroll = panel:Add("DScrollPanel")
		scroll:Dock(FILL)
		scroll:DockMargin(0,50,0,0)

		for i,item in pairs(items) do
			local y_base = (i-1)*90

			local panel = scroll:Add("DPanel")
			panel:SetPos(0, y_base)
			panel:SetSize(610,80)

			local title = panel:Add("DLabel")
			title:SetPos(100,0)
			title:SetFont("DermaLarge")
			title:SetText(item.name)
			title:SetDark(true) 
			title:SizeToContents()

			local icon = panel:Add("DModelPanel")
			icon:SetSize(70, 70)
			icon:SetPos(0,0)
			icon:SetModel(item.pv)
			icon:SetLookAt( Vector(0,0,0) )
			icon:SetFOV(1.5*icon:GetEntity():GetModelRadius())

			local desc = panel:Add("DLabel")
			desc:SetPos(100,40)
			desc:SetText(item.desc)
			desc:SetDark(true) 
			desc:SizeToContents()

			local button = panel:Add("DButton")
			button:SetText("Buy")
			button:SetPos(540,50)

			function button:DoClick()
				RunConsoleCommand("micro_shop_bui",ent:EntIndex(),i)
			end
		end
	end
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 then
		self:EmitSound("player/bhit_helmet-1.wav")
		--PRODUCE gibs HERE

		self:Remove()
	end
end