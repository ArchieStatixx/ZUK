while wait(10) do
	local teams = game:GetService("Teams"):GetTeams()
	for _,team in pairs(teams) do
		local players = teams:GetPlayers()
		if team.Name == "Arrested" or team.Name == "Tourist" or team.Name == "British Citizen" then
			print("Cannot remove these teams")
		elseif #players == 0 and team.Parent == game.Teams then
			team:Destroy()
		end
	end
end