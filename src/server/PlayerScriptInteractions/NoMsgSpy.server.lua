local Folder = game.ReplicatedStorage:WaitForChild("Functions")
local Remote = Folder:WaitForChild("GetHumanoidState")

local function OnInvoke(no,plr)
    local Stuff = {
    
    WalkSpeed = plr.Character.Humanoid.WalkSpeed,
    JumpPower = plr.Character.Humanoid.JumpPower,
    Backpack = plr.Backpack:GetChildren()
    
    }
    return Stuff
end



Remote.OnServerInvoke = OnInvoke