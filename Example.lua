--[[
    Rubot UI Library - Example Usage
    Copy this script to test the library in your executor
]]

-- Load Library
local UI = loadstring(game:HttpGet("YOUR_RAW_URL_HERE/RubotUI.lua"))()

-- Load Icons (Lucide)
local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()
Icons.SetIconsType("lucide")

-- Create Window
local Window = UI:Window({
    Title = "Rubot Executor",
    Icon = Icons.Icon("terminal"),
    Size = UDim2.new(0, 520, 0, 380),
})

-- Tab 1: Main
local MainTab = Window:Tab({
    Title = "Main",
    Icon = Icons.Icon("home"),
    Default = true,
})

local ExecutionSection = MainTab:Section("Execution")

ExecutionSection:Title("Script Runner")
ExecutionSection:Description("Execute your scripts with ease using the tools below.")

local ExecuteButton = ExecutionSection:Button({
    Text = "Execute Script",
    Icon = Icons.Icon("play"),
})

ExecuteButton.Clicked:Connect(function()
    UI:Toast({
        Title = "Success!",
        Description = "Script executed successfully.",
        Type = "success",
        Duration = 3,
        Icon = Icons.Icon("check-circle"),
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
    Icon = Icons.Icon("settings"),
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

local ThemeDropdown = VisualSection:Dropdown({
    Text = "Select Theme",
    Options = { "Light", "Dark", "System" },
    Default = "Light",
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
    Icon = Icons.Icon("info"),
})

local AboutSection = InfoTab:Section("About")

AboutSection:Title("Rubot UI Library")
AboutSection:Description(
"A minimalist Linear-inspired UI library for Roblox executors. Built with performance and simplicity in mind.")

local CreditsButton = AboutSection:Button({
    Text = "Show Credits",
    Icon = Icons.Icon("users"),
})

CreditsButton.Clicked:Connect(function()
    local Modal = UI:Modal({
        Title = "Credits",
        Description = "Rubot UI Library was created with love.\n\nDesign inspired by Linear.\nIcons by Lucide.",
        ConfirmText = "Close",
        CancelText = "Visit GitHub",
        Icon = Icons.Icon("heart"),
    })

    Modal:Show():Then(function(result)
        print("Modal result:", result)
    end)
end)

-- Toast Examples
local ToastSection = InfoTab:Section("Toast Examples")

ToastSection:Button({
    Text = "Success Toast",
    Icon = Icons.Icon("check-circle"),
}).Clicked:Connect(function()
    UI:Toast({
        Title = "Success!",
        Description = "Operation completed successfully.",
        Type = "success",
        Duration = 3,
        Icon = Icons.Icon("check-circle"),
    })
end)

ToastSection:Button({
    Text = "Error Toast",
    Icon = Icons.Icon("x-circle"),
}).Clicked:Connect(function()
    UI:Toast({
        Title = "Error!",
        Description = "Something went wrong.",
        Type = "error",
        Duration = 3,
        Icon = Icons.Icon("x-circle"),
    })
end)

ToastSection:Button({
    Text = "Info Toast",
    Icon = Icons.Icon("info"),
}).Clicked:Connect(function()
    UI:Toast({
        Title = "Info",
        Description = "This is an informational message.",
        Type = "info",
        Duration = 3,
        Icon = Icons.Icon("info"),
    })
end)

print("Rubot UI loaded successfully!")
