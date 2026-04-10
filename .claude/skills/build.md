---
description: Build the Wamp Xcode project in Debug configuration and report errors
---

Build the Wamp macOS app using xcodebuild.

Steps:
1. Run: `xcodebuild -project Wamp.xcodeproj -scheme Wamp -configuration Debug build 2>&1 | grep -E "error:|warning:|BUILD (SUCCEEDED|FAILED)" | tail -50`
2. Parse the output:
   - If `BUILD SUCCEEDED` → confirm success, list any warnings
   - If `BUILD FAILED` → extract each error (file path, line number, message) and propose a fix
3. Do NOT relaunch the app — use /reload or /build-reload for that
