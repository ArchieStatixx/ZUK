
local GunScript = {}
local GunRemote = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("GunShoot")
local LightRemote = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("GunLight")
local CurrentGun
local CurrentGunStats = {}
local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local GunCursor = Player:WaitForChild("PlayerGui"):WaitForChild("GunUI"):WaitForChild("Cursor")
local Mouse = Player:GetMouse()
local Hold, Crouch, Run, Reload, Pushback

local TweenService = game:GetService("TweenService")

local COOLDOWN_TIME = 2
local CooldownActivated = false

local CooldownFrame = Player:WaitForChild("PlayerGui"):WaitForChild("GunUI"):WaitForChild("Ammo"):WaitForChild("CooldownUI")
local CooldownBar = CooldownFrame:WaitForChild("Frame")

local BarTween = TweenService:Create(CooldownBar, TweenInfo.new(COOLDOWN_TIME), {
	["Size"] = UDim2.new(1,0,1,0)
})



function GunScript:UpdateUI()
	if not CurrentGun then
		GunCursor.Visible = false
		return
	end
	GunCursor.Visible = true
	if CurrentGunStats.Bullets <= CurrentGunStats.ClipSize / 5 then
		GunCursor.Parent.Ammo.Background.ImageColor3 = Color3.fromRGB(255,0,0)
	else
		GunCursor.Parent.Ammo.Background.ImageColor3 = Color3.fromRGB(255,255,255)
	end
	GunCursor.Parent.Ammo.Text = tostring(CurrentGunStats.Bullets) .. " / " .. CurrentGunStats.ClipSize
end



function GunScript:Reload()
    pcall(function()
        CancelReload = false
        GunCursor.Parent.Ammo.Text = "RELOADING"
        GunCursor.Parent.Ammo.Background.ImageColor3 = Color3.fromRGB(0,0,0)
        game.ReplicatedStorage.GunEvents.GunSound:FireServer(CurrentGun.Handle.Reload)
        Reload:Play()
        game.ReplicatedStorage.GunEvents.GunReload:FireServer(CurrentGun, CurrentGunStats.ReloadSpeed)
        wait(2)
        if not CancelReload then
            GunCursor.Parent.Ammo.Text = "RELOADING"
            CurrentGunStats.Bullets = CurrentGunStats.ClipSize
            self:UpdateUI()
            Reloading = false 
        else
            Reloading = false
            self:UpdateUI()
            CancelReload = false 
        end
    end)
end

function FireGun(A, B, Sender, NotPlayer)
	local NewRay = Ray.new(A, (B - A).unit * 300)
	local Part, Pos = workspace:FindPartOnRay(NewRay, Sender.Character, false, true)
	return Part, Pos
end


function GunScript:FireGun()
    local Target = Mouse.Target
    if Player.Character.Humanoid.Health <= 0 then
        return
    end
        local Hit = Mouse.Hit.p
    CurrentGunStats.Bullets = CurrentGunStats.Bullets - 1 
    GunScript:UpdateUI()
    Pushback:Play()
    game.ReplicatedStorage.GunEvents.GunSound
end
