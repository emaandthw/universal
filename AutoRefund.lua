local STXModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local STXClient = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

pcall(function()
    game:GetService("MarketplaceService").PromptPurchaseRequestedV2:Connect(function(player, assetId, isPurchased)
        
        local MarketplaceService = game:GetService("MarketplaceService")
        local Players = game:GetService("Players")

        local success, v2 = pcall(function()
            return MarketplaceService:GetProductInfo(assetId)
        end)

        if not success or not v2 then return end

        local price = v2.PriceInRobux or 0
        local remaining = 0

        if v2.CollectiblesItemDetails then
            remaining = v2.CollectiblesItemDetails.TotalQuantity or 0
        end
        
        pcall(function()
            MarketplaceService:SignalPromptPurchaseFinished(
                Players.LocalPlayer,
                assetId,
                false
            )
        end)

        STXClient:Notify(
            {
                Title = v2.Name or "Unknown Item",
                Description = string.format(
                    "Item ID: %s\nCost: %s Robux\nRemaining: %s",
                    tostring(assetId),
                    price,
                    remaining
                )
            },
            {
                OutlineColor = Color3.fromRGB(0, 0, 255),
                Time = 5,
                Type = "image"
            },
            {
                Image = string.format("rbxthumb://type=Asset&id=%d&w=420&h=420", assetId),
                ImageColor = Color3.fromRGB(255, 255, 255)
            }
        )
    end)
end)
