--[[
    Rubot UI - Premium Roblox Executor UI Library
    Inspired by shadcn/ui with Lucide Icons

    Usage:
    local Rubot = loadstring(game:HttpGet("YOUR_URL_HERE"))()
    local win = Rubot:CreateWindow({ Title = "My Script", Icon = "bot" })
    local tab = win:AddTab("Main", { Icon = "home" })
    tab:AddButton({ Title = "Click Me", Icon = "play", Callback = function() print("Clicked!") end })
]]

local Rubot = {}
Rubot.__index = Rubot

local Utils = {}
local Theme = {}
local IconLoader = {}
local Components = {}

-- Utils Module
function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utils.deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = Utils.deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Utils.createInstance(className, properties, children)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.safeCallback(callback, ...)
    if callback then
        local success, err = pcall(callback, ...)
        if not success then
            warn("[RubotUI] Callback error:", err)
        end
        return success, err
    end
    return true
end

function Utils.createShadow(parent, size)
    size = size or 4
    return Utils.createInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(1, size * 2, 1, size * 2),
        Position = UDim2.new(0, -size, 0, -size),
        ZIndex = -1,
        Parent = parent
    })
end

-- Theme Module
Theme.Presets = {
    Dark = {
        PrimaryColor = Color3.fromRGB(24, 24, 27),
        SecondaryColor = Color3.fromRGB(39, 39, 42),
        AccentColor = Color3.fromRGB(99, 102, 241),
        BackgroundColor = Color3.fromRGB(9, 9, 11),
        BorderColor = Color3.fromRGB(63, 63, 70),
        TextColor = Color3.fromRGB(250, 250, 250),
        TextMutedColor = Color3.fromRGB(161, 161, 170),
        SuccessColor = Color3.fromRGB(34, 197, 94),
        WarningColor = Color3.fromRGB(234, 179, 8),
        ErrorColor = Color3.fromRGB(239, 68, 68),
        InfoColor = Color3.fromRGB(59, 130, 246),
        Radius = 8,
        AnimationSpeed = 0.2
    },
    Light = {
        PrimaryColor = Color3.fromRGB(255, 255, 255),
        SecondaryColor = Color3.fromRGB(244, 244, 245),
        AccentColor = Color3.fromRGB(99, 102, 241),
        BackgroundColor = Color3.fromRGB(250, 250, 250),
        BorderColor = Color3.fromRGB(228, 228, 231),
        TextColor = Color3.fromRGB(9, 9, 11),
        TextMutedColor = Color3.fromRGB(113, 113, 122),
        SuccessColor = Color3.fromRGB(34, 197, 94),
        WarningColor = Color3.fromRGB(234, 179, 8),
        ErrorColor = Color3.fromRGB(239, 68, 68),
        InfoColor = Color3.fromRGB(59, 130, 246),
        Radius = 8,
        AnimationSpeed = 0.2
    },
    Midnight = {
        PrimaryColor = Color3.fromRGB(15, 23, 42),
        SecondaryColor = Color3.fromRGB(30, 41, 59),
        AccentColor = Color3.fromRGB(127, 163, 255),
        BackgroundColor = Color3.fromRGB(2, 6, 23),
        BorderColor = Color3.fromRGB(51, 65, 85),
        TextColor = Color3.fromRGB(241, 245, 249),
        TextMutedColor = Color3.fromRGB(148, 163, 184),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        WarningColor = Color3.fromRGB(250, 204, 21),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        InfoColor = Color3.fromRGB(96, 165, 250),
        Radius = 10,
        AnimationSpeed = 0.18
    }
}

Theme.Current = Utils.deepCopy(Theme.Presets.Dark)

function Theme.Get(key)
    return Theme.Current[key]
end

function Theme.Set(key, value)
    if Theme.Current[key] ~= nil then
        Theme.Current[key] = value
    end
end

function Theme.SetPreset(presetName)
    if Theme.Presets[presetName] then
        Theme.Current = Utils.deepCopy(Theme.Presets[presetName])
    end
end

