local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local function Find(Name, Class)
    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v.Name == Name and (not Class or v:IsA(Class)) then
            return v
        end
    end
end

local function WaitFor(Func, Timeout)
    local Start = os.clock()

    repeat
        local Success, Result = pcall(Func)

        if Success and Result then
            return Result
        end

        task.wait(0.03)
    until os.clock() - Start >= Timeout

    return nil
end

local Trigger = WaitFor(function()
    return Find("TriggerPoint", "ImageButton")
end, 5)

if not Trigger then
    return nil
end

if not GuiService.MenuIsOpen then
    firesignal(Trigger.Activated)

    if not WaitFor(function()
        return GuiService.MenuIsOpen
    end, 8) then
        return nil
    end
end

local LeaveButton = WaitFor(function()
    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text == "Leave" then
            local Button = v.Parent

            if Button and Button:IsA("GuiButton") then
                return Button
            end
        end
    end
end, 8)

if not LeaveButton then
    return nil
end

firesignal(LeaveButton.Activated)

local LeavePage = WaitFor(function()
    local v = Find("LeaveGamePage")

    if v and v.Visible then
        return v
    end
end, 8)

if not LeavePage then
    return nil
end

local ConfirmButton = WaitFor(function()
    for _, v in ipairs(LeavePage:GetDescendants()) do
        if v.Name == "LeaveGameButton" and v:IsA("GuiButton") then
            return v
        end
    end
end, 5)

if not ConfirmButton then
    return nil
end

firesignal(ConfirmButton.Activated)
