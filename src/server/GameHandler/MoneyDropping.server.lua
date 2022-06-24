
local Players = game:GetService('Players')
local ServerStorage = game:GetService('ServerStorage')
local Money = ServerStorage:WaitForChild('Money')

function dropNotes(player, Head, Wallet)
    for i = 1,4 do
        local note = Money:GetChildren()[math.random(#Money:GetChildren())]
        local digitPattern = '%d+'
        local noteValue = (note.Name):match(digitPattern)
        if Wallet.Value - noteValue >= 0 then
            Wallet.Value = Wallet.Value - noteValue
            local newNote = note:Clone()
            newNote.Parent = workspace
            newNote.Position = Head.Position
            game.Debris:AddItem(newNote, 70)
            newNote.Touched:connect(function(hit)
                if Players:GetPlayerFromCharacter(hit.Parent) then
                    local target = Players:GetPlayerFromCharacter(hit.Parent)
                    if target ~= player then
                        local targetStats = target:FindFirstChild('PlayerStats')
                        if target and targetStats and targetStats:FindFirstChild('CashOnHand') then
                            local targetWallet = targetStats:FindFirstChild('CashOnHand')
                            targetWallet.Value = targetWallet.Value + noteValue
                            newNote:Destroy()
                        end
                    end
                end
            end)
        end
    end
end

Players.PlayerAdded:connect(function(player)
    player.CharacterAdded:connect(function(character)
        character:WaitForChild('Humanoid').Died:connect(function()
            local Head = character:FindFirstChild('Head')
            local Stats = player:FindFirstChild('PlayerStats')
            if player and Head and Stats and Stats:FindFirstChild('CashOnHand') then
                local Wallet = Stats:FindFirstChild('CashOnHand')
                dropNotes(player, Head, Wallet)
            end
        end)
    end)
end)