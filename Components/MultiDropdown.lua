local Dropdown = require(script.Parent.Dropdown)

local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown
setmetatable(MultiDropdown, {__index = Dropdown})

function MultiDropdown.new(tab, options)
    options.Multi = true
    local self = Dropdown.new(tab, options)
    setmetatable(self, MultiDropdown)
    return self
end

function MultiDropdown:SelectAll()
    self.Selected = {}
    for _, item in ipairs(self.Items) do
        table.insert(self.Selected, item)
    end
    self:UpdateValueDisplay()
    self:UpdateCheckmarks()
    self.Utils.safeCallback(self.Callback, self.Selected)
end

function MultiDropdown:DeselectAll()
    self.Selected = {}
    self:UpdateValueDisplay()
    self:UpdateCheckmarks()
    self.Utils.safeCallback(self.Callback, self.Selected)
end

function MultiDropdown:IsSelected(item)
    return table.find(self.Selected, item) ~= nil
end

return MultiDropdown
