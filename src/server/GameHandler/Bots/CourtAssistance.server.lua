local firebase = require(game.ServerScriptService.FirebaseService)

local database = firebase:GetFirebase("CourtInfo")

local http = game:GetService("HttpService")

game.Players.PlayerAdded:Connect(function(plr)
	local data = database:GetAsync(plr.UserId)
	if data then
		data = http:JSONDecode(data)
		local changed = false
		if data.PlayerInfo then
		if data.PlayerInfo.MoneyOwed ~= nil and data.PlayerInfo.MoneyOwed ~= 0 then
				plr:WaitForChild("PlayerStats"):WaitForChild("CashInBank").Value = plr:WaitForChild("PlayerStats"):WaitForChild("CashInBank").Value + data.PlayerInfo.MoneyOwed
				_G.PlayerData[plr.UserId].Bank = _G.PlayerData[plr.UserId].Bank + data.PlayerInfo.MoneyOwed
				data.PlayerInfo.MoneyOwed = 0
				changed = true
			end
		end
		if data.Arrests then
			for i,v in pairs(data.Arrests) do
				if v.Served == false then
					plr:WaitForChild("PlayerStats"):WaitForChild("ArrestTime").Value = plr:WaitForChild("PlayerStats"):WaitForChild("ArrestTime").Value + tonumber(v.Time)
					v.Served = true
					changed = true
				end
			end
		end
		if changed == true then
			data = http:JSONEncode(data)
			database:SetAsync(plr.userId,data)
		end
	end
end)
game.Players.PlayerRemoving:Connect(function(plr)
	database:SetAsync(plr.UserId.."/PlayerInfo/CurrentMoney",plr:WaitForChild("PlayerStats"):WaitForChild("CashInBank").Value)
end)