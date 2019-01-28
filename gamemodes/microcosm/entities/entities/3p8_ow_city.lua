--[[
	3p8_ow_city
	Uses:		a generalization of the overworld representation of a city

	Todo:		use the building skybox models?
				make each villager add two to the population?
					require 2 pop before the town can trade?
				gonna need to edit the shop so that
					the money displayed is not it's own but the player's
				
				money box material
				models/props_buildings/project_building01

				shrink it
				models/props_buildings/building_002a.mdl

				row of houses, shrink it
				models/props_buildings/row_church_fullscale.mdl

				urban row, shrink
				models/props_buildings/row_res_2_fullscale.mdl

				corner shrink
				models/props_buildings/row_corner_1_fullscale.mdl

				corner shrink 2
				models/props_buildings/row_res_1_fullscale.mdl

				water tower shrink
				models/props_buildings/watertower_001a.mdl
				models/props_buildings/watertower_001c.mdl
				models/props_buildings/watertower_002a.mdl

				Ghetto models:
				20x30:
				models/props_wasteland/medbridge_base01.mdl

				6x20:
				models/props_wasteland/horizontalcoolingtank04.mdl

				8x8:
				models/props_c17/fountain_01.mdl
				models/props_combine/CombineThumper001a.mdl

				4x5:
				models/props_combine/CombineThumper002.mdl

				4x4:
				models/props_wasteland/coolingtank02.mdl
				models/props_wasteland/cranemagnet01a.mdl
				models/props_wasteland/laundry_washer001a.mdl
				models/props_c17/gravestone_statue001a.mdl

				3x5:
				models/props_wasteland/laundry_washer003.mdl

				3x3:
				models/props_trainstation/trainstation_column001.mdl
				models/props_wasteland/buoy01.mdl
				models/props_wasteland/gaspump001a.mdl
				models/props_c17/gravestone_cross001b.mdl

				2x6:
				models/props_combine/breendesk.mdl

				2x4:
				models/props_interiors/Furniture_Vanity01a.mdl

				2x3:
				models/props_wasteland/kitchen_fridge001a.mdl
				models/props_wasteland/laundry_dryer002.mdl
				models/props_combine/breenchair.mdl
				models/props_c17/furnitureStove001a.mdl
				models/props_c17/FurnitureSink001a.mdl
				models/props_c17/FurnitureDresser001a.mdl
				models/props_c17/FurnitureDrawer001a.mdl
				
				2x2:
				models/props_interiors/VendingMachineSoda01a.mdl
				models/props_junk/TrashBin01a.mdl
				models/props_trainstation/trainstation_post001.mdl
				models/props_wasteland/kitchen_stove002a.mdl
				models/props_wasteland/medbridge_post01.mdl
				models/props_interiors/Furniture_Lamp01a.mdl
				models/props_c17/oildrum001.mdl
				models/props_c17/FurnitureWashingmachine001a.mdl
				models/props_c17/canister_propane01a.mdl
				models/props_borealis/bluebarrel001.mdl
				models/props_c17/cashregister01a.mdl
				models/props_lab/reciever_cart.mdl
				models/props_c17/TrapPropeller_Engine.mdl

				1x3:
				models/props_borealis/mooring_cleat01.mdl
				models/props_c17/playgroundTick-tack-toe_post01.mdl

				1x2:
				models/props_lab/filecabinet02.mdl
				models/props_c17/pulleywheels_large01.mdl
				models/props_c17/SuitCase001a.mdl
				models/props_c17/SuitCase_Passenger_Physics.mdl

				1x1:
				models/props_junk/metal_paintcan001a.mdl
				models/props_junk/plasticbucket001a.mdl
				models/props_interiors/pot01a.mdl
				models/props_junk/TrafficCone001a.mdl
				models/props_junk/propane_tank001a.mdl
				models/props_combine/breenglobe.mdl
				models/props_c17/pulleywheels_small01.mdl
				models/props_c17/clock01.mdl
				models/props_combine/breenclock.mdl
				models/props_junk/garbage_bag001a.mdl
				models/props_junk/garbage_glassbottle003a.mdl
				models/props_junk/Shovel01a.mdl
				models/props_junk/terracotta01.mdl
				models/props_lab/harddrive02.mdl
				models/props_lab/jar01a.mdl
				models/props_lab/reciever01b.mdl
				models/props_junk/garbage_milkcarton001a.mdl
				models/props_junk/CinderBlock01a.mdl
				models/props_c17/tv_monitor01.mdl

				tiny:
				models/props_junk/PopCan01a.mdl
				models/props_junk/garbage_metalcan001a.mdl
				models/props_junk/garbage_metalcan002a.mdl
				models/props_junk/garbage_coffeemug001a.mdl


				Polez:
				models/props_c17/utilitypole01a.mdl
				models/props_c17/utilitypole01b.mdl
				models/props_c17/utilitypole01d.mdl
				models/props_c17/utilitypole02b.mdl
				models/props_c17/utilitypole03a.mdl

				p2x2:
				models/props_c17/chair_office01a.mdl

				p1x1:
				models/props_c17/canister02a.mdl
				models/props_trainstation/payphone001a.mdl
				models/props_junk/garbage_plasticbottle003a.mdl


				anthro:
				4x4:
				models/props_c17/gravestone_statue001a.mdl
				models/props_c17/statue_horse.mdl

				2x2:
				models/props_combine/breenbust.mdl
				models/props_c17/FurnitureToilet001a.mdl

				1x2:
				models/props_lab/bewaredog.mdl

				1x1:
				models/props_c17/doll01.mdl
				models/props_junk/Shoe001a.mdl
				models/props_lab/desklamp01.mdl

				tiny:
				models/Gibs/HGIBS.mdl
				models/props_lab/huladoll.mdl


				Trash:
				models/props_junk/garbage128_composite001a.mdl
				models/props_junk/garbage128_composite001b.mdl
				models/props_junk/garbage128_composite001c.mdl
				models/props_junk/garbage128_composite001d.mdl
				models/props_junk/garbage256_composite001a.mdl
				models/props_junk/garbage256_composite001b.mdl



					
]]

