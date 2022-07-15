local firebase = require(game.ServerScriptService.Server.GameHandler.Bots.Firebase)
local database firebase:GetFirebase("CourtInfo")

local http = game:GetService("HttpService")

game.Players.PlayerAdded:Connect(function(player)
	local data = database:GetAsync(player.UserId)
end)