--\\ Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterCharacter = game:GetService("StarterCharacterScripts")

--\\ Main


local NonCollide = {} --Will check for any parts which have CanCollide off aka doors so it won't trigger | TBD

local HRP = script.Parent:FindFirstChild("HumanoidRootPart")
local LastVector = HRP.Position

local function FlightPrevention(Obj)
    if Obj:IsA("BodyForce") or Obj:IsA("BodyMover") or Obj:IsA("BodyGyro") or Obj:IsA("BodyPosition") then
        warn("This player might be expoiting")
    end
end

local function NoClip()
    local _Ray = Ray.new(LastVector, HRP.Position)
    local Hit, Position = workspace:FindPartOnRayWithIgnoreList(_Ray, NonCollide)

    pcall(function()

            if Hit and HRP:CanCollideWith(Hit) then
                warn("This player might be noclipping")
            end
        end)
    end

RunService.Heartbeat:Connect(function()
        NoClip()
    end)

Players.PlayerAdded:Connect(function(LocalPlayer)
        LocalPlayer.CharacterAdded:Connect( function(char)
                repeat
                    task.wait()
                until char.HumanoidRootPart

                local HRP = char.HumanoidRootPart

             HRP.ChildAdded:Connect(function(Obj)
                 FlightPrevention(Obj)
         end)
      end)
  end)




