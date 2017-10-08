--[[

todo:
can only buy 1 3p8_hate
buyable breakable box, prop physics. models/props_junk/wood_crate001a.mdl
make sounds random when stuff is sold by the player... make a function that takes in the pre or post as a param...
--stock system and dynamic pricing for supply/demand :D
--breakable props "crate"
	--maybe just make an ent that allows anything that it is to be breakable
cosmetic NPC chilling like a villain
make buttons not appear if there is 0 stock, contrapositively, make them appear when there is stock

pre
vo/novaprospekt/al_illtakecare.wav
vo/novaprospekt/al_done01.wav
vo/novaprospekt/al_elevator02.wav
vo/k_lab/al_buyyoudrink02.wav
vo/eli_lab/al_anotherdog.wav
vo/eli_lab/al_awesome.wav
vo/eli_lab/al_excellent01.wav
vo/eli_lab/al_sweet.wav
vo/eli_lab/al_throwitdog.wav

post
vo/novaprospekt/al_careofyourself.wav
vo/novaprospekt/al_gladtoseeyoureok.wav
vo/novaprospekt/al_onepiece.wav
vo/k_lab2/al_gordontakecare_b.wav
vo/eli_lab/al_nicecatch01.wav
vo/eli_lab/al_soquickly03.wav
vo/eli_lab/al_thyristor02.wav
vo/eli_lab/al_allright01.wav
vo/citadel/al_notagain02.wav --damn it, not again


buying sounds
vo/eli_lab/al_giveittry.wav
vo/eli_lab/al_hazmat.wav --laser gun
vo/eli_lab/al_hereyougo02.wav
vo/eli_lab/al_minefield.wav --clearing minefields
vo/eli_lab/al_takeit.wav
vo/eli_lab/al_takethis.wav

or
ambient/levels/labs/coinslot1.wav

--chaching
npc/combine_soldier/gear3.wav
ambient/levels/canals/windchime4.wav
ambient/levels/canals/windchime5.wav
ambient/levels/labs/coinslot1.wav

unrelated but cool
ambient/levels/prison/radio_random15.wav --1 to 15
]]

AddCSLuaFile()

ENT.Type = "anim"

--models/player/group01/female_02.mdl
ENT.ComponentModel = "models/props_wasteland/controlroom_storagecloset001a.mdl"
ENT.ComponentScreenWidth = 180
ENT.ComponentScreenHeight = 180
ENT.ComponentScreenOffset = Vector(24,-22.5,46)
ENT.ComponentScreenRotation = Angle(0,90,90)

ENT.StartingCash = 0

local sound_add = Sound("ambient/levels/canals/windchime2.wav")
local sound_buy = Sound("ambient/levels/citadel/weapon_disintegrate2.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Cash")
end

function ENT:GetComponentName()
	return "Shop"
end

function ENT:Initialize()
	self:SetModel(self.ComponentModel)
	self:SetMaterial("models/effects/splodeglass_sheet") --make invis
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetAngles(Angle(0,-90,0))

	self:PhysicsInitStandard()

	if SERVER then
		self:GetPhysicsObject():EnableMotion(false)
		self:SetUseType(SIMPLE_USE)

		self:SetCash(self.StartingCash)

		--[[local ent = ents.Create("npc_citizen")
		ent:SetPos(self:GetPos())
		ent:SetAngles(Angle(0,-90,0))
		ent:SetModel("models/player/group01/female_02.mdl")
		ent:SetMoveType(MOVETYPE_NONE)

		--self:SetParent(ent, -1) --test
		--if this doesn't work, clear all capabilities besides animated face?
		ent:SetNPCState(NPC_STATE_SCRIPT)
		ent:SetSchedule(SCHED_NPC_FREEZE)
		ent:CapabilitiesClear() 
		ent:CapabilitiesAdd(CAP_ANIMATEDFACE || CAP_TURN_HEAD) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
		ent:DropToFloor()

		ent:Spawn()]]
	end
	self.health = 100
end

