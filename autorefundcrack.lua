local v1 = game:GetService("Players")
local v2 = game:GetService("CoreGui")
local v3 = game:GetService("MarketplaceService")
local v4 = game:GetService("StarterGui")
local v5 = v1.LocalPlayer
local v6 = "88708020645655"
local function v7(v8, v9)
    local v10 = game:HttpGet(v8, true)
    local v11 = loadstring(v10)
    if not v11 then
        error(v9 .. " failed to compile")
    end
    return v11()
end
local v12, v13 = pcall(v7,
    "https://raw.githubusercontent.com/Religius-Star/Main/refs/heads/main/ui%20libary/arod.luau",
    "arod.luau")
if not v12 then
    v4:SetCore("SendNotification", {
        Title = "Load Error",
        Text = "Failed to load UI library: " .. tostring(v13),
        Duration = 10,
    })
    return
end
local v14, v15 = pcall(v7,
    "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.lua",
    "Kawai Lib")
if not v14 then
    v15 = nil
    warn("Kawai not loaded, using fallback notifications.")
end
local v16 = Color3.fromRGB(255, 105, 180)
local v17 = Color3.fromRGB(128, 0, 128)
local function v18(v19, v20, v21, v22, v23, v24)
    v21 = v21 or "info"
    v22 = v22 or 3
    pcall(function()
        if v15 and v15.Notify then
            v15.Notify({
                Title = v19,
                Desc = v20,
                Type = v21,
                Duration = v22,
                Icon = v24 or v6,
                Buttons = v23,
                Color = { v16, v17 },
            })
        else
            v4:SetCore("SendNotification", {
                Title = v19,
                Text = v20,
                Duration = v22,
            })
        end
    end)
end
local function v25()
    local v26 = v2:FindFirstChild("FoundationOverlay")
    if not v26 then return nil end
    local v27 = v26:FindFirstChild("SafeAreaFrame")
    if not v27 then return nil end
    local v28 = v27:FindFirstChild("OverlayPortal")
    if not v28 then return nil end
    local v29 = v28:FindFirstChild("SheetContainer")
    if not v29 then return nil end
    local v30 = v29:FindFirstChild("Frame")
    if not v30 then return nil end
    local v31 = v30:FindFirstChild("Sheet")
    if not v31 then return nil end
    local v32 = v31:FindFirstChild("Content")
    if not v32 then return nil end
    local v33, v34
    for _, v35 in ipairs(v32:GetDescendants()) do
        if v35:IsA("TextLabel") and v35.Text and v35.Text ~= "" then
            v33 = v35.Text
        end
    end
    local v36 = v32:FindFirstChild("Title") or v32:FindFirstChild("Name")
    if v36 and v36:IsA("TextLabel") then
        v33 = v36.Text
    end
    local v37 = v32:FindFirstChild("Price") or v32:FindFirstChild("Cost")
    if v37 and v37:IsA("TextLabel") then
        v34 = v37.Text
    end
    if not v33 and not v34 then return nil end
    return {
        Name = v33 or "Unknown",
        Price = v34 or "?",
        Remaining = "N/A",
        CollectibleId = "N/A",
        TotalQuantity = "N/A",
        IsForSale = "Unknown",
    }
end
local function v38(v39)
    local v40, v41 = pcall(v3.GetProductInfo, v3, v39)
    if v40 and v41 then
        local v42 = v41.CollectibleItemDetails
        local v43 = v42 and v42.TotalQuantity
        return {
            Name = v41.Name or "Unknown",
            Price = tostring(v41.PriceInRobux or 0) .. " Robux",
            Remaining = v41.Remaining ~= nil and tostring(v41.Remaining) or "N/A",
            CollectibleId = tostring(v41.CollectibleItemId or "N/A"),
            TotalQuantity = v43 and tostring(v43) or "N/A",
            IsForSale = (v41.IsForSale == nil) and "N/A" or "Off Sale",
        }
    end
    return v25() or {
        Name = "Unknown Item",
        Price = "?",
        Remaining = "?",
        CollectibleId = "?",
        TotalQuantity = "?",
        IsForSale = "Unknown",
    }
end
local function v44(_, v45)
    if not v45 or v45 == 0 then return end
    local v46 = v38(v45)
    local v47 = string.format(
        "Name: %s\nPrice: %s\nStatus: %s\nRemaining: %s\nCollectible ID: %s\nTotal: %s",
        v46.Name, v46.Price, v46.IsForSale, v46.Remaining, v46.CollectibleId, v46.TotalQuantity
    )
    local v48 = "rbxthumb://type=Asset&id=" .. v45 .. "&w=420&h=420"
    v18("Item Profile", v47, "info", 10, nil, v48)
    if getgenv().AutoRefund then
        v3:SignalPromptPurchaseFinished(v5, v45, false)
    end
end
local function v49(v50)
    getgenv().AutoRefund = v50
    v18(
        "Auto Refund",
        v50 and "Enabled — purchases will be auto-declined" or "Disabled",
        v50 and "success" or "info",
        3
    )
end
local v51 = v13:CreateWindow("Auto Refund", "refresh-cw")
v51:Section("Auto Refund")
v51:Label("Automatically declines purchase prompts and shows item details.")
v51:Label("No Robux or gems are spent — just snipes and refunds.")
getgenv().AutoRefund = false
v51:Toggle("Enable Auto Refund", false, v49)
v51:Section("Credits")
v51:Label("skid by pnka")
v13:Start()
v3.PromptPurchaseRequestedV2:Connect(v44)
v3.PromptPurchaseRequested:Connect(v44)
v18("Auto Refund Loaded", "Toggle enabled/disabled in the UI", "info", 4)
