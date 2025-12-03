local TweenService = game:GetService("TweenService")

local Input = {}
Input.__index = Input

function Input.new(tab, options)
    local self = setmetatable({}, Input)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Theme = tab.Window.Theme
    self.Utils = tab.Window.Utils
    self.IconLoader = tab.Window.IconLoader
    
    self.Title = options.Title or "Input"
    self.Placeholder = options.Placeholder or "Type here..."
    self.Default = options.Default or ""
    self.Icon = options.Icon
    self.Callback = options.Callback
    self.ClearOnFocus = options.ClearOnFocus or false
    self.NumericOnly = options.NumericOnly or false
    
    self.Value = self.Default
    
    self:Create()
    
    return self
end

function Input:Create()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    self.Container = Utils.createInstance("Frame", {
        Name = "Input_" .. self.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        Parent = self.Tab.ContentFrame
    })
    
    self.Label = Utils.createInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Font = Enum.Font.GothamMedium,
        Text = self.Title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    self.InputFrame = Utils.createInstance("Frame", {
        Name = "InputFrame",
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 22),
        Parent = self.Container
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.InputFrame
    })
    
    self.Stroke = Utils.createInstance("UIStroke", {
        Color = Theme.Get("BorderColor"),
        Thickness = 1,
        Parent = self.InputFrame
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, self.Icon and 36 or 12),
        PaddingRight = UDim.new(0, 12),
        Parent = self.InputFrame
    })
    
    if self.Icon then
        self.IconLabel = IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = self.InputFrame
        })
    end
    
    self.TextBox = Utils.createInstance("TextBox", {
        Name = "TextBox",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = self.Value,
        PlaceholderText = self.Placeholder,
        PlaceholderColor3 = Theme.Get("TextMutedColor"),
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = self.ClearOnFocus,
        Parent = self.InputFrame
    })
    
    self.TextBox.Focused:Connect(function()
        TweenService:Create(self.Stroke, TweenInfo.new(0.2), {
            Color = Theme.Get("AccentColor")
        }):Play()
        
        if self.IconLabel then
            TweenService:Create(self.IconLabel, TweenInfo.new(0.2), {
                ImageColor3 = Theme.Get("AccentColor")
            }):Play()
        end
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(self.Stroke, TweenInfo.new(0.2), {
            Color = Theme.Get("BorderColor")
        }):Play()
        
        if self.IconLabel then
            TweenService:Create(self.IconLabel, TweenInfo.new(0.2), {
                ImageColor3 = Theme.Get("TextMutedColor")
            }):Play()
        end
        
        local text = self.TextBox.Text
        
        if self.NumericOnly then
            text = text:gsub("[^%d%.%-]", "")
            self.TextBox.Text = text
        end
        
        self.Value = text
        self.Utils.safeCallback(self.Callback, self.Value, enterPressed)
    end)
    
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if self.NumericOnly then
            local text = self.TextBox.Text:gsub("[^%d%.%-]", "")
            if text ~= self.TextBox.Text then
                self.TextBox.Text = text
            end
        end
    end)
end

function Input:SetValue(value)
    self.Value = tostring(value)
    self.TextBox.Text = self.Value
end

function Input:GetValue()
    return self.Value
end

function Input:SetPlaceholder(placeholder)
    self.Placeholder = placeholder
    self.TextBox.PlaceholderText = placeholder
end

function Input:Focus()
    self.TextBox:CaptureFocus()
end

function Input:Clear()
    self.Value = ""
    self.TextBox.Text = ""
end

return Input
