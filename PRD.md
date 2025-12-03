
# **📘 FINAL PRODUCT REQUIREMENTS DOCUMENT (PRD)**

## **Rubot UI — Roblox Executor UI Library (shadcn-inspired + Lucide Icons)**

---

# **1. Overview**

### **1.1 Product Name**

**Rubot UI**

### **1.2 Description**

Rubot UI adalah sebuah UI Library premium untuk Roblox Executor, dengan desain modern terinspirasi dari **shadcn/ui**, menggunakan icon pack **Lucide** sebagai ikon utama untuk seluruh komponen.

Library ini dibuat agar developer dapat membuat UI framework yang konsisten, estetis, modular, dan sangat mudah digunakan.

### **1.3 Goals**

* Menyediakan UI modern & konsisten.
* Mudah dipakai dan dikembangkan.
* Komponen ringan dan responsif.
* Memiliki icon system lengkap berbasis Lucide.
* Mendukung window hide/show toggle berbentuk squircle.

---

# **2. Target User**

* Roblox scripter
* Pembuat executor
* Developer script hub

---

# **3. Core Features**

1. **Window system** (drag, minimize toggle squircle, animations)
2. **Tabs system** (icon support, shadcn-style)
3. **Buttons** (primary, secondary, destructive, with icons)
4. **Toggle / Switch**
5. **Dropdown**
6. **Slider**
7. **Input / Textbox**
8. **Label / Description**
9. **Notification toast**
10. **Section / Separator**
11. **Lucide Icon System**
12. **Minimize Toggle Squircle Button (Floating Icon Button)**

---

# **4. Design Philosophy**

Mengikuti gaya **shadcn/ui**:

* Clean, minimal, elegant.
* Neutral grayscale palette.
* Soft borders.
* Subtle shadows.
* Smooth animations.
* Icons simple and crisp.

---

# **5. Component Specifications**

---

## **5.1 Window**

**Features**

* Drag & drop
* Resizable (optional)
* Close button
* Minimize button
* TitleBar with icon (Lucide icon optional)
* Animated appearance
* Customizable theme
* Built-in visibility management

**Minimize Behavior**

* Window fades out (0.15s)
* Window slides slightly down/up
* A **floating squircle button** appears
* Button contains **custom Lucide icon**
* Clicking it restores the window

**API**

```lua
local win = Rubot:CreateWindow({
    Title = "Rubot Control Panel",
    Size = UDim2.new(0, 480, 0, 330),
    Icon = "bot", -- Lucide
    HideKey = Enum.KeyCode.RightShift,
    MinimizeIcon = "panel-left",
    TogglePosition = "BottomRight",
})
```

**Window Methods**

```lua
win:Minimize()
win:Restore()
win:SetVisible(bool)
win:SetMinimizeIcon("menu")
win:SetTogglePosition("BottomLeft")
```

---

## **5.2 Floating Squircle Toggle Button**

**Purpose:** Restore minimized window.

**Shape:**

* Size: 42×42 px (default)
* Border radius: 16 px (squircle-like)
* Shadow: soft
* Lucide icon centered

**API:**

```lua
window:SetMinimizeIcon("lucide-icon-name")
window:SetTogglePosition("BottomRight")
```

---

## **5.3 Tabs**

**Style:**

* Segmented/tab switcher ala shadcn
* Active tab underline + accent color
* Icon support (Lucide)

**API:**

```lua
local tab = win:AddTab("Main", { Icon = "home" })
```

---

## **5.4 Button**

**Variants:**

* Primary
* Secondary
* Destructive
* Ghost

**Features:**

* Optional icon (Lucide)
* Disabled state
* Hover shading
* Press animation (shrink 98%)

**API:**

```lua
tab:AddButton({
    Title = "Start Farm",
    Icon = "play",
    Variant = "Primary",
    Callback = function() end
})
```

---

## **5.5 Toggle (Switch)**

**Features:**

