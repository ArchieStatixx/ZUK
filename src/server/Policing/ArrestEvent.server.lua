local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Policing")

local ArrestEvent = Events:WaitForChild(script.Name)

local databasedirectory = game.ServerScriptService.Server.GameHandler.Bots.Firebase

local firebase = require(databasedirectory)

local database = firebase:GetFirebase("CourtInfo")



local AuthorisedTeams = {
	"Metropolitan Police Service",
	"National Crime Agency",
	"Tourist",
	"Territorial Support Group",
	"Military Police",
	"Founder",
	"SCO19", 
	"CTSFO",
	"Security Service",
	"Border Force",
	"PaDP",
	"Royalty and Specialist Protection",
	"British Architects",
	--"GHQ"
}

function CheckIfAuthorised(team)
	for i,v in pairs(AuthorisedTeams) do
		if team == v then
			return true
		end
	end
	return false
end

ArrestEvent.OnServerEvent:connect(function(plr, arrestedplayer, arresttime, reason, key)
	if key == _G.Key then
		if CheckIfAuthorised(tostring(plr.Team)) == true then
			local SSS = game:GetService("ServerScriptService")
			local Information = SSS:WaitForChild("Function Handlers"):FindFirstChild("FunctionHandlers"):FindFirstChild("Information")
			local Teams = Information:FindFirstChild("Teams")
			local Team = Teams:FindFirstChild(tostring((plr.Team)))
			if Team then
				if plr:GetRankInGroup(Team.Value) >= Team:FindFirstChild("Rank").Value then
					print(tostring((plr.Team)))
					local PlayerStats = arrestedplayer:WaitForChild("PlayerStats")
					local ArrestTime = PlayerStats:WaitForChild("ArrestTime")
					local InJail = PlayerStats:WaitForChild("InJail")
					local IsCuffed = PlayerStats:WaitForChild("IsCuffed")
					local IsGrabbed = PlayerStats:WaitForChild("IsGrabbed")
					if PlayerStats and ArrestTime then
						local date = os.date("*t");
						local PlayersData = _G.PlayerData[arrestedplayer.userId]
						if PlayersData then
							IsCuffed.Value = false
							IsGrabbed.Value = false
							PlayersData.ArrestTime = arresttime
							PlayersData.InJail = true
							wait()
							ArrestTime.Value = PlayersData.ArrestTime
							InJail.Value = PlayersData.InJail
							arrestedplayer.TeamColor = BrickColor.new("Bright violet")
							arrestedplayer:LoadCharacter()
							_G.oofofthedoofmcoof:post{username = "[Arrest] "..plr.Name.." : "..plr.UserId, content = "Arrested: ".. arrestedplayer.Name .. "\nReason:" .. reason .. "\nArrestTime: ".. arresttime}
							local ArrestDataStore = game:GetService("DataStoreService"):GetDataStore("DataForUK")
							local Arrests = ArrestDataStore:GetAsync("Arrests") or 0 
							Arrests = Arrests + 1
							ArrestDataStore:SetAsync("Arrests", Arrests)
							database:SetAsync(arrestedplayer.userId.."/Arrests/"..os.time(),'{"Time":'.. arresttime .. ',"Reason":"'.. reason..'","Arrester":"'.. plr.Name..'","Court":false,"Served":true}')
							print("SUS2")
						end
					end
				end
			end
		end
	end
end)

