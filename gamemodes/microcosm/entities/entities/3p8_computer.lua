--[[
	3p8_computer
	Uses:		multi-platform uses
	
	History:	megaman lotto code enter system like chea codes. like the console, swag everywhere.

	Memes:		chea code swag

	Todo:		
				--3p8 mobile game will provide "blueprint lookup codes" for a "3d printer"
					--display fake, "contacting authorization server" "dispatching file"
					--make a way to encode custom codes, like, a large function with params that are encrypted
]]

AddCSLuaFile()
ENT.Base = "3p8_base_ent"
ENT.ItemModel = "models/props/cs_office/computer.mdl"

GLOBAL_chea = {
	--one time use codes
	{
		name="3p8_companion_app",
		used=false,
		inf=false,		
		func = function(comp)
			
		end
	},
	{
		name="orange",
		used=false,
		inf=false,		
		func = function(comp)
			
		end
	},
	{
		name="template",
		used=false,
		inf=false,		
		func = function(comp)
			
		end
	},
	--infinite use codes
	{
		name="pepperonipizza",
		used=false,
		inf=true,
		func = function(comp)
			if SERVER then
				local ent2 =ents.Create("micro_item_secrete_hd")
							ent2:SetPos(comp:GetPos()+Vector(0,0,32))
							ent2:Spawn()
			end
		end
	},
	{
		name="rocketsocket",
		used=false,
		inf=true,
		func = function(comp)
			if SERVER then
				local ent2 =ents.Create("3p8_ammo_rocket_socket")
							ent2:SetPos(comp:GetPos()+Vector(0,0,32))
							ent2:Spawn()
			end
		end
	},
	{
		name="exodus",
		used=false,
		inf=true,
		func = function(comp)
			--give all weapons and stuff
			--print("life")
			if SERVER then
				local ent1 =ents.Create("3p8_kookospahkina_puu")
							ent1:SetPos(comp:GetPos()+Vector(0,0,32))
							ent1:Spawn()
				local ent2 =ents.Create("3p8_ammo_rocket_socket")
							ent2:SetPos(comp:GetPos()+Vector(0,0,64))
							ent2:Spawn()
				local ent3 =ents.Create("3p8_potato_ent")
							ent3:SetPos(comp:GetPos()+Vector(0,0,96))
							ent3:Spawn()
				local ent4 =ents.Create("3p8_potato_head")
							ent4:SetPos(comp:GetPos()+Vector(0,0,128))
							ent4:Spawn()
			end
		end
	}
}

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.ItemModel)
		self:SetUseType(SIMPLE_USE)		
	end
	self:PhysicsInitStandard()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	--self:GetPos()
	self.health = 75
end

function ENT:Use(ply)
	--bring up chea code entering	
	ply:SendLua("cheacode(Entity("..self:EntIndex().."))")
end

if SERVER then
	concommand.Add("3p8_code",function(ply,_,args)
		local computer = Entity(tonumber(args[1]) or 0)

		local isHere = tonumber(args[2])

		if !ply:Alive() or !isnumber(isHere) or GLOBAL_chea[isHere]==nil or !IsValid(computer) or computer:GetClass()!="3p8_computer" then return end

		if computer:GetPos():Distance(ply:GetPos())>200 then return end

		local item = GLOBAL_chea[isHere]

		if !isfunction(item.func) then return end

		--mine
		--if is there, use it, else, error
		if(isHere != 0 && GLOBAL_chea[isHere].used == false) then
			GLOBAL_chea[isHere].func(computer)
			GLOBAL_chea[isHere].used = true
			computer:EmitSound("ambient/levels/canals/headcrab_canister_ambient".. math.random(1,6) ..".wav")
		elseif(isHere != 0 && GLOBAL_chea[isHere].inf == true) then
			GLOBAL_chea[isHere].func(computer)
			computer:EmitSound("ambient/levels/canals/headcrab_canister_ambient".. math.random(1,6) ..".wav")
		else
			print("Invalid Code.")
			--make error sound
			computer:EmitSound("ambient/machines/thumper_shutdown1.wav")			
		end

	end)
else
	function cheacode(ent)
		local frame = vgui.Create("DFrame", nil, frame)
		frame:SetPos( 5, 5 )
		frame:SetSize( 300, 150 )
		frame:SetTitle( "Name window" )
		frame:SetVisible( true )
		frame:SetDraggable( false )
		frame:ShowCloseButton( true )
		frame:MakePopup()
		local code = nil
		
		local NameEntry = vgui.Create( "DTextEntry", frame )
		NameEntry:SetPos( 25, 50 )
		NameEntry:SetSize( 360, 21 )
		NameEntry:SetText( "Enter your Material Appearance Program (M.A.P.) Code" )
		NameEntry.OnEnter = function( self )
			code = self:GetValue()
			print("You entered: "..code )
			
			local isHere = 0
			--loop through array once value is enter
			for i=1,#GLOBAL_chea do
				if (GLOBAL_chea[i].name.."" == code.."") then
					isHere = i
				end
			end
			
			--call the new console command, pass in isHere
			RunConsoleCommand("3p8_code",ent:EntIndex(),isHere)
		end
	end
end

if SERVER then
	function ENT:OnRemove()
		--PRODUCE GIBS HERE
	end
end
