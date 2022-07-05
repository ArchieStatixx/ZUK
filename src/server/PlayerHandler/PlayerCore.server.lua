--// Modified by InspiringNote (Polyrope) with the addition of number plates

RbxUtility = require(game:GetService("ReplicatedStorage"):
    WaitForChild("LoadLibrary"):WaitForChild("RbxUtility"))
Create = RbxUtility.Create

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local DS = game:GetService("DataStoreService"):GetDataStore("PlayerData2022") -- Cleared. (16/01/21)
local Functions = ReplicatedStorage:WaitForChild("Functions")
local GetPlayerData = Functions:WaitForChild("GetPlayerTeams")
local Service = game:GetService("MarketplaceService")

_G.PlayerData = {}

local areaCodes = {"LA", "LB", "LC", "LD", "LE", "LF", "LG", "LH", "LJ"}

local function generatePlate(player)
	local plrSeed = Random.new()
	
	local plate = areaCodes[plrSeed:NextInteger(1, #areaCodes)]	
	
	local yearPeriod = plrSeed:NextInteger(1, 3)
	
	if yearPeriod == 1 then
		plate = plate .. string.format("%0.2i", plrSeed:NextInteger(2, 21))
	else
		plate = plate .. plrSeed:NextInteger(52, 71)
	end
	
	plate = plate .. " "
	
	for i = 1, 3 do
		plate = plate .. string.char(plrSeed:NextInteger(65, 90))
	end
	
	return plate
end

function PlayerAdded(Player)
	if Player == nil then return end
	
	if Player:FindFirstChild("Stats") ~= nil then return end

	local PlayersData = DS:GetAsync(Player.userId) or {}

	PlayersData.Cash = PlayersData.Cash or 0
	PlayersData.Bank = PlayersData.Bank or 60000
	PlayersData.Plate = PlayersData.Plate or generatePlate(Player)
	
	
	PlayersData.ArrestTime = PlayersData.ArrestTime or 0
	PlayersData.InJail = PlayersData.InJail or false
	
	_G.PlayerData[Player.userId] = PlayersData
	
	PlayersData.Multiplier = PlayersData.Multiplier or 1
	local Stats = Create("Folder") {Name = "PlayerStats", Parent = Player}
	local Cash = Create("IntValue") {Name = "CashOnHand", Parent = Stats, Value = PlayersData.Cash}
	local DirtyMoney = Create("IntValue") {Name = "DirtyMoney", Parent = Stats}
	local Bank = Create("IntValue") {Name = "CashInBank", Parent = Stats, Value = PlayersData.Bank}
	local Plate = Create("StringValue") {Name = "PlateNumber", Parent = Stats, Value = PlayersData.Plate}
	local InJail = Create("BoolValue") {Name = "InJail", Parent = Stats, Value = PlayersData.InJail}
	local HasArrestWarrant = Create("BoolValue") {Name = "HasArrestWarrant", Parent = Stats}
	local Unit = Create("StringValue") {Name = "Unit", Parent = Stats}
	local IsCuffed = Create("BoolValue") {Name = "IsCuffed", Parent = Stats}
	local IsGrabbed = Create("BoolValue") {Name = "IsGrabbed", Parent = Stats}
	local GangInformation = Create("Folder") {Name = "GangInformation", Parent = Player}
	local ProfessionVal = Create("StringValue") {Name = "Profession", Parent = Stats, Value = "Civilian"}
	local AffiliatedGang = Create("StringValue") {Name = "AffiliatedGang", Parent = GangInformation}
	local IsOwnerOfGang = Create("BoolValue") {Name = "IsOwnerOfGang", Parent = GangInformation}
	local GangMemberCount = Create("IntValue") {Name = "GangMemberCount", Parent = GangInformation}
	local GangName = Create("StringValue") {Name = "GangName", Parent = GangInformation}
	local ArrestTime = Create("IntValue") {Name = "ArrestTime", Parent = Stats, Value = PlayersData.ArrestTime}
				
	local Gamepasses = game.ReplicatedStorage.Gamepasses
	for _,v in pairs(Gamepasses:GetChildren()) do
		local GamepassID = v:FindFirstChild("GamepassID")
		if Service:UserOwnsGamePassAsync(Player.userId, GamepassID.Value) then
			if Player.TeamColor ~= BrickColor.new("Medium stone grey") and Player.TeamColor ~= BrickColor.new("Bright yellow") and Player.TeamColor ~= BrickColor.new("Magenta") then return end
	end
	
	wait(1)
			
	Player.CharacterAdded:connect(function(Character)
		if Character then
			local Gamepasses = game.ReplicatedStorage.Gamepasses
			for _,v in pairs(Gamepasses:GetChildren()) do
				local GamepassID = v:FindFirstChild("GamepassID")
				if Service:UserOwnsGamePassAsync(Player.userId, GamepassID.Value) then
					if Player.TeamColor ~= BrickColor.new("Medium stone grey") and Player.TeamColor ~= BrickColor.new("Bright yellow") and Player.TeamColor ~= BrickColor.new("Magenta") then return end
			end
			IsCuffed.Value = false
			IsGrabbed.Value = false
			Player.PlayerGui.Core.Teams.Visible = true
			if game.Workspace.SpawnedCars:FindFirstChild(Player.Name) then
				local Car = game.Workspace.SpawnedCars:FindFirstChild(Player.Name)
				Car:Destroy()
			end
		end
	end
	end)
	end

	Cash.Changed:connect(function()

		_G.PlayerData[Player.userId].Cash = Cash.Value
	end)
	
	InJail.Changed:connect(function()
		_G.PlayerData[Player.userId].InJail = InJail.Value
	end)
	
	ArrestTime.Changed:connect(function()
		_G.PlayerData[Player.userId].ArrestTime = ArrestTime.Value
	end)
	
	Bank.Changed:connect(function()

		_G.PlayerData[Player.userId].Bank = Bank.Value
	end)	
end

function PermSave(Player)
	if Player then
		local PlayersData = _G.PlayerData[Player.userId]
		if PlayersData then
			DS:SetAsync(Player.userId, PlayersData)
		end
	end
end

game.Players.PlayerAdded:connect(PlayerAdded)
for _, Player in pairs(game.Players:GetChildren()) do
	PlayerAdded(Player)
end


game.Players.PlayerRemoving:connect(function(Player)
	if Player then
		PermSave(Player)
		_G.PlayerData[Player.userId] = nil
		if game.Workspace.SpawnedCars:FindFirstChild(Player.Name) then
			local Car = game.Workspace.SpawnedCars:FindFirstChild(Player.Name)
			Car:Destroy()
		end
	end
end)

game.OnClose = function()
	for i, v in pairs(_G.PlayerData) do
		DS:SetAsync(i, v)
	end
end