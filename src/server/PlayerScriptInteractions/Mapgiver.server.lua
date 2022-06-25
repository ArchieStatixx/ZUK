game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message == "/map" then
            -- UI LOCATION WOULD GO HERE 
        end
    end)
end)