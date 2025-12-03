Keren — ayo kita gas! 🎉
Berikut **API design lengkap & opinionated** untuk masing-masing komponen.
Aku bikin formatnya **rapih, konsisten, dan gampang dipahami developer**, dengan fokus pada:

* API sederhana & predictable
* Getter & setter jelas
* Event naming konsisten
* Pola OOP rapi: `Window → Tab → Section → Component`

---

# 🧩 **API DESIGN — Minimalist Roblox UI Library**

---

# 🔥 1. Root API

## **UI = Library.Init()**

```lua
local UI = loadstring(game:HttpGet("..."))()
```

---

# 🪟 2. Window API

### **Create Window**

```lua
local Window = UI:Window({
    Title = "Executor UI",
    Icon = Icons.Icon("layout-dashboard"),
    Size = UDim2.new(0, 500, 0, 350),
    CanDrag = true,
    DefaultOpen = true
})
```

### **Window Methods**

```lua
Window:SetTitle(text)
Window:SetIcon(icon)
Window:SetVisible(bool)
Window:IsVisible() → bool

Window:MoveTo(Vector2)
Window:GetPosition() → Vector2

Window:Destroy()
```

### **Events**

```lua
Window.VisibleChanged:Connect(function(isVisible) end)
```

---

# 🗂 3. Tab API (Vertical Tab)

### **Create Tab**

```lua
local Tab = Window:Tab({
    Title = "Main",
    Icon = Icons.Icon("home"),
    Default = false
})
```

### **Methods**

```lua
Tab:Select()
Tab:IsSelected() → bool
Tab:SetTitle(text)
Tab:SetIcon(icon)
Tab:Destroy()
```

### **Events**

```lua
Tab.Selected:Connect(function() end)
```

---

# 📦 4. Section API

### **Create Section**

```lua
local Section = Tab:Section("Execution")
```

### **Methods**

```lua
Section:SetTitle(text)
Section:Destroy()
```

---

# 🟦 5. Button API

### **Create Button**

```lua
local Button = Section:Button({
    Text = "Execute Script",
    Icon = Icons.Icon("play"),
    Disabled = false
})
```

### **Methods**

```lua
Button:SetText(text)
Button:SetIcon(icon)
Button:SetDisabled(bool)
Button:IsDisabled() → bool
Button:Destroy()
```

### **Events**

```lua
Button.Clicked:Connect(function() end)
```

---

# 🔘 6. Toggle API

### **Create Toggle**

```lua
local Toggle = Section:Toggle({
    Text = "Auto Execute",
    Default = false
})
```

### **Methods**

```lua
Toggle:Set(bool)
Toggle:Get() → bool
Toggle:SetText(text)
Toggle:Destroy()
```

### **Events**

```lua
Toggle.Changed:Connect(function(newValue) end)
```

---

# 📝 7. Input API

### **Create Input**

```lua
local Input = Section:Input({
    Placeholder = "Enter script name...",
    Default = "",
    Numeric = false,
    ClearTextOnFocus = false,
})
```

### **Methods**

```lua
Input:Set(text)
Input:Get() → string
Input:SetPlaceholder(text)
Input:Destroy()
```

### **Events**

```lua
Input.Changed:Connect(function(newText) end)
Input.Submitted:Connect(function(finalText) end)
```

---

# 📥 8. Dropdown API

### **Create Dropdown**

```lua
local Dropdown = Section:Dropdown({
    Text = "Select Mode",
    Options = {"Fast", "Safe", "Stealth"},
    Default = "Safe",
    Searchable = false,
})
```

### **Methods**

```lua
Dropdown:Set(value)
Dropdown:Get() → selectedOption
Dropdown:SetOptions(list)
Dropdown:AddOption(option)
Dropdown:RemoveOption(option)
Dropdown:Destroy()
```

### **Events**

```lua
Dropdown.Changed:Connect(function(selected) end)
```

---

# 🧩 9. Multi Dropdown API

### **Create Multi Dropdown**

```lua
local MD = Section:MultiDropdown({
    Text = "Select Modules",
    Options = {"Aimbot","ESP","Triggerbot"},
    Default = {"ESP"}
})
```

### **Methods**

```lua
MD:Set(listTable)
MD:Get() → table
MD:AddOption(text)
MD:RemoveOption(text)
MD:Clear()
MD:Destroy()
```

### **Events**

```lua
MD.Changed:Connect(function(newTable) end)
```

---

# 🎚 10. Slider API

### **Create Slider**

```lua
local Slider = Section:Slider({
    Text = "FOV",
    Min = 50,
    Max = 120,
    Default = 90,
    Step = 1,
    Format = function(value) return tostring(value) .. "°" end
})
```

### **Methods**

```lua
Slider:Set(number)
Slider:Get() → number
Slider:SetText(text)
Slider:Destroy()
```

### **Events**

```lua
Slider.Changed:Connect(function(value) end)
Slider.Released:Connect(function(finalValue) end)
```

---

# 📢 11. Toast API (Global)

### **Create Toast**

```lua
UI:Toast({
    Title = "Success!",
    Description = "Script executed.",
    Type = "success", -- success, error, info
    Duration = 3,
    Icon = Icons.Icon("check-circle")
})
```

---

# 🪟 12. Modal / Dialog API

### **Show Modal**

```lua
local Modal = UI:Modal({
    Title = "Confirm Delete",
    Description = "Are you sure you want to delete this script?",
    ConfirmText = "Delete",
    CancelText = "Cancel",
    Icon = Icons.Icon("alert-triangle")
})
```

### **Method**

```lua
Modal:Show():Then(function(result)
    if result == "Confirm" then
        -- do something
    end
end)
```

---

# 🔤 13. Title / Description Components

### **Title**

```lua
local Title = Section:Title("Executor Settings")
Title:Set("New Title")
```

### **Description**

```lua
local Desc = Section:Description("Tweak your execution behaviors here.")
Desc:Set("Updated description")
```

---

# 🧼 14. Visibility & State Controls (Universal)

Semua komponen ini kompatibel:

```lua
Component:SetVisible(bool)
Component:IsVisible()
Component:Destroy()
```

---

# 🧠 Consistency Rules (Internal)

Untuk menjaga library rapih dan gampang dipakai:

### **Getter**

```
Component:Get()
```

### **Setter**

```
Component:Set(value)
```

### **Events**

```
Component.EventName:Connect(callback)
```

### **Destroy**

```
Component:Destroy()
```
