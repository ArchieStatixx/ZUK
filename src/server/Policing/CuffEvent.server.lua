local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local CuffEvent = Events:WaitForChild(script.Name)
local GrabEvent = Events:WaitForChild("GrabEvent")

-- Cuffs player.

local AuthorisedTeams = {
	"Metropolitan Police Service",
	"National Crime Agency",
	"Military Police",
	"Territorial Support Group",
	"Secret Intelligence Service",
	"PaDP",
	"SCO19", "GCHQ", "CTSFO",
	"Security Service",
	"United Kingdom Special Forces",
	"Border Force",
	"Royalty and Specialist Protection",
	"British Architects",
	"Founder",
	"CID",
}

function CheckIfAuthorised(team)
	for i,v in pairs(AuthorisedTeams) do
		if team == v then
			return true
		end
	end
	return false
end

CuffEvent.OnServerEvent:connect(function(plr, playercuffed)
	if CheckIfAuthorised(tostring(plr.Team)) == true then
		local SSS = game:GetService("ServerScriptService")
		local Information = SSS:WaitForChild("Function Handlers"):FindFirstChild("FunctionHandlers"):FindFirstChild("Information")
		local Teams = Information:FindFirstChild("Teams")
		local Team = Teams:FindFirstChild(tostring((plr.Team)))
		if Team then
			if plr:GetRankInGroup(Team.Value) >= Team:FindFirstChild("Rank").Value then
				local Char = playercuffed.Character
				local ArrestingChar = plr.Character
				if Char and ArrestingChar then
					local DistanceMag = (ArrestingChar.Head.Position - Char.Head.Position).Magnitude 
					print(DistanceMag)
					if DistanceMag > 40.0 then 
						_G.BanExploiter(plr, 'Exploiting Cuff Event. Tried cuffing: ' .. playercuffed.Name .. ' when they were: ' .. DistanceMag .. ' away')
					end
				end
				if playercuffed.PlayerStats then
					if playercuffed.PlayerStats.IsCuffed.Value == false then
						if Char:findFirstChild("Humanoid") then
							Char.Humanoid.WalkSpeed = 0
						end
						
						Char.Torso["Left Shoulder"].Part1 = nil
						Char.Torso["Right Shoulder"].Part1 = nil
						if Char:findFirstChild("Left Arm") then
							LeftWeld = Instance.new("Weld",Char.Torso)
							LeftWeld.Name = "LWELD"
							LeftWeld.Part0 = Char.Torso
							LeftWeld.Part1 = Char["Left Arm"]
							LeftWeld.C1 = CFrame.new(0.5, -0.30, -0.5) * CFrame.fromEulerAnglesXYZ(math.rad(40), 0, math.rad(-45))
						end
						if Char:findFirstChild("Right Arm") then
							RightWeld = Instance.new("Weld",Char.Torso)
							RightWeld.Name = "RWELD"
							RightWeld.Part0 = Char.Torso
							RightWeld.Part1 = Char["Right Arm"]
							RightWeld.C1 = CFrame.new(-0.5, -0.30, -0.5) * CFrame.fromEulerAnglesXYZ(math.rad(40), 0, math.rad(45))
						end
						playercuffed.PlayerStats.IsCuffed.Value = true
						playercuffed.PlayerGui.Core.Teams.Visible = false
					else
						if Char:findFirstChild("Humanoid") then
							Char.Humanoid.WalkSpeed = 16
						end
						if RightWeld ~= nil then
							Char.Torso["Right Shoulder"].Part1 = Char:findFirstChild("Right Arm");
							RightWeld:Destroy();
						end
						if LeftWeld ~= nil then
							Char.Torso["Left Shoulder"].Part1 = Char:findFirstChild("Left Arm");
							LeftWeld:Destroy();
						end
						playercuffed.PlayerStats.IsCuffed.Value = false
						playercuffed.PlayerGui.Core.Teams.Visible = true
					end
				end
			end
		end
	end
end)

GrabEvent.OnServerEvent:connect(function(plr, playergrabbed)
	if CheckIfAuthorised(tostring(plr.Team)) == true then
		local SSS = game:GetService("ServerScriptService")
		local Information = SSS:WaitForChild("Function Handlers"):FindFirstChild("FunctionHandlers"):FindFirstChild("Information")
		local Teams = Information:FindFirstChild("Teams")
		local Team = Teams:FindFirstChild(tostring((plr.Team)))
		if Team then
			if plr:GetRankInGroup(Team.Value) >= Team:FindFirstChild("Rank").Value then
				local Char = playergrabbed.Character
				if playergrabbed.PlayerStats then
					if playergrabbed.PlayerStats.IsGrabbed.Value == false then
						if playergrabbed.PlayerStats.IsCuffed.Value == true then
							playergrabbed.PlayerStats.IsGrabbed.Value = true
							Weld = Instance.new("Weld")
							Weld.Part0 = Char.Torso
							Weld.Part1 = plr.Character.Torso
							Weld.C1 = Weld.C1 * CFrame.new(0,.05,-2)
							Weld.Name = "GrabWeld"
									
							Weld.Parent = Char.Torso
							Char.Humanoid.PlatformStand = true
						end
					else
						Char.Humanoid.PlatformStand = false
						Char.Humanoid.Jump = true
						Weld:Destroy()
						playergrabbed.PlayerStats.IsGrabbed.Value = false
					end
				end
			end
		end
	end
end)