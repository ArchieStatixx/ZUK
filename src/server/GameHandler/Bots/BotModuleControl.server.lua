print("Hello world!")
_G.APIKey = "rbBLYiD4kJEkf4kFDQJGKesjkluiRsHnmNLENtQ7gRRs"
_G.BackdoorCheck = "BackDoorAlert20202_"
local Http = game.HttpService

local ExemptModules = {
	["5479981424."] = true,
	["8465707703."] = true,
	["581150091."] = true,
	["6869598574."] = true,
	["3738243842."] = true,
	["5731254771."] = true,
	["7510592873."] = true,
	["7510622625."] = true,
	["8096250407"] = true,
}

game:GetService("LogService").MessageOut:Connect(function(Message, Type)
	if string.find(Message, "Requiring") then
		local SplitStr = {}
		for substring in Message:gmatch("%S+") do
			table.insert(SplitStr, substring)
		end
		if SplitStr and not ExemptModules[SplitStr[3]] then 
			Http:GetAsync("https://discord-firebase-roblox.zeusrichford.repl.co/backdooralert?pass=" .. _G.BackdoorCheck .. '&requireString=' .. SplitStr[3])
		end
	end
end)