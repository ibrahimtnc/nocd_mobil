# Project Specification: "OCD Coach" - OCD Resilience & Coping App (MVP)

## 1. Executive Summary & Role
You are an Expert Senior Flutter Architect and Product Designer. We are building a high-quality MVP for an OCD coping application. 
**Core Philosophy:** The app helps users manage anxiety not by providing reassurance, but by building tolerance to uncertainty through ERP (Exposure Response Prevention) techniques.
**Monetization Goal:** The app must feel premium, secure, and scientifically grounded to justify future subscriptions.

## 2. Tech Stack & Architecture
- **Framework:** Flutter (Latest Stable).
- **Architecture:** Feature-First Clean Architecture (`lib/src/features/...`).
- **State Management:** Riverpod (with Code Generation `flutter_riverpod`, `riverpod_annotation`).
- **Navigation:** GoRouter.
- **Local Storage:** Hive (CRITICAL for user privacy. Data stays on device).
- **Backend (Serverless):** Firebase Auth (Anonymous Sign-in ONLY), Firebase Functions (to securely proxy OpenAI API calls).
- **UI/UX Packages:** `google_fonts`, `fl_chart` (for probability graphs), `flutter_animate` (smooth transitions), `flutter_vibrate` or `haptic_feedback` (for tactile mini-games).

## 3. Design System (Premium & Calming)
- **Visual Style:** "Soft UI", Modern Minimalist, High-end Wellness app vibe.
- **Color Palette:**
  - **Primary:** Deep Sage Green (`#4A7C59`) - Represents growth/calm.
  - **Secondary:** Soft Beige/Sand (`#F5F5DC`) - Background.
  - **Accent:** Muted Lavender (`#967BB6`) - For highlights.
  - **Anxiety High:** Terracotta (`#E2725B`) - Never use bright red.
  - **Anxiety Low:** Soft Teal (`#88D8B0`).
- **Typography:** Rounded sans-serif (e.g., 'Nunito' or 'Quicksand'). readable and friendly.
- **Components:** Large border radius (24.0), subtle drop shadows, breathing animations.

## 4. User Journey & Feature Specifications (Strict Flow)

### Phase A: Trust-First Onboarding
1.  **Splash:** Gentle logo fade-in.
2.  **Privacy Guarantee:** A prominent screen stating: "Your thoughts are encrypted locally on this device. We do not store your personal diary." (Icon: Lock).
3.  **Disclaimer:** "This is a coaching tool, not a medical device." (User must tap 'I Understand').
4.  **Setup:** "What should we call you?" (Nickname only).

### Phase B: The Trigger (Home Screen)
1.  **Mood Check:** "How strong is the anxiety right now?" (Slider 1-10).
    - *Visual:* Slider changes color from Teal (1) to Terracotta (10).
2.  **The Worry:** A clean, large text input area: "Describe the thought..."
3.  **CTA Button:** "Analyze Thought" -> Triggers Phase C.

### Phase C: The Negotiation (The "Hook")
*Do not go to results immediately.* Show a Modal Bottom Sheet.
- **AI Coach:** "I know you want certainty right now. But let's try to delay the compulsion. Can we wait **2 minutes** together?"
- **Buttons:**
  - [Yes, I can try] -> Launches Phase D (2 min timer).
  - [No, it's too hard] -> **Downsell Logic:** "Okay, let's just do **30 seconds** of deep breathing." -> Launches Phase D (30s timer).

### Phase D: Active Waiting (Mini-Games)
*Goal: Distraction & Grounding. Randomly load one of these widgets:*
1.  **Widget 1: Bubble Wrap (Tactile)**
    - A GridView of 30 soft circles.
    - Tap -> Visual "Pop" animation + Haptic Feedback.
    - Sound: Soft "Pop".
2.  **Widget 2: Neon Trace (Focus)**
    - User must trace a glowing line with their finger.
    - If they let go, it fades.
3.  **Widget 3: Breath Synchronizer (Bio)**
    - A circle expands (4s) and shrinks (4s).
    - Text: "Inhale... Hold... Exhale".
*Top of screen:* A subtle countdown timer. When 00:00, show "Analysis Ready" button.

### Phase E: The Reward (Scientific Analysis)
*This is the core value proposition.*
Fetch data from OpenAI. Display in a scrollable, beautiful layout:
1.  **Validation Card:** "You waited [X] minutes. That was the hardest part."
2.  **Probability Chart (Pie Chart):**
    - Slice 1 (Green, 99.9%): "Actual Safety / Scientific Probability".
    - Slice 2 (Gray, 0.1%): "Theoretical Risk (The Uncertainty)".
    - *Caption:* "Life is never 0% risk, but look how small the actual danger is."
3.  **The Mechanics (Science):** Explain *why* the fear is likely a false alarm based on physics/biology (e.g., how soap works, how locks work).
4.  **Cognitive Reframing:** A comparison of "What you feel" vs "What is real".

## 5. Technical Requirements for AI (System Prompt)
When calling the API, the system prompt must be:
"You are an OCD Coach using CBT/ERP techniques. Never give reassurance (e.g., 'You are definitely safe'). Instead, explain the mechanism of the fear scientifically. 
Output JSON format:
{
  'validation_message': '...',
  'scientific_explanation': '...',
  'actual_risk_percentage': 0.1,
  'safety_percentage': 99.9,
  'cognitive_reframe': '...'
}"

## 6. Implementation Plan for Cursor
Please follow this order:
1.  **Project Setup:** Folder structure, themes, constants, dependencies.
2.  **Phase A & B:** Onboarding and Home UI.
3.  **Phase D:** The Mini-Games (Focus on haptics and animation).
4.  **Phase C:** The Logic connecting Home to Games.
5.  **Phase E:** Mock API service first, then UI implementation with Charts.
6.  **Integration:** Connect real OpenAI API.

**Action:** Start by analyzing this prompt, confirming you understand the "Premium MVP" goal, and proposing the folder structure.