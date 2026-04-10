---
description: Build the Wamp Xcode project in Debug configuration and report errors
---

Build the Wamp macOS app using xcodebuild.

Steps:
1. Run: `xcodebuild -project Wamp.xcodeproj -scheme Wamp -configuration Debug build 2>&1 | tail -30`
2. Parse the output:
   - If `BUILD SUCCEEDED` → confirm success with the number of warnings (if any)
   - If `BUILD FAILED` → extract each error: file path, line number, and error message; propose a fix for each
3. Do NOT relaunch the app — use /reload or /build-reload for that