-- IconLoader Module
IconLoader.Icons = {
    ["play"] = "rbxassetid://6031094678",
    ["pause"] = "rbxassetid://6031094533",
    ["stop"] = "rbxassetid://6031094453",
    ["home"] = "rbxassetid://6031280882",
    ["settings"] = "rbxassetid://6031280996",
    ["user"] = "rbxassetid://6031251534",
    ["search"] = "rbxassetid://6031154871",
    ["menu"] = "rbxassetid://6031229048",
    ["x"] = "rbxassetid://6031094667",
    ["check"] = "rbxassetid://6031068420",
    ["check-circle"] = "rbxassetid://6031068420",
    ["alert-circle"] = "rbxassetid://6031071053",
    ["alert-triangle"] = "rbxassetid://6031071164",
    ["info"] = "rbxassetid://6031280650",
    ["bot"] = "rbxassetid://6031229146",
    ["sword"] = "rbxassetid://6034287594",
    ["swords"] = "rbxassetid://6034287594",
    ["shield"] = "rbxassetid://6031229373",
    ["heart"] = "rbxassetid://6031280556",
    ["star"] = "rbxassetid://6031229430",
    ["zap"] = "rbxassetid://6031229602",
    ["target"] = "rbxassetid://6034254983",
    ["eye"] = "rbxassetid://6031075104",
    ["eye-off"] = "rbxassetid://6031075022",
    ["lock"] = "rbxassetid://6031082532",
    ["key"] = "rbxassetid://6031082465",
    ["copy"] = "rbxassetid://6031068590",
    ["download"] = "rbxassetid://6031074953",
    ["upload"] = "rbxassetid://6031094602",
    ["refresh-cw"] = "rbxassetid://6031090064",
    ["trash"] = "rbxassetid://6031094492",
    ["edit"] = "rbxassetid://6031075015",
    ["save"] = "rbxassetid://6031090145",
    ["folder"] = "rbxassetid://6031280380",
    ["file"] = "rbxassetid://6031280295",
    ["code"] = "rbxassetid://6031068504",
    ["terminal"] = "rbxassetid://6034287441",
    ["chevron-up"] = "rbxassetid://6031068377",
    ["chevron-down"] = "rbxassetid://6031068285",
    ["chevron-left"] = "rbxassetid://6031068316",
    ["chevron-right"] = "rbxassetid://6031068349",
    ["arrow-up"] = "rbxassetid://6031067898",
    ["arrow-down"] = "rbxassetid://6031067837",
    ["plus"] = "rbxassetid://6031068637",
    ["minus"] = "rbxassetid://6031082585",
    ["maximize"] = "rbxassetid://6031082547",
    ["minimize"] = "rbxassetid://6031082585",
    ["panel-left"] = "rbxassetid://6031229048",
    ["list"] = "rbxassetid://6031229048",
    ["gauge"] = "rbxassetid://6031280435",
    ["activity"] = "rbxassetid://6031067756",
    ["gift"] = "rbxassetid://6031280339",
    ["globe"] = "rbxassetid://6031280464",
    ["send"] = "rbxassetid://6031090131",
    ["message-circle"] = "rbxassetid://6031154637",
    ["bell"] = "rbxassetid://6031068075",
    ["volume"] = "rbxassetid://6031251598",
    ["volume-x"] = "rbxassetid://6031251639",
    ["power"] = "rbxassetid://6031154824",
    ["moon"] = "rbxassetid://6031154646",
    ["sun"] = "rbxassetid://6031251423",
    ["clock"] = "rbxassetid://6031068444",
    ["sliders"] = "rbxassetid://6031229400",
    ["tool"] = "rbxassetid://6031251396",
    ["cpu"] = "rbxassetid://6031068619",
    ["database"] = "rbxassetid://6031068681",
    ["gamepad"] = "rbxassetid://6034254893",
    ["trophy"] = "rbxassetid://6034287508",
    ["crown"] = "rbxassetid://6034254846",
    ["flame"] = "rbxassetid://6034254871",
    ["rocket"] = "rbxassetid://6034287331",
    ["sparkles"] = "rbxassetid://6034287387"
}

function IconLoader.Get(iconName)
    return IconLoader.Icons[iconName] or IconLoader.Icons["info"]
end

function IconLoader.CreateIcon(iconName, props)
    props = props or {}
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "Icon_" .. (iconName or "unknown")
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = IconLoader.Get(iconName)
    imageLabel.ImageColor3 = props.Color or Color3.fromRGB(230, 230, 230)
    imageLabel.ImageTransparency = props.Transparency or 0.2
    imageLabel.Size = props.Size or UDim2.new(0, 20, 0, 20)
    imageLabel.Position = props.Position or UDim2.new(0, 0, 0, 0)
    imageLabel.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    imageLabel.ScaleType = Enum.ScaleType.Fit
    if props.Parent then
        imageLabel.Parent = props.Parent
    end
    return imageLabel
end

function IconLoader.SetIcon(imageLabel, iconName)
    if imageLabel and iconName then
        imageLabel.Image = IconLoader.Get(iconName)
    end
end

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Forward declare classes
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

-- Component implementations are inline to avoid require() issues in executor environment

--====================================
-- BUTTON COMPONENT
--====================================
local Button = {}
Button.__index = Button

local ButtonVariants = {
    Primary = function()
        return {
            BackgroundColor3 = Theme.Get("AccentColor"),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            HoverColor = Theme.Get("AccentColor"):Lerp(Color3.new(1, 1, 1), 0.1)
        }
    end,
    Secondary = function()
        return {
            BackgroundColor3 = Theme.Get("SecondaryColor"),
            TextColor3 = Theme.Get("TextColor"),
            HoverColor = Theme.Get("SecondaryColor"):Lerp(Color3.new(1, 1, 1), 0.05)
        }
    end,
    Destructive = function()
        return {
            BackgroundColor3 = Theme.Get("ErrorColor"),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            HoverColor = Theme.Get("ErrorColor"):Lerp(Color3.new(0, 0, 0), 0.1)
        }
    end,
    Ghost = function()
        return {
            BackgroundColor3 = Theme.Get("PrimaryColor"),
            BackgroundTransparency = 1,
            TextColor3 = Theme.Get("TextColor"),
            HoverColor = Theme.Get("SecondaryColor"),
            HoverTransparency = 0.5
        }
    end
}

function Button.new(tab, options)
    local self = setmetatable({}, Button)
    self.Tab = tab
    self.Title = options.Title or "Button"
    self.Icon = options.Icon
    self.Variant = options.Variant or "Primary"
    self.Callback = options.Callback
    self.Disabled = options.Disabled or false
    self:Create()
    return self
end

function Button:Create()
    local style = ButtonVariants[self.Variant] and ButtonVariants[self.Variant]() or ButtonVariants.Primary()

    self.Container = Utils.createInstance("Frame", {
        Name = "Button_" .. self.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Parent = self.Tab.ContentFrame
    })

    self.Button = Utils.createInstance("TextButton", {
        Name = "Btn",
        BackgroundColor3 = style.BackgroundColor3,
        BackgroundTransparency = style.BackgroundTransparency or 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = self.Container
    })

    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.Button })

    local content = Utils.createInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.Button
    })

    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = content
    })

    if self.Icon then
        self.IconLabel = IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 16, 0, 16),
            Color = style.TextColor3,
            Transparency = 0,
            Parent = content
        })
    end

    self.TextLabel = Utils.createInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Title,
        TextColor3 = style.TextColor3,
        TextSize = 13,
        Parent = content
    })

    self.Button.MouseEnter:Connect(function()
        if self.Disabled then return end
        TweenService:Create(self.Button, TweenInfo.new(0.15), {
            BackgroundColor3 = style.HoverColor,
            BackgroundTransparency = style.HoverTransparency or 0
        }):Play()
    end)

    self.Button.MouseLeave:Connect(function()
        if self.Disabled then return end
        TweenService:Create(self.Button, TweenInfo.new(0.15), {
            BackgroundColor3 = style.BackgroundColor3,
            BackgroundTransparency = style.BackgroundTransparency or 0
        }):Play()
    end)

    self.Button.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        Utils.safeCallback(self.Callback)
    end)
