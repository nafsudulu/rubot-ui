--[[
    Rubot UI Library - Example Usage
    Copy this script to test the library in your executor
]]

-- Load Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nafsudulu/rubot-ui/refs/heads/main/RubotUI.lua"))()

-- Load Icons (Lucide)
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/nafsudulu/rubot-ui/refs/heads/main/Icons.lua"))()

-- Create Window
local Window = UI:Window({
    Title = "Rubot Executor",
    Icon = Icons["terminal"],
    Size = UDim2.new(0, 520, 0, 400),
    MinSize = Vector2.new(400, 300),
    MaxSize = Vector2.new(800, 600),
    Transparency = 0,
    Resizable = true,
})

-- Window events
Window.Closed:Connect(function()
    print("Window closed!")
end)

Window.Minimized:Connect(function()
    print("Window minimized!")
end)

-- Tab 1: Main
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons["home"],
    Default = true,
})

local ExecutionSection = MainTab:Section("Execution")

ExecutionSection:Title("Script Runner")
ExecutionSection:Description("Execute your scripts with ease using the tools below.")

local ExecuteButton = ExecutionSection:Button({
    Text = "Execute Script",
    Icon = Icons["play"],
})

ExecuteButton.Clicked:Connect(function()
    UI:Toast({
        Title = "Success!",
        Description = "Script executed successfully.",
        Type = "success",
        Duration = 3,
        Icon = Icons["circle-check"],
    })
end)

local AutoExecute = ExecutionSection:Toggle({
    Text = "Auto Execute on Join",
    Default = false,
})

AutoExecute.Changed:Connect(function(value)
    print("Auto Execute:", value)
end)

local ScriptInput = ExecutionSection:Input({
    Placeholder = "Enter script name...",
    Default = "",
})

ScriptInput.Submitted:Connect(function(text)
    print("Script name:", text)
end)

-- Tab 2: Settings
local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = Icons["settings"],
})

local VisualSection = SettingsTab:Section("Visual Settings")

local FOVSlider = VisualSection:Slider({
    Text = "FOV",
    Min = 50,
    Max = 120,
    Default = 90,
    Step = 1,
    Format = function(value)
        return tostring(value) .. "°"
    end,
})

FOVSlider.Changed:Connect(function(value)
    print("FOV changed to:", value)
end)

local TransparencySlider = VisualSection:Slider({
    Text = "Window Transparency",
    Min = 0,
    Max = 50,
    Default = 0,
    Step = 5,
    Format = function(value)
        return tostring(value) .. "%"
    end,
})

TransparencySlider.Changed:Connect(function(value)
    Window:SetTransparency(value / 100)
end)

local ThemeDropdown = VisualSection:Dropdown({
    Text = "Select Theme",
    Options = { "Dark", "Light", "System" },
    Default = "Dark",
})

ThemeDropdown.Changed:Connect(function(selected)
    print("Theme selected:", selected)
end)

local FeaturesSection = SettingsTab:Section("Features")

local FeatureSelect = FeaturesSection:MultiDropdown({
    Text = "Enable Features",
    Options = { "ESP", "Aimbot", "Triggerbot", "Wallhack" },
    Default = { "ESP" },
})

FeatureSelect.Changed:Connect(function(selected)
    print("Features enabled:", table.concat(selected, ", "))
end)

-- Tab 3: Info
local InfoTab = Window:Tab({
    Title = "Info",
    Icon = Icons["info"],
})

local AboutSection = InfoTab:Section("About")

AboutSection:Title("Rubot UI Library")
AboutSection:Description(
    "A minimalist Linear-inspired UI library for Roblox executors. Built with performance and simplicity in mind.")

local CreditsButton = AboutSection:Button({
    Text = "Show Credits",
    Icon = Icons["users"],
})

CreditsButton.Clicked:Connect(function()
    local Modal = UI:Modal({
        Title = "Credits",
        Description = "Rubot UI Library was created with love.\n\nDesign inspired by Linear.\nIcons by Lucide.",
        ConfirmText = "Close",
        CancelText = "Visit GitHub",
        Icon = Icons["heart"],
    })

    Modal:Show():Then(function(result)
        print("Modal result:", result)
    end)
end)

-- Toast Examples
local ToastSection = InfoTab:Section("Toast Examples")

ToastSection:Button({
    Text = "Success Toast",
    Icon = Icons["circle-check"],
}).Clicked:Connect(function()
    UI:Toast({
        Title = "Success!",
        Description = "Operation completed successfully.",
        Type = "success",
        Duration = 3,
        Icon = Icons["circle-check"],
    })
end)

ToastSection:Button({
    Text = "Error Toast",
    Icon = Icons["circle-x"],
}).Clicked:Connect(function()
    UI:Toast({
        Title = "Error!",
        Description = "Something went wrong.",
        Type = "error",
        Duration = 3,
        Icon = Icons["circle-x"],
    })
end)

ToastSection:Button({
    Text = "Info Toast",
    Icon = Icons["info"],
}).Clicked:Connect(function()
    UI:Toast({
        Title = "Info",
        Description = "This is an informational message.",
        Type = "info",
        Duration = 3,
        Icon = Icons["info"],
    })
end)

print("Rubot UI loaded successfully!")
