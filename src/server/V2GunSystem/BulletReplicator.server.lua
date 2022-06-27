math.randomseed(tick())

local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")

local fw = game.ReplicatedStorage.WeaponFrameworkRep

local irPoints = Instance.new("Folder")
irPoints.Name = "InfraredPoints"
irPoints.Parent = workspace

local baseDot = Instance.new("Part")
baseDot.Shape = Enum.PartType.Ball
baseDot.Size = Vector3.new(.9,.9,.9)
baseDot.Transparency = 1
baseDot.BrickColor = BrickColor.new("Institutional white")
baseDot.Material = Enum.Material.Neon
baseDot.TopSurface = Enum.SurfaceType.Smooth
baseDot.BottomSurface = Enum.SurfaceType.Smooth
baseDot.CanCollide = false
baseDot.Massless = true

cs:AddTag(baseDot, "Untrackable")

local init = function()
	for _,model in pairs(game.ReplicatedStorage.WeaponFrameworkRep.Models:GetChildren()) do
		if model.PrimaryPart ~= nil then
			for _,v in pairs(model:GetDescendants()) do
				if v:IsA("BasePart") and v ~= model.PrimaryPart then
					local new = Instance.new("CFrameValue")
					new.Value = v.CFrame * model.PrimaryPart.CFrame:Inverse()
					new.Name = "CFOffset"
					new.Parent = v
				end
				
				if v:IsA("BasePart") then
					cs:AddTag(v, "Untrackable")
					v.CanCollide = false
				end
			end
		end
	end
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

function tagHumanoid(humanoid, player)
	untagHumanoid(humanoid)
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
end


local getHeliFromChild = function(v)
	heliFind = function(searchingIn)
		local functionality = searchingIn:FindFirstChild("Functionality")
		
		if functionality ~= nil then
			return functionality
		elseif searchingIn == workspace then
			return nil
		else
			return heliFind(searchingIn.Parent)
		end
	end
	
	local func = heliFind(v)
	
	if func ~= nil then
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

fw.Events.MarkLoopingSound.OnServerEvent:Connect(function(plr, sound, on)
	fw.Events.MarkLoopingSound:FireAllClients(plr, sound, on)
end)

fw.Events.ReplicateShot.OnServerEvent:Connect(function(plr, code, cf, muzzleVelocity, additionalVelocity, bulletType, ignoreTable, fxTable)
	if code ~= 19742 then

		plr:Kick("500 Internal Server Error")
	else
		fw.Events.ReplicateShot:FireAllClients(cf, muzzleVelocity, additionalVelocity, bulletType, ignoreTable, fxTable, plr)
	end
end)

fw.Events.ReplicateRocket.OnServerEvent:Connect(function(plr, code, cf, mV, iV, rocketType, ignoreTable, fxTable, invisTable, soundTable)
	if code ~= 19742 then

		plr:Kick("500 Internal Server Error")
	else
		fw.Events.ReplicateRocket:FireAllClients(cf, mV, iV, rocketType, ignoreTable, fxTable, invisTable, soundTable, plr)
	end
end)

fw.Events.ReplicateMissile.OnServerEvent:Connect(function(plr, code, cf, mV, iV, missileType, ignoreTable, partVal, posVal, fxTable, invisTable, soundTable)
	if code ~= 19742 then

		plr:Kick("500 Internal Server Error")
	else
		fw.Events.ReplicateMissile:FireAllClients(cf, mV, iV, missileType, ignoreTable, partVal, posVal, fxTable, invisTable, soundTable, plr)
	end
end)

fw.Events.ReplicateFlare.OnServerEvent:Connect(function(plr, code, cf, mV, iV, soundTable, heat)
	if code ~= 19742 then
		plr:Kick("500 Internal Server Error")
	else
		fw.Events.ReplicateFlare:FireAllClients(plr, cf, mV, iV, soundTable, true, heat)
	end
end)


fw.Events.Damage.OnServerEvent:Connect(function(plr, code, parts, bulletType, origin)
	if code ~= 19742 then
		plr:Kick("500 Internal Server Error")
	else
		local foundHelis = {}
		local foundHumanoids = {}
		
		for i,v in pairs(parts) do
			if v ~= "filler" then
				local dmg = (i == 1 and bulletType.DamageHumanoid.Value or bulletType.Explosive.ExplosiveDamageHumanoid.Value)
				local dmgV = (i == 1 and bulletType.DamageVehicle.Value or bulletType.Explosive.ExplosiveDamageVehicle.Value)
				
				local heli = getHeliFromChild(v)
				
				if heli ~= nil then
					local found = false
	
					
					for _,v in pairs(foundHelis) do
						if v[1] == heli then
							found = true
						end
					end
					
					if not found then
						table.insert(foundHelis, {heli, dmgV})
					end
				else
					local humanoid = getHumanoidFromChild(v)
					
					if humanoid ~= nil then
						local found = false
					
						for _,v in pairs(foundHumanoids) do
							if v[1] == humanoid then
								found = true
							end
						end
						
						local dmg = dmg
						
						if i ~= 1 then
							dmg = math.max((1 - (humanoid.Parent.Head.Position - origin).Magnitude / (bulletType.Explosive.ExplosiveRadius.Value)) * dmg, 0)
						end
						
						if not found then
							table.insert(foundHumanoids, {humanoid, dmg})
						end
					end
				end
			end
		end
		
		for _,pair in pairs(foundHelis) do
			print(pair[2])
			pair[1].Functionality.Stats.Health.Value = pair[1].Functionality.Stats.Health.Value - (pair[2])
		end
		
		for _,pair in pairs(foundHumanoids) do
			tagHumanoid(pair[1])
			pair[1]:TakeDamage(pair[2])
		end
	end
end)

fw.Events.LaserDot.OnServerEvent:Connect(function(plr, code, action, tag, hit, offsetCF)
	if code ~= 19742 then
		plr:Kick("500 Internal Server Error")
	else
		if action == "new" then
			local new = baseDot:Clone()
			new.Name = tostring(tag)
			new.CFrame = hit.CFrame * offsetCF
			
			cs:AddTag(new, "Untrackable")
			cs:AddTag(new, "InfraredDot")
			
			local joint = Instance.new("Weld")
			joint.Name = "Hold"
			joint.Part0 = hit
			joint.Part1 = new
			joint.C0 = offsetCF
			joint.Parent = new
			
			new.Parent = irPoints
		elseif action == "update" then
			local dot = irPoints[tostring(tag)]
			
			if dot ~= nil then
				if dot:FindFirstChild("Hold") then
					dot.Hold.C0 = offsetCF
				else
					local joint = Instance.new("Weld")
					joint.Name = "Hold"
					joint.Part0 = hit
					joint.Part1 = dot
					joint.C0 = offsetCF
					joint.Parent = dot
				end
			end
		elseif action == "end" then
			pcall(function()
				local dot = irPoints[tostring(tag)]
				
				if dot ~= nil then
					dot:Destroy()
				end
			end)
		end
	end
end)

init()

while wait(1) do
	fw.LightingConditions.Ambient.Value = game.Lighting.Ambient
	fw.LightingConditions.OutdoorAmbient.Value = game.Lighting.OutdoorAmbient
	fw.LightingConditions.Brightness.Value = game.Lighting.Brightness
	fw.LightingConditions.GlobalShadows.Value = game.Lighting.GlobalShadows
end