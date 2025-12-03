local IconLoader = {}

IconLoader.Icons = {
    ["play"] = "rbxassetid://6031094678",
    ["pause"] = "rbxassetid://6031094533",
    ["stop"] = "rbxassetid://6031094453",
    ["home"] = "rbxassetid://6031280882",
    ["settings"] = "rbxassetid://6031280996",
    ["user"] = "rbxassetid://6031251534",
    ["users"] = "rbxassetid://6031251689",
    ["search"] = "rbxassetid://6031154871",
    ["menu"] = "rbxassetid://6031229048",
    ["x"] = "rbxassetid://6031094667",
    ["check"] = "rbxassetid://6031068420",
    ["check-circle"] = "rbxassetid://6031068420",
    ["alert-circle"] = "rbxassetid://6031071053",
    ["alert-triangle"] = "rbxassetid://6031071164",
    ["info"] = "rbxassetid://6031280650",
    ["bot"] = "rbxassetid://6031229146",
    ["sword"] = "rbxassetid://6034287594",
    ["swords"] = "rbxassetid://6034287594",
    ["shield"] = "rbxassetid://6031229373",
    ["heart"] = "rbxassetid://6031280556",
    ["star"] = "rbxassetid://6031229430",
    ["zap"] = "rbxassetid://6031229602",
    ["target"] = "rbxassetid://6034254983",
    ["crosshair"] = "rbxassetid://6034254983",
    ["eye"] = "rbxassetid://6031075104",
    ["eye-off"] = "rbxassetid://6031075022",
    ["lock"] = "rbxassetid://6031082532",
    ["unlock"] = "rbxassetid://6031082668",
    ["key"] = "rbxassetid://6031082465",
    ["copy"] = "rbxassetid://6031068590",
    ["clipboard"] = "rbxassetid://6031068543",
    ["download"] = "rbxassetid://6031074953",
    ["upload"] = "rbxassetid://6031094602",
    ["refresh-cw"] = "rbxassetid://6031090064",
    ["rotate-cw"] = "rbxassetid://6031090064",
    ["trash"] = "rbxassetid://6031094492",
    ["trash-2"] = "rbxassetid://6031094492",
    ["edit"] = "rbxassetid://6031075015",
    ["edit-2"] = "rbxassetid://6031075015",
    ["save"] = "rbxassetid://6031090145",
    ["folder"] = "rbxassetid://6031280380",
    ["file"] = "rbxassetid://6031280295",
    ["image"] = "rbxassetid://6031280596",
    ["code"] = "rbxassetid://6031068504",
    ["terminal"] = "rbxassetid://6034287441",
    ["command"] = "rbxassetid://6031068478",
    ["chevron-up"] = "rbxassetid://6031068377",
    ["chevron-down"] = "rbxassetid://6031068285",
    ["chevron-left"] = "rbxassetid://6031068316",
    ["chevron-right"] = "rbxassetid://6031068349",
    ["arrow-up"] = "rbxassetid://6031067898",
    ["arrow-down"] = "rbxassetid://6031067837",
    ["arrow-left"] = "rbxassetid://6031067868",
    ["arrow-right"] = "rbxassetid://6031067808",
    ["plus"] = "rbxassetid://6031068637",
    ["minus"] = "rbxassetid://6031082585",
    ["maximize"] = "rbxassetid://6031082547",
    ["minimize"] = "rbxassetid://6031082585",
    ["panel-left"] = "rbxassetid://6031229048",
    ["panel-right"] = "rbxassetid://6031229048",
    ["layers"] = "rbxassetid://6031082512",
    ["list"] = "rbxassetid://6031229048",
    ["grid"] = "rbxassetid://6031280492",
    ["layout"] = "rbxassetid://6031280756",
    ["gauge"] = "rbxassetid://6031280435",
    ["activity"] = "rbxassetid://6031067756",
    ["trending-up"] = "rbxassetid://6031094563",
    ["trending-down"] = "rbxassetid://6031094519",
    ["dollar-sign"] = "rbxassetid://6031074989",
    ["gift"] = "rbxassetid://6031280339",
    ["package"] = "rbxassetid://6031154766",
    ["box"] = "rbxassetid://6031068152",
    ["globe"] = "rbxassetid://6031280464",
    ["map"] = "rbxassetid://6031082565",
    ["navigation"] = "rbxassetid://6031154724",
    ["compass"] = "rbxassetid://6031068570",
    ["send"] = "rbxassetid://6031090131",
    ["message-circle"] = "rbxassetid://6031154637",
    ["message-square"] = "rbxassetid://6031154680",
    ["mail"] = "rbxassetid://6031082505",
    ["bell"] = "rbxassetid://6031068075",
    ["bell-off"] = "rbxassetid://6031068032",
    ["volume"] = "rbxassetid://6031251598",
    ["volume-2"] = "rbxassetid://6031251598",
    ["volume-x"] = "rbxassetid://6031251639",
    ["music"] = "rbxassetid://6031154707",
    ["headphones"] = "rbxassetid://6031280524",
    ["camera"] = "rbxassetid://6031068190",
    ["video"] = "rbxassetid://6031251571",
    ["mic"] = "rbxassetid://6031154616",
    ["mic-off"] = "rbxassetid://6031154571",
    ["wifi"] = "rbxassetid://6031251488",
    ["bluetooth"] = "rbxassetid://6031068098",
    ["battery"] = "rbxassetid://6031067956",
    ["power"] = "rbxassetid://6031154824",
    ["moon"] = "rbxassetid://6031154646",
    ["sun"] = "rbxassetid://6031251423",
    ["cloud"] = "rbxassetid://6031068461",
    ["clock"] = "rbxassetid://6031068444",
    ["calendar"] = "rbxassetid://6031068171",
    ["filter"] = "rbxassetid://6031280272",
    ["sliders"] = "rbxassetid://6031229400",
    ["tool"] = "rbxassetid://6031251396",
    ["wrench"] = "rbxassetid://6031251455",
    ["hammer"] = "rbxassetid://6031280506",
    ["cpu"] = "rbxassetid://6031068619",
    ["database"] = "rbxassetid://6031068681",
    ["server"] = "rbxassetid://6031229354",
    ["hard-drive"] = "rbxassetid://6031280540",
    ["monitor"] = "rbxassetid://6031154661",
    ["smartphone"] = "rbxassetid://6031229386",
    ["tablet"] = "rbxassetid://6034287463",
    ["gamepad"] = "rbxassetid://6034254893",
    ["gamepad-2"] = "rbxassetid://6034254893",
    ["trophy"] = "rbxassetid://6034287508",
    ["crown"] = "rbxassetid://6034254846",
    ["flame"] = "rbxassetid://6034254871",
    ["sparkles"] = "rbxassetid://6034287387",
    ["rocket"] = "rbxassetid://6034287331",
    ["plane"] = "rbxassetid://6034287282",
    ["car"] = "rbxassetid://6034254824",
    ["bike"] = "rbxassetid://6034254795",
    ["footprints"] = "rbxassetid://6034254860",
    ["sprint"] = "rbxassetid://6034287405",
    ["walk"] = "rbxassetid://6034287540"
}

