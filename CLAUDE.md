# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CapiLift is an iOS carpooling app for employees commuting between home and company campuses (Stellenbosch and Canal Walk, South Africa). It matches drivers with passengers, tracks sustainability metrics (CO₂ saved), and rewards participation with a points system.

## Build & Run

Open the Xcode project:
```
open CapiLift/CapiLift.xcodeproj
```

Build from CLI (simulator):
```
xcodebuild -project CapiLift/CapiLift.xcodeproj -scheme CapiLift -sdk iphonesimulator build
```

Run tests:
```
xcodebuild test -project CapiLift/CapiLift.xcodeproj -scheme CapiLift -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```

Run a single test class:
```
xcodebuild test -project CapiLift/CapiLift.xcodeproj -scheme CapiLift -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:CapiLiftTests/CapiLiftTests
```

## Architecture

### State Management
The app uses **Swift Observation (`@Observable`)** — not the older `ObservableObject`/`@Published` pattern. Three global objects are injected into the environment at the root in `CapiLiftApp.swift`:

- `AuthState` — authentication state, current user, and the `pendingReviewDriver` trigger for the post-ride review sheet
- `AppRouter` — `NavigationPath`-based programmatic navigation with typed `Destination` enum cases
- `TabSelection` — shared tab index (0=Home, 1=Schedule, 2=Matches, 3=Chats, 4=Points)

Views consume these via `@Environment(AuthState.self)` etc. When modifying a `@Observable` object inside a view, use `@Bindable var x = x` to get bindings.

### Auth & Navigation Flow
```
SignInView  →  (SSO complete)  →  OnboardingView (5 steps)  →  MainTabView
```
`AuthState.isAuthenticated` (non-nil `currentUser`) gates access to `MainTabView`. `hasCompletedSSO` gates whether `OnboardingView` or `SignInView` is shown.

Onboarding steps: 1 Profile → 2 Location → 3 Campus → 4 Role (driver/passenger/both) → 5 Schedule. `OnboardingProfile` is the local draft struct passed as `@Binding` through all steps.

### Networking
`APIClient` is a Swift `actor` singleton (`APIClient.shared`). Base URL: `https://api.capilift.co.za`. All requests attach a JWT from `KeychainService` as a Bearer token. JSON uses snake_case on the wire and is decoded to camelCase Swift models via `keyDecodingStrategy: .convertFromSnakeCase`.

### Mock Data
The UI currently runs on mock data — `MockMatch`, `MockPassenger`, and `MockConversation` provide preview/development data. `ChatViewModel` is initialised with a `MockMatch` and builds mock messages locally. When wiring real API calls, replace the mock initialisers.

### Design System
All UI tokens are prefixed `LC`. Use these everywhere — do not hardcode colors, fonts, or spacing.

| Token type | File | Usage |
|---|---|---|
| Colors | `DesignSystem/LCColors.swift` | `Color.lcGreen`, `.lcBackground`, `.lcCard`, `.lcText`, `.lcMuted`, `.lcBorder`, `.lcCoral` |
| Fonts | `DesignSystem/LCFonts.swift` | `Font.lcTitle`, `.lcBody`, `.lcBodyBold`, `.lcCaption`, etc. |
| Spacing | `DesignSystem/LCSpacing.swift` | `LCSpacing.xs/sm/md/lg/xl/xxl`, `LCRadius.sm/md/lg/xl/pill` |
| Components | `DesignSystem/Components/` | `LCPrimaryButton`, `LCCard`, `LCTextField`, `PointsPill` |

Note: `lcGreen` is actually **royal blue** (`#0052CC`) — the name is legacy. `lcAccent`/`lcCoral` are the same burnt-orange value and used for errors/destructive actions.

### Core Models
- `User` — employee with home coordinates, campus, and points total
- `Match` / `MatchPassenger` — a ride with a driver and passengers, statused through pending → accepted → completed/cancelled
- `ScheduleDay` / `WeekSchedule` — per-day office attendance with driver/passenger/both role
- `PointsLedgerEntry`, `Reward`, `LeaderboardEntry` — points economy models
- `Message` — belongs to a match (group chat per ride)

### Feature Structure
Each feature lives under `Features/<Name>/` with its views, view models, and mock data co-located. Sub-components live in a `Components/` subfolder within the feature.
