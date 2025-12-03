local TweenService = game:GetService("TweenService")

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(tab, options)
    local self = setmetatable({}, Dropdown)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Theme = tab.Window.Theme
    self.Utils = tab.Window.Utils
    self.IconLoader = tab.Window.IconLoader
    
    self.Title = options.Title or "Dropdown"
    self.Items = options.Items or {}
    self.Icon = options.Icon
    self.Multi = options.Multi or false
    self.Default = options.Default
    self.Callback = options.Callback
    
    self.IsOpen = false
    self.Selected = self.Multi and {} or nil
    
    if self.Default then
        if self.Multi then
            self.Selected = type(self.Default) == "table" and self.Default or {self.Default}
        else
            self.Selected = self.Default
        end
    end
    
    self:Create()
    
    return self
end

function Dropdown:Create()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    self.Container = Utils.createInstance("Frame", {
        Name = "Dropdown_" .. self.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        ClipsDescendants = false,
        Parent = self.Tab.ContentFrame
    })
    
    self.Header = Utils.createInstance("TextButton", {
        Name = "Header",
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Text = "",
        AutoButtonColor = false,
        Parent = self.Container
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.Header
    })
    
    Utils.createInstance("UIStroke", {
        Color = Theme.Get("BorderColor"),
        Thickness = 1,
        Parent = self.Header
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = self.Header
    })
    
    local leftContent = Utils.createInstance("Frame", {
        Name = "Left",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 1, 0),
        Parent = self.Header
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
    
    self.TitleLabel = Utils.createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 13,
        Parent = leftContent
    })
    
    self.ValueLabel = Utils.createInstance("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Theme.Get("TextMutedColor"),
        TextSize = 12,
        Parent = leftContent
    })
    
    self.Arrow = IconLoader.CreateIcon("chevron-down", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = Theme.Get("TextMutedColor"),
        Transparency = 0,
        Parent = self.Header
    })
    
    self.DropdownFrame = Utils.createInstance("Frame", {
        Name = "Dropdown",
        BackgroundColor3 = Theme.Get("PrimaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 44),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = self.Container
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.DropdownFrame
    })
    
    Utils.createInstance("UIStroke", {
        Color = Theme.Get("BorderColor"),
        Thickness = 1,
        Parent = self.DropdownFrame
    })
    
    Utils.createShadow(self.DropdownFrame, 4)
    
    self.ItemsContainer = Utils.createInstance("ScrollingFrame", {
        Name = "Items",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Get("BorderColor"),
        Parent = self.DropdownFrame
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = self.ItemsContainer
    })
    
    Utils.createInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = self.ItemsContainer
    })
    
    self:PopulateItems()
    self:UpdateValueDisplay()
    
    self.Header.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.Header.MouseEnter:Connect(function()
        TweenService:Create(self.Header, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Get("SecondaryColor"):Lerp(Color3.new(1, 1, 1), 0.03)
        }):Play()
    end)
    
    self.Header.MouseLeave:Connect(function()
        TweenService:Create(self.Header, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Get("SecondaryColor")
        }):Play()
    end)
end

function Dropdown:PopulateItems()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    for _, child in ipairs(self.ItemsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for i, item in ipairs(self.Items) do
        local itemBtn = Utils.createInstance("TextButton", {
            Name = "Item_" .. item,
            BackgroundColor3 = Theme.Get("SecondaryColor"),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = i,
            Parent = self.ItemsContainer
        })
        
        Utils.createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = itemBtn
        })
        
        local itemLabel = Utils.createInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -24, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            Font = Enum.Font.Gotham,
            Text = item,
            TextColor3 = Theme.Get("TextColor"),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemBtn
        })
        
        local checkIcon = IconLoader.CreateIcon("check", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(1, -20, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = Theme.Get("AccentColor"),
            Transparency = 1,
            Parent = itemBtn
        })
        
        itemBtn.MouseEnter:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.5
            }):Play()
        end)
        
        itemBtn.MouseLeave:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            self:SelectItem(item)
            self:UpdateCheckmarks()
        end)
    end
end

function Dropdown:UpdateCheckmarks()
    local Theme = self.Theme
    
    for _, child in ipairs(self.ItemsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            local checkIcon = child:FindFirstChild("Icon_check")
            if checkIcon then
                local isSelected = false
                local itemName = child.Name:gsub("Item_", "")
                
                if self.Multi then
                    isSelected = table.find(self.Selected, itemName) ~= nil
                else
                    isSelected = self.Selected == itemName
                end
                
                TweenService:Create(checkIcon, TweenInfo.new(0.15), {
                    ImageTransparency = isSelected and 0 or 1
                }):Play()
            end
        end
    end
end

function Dropdown:SelectItem(item)
    if self.Multi then
        local index = table.find(self.Selected, item)
        if index then
            table.remove(self.Selected, index)
        else
            table.insert(self.Selected, item)
        end
    else
        self.Selected = item
        self:Close()
    end
    
    self:UpdateValueDisplay()
    self.Utils.safeCallback(self.Callback, self.Selected)
end

function Dropdown:UpdateValueDisplay()
    if self.Multi then
        if #self.Selected > 0 then
            self.ValueLabel.Text = "(" .. #self.Selected .. " selected)"
        else
            self.ValueLabel.Text = ""
        end
    else
        self.ValueLabel.Text = self.Selected and ("- " .. self.Selected) or ""
    end
end

function Dropdown:Toggle()
    if self.IsOpen then
        self:Close()
    else
        self:Open()
    end
end

function Dropdown:Open()
    self.IsOpen = true
    self.DropdownFrame.Visible = true
    
    local itemCount = math.min(#self.Items, 5)
    local targetHeight = itemCount * 34 + 8
    
    TweenService:Create(self.DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
        Size = UDim2.new(1, 0, 0, targetHeight)
    }):Play()
    
    TweenService:Create(self.Arrow, TweenInfo.new(0.2), {
        Rotation = 180
    }):Play()
    
    TweenService:Create(self.Container, TweenInfo.new(0.2), {
        Size = UDim2.new(1, 0, 0, 44 + targetHeight)
    }):Play()
    
    self:UpdateCheckmarks()
end

function Dropdown:Close()
    self.IsOpen = false
    
    TweenService:Create(self.DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
        Size = UDim2.new(1, 0, 0, 0)
    }):Play()
    
    TweenService:Create(self.Arrow, TweenInfo.new(0.2), {
        Rotation = 0
    }):Play()
    
    TweenService:Create(self.Container, TweenInfo.new(0.2), {
        Size = UDim2.new(1, 0, 0, 40)
    }):Play()
    
    task.delay(0.2, function()
        if not self.IsOpen then
            self.DropdownFrame.Visible = false
        end
    end)
end

function Dropdown:SetItems(items)
    self.Items = items
    self:PopulateItems()
end

function Dropdown:GetValue()
    return self.Selected
end

function Dropdown:SetValue(value)
    self.Selected = value
    self:UpdateValueDisplay()
    self:UpdateCheckmarks()
end

return Dropdown
