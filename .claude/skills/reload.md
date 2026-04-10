---
description: Kill the running Wamp app and relaunch from the latest Debug build
---

Reload the Wamp app without rebuilding (uses the last successful build).

Steps:
1. Kill if running: `pkill -x Wamp; sleep 0.5`
2. Find the built app: `APP=$(find ~/Library/Developer/Xcode/DerivedData -name "Wamp.app" -path "*/Debug/*" 2>/dev/null | head -1)`
3. If found: `open "$APP"` and confirm the app launched
4. If not found: tell the user no build exists yet and suggest running /build-reload