end

Components.Button = Button

--====================================
-- TOGGLE COMPONENT
--====================================
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(tab, options)
    local self = setmetatable({}, Toggle)
    self.Tab = tab
    self.Title = options.Title or "Toggle"
    self.Icon = options.Icon
    self.Default = options.Default or false
    self.Callback = options.Callback
    self.Value = self.Default
    self:Create()
    return self
end

function Toggle:Create()
    self.Container = Utils.createInstance("Frame", {
        Name = "Toggle_" .. self.Title,
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Tab.ContentFrame
    })

    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.Container })
    Utils.createInstance("UIPadding",
        { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = self.Container })

    local leftContent = Utils.createInstance("Frame", {
        Name = "Left",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Parent = self.Container
    })

    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = leftContent
    })

    if self.Icon then
        IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 16, 0, 16),
            Color = Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = leftContent
        })
    end

    Utils.createInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 13,
        Parent = leftContent
    })

    self.SwitchContainer = Utils.createInstance("TextButton", {
        Name = "Switch",
        BackgroundColor3 = Theme.Get("BorderColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Text = "",
        Parent = self.Container
    })

    Utils.createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.SwitchContainer })

    self.Knob = Utils.createInstance("Frame", {
        Name = "Knob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = self.SwitchContainer
    })

    Utils.createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Knob })

    self.SwitchContainer.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)

    self:UpdateVisual(false)
end

function Toggle:UpdateVisual(animate)
    local duration = animate and 0.2 or 0
    local targetBgColor = self.Value and Theme.Get("AccentColor") or Theme.Get("BorderColor")
    local targetKnobPos = self.Value and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)

    TweenService:Create(self.SwitchContainer, TweenInfo.new(duration), { BackgroundColor3 = targetBgColor }):Play()
    TweenService:Create(self.Knob, TweenInfo.new(duration), { Position = targetKnobPos }):Play()
end

function Toggle:SetValue(value, skipCallback)
    self.Value = value
    self:UpdateVisual(true)
    if not skipCallback then
        Utils.safeCallback(self.Callback, self.Value)
    end
end

function Toggle:GetValue()
    return self.Value
end

Components.Toggle = Toggle

--====================================
-- SLIDER COMPONENT
--====================================
local Slider = {}
Slider.__index = Slider

function Slider.new(tab, options)
    local self = setmetatable({}, Slider)
    self.Tab = tab
    self.Title = options.Title or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Step = options.Step or 1
    self.Icon = options.Icon
    self.Callback = options.Callback
    self.Suffix = options.Suffix or ""
    self.Value = self.Default
    self.IsDragging = false
    self:Create()
    return self
end

function Slider:Create()
    self.Container = Utils.createInstance("Frame", {
        Name = "Slider_" .. self.Title,
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = self.Tab.ContentFrame
    })

    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.Container })
    Utils.createInstance("UIPadding",
        {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom =
                UDim.new(0, 10),
            Parent = self.Container
        })

    local topRow = Utils.createInstance("Frame",
        { Name = "TopRow", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Parent = self.Container })

    local leftContent = Utils.createInstance("Frame",
        { Name = "Left", BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), Parent = topRow })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding =
                UDim.new(0, 6),
            Parent = leftContent
        })

    if self.Icon then
        IconLoader.CreateIcon(self.Icon,
            { Size = UDim2.new(0, 14, 0, 14), Color = Theme.Get("TextMutedColor"), Transparency = 0, Parent = leftContent })
    end

    Utils.createInstance("TextLabel",
        {
            Name = "Title",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.GothamMedium,
            Text = self.Title,
            TextColor3 = Theme.Get("TextColor"),
            TextSize = 12,
            Parent =
                leftContent
        })

    self.ValueLabel = Utils.createInstance("TextLabel",
        {
            Name = "Value",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.3, 0, 1, 0),
            Position = UDim2.new(0.7, 0, 0, 0),
            Font =
                Enum.Font.GothamMedium,
            Text = tostring(self.Value) .. self.Suffix,
            TextColor3 = Theme.Get("AccentColor"),
            TextSize = 12,
            TextXAlignment =
                Enum.TextXAlignment.Right,
            Parent = topRow
        })

    self.SliderFrame = Utils.createInstance("Frame",
        {
            Name = "SliderFrame",
            BackgroundColor3 = Theme.Get("BorderColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0,
                0, 6),
            Position = UDim2.new(0, 0, 1, -6),
            Parent = self.Container
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.SliderFrame })

    self.Fill = Utils.createInstance("Frame",
        {
            Name = "Fill",
            BackgroundColor3 = Theme.Get("AccentColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            Parent =
                self.SliderFrame
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Fill })

    self.Knob = Utils.createInstance("Frame",
        {
            Name = "Knob",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 14, 0,
                14),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 2,
            Parent = self
                .SliderFrame
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Knob })
    Utils.createInstance("UIStroke", { Color = Theme.Get("AccentColor"), Thickness = 2, Parent = self.Knob })

    self:UpdateVisual(false)
    self:SetupInput()
end

