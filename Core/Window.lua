local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Window = {}
Window.__index = Window

function Window.new(library, options)
    local self = setmetatable({}, Window)
    
    self.Library = library
    self.Theme = library.Theme
    self.Utils = library.Utils
    self.IconLoader = library.IconLoader
    self.Components = library.Components
    
    self.Title = options.Title or "Rubot UI"
    self.Size = options.Size or UDim2.new(0, 480, 0, 330)
    self.Icon = options.Icon
    self.HideKey = options.HideKey or Enum.KeyCode.RightShift
    self.MinimizeIcon = options.MinimizeIcon or "panel-left"
    self.TogglePosition = options.TogglePosition or "BottomRight"
    
    self.Tabs = {}
    self.ActiveTab = nil
    self.IsMinimized = false
    self.IsVisible = true
    self.IsDragging = false
    
    self:Create()
    self:SetupDragging()
    self:SetupKeybind()
    
    return self
end

function Window:Create()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    self.ScreenGui = Utils.createInstance("ScreenGui", {
        Name = "RubotUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = playerGui
    })
    
    if syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
    elseif gethui then
        self.ScreenGui.Parent = gethui()
    end
    
    self.MainFrame = Utils.createInstance("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = Theme.Get("PrimaryColor"),
        BorderSizePixel = 0,
        Size = self.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = self.ScreenGui
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = self.MainFrame
    })
    
    Utils.createInstance("UIStroke", {
        Color = Theme.Get("BorderColor"),
        Thickness = 1,
        Parent = self.MainFrame
    })
    
    Utils.createShadow(self.MainFrame, 8)
    
    self.TitleBar = Utils.createInstance("Frame", {
        Name = "TitleBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.MainFrame
    })
    
    local titleContent = Utils.createInstance("Frame", {
        Name = "TitleContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Parent = self.TitleBar
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = titleContent
    })
    
    if self.Icon then
        IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 18, 0, 18),
            Color = Theme.Get("AccentColor"),
            Transparency = 0,
            Parent = titleContent
        })
    end
    
    Utils.createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 14,
        Parent = titleContent
    })
    
    local buttonContainer = Utils.createInstance("Frame", {
        Name = "Buttons",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -70, 0, 0),
        Parent = self.TitleBar
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4),
        Parent = buttonContainer
    })
    
    self.MinimizeButton = self:CreateTitleButton("minimize", buttonContainer, function()
        self:Minimize()
    end)
    
    self.CloseButton = self:CreateTitleButton("x", buttonContainer, function()
        self:Destroy()
    end, Theme.Get("ErrorColor"))
    
    local separator = Utils.createInstance("Frame", {
        Name = "Separator",
        BackgroundColor3 = Theme.Get("BorderColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 40),
        Parent = self.MainFrame
    })
    
    self.TabContainer = Utils.createInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Theme.Get("BackgroundColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 41),
        Parent = self.MainFrame
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 0),
        Parent = self.TabContainer
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        Parent = self.TabContainer
    })
    
    self.ContentContainer = Utils.createInstance("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -78),
        Position = UDim2.new(0, 0, 0, 78),
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    self:CreateToggleButton()
    
    self.MainFrame.BackgroundTransparency = 1
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundTransparency = 0
    }):Play()
end

function Window:CreateTitleButton(icon, parent, callback, hoverColor)
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    local button = Utils.createInstance("TextButton", {
        Name = "Btn_" .. icon,
        BackgroundColor3 = Theme.Get("SecondaryColor"),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 28, 0, 28),
        Text = "",
        Parent = parent
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })
    
    local iconLabel = IconLoader.CreateIcon(icon, {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Theme.Get("TextMutedColor"),
        Transparency = 0,
        Parent = button
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.5
        }):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.15), {
            ImageColor3 = hoverColor or Theme.Get("TextColor")
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.15), {
            ImageColor3 = Theme.Get("TextMutedColor")
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        self.Utils.safeCallback(callback)
    end)
    
    return button
end

