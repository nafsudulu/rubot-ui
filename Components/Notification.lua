local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Notification = {}
Notification.__index = Notification

local NotificationContainer = nil
local ActiveNotifications = {}

local VariantConfig = {
    Info = {
        icon = "info",
        color = function(theme) return theme.Get("InfoColor") end
    },
    Success = {
        icon = "check-circle",
        color = function(theme) return theme.Get("SuccessColor") end
    },
    Warning = {
        icon = "alert-triangle",
        color = function(theme) return theme.Get("WarningColor") end
    },
    Error = {
        icon = "alert-circle",
        color = function(theme) return theme.Get("ErrorColor") end
    }
}

function Notification.Init(library)
    if NotificationContainer then return end
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = playerGui:FindFirstChild("RubotNotifications")
    if not screenGui then
        screenGui = library.Utils.createInstance("ScreenGui", {
            Name = "RubotNotifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 100,
            Parent = playerGui
        })
        
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
        elseif gethui then
            screenGui.Parent = gethui()
        end
    end
    
    NotificationContainer = library.Utils.createInstance("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 320, 1, -20),
        Position = UDim2.new(1, -330, 0, 10),
        Parent = screenGui
    })
    
    library.Utils.createInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8),
        Parent = NotificationContainer
    })
end

function Notification.Show(library, options)
    Notification.Init(library)
    
    local Theme = library.Theme
    local Utils = library.Utils
    local IconLoader = library.IconLoader
    
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local variant = options.Variant or "Info"
    local duration = options.Duration or 4
    local icon = options.Icon
    
    local config = VariantConfig[variant] or VariantConfig.Info
    local accentColor = config.color(Theme)
    icon = icon or config.icon
    
    local notification = Utils.createInstance("Frame", {
        Name = "Notification",
        BackgroundColor3 = Theme.Get("PrimaryColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        LayoutOrder = -tick(),
        Parent = NotificationContainer
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, Theme.Get("Radius")),
        Parent = notification
    })
    
    Utils.createInstance("UIStroke", {
        Color = Theme.Get("BorderColor"),
        Thickness = 1,
        Parent = notification
    })
    
    Utils.createShadow(notification, 4)
    
    local accentBar = Utils.createInstance("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, 0),
        Parent = notification
    })
    
    local content = Utils.createInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -3, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(0, 3, 0, 0),
        Parent = notification
    })
    
    Utils.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = content
    })
    
    local header = Utils.createInstance("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Parent = content
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = header
    })
    
    IconLoader.CreateIcon(icon, {
        Size = UDim2.new(0, 18, 0, 18),
        Color = accentColor,
        Transparency = 0,
        Parent = header
    })
    
    Utils.createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Get("TextColor"),
        TextSize = 13,
        Parent = header
    })
    
    if message and message ~= "" then
        Utils.createInstance("TextLabel", {
            Name = "Message",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.new(0, 0, 0, 24),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Theme.Get("TextMutedColor"),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = content
        })
    end
    
    local closeBtn = Utils.createInstance("TextButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 0, 10),
        Text = "",
        Parent = notification
    })
    
    local closeIcon = IconLoader.CreateIcon("x", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Theme.Get("TextMutedColor"),
        Transparency = 0,
        Parent = closeBtn
    })
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeIcon, TweenInfo.new(0.15), {
            ImageColor3 = Theme.Get("TextColor")
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeIcon, TweenInfo.new(0.15), {
            ImageColor3 = Theme.Get("TextMutedColor")
        }):Play()
    end)
    
    local function dismiss()
        TweenService:Create(notification, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.2, function()
            notification:Destroy()
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(dismiss)
    
    notification.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    if duration > 0 then
        task.delay(duration, function()
            if notification and notification.Parent then
                dismiss()
            end
        end)
    end
    
    table.insert(ActiveNotifications, notification)
    
    return {
        Dismiss = dismiss,
        Frame = notification
    }
end

function Notification.ClearAll()
    for _, notif in ipairs(ActiveNotifications) do
        if notif and notif.Parent then
            notif:Destroy()
        end
    end
    ActiveNotifications = {}
end

return Notification
