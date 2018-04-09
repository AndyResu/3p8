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
ENT.ParentEnt = nil
ENT.StockArray = nil

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
	self.health = 100

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

		--set up the initial stock
		for i = 1, #self.StockArray do
			self:SetNWInt(self.StockArray[i].ent, self.StockArray[i].stock)
		end

	end
	if CLIENT then
		--doesn't work on 2-player server ******************************************************************************************************************************
		--for client. Works fine for server
		print(self.ParentEnt)
		self.ParentEnt = self:GetNWEntity("ParentEnt", "error")
		print(self.ParentEnt)
		--loop through the possible network entity names and reconnstruct the array clientside
		local meme = self.ParentEnt.ParentEnt.ItemList
		--wow, this works. who to heck done it?????????????????????????????????????
		--local memeArray = {{1},{},{},{},{5},{},{},{},{},{10},{},{},{},{},{15},{},{},{},{},{20},{},{},{},{},{25},{},{},{},{},{30},{},{},{},{},{35},{},{},{},{},{40},{},{},{},{},{45},{},{},{},{},{50}}
		--[[local memeArray = {}
		for i = 1, #meme do
			memeArray[i] = -1
			print(memeArray[i])
		end
		local eSize = 1]]
		local size = #meme
		local i = 1
		while(i <= size) do
			--print("Size of meme: " .. #meme)
			--print("i: " .. i)
			local stock = self:GetNWInt(meme[i].ent, -999)
			if(stock >= 0) then
				--the value exists, and the stock should be set 
				meme[i].stock = stock
				--print("meme["..i.."].ent: " .. meme[i].ent)
			elseif(stock < 0) then
				--the value does not exist and should be removed from meme
				--print("*******************")
				--[[for j = 1, #meme do
					print("meme["..j.."].ent: " .. meme[j].ent)
				end]]
				--print("******************* removing: " .. meme[i].ent)
				--table.remove(meme, i)
				--size = #meme
				--[[for j = 1, #meme do
					print("meme["..j.."].ent: " .. meme[j].ent)
				end]]
				--print("*******************")
				--i = i - 1

				meme[i].stock = -1
			end
			i = i + 1
		end

		self.StockArray = meme
	end
end

function ENT:PhysicsCollide(data, phys)
	local class = data.HitEntity:GetClass()

	--sell code block
		--Easier to program for version 2.0
	
	if string.match(class, "3p8_collector") then
		--should use the global edgewood prices / 2 I think
		self:PlayerSellToShop(data.HitEntity.HeldObject, data.HitEntity:GetCount())
		data.HitEntity:SetCount(0)
		self:EmitSound("items/ammocrate_open.wav")
	elseif (self:GetItemIDFromEntName(class) != nil) then
	--if the id was found in the array, gib monie, otherwise we don't care
		--delete item to be sold
		data.HitEntity:Remove()
		--increase the stock of currentItemID by one
		--gib monie
			-- / self.BuySellCostRatio divides by that when trying to earn money from selling.
		self:PlayerSellToShop(class, 1)
		local currentItemID = self:GetItemIDFromEntName(class)
		--make sound
		self:EmitSound(self.ParentEnt.ParentEnt.ItemList[currentItemID].soundSell)
	else
		print("DEBUGGING ERROR: Item not found in 3p8_shop")
	end
	
end

function ENT:CalculateCost(itemID, stockOfItem)
	--price = (base cost of item / 2) / (stock * 0.1) (rounded up)
		--do that divide by two outside. leave this method for calculating price (like MSRP) for an item
		-- / self.BuySellCostRatio
	return math.ceil((self.ParentEnt.ParentEnt.ItemList[itemID].cost) / (stockOfItem*self.SupplyDampening))
end

function ENT:PlayerSellToShop(entName, amount)
	self:SetNWInt(entName, (self:GetNWInt(entName, 0)+amount))
	local stock = self:GetNWInt(entName, -999)
	--sell the stock along the price / supply curve
	for i = 1, amount do
		self:AddCash(math.ceil(1*(self:CalculateCost(self:GetItemIDFromEntName(entName), stock-amount+i)) / self.BuySellCostRatio))
	end
end

--the sell function. Originally was meant for overworld use only, but became the way to sell stuff easy
	--takes money from the shop and gives stock
function ENT:ow_sellToShop(entName, amount)
	--gotta update the local array of stuff
	self:SetNWInt(entName, (self:GetNWInt(entName, 0)+amount))
	local stock = self:GetNWInt(entName, -999)
	--sell the stock along the price / supply curve
	for i = 1, amount do
		self:AddCash(math.ceil(-1*(self:CalculateCost(self:GetItemIDFromEntName(entName), stock-amount+i)) / self.BuySellCostRatio))
	end
end

--great for selling inventories if you are a villager or w/e
function ENT:SellToShopArray(entArray)
	for i = 1, #entArray do
		if (entArray.ent != "Cash" && entArray.ent != "Money") then
			self:ow_sellToShop(entArray[i].ent, entArray[i].stock)
		end
	end
end

function ENT:GetItemIDFromEntName(entName)
	local itemID = nil
	for i = 1, #self.ParentEnt.ParentEnt.ItemList do
		if entName == self.ParentEnt.ParentEnt.ItemList[i].ent then
			itemID = i
		end
	end
	return itemID
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

	if !ply:Alive() or !isnumber(n) or shop_ent.ParentEnt.ParentEnt.ItemList[n]==nil or !IsValid(shop_ent) then return end

	if shop_ent:GetPos():Distance(ply:GetPos())>200 then return end

	if isstring(shop_ent.ParentEnt.ParentEnt.ItemList[n].ent) then
		if shop_ent:CheckBlocked() then return end
	--[[elseif !isfunction(GLOBAL_items_edgewood[n].func) then return ]]end

	-- point of no return
	local stocky = shop_ent:GetNWInt(shop_ent.ParentEnt.ParentEnt.ItemList[n].ent, -999)
	local costy = shop_ent:CalculateCost(shop_ent:GetItemIDFromEntName(shop_ent.ParentEnt.ParentEnt.ItemList[n].ent), stocky)
	if shop_ent:GetCash()<costy or stocky <= 0 then return end
	shop_ent:SetCash(shop_ent:GetCash()-costy)
	shop_ent:SetNWInt(shop_ent.ParentEnt.ParentEnt.ItemList[n].ent, stocky-1)

	shop_ent:EmitSound(sound_buy)

	if isstring(shop_ent.ParentEnt.ParentEnt.ItemList[n].ent) then
		local ent = ents.Create(shop_ent.ParentEnt.ParentEnt.ItemList[n].ent)
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
	for i,item in pairs(ent.StockArray) do
		local stocke = ent:GetNWInt(ent.StockArray[i].ent, -999)
		if (stocke>0) then
			local y_base = (i-notThere-1)*90

			local panel = scroll:Add("DPanel")
			panel:SetPos(0, y_base)
			panel:SetSize(610,80)

			local title = panel:Add("DLabel")
			title:SetPos(100,0)
			title:SetFont("DermaLarge")
			title:SetText(ent.ParentEnt.ParentEnt.ItemList[i].name)
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
			icon:SetModel(ent.ParentEnt.ParentEnt.ItemList[i].pv)
			icon:SetLookAt( Vector(0,0,0) )
			icon:SetFOV(1.5*icon:GetEntity():GetModelRadius())

			local desc = panel:Add("DLabel")
			desc:SetPos(100,40)
			desc:SetText(ent.ParentEnt.ParentEnt.ItemList[i].desc)
			desc:SetDark(true) 
			desc:SizeToContents()

			local button = panel:Add("DButton")
			button:SetText("Buy")
			button:SetPos(540,50)

			function button:DoClick()
				RunConsoleCommand("micro_shop_buy",ent:EntIndex(),i)
			end

			function button:Think()
				local cash = ent:GetCash()
				local stocke = ent:GetNWInt(ent.StockArray[i].ent, -999)

				-- WARNING! SLOW! DOES A TRACE FOR EVERY BUTTON!
				if ent:CalculateCost(i, stocke)>cash or (ent.StockArray[i].ent and blocked) or (stocke <= 0) then
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
