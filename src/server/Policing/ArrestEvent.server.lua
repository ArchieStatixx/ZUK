local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PoliceEvents = ReplicatedStorage:WaitForChild("PoliceEvents")

local ArrestEvent = PoliceEvents:WaitForChild(script.Name)

local databaseDirectory = game.ServerScriptService.Server.GameHandler.Bots.Firebase

local database = Firebase:GetFirebase("CourtInfo")


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
}

function CheckIfAuthorised(team)
        for i,v in pairs(AuthorisedTeams) do
            if team == v then
                return true
            end
        end
        return false 
    end
