# 🦎 Newt Merge

A 2D merge game featuring roughskinned newts in an Oregon creek setting. Built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.27-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6-blue?logo=dart)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## 🎮 Game Overview

Merge newts through their evolution stages to level up your creek! Start with a 2×2 grid and unlock more space as you progress.

### Evolution Stages
🥚 **Egg** → 🐛 **Larva** → 🦎 **Larva+** → 🔶 **Eft** → 🦎 **Adult** → 👑 **Elder**

### Features
- **Progressive Grid:** Start with 2×2, grow to 5×5 as you level up
- **Merge Mechanics:** Combine same-stage newts to evolve them
- **Creek Levels:** Earn points through merges to unlock more grid slots
- **Endless Gameplay:** No win condition — keep evolving!

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.27+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### Installation

```bash
# Clone the repository
git clone https://github.com/Newt-News/newt-merge.git
cd newt-merge

# Install dependencies
flutter pub get

# Run on web (quickest for testing)
flutter run -d chrome

# Run on Android
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios
```

### Local SDK Setup (This Project)

This project has Flutter installed locally in the `./flutter/` directory. To run:

```bash
# From the project root
./flutter/bin/flutter run -d chrome
```

To add Flutter to your PATH permanently:
```bash
echo 'export PATH="$PATH:/home/jay/Repos/newt-merge/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Now you can use flutter globally
flutter run -d chrome
```

## 🏗️ Project Structure

```
lib/
├── domain/           # Data models
│   ├── evolution_stage.dart   # 6 evolution stages
│   ├── newt.dart              # Newt entity
│   ├── player_stats.dart      # Points, level, progression
│   ├── grid_slot.dart         # Locked/unlocked slots
│   └── game_state.dart        # Playing vs game over
├── providers/        # Riverpod state management (coming soon)
├── screens/
│   └── game_screen.dart       # Main game layout
├── services/
│   └── sound_service.dart     # Audio shell (future)
├── widgets/
│   ├── scoreboard.dart        # Creek Level + Points
│   ├── creek_grid.dart        # Dynamic game grid
│   ├── grid_cell.dart         # Individual cells
│   ├── newt_view.dart         # Newt visuals
│   ├── incubator_button.dart  # Spawn eggs
│   └── ad_banner_slot.dart    # AdMob placeholder
└── main.dart                  # App entry point
```

## 🎯 Roadmap

- [x] **Phase 1:** Environment & Architecture
- [ ] **Phase 2:** Reactive UI Shell
- [ ] **Phase 3:** Drag-and-Drop Core Loop
- [ ] **Phase 4:** Discovery & Progression
- [ ] **Phase 5:** Persistence
- [ ] **Phase 6:** Assets & Visual Polish
- [ ] **Phase 7:** Monetization & Future-Proofing

See [PLAN.md](PLAN.md) for detailed implementation plan.

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.27 |
| Language | Dart 3.6 |
| State Management | Riverpod 3.0 |
| Persistence | shared_preferences |
| Ads | Google Mobile Ads (planned) |

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📱 Platforms

| Platform | Status |
|----------|--------|
| Android | ✅ Ready |
| iOS | ✅ Ready |
| Web | ✅ Ready |
| Linux | 🔧 Available |
| macOS | 🔧 Available |
| Windows | 🔧 Available |

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by merge games like *Merge Dragons* and *2048*
- Roughskinned newt (*Taricha granulosa*) — native to the Pacific Northwest
- Built with ❤️ in Oregon