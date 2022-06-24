local MarketplaceService = game:GetService('MarketplaceService')
local Storage = game:GetService("ServerStorage")
-- General Ideas
-- Player.PlayerStats.CashOnHand.Value = Player.PlayerStats.CashOnHand.Value +35000 -- IF YOU WISH TO MAKE CASH GAMEPASSES
-- Minigun:clone().Parent = Player.Backpack -- FOR ANY TOOL GAMEPASSES

local Glock = game.ServerStorage["Glock 17"]
local Minigun = game.ServerStorage.Minigun
local C4 = game.ServerStorage.C4


MarketplaceService.ProcessReceipt = function(receiptInfo)
	local Player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)

	if not Player then return end

	local ProductId = receiptInfo.ProductId

	if ProductId == 1 then
	elseif ProductId == 1 then
	elseif ProductId == 1 then
	elseif ProductId == 1 then
	elseif ProductId == 1 then
	elseif ProductId == 1 then
	elseif ProductId == 1 then
	end


	return Enum.ProductPurchaseDecision.PurchaseGranted
end