local v1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/emaandthw/my-Ui-Library/refs/heads/main/wizzardUI.lua"))()
local v2 = game:GetService("UserInputService")
local v3 = game:GetService("VirtualInputManager")
local v4 = game:GetService("RunService")
local v5 = game:GetService("CoreGui")
local v47 = game:GetService("StarterGui")
local v6 = true      -- running
local v7 = false     -- autoClicking
local v8 = false     -- perFrame
local v9 = false     -- ultraClicking
local v10 = false    -- setupMode
local v11 = 0.1      -- click delay (seconds)
local v12 = nil      -- saved click position
local v13 = 0        -- touch id
local v44 = 1        -- clicks per tick
local v45 = true     -- touch input still usable
local v53 = 0        -- click counter (for CPS)
local function v48(v49, v50)
    pcall(function()
        v47:SetCore("SendNotification", {
            Title = "Auto Click",
            Text = v49 .. ": " .. (v50 and "ON" or "OFF"),
            Duration = 2,
        })
    end)
end
local function v59(v60)
    if v60 >= 1000000 then
        return string.format("%.1fM", v60 / 1000000)
    elseif v60 >= 1000 then
        return string.format("%.1fk", v60 / 1000)
    end
    return tostring(v60)
end
local function v14()
    return v12 or v2:GetMouseLocation()
end
local function v15(v25, v26, v27)
    if not v45 then return end
    if not pcall(v3.SendTouchEvent, v3, v13, v25, v26, v27) then
        v45 = false
    end
end
local function v16()
    local v29 = v14()
    local v30, v31 = v29.X, v29.Y
    for _ = 1, v44 do
        v3:SendMouseButtonEvent(v30, v31, 0, true, game, 0)
        v15(0, v30, v31)
        v3:SendMouseButtonEvent(v30, v31, 0, false, game, 0)
        v15(2, v30, v31)
    end
    v53 = v53 + v44
end
if v5:FindFirstChild("ClickDotGui") then
    v5.ClickDotGui:Destroy()
end
local v17 = Instance.new("ScreenGui")
v17.Name = "ClickDotGui"
v17.IgnoreGuiInset = true
v17.ResetOnSpawn = false
v17.DisplayOrder = 999
v17.Parent = v5
local v18 = Instance.new("Frame")
v18.Size = UDim2.new(0, 28, 0, 28)
v18.AnchorPoint = Vector2.new(0.5, 0.5)
v18.Position = UDim2.new(0.5, 0, 0.5, 0)
v18.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
v18.BorderSizePixel = 0
v18.Visible = false
v18.Active = false
v18.Parent = v17
Instance.new("UICorner", v18).CornerRadius = UDim.new(1, 0)
local v19 = Instance.new("UIStroke", v18)
v19.Color = Color3.new(1, 1, 1)
v19.Thickness = 2
local function v20()
    local v32 = v2:GetMouseLocation()
    v12 = v32
    v18.Position = UDim2.fromOffset(v32.X, v32.Y)
end
local v21 = false -- holding
v2.InputBegan:Connect(function(v33, v34)
    if not v10 or v34 then return end
    if v33.UserInputType == Enum.UserInputType.MouseButton1
        or v33.UserInputType == Enum.UserInputType.Touch then
        v21 = true
        v20()
    end
end)
v2.InputChanged:Connect(function(v35)
    if v10 and v21 and (v35.UserInputType == Enum.UserInputType.MouseMovement
        or v35.UserInputType == Enum.UserInputType.Touch) then
        v20()
    end
end)
v2.InputEnded:Connect(function(v36)
    if v36.UserInputType == Enum.UserInputType.MouseButton1
        or v36.UserInputType == Enum.UserInputType.Touch then
        v21 = false
    end
end)
local v22 = v1:NewWindow("Auto Click")
local v23 = v22:NewSection("FPS: | CPS:")
v23:CreateToggle("Setup Location", function(v37)
    v10 = v37
    v21 = false
    if v37 then
        if v12 then
            v18.Position = UDim2.fromOffset(v12.X, v12.Y)
        else
            local v38 = v2:GetMouseLocation()
            v18.Position = UDim2.fromOffset(v38.X, v38.Y)
        end
        v18.Visible = true
    else
        v18.Visible = false
    end
    v48("Setup Location", v37)
end)
v23:CreateToggle("Auto Click", function(v39)
    v7 = v39
    v48("Auto Click", v39)
end)
v23:CreateToggle("Click Per Frame", function(v40)
    v8 = v40
    v48("Click Per Frame", v40)
end)
v23:CreateSlider("Delay (x0.01s)", 1, 100, 10, false, function(v41)
    v11 = v41 / 100
end)
v23:CreateSlider("Clicks / Tick", 1, 20, 1, false, function(v46)
    v44 = v46
end)
v23:CreateButton("Destroy UI", function()
    v6 = false
    v7 = false
    v9 = false
    v10 = false
    v17:Destroy()
    local v43 = v5:FindFirstChild("WizardLibrary")
    if v43 then v43:Destroy() end
end)
local v24 = v22:NewSection("Ultra Click")
v24:CreateToggle("Ultra Click", function(v42)
    v9 = v42
    v48("Ultra Click", v42)
end)
task.spawn(function()
    local v56 = 0
    local v51 = os.clock()
    local v54 = v4.RenderStepped:Connect(function()
        v56 = v56 + 1
    end)
    while v6 do
        task.wait(0.5)
        local v52 = os.clock()
        local v55 = v52 - v51
        local v57 = math.floor(v56 / v55 + 0.5)
        local v58 = math.floor(v53 / v55 + 0.5)
        v56, v53, v51 = 0, 0, v52
        v23:SetTitle("FPS: " .. v57 .. " | CPS: " .. v59(v58))
    end
    v54:Disconnect()
end)
task.spawn(function()
    while v6 do
        if v7 then
            v16()
            if v8 then
                v4.Heartbeat:Wait()
            else
                task.wait(v11)
            end
        else
            task.wait(0.1)
        end
    end
end)
task.spawn(function()
    while v6 do
        if v9 then
            v16()
            v4.Heartbeat:Wait()
        else
            task.wait(0.1)
        end
    end
end)
task.spawn(function()
    while v6 do
        if v9 then
            v16()
            task.wait(v11)
        else
            task.wait(0.1)
        end
    end
end)