---
description: Build the Wamp project then reload (kill + relaunch) if build succeeds
---

Build the Wamp app and relaunch it if the build succeeds. This is the primary development cycle command.

Steps:
1. Build:
   ```bash
   xcodebuild -project Wamp.xcodeproj -scheme Wamp -configuration Debug build 2>&1 | grep -E "error:|warning:|BUILD (SUCCEEDED|FAILED)" | tail -50
   ```
2. Check result:
   - **BUILD SUCCEEDED** → proceed to step 3
   - **BUILD FAILED** → show each compiler error (file, line, message) and STOP — do not relaunch
3. Kill and relaunch:
   ```bash
   pkill -x Wamp; sleep 0.5
   APP=$(find ~/Library/Developer/Xcode/DerivedData -name "Wamp.app" -path "*/Debug/*" 2>/dev/null | head -1)
   open "$APP"
   ```
4. Confirm the app launched successfully
