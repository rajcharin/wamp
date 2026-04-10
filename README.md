<div align="center">

# Wamp

### A retro audio player for macOS 🦙

A native macOS audio player inspired by the classic Winamp 2.x era — built entirely with Swift and AppKit.

No Electron. No web views. No dependencies. Just pure native macOS.


<img width="411" height="605" alt="image" src="https://github.com/user-attachments/assets/25b475ea-65ab-4307-a4ce-843adb048fa8" />



[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS-000000?logo=apple&logoColor=white)](https://www.apple.com/macos)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## Features

**Player**
- Classic transport controls — play, pause, stop, previous, next
- Volume and balance sliders with real-time response
- Retro LCD time display with seven-segment digits — shows track time and release year
- Real-time spectrum analyzer visualization
- Album artwork display (overlays the spectrum analyzer when artwork is available)
- Scrolling track title display

**10-Band Equalizer**
- Fully adjustable EQ with preamp control
- Live frequency response curve
- Built-in presets (Rock, Pop, Jazz, Classical, and more)
- Toggle on/off without losing settings

**Playlist**
- Drag & drop files directly from Finder
- Keyboard navigation — arrow keys to browse, Return to play
- Multi-select with standard Cmd+Click and Shift+Click
- Search through your library instantly (locale-aware — works with Thai, Chinese, Japanese)
- Sort by Title, Artist, Album, or Duration — toggle ascending/descending
- Right-click context menu: Show in Finder, Copy File Path(s), Remove from Playlist
- Shuffle and repeat modes (off / track / playlist)
- Supports MP3, AAC, M4A, FLAC, WAV, and AIFF

**Customization**
- Adjustable UI scale — change a single value in `WinampTheme.scale` to resize the entire player

**System Integration**
- Media key support — play/pause, next, previous from your keyboard
- Now Playing integration with macOS Control Center and Lock Screen (with album artwork, genre, and track number)
- System tray menu for quick access
- Always-on-top (pin) window mode
- Full state persistence — picks up right where you left off

---

## What's New (vs [wishval/wamp](https://github.com/wishval/wamp))

### Multi-language metadata support
Old MP3 files tagged in non-UTF-8 encodings (Thai TIS-620, Japanese Shift-JIS, Chinese GBK/Big5) display correctly instead of garbled Latin characters. The fix detects mojibake by checking whether all non-ASCII characters fall in the U+0080–U+00FF Latin Extended range, recovers the raw bytes, and re-interprets them using the correct encoding.

Playlist search also uses locale-aware matching (`localizedCaseInsensitiveContains`) so Thai and CJK search works correctly. Playlist file URLs are now stored as percent-encoded `file://` strings so paths with non-ASCII folder names survive save/reload.

### Track number and release year
Track number is extracted from the ID3 `TRCK` tag (not available via AVFoundation's common metadata keys). Release year is extracted from `commonKeyCreationDate`. Both are stored in the `Track` model (backward-compatible with existing playlist JSON), surfaced in the macOS Now Playing info, and the year is shown in the LCD display as a `[YYYY]` suffix.

### Album artwork
Artwork is loaded async from embedded tags on demand (not stored in the playlist JSON — `NSImage` is not `Codable`). It appears as an overlay on the spectrum analyzer in the player and is sent to macOS Control Center and the Lock Screen via `MPMediaItemArtwork`. Artwork is cached per track URL to avoid reloading every second.

### Playlist sort
A **SORT** button opens a menu to sort by Title, Artist, Album, or Duration. Selecting the same field again toggles ascending/descending. **Clear Sort** restores the original playlist order.

### Multi-select and right-click context menu
The playlist table supports standard multi-selection (Cmd+Click, Shift+Click). Right-clicking builds a context menu dynamically:
- **Show in Finder** — available when a single track is selected
- **Copy File Path(s)** — copies all selected paths, one per line
- **Remove from Playlist** — removes all selected tracks (with count shown)

Right-clicking an unselected row auto-selects it before the menu appears.

---

## Tech Stack

| | |
|---|---|
| **Language** | Swift 5 |
| **UI Framework** | AppKit (100% programmatic, zero XIBs) |
| **Audio** | AVFoundation + AVAudioEngine |
| **DSP** | Accelerate (FFT for spectrum analysis) |
| **Media Keys** | MediaPlayer framework |
| **State** | Combine + JSON persistence |
| **Dependencies** | None. Zero. Nada. |

## Architecture

```
AppDelegate
├── AudioEngine          PlayerNode → 10-Band EQ → Mixer → Output
├── PlaylistManager      Track list, shuffle, repeat, auto-advance
├── StateManager         JSON persistence with debounced saves
└── MainWindow           275px fixed-width borderless window
    ├── MainPlayerView       LCD display, transport, sliders, artwork overlay
    ├── EqualizerView        10-band EQ + response curve
    └── PlaylistView         Scrollable table with drag-drop, sort, multi-select
```

Views subscribe to model changes via **Combine** publishers — no delegates, no notification spaghetti.

## Getting Started

### Requirements

- macOS 14.0+
- Xcode 15+

### Build & Run

```bash
# Clone the repo
git clone https://github.com/rajcharin/wamp.git
cd wamp

# Build from command line
xcodebuild -project Wamp.xcodeproj -scheme Wamp -configuration Debug build

# Or just open in Xcode and hit ⌘R
open Wamp.xcodeproj

# Open .app
open ~/Library/Developer/Xcode/DerivedData/Wamp-*/Build/Products/Debug/Wamp.app
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Space` | Play / Pause |
| `Return` | Play selected track |
| `↑` `↓` | Navigate playlist |
| `Cmd+Click` | Add/remove track from selection |
| `Shift+Click` | Extend selection to clicked track |
| `⌘Q` | Quit |
| Media Keys | Play / Pause / Next / Previous |

## Supported Formats

MP3 | AAC | M4A | FLAC | WAV | AIFF

---

<div align="center">

Made with nostalgia and Swift on macOS.

*Forked from [wishval/wamp](https://github.com/wishval/wamp). Inspired by Winamp 2.x. This is an independent project and is not affiliated with or endorsed by the original Winamp authors.*

</div>
