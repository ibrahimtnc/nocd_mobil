# Project Specification: "OCD Coach" - Phase 2: Polish, Depth, and Structure

## 1. Executive Summary & Phase 2 Goals
We have a functional MVP (Phase 1) based on the previous specifications. The core flow (Home -> Negotiation -> Game -> Result) works.
**Phase 2 Goals (CRITICAL):**
1.  **Elevate UI/UX:** Move from "basic functional" to "premium wellness app." The design must feel warmer, safer, and more professional.
2.  **Deepen AI Analysis:** The current output is too generic. The new analysis must be deeply scientifically grounded, empathetic, and specifically emphasize cognitive reframing (helping the user realize "it's a brain glitch, not my fault").
3.  **Enhance Engagement (Games):** Improve existing mini-games and add better ones to truly distract during high anxiety.
4.  **Add Structure & Localization:** Implement Bottom Navigation (Home, History, Settings) and full English/Turkish support.

## 2. Architectural Changes & Navigation
- **Introduce Bottom Navigation Bar:**
  - Create a main scaffolding widget that holds a `BottomNavigationBar`.
  - **Tabs:**
    1.  **Home:** (The current main screen).
    2.  **History:** (New screen listing past analyses listed by date/trigger).
    3.  **Settings:** (New screen for Language switching, Dark Mode toggle, About).
- **Routing:** Update GoRouter to handle this new nested navigation structure.

## 3. Localization (i18n) Infrastructure (High Priority)
- **Setup:** Implement `flutter_localizations` and `intl`.
- **ARB Files:** Create `app_en.arb` and `app_tr.arb`.
- **Scope:**
  - All static UI strings (titles, buttons, onboardings) must be localized.
  - **Crucial:** The current selected language code ('en' or 'tr') must be passed to the Firebase Cloud Function when requesting AI analysis, so the backend generates the response in the correct language.

## 4. UI/UX Polish & Redesign Instructions (Based on Screenshots)
*The current design feels a bit too standard. Let's elevate it.*

### General Styling
- **Card Styling:** Instead of heavy shadows, use lighter backgrounds with subtle borders and very soft, diffused shadows. Increase internal padding for a "breathing room" feel.
- **Typography:** Improve hierarchy. Headings should be bolder, body text needs better line height (1.5x) for readability.

### Specific Screen Improvements
- **Negotiation Sheet (image_1.png):** It looks too basic. Make it a modal with highly rounded top corners. Add a visible "grabber handle" icon at the top. The buttons need to be larger and friendlier (capsule shape).
- **Game Screen (image_4.png - Bubble Wrap):**
  - *Visuals:* Make bubbles look more organic/jelly-like, not perfect circles. Add a subtle gradient background.
  - *Feedback:* Enhance `HapticFeedback`. Use `heavyImpact` on pop. Add a satisfying, soft "pop" sound effect (using a simple audio package).
- **Analysis Screen (image_2.png, image_3.png):**
  - **The Pie Chart:** It feels flat. Add a subtle outer glow to the green section. Make the center text (percentage) larger and bolder.
  - **Content Blocks:** They are too dense. Break them down with small, friendly icons next to headers (e.g., a Brain icon for Reframing, a Microscope for Mechanics). Use distinct background colors for different sections (e.g., very soft purple for Mechanics, soft green for Reframing).

## 5. The New AI Analysis Structure (Backend & Frontend)
*The current analysis is insufficient. We need a richer structure.*

### New JSON Schema (Expected from Backend)
Update the Firebase Function system prompt to generate this structured JSON:

```json
{
  "empathetic_validation": "A short sentence acknowledging how real the fear feels right now.",
  "the_science_mechanism": "A detailed paragraph explaining the actual physics/biology of the trigger, debunking the magical thinking.",
  "the_brain_glitch": "Crucial section explaining WHY they had this thought. E.g., 'Your Amygdala fired a false alarm. It's a biological misfire, not a reflection of your character or reality.'",
  "risk_analysis": {
    "perceived_risk_percent": 99.9,
    "actual_risk_percent": 0.01,
    "safety_percent": 99.99,
    "analysis_summary": "A sentence comparing the two risks."
  },
  "actionable_takeaway": "A small, non-compulsive tip for the next hour."
}