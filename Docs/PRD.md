# 🧩 PRD — Minimalist Roblox Executor UI Library

*(Internal Product)*

## 📝 TL;DR

Library UI internal bergaya **Linear** untuk Roblox executor, dibuat dengan **Instance.new**, fokus pada **performance** (low instance count), API **simple & predictable**, dukungan **getter/setter** untuk semua komponen, serta paket komponen lengkap (window, tabs, input, slider, toast, modal, dll).
Ikon menggunakan **Lucide** via loader eksternal.

---

# 🎯 Goals

## 🎯 Business Goals

* Mempercepat pembuatan UI internal untuk berbagai tool executor — hemat waktu dev 40–60%.
* Meningkatkan konsistensi visual di semua product internal.
* Mengurangi bug UI dan fragmentasi codebase.
* Membuat UI terlihat profesional & modern ala Linear → untuk meningkatkan credibility tool internal.

## 🎯 User Goals (Developer → Library Users)

* Bisa membuat UI yang rapih, konsisten, dan aesthetic dengan **minim konfigurasi**.
* UI responsif, ringan, tidak memakan terlalu banyak instance (penting untuk executor).
* Components mudah diatur: getter/setter, event listener, dan state handling jelas.
* Dokumentasi dan API mudah dipahami, “cukup 1–2 contoh untuk mengerti semuanya”.

## 🚫 Non-Goals

* Tidak dirancang untuk UI kompleks seperti chat, table besar, grafik.
* Tidak bertujuan menjadi open-source tool publik.
* Tidak menyediakan theme builder kompleks atau full design system.

---

# 👥 User Stories

### Developer / User Library

* *“Sebagai developer, saya ingin membuat window dengan tab dan sections tanpa mikir layouting lagi.”*
* *“Sebagai developer, saya ingin toggle & button punya event yang jelas (OnChanged, OnClick).”*
* *“Sebagai developer, saya ingin slider bekerja halus tanpa delay.”*
* *“Sebagai developer, saya ingin bisa hide/show window dengan satu API.”*
* *“Sebagai developer, saya ingin setiap component punya accessor: Component:Set(value) dan Component:Get().”*

---

# 🧭 User Experience (Flow Detail)

## 1. Load Library

```lua
local UI = loadstring(game:HttpGet("..."))()
```

## 2. Initialize Icons

```lua
local Icons = loadstring(game:HttpGetAsync("..."))()
Icons.SetIconsType("lucide")
```

## 3. Create Window

* Minimalis: background putih keabu, border tipis 1px, shadow halus.
* Draggable area di topbar.
* Show/hide melalui **floating toggle button** (icon-based) di pojok.

```lua
local Window = UI:Window({
   Title = "Executor UI",
   Icon = Icons.Icon("layout-dashboard"),
})
```

## 4. Add Vertical Tabs

* Sidebar kiri.
* Highlight tab aktif dengan bar tipis.
* Tekstur flat, warna abu netral.

```lua
local Tab = Window:Tab({
   Title = "Main",
   Icon = Icons.Icon("home"),
})
```

## 5. Sections

* Memisahkan logika komponen.
* Margin, padding, dan spacing otomatis.

```lua
local Section = Tab:Section("Execution Tools")
```

## 6. Components (UX)

### Button

* Flat, radius kecil.
* Hover slightly darker.
* Click animation scale 0.97.

### Toggle

* Track kecil ala Linear.
* Smooth tween (0.1s).
* Icon check optional.

### Input

* Minimal border, placeholder abu.
* Auto-select saat click.

### Dropdown & Multi-dropdown

* Panel kecil keluar ke kanan/bawah.
* Scrollable jika panjang.

### Slider

* Handle kecil, track tipis.
* Value preview inline.

### Toasts

* Bottom-right, auto dismiss.
* Use Lucide icons per variant: success, error, info.

### Modal / Dialog

* Blur background optional.
* CTA + cancel buttons.

---

# 🧠 Narrative (For Execs)

