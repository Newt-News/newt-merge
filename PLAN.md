# Project Plan: Newt Merge

## Overview
A 2D portrait-mode merge game built in Flutter.
- **Theme:** Roughskinned newt in an Oregon creek setting.
- **Visual Style:** Bright, cartoonish, and playful. Newts use brownish red/orange color patterns.
- **Environment:** Antigravity IDE (VS Code Fork).
- **State Management:** Riverpod 3.0 (using `@riverpod` generators).
- **Database:** Isar (Local-only persistence).
- **Monetization:** AdMob (Bottom-anchored Banner) — deferred, using test IDs.
- **Platforms:** Android, iOS, and Web (GitHub Pages deployment).
- **Grid:** Progressive — starts at 2x2, grows one slot at a time up to 5x5 (25 total slots).

---

## Core Game Mechanics

### Scoring
- Points are awarded on each merge.
- **Cumulative:** Points are never spent — they accumulate like XP.
- **Exponential scaling:** Higher-tier merges yield exponentially more points.
  - `egg → larva`: 10 pts
  - `larva → larvaPlus`: 20 pts
  - `larvaPlus → eft`: 40 pts
  - `eft → adult`: 80 pts
  - `adult → elder`: 160 pts

### Creek Level (Progression)
- Creek Level is the primary progression metric.
- Leveling up unlocks additional grid slots:
  - **Level 1:** 2x2 (4 slots)
  - **Levels 2-5:** Add 1 slot each (5, 6, 7, 8 slots)
  - **Levels 6-9:** Continue adding to reach 3x3 equivalent and beyond
  - **Max Grid:** 5x5 (25 slots)
- Level-up thresholds increase progressively (e.g., 100 → 250 → 500 → 1000 pts).

### Spawning
- The "Incubator" button spawns a new `egg` into a random empty slot.
- **No cooldown or cost** — players can spawn freely until the board is full.
- As "Highest Stage Discovered" increases, a weighted chance (5-10%) allows spawning `larva` or `eft` directly.

### Win/Lose Conditions
- **Lose:** Board is full AND no valid merges exist.
- **Win:** None — this is an endless progression game. The goal is to maximize Creek Level and Points.

---

