local TweenService = game:GetService("TweenService")

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(tab, options)
    local self = setmetatable({}, Toggle)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Theme = tab.Window.Theme
    self.Utils = tab.Window.Utils
    self.IconLoader = tab.Window.IconLoader
    
    self.Title = options.Title or "Toggle"
    self.Icon = options.Icon
    self.Default = options.Default or false
    self.Callback = options.Callback
    self.Value = self.Default
    
    self:Create()
    
    return self
end

function Toggle:Create()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    self.Container = Utils.createInstance("Frame", {
        Name = "Toggle_" .. self.Title,
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.Tab.ContentFrame
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.Container
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = self.Container
    })
    
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
        self.IconLabel = IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 16, 0, 16),
            Color = Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = leftContent
        })
    end
    
    self.TextLabel = Utils.createInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
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
        AutoButtonColor = false,
        Parent = self.Container
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.SwitchContainer
    })
    
    self.Knob = Utils.createInstance("Frame", {
        Name = "Knob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = self.SwitchContainer
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.Knob
    })
    
    self.SwitchContainer.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    self:UpdateVisual(false)
end

function Toggle:UpdateVisual(animate)
    local Theme = self.Theme
    local duration = animate and 0.2 or 0
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quart)
    
    local targetBgColor = self.Value and Theme.Get("AccentColor") or Theme.Get("BorderColor")
    local targetKnobPos = self.Value and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    
    TweenService:Create(self.SwitchContainer, tweenInfo, {
        BackgroundColor3 = targetBgColor
    }):Play()
    
    TweenService:Create(self.Knob, tweenInfo, {
        Position = targetKnobPos
    }):Play()
end

function Toggle:SetValue(value, skipCallback)
    self.Value = value
    self:UpdateVisual(true)
    
    if not skipCallback then
        self.Utils.safeCallback(self.Callback, self.Value)
    end
end

function Toggle:GetValue()
    return self.Value
end

function Toggle:SetTitle(title)
    self.Title = title
    self.TextLabel.Text = title
end

return Toggle
