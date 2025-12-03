--[[
    Rubot UI Library
    Minimalist Linear-Inspired UI for Roblox Executors

    Usage:
    local UI = loadstring(game:HttpGet("..."))()
    local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    Icons.SetIconsType("geist")

    local Window = UI:Window({
        Title = "My UI",
        Icon = Icons.Image({ Icon = "terminal", Size = UDim2.new(0, 18, 0, 18) })
    })
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME (Linear-Inspired)
-- ═══════════════════════════════════════════════════════════════════════════════
local Theme = {
    BgPrimary = Color3.fromHex("FFFFFF"),
    BgSecondary = Color3.fromHex("F7F7F7"),
    Border = Color3.fromHex("E4E4E7"),
    TextPrimary = Color3.fromHex("1A1A1A"),
    TextSecondary = Color3.fromHex("636363"),
    Accent = Color3.fromHex("3A3A3A"),
    Hover = Color3.fromHex("F3F3F3"),
    Success = Color3.fromHex("10B981"),
    Error = Color3.fromHex("EF4444"),
    Warning = Color3.fromHex("F59E0B"),

    Font = Enum.Font.Gotham,
    FontMedium = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,

    CornerRadius = UDim.new(0, 4),
    CornerRadiusLarge = UDim.new(0, 6),

    Spacing = {
        XS = 4,
        SM = 6,
        MD = 8,
        LG = 10,
        XL = 12,
        XXL = 16,
        XXXL = 20,
    },

    TextSize = {
        Title = 18,
        Heading = 14,
        Body = 13,
        Small = 12,
    },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SIGNAL (Event System)
-- ═══════════════════════════════════════════════════════════════════════════════
local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._connections = {}
    return self
end

function Signal:Connect(callback)
    local connection = {
        Callback = callback,
        Connected = true,
    }

    function connection:Disconnect()
        connection.Connected = false
    end

    table.insert(self._connections, connection)
    return connection
end

function Signal:Fire(...)
    for _, connection in ipairs(self._connections) do
        if connection.Connected then
            task.spawn(connection.Callback, ...)
        end
    end
end

function Signal:Wait()
    local waitingCoroutine = coroutine.running()
    local connection
    connection = self:Connect(function(...)
        connection:Disconnect()
        task.spawn(waitingCoroutine, ...)
    end)
    return coroutine.yield()
end

function Signal:Destroy()
    for _, connection in ipairs(self._connections) do
        connection.Connected = false
    end
    self._connections = {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════════════════════════════════════
local Utils = {}

function Utils.Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.Tween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.1
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out

    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, easingStyle, easingDirection),
        properties
    )
    tween:Play()
    return tween
end

function Utils.ApplyCorner(frame, radius)
    radius = radius or Theme.CornerRadius
    return Utils.Create("UICorner", {
        CornerRadius = radius,
        Parent = frame,
    })
end

function Utils.ApplyStroke(frame, color, thickness)
    return Utils.Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Parent = frame,
    })
end

function Utils.ApplyPadding(frame, padding)
    padding = padding or Theme.Spacing.MD
    return Utils.Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = frame,
    })
end

function Utils.ApplyListLayout(frame, padding, direction, horizontalAlign, verticalAlign)
    return Utils.Create("UIListLayout", {
        Padding = UDim.new(0, padding or Theme.Spacing.LG),
        FillDirection = direction or Enum.FillDirection.Vertical,
        HorizontalAlignment = horizontalAlign or Enum.HorizontalAlignment.Left,
        VerticalAlignment = verticalAlign or Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = frame,
    })
end

function Utils.ApplyIcon(parent, iconData, size)
    size = size or 16
    if not iconData then return nil end

    -- New API: iconData is already an ImageLabel instance from Icons.Image()
    if typeof(iconData) == "Instance" and iconData:IsA("ImageLabel") then
        iconData.Size = UDim2.new(0, size, 0, size)
        iconData.BackgroundTransparency = 1
        iconData.Parent = parent
        return iconData
    end

    -- Legacy API: iconData is {Image, {ImageRectSize, ImageRectPosition}}
    if type(iconData) == "table" and iconData[1] then
        local icon = Utils.Create("ImageLabel", {
            Size = UDim2.new(0, size, 0, size),
            BackgroundTransparency = 1,
            Image = iconData[1],
            ImageRectSize = iconData[2] and iconData[2].ImageRectSize or Vector2.new(0, 0),
            ImageRectOffset = iconData[2] and iconData[2].ImageRectPosition or Vector2.new(0, 0),
            ImageColor3 = Theme.TextPrimary,
            Parent = parent,
        })
        return icon
    end

    return nil
end