## Phase 1: Environment & Scalable Architecture
- **Environment:** Initialize Flutter project. Add dependencies to `pubspec.yaml`:
  - `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
  - `shared_preferences` (Isar has analyzer conflicts with Riverpod generator)
  - `google_mobile_ads`, `uuid`
- **Domain Modeling:**
  - Define a `Newt` class with a unique `id` and an `EvolutionStage` enum:
    - `egg`, `larva`, `larvaPlus`, `eft`, `adult`, `elder`
  - Define a `GridSlot` model to represent unlocked/locked slots.
  - Define a `GameState` enum: `playing`, `gameOver`.
- **Riverpod Setup:** Implement a `BoardNotifier` class using the `@riverpod` annotation.
- **State Initialization:**
  - Board state: `List<Newt?>` with length equal to current unlocked slots (starts at 4).
  - Player state: `creekLevel`, `points`, `highestStageDiscovered`.

## Phase 2: Reactive UI Shell (Portrait Only)
- **Constraint:** Lock app to `DeviceOrientation.portraitUp` in `main.dart`.
- **Layout:** Build a `Scaffold` with a `Column`:
  1. **Scoreboard:** Top section showing "Creek Level" and "Points".
  2. **The Creek:** An `Expanded` widget containing a dynamic `GridView` that adapts to current slot count.
  3. **Incubator Button:** A button to spawn new eggs.
  4. **Ad Slot:** A `SizedBox` at the very bottom with a fixed height of 50px for the Banner (placeholder for now).
- **Newt View:** Create a stateless widget that maps `EvolutionStage` to its corresponding asset.
- **Grid Rendering:**
  - Always render the **full next-tier grid** (e.g., at 5 unlocked slots, show full 3x3 = 9 slots).
  - **Grid tiers:** 2x2 (4) → 3x3 (9) → 4x4 (16) → 5x5 (25).
  - **Locked slots:** Dimmed/grayed-out placeholders showing goals ahead.
  - **Unlocked slots:** Fully interactive, can receive newts.
- **Game Over Screen:**
  - Modal overlay when lose condition is triggered.
  - Shows final score (Points) and Creek Level.
  - "Second Chance" button (watches ad to remove one piece — free for now).
  - "New Game" button to restart.
  - *Future-ready:* Leave hooks for leaderboard/high-score display.

## Phase 3: Drag-and-Drop Core Loop
- **Dragging:** Wrap each non-null cell in a `Draggable<int>`, passing its `index` as the data.
- **Dropping:** Wrap every grid cell in a `DragTarget<int>`.
- **Board Actions:**
  - **Move:** If target index is `null`, update list: `target = source; source = null;`.
  - **Merge:** If `target.stage == source.stage` (and not `elder`), replace target with a new `Newt` of the next stage, set source to `null`, and award points.
- **Lose Detection:** After each action, check if board is full and no valid merges exist.
- **Scalability:** All board mutations must happen within the `BoardNotifier` to keep UI logic separate from game rules.

## Phase 4: Discovery & Progression
- **Progress Tracking:** Create a `PlayerStatsNotifier` to track:
  - `creekLevel`, `points`, `highestStageDiscovered`
- **Level-Up Logic:** When points exceed the threshold for the next level:
  - Increment `creekLevel`.
  - Unlock one additional grid slot (up to 25 max).
  - Recalculate next threshold.
- **Spawning Logic:** Implement a `spawnNewt()` action:
  - **Base:** Always spawn an `egg`.
  - **Advanced:** As "Highest Stage" increases, add a weighted probability (5-10%) to spawn `larva` or `eft`.
- **UI Trigger:** "Incubator" button calls `spawnNewt()`. Disabled when board is full.

## Phase 5: Persistence
- **Isar Setup:** Initialize Isar in `main()` with `path_provider` for directory.
- **Auto-Save:** Use a Riverpod `ref.listen` to write game state to Isar on every change.
- **Hydration:** On app start, `BoardNotifier` checks Isar and populates initial state from the database.
- **Reset:** Provide a "New Game" option that clears Isar and resets state.

## Phase 6: Assets & Visual Polish
- **Newt Assets:** Create/generate assets for each evolution stage:
  - `egg` — small, rounded, speckled
  - `larva` — tiny aquatic form with gills and no legs
  - `larva +` — tiny aquatic form with gills and legs
  - `eft` — juvenile land form, vibrant orange and slightly smaller than adult
  - `adult` — full roughskinned newt, brownish-red with orange belly
  - `elder` — "Bearded Elder" with distinct glow/shimmer animation and noticeable vertical lobes on its tail, chunkier arms/legs just like adult male roughskinned newts
- **Creek Background:** Oregon creek aesthetic — rocks, water, greenery.
- **Color Palette:** Bright and cartoonish. Primary newt colors: browns, oranges
- **Animations:** Merge animation, spawn animation, level-up celebration.

## Phase 7: Monetization & Future-Proofing
- **AdMob:** 
  - Use test Ad Unit IDs during development.
  - Initialize `MobileAds` and load `BannerAd` into bottom slot.
  - Document how to swap in production IDs.
- **Sound Service:** Create a `SoundService` class shell (empty for now) for future audio.
- **Analytics:** (Optional) Prepare hooks for Firebase Analytics.

---

## Technical Notes
- **Flutter SDK:** Latest stable channel.
- **Dart:** 3.x with null safety and modern features.
- **Web Deployment:** GitHub Pages via `flutter build web`.
- **Testing:** Unit tests for game logic (merge, spawn, level-up, lose detection).

---

## Scalability & Future Features
The architecture should make it easy to add:
- **Leaderboards:** Global/local high-score tracking.
- **Achievements:** Milestone badges (e.g., "First Elder", "Creek Level 10").
- **Daily Challenges:** Special objectives with rewards.
- **Power-ups:** Consumables like "Remove any newt" or "Free merge".
- **Themes:** Alternate creek/newt skins.
- **Sound/Music:** SoundService shell ready for audio integration.