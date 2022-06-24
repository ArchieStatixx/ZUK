local MarketplaceService = game:GetService('MarketplaceService')
local Storage = game:GetService("ServerStorage")


local Glock = game.ServerStorage["Glock 17"]
local Minigun = game.ServerStorage.Minigun
local C4 = game.ServerStorage.C4


MarketplaceService.ProcessReceipt = function(receiptInfo)
	local Player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)

	if not Player then return end

	local ProductId = receiptInfo.ProductId

	if ProductId == 981111175 then
		Player.PlayerStats.CashOnHand.Value = Player.PlayerStats.CashOnHand.Value +5000
	elseif ProductId == 981111339 then
		Player.PlayerStats.CashOnHand.Value = Player.PlayerStats.CashOnHand.Value +10000
	elseif ProductId == 981111125 then
		Player.PlayerStats.CashOnHand.Value = Player.PlayerStats.CashOnHand.Value +1000
	elseif ProductId == 981111641 then
		Player.PlayerStats.CashOnHand.Value = Player.PlayerStats.CashOnHand.Value +35000
	elseif ProductId == 610879586 then
		Glock:clone().Parent = Player.Backpack -- GLOCK GIVER
	elseif ProductId == 981111827 then
		Minigun:clone().Parent = Player.Backpack -- MINIGUN GIVER
	elseif ProductId == 981123303 then
		C4:clone().Parent = Player.Backpack -- C4 GIVER
	end


	return Enum.ProductPurchaseDecision.PurchaseGranted
end