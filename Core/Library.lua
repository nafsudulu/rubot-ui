local Library = {}
Library.__index = Library

Library.Theme = require(script.Parent.Theme)
Library.Utils = require(script.Parent.Utils)
Library.IconLoader = require(script.Parent.IconLoader)
Library.Tab = require(script.Parent.Tab)
Library.Window = require(script.Parent.Window)

Library.Components = {}
Library.Windows = {}
Library.Icons = Library.IconLoader.Icons

function Library:CreateWindow(options)
    options = options or {}
    local window = Library.Window.new(self, options)
    table.insert(self.Windows, window)
    return window
end

function Library:Notify(options)
    local Notification = self.Components.Notification
    if Notification then
        return Notification.Show(self, options)
    end
end

function Library:SetTheme(key, value)
    self.Theme.Set(key, value)
end

function Library:SetPreset(presetName)
    self.Theme.SetPreset(presetName)
end

function Library:RegisterComponent(name, component)
    self.Components[name] = component
end

function Library:GetIcon(name)
    return self.IconLoader.Get(name)
end

function Library:RegisterIcon(name, assetId)
    self.IconLoader.RegisterIcon(name, assetId)
end

function Library:DestroyAll()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    self.Windows = {}
end

return Library