function ENT:OnTakeDamage(damageto)
	self.health = self.health - damageto:GetDamage()
	if self.health <= 0 && SERVER then
		self:EmitSound("weapons/debris1.wav")
		--PRODUCE gibs HERE

		--[[if(ent:isValid()) then
			ent:Remove()
		end]]
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	--sell code block
	if class == "3p8_kookospahkina_puu" then --make this check a table of items and their sell prices.
		data.HitEntity:Remove()
		--gib monie
		self:AddCash(1)
		self:EmitSound("ambient/levels/labs/coinslot1.wav") --play a cha-ching sound.
		--DOESN'T WORK WHYYAAA
		--print(items[1].stock)
		GLOBAL_items_edgewood[1].stock = GLOBAL_items_edgewood[1].stock + 1
	elseif class == "micro_item_salainen_puulle" then
		data.HitEntity:Remove()
		self:AddCash(5)
		self:EmitSound("ambient/machines/hydraulic_1.wav") --saw sound
	elseif class == "3p8_rock_s" then
		data.HitEntity:Remove()
		self:AddCash(10)
		self:EmitSound("ambient/machines/hydraulic_1.wav")
	elseif class == "3p8_potato_ent" then
		data.HitEntity:Remove()
		self:AddCash(1)
		self:EmitSound("ambient/levels/labs/coinslot1.wav")
	elseif class == "3p8_potato_head" then
		data.HitEntity:Remove()
		self:AddCash(1000)
		self:EmitSound("vo/eli_lab/al_minefield.wav")
	elseif class == "3p8_metal" then
		data.HitEntity:Remove()
		self:AddCash(20)
		self:EmitSound("ambient/materials/platedrop1.wav")
	end
end

function ENT:Use(ply)
	ply:SendLua("MICRO_SHOW_SHOP(Entity("..self:EntIndex().."))")
end

if SERVER then
	--function ENT:Think()
	--end

	function ENT:AddCash(amount)
		self:SetCash(self:GetCash()+amount)
		self:EmitSound(sound_add)
		return true
	end
end

function ENT:GetItemSpawn()
	return self:GetPos()+Vector(32,32,24)
end

function ENT:CheckBlocked()
	local r = 9
	local tr = util.TraceHull{start=self:GetItemSpawn(),endpos=self:GetItemSpawn(),mins=Vector(-1,-1,-1)*r, maxs=Vector(1,1,1)*r, filter=self}
	return tr.Hit
end

if CLIENT then
	function ENT:GetScreenText()
		return "Ready",Color(0,255,0)
	end
end

