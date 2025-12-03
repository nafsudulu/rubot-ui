local Theme = {}

Theme.Presets = {
    Dark = {
        PrimaryColor = Color3.fromRGB(24, 24, 27),
        SecondaryColor = Color3.fromRGB(39, 39, 42),
        AccentColor = Color3.fromRGB(99, 102, 241),
        BackgroundColor = Color3.fromRGB(9, 9, 11),
        BorderColor = Color3.fromRGB(63, 63, 70),
        TextColor = Color3.fromRGB(250, 250, 250),
        TextMutedColor = Color3.fromRGB(161, 161, 170),
        SuccessColor = Color3.fromRGB(34, 197, 94),
        WarningColor = Color3.fromRGB(234, 179, 8),
        ErrorColor = Color3.fromRGB(239, 68, 68),
        InfoColor = Color3.fromRGB(59, 130, 246),
        Radius = 8,
        AnimationSpeed = 0.2
    },
    Light = {
        PrimaryColor = Color3.fromRGB(255, 255, 255),
        SecondaryColor = Color3.fromRGB(244, 244, 245),
        AccentColor = Color3.fromRGB(99, 102, 241),
        BackgroundColor = Color3.fromRGB(250, 250, 250),
        BorderColor = Color3.fromRGB(228, 228, 231),
        TextColor = Color3.fromRGB(9, 9, 11),
        TextMutedColor = Color3.fromRGB(113, 113, 122),
        SuccessColor = Color3.fromRGB(34, 197, 94),
        WarningColor = Color3.fromRGB(234, 179, 8),
        ErrorColor = Color3.fromRGB(239, 68, 68),
        InfoColor = Color3.fromRGB(59, 130, 246),
        Radius = 8,
        AnimationSpeed = 0.2
    },
    Midnight = {
        PrimaryColor = Color3.fromRGB(15, 23, 42),
        SecondaryColor = Color3.fromRGB(30, 41, 59),
        AccentColor = Color3.fromRGB(127, 163, 255),
        BackgroundColor = Color3.fromRGB(2, 6, 23),
        BorderColor = Color3.fromRGB(51, 65, 85),
        TextColor = Color3.fromRGB(241, 245, 249),
        TextMutedColor = Color3.fromRGB(148, 163, 184),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        WarningColor = Color3.fromRGB(250, 204, 21),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        InfoColor = Color3.fromRGB(96, 165, 250),
        Radius = 10,
        AnimationSpeed = 0.18
    }
}

Theme.Current = {}

function Theme.Init(preset)
    preset = preset or "Dark"
    Theme.Current = Theme.DeepCopy(Theme.Presets[preset] or Theme.Presets.Dark)
    return Theme.Current
end

function Theme.Set(key, value)
    if Theme.Current[key] ~= nil then
        Theme.Current[key] = value
    end
end

function Theme.Get(key)
    return Theme.Current[key]
end

function Theme.SetPreset(presetName)
    if Theme.Presets[presetName] then
        Theme.Current = Theme.DeepCopy(Theme.Presets[presetName])
    end
end

function Theme.DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = Theme.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Theme.CreateCustom(name, themeData)
    Theme.Presets[name] = themeData
end

Theme.Init("Dark")

return Theme
