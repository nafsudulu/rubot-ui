local Section = {}
Section.__index = Section

function Section.new(tab, options)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Theme = tab.Window.Theme
    self.Utils = tab.Window.Utils
    self.IconLoader = tab.Window.IconLoader
    
    self.Title = options.Title or "Section"
    self.Icon = options.Icon
    
    self:Create()
    
    return self
end

function Section:Create()
    local Theme = self.Theme
    local Utils = self.Utils
    local IconLoader = self.IconLoader
    
    self.Container = Utils.createInstance("Frame", {
        Name = "Section_" .. self.Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        Parent = self.Tab.ContentFrame
    })
    
    local leftLine = Utils.createInstance("Frame", {
        Name = "LeftLine",
        BackgroundColor3 = Theme.Get("BorderColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 1),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = self.Container
    })
    
    local content = Utils.createInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = self.Container
    })
    
    Utils.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = content
    })
    
    if self.Icon then
        IconLoader.CreateIcon(self.Icon, {
            Size = UDim2.new(0, 14, 0, 14),
            Color = Theme.Get("TextMutedColor"),
            Transparency = 0,
            Parent = content
        })
    end
    
    self.TitleLabel = Utils.createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamMedium,
        Text = self.Title:upper(),
        TextColor3 = Theme.Get("TextMutedColor"),
        TextSize = 10,
        Parent = content
    })
    
    local rightLine = Utils.createInstance("Frame", {
        Name = "RightLine",
        BackgroundColor3 = Theme.Get("BorderColor"),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -100, 0, 1),
        Position = UDim2.new(0, 100, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = self.Container
    })
    
    content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local contentWidth = content.AbsoluteSize.X
        rightLine.Position = UDim2.new(0, 36 + contentWidth, 0.5, 0)
        rightLine.Size = UDim2.new(1, -(44 + contentWidth), 0, 1)
    end)
end

function Section:SetTitle(title)
    self.Title = title
    self.TitleLabel.Text = title:upper()
end

return Section