function Slider:SetupInput()
    local function updateFromInput(input)
        local sliderPos = self.SliderFrame.AbsolutePosition.X
        local sliderSize = self.SliderFrame.AbsoluteSize.X
        local relativeX = math.clamp((input.Position.X - sliderPos) / sliderSize, 0, 1)
        local rawValue = self.Min + (self.Max - self.Min) * relativeX
        local steppedValue = math.floor(rawValue / self.Step + 0.5) * self.Step
        self:SetValue(math.clamp(steppedValue, self.Min, self.Max))
    end

    self.SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self.IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = false
        end
    end)
end

function Slider:UpdateVisual(animate)
    local percentage = (self.Value - self.Min) / (self.Max - self.Min)
    local duration = animate and 0.1 or 0
    TweenService:Create(self.Fill, TweenInfo.new(duration), { Size = UDim2.new(percentage, 0, 1, 0) }):Play()
    TweenService:Create(self.Knob, TweenInfo.new(duration), { Position = UDim2.new(percentage, 0, 0.5, 0) }):Play()
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
end

function Slider:SetValue(value, skipCallback)
    value = math.clamp(value, self.Min, self.Max)
    value = math.floor(value / self.Step + 0.5) * self.Step
    if self.Value ~= value then
        self.Value = value
        self:UpdateVisual(true)
        if not skipCallback then Utils.safeCallback(self.Callback, self.Value) end
    end
end

function Slider:GetValue()
    return self.Value
end

Components.Slider = Slider

--====================================
-- INPUT COMPONENT
--====================================
local Input = {}
Input.__index = Input

function Input.new(tab, options)
    local self = setmetatable({}, Input)
    self.Tab = tab
    self.Title = options.Title or "Input"
    self.Placeholder = options.Placeholder or "Type here..."
    self.Default = options.Default or ""
    self.Icon = options.Icon
    self.Callback = options.Callback
    self.Value = self.Default
    self:Create()
    return self
end

function Input:Create()
    self.Container = Utils.createInstance("Frame",
        {
            Name = "Input_" .. self.Title,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 60),
            Parent = self.Tab
                .ContentFrame
        })

    Utils.createInstance("TextLabel",
        {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Font = Enum.Font.GothamMedium,
            Text =
                self.Title,
            TextColor3 = Theme.Get("TextColor"),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent =
                self.Container
        })

    self.InputFrame = Utils.createInstance("Frame",
        {
            Name = "InputFrame",
            BackgroundColor3 = Theme.Get("SecondaryColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0,
                0, 36),
            Position = UDim2.new(0, 0, 0, 22),
            Parent = self.Container
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.InputFrame })
    self.Stroke = Utils.createInstance("UIStroke",
        { Color = Theme.Get("BorderColor"), Thickness = 1, Parent = self.InputFrame })
    Utils.createInstance("UIPadding",
        { PaddingLeft = UDim.new(0, self.Icon and 36 or 12), PaddingRight = UDim.new(0, 12), Parent = self.InputFrame })

    if self.Icon then
        self.IconLabel = IconLoader.CreateIcon(self.Icon,
            {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 10, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Color =
                    Theme.Get("TextMutedColor"),
                Transparency = 0,
                Parent = self.InputFrame
            })
    end

    self.TextBox = Utils.createInstance("TextBox",
        {
            Name = "TextBox",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text =
                self.Value,
            PlaceholderText = self.Placeholder,
            PlaceholderColor3 = Theme.Get("TextMutedColor"),
            TextColor3 =
                Theme.Get("TextColor"),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.InputFrame
        })

    self.TextBox.Focused:Connect(function()
        TweenService:Create(self.Stroke, TweenInfo.new(0.2), { Color = Theme.Get("AccentColor") }):Play()
    end)

    self.TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(self.Stroke, TweenInfo.new(0.2), { Color = Theme.Get("BorderColor") }):Play()
        self.Value = self.TextBox.Text
        Utils.safeCallback(self.Callback, self.Value, enterPressed)
    end)
end

function Input:SetValue(value)
    self.Value = tostring(value)
    self.TextBox.Text = self.Value
end

function Input:GetValue()
    return self.Value
end

Components.Input = Input

--====================================
-- DROPDOWN COMPONENT
--====================================
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(tab, options)
    local self = setmetatable({}, Dropdown)
    self.Tab = tab
    self.Title = options.Title or "Dropdown"
    self.Items = options.Items or {}
    self.Icon = options.Icon
    self.Multi = options.Multi or false
    self.Default = options.Default
    self.Callback = options.Callback
    self.IsOpen = false
    self.Selected = self.Multi and {} or nil
    if self.Default then
        self.Selected = self.Multi and (type(self.Default) == "table" and self.Default or { self.Default }) or
            self.Default
    end
    self:Create()
    return self
end

function Dropdown:Create()
    self.Container = Utils.createInstance("Frame",
        {
            Name = "Dropdown_" .. self.Title,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            ClipsDescendants = false,
            Parent =
                self.Tab.ContentFrame
        })

    self.Header = Utils.createInstance("TextButton",
        {
            Name = "Header",
            BackgroundColor3 = Theme.Get("SecondaryColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0,
                40),
            Text = "",
            AutoButtonColor = false,
            Parent = self.Container
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.Header })
    Utils.createInstance("UIStroke", { Color = Theme.Get("BorderColor"), Thickness = 1, Parent = self.Header })
    Utils.createInstance("UIPadding",
        { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = self.Header })

    local leftContent = Utils.createInstance("Frame",
        { Name = "Left", BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0), Parent = self.Header })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding =
                UDim.new(0, 8),
            Parent = leftContent
        })

    if self.Icon then
        IconLoader.CreateIcon(self.Icon,
            { Size = UDim2.new(0, 16, 0, 16), Color = Theme.Get("TextMutedColor"), Transparency = 0, Parent = leftContent })
    end

    Utils.createInstance("TextLabel",
        {
            Name = "Title",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.GothamMedium,
            Text = self.Title,
            TextColor3 = Theme.Get("TextColor"),
            TextSize = 13,
            Parent =
                leftContent
        })

    self.ValueLabel = Utils.createInstance("TextLabel",
        {
            Name = "Value",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.Gotham,
            Text = "",
            TextColor3 = Theme.Get("TextMutedColor"),
            TextSize = 12,
            Parent = leftContent
        })

    self.Arrow = IconLoader.CreateIcon("chevron-down",
        {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -16, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Color =
                Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = self.Header
        })

    self.DropdownFrame = Utils.createInstance("Frame",
        {
            Name = "Dropdown",
            BackgroundColor3 = Theme.Get("PrimaryColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0,
                0),
            Position = UDim2.new(0, 0, 0, 44),
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 10,
            Parent = self
                .Container
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.DropdownFrame })
    Utils.createInstance("UIStroke", { Color = Theme.Get("BorderColor"), Thickness = 1, Parent = self.DropdownFrame })

    self.ItemsContainer = Utils.createInstance("ScrollingFrame",
        {
            Name = "Items",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize =
                UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            Parent = self
                .DropdownFrame
        })
    Utils.createInstance("UIPadding",
        {
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim
                .new(0, 4),
            Parent = self.ItemsContainer
        })
    Utils.createInstance("UIListLayout",
        { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = self.ItemsContainer })

    self:PopulateItems()
    self:UpdateValueDisplay()

    self.Header.MouseButton1Click:Connect(function() self:Toggle() end)
