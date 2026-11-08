local v1 = game:GetService("CoreGui")
local v2 = game:GetService("GuiService")
local function v3(v4, v5)
    for _, v6 in ipairs(v1:GetDescendants()) do
        if v6.Name == v4 and (not v5 or v6:IsA(v5)) then
            return v6
        end
    end
end
local function v7(v8, v9)
    local v10 = os.clock()
    repeat
        local v11 = v8()
        if v11 then
            return v11
        end
        task.wait()
    until os.clock() - v10 >= v9
    return nil
end
local v12 = v3("TriggerPoint", "ImageButton")
if not v12 then
    return nil
end
if not v2.MenuIsOpen then
    firesignal(v12.Activated)
    if not v7(function()
        return v2.MenuIsOpen
    end, 3) then
        return nil
    end
end
local v13 = v7(function()
    for _, v14 in ipairs(v1:GetDescendants()) do
        if v14:IsA("TextLabel") and v14.Text == "Leave" then
            local v15 = v14.Parent

            if v15 and v15:IsA("GuiButton") then
                return v15
            end
        end
    end
end, 3)
if not v13 then
    return nil
end
firesignal(v13.Activated)
local v16 = v7(function()
    local v17 = v3("LeaveGamePage")
    if v17 and v17.Visible then
        return v17
    end
end, 3)
if not v16 then
    return nil
end
local v18 = v16:FindFirstChild("LeaveButtonsContainer", true)
if v18 then
    v18 = v18:FindFirstChild("LeaveButtonsContainer")
    v18 = v18 and v18:FindFirstChild("LeaveGameButton")
end
if not v18 or not v18:IsA("GuiButton") then
    return nil
end
firesignal(v18.Activated)