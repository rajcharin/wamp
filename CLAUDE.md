# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a macOS app built with Xcode. Open `Wamp.xcodeproj` and build/run from Xcode, or use:

```bash
xcodebuild -project Wamp.xcodeproj -scheme Wamp -configuration Debug build
```

There are no tests, no linter, and no CI/CD configured.

## Architecture

Pure Swift/Cocoa (AppKit) macOS audio player replicating classic Winamp 2.x. No SwiftUI, no storyboards, no XIBs — all UI is programmatic. Zero external dependencies; uses only Apple frameworks (AVFoundation, Combine, Accelerate, MediaPlayer).

### Project Structure

```
Wamp/
├── AppDelegate.swift        — nib-less bootstrap (static func main()), owns singletons & window
├── Audio/
│   └── AudioEngine.swift    — AVAudioEngine graph: PlayerNode → 10-band EQ → Mixer → Output
├── Models/
│   ├── PlaylistManager.swift — track list, current index, shuffle, repeat, auto-advance
│   ├── StateManager.swift    — JSON persistence to ~/Library/Application Support/Wamp/
│   └── Track.swift           — audio file model with metadata parsing via AVURLAsset
├── UI/
│   ├── MainWindow.swift      — fixed-width (275px) borderless window
│   ├── MainPlayerView.swift  — time display, volume/balance sliders, transport controls
│   ├── EqualizerView.swift   — 10-band EQ sliders + presets + EQ response curve
│   ├── PlaylistView.swift    — table with drag-drop, search, keyboard nav, double-click-to-play
│   ├── WinampTheme.swift     — all design tokens (colors, sizes, fonts)
│   └── Components/
│       ├── TitleBarView.swift    — window title bar with pin/minimize/close buttons
│       ├── TransportBar.swift    — play/pause/stop/prev/next buttons
│       ├── LCDDisplay.swift      — retro LCD time display
│       ├── SevenSegmentView.swift — seven-segment digit renderer
│       ├── SpectrumView.swift    — real-time spectrum analyzer visualization
│       ├── EQResponseView.swift  — EQ frequency response curve
│       ├── WinampButton.swift    — themed button component
│       └── WinampSlider.swift    — themed slider component
└── Utils/
    └── HotKeyManager.swift   — media keys (play/pause/next/prev) & Now Playing info
```

### Data Flow

`AppDelegate` owns the core singletons and wires them together:

- **AudioEngine** (`ObservableObject`) — playback, 10-band EQ, spectrum data (32 bins via Accelerate), volume/balance/mute
- **PlaylistManager** (`ObservableObject`) — track list, shuffle, repeat modes (off/track/playlist), auto-advance on track finish
- **StateManager** — debounced saves (500ms), auto-restores on launch: volume, EQ bands/preamp/preset, playlist, window position, repeat mode, always-on-top

Views bind to models via **Combine** (`@Published` properties + `sink` subscriptions). State changes flow: User action → Model mutation → `@Published` fires → Views update.

### Window Layout

MainWindow stacks three panels vertically in a fixed 275px-wide borderless window:
- Player section: 148px height (title bar, LCD display, transport, volume/balance)
- Equalizer: 130px height (togglable)
- Playlist: 232px minimum height (resizable)

### Key Patterns

- **Nib-less bootstrap** — `AppDelegate` has an explicit `static func main()` because the default `@main` silently fails without a nib; `NSApp.setActivationPolicy(.regular)` is required
- **State persistence** — `AppState` and `EQState` are `Codable` structs saved as JSON; `StateManager` debounces writes
- **Track metadata** — `Track.fromURL(_:)` is `async` and uses `AVURLAsset` to load metadata (title, artist, album, genre, bitrate, sample rate, channels)
- **Spectrum analyzer** — AudioEngine installs a tap on the audio graph, uses Accelerate FFT for 32-bin spectrum data published via `@Published`
- **System tray** — `NSStatusItem` with menu for quick access
- **HotKeyManager** — handles media keys and publishes Now Playing info to Control Center via `MPNowPlayingInfoCenter`
- **WinampTheme** — centralizes all design tokens; retro palette uses grays, golds, and greens

## Git Workflow (Gitflow)

```
main      ← production; tagged releases only
develop   ← integration branch; all features merge here first
feature/* ← branch from develop; merge back to develop via PR
release/* ← branch from develop when ready to ship; merge to main + develop
hotfix/*  ← branch from main for urgent fixes; merge to main + develop
```

**Starting a feature:**
```bash
git checkout develop && git pull origin develop
git checkout -b feature/my-feature
# ... work ...
git push origin feature/my-feature
gh pr create --base develop
```

**Creating a release:**
```bash
git checkout -b release/1.2.0 develop
# bump version, test, fix only
git checkout main && git merge --no-ff release/1.2.0 && git tag v1.2.0
git checkout develop && git merge --no-ff release/1.2.0
git push origin main develop --tags
```

**Hotfix:**
```bash
git checkout -b hotfix/crash-fix main
# fix ...
git checkout main && git merge --no-ff hotfix/crash-fix && git tag v1.1.1
git checkout develop && git merge --no-ff hotfix/crash-fix
```

## Claude Code Setup

### Skills (slash commands)

| Command | Description |
|---------|-------------|
| `/build` | Build with xcodebuild and report errors |
| `/reload` | Kill Wamp and relaunch from last build |
| `/build-reload` | Build + reload in one step (primary dev cycle) |

Skill definitions are in `.claude/skills/`.

### Hooks (`.claude/settings.json`)

| Hook | Trigger | Action |
|------|---------|--------|
| `PostToolUse` | Edit/Write on `.swift` files | Prints reminder to run `/build-reload` |
| `Notification` | Claude needs input | Shows macOS notification with sound |
| `Stop` | Claude finishes a turn | Prints current branch + uncommitted file list |

### MCP Servers (`.mcp.json`)

| Server | Purpose |
|--------|---------|
| `github` | Create/manage issues and PRs for `rajcharin/wamp` — requires `GITHUB_TOKEN` env var |
| `filesystem` | Direct file access scoped to the project root |

To activate GitHub MCP: `export GITHUB_TOKEN=ghp_...` in your shell before launching Claude Code.

## Conventions

- Commit messages use conventional format: `feat:`, `fix:`, `chore:`, `style:`
- App sandbox is **disabled** (entitlements) to allow filesystem access and media key handling
- Supported audio formats: MP3, AAC, M4A, FLAC, WAV, AIFF, AIF
- All UI components are custom `NSView` subclasses — no Interface Builder usage
- Playlist supports drag-and-drop (files from Finder), keyboard navigation (arrows, Return to play), and search
