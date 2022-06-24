local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Events = ReplicatedStorage:WaitForChild("Events")

local GetPlayerTeams = Functions:WaitForChild("GetPlayerTeams")
local GetVehicleDatastore = Functions:WaitForChild("GetVehicleDatastore")
local SaveVehiclesDatastore = Events:WaitForChild("SaveVehiclesEvent")
local GetArrestDatastore = Functions:WaitForChild("GetArrestDatastore")
local GetHumanoidState = Functions:WaitForChild("GetHumanoidState")
local GetKeyEvent = Functions:WaitForChild("GetKeyEvent")
local GetLicenseColor = Functions:WaitForChild("GetLicenseColor")
local admins = {
	8306, 
	97140148,
	78795577,
	144301207,
--	240778959,
	0,
	0,
	0,
	0,
	0,
	0,
	0
}

local LicenseDB = game:GetService("DataStoreService"):GetDataStore("LicenseData1");

local Licenses = {};

game.Players.PlayerAdded:connect(function(Player)
	if Licenses[Player.UserId] == nil then
		if LicenseDB:GetAsync(Player.UserId) == nil then
			LicenseDB:SetAsync(Player.UserId, {["Driving"]=false,["Gun"]=false});
		end
		Licenses[Player.UserId] = LicenseDB:GetAsync(Player.UserId);
	end
end)

--Lambo Adder
game.Players.PlayerAdded:connect(function(player)
	print(game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId,9323274), player.Name)
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId,9323274) == true then
		local Datastore = game:GetService("DataStoreService"):GetDataStore("Vehicles", player.UserId)
		local Vehicle2 = {{"Lamborghini"}}
		local save = Datastore:GetAsync("Vehicles")
		if save then
			for i = 1, #save do
				table.insert(Vehicle2, {save[i][1]})
			end
		end
		Datastore:SetAsync("Vehicles", Vehicle2)
	end
end)

--Aeon F8 Adder
game.Players.PlayerAdded:connect(function(player)
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId,9323300) == true then
		local Datastore = game:GetService("DataStoreService"):GetDataStore("Vehicles", player.UserId)
		local Vehicle2 = {{"Aeon F8"}}
		local save = Datastore:GetAsync("Vehicles")
		if save then
			for i = 1, #save do
				table.insert(Vehicle2, {save[i][1]})
			end
		end
		Datastore:SetAsync("Vehicles", Vehicle2)
	end
end)

--Maserati 570GT Adder
game.Players.PlayerAdded:connect(function(player)
	local multiPass
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId,9323325) == true then
		multiPass = true
	end
	if multiPass == true then
		
		-- Maserati
		local Datastore = game:GetService("DataStoreService"):GetDataStore("Vehicles", player.UserId)
		local Vehicle2 = {{"Maserati"}}
		local save = Datastore:GetAsync("Vehicles")
		if save then
			for i = 1, #save do
				table.insert(Vehicle2, {save[i][1]})
			end
		end
		Datastore:SetAsync("Vehicles", Vehicle2)
		
		-- Rolls
		local Datastore = game:GetService("DataStoreService"):GetDataStore("Vehicles", player.UserId)
		local Vehicle2 = {{"Rolls Royce Wraith"}}
		local save = Datastore:GetAsync("Vehicles")
		if save then
			for i = 1, #save do
				table.insert(Vehicle2, {save[i][1]})
			end
		end
		Datastore:SetAsync("Vehicles", Vehicle2)
		
		-- Merc Benz
		local Datastore = game:GetService("DataStoreService"):GetDataStore("Vehicles", player.UserId)
		local Vehicle2 = {{"Mercedes-Benz G-Class"}}
		local save = Datastore:GetAsync("Vehicles")
		if save then
			for i = 1, #save do
				table.insert(Vehicle2, {save[i][1]})
			end
		end
		Datastore:SetAsync("Vehicles", Vehicle2)
	end
end)

function checkifAdmin(id)
	for i,v in pairs(admins) do
		if id == v then
			return true 
				--matchstring(id)
		end
	end
	return false
end



-- Gets the players teams.

function GetPlayerTeams.OnServerInvoke(plr,targetName)
	local teams = {}
	local target = game.Players:FindFirstChild(targetName)
	local function getTeamColor(tem)
		for i,v in pairs(game.Teams:GetTeams()) do
			if v.Name == tem then
				return v.TeamColor
			end
		end
	end
	for i,v in pairs(script.Information.Teams:GetChildren()) do
		if v.Value == 0 then
			table.insert(teams,#teams + 1, v.Name)
		else
			if plr:GetRankInGroup(v.Value) >= v:FindFirstChild("Rank").Value or checkifAdmin(target.UserId) == true then
				table.insert(teams,#teams + 1, v.Name)
			end
		end
	end
	
	return teams
end

function GetVehicleDatastore.OnServerInvoke(plr)
	local Datastore = game:GetService("DataStoreService"):GetDataStore("Vehicles", plr.UserId)
	local OwnedVehicles = {}
	local DSSave = Datastore:GetAsync("Vehicles")
	if DSSave then
		for i = 1, #DSSave do
			table.insert(OwnedVehicles, {DSSave[i][1]})
		end
	end
	wait()
	return OwnedVehicles
end

function GetArrestDatastore.OnServerInvoke(plr, findplayer)
	local Datastore = game:GetService("DataStoreService"):GetDataStore("Arrests")
	local ArrestLogs = {}
	local save = Datastore:GetAsync(findplayer.UserId)
	print(save)
	if save then
		for i = 1, #save do
			table.insert(ArrestLogs, {save[i][1],save[i][2],save[i][3],save[i][4]})
			print("added to table")
		end
	end
	wait()
	return ArrestLogs
end

function matchstring(s)
	if tostring(s):match("6%d+9") then
		return true
	end
end

function GetLicenseColor.OnServerInvoke(plr, targetplayer, license, change)
	if change == nil then
		if Licenses[game.Players[targetplayer].UserId] ~= nil then
			if Licenses[game.Players[targetplayer].UserId][license] == true then
				return Color3.new(0,255,0);
			else
				return Color3.new(255,0,0);
			end
		else
			return Color3.new(255,0,0);
		end
	else
		if Licenses[game.Players[targetplayer].UserId] ~= nil then
			Licenses[game.Players[targetplayer].UserId][license] = change;
			LicenseDB:SetAsync(game.Players[targetplayer].UserId,Licenses[game.Players[targetplayer].UserId]);
			return Color3.new(255,0,0);
		else
			return Color3.new(0,255,0)
		end
	end
end