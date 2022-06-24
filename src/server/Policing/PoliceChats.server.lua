local db = false
Storage = game.ReplicatedStorage
Voices = Storage.Chat
math.randomseed(tick())
game.Players.PlayerAdded:connect(function(Player)
	local Team
	Player.Chatted:connect(function(msg)
		if msg:lower() == "/e rights" then
			game:GetService("Chat"):Chat(Player.Character.Head, "You are under arrest. You do not have to say anything, but it may harm your defence if you do not mention when questioned something which you later rely on in court. Anything you do say may be given in evidence.")
			wait(1)
			game:GetService("Chat"):Chat(Player.Character.Head,"Do you understand?")
		else
			for _,v in ipairs(game.Teams:GetTeams()) do
				if Player.TeamColor == v.TeamColor then Team = v end
			end
			if Storage.Chat:FindFirstChild(Team.Name) ~= nil and Storage.Chat[Team.Name] then
				Voices = Storage.Chat[Team.Name]
				for _,v in pairs(Voices:GetChildren()) do
					if msg:lower():find(v.Name:lower()) then
						local newSound = v:Clone()
						if v["3D"].Value == true then
							for j,k in pairs(Player.Character.Torso:GetChildren()) do
								if k.ClassName == "Sound" then
									k:Destroy()
								end
								wait()
							end
							newSound.Parent = Player.Character.Torso
							wait()
							newSound:Play()
							newSound.PlayOnRemove = false
							wait(newSound.TimeLength)
							newSound:Stop()
							newSound:Destroy()
						else
							for _, nv in pairs(game.Players:GetPlayers()) do
								local newRep = v:Clone()
								newRep.Parent = nv.PlayerGui
								wait()
								newRep:Destroy()
							end
							newSound:Destroy()
						end
					end
				end
			end
		end
	end)


end)



