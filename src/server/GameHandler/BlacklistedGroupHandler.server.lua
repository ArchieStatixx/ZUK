local bannedGroups = {12426299,13562606}

local GroupService = game:GetService("GroupService")

game:GetService("Players").PlayerAdded:Connect(function(player)
	local playerIsInGroups = GroupService:GetGroupsAsync(player.UserId)
	for _,currentGroup in pairs(playerIsInGroups) do
		for i,currentBannedGroup in pairs(bannedGroups) do
			if currentGroup.Id == currentBannedGroup then
				player:Kick("Containment protocol in place. Please leave the group "..currentGroup.Name.." to join this game.")
                player:Kick("ZUK")
			end
		end
	end
end)