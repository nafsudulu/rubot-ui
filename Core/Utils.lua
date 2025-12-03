local Utils = {}

function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utils.deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = Utils.deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Utils.createInstance(className, properties, children)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.safeCallback(callback, ...)
    if callback then
        local success, err = pcall(callback, ...)
        if not success then
            warn("[RubotUI] Callback error:", err)
        end
        return success, err
    end
    return true
end

function Utils.generateId()
    return string.format("%x", tick() * 1000000 + math.random(1, 999999))
end

function Utils.rgba(r, g, b, a)
    return Color3.fromRGB(r, g, b), a or 1
end

function Utils.hexToRGB(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

function Utils.createRoundedFrame(props)
    local frame = Utils.createInstance("Frame", {
        BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Size = props.Size or UDim2.new(1, 0, 1, 0),
        Position = props.Position or UDim2.new(0, 0, 0, 0),
        AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
        Parent = props.Parent
    })
    
    Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, props.CornerRadius or 8),
        Parent = frame
    })
    
    return frame
end

function Utils.createShadow(parent, size)
    size = size or 4
    local shadow = Utils.createInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(1, size * 2, 1, size * 2),
        Position = UDim2.new(0, -size, 0, -size),
        ZIndex = -1,
        Parent = parent
    })
    return shadow
end

return Utils
