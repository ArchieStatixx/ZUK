wait(5)
local Player = game:GetService("Players").LocalPlayer
local GunCursor = Player:WaitForChild("PlayerGui"):WaitForChild("GunUI"):WaitForChild("Cursor")

local GunScript = {}
local GunRemote = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("GunShoot")
local LightRemote = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("GunLight")
local CurrentGun
local CurrentGunStats = {}
local UserInputService = game:GetService("UserInputService")
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
		game.ReplicatedStorage.Events.GunSound:FireServer(CurrentGun.Handle.Reload)
		Reload:Play()
		game.ReplicatedStorage.Events.GunReload:FireServer(CurrentGun, CurrentGunStats.ReloadSpeed)
		wait(CurrentGunStats.ReloadSpeed)
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
	if CooldownActivated then return end
	
	local Target = Mouse.Target
	if Player.Character.Humanoid.Health <= 0 then
		return
	end
	local Hit = Mouse.Hit.p
	CurrentGunStats.Bullets = CurrentGunStats.Bullets - 1
	GunScript:UpdateUI()
	Pushback:Play()
	game.ReplicatedStorage.Events.GunSound:FireServer(CurrentGun:WaitForChild("Emitter"):WaitForChild("GunShot"))
	if CurrentGunStats.Bullets == 0 and CurrentGun.Emitter:FindFirstChild("GunShotLast") then
		game.ReplicatedStorage.Events.GunSound:FireServer(CurrentGun.Emitter.GunShotLast)
	end
	local Part, Pos = FireGun(CurrentGun.Emitter.Position, Hit, game.Players.LocalPlayer)
	if Part and Pos then
		do
	
		end
	end
	GunRemote:FireServer(CurrentGun, Hit, Pos, CurrentGunStats.Range, CurrentGunStats.Bullets, Mouse.Target, CurrentGunStats.Damage, CurrentGunStats.HeadshotMultiplier, GunCursor.Parent, CurrentGunStats.FireDelay, CurrentGunStats.BulletSpread)
wait(.0001)
workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame*CFrame.Angles(math.random(-CurrentGunStats.BulletSpread,CurrentGunStats.BulletSpread)/460,math.random(-CurrentGunStats.BulletSpread,CurrentGunStats.BulletSpread)/460,math.random(-CurrentGunStats.BulletSpread,CurrentGunStats.BulletSpread)/460)
end
local SavedStats = {}
local CurrentGunName
local Root = game.ReplicatedStorage:WaitForChild("GunSettings")
function GunScript.Equip(Gun)
	if Player.Character.Humanoid.Sit then return end
	if Player.PlayerStats.IsCuffed.Value == true then return end
	
	local X, Y = Mouse.X, Mouse.Y
	GunCursor.Position = UDim2.new(0, X, 0, Y)
	Player = game.Players.LocalPlayer
	CurrentGun = Gun
	UI = Player:WaitForChild("PlayerGui"):WaitForChild("GunUI")
	if not SavedStats[Gun.Name] then
		CurrentGunStats = require(Root:FindFirstChild(Gun.Name))
		CurrentGunStats.Bullets = 0 
	else
		CurrentGunStats = SavedStats[Gun.Name]
	end
	CurrentGunName = Gun.Name
	if CurrentGunStats.FireMode == "Semi" then
		GunCursor.Parent.Ammo.FireMode.Text = "Fire Mode: Semi"
	elseif CurrentGunStats.FireMode == "Auto" then
		GunCursor.Parent.Ammo.FireMode.Text = "Fire Mode: Auto"
	end
	if not (Hold and Crouch) or not Run then
		if not CurrentGun:FindFirstChild("Idle") then
			local Anim = Instance.new("Animation", CurrentGun)
			Anim.AnimationId = CurrentGunStats.AnimationData.Aim.Id
			Anim.Name = "Idle"
		end
		if not CurrentGun:FindFirstChild("Running") then
			local Anim = Instance.new("Animation", CurrentGun)
			Anim.AnimationId = CurrentGunStats.AnimationData.Idle.Id
			Anim.Name = "Running"
		end
		if not CurrentGun:FindFirstChild("Reload") then
			local Anim = Instance.new("Animation", CurrentGun)
			Anim.AnimationId = CurrentGunStats.AnimationData.Reload.Id
			Anim.Name = "Reload"
		end
		if not CurrentGun:FindFirstChild("Pushback") then
			local Anim = Instance.new("Animation", CurrentGun)
			Anim.AnimationId = CurrentGunStats.AnimationData.Recoil.Id
			Anim.Name = "Pushback"
		end
		Hold, Run, Reload, Pushback = Player.Character.Humanoid:LoadAnimation(CurrentGun:WaitForChild("Idle")), Player.Character.Humanoid:LoadAnimation(CurrentGun:WaitForChild("Running")), Player.Character.Humanoid:LoadAnimation(CurrentGun:WaitForChild("Reload")), Player.Character.Humanoid:LoadAnimation(CurrentGun:WaitForChild("Pushback"))
	end
	GunScript:UpdateUI()
	Hold:Play()
	Equipped = true
	GunCursor.Visible = true
	GunCursor.Parent.Ammo.Visible = true
	Mouse.Icon = "rbxassetid://1129350528"
	
	if CurrentGunStats.Bullets ~= 0 then
		CooldownFrame.Visible = true
		CooldownActivated = true

		CooldownBar.Size = UDim2.new(0,0,1,0)

		BarTween:Play()

		BarTween.Completed:Connect(function()
			CooldownActivated = false
			CooldownFrame.Visible = false
		end)
	end
