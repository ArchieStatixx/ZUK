local ss = game:GetService("ServerStorage");
local rs = game:GetService("ReplicatedStorage");
local http = game:GetService("HttpService");
local gEvents = rs:WaitForChild("GangEvents");
local gList = ss:WaitForChild("GangList");
local gProfiles = ss:WaitForChild("GangPlayerProfile");

-- CONFIG (calagoz)
local Gang_Limit = 5

-- Communication
-- THIS SCRIPT IS BAD

local getPlayerData = gEvents:WaitForChild("GetPlayerData");
local joinGang = gEvents:WaitForChild("JoinGang");

local data = {
	['Tambov Bratva'] = {
		name = 'Tambov Bratva',
		id = 3158039,
		tools = {game.ServerStorage.Tools.MP5,game.ServerStorage.LegalKnife,game.ServerStorage.Balaclava,game.ServerStorage.MK119S,game.ServerStorage.M4A1},
		ranktools = false,
		owner = {
			username = 'DmitroYashin',
		},
	},


	},

	['The Extremist Clowns'] = {
		name = 'The Extremist Clowns',
		id = 12733914,
		tools = {game.ServerStorage.Tools.MP5,game.ServerStorage.Tools.Machete},
		ranktools = false,
		owner = {
			username = 'MatthiasGriffin'
		}
	},

	['Group 223'] = {
		name = 'Group 223',
		id = 9761714,
		tools = {game.ServerStorage.Tools.MP5},
		ranktools = false,
		owner = {
			username = 'Magpie'
		}
	},

	['Irish Republican Army'] = {
		name = 'Irish Republican Army',
		id = 12178433,
		tools = false,
		ranktools = false,
		owner = {
			username = 'Clanker213'
		},
	},
	['Juggemaffian'] = {
		name = 'Juggemaffian',
		id = 12918075,
		tools = {game.ServerStorage.Tools.MP5A4,game.ServerStorage.Tools.Machete,game.ServerStorage.Tools.Balaclava},
		ranktools = {{tool = game.ServerStorage.MP5A3SD,id = 250}},
		owner = {
			username = 'TheStealthyGoblin',
		},
	},
	['Special Intelligence and Operations Unit'] = {
		name = 'Special Intelligence and Operations Unit',
		id = 12916555,
		tools = false,
		ranktools = {{tool = game.ServerStorage.MP5, id = 1}},
		owner = {
			username = 'JustGamesReborn'
		}
	},
	['TF TASK FORCE 55'] = {
		name = "TF TASK FORCE 55",
		id = 13210307,
		tools  = false,
		ranktools = {{tool = game.ServerStorage["Desert Eagle"], id = 1}},
		owner = {
			username = 'MODIFIED'
		}
	},
	['The Saints'] = {
		name = 'The Saints',
		id = 9083099,
		tools = false, 
		ranktools = {{tool = game.ServerStorage.MP5, id = 1}},
		owner = {
			username = "choppysmoky"
		}
	},
	['Rogue Mafia']  = {
		name = 'Rogue Mafia',
		id = 5524137,
		tools = false, 
		ranktools = {{tool = game.ServerStorage.MP5, id = 1}},
		owner = {
		 username = "Rogue Mafia",
		}
	},
	['JamesUK Testing Misc'] = {
		name = 'JamesUK Test',
		id = 5465088,
		tools = false, 
		ranktools = {{tool = game.ServerStorage.MP5, id = 1}},
		owner = {
			username = "JamesUK",
		},
	},
	['Lemenos Crime Family'] = {
		name = 'Lemenos Crime Family',
		id = 13224815,
		tools = false,
		ranktools = false,
		owner = {
			username = "JamesLemnos"
		}
	},
	['VAMP'] = {
		name = 'VAMP',
		id = 12507495,
		tools = {game.ServerStorage.MP5},
		ranktools = false,
		owner = {
			username = "Iv6_l"
		}
	},
	['MOD CORPORATION'] = {
		name = 'MOD CORPORATION',
		id = 9160679,
		ranktools = {{tool = game.ServerStorage.MP5A4, id = 1}},
		tools = false, 
		owner = {
			username = "modoux"
		}
	},
	['La Cosa Nostra'] = {
		name = 'La Cosa Nostra',
		id = 14392880,
	ranktools = {{tool = game.ServerStorage.MP5, id = 1}},
	tools = {game.ServerStorage.Balaclava},
	owner = {
			username = "Rush_S"
		},
	},
	['DWG KIA'] = {
		name = 'DWG KIA',
		id = 12756967,
		ranktools = false,
		tools = {game.ServerStorage.Balaclava,game.ServerStorage.Molotov, game.ServerStorage.Knife, game.ServerStorage.Bandage, game.ServerStorage.MP5 },
		owner = {
			username = "Xajitur"
		},
}
}