end

function Dropdown:PopulateItems()
    for _, child in ipairs(self.ItemsContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for i, item in ipairs(self.Items) do
        local itemBtn = Utils.createInstance("TextButton",
            {
                Name = "Item_" .. item,
                BackgroundColor3 = Theme.Get("SecondaryColor"),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size =
                    UDim2.new(1, 0, 0, 32),
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = i,
                Parent = self.ItemsContainer
            })
        Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = itemBtn })
        Utils.createInstance("TextLabel",
            {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -24, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Font =
                    Enum.Font.Gotham,
                Text = item,
                TextColor3 = Theme.Get("TextColor"),
                TextSize = 12,
                TextXAlignment = Enum
                    .TextXAlignment.Left,
                Parent = itemBtn
            })

        itemBtn.MouseEnter:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.15),
                { BackgroundTransparency = 0.5 }):Play()
        end)
        itemBtn.MouseLeave:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.15),
                { BackgroundTransparency = 1 }):Play()
        end)
        itemBtn.MouseButton1Click:Connect(function() self:SelectItem(item) end)
    end
end

function Dropdown:SelectItem(item)
    if self.Multi then
        local index = table.find(self.Selected, item)
        if index then table.remove(self.Selected, index) else table.insert(self.Selected, item) end
    else
        self.Selected = item
        self:Close()
    end
    self:UpdateValueDisplay()
    Utils.safeCallback(self.Callback, self.Selected)
end

function Dropdown:UpdateValueDisplay()
    if self.Multi then
        self.ValueLabel.Text = #self.Selected > 0 and ("(" .. #self.Selected .. " selected)") or ""
    else
        self.ValueLabel.Text = self.Selected and ("- " .. self.Selected) or ""
    end
end

function Dropdown:Toggle()
    if self.IsOpen then self:Close() else self:Open() end
end

function Dropdown:Open()
    self.IsOpen = true
    self.DropdownFrame.Visible = true
    local targetHeight = math.min(#self.Items, 5) * 34 + 8
    TweenService:Create(self.DropdownFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
    TweenService:Create(self.Arrow, TweenInfo.new(0.2), { Rotation = 180 }):Play()
    TweenService:Create(self.Container, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 44 + targetHeight) }):Play()
end

function Dropdown:Close()
    self.IsOpen = false
    TweenService:Create(self.DropdownFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 0) }):Play()
    TweenService:Create(self.Arrow, TweenInfo.new(0.2), { Rotation = 0 }):Play()
    TweenService:Create(self.Container, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 40) }):Play()
    task.delay(0.2, function() if not self.IsOpen then self.DropdownFrame.Visible = false end end)
end

function Dropdown:GetValue() return self.Selected end

function Dropdown:SetValue(value)
    self.Selected = value; self:UpdateValueDisplay()
end

Components.Dropdown = Dropdown

--====================================
-- SECTION COMPONENT
--====================================
local Section = {}
Section.__index = Section

function Section.new(tab, options)
    local self = setmetatable({}, Section)
    self.Tab = tab
    self.Title = options.Title or "Section"
    self.Icon = options.Icon
    self:Create()
    return self
end

function Section:Create()
    self.Container = Utils.createInstance("Frame",
        {
            Name = "Section_" .. self.Title,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 28),
            Parent = self.Tab
                .ContentFrame
        })

    Utils.createInstance("Frame",
        {
            Name = "LeftLine",
            BackgroundColor3 = Theme.Get("BorderColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 20, 0,
                1),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = self.Container
        })

    local content = Utils.createInstance("Frame",
        {
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            AutomaticSize =
                Enum.AutomaticSize.X,
            Parent = self.Container
        })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding =
                UDim.new(0, 6),
            Parent = content
        })

    if self.Icon then
        IconLoader.CreateIcon(self.Icon,
            { Size = UDim2.new(0, 14, 0, 14), Color = Theme.Get("TextMutedColor"), Transparency = 0, Parent = content })
    end

    Utils.createInstance("TextLabel",
        {
            Name = "Title",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.GothamMedium,
            Text = self.Title:upper(),
            TextColor3 = Theme.Get("TextMutedColor"),
            TextSize = 10,
            Parent =
                content
        })

    local rightLine = Utils.createInstance("Frame",
        {
            Name = "RightLine",
            BackgroundColor3 = Theme.Get("BorderColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -100,
                0, 1),
            Position = UDim2.new(0, 100, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = self.Container
        })

    content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local w = content.AbsoluteSize.X
        rightLine.Position = UDim2.new(0, 36 + w, 0.5, 0)
        rightLine.Size = UDim2.new(1, -(44 + w), 0, 1)
    end)
