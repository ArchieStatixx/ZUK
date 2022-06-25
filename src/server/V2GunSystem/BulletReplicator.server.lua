math.randomseed(tick())

local cs = game:GetService("CollectionService")
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