--Sorted




local gpObject = {};

if (data) then
	for i,v in pairs(data) do
		if (v["owner"] ~= nil and v.id ~= 3043431) then
			local gFolder = Instance.new("Folder");
			gFolder.Name = v.id;
			gFolder.Parent = gList;
			local gName = Instance.new("StringValue");
			gName.Name = "GroupName";
			gName.Value = v.name;
			gName.Parent = gFolder;
			local gOnline = Instance.new("IntValue");
			gOnline.Name = "Online";
			gOnline.Value = 0;
			gOnline.Parent = gFolder;
			local tools = Instance.new("Folder")
			tools.Name = "Tools"
			tools.Parent = gFolder
			if v.tools ~= false then
				for i,v in pairs(v.tools) do
					v:Clone().Parent = tools
				end
			end
			if v.ranktools  ~= false then
				for i,v in pairs(v.ranktools) do
					local tool = v.tool:Clone()
					tool.Parent = tools
					local RankRequirement = Instance.new("IntValue")
					RankRequirement.Name = "Rank"
					RankRequirement.Parent = tool
					RankRequirement.Value = v.id				
				end
			end
			local gOwner = Instance.new("StringValue");
			gOwner.Name = "Owner";
			gOwner.Value = v.owner.username;
			gOwner.Parent = gFolder;
			local gPlayers = Instance.new("Folder");
			gPlayers.Name = "Players";
			gPlayers.Parent = gFolder;
		end
	end
else
	script.Disabled = true;
end

game.Players.PlayerAdded:Connect(function(player)
	local profile = Instance.new("Folder");
	profile.Name = player.Name;
	profile.Parent = gProfiles;
	local selectedGang = Instance.new("IntValue");
	selectedGang.Name = "SelectedGang";
	selectedGang.Value = 0;
	selectedGang.Parent = profile;
	local profileGangs = Instance.new("Folder");
	profileGangs.Name = "Gangs";
	profileGangs.Parent = profile;
	local plrgang = false
	for i,v in pairs(gList:GetChildren()) do
		local gid = v.Name;
		plrgang = v.Name
		if (player:GetRankInGroup(gid) > 0) then
			local gang = Instance.new("Folder");
			gang.Name = gid;
			local role = Instance.new("StringValue");
			role.Name = "Role";
			role.Value = player:GetRoleInGroup(gid);
			gang.Parent = profileGangs;
			role.Parent = gang;
		end
	end
end);


function LeaveGang(player) 
	if (gpObject[player] ~= nil) then
		gpObject[player]:Destroy()
		if (gProfiles[player.Name] ~= nil) then
			local profile = gProfiles[player.Name];
			print(profile)
			local gangTables = {};
			for i,v in pairs(profile["Gangs"]:GetChildren()) do
				if v.Name then 
					if not (game.ServerStorage.GangList[v.Name].Online.Value <= 0) then
						game.ServerStorage.GangList[v.Name].Online.Value =  game.ServerStorage.GangList[v.Name].Online.Value - 1
						if gProfiles[player.Name] then
							gProfiles[player.Name] = nil;	
						end
					end	
				end
			end
		end
	end
end

game.Players.PlayerRemoving:Connect(function(player)
	LeaveGang(player)
end)

for x,y in pairs(game.Players:GetChildren()) do
	if (gProfiles:FindFirstChild(y.Name) == nil) then
		local profile = Instance.new("Folder");
		profile.Name = y.Name;
		profile.Parent = gProfiles;
		local selectedGang = Instance.new("IntValue");
		selectedGang.Name = "SelectedGang";
		selectedGang.Value = 0;
		selectedGang.Parent = profile;
		local profileGangs = Instance.new("Folder");
		profileGangs.Name = "Gangs";
		profileGangs.Parent = profile;
		for i,v in pairs(gList:GetChildren()) do
			local gid = v.Name;
			if (y:GetRankInGroup(gid) > 0) then
				local gang = Instance.new("Folder");
				gang.Name = gid;
				local role = Instance.new("StringValue");
				role.Name = "Role";
				role.Value = y:GetRoleInGroup(gid);
				gang.Parent = profileGangs;
				role.Parent = gang;
			end
		end
	end
end

-- Events & Functions

