#!/usr/bin/env python3
# PostToolUse hook — prints a build reminder when a Swift file is edited.
# Claude Code pipes the tool JSON to stdin; stdout is injected into the conversation.
import sys
import json
import os

try:
    data = json.load(sys.stdin)
    path = data.get("tool_input", {}).get("file_path", "")
    if path.endswith(".swift"):
        name = os.path.basename(path)
        print(f"[wamp] {name} modified — run /build-reload to rebuild and relaunch")
except Exception:
    pass