* Smooth sliding knob
* Accent color glow on active
* Optional Lucide icon (left or right)

**API:**

```lua
tab:AddToggle("Auto Kill", false, {
    Icon = "sword",
    Callback = function(state) end
})
```

---

## **5.6 Dropdown**

**Features:**

* Lucide icon optional
* Scrollable list
* Supports multi-select
* Soft border & shadow

**API:**

```lua
tab:AddDropdown("Select Team", {"Red","Blue"}, {
    Icon = "list",
    Multi = false,
    Callback = function(value) end
})
```

---

## **5.7 Slider**

**Features:**

* Value preview (right aligned)
* Accent color filled portion
* Knob hover highlight
* Optional icon

**API:**

```lua
tab:AddSlider("WalkSpeed", 16, 300, 16, {
    Icon = "gauge",
    Step = 1,
    Callback = function(v) end
})
```

---

## **5.8 Input / Textbox**

**Features:**

* Placeholder text
* Focus glow
* Border accent
* Optional Lucide prefix icon

**API:**

```lua
tab:AddInput("Enter Key", {
    Icon = "key",
    Placeholder = "Type here…",
    Callback = function(text) end
})
```

---

## **5.9 Notification Toast**

**Styles:**

* Info
* Success
* Warning
* Error

**Features:**

* Lucide icon based on variant
* Slide-in animation
* Auto-dismiss timer

**API:**

```lua
Rubot:Notify({
    Title = "Success",
    Message = "Auto Farm has started",
    Icon = "check-circle",
    Variant = "Success",
    Duration = 4,
})
```

---

## **5.10 Section / Divider**

**Usage:**
Grouping elements inside tabs.

**API:**

```lua
tab:AddSection("Combat Settings", { Icon = "swords" })
```

---

# **6. Lucide Icon System**

Rubot UI menyertakan icon pack:

* Ikon Lucide diubah menjadi **sprite atlas PNG** atau **ImageLabel individual PNG**.
* Semua komponen dapat memanggil ikon dengan nama string.

**API Global**

```lua
Rubot.Icons["play"]
Rubot.Icons["bot"]
Rubot.Icons["sword"]
Rubot.Icons["menu"]
Rubot.Icons["gauge"]
```

**Icon Properties**

* Default size: 20×20 px
* Color: `Color3.fromRGB(230, 230, 230)`
* Opacity: 0.8 → 1.0 on hover

---

# **7. Theming System**

### **Variables**

* PrimaryColor
* AccentColor
* BackgroundColor
* BorderColor
* TextColor
* Radius (global radius)
* AnimationSpeed

### **API**

```lua
Rubot:SetTheme("AccentColor", Color3.fromRGB(127, 163, 255))
```

---

# **8. Architecture**

### **Folder Structure**

```
RubotUI/
  Core/
    Library.lua
    Window.lua
    Tab.lua
    Theme.lua
    IconLoader.lua
    Utils.lua

  Components/
    Button.lua
    Toggle.lua
    Dropdown.lua
    MultiDropdown.lua
    Slider.lua
    Input.lua
    Notification.lua
    Section.lua

  Assets/
    Icons/
      mapping.json

RubotInit.lua
```

---

# **9. Performance Requirements**

* TweenService for animations (0.15–0.25s)
* Lazy rendering (only draw what is needed)
* No loops unless essential
* All callbacks wrapped with `pcall`

---

# **10. Compatibility**

* Works across:

  * Delta
  * Solara
  * Evon
  * Fluxus
  * Arceus X (Mobile)
* Supports any screen resolution

---

# **11. Deliverables**

1. Rubot UI library source code
2. Minified build
3. Icon atlas & mapping (Lucide set)
4. API documentation
5. Demo script
6. Prebuilt themes (Dark, Light, Midnight)

---

# **12. Future Plans**

* Context menu (right-click)
* Keybind component
* Color picker
* Docking system (like taskbar)
* Multi-window management system
* Searchable dropdown