getPlayerData.OnServerInvoke = function(player)
	if (gProfiles[player.Name] ~= nil) then
		local profile = gProfiles[player.Name];
		local gangTables = {};
		for i,v in pairs(profile["Gangs"]:GetChildren()) do
			local gangTable = {
				["Role"]=v.Role.Value,
				["GangName"]=gList:FindFirstChild(v.Name).GroupName.Value,
				["ID"]=v.Name,
				["Online"]=gList:FindFirstChild(v.Name).Online.Value,
				["Owner"]=gList:FindFirstChild(v.Name).Owner.Value;
			};
			gangTables[v.Name] = gangTable;
		end
		return gangTables;
	else
		return false;
	end
end

game.Players.PlayerRemoving:Connect(function(player)
	LeaveGang(player)--
end)

for x,y in pairs(game.Players:GetChildren()) do
	if (gProfiles:FindFirstChild(y.Name) == nil) then
		local profile = Instance.new("Folder");
		profile.Name = y.Name;
		profile.Parent = gProfiles;
		local selectedGang = Instance.new("IntValue");
		selectedGang.Name = "SelectedGang";
		selectedGang.Value = 0;
		selectedGang.Parent = profile;
		local profileGangs = Instance.new("Folder");
		profileGangs.Name = "Gangs";
		profileGangs.Parent = profile;
		for i,v in pairs(gList:GetChildren()) do
			local gid = v.Name;
			if (y:GetRankInGroup(gid) > 0) then
				local gang = Instance.new("Folder");
				gang.Name = gid;
				local role = Instance.new("StringValue");
				role.Name = "Role";
				role.Value = y:GetRoleInGroup(gid);
				gang.Parent = profileGangs;
				role.Parent = gang;
			end
		end
	end
end

-- Events & Functions ssss

getPlayerData.OnServerInvoke = function(player)
	if (gProfiles[player.Name] ~= nil) then
		local profile = gProfiles[player.Name];
		local gangTables = {};
		for i,v in pairs(profile["Gangs"]:GetChildren()) do
			local gangTable = {
				["Role"]=v.Role.Value,
				["GangName"]=gList:FindFirstChild(v.Name).GroupName.Value,
				["ID"]=v.Name,
				["Online"]=gList:FindFirstChild(v.Name).Online.Value,
				["Owner"]=gList:FindFirstChild(v.Name).Owner.Value;
			};
			gangTables[v.Name] = gangTable;
		end
		return gangTables;
	else
		return false;
	end
end

joinGang.OnServerInvoke = function(player, gang, toggle)
	if (toggle == false) then
		local profile = gProfiles:WaitForChild(player.Name);
		profile:WaitForChild("SelectedGang").Value = 0;
		player:WaitForChild("Backpack"):ClearAllChildren()
		player:WaitForChild("StarterGear"):ClearAllChildren()
		local gang = gList[gang];
		local gPlayers = gang:WaitForChild("Players");
		if (gang and gPlayers:FindFirstChild(player.Name) ~= nil) then
			if not (gang.Online.Value <= 0) then
				gang.Online.Value = gang.Online.Value-1;
			end

			gpObject[player] = nil;
			gPlayers:FindFirstChild(player.Name):Destroy();
		end
	--aveGang(player)
	elseif (toggle == true) then
		local profile = gProfiles:WaitForChild(player.Name);
		profile:WaitForChild("SelectedGang").Value = gang;
		local gang = gList[gang];
		local gPlayers = gang.Players;
		if gang.Online.Value >= Gang_Limit then return end
		if (gang and gPlayers:FindFirstChild(player.Name) == nil) then
			gang.Online.Value = gang.Online.Value+1;
			for i,v in pairs(gang.Tools:GetChildren()) do
				if v:FindFirstChild("Rank") then
					print(gang.Name)
					if player:GetRankInGroup(tonumber(gang.Name)) >= v.Rank.Value then
						v:Clone().Parent = player:WaitForChild("StarterGear")
						v:Clone().Parent = player:WaitForChild("Backpack")
					end
				else
					v:Clone().Parent = player:WaitForChild("StarterGear")
					v:Clone().Parent = player:WaitForChild("Backpack")
				end
			end
			local gPlayer = Instance.new("ObjectValue");
			gPlayer.Name = player.Name;
			gPlayer.Parent = gPlayers;
			gpObject[player] = gPlayer;
			print(gpObject[player])
			game.ReplicatedStorage.GangEvents.GetPlayerData:InvokeClient(player)
		end
	end
end