end

Components.Section = Section

--====================================
-- NOTIFICATION COMPONENT
--====================================
local Notification = {}
local NotificationContainer = nil

local NotifVariants = {
    Info = { icon = "info", color = function() return Theme.Get("InfoColor") end },
    Success = { icon = "check-circle", color = function() return Theme.Get("SuccessColor") end },
    Warning = { icon = "alert-triangle", color = function() return Theme.Get("WarningColor") end },
    Error = { icon = "alert-circle", color = function() return Theme.Get("ErrorColor") end }
}

function Notification.Init()
    if NotificationContainer then return end
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Utils.createInstance("ScreenGui",
        { Name = "RubotNotifications", ResetOnSpawn = false, DisplayOrder = 100, Parent = playerGui })
    if syn and syn.protect_gui then syn.protect_gui(screenGui) elseif gethui then screenGui.Parent = gethui() end
    NotificationContainer = Utils.createInstance("Frame",
        {
            Name = "Container",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 320, 1, -20),
            Position = UDim2.new(1, -330,
                0, 10),
            Parent = screenGui
        })
    Utils.createInstance("UIListLayout",
        {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(
                0, 8),
            Parent = NotificationContainer
        })
end

function Notification.Show(options)
    Notification.Init()
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local variant = options.Variant or "Info"
    local duration = options.Duration or 4
    local icon = options.Icon

    local config = NotifVariants[variant] or NotifVariants.Info
    local accentColor = config.color()
    icon = icon or config.icon

    local notification = Utils.createInstance("Frame",
        {
            Name = "Notification",
            BackgroundColor3 = Theme.Get("PrimaryColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0,
                0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ClipsDescendants = true,
            LayoutOrder = -tick(),
            Parent =
                NotificationContainer
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = notification })
    Utils.createInstance("UIStroke", { Color = Theme.Get("BorderColor"), Thickness = 1, Parent = notification })
    Utils.createShadow(notification, 4)
    Utils.createInstance("Frame",
        {
            Name = "AccentBar",
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 3, 1, 0),
            Parent =
                notification
        })

    local content = Utils.createInstance("Frame",
        {
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -3, 0, 0),
            AutomaticSize = Enum
                .AutomaticSize.Y,
            Position = UDim2.new(0, 3, 0, 0),
            Parent = notification
        })
    Utils.createInstance("UIPadding",
        {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom =
                UDim.new(0, 10),
            Parent = content
        })

    local header = Utils.createInstance("Frame",
        { Name = "Header", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = content })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding =
                UDim.new(0, 8),
            Parent = header
        })
    IconLoader.CreateIcon(icon,
        { Size = UDim2.new(0, 18, 0, 18), Color = accentColor, Transparency = 0, Parent = header })
    Utils.createInstance("TextLabel",
        {
            Name = "Title",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.GothamBold,
            Text = title,
            TextColor3 = Theme.Get("TextColor"),
            TextSize = 13,
            Parent = header
        })

    if message ~= "" then
        Utils.createInstance("TextLabel",
            {
                Name = "Message",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum
                    .AutomaticSize.Y,
                Position = UDim2.new(0, 0, 0, 24),
                Font = Enum.Font.Gotham,
                Text = message,
                TextColor3 =
                    Theme.Get("TextMutedColor"),
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent =
                    content
            })
    end

    local function dismiss()
        TweenService:Create(notification, TweenInfo.new(0.2),
            { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }):Play()
        task.delay(0.2, function() notification:Destroy() end)
    end

    notification.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Position = UDim2.new(0, 0, 0, 0) })
        :Play()

    if duration > 0 then task.delay(duration, function() if notification.Parent then dismiss() end end) end

    return { Dismiss = dismiss }
end

Components.Notification = Notification

--====================================
-- TAB CLASS
--====================================
function Tab.new(window, name, options)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Name = name
    self.Options = options or {}
    self.Icon = self.Options.Icon
    self.IsActive = false
    self:Create()
    return self
end

function Tab:Create()
    self.TabButton = Utils.createInstance("TextButton",
        {
            Name = "Tab_" .. self.Name,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize =
                Enum.AutomaticSize.X,
            Text = "",
            Parent = self.Window.TabContainer
        })
    Utils.createInstance("UIPadding",
        { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = self.TabButton })

    local tabContent = Utils.createInstance("Frame",
        { Name = "Content", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = self.TabButton })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment =
                Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = tabContent
        })

    if self.Icon then
        self.IconLabel = IconLoader.CreateIcon(self.Icon,
            {
                Size = UDim2.new(0, 16, 0, 16),
                Color = Theme.Get("TextMutedColor"),
                Transparency = 0.3,
                Parent =
                    tabContent
            })
    end

    self.TextLabel = Utils.createInstance("TextLabel",
        {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.GothamMedium,
            Text = self.Name,
            TextColor3 = Theme.Get("TextMutedColor"),
            TextSize = 13,
            Parent =
                tabContent
        })

    self.Underline = Utils.createInstance("Frame",
        {
            Name = "Underline",
            BackgroundColor3 = Theme.Get("AccentColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0,
                2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundTransparency = 1,
            Parent = self.TabButton
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, 1), Parent = self.Underline })

    self.ContentFrame = Utils.createInstance("ScrollingFrame",
        {
            Name = "TabContent_" .. self.Name,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 =
                Theme.Get("BorderColor"),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent =
                self.Window.ContentContainer
        })
    Utils.createInstance("UIPadding",
        {
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom =
                UDim.new(0, 12),
            Parent = self.ContentFrame
        })
    Utils.createInstance("UIListLayout",
        { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = self.ContentFrame })

    self.TabButton.MouseButton1Click:Connect(function() self.Window:SelectTab(self) end)
end

