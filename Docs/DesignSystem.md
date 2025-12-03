Siap — ini bagian favoritku 😎
Aku buat **Style Guideline UI ala Linear** yang sudah diadaptasi untuk Roblox (Instance.new, no CSS, no Web).
Goal-nya: *clean, minimal, predictable, dan kelihatan premium banget seperti Linear.*

---

# 🎨 **STYLE GUIDELINE — Minimalist Linear-Inspired UI (Roblox Version)**

*(Untuk internal UI library executor)*

---

# 1️⃣ Colors — “Linear Neutral Palette”

Linear itu *bersih*, *netral*, dan *low-contrast dengan akurat*.
Berikut palet yang aku rekomendasikan (dioptimalkan untuk Roblox Color3):

### **Core Colors**

| Name                     | Hex       | Roblox Code                |
| ------------------------ | --------- | -------------------------- |
| **BG Primary**           | `#FFFFFF` | `Color3.fromHex("FFFFFF")` |
| **BG Secondary**         | `#F7F7F7` | `Color3.fromHex("F7F7F7")` |
| **Border/Subtle Stroke** | `#E4E4E7` | `Color3.fromHex("E4E4E7")` |
| **Text Primary**         | `#1A1A1A` | `Color3.fromHex("1A1A1A")` |
| **Text Secondary**       | `#636363` | `Color3.fromHex("636363")` |
| **Accent**               | `#3A3A3A` | `Color3.fromHex("3A3A3A")` |
| **Hover Gray**           | `#F3F3F3` | `Color3.fromHex("F3F3F3")` |
| **Danger**               | `#EF4444` | `Color3.fromHex("EF4444")` |
| **Success**              | `#10B981` | `Color3.fromHex("10B981")` |
| **Warning**              | `#F59E0B` | `Color3.fromHex("F59E0B")` |

### 🎨 Why this works

* Linear memakai netral *dingin* dan *flat*, bukan warm grey.
* Stroke tipis untuk membentuk struktur tanpa visual noise.
* Aksen hitam tidak terlalu pekat, sekitar level `#1A1A1A` bukan `#000000`.

---

# 2️⃣ Spacing System — “Consistent Scale”

Linear sangat mengandalkan *grid spacing yang konsisten*.
Ambil skala: **4px, 6px, 8px, 10px, 12px, 16px, 20px**.

### **Recommended Spacing (UI Roblox)**

| Use Case           | Spacing         |
| ------------------ | --------------- |
| Inside components  | **8 px**        |
| Section → elements | **10 px**       |
| Between components | **12 px**       |
| Tab padding        | **12–16 px**    |
| Window padding     | **16–20 px**    |
| Line spacing text  | **1.15 – 1.25** |

**General rule:**
➡️ *Visual udara → jangan takut whitespace. Linear banyak banget whitespace untuk kesan premium.*

---

# 3️⃣ Typography — “Sharp, Clean, Compact”

Roblox tidak bisa impor font custom, jadi kita adaptasi gaya Linear pakai **Gotham-like alternatives**:
Gunakan:

### **Font**

```
Font = Enum.Font.Gotham
FontWeight = Medium / Semibold
```

### **Sizes**

| Type                  | Size  | Weight   |
| --------------------- | ----- | -------- |
| Title                 | 18–20 | Semibold |
| Section Heading       | 14–16 | Semibold |
| Body text             | 13–14 | Medium   |
| Subtext / Description | 12    | Medium   |
| Button text           | 13–14 | Semibold |

### Typography Rules

* **No all caps** (Linear jarang menggunakan caps).
* Semua huruf *normal case* atau *sentence case*.
* Hindari bold yang terlalu hard.
* LineHeight kecil → membuat UI “rapat” tapi tetap bersih.

---

# 4️⃣ Corners & Radius

Linear memiliki sudut yang:

* kecil
* stabil
* tidak dramatis

Gunakan radius:

### **BorderRadius = 4–6 px**

Untuk Roblox (`UICorner.CornerRadius` contoh):

```
UICorner.CornerRadius = UDim.new(0, 4)
```

### Rules:

* Button → 4 px
* Input → 4 px
* Dropdown → 4 px
* Slider handle → 4 px
* Modal → 6 px

➡️ *Kecil → tapi cukup untuk terlihat modern.*

---

# 5️⃣ Shadows — Minimalist & Soft

Linear memakai bayangan super halus, hampir tidak terlihat.

Kita adaptasi via Roblox **ImageLabel shadow** atau subtle drop shadow.

### **Shadow Style**

* Opacity rendah (0.05–0.08)
* Blur besar
* Offset 2–4 px

Jika menggunakan external shadow PNG:

| Parameter    | Value               |
| ------------ | ------------------- |
| Transparency | 0.92–0.95           |
| Size         | 102–120% of element |
| Offset       | (0, 2)              |

➡️ *Shadows exist only to lift the window slightly — jangan buat UI berat.*

---

# 6️⃣ Border Rules — “One Pixel Precision”

Linear memakai **1px solid borders** untuk struktur visual.

Untuk Roblox:

```
Frame.BorderSizePixel = 1
Frame.BorderColor3 = Color3.fromHex("E4E4E7")
```

### Where borders matter:

* Window container
* Input fields
* Dropdown closed state
* Sections separator line (vertical subtle line)

### Where borders DO NOT belong:

* Buttons (no borders → rely on flat background)
* Tabs (use indicator bar only)

---

# 7️⃣ Component-Specific Style Rules

### 🟦 Button

* Background: white
* Hover: subtle gray (#F3F3F3)
* Active: scale down to 0.97
* Border: none
* Icon 16px + Text 13/14px
* Padding: 8–10 px

### 🔘 Toggle

* Track: #E4E4E7
* Handle: #FFFFFF
* ON state: accent (#3A3A3A)
* Animation: TweenService (0.1s)

### 📥 Input

* Border 1px
* Text left padded 8px
* Focus border: #3A3A3A

### 📑 Dropdown

* Closed: looks like Input
* Open: floating panel with shadow
* Option hover: #F3F3F3

### 🎚 Slider

* Track: thin (2–3 px)
* Fill: accent
* Handle: circle 10–12 px

### 🧃 Toast

* Flat, left accent bar
* Colors:

  * success: #10B981
  * error: #EF4444
  * info: #3A3A3A
* Animation: fade + slide up 6–8 px

### 🪟 Modal

* Centered
* Soft outer shadow
* Padding heavy (20–24 px)
* Buttons right-aligned

---

# 8️⃣ Iconography — Lucide Style

Linear dan Lucide punya vibe sama: clean, geometric, 2px strokes.

### Rules:

* Icon size: **16x16** atau **18x18**
* Stroke thickness fixed
* Color:

  * `#3A3A3A` for active
  * `#636363` for secondary

### Usage Pattern:

Icon ALWAYS goes before text, spaced 6–8 px.

---

# 🔟 Motion & Animation

Linear uses **micro-interactions**, bukan animasi besar.

### Rules:

| Element         | Duration   | Easing   |
| --------------- | ---------- | -------- |
| Hover           | 0.05–0.07s | Linear   |
| Press           | 0.07s      | QuartOut |
| Window show     | 0.12s      | QuadOut  |
| Dropdown expand | 0.12s      | QuadOut  |

No bounce, no elastic — too playful, not Linear.

---

# 🧠 BONUS — “Micro Details That Make it Feel Linear”

* Use **consistent icon color**, don't color icons randomly
* More **empty space** than you think
* Never round corners above 6px
* Keep everything **flat** — no gradients, no textures
* Use **fixed spacing scale**, no improvisation
* Focus on **alignment** (Linear sangat presisi)
