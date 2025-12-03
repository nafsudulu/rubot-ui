local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

local VariantStyles = {
    Primary = function(theme)
        return {
            BackgroundColor3 = theme.Get("AccentColor"),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            HoverColor = theme.Get("AccentColor"):Lerp(Color3.new(1, 1, 1), 0.1)
        }
    end,
    Secondary = function(theme)
        return {
            BackgroundColor3 = theme.Get("SecondaryColor"),
            TextColor3 = theme.Get("TextColor"),
            HoverColor = theme.Get("SecondaryColor"):Lerp(Color3.new(1, 1, 1), 0.05)
        }
    end,
    Destructive = function(theme)
        return {
            BackgroundColor3 = theme.Get("ErrorColor"),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            HoverColor = theme.Get("ErrorColor"):Lerp(Color3.new(0, 0, 0), 0.1)
        }
    end,
    Ghost = function(theme)
        return {
            BackgroundColor3 = theme.Get("PrimaryColor"),
            BackgroundTransparency = 1,
            TextColor3 = theme.Get("TextColor"),
            HoverColor = theme.Get("SecondaryColor"),
            HoverTransparency = 0.5
        }
    end
}

function Button.new(tab, options)
    local self = setmetatable({}, Button)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Theme = tab.Window.Theme
    self.Utils = tab.Window.Utils
    self.IconLoader = tab.Window.IconLoader
    
    self.Title = options.Title or "Button"
    self.Icon = options.Icon
    self.Variant = options.Variant or "Primary"
    self.Callback = options.Callback
    self.Disabled = options.Disabled or false
    
    self:Create()
    
    return self
end

function Button:Create()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    local style = VariantStyles[self.Variant] and VariantStyles[self.Variant](Theme) or VariantStyles.Primary(Theme)
    
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
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.Button
    })
    
    if self.Variant ~= "Ghost" then
        Utils.createInstance("UIStroke", {
            Color = Theme.Get("BorderColor"),
            Thickness = 1,
            Transparency = 0.5,
            Parent = self.Button
        })
    end
    
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
    
    self.Button.MouseButton1Down:Connect(function()
        if self.Disabled then return end
        TweenService:Create(self.Button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.98, 0, 0.98, 0),
            Position = UDim2.new(0.01, 0, 0.01, 0)
        }):Play()
    end)
    
    self.Button.MouseButton1Up:Connect(function()
        if self.Disabled then return end
        TweenService:Create(self.Button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    end)
    
    self.Button.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        self.Utils.safeCallback(self.Callback)
    end)
    
    if self.Disabled then
        self:SetDisabled(true)
    end
end

function Button:SetDisabled(disabled)
    self.Disabled = disabled
    local transparency = disabled and 0.5 or 0
    
    TweenService:Create(self.Button, TweenInfo.new(0.2), {
        BackgroundTransparency = transparency
    }):Play()
    
    TweenService:Create(self.TextLabel, TweenInfo.new(0.2), {
        TextTransparency = transparency
    }):Play()
    
    if self.IconLabel then
        TweenService:Create(self.IconLabel, TweenInfo.new(0.2), {
            ImageTransparency = transparency
        }):Play()
    end
end

function Button:SetTitle(title)
    self.Title = title
    self.TextLabel.Text = title
end

function Button:SetCallback(callback)
    self.Callback = callback
end

return Button