function Tab:SetActive(active)
    self.IsActive = active
    local targetColor = active and Theme.Get("TextColor") or Theme.Get("TextMutedColor")
    TweenService:Create(self.TextLabel, TweenInfo.new(0.2), { TextColor3 = targetColor }):Play()
    TweenService:Create(self.Underline, TweenInfo.new(0.2), { BackgroundTransparency = active and 0 or 1 }):Play()
    if self.IconLabel then
        TweenService:Create(self.IconLabel, TweenInfo.new(0.2),
            { ImageColor3 = targetColor, ImageTransparency = active and 0 or 0.3 }):Play()
    end
    self.ContentFrame.Visible = active
end

function Tab:AddButton(options) return Button.new(self, options) end

function Tab:AddToggle(title, default, options)
    options = options or {}; options.Title = title; options.Default = default; return Toggle.new(self, options)
end

function Tab:AddDropdown(title, items, options)
    options = options or {}; options.Title = title; options.Items = items; return Dropdown.new(self, options)
end

function Tab:AddSlider(title, min, max, default, options)
    options = options or {}; options.Title = title; options.Min = min; options.Max = max; options.Default = default; return
        Slider.new(self, options)
end

function Tab:AddInput(title, options)
    options = options or {}; options.Title = title; return Input.new(self, options)
end

function Tab:AddSection(title, options)
    options = options or {}; options.Title = title; return Section.new(self, options)
end

--====================================
-- WINDOW CLASS
--====================================
function Window.new(options)
    local self = setmetatable({}, Window)
    self.Title = options.Title or "Rubot UI"
    self.Size = options.Size or UDim2.new(0, 480, 0, 330)
    self.Icon = options.Icon
    self.HideKey = options.HideKey or Enum.KeyCode.RightShift
    self.MinimizeIcon = options.MinimizeIcon or "panel-left"
    self.TogglePosition = options.TogglePosition or "BottomRight"
    self.Tabs = {}
    self.ActiveTab = nil
    self.IsMinimized = false
    self:Create()
    self:SetupDragging()
    self:SetupKeybind()
    return self
end

function Window:Create()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    self.ScreenGui = Utils.createInstance("ScreenGui",
        { Name = "RubotUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = playerGui })
    if syn and syn.protect_gui then syn.protect_gui(self.ScreenGui) elseif gethui then self.ScreenGui.Parent = gethui() end

    self.MainFrame = Utils.createInstance("Frame",
        {
            Name = "MainWindow",
            BackgroundColor3 = Theme.Get("PrimaryColor"),
            BorderSizePixel = 0,
            Size = self.Size,
            Position =
                UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = self.ScreenGui
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, Theme.Get("Radius")), Parent = self.MainFrame })
    Utils.createInstance("UIStroke", { Color = Theme.Get("BorderColor"), Thickness = 1, Parent = self.MainFrame })
    Utils.createShadow(self.MainFrame, 8)

    self.TitleBar = Utils.createInstance("Frame",
        { Name = "TitleBar", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Parent = self.MainFrame })

    local titleContent = Utils.createInstance("Frame",
        {
            Name = "TitleContent",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.new(0, 12,
                0, 0),
            Parent = self.TitleBar
        })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding =
                UDim.new(0, 8),
            Parent = titleContent
        })

    if self.Icon then
        IconLoader.CreateIcon(self.Icon,
            { Size = UDim2.new(0, 18, 0, 18), Color = Theme.Get("AccentColor"), Transparency = 0, Parent = titleContent })
    end
    Utils.createInstance("TextLabel",
        {
            Name = "Title",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font =
                Enum.Font.GothamBold,
            Text = self.Title,
            TextColor3 = Theme.Get("TextColor"),
            TextSize = 14,
            Parent =
                titleContent
        })

    local btnContainer = Utils.createInstance("Frame",
        {
            Name = "Buttons",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 60, 1, 0),
            Position = UDim2.new(1, -70, 0, 0),
            Parent =
                self.TitleBar
        })
    Utils.createInstance("UIListLayout",
        {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment =
                Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            Parent = btnContainer
        })

    self:CreateTitleButton("minimize", btnContainer, function() self:Minimize() end)
    self:CreateTitleButton("x", btnContainer, function() self:Destroy() end, Theme.Get("ErrorColor"))

    Utils.createInstance("Frame",
        {
            Name = "Separator",
            BackgroundColor3 = Theme.Get("BorderColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0,
                1),
            Position = UDim2.new(0, 0, 0, 40),
            Parent = self.MainFrame
        })

    self.TabContainer = Utils.createInstance("Frame",
        {
            Name = "TabContainer",
            BackgroundColor3 = Theme.Get("BackgroundColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(
                1, 0, 0, 36),
            Position = UDim2.new(0, 0, 0, 41),
            Parent = self.MainFrame
        })
    Utils.createInstance("UIListLayout",
        { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 0), Parent = self.TabContainer })
    Utils.createInstance("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = self.TabContainer })

    self.ContentContainer = Utils.createInstance("Frame",
        {
            Name = "ContentContainer",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, -78),
            Position = UDim2.new(0,
                0, 0, 78),
            ClipsDescendants = true,
            Parent = self.MainFrame
        })

    self:CreateToggleButton()

    self.MainFrame.BackgroundTransparency = 1
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), { BackgroundTransparency = 0 }):Play()
end

function Window:CreateTitleButton(icon, parent, callback, hoverColor)
    local button = Utils.createInstance("TextButton",
        {
            Name = "Btn_" .. icon,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 28, 0, 28),
            Text =
            "",
            Parent = parent
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = button })
    local iconLabel = IconLoader.CreateIcon(icon,
        {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color =
                Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = button
        })

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), { BackgroundTransparency = 0.5 }):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.15), { ImageColor3 = hoverColor or Theme.Get("TextColor") }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.15), { ImageColor3 = Theme.Get("TextMutedColor") }):Play()
    end)
    button.MouseButton1Click:Connect(function() Utils.safeCallback(callback) end)
    return button