end

local HoldToggle = false


function GunScript.Unequip()
	HoldToggle = false
	
	GunCursor.Visible = false
	GunCursor.Parent.Ammo.Visible = false
	pcall(function()
		Hold:Stop()
		Run:Stop()
	end)
	Equipped = false
	if Running == true then
		Player.Character.Humanoid.WalkSpeed = Player.Character.Humanoid.WalkSpeed - CurrentGunStats.SprintSpeed
	end
	Player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
	Reloading, Firing, Running, Crouching = false, false, false, false
	Mouse.Icon = ""
	CancelReload = true
	CurrentGun = nil
	if 0 >= Player.Character.Humanoid.Health then
		SavedStats = {}
	else
		SavedStats[CurrentGunName] = CurrentGunStats
	end
	CurrentGunName = nil
	CurrentGunStats = nil
	
	BarTween:Cancel()
end
local LastShot = tick()
local Shooting = false
pcall(function()
	Mouse.Move:connect(function()
		if not Equipped then
			return
		end
		local X, Y = Mouse.X, Mouse.Y
		GunCursor.Position = UDim2.new(0, X, 0, Y)
	end)
end)

UserInputService.InputBegan:connect(function(IO, GP)
	pcall(function()
		if not Equipped or GP then
			return
		end
		if IO.UserInputType == Enum.UserInputType.MouseButton1 then
			if CurrentGunStats.Bullets <= 0 then
				--game.ReplicatedStorage.Events.GunSound:FireServer(CurrentGun.Emitter.GunShot)
			end
			if CurrentGunStats.Bullets == 0 then
						game.ReplicatedStorage.Events.GunSound:FireServer(CurrentGun.Emitter.EmptyClip)
					end
			if tick() - LastShot >= CurrentGunStats.FireDelay and CurrentGunStats.Bullets > 0 and not Firing and not Reloading and not Running then
				if CurrentGunStats.FireMode == "Auto" and not Firing then
					Firing = true
					Shooting = true
					HoldToggle = false
					
					Run:Stop()
					Hold:Play()
					
					repeat
						spawn(function()
							GunScript:FireGun()
						end)
						LastShot = tick()
						wait(CurrentGunStats.FireDelay)
					until not Firing or CurrentGunStats.Bullets <= 0
					Shooting = false
				else
					GunScript:FireGun()
				end
				Firing = false
				GunScript:UpdateUI()
				LastShot = tick()
			end
		elseif IO.KeyCode == Enum.KeyCode.LeftShift and not Running and Equipped and not Reloading then
				Running = true
				Firing = false
				Crouching = false
				Player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
				Player.Character.Humanoid.WalkSpeed = Player.Character.Humanoid.WalkSpeed + CurrentGunStats.SprintSpeed
			
				if not HoldToggle then
					Run:Play()
					Hold:Stop()
				end
		elseif IO.KeyCode == Enum.KeyCode.R and not Reloading and not Running and CurrentGunStats.Bullets < CurrentGunStats.ClipSize then
			Reloading = true
			Firing = false
			wait()
			GunScript:Reload()
		elseif IO.KeyCode == Enum.KeyCode.V then
			if CurrentGunStats.AllowSwitching == true and CurrentGunStats.FireMode == "Auto" then
				local Anim = Instance.new("Animation", CurrentGun)
				Anim.AnimationId = CurrentGunStats.AnimationData.ModeChange.Id
				Anim.Name = "ModeChange"
				local Anim2 = Player.Character.Humanoid:LoadAnimation(CurrentGun:WaitForChild("ModeChange"))
				Anim2:Play()
				CurrentGunStats.FireMode = "None"
				GunCursor.Parent.Ammo.FireMode.Text = "Fire Mode: Semi"
				CurrentGun.Handle.Switch:Play()
				CurrentGunStats.FireMode = "Semi"
			elseif CurrentGunStats.AllowSwitching == true and CurrentGunStats.FireMode == "Semi" then
				local Anim = Instance.new("Animation", CurrentGun)
				Anim.AnimationId = CurrentGunStats.AnimationData.ModeChange.Id
				Anim.Name = "ModeChange"
				local Anim2 = Player.Character.Humanoid:LoadAnimation(CurrentGun:WaitForChild("ModeChange"))
				GunCursor.Parent.Ammo.FireMode.Text = "Fire Mode: Auto"
				Anim2:Play()
				CurrentGunStats.FireMode = "None"
				CurrentGun.Handle.Switch:Play()
				CurrentGunStats.FireMode = "Auto"
			end
		elseif IO.KeyCode == Enum.KeyCode.Y then
			LightRemote:FireServer()
		elseif IO.KeyCode == Enum.KeyCode.F then
			HoldToggle = not HoldToggle
			
			if HoldToggle then
				Hold:Stop()	
				Run:Play()
			else
				Run:Stop()
				Hold:Play()
			end
		end
	end)
end)
UserInputService.InputEnded:connect(function(IO, GP)
	if not Equipped or GP then
		return
	end
	if IO.UserInputType == Enum.UserInputType.MouseButton1 then
		Firing = false
	elseif IO.KeyCode == Enum.KeyCode.LeftShift and Running then
		Running = false
		Player.Character.Humanoid.WalkSpeed = Player.Character.Humanoid.WalkSpeed - CurrentGunStats.SprintSpeed
		pcall(function()
			Run:Stop()
			Hold:Play()
		end)
		delay(0.1, function()
			Mouse.Icon = "rbxassetid://1129350528"
		end)
		
		HoldToggle = false
	end
end)
local Character = Player.Character
Character.ChildAdded:connect(function(Child)
	Hold, Crouch, Run, Reload = nil, nil, nil, nil
	if Child:IsA("Tool") and Child:FindFirstChild("Emitter") then
		GunScript.Equip(Child)
	end
end)
Character.ChildRemoved:connect(function(Child)
	if Child:IsA("Tool") and Child == CurrentGun then
		GunScript.Unequip()
	end
end)
Character:WaitForChild("Humanoid").Died:Connect(function()
	Equipped = false
	GunScript.Unequip()
end)

--print("Gun script loaded.")