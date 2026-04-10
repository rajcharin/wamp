# Wamp — Feature Roadmap

Tracked feature backlog for [rajcharin/wamp](https://github.com/rajcharin/wamp), forked from [wishval/wamp](https://github.com/wishval/wamp).

---

## UI / UX

- [x] UI theme selector — choose from built-in themes (Classic, Dark Steel, Amber, Midnight, Soft Green)
- [x] File info panel — show codec, bitrate, sample rate, channels, file size, play count, last played (INFO button)
- [ ] Mini player / menu bar mode — compact floating player or menu-bar-only playback control
- [ ] Lyrics display — read embedded USLT/SYLT tags; show plain or synchronized lyrics
- [ ] Rating system — 1–5 stars per track, stored in app state; feeds into smart playlists
- [ ] Keyboard shortcut customization — remap keys to user preference

---

## Library & Organisation

- [ ] Watched folder — auto-detect new audio files dropped into a configured folder via FSEvents
- [ ] Multiple named playlists — sidebar or tab switching between saved playlists
- [ ] Artist / Album browser panel — hierarchical grouping: artist → album → tracks
- [x] Play count + last played tracking — persisted in playlist.json per track
- [ ] Smart playlists — auto-generated lists filtered by genre, year range, play count, or rating
- [x] Missing file detection — highlight tracks in red whose files no longer exist on disk
- [ ] Duplicate detection — find tracks with the same title+artist or identical file hash

---

## Playback

- [ ] Gapless playback — schedule audio buffers back-to-back in AVAudioEngine (no silence between tracks)
- [ ] Crossfade — configurable fade-out/fade-in duration between tracks
- [ ] ReplayGain — read R128 / RG tags and normalize volume per track to prevent level jumps
- [x] Queue / Up Next — temporary play queue; right-click "Add to Queue", position badge in playlist
- [x] Sleep timer — ZZZ button in title bar; countdown stops playback; 15/30/45/60 min options
- [ ] A-B loop — mark a start and end point in a track and loop that segment continuously
- [x] Playback speed — 0.5×–2× speed slider in player; persists across launches

---

## Metadata & Tagging

- [ ] Tag editor — edit title, artist, album, genre, year directly inside the app
- [ ] Bulk tag editor — apply shared field values (e.g. album name, genre) to a multi-selection
- [x] File info panel — show full technical details: codec, bitrate, sample rate, channels, file size
- [x] M3U / PLS import and export — import/export via ADD menu; standard format support
- [ ] Duplicate detection — find tracks with identical audio fingerprints or metadata

---

## Audio

- [x] Output device selector — OUT button in title bar; lists all CoreAudio outputs with checkmark
- [ ] Stereo / mono toggle — collapse stereo channels for single-speaker or accessibility use

---

## Developer / Workflow

- [x] Gitflow branching model — `main` / `develop` / `feature/*` / `release/*` / `hotfix/*`
- [x] Claude Code skills — `/build`, `/reload`, `/build-reload` slash commands
- [x] Claude Code hooks — Swift edit reminder, macOS notification, git status on stop
- [x] MCP servers — GitHub and filesystem MCP configured in `.mcp.json`