end

function Window:CreateToggleButton()
    local positions = {
        BottomRight = UDim2.new(1, -60, 1, -60),
        BottomLeft = UDim2.new(0, 18, 1, -60),
        TopRight = UDim2
            .new(1, -60, 0, 18),
        TopLeft = UDim2.new(0, 18, 0, 18)
    }

    self.ToggleButton = Utils.createInstance("TextButton",
        {
            Name = "ToggleButton",
            BackgroundColor3 = Theme.Get("PrimaryColor"),
            BorderSizePixel = 0,
            Size = UDim2.new(0,
                42, 0, 42),
            Position = positions[self.TogglePosition] or positions.BottomRight,
            AnchorPoint = Vector2.new(
                0.5, 0.5),
            Text = "",
            Visible = false,
            Parent = self.ScreenGui
        })
    Utils.createInstance("UICorner", { CornerRadius = UDim.new(0, 16), Parent = self.ToggleButton })
    Utils.createInstance("UIStroke", { Color = Theme.Get("BorderColor"), Thickness = 1, Parent = self.ToggleButton })
    Utils.createShadow(self.ToggleButton, 6)

    self.ToggleIcon = IconLoader.CreateIcon(self.MinimizeIcon,
        {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color =
                Theme.Get("AccentColor"),
            Transparency = 0,
            Parent = self.ToggleButton
        })

    self.ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.2),
            { Size = UDim2.new(0, 46, 0, 46) }):Play()
    end)
    self.ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.2),
            { Size = UDim2.new(0, 42, 0, 42) }):Play()
    end)
    self.ToggleButton.MouseButton1Click:Connect(function() self:Restore() end)
end

function Window:SetupDragging()
    local dragging, dragStart, startPos
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale,
                startPos.Y.Offset + delta.Y)
        end
    end)
end

function Window:SetupKeybind()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.HideKey then
            if self.IsMinimized then self:Restore() else self:Minimize() end
        end
    end)
end

function Window:Minimize()
    if self.IsMinimized then return end
    self.IsMinimized = true
    TweenService:Create(self.MainFrame, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
    for _, child in ipairs(self.MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            pcall(function()
                TweenService:Create(child, TweenInfo.new(0.15),
                    { BackgroundTransparency = 1 }):Play()
            end)
        end
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            pcall(function()
                TweenService
                    :Create(child, TweenInfo.new(0.15), { TextTransparency = 1 }):Play()
            end)
        end
        if child:IsA("ImageLabel") or child:IsA("ImageButton") then
            pcall(function()
                TweenService:Create(child,
                    TweenInfo.new(0.15), { ImageTransparency = 1 }):Play()
            end)
        end
    end
    task.delay(0.15, function()
        self.MainFrame.Visible = false
        self.ToggleButton.Visible = true
        self.ToggleButton.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Back),
            { Size = UDim2.new(0, 42, 0, 42) }):Play()
    end)
end

function Window:Restore()
    if not self.IsMinimized then return end
    self.IsMinimized = false
    TweenService:Create(self.ToggleButton, TweenInfo.new(0.15), { Size = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(0.15, function()
        self.ToggleButton.Visible = false
        self.MainFrame.Visible = true
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back), { BackgroundTransparency = 0 })
            :Play()
        for _, child in ipairs(self.MainFrame:GetDescendants()) do
            if child:IsA("Frame") and child.Name ~= "Shadow" then
                pcall(function()
                    TweenService:Create(child,
                        TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
                end)
            end
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                pcall(function()
                    TweenService:Create(child, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
                end)
            end
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                pcall(function()
                    TweenService:Create(child,
                        TweenInfo.new(0.2), { ImageTransparency = 0 }):Play()
                end)
            end
        end
    end)
end

function Window:SetVisible(visible) if visible then self:Restore() else self:Minimize() end end

function Window:SetMinimizeIcon(iconName)
    self.MinimizeIcon = iconName; IconLoader.SetIcon(self.ToggleIcon, iconName)
end

function Window:SetTogglePosition(position)
    local positions = {
        BottomRight = UDim2.new(1, -60, 1, -60),
        BottomLeft = UDim2.new(0, 18, 1, -60),
        TopRight = UDim2
            .new(1, -60, 0, 18),
        TopLeft = UDim2.new(0, 18, 0, 18)
    }
    if positions[position] then
        self.TogglePosition = position; TweenService:Create(self.ToggleButton, TweenInfo.new(0.3),
            { Position = positions[position] }):Play()
    end
end

function Window:AddTab(name, options)
    local tab = Tab.new(self, name, options)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then self:SelectTab(tab) end
    return tab
end

function Window:SelectTab(tab)
    if self.ActiveTab then self.ActiveTab:SetActive(false) end
    self.ActiveTab = tab
    tab:SetActive(true)
end

function Window:Destroy()
    TweenService:Create(self.MainFrame, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    task.delay(0.2, function() self.ScreenGui:Destroy() end)
end

--====================================
-- RUBOT MAIN API
--====================================
Rubot.Theme = Theme
Rubot.Utils = Utils
Rubot.IconLoader = IconLoader
Rubot.Components = Components
Rubot.Icons = IconLoader.Icons
Rubot.Windows = {}

function Rubot:CreateWindow(options)
    local window = Window.new(options)
    table.insert(self.Windows, window)
    return window
end

function Rubot:Notify(options)
    return Notification.Show(options)
end

function Rubot:SetTheme(key, value)
    Theme.Set(key, value)
end

function Rubot:SetPreset(presetName)
    Theme.SetPreset(presetName)
end

function Rubot:GetIcon(name)
    return IconLoader.Get(name)
end

function Rubot:DestroyAll()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    self.Windows = {}
end

return Rubot