AddCSLuaFile()

ENT.Base = "3p8_base_ent"
ENT.CityName = "Paradise Oasis" --angel oasis?
ENT.Model = nil
ENT.ParentEnt = nil
ENT.StockArray = nil
ENT.StartingMoney = 1000
ENT.StartingPeople = 5
ENT.ShopPos = nil --Vector(-268, 2730, 48)
ENT.ShopEnt = nil
ENT.TelePos = nil
ENT.CityNum = nil

function ENT:Initialize()
	--self:SetModelScale(1/32, 0) --cactus is small enough as it is

	--print("City: ".. tostring(self.ParentEnt))
	self.ParentEnt = self:GetNWEntity("ParentEnt", "error")
	--print("City after: ".. tostring(self.ParentEnt))
	--above code only sort of works...

	if SERVER then
		self:SetModel(self.Model)

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:GetPhysicsObject():EnableMotion(false)

		--make money, people, all that into network variables.
		self:SetNWInt("money", self.StartingMoney)
		self:SetNWInt("people", self.StartingPeople)

		--have it create the shop
		if self.ShopPos != nil then
			oasisShop = ents.Create("3p8_shop")
			if ( !IsValid( oasisShop ) ) then return end
			oasisShop.StockArray = self.StockArray
			oasisShop:SetNWEntity("ParentEnt", self)
			oasisShop.ParentEnt = oasisShop:GetNWEntity("ParentEnt", "error")
			oasisShop:SetPos(self.ShopPos)
			--the shop will have to go parentEnt.parentEnt.ItemList[i] for each item it has in stock
				--deeper than Atlantis
			oasisShop:Spawn()
		end

		self.ShopEnt = oasisShop

		if self.TelePos != nil then
			genji = ents.Create("3p8_teleporter")
			genji:SetPos(self.TelePos)
			genji.CityNumber = self.CityNum
			genji:Spawn()
		end
	end

	--create a villager to get the ball rolling?
		--from where to where?
end

--override the original
function ENT:OnTakeDamage(damageto) end