function Utils.MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════
local function CreateWindow(library, config)
    config = config or {}
    local title = config.Title or "Window"
    local icon = config.Icon
    local size = config.Size or UDim2.new(0, 500, 0, 350)
    local canDrag = config.CanDrag ~= false
    local defaultOpen = config.DefaultOpen ~= false

    local window = {}
    window.Tabs = {}
    window.VisibleChanged = Signal.new()

    local screenGui = Utils.Create("ScreenGui", {
        Name = "RubotUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Player:WaitForChild("PlayerGui"),
    })

    local mainFrame = Utils.Create("Frame", {
        Name = "MainFrame",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        Visible = defaultOpen,
        Parent = screenGui,
    })
    Utils.ApplyCorner(mainFrame, Theme.CornerRadiusLarge)
    Utils.ApplyStroke(mainFrame)

    local shadow = Utils.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = mainFrame,
    })

    local topbar = Utils.Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = mainFrame,
    })

    local topbarContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -Theme.Spacing.XXL * 2, 1, 0),
        Position = UDim2.new(0, Theme.Spacing.XXL, 0, 0),
        BackgroundTransparency = 1,
        Parent = topbar,
    })
    Utils.ApplyListLayout(topbarContent, Theme.Spacing.MD, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Center)

    if icon then
        Utils.ApplyIcon(topbarContent, icon, 18)
    end

    local titleLabel = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Title,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topbarContent,
    })

    local divider = Utils.Create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })

    local contentArea = Utils.Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -41),
        Position = UDim2.new(0, 0, 0, 41),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = mainFrame,
    })

    local sidebar = Utils.Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, 0),
        BackgroundColor3 = Theme.BgSecondary,
        BorderSizePixel = 0,
        Parent = contentArea,
    })
    Utils.ApplyCorner(sidebar, Theme.CornerRadiusLarge)
    Utils.ApplyPadding(sidebar, Theme.Spacing.MD)

    local tabList = Utils.Create("Frame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = sidebar,
    })
    Utils.ApplyListLayout(tabList, Theme.Spacing.SM)

    local sidebarDivider = Utils.Create("Frame", {
        Name = "SidebarDivider",
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(0, 140, 0, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = contentArea,
    })

    local tabContent = Utils.Create("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -141, 1, 0),
        Position = UDim2.new(0, 141, 0, 0),
        BackgroundTransparency = 1,
        Parent = contentArea,
    })
    Utils.ApplyPadding(tabContent, Theme.Spacing.XXL)

    local toggleButton = Utils.Create("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -60, 1, -60),
        BackgroundColor3 = Theme.Accent,
        Text = "",
        AutoButtonColor = false,
        Parent = screenGui,
    })
    Utils.ApplyCorner(toggleButton, Theme.CornerRadiusLarge)

    local toggleIcon = Utils.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = defaultOpen and "-" or "+",
        TextColor3 = Theme.BgPrimary,
        TextSize = 24,
        Font = Theme.FontBold,
        Parent = toggleButton,
    })

    if canDrag then
        Utils.MakeDraggable(mainFrame, topbar)
    end

    toggleButton.MouseButton1Click:Connect(function()
        local visible = not mainFrame.Visible
        mainFrame.Visible = visible
        toggleIcon.Text = visible and "-" or "+"
        window.VisibleChanged:Fire(visible)
    end)

    function window:SetTitle(text)
        titleLabel.Text = text
    end

    function window:SetIcon(iconData)
        for _, child in ipairs(topbarContent:GetChildren()) do
            if child:IsA("ImageLabel") then
                child:Destroy()
            end
        end
        if iconData then
            local newIcon = Utils.ApplyIcon(topbarContent, iconData, 18)
            newIcon.LayoutOrder = -1
        end
    end

    function window:SetVisible(visible)
        mainFrame.Visible = visible
        toggleIcon.Text = visible and "-" or "+"
        window.VisibleChanged:Fire(visible)
    end

    function window:IsVisible()
        return mainFrame.Visible
    end

    function window:MoveTo(position)
        mainFrame.Position = UDim2.new(0, position.X, 0, position.Y)
    end

    function window:GetPosition()
        return Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
    end

    function window:Destroy()
        window.VisibleChanged:Destroy()
        screenGui:Destroy()
    end

    function window:Tab(tabConfig)
        return CreateTab(window, tabList, tabContent, tabConfig)
    end

    window._mainFrame = mainFrame
    window._screenGui = screenGui
    window._tabContent = tabContent

    return window
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: TAB
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateTab(window, tabList, tabContentArea, config)
    config = config or {}
    local title = config.Title or "Tab"
    local icon = config.Icon
    local isDefault = config.Default

    local tab = {}
    tab.Selected = Signal.new()

    local tabButton = Utils.Create("TextButton", {
        Name = title,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.BgPrimary,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = tabList,
    })
    Utils.ApplyCorner(tabButton)

    local tabButtonContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -Theme.Spacing.MD * 2, 1, 0),
        Position = UDim2.new(0, Theme.Spacing.MD, 0, 0),
        BackgroundTransparency = 1,
        Parent = tabButton,
    })
    Utils.ApplyListLayout(tabButtonContent, Theme.Spacing.MD, Enum.FillDirection.Horizontal,
        Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)

    local indicator = Utils.Create("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 3, 0, 16),
        Position = UDim2.new(0, 0, 0.5, -8),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Visible = false,
        Parent = tabButton,
    })
    Utils.ApplyCorner(indicator, UDim.new(0, 2))

    local tabIcon
    if icon then
        tabIcon = Utils.ApplyIcon(tabButtonContent, icon, 16)
    end

    local tabTitle = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -24, 1, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.TextSecondary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabButtonContent,
    })

    local contentFrame = Utils.Create("ScrollingFrame", {
        Name = title .. "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = tabContentArea,
    })
    Utils.ApplyListLayout(contentFrame, Theme.Spacing.XXL)

    table.insert(window.Tabs, tab)

    local function selectTab()
        for _, t in ipairs(window.Tabs) do
            if t ~= tab then
                t:_deselect()
            end
        end
        indicator.Visible = true
        tabTitle.TextColor3 = Theme.TextPrimary
        tabButton.BackgroundTransparency = 0
        contentFrame.Visible = true
        tab.Selected:Fire()
    end

    function tab:_deselect()
        indicator.Visible = false
        tabTitle.TextColor3 = Theme.TextSecondary
        tabButton.BackgroundTransparency = 1
        contentFrame.Visible = false
    end

    function tab:Select()
        selectTab()
    end

    function tab:IsSelected()
        return indicator.Visible
    end

    function tab:SetTitle(text)
        tabTitle.Text = text
        tabButton.Name = text
        contentFrame.Name = text .. "Content"
    end

    function tab:SetIcon(iconData)
        if tabIcon then
            tabIcon:Destroy()
        end
        if iconData then
            tabIcon = Utils.ApplyIcon(tabButtonContent, iconData, 16)
            tabIcon.LayoutOrder = -1
        end
    end

    function tab:Destroy()
        tab.Selected:Destroy()
        tabButton:Destroy()
        contentFrame:Destroy()
        for i, t in ipairs(window.Tabs) do
            if t == tab then
                table.remove(window.Tabs, i)
                break
            end
        end
    end

    function tab:Section(sectionTitle)
        return CreateSection(contentFrame, sectionTitle)
    end

    tabButton.MouseButton1Click:Connect(selectTab)

    tabButton.MouseEnter:Connect(function()
        if not tab:IsSelected() then
            Utils.Tween(tabButton, { BackgroundTransparency = 0.5 }, 0.05)
        end
    end)

    tabButton.MouseLeave:Connect(function()
        if not tab:IsSelected() then
            Utils.Tween(tabButton, { BackgroundTransparency = 1 }, 0.05)
        end
    end)

    tab._button = tabButton
    tab._content = contentFrame

    if isDefault or #window.Tabs == 1 then
        selectTab()
    end

    return tab
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: SECTION
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateSection(parent, sectionTitle)
    local section = {}

    local sectionFrame = Utils.Create("Frame", {
        Name = sectionTitle or "Section",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local sectionContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = sectionFrame,
    })
    Utils.ApplyListLayout(sectionContent, Theme.Spacing.LG)

    if sectionTitle then
        local titleLabel = Utils.Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = sectionTitle,
            TextColor3 = Theme.TextSecondary,
            TextSize = Theme.TextSize.Small,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = -1,
            Parent = sectionContent,
        })

        function section:SetTitle(text)
            titleLabel.Text = text
        end
    else
        function section:SetTitle() end
    end

    function section:Destroy()
        sectionFrame:Destroy()
    end

    function section:Button(config)
        return CreateButton(sectionContent, config)
    end

    function section:Toggle(config)
        return CreateToggle(sectionContent, config)
    end

    function section:Input(config)
        return CreateInput(sectionContent, config)
    end

    function section:Slider(config)
        return CreateSlider(sectionContent, config)
    end

    function section:Dropdown(config)
        return CreateDropdown(sectionContent, config)
    end

    function section:MultiDropdown(config)
        return CreateMultiDropdown(sectionContent, config)
    end

    function section:Title(text)
        return CreateTitle(sectionContent, text)
    end

    function section:Description(text)
        return CreateDescription(sectionContent, text)
    end

    section._frame = sectionFrame
    section._content = sectionContent

    return section
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: BUTTON
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateButton(parent, config)
    config = config or {}
    local text = config.Text or "Button"
    local icon = config.Icon
    local disabled = config.Disabled or false

    local button = {}
    button.Clicked = Signal.new()

    local buttonFrame = Utils.Create("TextButton", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.BgSecondary,
        Text = "",
        AutoButtonColor = false,
        Parent = parent,
    })
    Utils.ApplyCorner(buttonFrame)

    local buttonContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = buttonFrame,
    })
    Utils.ApplyListLayout(buttonContent, Theme.Spacing.MD, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment
    .Center, Enum.VerticalAlignment.Center)

    local buttonIcon
    if icon then
        buttonIcon = Utils.ApplyIcon(buttonContent, icon, 16)
    end

    local buttonText = Utils.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        Parent = buttonContent,
    })

    local function updateState()
        if disabled then
            buttonFrame.BackgroundColor3 = Theme.BgSecondary
            buttonText.TextColor3 = Theme.TextSecondary
            if buttonIcon then
                buttonIcon.ImageColor3 = Theme.TextSecondary
            end
        else
            buttonFrame.BackgroundColor3 = Theme.BgSecondary
            buttonText.TextColor3 = Theme.TextPrimary
            if buttonIcon then
                buttonIcon.ImageColor3 = Theme.TextPrimary
            end
        end
    end

    buttonFrame.MouseButton1Click:Connect(function()
        if not disabled then
            Utils.Tween(buttonFrame, { Size = UDim2.new(1, 0, 0, 34) }, 0.05)
            task.wait(0.05)
            Utils.Tween(buttonFrame, { Size = UDim2.new(1, 0, 0, 36) }, 0.05)
            button.Clicked:Fire()
        end
    end)

    buttonFrame.MouseEnter:Connect(function()
        if not disabled then
            Utils.Tween(buttonFrame, { BackgroundColor3 = Theme.Hover }, 0.05)
        end
    end)

    buttonFrame.MouseLeave:Connect(function()
        Utils.Tween(buttonFrame, { BackgroundColor3 = Theme.BgSecondary }, 0.05)
    end)

    function button:SetText(newText)
        buttonText.Text = newText
        buttonFrame.Name = newText
    end

    function button:SetIcon(iconData)
        if buttonIcon then
            buttonIcon:Destroy()
        end
        if iconData then
            buttonIcon = Utils.ApplyIcon(buttonContent, iconData, 16)
            buttonIcon.LayoutOrder = -1
        end
    end

    function button:SetDisabled(state)
        disabled = state
        updateState()
    end

    function button:IsDisabled()
        return disabled
    end

    function button:SetVisible(visible)
        buttonFrame.Visible = visible
    end

    function button:IsVisible()
        return buttonFrame.Visible
    end

    function button:Destroy()
        button.Clicked:Destroy()
        buttonFrame:Destroy()
    end

    updateState()
    button._frame = buttonFrame

    return button
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: TOGGLE
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateToggle(parent, config)
    config = config or {}
    local text = config.Text or "Toggle"
    local default = config.Default or false

    local toggle = {}
    toggle.Changed = Signal.new()
    local state = default

    local toggleFrame = Utils.Create("TextButton", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = parent,
    })

    local toggleContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = toggleFrame,
    })

    local toggleText = Utils.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleContent,
    })

    local track = Utils.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(0, 36, 0, 20),
        Position = UDim2.new(1, -36, 0.5, -10),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = toggleContent,
    })
    Utils.ApplyCorner(track, UDim.new(0, 10))

    local handle = Utils.Create("Frame", {
        Name = "Handle",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        Parent = track,
    })
    Utils.ApplyCorner(handle, UDim.new(0, 8))

    local function updateVisual()
        if state then
            Utils.Tween(track, { BackgroundColor3 = Theme.Accent }, 0.1)
            Utils.Tween(handle, { Position = UDim2.new(0, 18, 0.5, -8) }, 0.1)
        else
            Utils.Tween(track, { BackgroundColor3 = Theme.Border }, 0.1)
            Utils.Tween(handle, { Position = UDim2.new(0, 2, 0.5, -8) }, 0.1)
        end
    end

    toggleFrame.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        toggle.Changed:Fire(state)
    end)

    function toggle:Set(value)
        state = value
        updateVisual()
        toggle.Changed:Fire(state)
    end

    function toggle:Get()
        return state
    end

    function toggle:SetText(newText)
        toggleText.Text = newText
        toggleFrame.Name = newText
    end

    function toggle:SetVisible(visible)
        toggleFrame.Visible = visible
    end

    function toggle:IsVisible()
        return toggleFrame.Visible
    end

    function toggle:Destroy()
        toggle.Changed:Destroy()
        toggleFrame:Destroy()
    end

    updateVisual()
    toggle._frame = toggleFrame

    return toggle
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: INPUT
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateInput(parent, config)
    config = config or {}
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local numeric = config.Numeric or false
    local clearOnFocus = config.ClearTextOnFocus or false

    local input = {}
    input.Changed = Signal.new()
    input.Submitted = Signal.new()

    local inputFrame = Utils.Create("Frame", {
        Name = "Input",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        Parent = parent,
    })
    Utils.ApplyCorner(inputFrame)
    Utils.ApplyStroke(inputFrame)

    local textBox = Utils.Create("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(1, -Theme.Spacing.XXL, 1, 0),
        Position = UDim2.new(0, Theme.Spacing.MD, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.TextSecondary,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = clearOnFocus,
        Parent = inputFrame,
    })

    local stroke = inputFrame:FindFirstChild("UIStroke")

    textBox.Focused:Connect(function()
        if stroke then
            Utils.Tween(stroke, { Color = Theme.Accent }, 0.1)
        end
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if stroke then
            Utils.Tween(stroke, { Color = Theme.Border }, 0.1)
        end
        if enterPressed then
            input.Submitted:Fire(textBox.Text)
        end
    end)

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if numeric then
            local filtered = textBox.Text:gsub("[^%d%.%-]", "")
            if filtered ~= textBox.Text then
                textBox.Text = filtered
            end
        end
        input.Changed:Fire(textBox.Text)
    end)

    function input:Set(text)
        textBox.Text = text
    end

    function input:Get()
        return textBox.Text
    end

    function input:SetPlaceholder(text)
        textBox.PlaceholderText = text
    end

    function input:SetVisible(visible)
        inputFrame.Visible = visible
    end

    function input:IsVisible()
        return inputFrame.Visible
    end

    function input:Destroy()
        input.Changed:Destroy()
        input.Submitted:Destroy()
        inputFrame:Destroy()
    end

    input._frame = inputFrame

    return input
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: SLIDER
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateSlider(parent, config)
    config = config or {}
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local step = config.Step or 1
    local formatFunc = config.Format or function(v) return tostring(v) end

    local slider = {}
    slider.Changed = Signal.new()
    slider.Released = Signal.new()
    local value = math.clamp(default, min, max)
    local dragging = false

    local sliderFrame = Utils.Create("Frame", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    local labelRow = Utils.Create("Frame", {
        Name = "LabelRow",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = sliderFrame,
    })

    local sliderText = Utils.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = labelRow,
    })

    local valueLabel = Utils.Create("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = formatFunc(value),
        TextColor3 = Theme.TextSecondary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = labelRow,
    })

    local trackFrame = Utils.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = sliderFrame,
    })
    Utils.ApplyCorner(trackFrame, UDim.new(0, 2))

    local fill = Utils.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = trackFrame,
    })
    Utils.ApplyCorner(fill, UDim.new(0, 2))

    local handle = Utils.Create("Frame", {
        Name = "Handle",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = trackFrame,
    })
    Utils.ApplyCorner(handle, UDim.new(0, 6))

    local hitArea = Utils.Create("TextButton", {
        Name = "HitArea",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "",
        Parent = sliderFrame,
    })

    local function updateSlider(inputX)
        local trackAbsPos = trackFrame.AbsolutePosition.X
        local trackAbsSize = trackFrame.AbsoluteSize.X
        local relative = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)

        local rawValue = min + (max - min) * relative
        local steppedValue = math.floor(rawValue / step + 0.5) * step
        value = math.clamp(steppedValue, min, max)

        local percent = (value - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(percent, -6, 0.5, -6)
        valueLabel.Text = formatFunc(value)

        slider.Changed:Fire(value)
    end

    hitArea.MouseButton1Down:Connect(function()
        dragging = true
        updateSlider(Mouse.X)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            slider.Released:Fire(value)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            updateSlider(Mouse.X)
        end
    end)

    function slider:Set(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(percent, -6, 0.5, -6)
        valueLabel.Text = formatFunc(value)
        slider.Changed:Fire(value)
    end

    function slider:Get()
        return value
    end

    function slider:SetText(newText)
        sliderText.Text = newText
        sliderFrame.Name = newText
    end

    function slider:SetVisible(visible)
        sliderFrame.Visible = visible
    end

    function slider:IsVisible()
        return sliderFrame.Visible
    end

    function slider:Destroy()
        slider.Changed:Destroy()
        slider.Released:Destroy()
        sliderFrame:Destroy()
    end

    slider._frame = sliderFrame

    return slider
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: DROPDOWN
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateDropdown(parent, config)
    config = config or {}
    local text = config.Text or "Dropdown"
    local options = config.Options or {}
    local default = config.Default
    local searchable = config.Searchable or false

    local dropdown = {}
    dropdown.Changed = Signal.new()
    local selected = default
    local isOpen = false

    local dropdownFrame = Utils.Create("Frame", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = parent,
    })

    local labelText = Utils.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdownFrame,
    })

    local selector = Utils.Create("TextButton", {
        Name = "Selector",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = Theme.BgPrimary,
        Text = "",
        AutoButtonColor = false,
        Parent = dropdownFrame,
    })
    Utils.ApplyCorner(selector)
    Utils.ApplyStroke(selector)

    local selectorContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -Theme.Spacing.XXL, 1, 0),
        Position = UDim2.new(0, Theme.Spacing.MD, 0, 0),
        BackgroundTransparency = 1,
        Parent = selector,
    })

    local selectedText = Utils.Create("TextLabel", {
        Name = "Selected",
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = selected or "Select...",
        TextColor3 = selected and Theme.TextPrimary or Theme.TextSecondary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = selectorContent,
    })

    local arrow = Utils.Create("TextLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 16, 1, 0),
        Position = UDim2.new(1, -16, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Theme.TextSecondary,
        TextSize = 10,
        Font = Theme.Font,
        Parent = selectorContent,
    })

    local optionsContainer = Utils.Create("Frame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        ClipsDescendants = true,
        Parent = dropdownFrame,
    })
    Utils.ApplyCorner(optionsContainer)
    Utils.ApplyStroke(optionsContainer)

    local optionsList = Utils.Create("ScrollingFrame", {
        Name = "List",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 10,
        Parent = optionsContainer,
    })
    Utils.ApplyListLayout(optionsList, 0)
    Utils.ApplyPadding(optionsList, Theme.Spacing.SM)

    local function createOption(optionText)
        local optionButton = Utils.Create("TextButton", {
            Name = optionText,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.BgPrimary,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 10,
            Parent = optionsList,
        })
        Utils.ApplyCorner(optionButton)

        local optionLabel = Utils.Create("TextLabel", {
            Size = UDim2.new(1, -Theme.Spacing.MD * 2, 1, 0),
            Position = UDim2.new(0, Theme.Spacing.MD, 0, 0),
            BackgroundTransparency = 1,
            Text = optionText,
            TextColor3 = Theme.TextPrimary,
            TextSize = Theme.TextSize.Body,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 10,
            Parent = optionButton,
        })

        optionButton.MouseEnter:Connect(function()
            Utils.Tween(optionButton, { BackgroundTransparency = 0, BackgroundColor3 = Theme.Hover }, 0.05)
        end)

        optionButton.MouseLeave:Connect(function()
            Utils.Tween(optionButton, { BackgroundTransparency = 1 }, 0.05)
        end)

        optionButton.MouseButton1Click:Connect(function()
            selected = optionText
            selectedText.Text = optionText
            selectedText.TextColor3 = Theme.TextPrimary
            isOpen = false
            optionsContainer.Visible = false
            arrow.Text = "▼"
            dropdown.Changed:Fire(selected)
        end)

        return optionButton
    end

    local function refreshOptions()
        for _, child in ipairs(optionsList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for _, opt in ipairs(options) do
            createOption(opt)
        end
        local height = math.min(#options * 30 + Theme.Spacing.SM * 2, 150)
        optionsContainer.Size = UDim2.new(1, 0, 0, height)
    end

    refreshOptions()

    selector.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsContainer.Visible = isOpen
        arrow.Text = isOpen and "▲" or "▼"
    end)

    function dropdown:Set(value)
        selected = value
        selectedText.Text = value or "Select..."
        selectedText.TextColor3 = value and Theme.TextPrimary or Theme.TextSecondary
        dropdown.Changed:Fire(selected)
    end

    function dropdown:Get()
        return selected
    end

    function dropdown:SetOptions(newOptions)
        options = newOptions
        refreshOptions()
    end

    function dropdown:AddOption(option)
        table.insert(options, option)
        refreshOptions()
    end

    function dropdown:RemoveOption(option)
        for i, opt in ipairs(options) do
            if opt == option then
                table.remove(options, i)
                break
            end
        end
        refreshOptions()
    end

    function dropdown:SetVisible(visible)
        dropdownFrame.Visible = visible
    end

    function dropdown:IsVisible()
        return dropdownFrame.Visible
    end

    function dropdown:Destroy()
        dropdown.Changed:Destroy()
        dropdownFrame:Destroy()
    end

    dropdown._frame = dropdownFrame

    return dropdown
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: MULTI DROPDOWN
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateMultiDropdown(parent, config)
    config = config or {}
    local text = config.Text or "Multi Dropdown"
    local options = config.Options or {}
    local default = config.Default or {}

    local multiDropdown = {}
    multiDropdown.Changed = Signal.new()
    local selected = {}
    for _, v in ipairs(default) do
        selected[v] = true
    end
    local isOpen = false

    local dropdownFrame = Utils.Create("Frame", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = parent,
    })

    local labelText = Utils.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdownFrame,
    })

    local selector = Utils.Create("TextButton", {
        Name = "Selector",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = Theme.BgPrimary,
        Text = "",
        AutoButtonColor = false,
        Parent = dropdownFrame,
    })
    Utils.ApplyCorner(selector)
    Utils.ApplyStroke(selector)

    local selectorContent = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -Theme.Spacing.XXL, 1, 0),
        Position = UDim2.new(0, Theme.Spacing.MD, 0, 0),
        BackgroundTransparency = 1,
        Parent = selector,
    })

    local function getSelectedText()
        local list = {}
        for opt, _ in pairs(selected) do
            table.insert(list, opt)
        end
        if #list == 0 then
            return "Select..."
        end
        return table.concat(list, ", ")
    end

    local selectedTextLabel = Utils.Create("TextLabel", {
        Name = "Selected",
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = getSelectedText(),
        TextColor3 = next(selected) and Theme.TextPrimary or Theme.TextSecondary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = selectorContent,
    })

    local arrow = Utils.Create("TextLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 16, 1, 0),
        Position = UDim2.new(1, -16, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Theme.TextSecondary,
        TextSize = 10,
        Font = Theme.Font,
        Parent = selectorContent,
    })

    local optionsContainer = Utils.Create("Frame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        ClipsDescendants = true,
        Parent = dropdownFrame,
    })
    Utils.ApplyCorner(optionsContainer)
    Utils.ApplyStroke(optionsContainer)

    local optionsList = Utils.Create("ScrollingFrame", {
        Name = "List",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 10,
        Parent = optionsContainer,
    })
    Utils.ApplyListLayout(optionsList, 0)
    Utils.ApplyPadding(optionsList, Theme.Spacing.SM)

    local optionButtons = {}

    local function updateSelectedText()
        selectedTextLabel.Text = getSelectedText()
        selectedTextLabel.TextColor3 = next(selected) and Theme.TextPrimary or Theme.TextSecondary
    end

    local function getSelectedTable()
        local list = {}
        for opt, _ in pairs(selected) do
            table.insert(list, opt)
        end
        return list
    end

    local function createOption(optionText)
        local optionButton = Utils.Create("TextButton", {
            Name = optionText,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.BgPrimary,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 10,
            Parent = optionsList,
        })
        Utils.ApplyCorner(optionButton)

        local checkbox = Utils.Create("Frame", {
            Name = "Checkbox",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, Theme.Spacing.MD, 0.5, -8),
            BackgroundColor3 = selected[optionText] and Theme.Accent or Theme.BgPrimary,
            BorderSizePixel = 0,
            ZIndex = 10,
            Parent = optionButton,
        })
        Utils.ApplyCorner(checkbox)
        Utils.ApplyStroke(checkbox, selected[optionText] and Theme.Accent or Theme.Border)

        local checkmark = Utils.Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "✓",
            TextColor3 = Theme.BgPrimary,
            TextSize = 12,
            Font = Theme.FontBold,
            Visible = selected[optionText] or false,
            ZIndex = 10,
            Parent = checkbox,
        })

        local optionLabel = Utils.Create("TextLabel", {
            Size = UDim2.new(1, -Theme.Spacing.MD * 2 - 24, 1, 0),
            Position = UDim2.new(0, Theme.Spacing.MD + 24, 0, 0),
            BackgroundTransparency = 1,
            Text = optionText,
            TextColor3 = Theme.TextPrimary,
            TextSize = Theme.TextSize.Body,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 10,
            Parent = optionButton,
        })

        optionButton.MouseEnter:Connect(function()
            Utils.Tween(optionButton, { BackgroundTransparency = 0, BackgroundColor3 = Theme.Hover }, 0.05)
        end)

        optionButton.MouseLeave:Connect(function()
            Utils.Tween(optionButton, { BackgroundTransparency = 1 }, 0.05)
        end)

        optionButton.MouseButton1Click:Connect(function()
            if selected[optionText] then
                selected[optionText] = nil
                checkbox.BackgroundColor3 = Theme.BgPrimary
                checkbox:FindFirstChild("UIStroke").Color = Theme.Border
                checkmark.Visible = false
            else
                selected[optionText] = true
                checkbox.BackgroundColor3 = Theme.Accent
                checkbox:FindFirstChild("UIStroke").Color = Theme.Accent
                checkmark.Visible = true
            end
            updateSelectedText()
            multiDropdown.Changed:Fire(getSelectedTable())
        end)

        optionButtons[optionText] = { button = optionButton, checkbox = checkbox, checkmark = checkmark }
        return optionButton
    end

    local function refreshOptions()
        for _, child in ipairs(optionsList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        optionButtons = {}
        for _, opt in ipairs(options) do
            createOption(opt)
        end
        local height = math.min(#options * 30 + Theme.Spacing.SM * 2, 150)
        optionsContainer.Size = UDim2.new(1, 0, 0, height)
    end

    refreshOptions()

    selector.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsContainer.Visible = isOpen
        arrow.Text = isOpen and "▲" or "▼"
    end)

    function multiDropdown:Set(list)
        selected = {}
        for _, v in ipairs(list) do
            selected[v] = true
        end
        for optText, data in pairs(optionButtons) do
            if selected[optText] then
                data.checkbox.BackgroundColor3 = Theme.Accent
                data.checkbox:FindFirstChild("UIStroke").Color = Theme.Accent
                data.checkmark.Visible = true
            else
                data.checkbox.BackgroundColor3 = Theme.BgPrimary
                data.checkbox:FindFirstChild("UIStroke").Color = Theme.Border
                data.checkmark.Visible = false
            end
        end
        updateSelectedText()
        multiDropdown.Changed:Fire(getSelectedTable())
    end

    function multiDropdown:Get()
        return getSelectedTable()
    end

    function multiDropdown:AddOption(option)
        table.insert(options, option)
        refreshOptions()
    end

    function multiDropdown:RemoveOption(option)
        for i, opt in ipairs(options) do
            if opt == option then
                table.remove(options, i)
                break
            end
        end
        selected[option] = nil
        refreshOptions()
        updateSelectedText()
    end

    function multiDropdown:Clear()
        selected = {}
        for optText, data in pairs(optionButtons) do
            data.checkbox.BackgroundColor3 = Theme.BgPrimary
            data.checkbox:FindFirstChild("UIStroke").Color = Theme.Border
            data.checkmark.Visible = false
        end
        updateSelectedText()
        multiDropdown.Changed:Fire({})
    end

    function multiDropdown:SetVisible(visible)
        dropdownFrame.Visible = visible
    end

    function multiDropdown:IsVisible()
        return dropdownFrame.Visible
    end

    function multiDropdown:Destroy()
        multiDropdown.Changed:Destroy()
        dropdownFrame:Destroy()
    end

    multiDropdown._frame = dropdownFrame

    return multiDropdown
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: TITLE
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateTitle(parent, text)
    local title = {}

    local titleLabel = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = text or "Title",
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Heading,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent,
    })

    function title:Set(newText)
        titleLabel.Text = newText
    end

    function title:SetVisible(visible)
        titleLabel.Visible = visible
    end

    function title:IsVisible()
        return titleLabel.Visible
    end

    function title:Destroy()
        titleLabel:Destroy()
    end

    title._label = titleLabel

    return title
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: DESCRIPTION
-- ═══════════════════════════════════════════════════════════════════════════════
function CreateDescription(parent, text)
    local description = {}

    local descLabel = Utils.Create("TextLabel", {
        Name = "Description",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = text or "Description",
        TextColor3 = Theme.TextSecondary,
        TextSize = Theme.TextSize.Small,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = parent,
    })

    function description:Set(newText)
        descLabel.Text = newText
    end

    function description:SetVisible(visible)
        descLabel.Visible = visible
    end

    function description:IsVisible()
        return descLabel.Visible
    end

    function description:Destroy()
        descLabel:Destroy()
    end

    description._label = descLabel

    return description
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: TOAST
-- ═══════════════════════════════════════════════════════════════════════════════
local toastContainer = nil

