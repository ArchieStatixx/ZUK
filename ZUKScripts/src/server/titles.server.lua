local Rank = script:WaitForChild('Rank')
local http = game:GetService("HttpService");

local url = "https://api.trello.com/1/boards/SF1OFaCb/lists?cards=open&card_fields=name,desc&filter=open&fields=name&key=0b3589ed7d4dc5b8f992b2e9372d8c0a&token=fae8be7d1d32195ce6eba3ccd64693697054e22b8accb62018bb9283befceaee";
local url2 = "https://api.trello.com/1/boards/SF1OFaCb/lists?cards=open&card_fields=name,desc&filter=open&fields=name&key=0b3589ed7d4dc5b8f992b2e9372d8c0a&token=fae8be7d1d32195ce6eba3ccd64693697054e22b8accb62018bb9283befceaee"

function returnGroup(Player)
	for _,v in pairs(game.ServerScriptService["Function Handlers"].FunctionHandlers.Information.Teams:GetChildren()) do
		if tostring(Player.Team) == v.Name then
			if Player:IsInGroup(v.Value) then
				return v.Value
			else
				return "0"
			end
		end
	end
end

function GetTeamFromColor(TeamColor)
	for i,v in pairs(game:GetService('Teams'):GetChildren()) do
		if v.TeamColor == TeamColor then
			return v
		end
	end
	return false
end

local cache;

function replaceVars(player, input)
	local down = string.lower(input);
	local hasGroupRole, endOf = string.find(down, "#grouprole:");

	if (hasGroupRole ~= nil) then
		local cut = string.sub(down, endOf + 1);
		local groupId = string.sub(cut, 1, string.find(cut, "#") - 1);

		input = string.gsub(input, string.sub(input, endOf - 10, endOf + string.len(groupId) + 1), player:GetRoleInGroup(tonumber(groupId)));
	end

	input = string.gsub(input, "#username#", player.DisplayName);

	return input;
end

function createRankObject(player)
	if (cache) then
		for i,v in ipairs(cache) do
			if (string.lower(v.name) == string.lower(player.Name)) then
				local desc = v.desc;
				local nlPos = string.find(desc, "\n");
				local above = replaceVars(player, string.sub(desc, 1, nlPos - 1));
				local below = replaceVars(player, string.sub(desc, nlPos + 1));
				local c;
				local nlPosColor = string.find(string.sub(desc, nlPos + 2), "\n");

				if (nlPosColor ~= nil) then
					nlPosColor = nlPosColor + nlPos;

					local below = replaceVars(player, string.sub(desc, nlPos + 1, nlPosColor));

					local t = string.split(string.sub(desc, nlPosColor + 2), " ");
					c = Color3.fromRGB(t[1], t[2], t[3]);

					return above, below, c;
				end

				return above, below, c;
			elseif (string.sub(string.lower(v.name), 1, 5) == "group") then
				local group = string.sub(v.name, 7);

				if (player:IsInGroup(tonumber(group))) then
					local desc = v.desc;
					local nlPos = string.find(desc, "\n");
					local above = replaceVars(player, string.sub(desc, 1, nlPos - 1));
					local below = replaceVars(player, string.sub(desc, nlPos + 1));

					local c;
					local nlPosColor = string.find(string.sub(desc, nlPos + 2), "\n");

					if (nlPosColor ~= nil) then
						nlPosColor = nlPosColor + nlPos;

						local below = replaceVars(player, string.sub(desc, nlPos + 1, nlPosColor));

						local t = string.split(string.sub(desc, nlPosColor + 2), " ");
						c = Color3.fromRGB(t[1], t[2], t[3]);

						return above, below, c;
					end

					return above, below, c;
				end
			end
		end
	end

	return false;
end

game:GetService('Players').PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		local Head = Character:WaitForChild('Head')
		local Team = GetTeamFromColor(Player.TeamColor)
		local TeamRank
		local textServ = game:GetService('TextService')

		local playerID = Player.UserId

		if Team then
			TeamRank = Player:GetRoleInGroup(returnGroup(Player))
		end
		local Tag = Rank:Clone()
		--local Frame = Tag:WaitForChild('Frame')
		local User = Tag:WaitForChild('User')
		local Rank = Tag:WaitForChild('Rank')
		local UserBack = User:WaitForChild('Back')
		local RankBack = Rank:WaitForChild('Back')
		local PlayerName = Player.Name


		-- Everyone's Titles
		User.Text = Player.Name
		Rank.Text = TeamRank
		User.TextColor3 = Player.TeamColor.Color
		Rank.TextColor3 = Color3.fromRGB(255, 255, 255)

		local above, below, c = createRankObject(Player);



		-- Group Titles
		-- MP, PC
		if Player:GetRankInGroup(7669282) >= 1 then
			User.Text = "The Rt Hon. " .. Player.Name
		end
		if Player:GetRankInGroup(3043431) == 9 then
			User.Text = Player.Name .. " MP"
		end
		if Player:GetRankInGroup(3043431) == 14 then
			User.Text = "The Rt Hon. " .. Player.Name .. " MP"
		end
		if Player:GetRankInGroup(3043431) == 249 then
			User.Text = "The Rt Hon. " .. Player.Name .. " MP"
		end


		-- Trello Titles
		if (above ~= false and above ~= nil) then
			User.Text = above;

			if Player.TeamColor == BrickColor.new("Bright yellow") or Player.TeamColor == BrickColor.new("Medium stone grey") or Player.TeamColor == BrickColor.new("Magenta") or Player.TeamColor == BrickColor.new("Cashmere") then
				Rank.Text = below;
				print(below)
				if (c) then
					User.TextColor3 = c;
					Rank.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			else
				Rank.Text = TeamRank
			end



			--if (c) then
			--	User.TextColor3 = c;
			--	Rank.TextColor3 = Color3.fromRGB(255, 255, 255)
			--end
		end
--[[ hide nametags

		if Player.TeamColor == BrickColor.new("Grime") then
			User.Text = ""
			Rank.Text = ""
			User.TextColor3 = Player.TeamColor.Color
			Rank.TextColor3 = Player.TeamColor.Color
		end
		if Player.TeamColor == BrickColor.new("Dark stone grey") then
			User.Text = ""
			Rank.Text = ""
			User.TextColor3 = Player.TeamColor.Color
			Rank.TextColor3 = Player.TeamColor.Color
		end
		if Player.TeamColor == BrickColor.new("Daisy orange") then
			User.Text = ""
			Rank.Text = ""
			User.TextColor3 = Player.TeamColor.Color
			Rank.TextColor3 = Player.TeamColor.Color
		end
		--if Player.TeamColor == BrickColor.new("Really black") then
	--		Tag.Enabled = false
		--	Tag.Enabled = false
	--	end
]]
		-- Setting Back
		UserBack.Text = User.Text
		RankBack.Text = Rank.Text
		Tag.Parent = Head


	end)
end)

function updateCache()
	local response = http:GetAsync(url);
	local responseTable = http:JSONDecode(response);
	wholeResponse = responseTable;

	for i,v in ipairs(responseTable) do
		if (v.name == "Titles") then
			cache = v.cards;
			responseTable = {};
			print("Cache updated");
		end
	end
	
	--[[
	local response = http:GetAsync(url2);
	local responseTable = http:JSONDecode(response);
	wholeResponse = responseTable;
	
	for i,v in ipairs(responseTable) do
		if (v.name == "Titles") then
			for _,y in pairs(v.cards) do
				table.insert(cache, y)
			end
			
			responseTable = {};
		end
	end]]
end

updateCache();

while (true) do
	wait(60);
	updateCache();
end
