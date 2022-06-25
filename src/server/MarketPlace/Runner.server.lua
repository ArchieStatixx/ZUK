local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("MarketPlace")
local CollectionService = game:GetService("CollectionService")

game:GetService('Players').PlayerAdded:Connect(function(Player)
	if Player:GetRankInGroup(3043431) >= 3 then
		local Team = game.Teams:FindFirstChild("Citizens") or ReplicatedStorage:WaitForChild("TTeams"):FindFirstChild("Citizens")
		local SSS = game:GetService("ServerScriptService")
		local Information = SSS:WaitForChild("Function Handlers"):FindFirstChild("FunctionHandlers"):FindFirstChild("Information")
		local Teams = Information:FindFirstChild("Teams")
		local FolderTeam = Teams:FindFirstChild("Citizens")
		if FolderTeam then
			if game.Teams:FindFirstChild("Citizens") then --It there
				if Player.Character and Player.Character:FindFirstChild("Humanoid") then
					Player.Team = game.Teams:WaitForChild("Citizens")
					wait()
					Player:LoadCharacter()
				end
			else
				local t = game.ReplicatedStorage.TTeams:FindFirstChild("Citizens"):clone()
				t.Name = "Citizens"
				t.Parent = game.Teams
				if Player.Character:FindFirstChild("Humanoid") then
					Player.Team = game.Teams:WaitForChild("Citizens")
					wait()
					Player:LoadCharacter()
				end
			end
		end
	end
end)