function Window:CreateToggleButton()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    local positions = {
        BottomRight = UDim2.new(1, -60, 1, -60),
        BottomLeft = UDim2.new(0, 18, 1, -60),
        TopRight = UDim2.new(1, -60, 0, 18),
        TopLeft = UDim2.new(0, 18, 0, 18)
    }
    
    self.ToggleButton = Utils.createInstance("TextButton", {
        Name = "ToggleButton",
        BackgroundColor3 = Theme.Get("PrimaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 42, 0, 42),
        Position = positions[self.TogglePosition] or positions.BottomRight,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "",
        Visible = false,
        Parent = self.ScreenGui
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = self.ToggleButton
    })
    
    Utils.createInstance("UIStroke", {
        Color = Theme.Get("BorderColor"),
        Thickness = 1,
        Parent = self.ToggleButton
    })
    
    Utils.createShadow(self.ToggleButton, 6)
    
    self.ToggleIcon = IconLoader.CreateIcon(self.MinimizeIcon, {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Theme.Get("AccentColor"),
        Transparency = 0,
        Parent = self.ToggleButton
    })
    
    self.ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 46, 0, 46)
        }):Play()
    end)
    
    self.ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 42, 0, 42)
        }):Play()
    end)
    
    self.ToggleButton.MouseButton1Click:Connect(function()
        self:Restore()
    end)
end

function Window:SetupDragging()
    local dragging, dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            self.IsDragging = true
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    self.IsDragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Window:SetupKeybind()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == self.HideKey then
            if self.IsMinimized then
                self:Restore()
            else
                self:Minimize()
            end
        end
    end)
end

function Window:Minimize()
    if self.IsMinimized then return end
    self.IsMinimized = true
    
    TweenService:Create(self.MainFrame, TweenInfo.new(0.15), {
        BackgroundTransparency = 1,
        Position = UDim2.new(
            self.MainFrame.Position.X.Scale,
            self.MainFrame.Position.X.Offset,
            self.MainFrame.Position.Y.Scale,
            self.MainFrame.Position.Y.Offset + 20
        )
    }):Play()
    
    for _, child in ipairs(self.MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, TweenInfo.new(0.15), {
                BackgroundTransparency = 1
            }):Play()
        end
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            TweenService:Create(child, TweenInfo.new(0.15), {
                TextTransparency = 1
            }):Play()
        end
        if child:IsA("ImageLabel") or child:IsA("ImageButton") then
            TweenService:Create(child, TweenInfo.new(0.15), {
                ImageTransparency = 1
            }):Play()
        end
    end
    
    task.delay(0.15, function()
        self.MainFrame.Visible = false
        self.ToggleButton.Visible = true
        self.ToggleButton.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 42, 0, 42)
        }):Play()
    end)
end

function Window:Restore()
    if not self.IsMinimized then return end
    self.IsMinimized = false
    
    TweenService:Create(self.ToggleButton, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.delay(0.15, function()
        self.ToggleButton.Visible = false
        self.MainFrame.Visible = true
        
        local targetPos = UDim2.new(
            self.MainFrame.Position.X.Scale,
            self.MainFrame.Position.X.Offset,
            self.MainFrame.Position.Y.Scale,
            self.MainFrame.Position.Y.Offset - 20
        )
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0,
            Position = targetPos
        }):Play()
        
        for _, child in ipairs(self.MainFrame:GetDescendants()) do
            if child:IsA("Frame") and child.Name ~= "Shadow" then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = child:GetAttribute("OriginalTransparency") or 0
                }):Play()
            end
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    TextTransparency = 0
                }):Play()
            end
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    ImageTransparency = child:GetAttribute("OriginalImageTransparency") or 0
                }):Play()
            end
        end
    end)
end

function Window:SetVisible(visible)
    self.IsVisible = visible
    if visible then
        self:Restore()
    else
        self:Minimize()
    end
end

function Window:SetMinimizeIcon(iconName)
    self.MinimizeIcon = iconName
    self.IconLoader.SetIcon(self.ToggleIcon, iconName)
end

function Window:SetTogglePosition(position)
    local positions = {
        BottomRight = UDim2.new(1, -60, 1, -60),
        BottomLeft = UDim2.new(0, 18, 1, -60),
        TopRight = UDim2.new(1, -60, 0, 18),
        TopLeft = UDim2.new(0, 18, 0, 18)
    }
    
    if positions[position] then
        self.TogglePosition = position
        TweenService:Create(self.ToggleButton, TweenInfo.new(0.3), {
            Position = positions[position]
        }):Play()
    end
end

function Window:AddTab(name, options)
    local Tab = self.Library.Tab
    local tab = Tab.new(self, name, options)
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.ActiveTab then
        self.ActiveTab:SetActive(false)
    end
    self.ActiveTab = tab
    tab:SetActive(true)
end

function Window:Destroy()
    TweenService:Create(self.MainFrame, TweenInfo.new(0.2), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, self.Size.X.Offset * 0.95, 0, self.Size.Y.Offset * 0.95)
    }):Play()
    
    for _, child in ipairs(self.MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
    
    task.delay(0.2, function()
        self.ScreenGui:Destroy()
    end)
end

return Window
