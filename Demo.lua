--[[
    Rubot UI Demo Script
    This script demonstrates all components of the Rubot UI library
]]

-- Load the library (adjust the path based on your setup)
local Rubot = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
-- Or for local testing: local Rubot = require(game.ReplicatedStorage.RubotUI.RubotInit)

-- Create the main window
local Window = Rubot:CreateWindow({
    Title = "Rubot Control Panel",
    Size = UDim2.new(0, 500, 0, 380),
    Icon = "bot",
    HideKey = Enum.KeyCode.RightShift,
    MinimizeIcon = "panel-left",
    TogglePosition = "BottomRight"
})

-- ============================
-- MAIN TAB
-- ============================
local MainTab = Window:AddTab("Main", { Icon = "home" })

MainTab:AddSection("Quick Actions", { Icon = "zap" })

MainTab:AddButton({
    Title = "Start Auto Farm",
    Icon = "play",
    Variant = "Primary",
    Callback = function()
        Rubot:Notify({
            Title = "Auto Farm",
            Message = "Auto Farm has been started!",
            Variant = "Success",
            Duration = 3
        })
    end
})

MainTab:AddButton({
    Title = "Stop All Scripts",
    Icon = "stop",
    Variant = "Destructive",
    Callback = function()
        Rubot:Notify({
            Title = "Stopped",
            Message = "All scripts have been stopped.",
            Variant = "Warning",
            Duration = 3
        })
    end
})

MainTab:AddToggle("Auto Kill", false, {
    Icon = "sword",
    Callback = function(state)
        print("Auto Kill:", state)
    end
})

MainTab:AddToggle("God Mode", false, {
    Icon = "shield",
    Callback = function(state)
        print("God Mode:", state)
    end
})

-- ============================
-- PLAYER TAB
-- ============================
local PlayerTab = Window:AddTab("Player", { Icon = "user" })

PlayerTab:AddSection("Movement", { Icon = "footprints" })

PlayerTab:AddSlider("WalkSpeed", 16, 500, 16, {
    Icon = "gauge",
    Suffix = " studs/s",
    Step = 1,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:AddSlider("JumpPower", 50, 500, 50, {
    Icon = "arrow-up",
    Step = 5,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

PlayerTab:AddSection("Teleport", { Icon = "navigation" })

PlayerTab:AddInput("Player Name", {
    Icon = "search",
    Placeholder = "Enter player name...",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Teleporting to:", text)
        end
    end
})

PlayerTab:AddDropdown("Quick Teleport", { "Spawn", "Shop", "Boss Area", "Safe Zone" }, {
    Icon = "map",
    Callback = function(selected)
        print("Selected location:", selected)
        Rubot:Notify({
            Title = "Teleport",
            Message = "Teleporting to " .. selected,
            Variant = "Info",
            Duration = 2
        })
    end
})

-- ============================
-- COMBAT TAB
-- ============================
local CombatTab = Window:AddTab("Combat", { Icon = "swords" })

CombatTab:AddSection("Auto Combat", { Icon = "target" })

CombatTab:AddToggle("Auto Attack", false, {
    Icon = "zap",
    Callback = function(state)
        print("Auto Attack:", state)
    end
})

CombatTab:AddToggle("Auto Skill", false, {
    Icon = "sparkles",
    Callback = function(state)
        print("Auto Skill:", state)
    end
})

CombatTab:AddSlider("Attack Range", 10, 100, 25, {
    Icon = "crosshair",
    Suffix = " studs",
    Step = 5,
    Callback = function(value)
        print("Attack Range:", value)
    end
})

CombatTab:AddSection("Target Settings", { Icon = "eye" })

CombatTab:AddDropdown("Target Priority", { "Nearest", "Lowest HP", "Highest Level", "Boss Only" }, {
    Icon = "list",
    Default = "Nearest",
    Callback = function(selected)
        print("Target Priority:", selected)
    end
})

-- ============================
-- SETTINGS TAB
-- ============================
local SettingsTab = Window:AddTab("Settings", { Icon = "settings" })

SettingsTab:AddSection("Theme", { Icon = "moon" })

SettingsTab:AddDropdown("Color Theme", { "Dark", "Light", "Midnight" }, {
    Icon = "sliders",
    Default = "Dark",
    Callback = function(selected)
        Rubot:SetPreset(selected)
        Rubot:Notify({
            Title = "Theme Changed",
            Message = "Switched to " .. selected .. " theme",
            Variant = "Success",
            Duration = 2
        })
    end
})

SettingsTab:AddSection("Notifications", { Icon = "bell" })

SettingsTab:AddButton({
    Title = "Test Info Notification",
    Icon = "info",
    Variant = "Secondary",
    Callback = function()
        Rubot:Notify({
            Title = "Information",
            Message = "This is an info notification",
            Variant = "Info",
            Duration = 4
        })
    end
})

SettingsTab:AddButton({
    Title = "Test Success Notification",
    Icon = "check",
    Variant = "Secondary",
    Callback = function()
        Rubot:Notify({
            Title = "Success!",
            Message = "Operation completed successfully",
            Variant = "Success",
            Duration = 4
        })
    end
})

SettingsTab:AddButton({
    Title = "Test Warning Notification",
    Icon = "alert-triangle",
    Variant = "Secondary",
    Callback = function()
        Rubot:Notify({
            Title = "Warning",
            Message = "Please be careful with this action",
            Variant = "Warning",
            Duration = 4
        })
    end
})

SettingsTab:AddButton({
    Title = "Test Error Notification",
    Icon = "alert-circle",
    Variant = "Secondary",
    Callback = function()
        Rubot:Notify({
            Title = "Error",
            Message = "Something went wrong!",
            Variant = "Error",
            Duration = 4
        })
    end
})

SettingsTab:AddSection("Window", { Icon = "maximize" })

SettingsTab:AddDropdown("Toggle Position", { "BottomRight", "BottomLeft", "TopRight", "TopLeft" }, {
    Icon = "layout",
    Default = "BottomRight",
    Callback = function(selected)
        Window:SetTogglePosition(selected)
    end
})

-- Show welcome notification
Rubot:Notify({
    Title = "Welcome to Rubot UI",
    Message = "Press RightShift to toggle the UI",
    Variant = "Info",
    Icon = "bot",
    Duration = 5
})

print("[Rubot UI] Demo loaded successfully!")
