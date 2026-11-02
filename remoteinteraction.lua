local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/emaandthw/my-Ui-Library/refs/heads/main/wizzardUI.lua"))()
local window = Library:NewWindow("Remote Interaction Menu")
local mainSection = window:NewSection("Main")
local function findAll(className)
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA(className) then
            table.insert(found, obj)
        end
    end
    return found
end

local function findTouchParts()
    local list = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:FindFirstChildOfClass("TouchTransmitter") then
            table.insert(list, obj)
        end
    end
    return list
end
local state = {
    ShowPrompt = false,
    FirePrompt = false,
    FireTouch = false,
    FireClick = false,
}
mainSection:CreateButton("Scan & Notify", function()
    local prompts = findAll("ProximityPrompt")
    local touches = findTouchParts()
    local clicks = findAll("ClickDetector")

    StarterGui:SetCore("SendNotification", {
        Title = "Scan Complete",
        Text = "ProximityPrompts: " .. #prompts .. "\nTouchInterests: " .. #touches .. "\nClickDetectors: " .. #clicks,
        Duration = 5
    })
end)
local origPrompt = setmetatable({}, {__mode = "k"})
local origClick = setmetatable({}, {__mode = "k"})

local function restorePrompts()
    for prompt, o in pairs(origPrompt) do
        pcall(function()
            prompt.RequiresLineOfSight = o.RequiresLineOfSight
            prompt.MaxActivationDistance = o.MaxActivationDistance
            prompt.Enabled = o.Enabled
        end)
    end
    table.clear(origPrompt)
end

local function restoreClicks()
    for click, o in pairs(origClick) do
        pcall(function()
            click.MaxActivationDistance = o.MaxActivationDistance
        end)
    end
    table.clear(origClick)
end

mainSection:CreateToggle("Show Prompts", function(v)
    state.ShowPrompt = v
    if not v then restorePrompts() end
end)
mainSection:CreateToggle("Activate Prompts", function(v) state.FirePrompt = v end)
mainSection:CreateToggle("Fire TouchInterests", function(v) state.FireTouch = v end)
mainSection:CreateToggle("Fire ClickDetectors", function(v)
    state.FireClick = v
    if not v then restoreClicks() end
end)
task.spawn(function()
    while true do
        if state.ShowPrompt then
            for _, prompt in ipairs(findAll("ProximityPrompt")) do
                pcall(function()
                    if not origPrompt[prompt] then
                        origPrompt[prompt] = {
                            RequiresLineOfSight = prompt.RequiresLineOfSight,
                            MaxActivationDistance = prompt.MaxActivationDistance,
                            Enabled = prompt.Enabled,
                        }
                    end
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = 9e9
                    prompt.Enabled = true
                end)
            end
        end
        task.wait(1)
    end
end)
task.spawn(function()
    while true do
        if state.FirePrompt then
            for _, prompt in ipairs(findAll("ProximityPrompt")) do
                pcall(fireproximityprompt, prompt)
            end
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        if state.FireTouch then
            local root = getRoot()
            if root then
                for _, part in ipairs(findTouchParts()) do
                    if not state.FireTouch then break end
                    pcall(function()
                        firetouchinterest(root, part, 0)
                        firetouchinterest(root, part, 1)
                    end)
                end
            end
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        if state.FireClick then
            for _, click in ipairs(findAll("ClickDetector")) do
                pcall(function()
                    if not origClick[click] then
                        origClick[click] = {MaxActivationDistance = click.MaxActivationDistance}
                    end
                    click.MaxActivationDistance = 9e9
                    fireclickdetector(click)
                end)
            end
        end
        task.wait(0.1)
    end
end)