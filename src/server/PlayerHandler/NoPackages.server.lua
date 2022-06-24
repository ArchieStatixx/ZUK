game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(c)
    for i,v in pairs(c:GetChildren()) do
        if v:IsA("CharacterMesh") then
            v:Destroy()
            print(plr.Name.. "was using a package.")
            end
         end
    end)
end)