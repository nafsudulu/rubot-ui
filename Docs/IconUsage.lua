-- Load Icons
local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()

local PrimaryColor = Color3.fromHex("#ffffff")
local SecondaryColor = Color3.fromHex("#315dff")


-- Change default icon set
Icons.SetIconsType("geist")


-- Create simple icon
local houseIcon = Icons.Image({
    Icon = "accessibility-unread", -- Default Geist icon
    Colors = { PrimaryColor, SecondaryColor },
    Size = UDim2.new(0, 32, 0, 32)
})