local function CreateToast(screenGui, config)
    config = config or {}
    local title = config.Title or "Toast"
    local description = config.Description or ""
    local toastType = config.Type or "info"
    local duration = config.Duration or 3
    local icon = config.Icon

    local colors = {
        success = Theme.Success,
        error = Theme.Error,
        info = Theme.Accent,
        warning = Theme.Warning,
    }
    local accentColor = colors[toastType] or Theme.Accent

    if not toastContainer then
        toastContainer = Utils.Create("Frame", {
            Name = "ToastContainer",
            Size = UDim2.new(0, 300, 1, -40),
            Position = UDim2.new(1, -320, 0, 20),
            BackgroundTransparency = 1,
            Parent = screenGui,
        })
        Utils.ApplyListLayout(toastContainer, Theme.Spacing.MD, Enum.FillDirection.Vertical,
            Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    end

    local toastFrame = Utils.Create("Frame", {
        Name = "Toast",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = toastContainer,
    })
    Utils.ApplyCorner(toastFrame)
    Utils.ApplyStroke(toastFrame)

    local accentBar = Utils.Create("Frame", {
        Name = "Accent",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = toastFrame,
    })
    Utils.ApplyCorner(accentBar, UDim.new(0, 2))

    local content = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -Theme.Spacing.XXL - 4, 0, 0),
        Position = UDim2.new(0, Theme.Spacing.MD + 4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = toastFrame,
    })
    Utils.ApplyPadding(content, Theme.Spacing.MD)
    Utils.ApplyListLayout(content, Theme.Spacing.SM)

    local titleRow = Utils.Create("Frame", {
        Name = "TitleRow",
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Parent = content,
    })
    Utils.ApplyListLayout(titleRow, Theme.Spacing.SM, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Center)

    if icon then
        local iconImg = Utils.ApplyIcon(titleRow, icon, 16)
        iconImg.ImageColor3 = accentColor
    end

    local titleLabel = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 0, 0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontBold,
        Parent = titleRow,
    })

    if description ~= "" then
        local descLabel = Utils.Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = Theme.TextSecondary,
            TextSize = Theme.TextSize.Small,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = content,
        })
    end

    Utils.Tween(toastFrame, { BackgroundTransparency = 0 }, 0.15)

    task.delay(duration, function()
        Utils.Tween(toastFrame, { BackgroundTransparency = 1 }, 0.15)
        task.wait(0.15)
        toastFrame:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPONENT: MODAL
-- ═══════════════════════════════════════════════════════════════════════════════
local function CreateModal(screenGui, config)
    config = config or {}
    local title = config.Title or "Modal"
    local description = config.Description or ""
    local confirmText = config.ConfirmText or "Confirm"
    local cancelText = config.CancelText or "Cancel"
    local icon = config.Icon

    local modal = {}

    local overlay = Utils.Create("TextButton", {
        Name = "ModalOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 100,
        Parent = screenGui,
    })

    local modalFrame = Utils.Create("Frame", {
        Name = "Modal",
        Size = UDim2.new(0, 340, 0, 0),
        Position = UDim2.new(0.5, -170, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.BgPrimary,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = screenGui,
    })
    Utils.ApplyCorner(modalFrame, Theme.CornerRadiusLarge)

    local shadow = Utils.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = 100,
        Parent = modalFrame,
    })

    local content = Utils.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = modalFrame,
    })
    Utils.ApplyPadding(content, Theme.Spacing.XXXL)
    Utils.ApplyListLayout(content, Theme.Spacing.XL)

    local headerRow = Utils.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = content,
    })
    Utils.ApplyListLayout(headerRow, Theme.Spacing.MD, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Center)

    if icon then
        local iconImg = Utils.ApplyIcon(headerRow, icon, 20)
        iconImg.ZIndex = 101
    end

    local titleLabel = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Title,
        Font = Theme.FontBold,
        ZIndex = 101,
        Parent = headerRow,
    })

    if description ~= "" then
        local descLabel = Utils.Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = Theme.TextSecondary,
            TextSize = Theme.TextSize.Body,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 101,
            Parent = content,
        })
    end

    local buttonRow = Utils.Create("Frame", {
        Name = "Buttons",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = content,
    })
    Utils.ApplyListLayout(buttonRow, Theme.Spacing.MD, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right,
        Enum.VerticalAlignment.Center)

    local cancelButton = Utils.Create("TextButton", {
        Name = "Cancel",
        Size = UDim2.new(0, 80, 0, 36),
        BackgroundColor3 = Theme.BgSecondary,
        Text = cancelText,
        TextColor3 = Theme.TextPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        AutoButtonColor = false,
        ZIndex = 101,
        LayoutOrder = 1,
        Parent = buttonRow,
    })
    Utils.ApplyCorner(cancelButton)

    local confirmButton = Utils.Create("TextButton", {
        Name = "Confirm",
        Size = UDim2.new(0, 80, 0, 36),
        BackgroundColor3 = Theme.Accent,
        Text = confirmText,
        TextColor3 = Theme.BgPrimary,
        TextSize = Theme.TextSize.Body,
        Font = Theme.FontMedium,
        AutoButtonColor = false,
        ZIndex = 101,
        LayoutOrder = 2,
        Parent = buttonRow,
    })
    Utils.ApplyCorner(confirmButton)

    cancelButton.MouseEnter:Connect(function()
        Utils.Tween(cancelButton, { BackgroundColor3 = Theme.Hover }, 0.05)
    end)
    cancelButton.MouseLeave:Connect(function()
        Utils.Tween(cancelButton, { BackgroundColor3 = Theme.BgSecondary }, 0.05)
    end)

    confirmButton.MouseEnter:Connect(function()
        Utils.Tween(confirmButton, { BackgroundColor3 = Theme.TextPrimary }, 0.05)
    end)
    confirmButton.MouseLeave:Connect(function()
        Utils.Tween(confirmButton, { BackgroundColor3 = Theme.Accent }, 0.05)
    end)

    local resultCallback = nil

    local function close(result)
        overlay:Destroy()
        modalFrame:Destroy()
        if resultCallback then
            resultCallback(result)
        end
    end

    cancelButton.MouseButton1Click:Connect(function()
        close("Cancel")
    end)

    confirmButton.MouseButton1Click:Connect(function()
        close("Confirm")
    end)

    overlay.MouseButton1Click:Connect(function()
        close("Cancel")
    end)

    function modal:Show()
        local promise = {}
        function promise:Then(callback)
            resultCallback = callback
            return promise
        end

        return promise
    end

    modal._overlay = overlay
    modal._frame = modalFrame

    return modal
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════════
local Library = {}
Library.__index = Library

function Library:Window(config)
    local window = CreateWindow(self, config)
    self._currentWindow = window
    return window
end

function Library:Toast(config)
    if self._currentWindow and self._currentWindow._screenGui then
        CreateToast(self._currentWindow._screenGui, config)
    end
end

function Library:Modal(config)
    if self._currentWindow and self._currentWindow._screenGui then
        return CreateModal(self._currentWindow._screenGui, config)
    end
end

return Library