IconLoader.DefaultSize = UDim2.new(0, 20, 0, 20)
IconLoader.DefaultColor = Color3.fromRGB(230, 230, 230)
IconLoader.DefaultTransparency = 0.2

function IconLoader.Get(iconName)
    return IconLoader.Icons[iconName] or IconLoader.Icons["info"]
end

function IconLoader.CreateIcon(iconName, props)
    props = props or {}
    
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "Icon_" .. (iconName or "unknown")
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = IconLoader.Get(iconName)
    imageLabel.ImageColor3 = props.Color or IconLoader.DefaultColor
    imageLabel.ImageTransparency = props.Transparency or IconLoader.DefaultTransparency
    imageLabel.Size = props.Size or IconLoader.DefaultSize
    imageLabel.Position = props.Position or UDim2.new(0, 0, 0, 0)
    imageLabel.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    imageLabel.ScaleType = Enum.ScaleType.Fit
    
    if props.Parent then
        imageLabel.Parent = props.Parent
    end
    
    return imageLabel
end

function IconLoader.SetIcon(imageLabel, iconName)
    if imageLabel and iconName then
        imageLabel.Image = IconLoader.Get(iconName)
    end
end

function IconLoader.RegisterIcon(name, assetId)
    IconLoader.Icons[name] = assetId
end

function IconLoader.RegisterIcons(iconTable)
    for name, assetId in pairs(iconTable) do
        IconLoader.Icons[name] = assetId
    end
end

return IconLoader