function ENT:drawInfo()
	local cash = self:GetCash()

	draw.SimpleText("$"..cash,"micro_big",88,80,Color(255,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	local text,text_color = self:GetScreenText()
	draw.SimpleText(text,"micro_big",88,130,text_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

GLOBAL_items_edgewood = {
	{
		name="Coconut",
		desc="In some tribal societies the more coconuts you have, the more powerful you are.",
		cost=5,
		pv="models/hunter/misc/sphere025x025.mdl",
		ent="3p8_kookospahkina_puu",
		stock=1,
		--softcap=50,
		produce=1 --will be negative to show consumption... --needed? 
	},
	{
		name="Potato",
		desc="Might be a beautiful french fry some day.",
		cost=5,
		pv="models/props_phx/misc/potato.mdl",
		ent="3p8_potato_ent",
		stock=100
	},
	{
		name="Metal",
		desc="Refined. Like my humor.",
		cost=40,
		pv="models/props_c17/oildrumchunk01a.mdl",
		ent="3p8_metal",
		stock=10
	},
	{
		name="Med Kit",
		desc="Restores 100 crew HP.",
		cost=5,
		pv="models/items/healthkit.mdl",
		ent="micro_item_medkit",
		stock=100
	},
	{
		name="Armor Kit",
		desc="100 units of body armor.",
		cost=100,
		pv="models/items/battery.mdl",
		ent="micro_item_armorkit",
		stock=100
	},
	{
		name="Collectable Food",
		desc="Exotic food that restores health! It's 1 of 11 collectable foods. Collect them all!",
		cost=50,
		pv="models/slyfo_2/acc_food_meatsandwich.mdl",
		ent="micro_item_collectable_food",
		stock=100
	},
	{
		name="Collectable Toy",
		desc="A ball, a doll, or something special. Contains 1 of 5. Collect them all!",
		cost=100,
		pv="models/props/de_tides/vending_turtle.mdl",
		ent="micro_item_collectable_toys",
		stock=100
	},
	{
		name="Collectable Decoration",
		desc="Show off loot in your richie-rich spaceship! Contains 1 of 11. Collect them all!",
		cost=500,
		pv="models/maxofs2d/gm_painting.mdl",
		ent="micro_item_collectable_deco",
		stock=100
	},
	{
		name="Spinny Ball",
		desc="Slightly-used ball that has spinny parts in it. Looks cool. Might be useful.",
		cost=3000,
		pv="models/maxofs2d/hover_rings.mdl",
		ent="3p8_hate",
		stock=1
	}
	--models/weapons/w_package.mdl --the package from the citizen at the trainstation
}


-- This is shitty.

concommand.Add("micro_shop_buy",function(ply,_,args)
	local shop_ent = Entity(tonumber(args[1]) or 0)

	local n = tonumber(args[2])

	if !ply:Alive() or !isnumber(n) or GLOBAL_items_edgewood[n]==nil or !IsValid(shop_ent) then return end

	if shop_ent:GetPos():Distance(ply:GetPos())>200 then return end

	local item = GLOBAL_items_edgewood[n]

	if isstring(GLOBAL_items_edgewood[n].ent) then
		if shop_ent:CheckBlocked() then return end
	elseif !isfunction(GLOBAL_items_edgewood[n].func) then return end

	-- point of no return
	if shop_ent:GetCash()<GLOBAL_items_edgewood[n].cost then return end
	shop_ent:SetCash(shop_ent:GetCash()-item.cost)

	shop_ent:EmitSound(sound_buy)





	--make this call a function outside the concommand if server/client then? not sure. this is why it is broken. maybe make sets of network variables?







	GLOBAL_items_edgewood[n].stock = GLOBAL_items_edgewood[n].stock - 1 --WEWEST LAD
	print(GLOBAL_items_edgewood[n].stock)
	--just goes down by one each time........???!?!??!??

	if isstring(GLOBAL_items_edgewood[n].ent) then
		local ent = ents.Create(GLOBAL_items_edgewood[n].ent)
		if !IsValid(ent) then error("FAILED to make bought entity!") end
		--ent:SetModel("models/Items/item_item_crate.mdl")
		ent:SetPos(shop_ent:GetItemSpawn())
		ent:Spawn()
	else
		--item.func(ship) --?????
	end

end)


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

		local cash = ent:GetCash()
		draw.SimpleText("$"..cash,"micro_big",605,50,Color(255,255,0),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		
		local text,text_color = ent:GetScreenText()
		draw.SimpleText(text,"micro_big",380,50,text_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	local scroll = panel:Add("DScrollPanel")
	scroll:Dock(FILL)
	scroll:DockMargin(0,50,0,0)

	for i,item in pairs(GLOBAL_items_edgewood) do
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

		local cost = panel:Add("DLabel")
		cost:SetFont("DermaLarge")
		cost:SetText("$"..item.cost)
		cost:SetDark(true) 
		cost:SizeToContents()
		cost:SetPos(600-cost:GetWide(),10)

		local stock = panel:Add("DLabel")
		--stock:SetFont("DermaLarge")
		stock:SetText("Stock: "..GLOBAL_items_edgewood[i].stock.." ")
		stock:SetDark(true)
		stock:SizeToContents()
		stock:SetPos(530-stock:GetWide(),60)

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
			RunConsoleCommand("micro_shop_buy",ent:EntIndex(),i)
		end

		function stock:Think()
			stock:SetText("Stock: "..GLOBAL_items_edgewood[i].stock.." ")
		end

		function button:Think()
			local cash = ent:GetCash()

			-- WARNING! SLOW! DOES A TRACE FOR EVERY BUTTON!
			if GLOBAL_items_edgewood[i].cost>cash or (GLOBAL_items_edgewood[i].ent and blocked) or GLOBAL_items_edgewood[i].stock<=0 then
				self:SetDisabled(true)
			else
				self:SetDisabled(false)
			end
		end
	end
end


--stuff from component
function ENT:Draw()
	local is_controlling = LocalPlayer().proxyctrls_ent == self

	self:DrawModel()
		cam.Start3D2D(self:LocalToWorld(self.ComponentScreenOffset),self:LocalToWorldAngles(self.ComponentScreenRotation), .25 )
			self:drawScreen()
		cam.End3D2D()

end

hook.easy("HUDPaint",function()
	local control_ent = LocalPlayer().proxyctrls_ent

	if IsValid(control_ent) and control_ent.drawScreenToHud and isfunction(control_ent.drawScreen) then

		local matrix = Matrix()
		matrix:Translate(Vector(ScrW()-control_ent.ComponentScreenWidth,ScrH()-control_ent.ComponentScreenHeight,0))
		--matrix:Scale(Vector(2,2,2))
		cam.PushModelMatrix(matrix)
		control_ent:drawScreen()
		cam.PopModelMatrix()
		--end
	end
end)

function ENT:drawScreen()
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

	self:drawInfo()

	render.SetStencilEnable(false)
end
