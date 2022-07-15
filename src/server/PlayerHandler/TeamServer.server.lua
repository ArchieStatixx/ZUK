
while wait(10) do
	local teams = game:GetService("Teams"):GetTeams()
	for _, team in pairs(teams) do
    	local players = team:GetPlayers()
		if team.Name == "Arrested" or team.Name == "Tourists" or team.Name == "British Steel" or team.Name == "Royal Mail" then 
            
		elseif #players == 0 and team.Parent == game.Teams then
			team:Destroy() 
		end
	end
end
