local MarketplaceService = game:GetService("MarketplaceService")
Events = game.ReplicatedStorage:WaitForChild("Events")
marketplaceService = game:GetService("MarketplaceService")


local wages = {
    
}




local settings = {
    payTime = 120
}



spawn(function()
	local currentTime = settings.payTime
	while true do
		local s, p = pcall(function()
		local x = wait(10)
		currentTime = currentTime - math.floor(x)
		local function getWage(plr)
			local function getAmount(Name)
				for i,v in pairs(wages) do
					if v[1] == Name then
						local wage = v[2]
						return wage
					end
				end
			end
							
		for i,v in pairs(game.Teams:GetTeams()) do
			if plr.TeamColor == v.TeamColor then
				return getAmount(v.Name)
			end
		end
	end
						
	for i,plr in pairs(game.Players:GetPlayers()) do
		if workspace:FindFirstChild(plr.Name) then
			Events.UpdateCashInfo:FireClient(plr)
		end
	end
	if currentTime <= 0 then
		for i,plr in pairs(game.Players:GetPlayers()) do
			if workspace:FindFirstChild(plr.Name) then
				local Stats = plr:WaitForChild("PlayerStats")
				local Wage = getWage(plr)
				if Wage then
					if Stats then
						if Stats:FindFirstChild("CashOnHand") then
							Stats.CashOnHand.Value = Stats.CashOnHand.Value + getWage(plr)
						end
					end
				else
					if Stats then
						if Stats:FindFirstChild("CashOnHand") then
							Stats.CashOnHand.Value = Stats.CashOnHand.Value + 8
						end
					end
				end
			end
		end
		currentTime = settings.payTime
		end
	end)
	end
end)