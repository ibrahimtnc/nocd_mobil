# MISSION: UI REDESIGN - "Clean Matte & Structured"

## 1. Critique & Direction
**STOP using Glassmorphism.** The user finds it blurry and unclear.
**NEW GOAL:** Create a design that offers **Certainty, Structure, and Clarity**.
**Concept:** "Soft Matte". Think of high-quality wellness apps like Headspace or structured productivity tools like Notion.
**Keywords:** Solid, opaque, grounded, high-contrast, rounded, matte.

## 2. The New Design System

### A. Color Palette (Earth & Sage)
Use these exact specific colors for a calm, grounded look:
- **Background:** `#F9F9F7` (Warm Off-White / Paper tint). NOT pure white.
- **Surface Cards:** `#FFFFFF` (Pure White).
- **Primary Brand:** `#4A6C6F` (Deep Sage Green) - Used for buttons/active states.
- **Secondary:** `#D6E4E5` (Soft Blue-Green) - Used for secondary backgrounds.
- **Text Primary:** `#2C3333` (Soft Black) - High readability.
- **Text Secondary:** `#7D8787` (Muted Grey).

### B. Shapes & Shadows (The "Tactile" Feel)
- **Cards:**
    - Opacity: 100% (Solid). NO Blur.
    - BorderRadius: `BorderRadius.circular(24)` (Friendly curves).
    - Border: No border lines. Use shadow for separation.
    - Shadow: `BoxShadow(color: Color(0xFF4A6C6F).withOpacity(0.08), blurRadius: 24, offset: Offset(0, 8))` -> Very soft, diffused, colored shadow.
- **Buttons:**
    - Height: 56px (Large tap target).
    - Shape: `StadiumBorder` (Fully rounded caps).
    - Elevation: 0 (Flat look).

### C. Typography
- Font: **'Outfit'** or **'Plus Jakarta Sans'**.
- **Hierarchy:**
    - Headlines: Bold, Dark, Large (24-32sp).
    - Body: Clean, 1.5 height for readability.

## 3. Component Updates

### Widget 1: `AppScaffold`
- Remove the animated mesh/blobs.
- Use a solid `Scaffold` with `backgroundColor: Color(0xFFF9F9F7)`.
- Use a `SafeArea`.

### Widget 2: `ContentCard` (Replaces GlassCard)
- A Container with color `Colors.white`.
- Apply the specific shadow defined above.
- Add `Padding(all: 24)`.

### Screen Specifics

#### Home Screen
- **Header:** Left aligned "Good Morning, [Name]" in dark text.
- **Anxiety Slider:** A thick, solid track (Grey) with a large colored Circle thumb. NO glowing effects. Clean and mechanical.

#### Mini-Games (Clean Focus)
- **Background:** Solid muted color (e.g., `#EBF2F2`).
- **Elements:**
    - **Breathing:** The Lottie animation should be centered on a clean background. No glows interfering.
    - **Drawing:** High contrast lines on a "Canvas" colored background.
    - **Grid:** Tiles should be solid cards that flip crisply.

#### Analysis Result
- **Layout:** A clean report style.
- **Chart:** The Pie Chart should be on a white card. Use **Bold** colors for the chart sections (Sage Green vs Grey) so the contrast is sharp.
- **Text:** Use icons next to headers (e.g., [Science Icon] The Mechanism).

## 4. Implementation Steps for Cursor
1.  **Theme:** Update `main.dart` theme data with the new color palette (`scaffoldBackgroundColor`, `cardTheme`, `textTheme`).
2.  **Widgets:** Create `ContentCard` widget.
3.  **Refactor:** Replace all `GlassContainer` or `Container` with `ContentCard`.
4.  **Clean Up:** Remove all `BackdropFilter` and `ImageFilter.blur` codes.

**Action:** Apply this "Clean Matte" design to the Home Screen and Analysis Screen immediately.