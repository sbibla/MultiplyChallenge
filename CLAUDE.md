# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iOS educational math game (SwiftUI, iOS 15+) where players solve math equations to reveal a hidden image tile-by-tile. Despite the directory name `MultiplyChallenge`, the Xcode project is named `AdditionChallenge` — both names are used interchangeably.

## Build & Run

Open `AdditionChallenge.xcodeproj` in Xcode. There is no Package.swift or CLI build system; all building and testing is done through Xcode or `xcodebuild`:

```bash
# Build from CLI
xcodebuild -project AdditionChallenge.xcodeproj -scheme AdditionChallenge -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests (if any exist)
xcodebuild test -project AdditionChallenge.xcodeproj -scheme AdditionChallenge -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

**Pattern**: MVVM with SwiftUI. State is held in `@State`/`@StateObject` on views or `ObservableObject` ViewModels. No external dependencies — pure Apple frameworks only.

**Core game loop** (`Views/GameFile.swift`):
- Displays a 4×4 grid of tile buttons, each mapped to a math equation
- Player taps a tile → sees 3 answer choices → correct answer reveals that tile
- 5 mistakes allowed per level; every 3 levels triggers a bonus level
- Level data (high score, level reached) persisted via `UserDefaults`

**Math generation** (`Other/MathQuestionBuilder.swift`):
- Singleton (`MathQuestionBuilder.shared`) that generates equations and plausible wrong answers
- `generateAdditionEquation(_:)` is the active path; `generateMultiplicationEquation(_:)` is implemented but unused in the current game flow
- Returns a tuple `(equationString, ans1, ans2, ans3, correctIndex)`

**Image system** (`Models/PhotoPickerViewModal.swift`):
- Ships with default backgrounds in `background Images/` (default + Pokemon themes)
- Users can import from photo library; images saved as `UserImage1.jpg`, `UserImage2.jpg`, … in `Documents/userBackgroundImages/`, up to 50 images

**Bonus level** (`Views/BonusView.swift`):
- 60-second timed "Which is Bigger?" comparison game between two addition equations
- Has its own score tracking separate from the main game

**Logging**: `Other/Logger.swift` — singleton `logManager.shared`, three levels (`.debug`, `.info`, `.warning`), emoji-tagged output. Use this instead of `print`.

**Alerts**: Standardized via `Utilities/Alert/Alert.swift` (`AlertItem`/`AlertContext`) and `CustomModifiers.swift` for consistent button styling.

## Key Observations for Development

- **Operation switching**: The game calls `generateAdditionEquation` in `GameFile.swift`. To enable multiplication, swap the call to `generateMultiplicationEquation` — the builder already supports it.
- **Commented-out Firebase code**: Several files (`MathQuestionBuilder.swift`, `PhotoPickerViewModal.swift`, others) have commented Firebase/Firestore references from an earlier multiplayer prototype. These are dead code.
- **Login system**: `Views/LoginView.swift` and `Models/LoginViewModel.swift` exist but login is not wired to any backend — placeholder only.
- **Multi-touch prevention**: `AdditionChallengeApp.swift` sets `UIApplication.shared.isExclusiveTouch` — intentional for single-finger game interaction.
