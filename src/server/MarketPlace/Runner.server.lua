local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunnerEvents = ReplicatedStorage:WaitForChild("MarketPlace")

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

game:GetService('Players').PlayerAdded:Connect(function(player)
    if player:GetRankInGroup(3043431) >= 3 then
        local Team = game.Teams:Finds
    end
end)