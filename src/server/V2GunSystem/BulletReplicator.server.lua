math.randomseed(tick())

local cs = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local rs = game:GetService("RunService")

local FrameWork = game.ReplicatedStorage.WeaponFrameworkRep

local irPoints = Instance.new("Folder")
irPoints.Name = "InfraredPoints"
irPoints.Parent = workspace

local base = Instance.new("Part")
base.Shape = Enum.PartType.Ball
base.Size = Vector3.new(.9,.9,.9)
base.Transparency = 1
base.BrickColor = BrickColor.new("Institutional white")
base.Material = Enum.Material.Neon
base.TopSurface = Enum.SurfaceType.Smooth
base.BottomSurface = Enum.SurfaceType.Smooth
base.CanCollide = false
base.Massless = true

cs:AddTag(base, "Untrackable")

local init = function()
   for _,model in pairs(game.ReplicatedStorage.WeaponFrameworkRep.Models:GetChildren()) do
    if model.PrimaryPart ~= nil then
        for _,v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") and v ~= model.PrimaryPart then
                local Frame = Instance.new("CFrameValue")
                Frame.Value = v.CFrame * model.PrimaryPart.CFrame:Inverse()
                    Frame.Name = "CFOffSet"
                    Frame.Parent = v
            end

            if v:IsA("BasePart") then
                cs:AddTag(v, "Untrackabale")
                v.CanCollide = false 
            end
        end
    end
   end 
end


function HumanoidUntag(humanoid)
    if humanoid ~= nil then
        local tag = humanoid:FindFirstChild("creator")
        if tag ~= nil then
            tag.Parent = nil
        end
    end
end


function HumanoidTag(humanoid, player)
    HumanoidUntag(humanoid)
    local creator_tag = Instance.new("ObjectValue")
    creator_tag.Value = player
    creator_tag.Name = "creator"
    creator_tag.Parent = humanoid
end



local getHelifromChild = function(v)
    heliFind = function(searchingIn)
        local functionality = searchingIn:FindFirstChild("Functionality")
        
        if functionality ~= nil then
            return functionality
            elseif searchingIn == workspace  then
                return nil
            else
                return heliFind(searchingIn.Parent )
        end
    end
    local func = heliFind(v)

    if  func ~= nil then
        func = func.Parent
    end

    return func 
end



local getHumanoidFromChild = function(v)
getHumanoid = function(v)
    local humanoid = v.Parent:FindFirstChild("Humanoid")
        if humanoid ~= nil then
            return humanoid
            elseif v == workspace then
                return nil
            else
                return getHumanoid(v.Parent)
            end
        end

        local h = getHumanoid(v)

        return h 
    end


    

