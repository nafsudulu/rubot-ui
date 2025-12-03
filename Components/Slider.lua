local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Slider = {}
Slider.__index = Slider

function Slider.new(tab, options)
    local self = setmetatable({}, Slider)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Theme = tab.Window.Theme
    self.Utils = tab.Window.Utils
    self.IconLoader = tab.Window.IconLoader
    
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
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    self.Container = Utils.createInstance("Frame", {
        Name = "Slider_" .. self.Title,
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = self.Tab.ContentFrame
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.Container
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 10),
        Parent = self.Container
    })
    
    local topRow = Utils.createInstance("Frame", {
        Name = "TopRow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = self.Container
    })
    
    local leftContent = Utils.createInstance("Frame", {
        Name = "Left",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Parent = topRow
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = leftContent
    })
    
    if self.Icon then
        IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 14, 0, 14),
            Color = Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = leftContent
        })
    end
    
    self.TitleLabel = Utils.createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 12,
        Parent = leftContent
    })
    
    self.ValueLabel = Utils.createInstance("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Font = Enum.Font.GothamMedium,
        Text = tostring(self.Value) .. self.Suffix,
        TextColor3 = Theme.Get("AccentColor"),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = topRow
    })
    
    self.SliderFrame = Utils.createInstance("Frame", {
        Name = "SliderFrame",
        BackgroundColor3 = Theme.Get("BorderColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -6),
        Parent = self.Container
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.SliderFrame
    })
    
    self.Fill = Utils.createInstance("Frame", {
        Name = "Fill",
        BackgroundColor3 = Theme.Get("AccentColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = self.SliderFrame
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.Fill
    })
    
    self.Knob = Utils.createInstance("Frame", {
        Name = "Knob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 2,
        Parent = self.SliderFrame
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.Knob
    })
    
    Utils.createInstance("UIStroke", {
        Color = Theme.Get("AccentColor"),
        Thickness = 2,
        Parent = self.Knob
    })
    
    self:UpdateVisual(false)
    self:SetupInput()
end

function Slider:SetupInput()
    local Theme = self.Theme
    
    local function updateFromInput(input)
        local sliderPos = self.SliderFrame.AbsolutePosition.X
        local sliderSize = self.SliderFrame.AbsoluteSize.X
        
        local relativeX = math.clamp((input.Position.X - sliderPos) / sliderSize, 0, 1)
        local rawValue = self.Min + (self.Max - self.Min) * relativeX
        local steppedValue = math.floor(rawValue / self.Step + 0.5) * self.Step
        steppedValue = math.clamp(steppedValue, self.Min, self.Max)
        
        self:SetValue(steppedValue)
    end
    
    self.SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = true
            updateFromInput(input)
            
            TweenService:Create(self.Knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 18, 0, 18)
            }):Play()
        end
    end)
    
    self.Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsDragging = true
            
            TweenService:Create(self.Knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 18, 0, 18)
            }):Play()
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
            
            TweenService:Create(self.Knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 14, 0, 14)
            }):Play()
        end
    end)
    
    self.SliderFrame.MouseEnter:Connect(function()
        TweenService:Create(self.Knob, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Get("AccentColor"):Lerp(Color3.new(1, 1, 1), 0.3)
        }):Play()
    end)
    
    self.SliderFrame.MouseLeave:Connect(function()
        if not self.IsDragging then
            TweenService:Create(self.Knob, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end
    end)
end

function Slider:UpdateVisual(animate)
    local percentage = (self.Value - self.Min) / (self.Max - self.Min)
    local duration = animate and 0.1 or 0
    
    TweenService:Create(self.Fill, TweenInfo.new(duration), {
        Size = UDim2.new(percentage, 0, 1, 0)
    }):Play()
    
    TweenService:Create(self.Knob, TweenInfo.new(duration), {
        Position = UDim2.new(percentage, 0, 0.5, 0)
    }):Play()
    
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
end

function Slider:SetValue(value, skipCallback)
    value = math.clamp(value, self.Min, self.Max)
    value = math.floor(value / self.Step + 0.5) * self.Step
    
    if self.Value ~= value then
        self.Value = value
        self:UpdateVisual(true)
        
        if not skipCallback then
            self.Utils.safeCallback(self.Callback, self.Value)
        end
    end
end

function Slider:GetValue()
    return self.Value
end

function Slider:SetMin(min)
    self.Min = min
    self:SetValue(math.max(self.Value, min))
end

function Slider:SetMax(max)
    self.Max = max
    self:SetValue(math.min(self.Value, max))
end

return Slider
