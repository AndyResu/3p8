--[[

todo:
buyable breakable box, prop physics. models/props_junk/wood_crate001a.mdl
make sounds random when stuff is sold by the player... make a function that takes in the pre or post as a param...
--breakable props "crate"
	--maybe just make an ent that allows anything that it is to be breakable
--models/props_c17/pottery04a.mdl is a cool gravity gun, jump launch system
cosmetic NPC chilling like a villain

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

local sound_add = Sound("ambient/levels/canals/windchime2.wav")
local sound_buy = Sound("ambient/levels/citadel/weapon_disintegrate2.wav")

ENT.StartingCash = 25

--Will sell items to you for twice the price it buys them at if set to 2
ENT.BuySellCostRatio = 2
--when supply becomes 1 you get full price for the item with a value of 1
--if supply is two we can't have half that price because we doubled supply...
--I just want it to go down when supplied in mass... hence this number
ENT.SupplyDampening = 1

function ENT:SetupDataTables()
	--run throuhg an array and make a cost, stock, and etc for each/
	self:NetworkVar("Int", 0, "Cash")
	for i,item in pairs(GLOBAL_items_edgewood) do
		self:NetworkVar("Int", i+1, "ew_" .. GLOBAL_items_edgewood[i].ent)
	end
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
	self.pricePer = 1
	if(#GLOBAL_items_edgewood > 32) then
		print("ERROR: A shop can only buy/sell 31 items because 1 entity can only make 32 network variables for itself (1 netvar is cash). There are more than that in 3p8_shop!!")
	end
	--set up the initial stock
	if SERVER then
		self:Setew_3p8_kookospahkina_puu(50)
		self:Setew_3p8_potato_ent(25)
		self:Setew_3p8_pizza(3)
		self:Setew_3p8_metal(10)
		self:Setew_micro_item_medkit(100)
		self:Setew_micro_item_armorkit(100)
		self:Setew_3p8_pizza_kit(100)
		self:Setew_3p8_collector_puu(100)
		self:Setew_3p8_collector_puulle(100)
		self:Setew_3p8_collector_rock(100)
		self:Setew_3p8_collector_metal(100)
		self:Setew_micro_item_collectable_food(100)
		self:Setew_micro_item_collectable_toys(50)
		self:Setew_micro_item_collectable_deco(25)
		self:Setew_3p8_hate(1)
	end

	print("PIZZAS IN 3p8 CURRENTLY: "..self:Getew_3p8_pizza())
end

function ENT:GetStockOf(itemID)
	if(itemID == 1) then
		return self:Getew_3p8_kookospahkina_puu()
	elseif(itemID == 2) then
		return self:Getew_3p8_potato_ent()
	elseif(itemID == 3) then
		return self:Getew_3p8_potato_head()
	elseif(itemID == 4) then
		return self:Getew_3p8_pizza()
	elseif(itemID == 5) then
		return self:Getew_micro_item_salainen_puulle()
	elseif(itemID == 6) then
		return self:Getew_3p8_rock_s()
	elseif(itemID == 7) then
		return self:Getew_3p8_metal()
	elseif(itemID == 8) then
		return self:Getew_micro_item_medkit()
	elseif(itemID == 9) then
		return self:Getew_micro_item_armorkit()
	elseif(itemID == 10) then
		return self:Getew_3p8_pizza_kit()
	elseif(itemID == 11) then
		return self:Getew_3p8_collector_puu()
	elseif(itemID == 12) then
		return self:Getew_3p8_collector_puulle()
	elseif(itemID == 13) then
		return self:Getew_3p8_collector_rock()
	elseif(itemID == 14) then
		return self:Getew_3p8_collector_metal()
	elseif(itemID == 15) then
		return self:Getew_micro_item_collectable_food()
	elseif(itemID == 16) then
		return self:Getew_micro_item_collectable_toys()
	elseif(itemID == 17) then
		return self:Getew_micro_item_collectable_deco()
	elseif(itemID == 18) then
		return self:Getew_3p8_hate()
	else
		return 0
	end
	--RunString("return self:Getew_" .. GLOBAL_items_edgewood[itemID].ent .. "()", "RunString: GetStockOf("..GLOBAL_items_edgewood[itemID].ent..")", true)
	--RunString("return Getew_3p8_kookospahkina_puu()", "RunString: GetStockOfGUIEdition("..GLOBAL_items_edgewood[itemID].ent..")", true)
end

if SERVER then
	function ENT:SetStockOf(itemID, amount)
		if(itemID == 1) then
			self:Setew_3p8_kookospahkina_puu(amount)
		elseif(itemID == 2) then
			self:Setew_3p8_potato_ent(amount)
		elseif(itemID == 3) then
			self:Setew_3p8_potato_head(amount)
		elseif(itemID == 4) then
			self:Setew_3p8_pizza(amount)
		elseif(itemID == 5) then
			self:Setew_micro_item_salainen_puulle(amount)
		elseif(itemID == 6) then
			self:Setew_3p8_rock_s(amount)
		elseif(itemID == 7) then
			self:Setew_3p8_metal(amount)
		elseif(itemID == 8) then
			self:Setew_micro_item_medkit(amount)
		elseif(itemID == 9) then
			self:Setew_micro_item_armorkit(amount)
		elseif(itemID == 10) then
			self:Setew_3p8_pizza_kit(amount)
		elseif(itemID == 11) then
			self:Setew_3p8_collector_puu(amount)
		elseif(itemID == 12) then
			self:Setew_3p8_collector_puulle(amount)
		elseif(itemID == 13) then
			self:Setew_3p8_collector_rock(amount)
		elseif(itemID == 14) then
			self:Setew_3p8_collector_metal(amount)
		elseif(itemID == 15) then
			self:Setew_micro_item_collectable_food(amount)
		elseif(itemID == 16) then
			self:Setew_micro_item_collectable_toys(amount)
		elseif(itemID == 17) then
			self:Setew_micro_item_collectable_deco(amount)
		elseif(itemID == 18) then
			self:Setew_3p8_hate(amount)
		else
			print("ERROR: Can't set stock of something that doesn't exist...")
		end
		--RunString("self:Setew_" .. GLOBAL_items_edgewood[itemID].ent .. "(" .. amount .. ")", "RunString: SetStockOf("..GLOBAL_items_edgewood[itemID].ent..")", true)
	end
end

--has the following format
	--name="what it will show up as in the shop",
	--desc="the description of the item in the shop",
	--cost=1 --cost of the item in the shop
	--pv="models/hunter/misc/sphere025x025.mdl" --the preview model in the shop
	--ent="the_ent_name"
	--soundSell="ambient/levels/labs/coinslot1.wav" --noise to make when sold


GLOBAL_items_edgewood = {
	{
		name="Coconut",
		desc="In some tribal societies the more coconuts you have, the more powerful you are.",
		cost=25,
		pv="models/hunter/misc/sphere025x025.mdl",
		ent="3p8_kookospahkina_puu",
		soundSell="ambient/levels/labs/coinslot1.wav"
		--softcap=50, --would be used for the shop/villager AI to signal a sell order
		--produce=1 --will be negative to show consumption... --needed?
	},
	{
		name="Potato",
		desc="Might be a beautiful french fry some day.",
		cost=25,
		pv="models/props_phx/misc/potato.mdl",
		ent="3p8_potato_ent",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Potato Head",
		desc="Is somebody coming back to life? A new species? Good for science. Thanks.",
		cost=1000,
		--consider changing pv to a cheaple or something?
		pv="models/props_phx/misc/potato.mdl",
		ent="3p8_potato_head",
		soundSell="vo/eli_lab/al_minefield.wav"
	},
	{
		name="Pizza",
		desc="Yea, of course we have it!",
		cost=24,
--SET PV
		pv="models/props_docks/channelmarker_gib01.mdl",
		ent="3p8_pizza",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Log",
		desc="Put it in the sawmill to make a wall.",
		cost=25,
		pv="models/props_docks/channelmarker_gib01.mdl",
		ent="micro_item_salainen_puulle",
		soundSell="ambient/machines/hydraulic_1.wav"
	},
	{
		name="Rock",
		desc="Found all over. Exhaustible though.",
		cost=50,
		pv="models/props_wasteland/rockgranite03c.mdl",
		ent="3p8_rock_s",
		soundSell="ambient/machines/hydraulic_1.wav"
	},
	{
		name="Metal",
		desc="Refined. Like my humor.",
		cost=100,
		pv="models/props_c17/oildrumchunk01a.mdl",
		ent="3p8_metal",
		soundSell="ambient/materials/platedrop1.wav"
	},
	{
		name="Med Kit",
		desc="100 units of HP.",
		cost=50,
		pv="models/items/healthkit.mdl",
		ent="micro_item_medkit",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Armor Kit",
		desc="100 units of body armor.",
		cost=1000,
		pv="models/items/battery.mdl",
		ent="micro_item_armorkit",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Pizza Kit",
		desc="3 units of pizza to ate. INSTRUCTIONS: Put in oven. Pizza come out. Cool. We love 3p8!",
		cost=500,
--SET DAT PV
		pv="models/items/battery.mdl",
		ent="3p8_pizza_kit",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Coconut Collector",
		desc="Can carry and preserve 5 coconuts.",
		cost=250,
		pv="models/props_junk/cardboard_box001a.mdl",
		ent="3p8_collector_puu",
		soundSell="items/ammocrate_open.wav"
	},
	{
		name="Log Collector",
		desc="Can carry and preserve 5 logs.",
		cost=250,
		pv="models/props_junk/wood_crate002a.mdl",
		ent="3p8_collector_puulle",
		soundSell="items/ammocrate_open.wav"
	},
	{
		name="Rock Collector",
		desc="Can carry and preserve 5 rocks.",
		cost=250,
		pv="models/props_wasteland/laundry_washer001a.mdl",
		ent="3p8_collector_rock",
		soundSell="items/ammocrate_open.wav"
	},
	{
		name="Metal Collector",
		desc="Can carry and preserve 5 metal pieces.",
		cost=250,
		pv="models/props_lab/filecabinet02.mdl",
		ent="3p8_collector_metal",
		soundSell="items/ammocrate_open.wav"
	},
	{
		name="Collectable Food",
		desc="Exotic food that restores health! It's 1 of 11 collectable foods. Collect them all!",
		cost=500,
		pv="models/slyfo_2/acc_food_meatsandwich.mdl",
		ent="micro_item_collectable_food",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Collectable Toy",
		desc="A ball, a doll, or something special. Contains 1 of 5. Collect them all!",
		cost=1000,
		pv="models/props/de_tides/vending_turtle.mdl",
		ent="micro_item_collectable_toys",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Collectable Decoration",
		desc="Show off loot in your richie-rich spaceship! Contains 1 of 11. Collect them all!",
		cost=5000,
		pv="models/maxofs2d/gm_painting.mdl",
		ent="micro_item_collectable_deco",
		soundSell="ambient/levels/labs/coinslot1.wav"
	},
	{
		name="Spinny Ball",
		desc="Slightly-used ball that has spinny parts in it. Looks cool. Might be useful.",
		cost=3000,
		pv="models/maxofs2d/hover_rings.mdl",
		ent="3p8_hate",
		soundSell="ambient/levels/labs/coinslot1.wav"
	}
	--models/weapons/w_package.mdl --the package from the citizen at the trainstation
}

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()
	
	--sell code block
		--Easier to program for version

	--find the current item's position in the GLOBAL_items_edgewood array
	--and use it to find it's network variable and such
	local currentItemID = -1
	--instead I can get the item's ID, run that through the GetStockOf(ID) function
	for i, item in pairs(GLOBAL_items_edgewood) do
		if(item.ent == class) then
			currentItemID = i
			break
		end
	end
	
	if string.match(class, "3p8_collector") then
		--should use the global edgewood prices / 2 I think
		local stock = self:GetStockOf(currentItemID)
		if string.match(class, "_puu") then
			for i, item in pairs(GLOBAL_items_edgewood) do
				if(item.ent == "3p8_kookospahkina_puu") then
					currentItemID = i
					break
				end
			end
			self.pricePer = (self:CalculateCost(currentItemID, stock)) / self.BuySellCostRatio
		elseif string.match(class, "_puulle") then
			for i, item in pairs(GLOBAL_items_edgewood) do
				if(item.ent == "micro_item_salainen_puulle") then
					currentItemID = i
					break
				end
			end
			self.pricePer = (self:CalculateCost(currentItemID, stock)) / self.BuySellCostRatio
		elseif string.match(class, "_rock") then
			for i, item in pairs(GLOBAL_items_edgewood) do
				if(item.ent == "3p8_rock_s") then
					currentItemID = i
					break
				end
			end
			self.pricePer = (self:CalculateCost(currentItemID, stock)) / self.BuySellCostRatio
		elseif string.match(class, "_metal") then
			for i, item in pairs(GLOBAL_items_edgewood) do
				if(item.ent == "3p8_metal") then
					currentItemID = i
					break
				end
			end
			self.pricePer = (self:CalculateCost(currentItemID, stock)) / self.BuySellCostRatio
		else
			print("ERROR: Collector type not yet implemented in 3p8_shop!")
			self.pricePer = 1
		end
		self:AddCash(data.HitEntity:GetCount()*self.pricePer)
		data.HitEntity:SetCount(0)
		self:EmitSound("items/ammocrate_open.wav")
	elseif (currentItemID > 0) then
	--if the id was found in the array, gib monie, otherwise we don't care
		--delete item to be sold
		data.HitEntity:Remove()
		self:SetStockOf(currentItemID, self:GetStockOf(currentItemID)+1)
		local stock = self:GetStockOf(currentItemID)
		--increase the stock of currentItemID by one
		--gib monie
			-- / self.BuySellCostRatio divides by that when trying to earn money from selling.
		self:AddCash(math.ceil((self:CalculateCost(currentItemID, stock)) / self.BuySellCostRatio))
		--make sound
		self:EmitSound(GLOBAL_items_edgewood[currentItemID].soundSell)
	else
		print("DEBUGGING ERROR: Item not found in 3p8_shop")
	end
	
end

function ENT:CalculateCost(itemID, stockOfItem)
	--price = (base cost of item / 2) / (stock * 0.1) (rounded up)
		--do that divide by two outside. leave this method for calculating price (like MSRP) for an item
		-- / self.BuySellCostRatio
	return math.ceil((GLOBAL_items_edgewood[itemID].cost) / (stockOfItem*self.SupplyDampening))
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

function ENT:Use(ply)
	ply:SendLua("MICRO_SHOW_SHOP(Entity("..self:EntIndex().."))")
end

if SERVER then
	

	function ENT:AddCash(amount)
		self:SetCash(self:GetCash()+amount)
		self:EmitSound(sound_add)
		return true
	end
end

function ENT:GetItemSpawn()
	return self:GetPos() + self:GetForward()*64 + Vector(0,0,64)
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

-- This is bad.

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
	local stocky = shop_ent:GetStockOf(n)
	local costy = shop_ent:CalculateCost(n, stocky)
	if shop_ent:GetCash()<costy or stocky <= 0 then return end
	shop_ent:SetCash(shop_ent:GetCash()-costy)
	shop_ent:SetStockOf(n, stocky-1)

	shop_ent:EmitSound(sound_buy)

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

	local notThere = 0
	for i,item in pairs(GLOBAL_items_edgewood) do
		local stocke = ent:GetStockOf(i)
		if (stocke>0) then
			local y_base = (i-notThere-1)*90

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
			cost:SetText("$"..ent:CalculateCost(i, stocke))
			cost:SetDark(true) 
			cost:SizeToContents()
			cost:SetPos(600-cost:GetWide(),10)

			local stock = panel:Add("DLabel")
			--stock:SetFont("DermaLarge")
			stock:SetText("Stock: "..stocke.." ")
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

			--[[function stock:Think()
				stock:SetText("Stock: "..GLOBAL_items_edgewood[i].stock.." ") --gets the value clientside...
				--if CLIENT then return end --only the client can get to this part, so this will make the function do nothing
				--stock:SetText("Stock: "..RunConsoleCommand("3p8_stock",ent:EntIndex(),i).." ")
				--stock:SetText("Stock: ".."0".." ")
				
				--print(GLOBAL_items_edgewood[i].stock)
			end]]

			function button:Think()
				local cash = ent:GetCash()
				local stocke = ent:GetStockOf(i)

				-- WARNING! SLOW! DOES A TRACE FOR EVERY BUTTON!
				if ent:CalculateCost(i, stocke)>cash or (GLOBAL_items_edgewood[i].ent and blocked) or (stocke <= 0) then
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
