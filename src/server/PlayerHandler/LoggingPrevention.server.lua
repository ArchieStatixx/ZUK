local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("GameHandler")
local ChangeTeamEvent = Events:WaitForChild("ChangeTeamEvent")

local LoggerServerBanList = {}

local whitelist = require(script.Whitelist)

function ServerBan(Logger)
	if not table.find(whitelist,Logger.UserId) then
	if Logger.UserId then
	table.insert(LoggerServerBanList,Logger.UserId)
	end
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	if table.find(LoggerServerBanList,plr.UserId) then
		plr:kick("Automated Server Ban [Logging]")
	end
end)


game.Players.PlayerRemoving:Connect(function(plr)
	if plr:FindFirstChild("PlayerStats") then
		if plr.PlayerStats.IsCuffed.Value == true and plr.PlayerStats.IsGrabbed.Value == true then
			local Char = plr.Character
			
			if Char then
				local Humanoid = Char:WaitForChild("Humanoid")
				
				if Humanoid.Health <= 0 then
					return
				end
			end
			
			ServerBan(plr)
		end
	end
end)

game.Players.PlayerAdded:connect(function(Player)
	if Player:GetRankInGroup(8988151) >= 2 or Player.Name == "zeus" or Player.Name == "ArchieStatixx" then
        Player.Chatted:connect(function(msg)
		local Arguments = {}

for Argument in string.gmatch(msg,"[^%s]+") do
    table.insert(Arguments,Argument)
end
		if msg:sub(1,7):lower() == '!unban ' then
		    local playermentioned = tonumber(Arguments[2]) --be sure to use the ID of the player
			
			local id = table.find(LoggerServerBanList,playermentioned)
			if id then
			table.remove(LoggerServerBanList,id)
			end
		
		end
end)
end
end)