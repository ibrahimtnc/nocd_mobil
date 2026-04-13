# MISSION: PHASE 5 - "The Intellectual & Editorial Overhaul"

## 1. Critique & Vision
The current app looks generic, and the AI responses feel too robotic/standard.
**NEW GOAL:** Create a "Premium Editorial" experience. Think of high-end journalism apps (NYT, Arc) meets Apple Health.
**The Vibe:** Intelligent, Scientific, Serene, High-Authority.
**Key Changes:**
1.  **Typography Revolution:** Use **Serif fonts** for Headings (Authority) + **Sans-Serif** for Body (Cleanliness).
2.  **Editorial Layout (Bento Grid):** Display analysis results in a structured, grid-like dashboard, not just a list of cards.
3.  **Genius AI:** The AI must use metaphors, name specific cognitive distortions, and provide "Sherlock Holmes" style deductions.

## 2. Design System 3.0: "The Editorial Paper"

### A. Typography (The Soul of the Design)
- **Headings:** Use **'Lora'** or **'Playfair Display'**. This gives a "Medical/Scientific Journal" feel.
    - Color: Dark Charcoal `#1A2C2A`.
- **Body:** Use **'Outfit'** or **'Inter'**. High readability.
    - Color: Slate Grey `#4A5568`.

### B. Color Palette (Sophisticated)
- **Background:** `#F7F7F5` (Warm Paper White).
- **Primary Accent:** `#3A5A40` (Deep Hunter Green) - For active states.
- **Secondary Accent:** `#A3B18A` (Muted Sage) - For backgrounds.
- **Surface:** `#FFFFFF` (Pure White) with a very subtle border: `Border.all(color: Colors.black.withOpacity(0.05))`.

### C. UI Component: "Bento Card"
Instead of standard cards with shadows, use "Editorial Blocks":
- **Shape:** Rounded Rectangles (Radius 20).
- **Style:** White background, no shadow, subtle grey border (1px).
- **Layout:** Content inside should look like a magazine snippet (Big numbers, bold icons, Serif titles).
## 1. The Problem
The current "Risk Analysis" widget shows generic percentages (e.g., "Actual Risk: 0.01%"). This is too abstract.
**NEW GOAL:** The widget must explain **WHY** the risk is low, using specific logic derived from the user's input.
**Example:**
- If user fears germs -> Reason: "Bacteria cannot survive on dry surfaces."
- If user fears unlocked door -> Reason: "Muscle memory handles routine tasks."

## 2. Backend (Node.js) Update
Update the `index.js` System Prompt and JSON structure to include specific **short reasons** for the statistics.

**Update JSON Structure:**
```json
{
  // ... existing fields ...
  "risk_analysis": {
    "perceived_risk_percent": 99.9,
    "perceived_reason": "Based on the intense anxiety (10/10) you feel.",
    "actual_risk_percent": 0.01,
    "actual_reason": "Specific scientific/logical reason (max 10 words).",
    "comparison_analogy": "A one-sentence metaphor comparing this probability to something absurd (e.g., 'You are more likely to be struck by lightning twice')."
  }
}