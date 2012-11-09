#!/usr/bin/osascript
-- Guru Inamdar Copyright 2012.
-- The script provided as-is, use at your own risk

tell application "Xcode"
tell active workspace document
tell application "Xcode"
activate
tell application "System Events" to keystroke "0" using {command down, option down}
end tell
end tell
end tell