Bayangkan developer internal kita ingin membuat tool baru untuk mengelola script executor. Biasanya mereka harus menghabiskan waktu lama hanya untuk membuat UI dasar: window, draggable area, tab, layout, toggle, dan sebagainya. Hasilnya sering berbeda-beda, tidak konsisten, dan kadang berat karena penggunaan instance yang tidak optimal.

Dengan library UI baru ini, developer cukup menulis beberapa baris kode, dan langsung mendapatkan UI modern ala Linear — clean, fokus pada konten, dan sangat responsif. Semua komponen sudah dioptimalkan, memakai sedikit instance, animasi halus, dan API-nya konsisten: semua komponen punya `:Get()` dan `:Set()`.

Library ini mengubah cara kita membangun tool internal: lebih cepat, lebih rapih, dan lebih profesional. Bukan hanya membantu developer, tetapi juga membuat semua produk internal terasa seperti satu ekosistem terpadu.

---

# 📏 Success Metrics

* ⏱ Mengurangi waktu pembuatan UI internal dari 2–4 jam → < 20 menit.
* 🧩 Konsistensi style antar-tool meningkat (diukur via adoption rate).
* 🧠 Developer satisfaction ≥ 8/10.
* 📉 Instance count turun 20–30% dibanding UI manual.
* 🐞 Penurunan bug UI 40%.

---

# 🛠 Technical Considerations

### Instance Management

* Setiap component harus menggunakan **minimum Instance**, contoh:

  * Toggle = Frame + UICorner + inner frame.
  * Button = Frame + TextLabel.
* Reuse UI objects jika memungkinkan.

### API Design

* Semua komponen wajib punya:

  * `component:Set(value)`
  * `component:Get()`
  * Event-friendly: `component.Changed:Connect(function(val) end)`

### Theme System

* Warna default ala Linear:

  * Background: #FFFFFF
  * Border: #E5E5E5
  * Accent: #3A3A3A
  * Success: #4ADE80
  * Error: #F87171

### Icon Loader

* Harus support lucide (default).
* Icon disimpan sebagai spritesheet (seperti contoh user).

### Performance

* Tween minimal (TweenService).
* Cache icons.
* Jangan pakai UIGradient kecuali benar-benar diperlukan.



# 🧱 Component List (Detail Requirements)

### Window

* Draggable topbar
* Show/hide toggle
* Icon support
* Getters: position, visible
* Setters: MoveTo, SetVisible

### Vertical Tab

* Left side
* Support icons
* API: `Select()`, `IsSelected()`
* Icon support

### Section

* Text header optional
* Automatic vertical layout

### Button

* OnClick event
* Disabled state
* SetText / SetEnabled
* Icon support

### Toggle

* State: boolean
* Set(true/false)
* OnChanged

### Dropdown

* Single select
* Optional search
* SetOptions()
* SetSelected()

### Multi Dropdown

* Multiple choices
* Returns table
* SetMultiple(table)

### Slider

* Min, max, step
* Live update event
* SetValue()

### Input

* Placeholder
* OnChanged
* SetText()

### Toast

* Types: success, error, info
* Auto-hide timer
* Icon support

### Modal

* Title, description
* Buttons (confirm/cancel)
* Result promise-like callback

### Title / Description (Text Blocks)

* Styling minimal
* Auto-resize

---

# 🗂 Milestones & Sequencing

## Milestone 1 — Core Foundation (1–2 weeks)

* Base UI system
* Window + draggable
* Theme + icon loader

## Milestone 2 — Navigation Layer (1–2 weeks)

* Vertical tabs
* Sections
* Layout engine

## Milestone 3 — Core Components (2–4 weeks)

* Button
* Toggle
* Input
* Slider
* Dropdown
* Multi-dropdown

## Milestone 4 — Advanced Components (1–2 weeks)

* Toasts
* Modal

## Milestone 5 — Finalization (1–2 weeks)

* Getter/Setter system
* Docs + examples
* Performance validation

Support Semua Executor
