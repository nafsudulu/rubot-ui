local TweenService = game:GetService("TweenService")

local Tab = {}
Tab.__index = Tab

function Tab.new(window, name, options)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Name = name
    self.Options = options or {}
    self.Icon = self.Options.Icon
    self.Components = {}
    self.IsActive = false
    
    self:Create()
    
    return self
end

function Tab:Create()
    local Theme = self.Window.Theme
    local Utils = self.Window.Utils
    local IconLoader = self.Window.IconLoader
    
    self.TabButton = Utils.createInstance("TextButton", {
        Name = "Tab_" .. self.Name,
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = "",
        Parent = self.Window.TabContainer
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = self.TabButton
    })
    
    local tabContent = Utils.createInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.TabButton
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = tabContent
    })
    
    if self.Icon then
        self.IconLabel = IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 16, 0, 16),
            Color = Theme.Get("TextMutedColor"),
            Transparency = 0.3,
            Parent = tabContent
        })
    end
    
    self.TextLabel = Utils.createInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Name,
        TextColor3 = Theme.Get("TextMutedColor"),
        TextSize = 13,
        Parent = tabContent
    })
    
    self.Underline = Utils.createInstance("Frame", {
        Name = "Underline",
        BackgroundColor3 = Theme.Get("AccentColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundTransparency = 1,
        Parent = self.TabButton
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, 1),
        Parent = self.Underline
    })
    
    self.ContentFrame = Utils.createInstance("ScrollingFrame", {
        Name = "TabContent_" .. self.Name,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Get("BorderColor"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Window.ContentContainer
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        Parent = self.ContentFrame
    })
    
    Utils.createInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = self.ContentFrame
    })
    
    self.TabButton.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    self.TabButton.MouseEnter:Connect(function()
        if not self.IsActive then
            TweenService:Create(self.TextLabel, TweenInfo.new(0.15), {
                TextColor3 = Theme.Get("TextColor")
            }):Play()
        end
    end)
    
    self.TabButton.MouseLeave:Connect(function()
        if not self.IsActive then
            TweenService:Create(self.TextLabel, TweenInfo.new(0.15), {
                TextColor3 = Theme.Get("TextMutedColor")
            }):Play()
        end
    end)
end

function Tab:SetActive(active)
    local Theme = self.Window.Theme
    self.IsActive = active
    
    local targetTextColor = active and Theme.Get("TextColor") or Theme.Get("TextMutedColor")
    local targetUnderlineTransparency = active and 0 or 1
    local targetIconTransparency = active and 0 or 0.3
    
    TweenService:Create(self.TextLabel, TweenInfo.new(0.2), {
        TextColor3 = targetTextColor
    }):Play()
    
    TweenService:Create(self.Underline, TweenInfo.new(0.2), {
        BackgroundTransparency = targetUnderlineTransparency
    }):Play()
    
    if self.IconLabel then
        TweenService:Create(self.IconLabel, TweenInfo.new(0.2), {
            ImageColor3 = targetTextColor,
            ImageTransparency = targetIconTransparency
        }):Play()
    end
    
    self.ContentFrame.Visible = active
end

function Tab:AddButton(options)
    local Button = self.Window.Components.Button
    return Button.new(self, options)
end

function Tab:AddToggle(title, default, options)
    local Toggle = self.Window.Components.Toggle
    options = options or {}
    options.Title = title
    options.Default = default
    return Toggle.new(self, options)
end

function Tab:AddDropdown(title, items, options)
    local Dropdown = self.Window.Components.Dropdown
    options = options or {}
    options.Title = title
    options.Items = items
    return Dropdown.new(self, options)
end

function Tab:AddSlider(title, min, max, default, options)
    local Slider = self.Window.Components.Slider
    options = options or {}
    options.Title = title
    options.Min = min
    options.Max = max
    options.Default = default
    return Slider.new(self, options)
end

function Tab:AddInput(title, options)
    local Input = self.Window.Components.Input
    options = options or {}
    options.Title = title
    return Input.new(self, options)
end

function Tab:AddSection(title, options)
    local Section = self.Window.Components.Section
    options = options or {}
    options.Title = title
    return Section.new(self, options)
end

return Tab
