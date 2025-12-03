-- Load icons
local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()

-- Set Icons Type
Icons.SetIconsType("lucide") -- lucide, craft and more...

-- Use Icons
local HouseIcon = Icons.Icon("house")

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Image = HouseIcon[1]
ImageLabel.ImageRectSize = HouseIcon[2].ImageRectSize
ImageLabel.ImageRectOffset = HouseIcon[2].ImageRectPosition
