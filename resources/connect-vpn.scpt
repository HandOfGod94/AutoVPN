tell application "System Events"
  click menu bar item 1 of menu bar 1 of application process "SystemUIServer"
  click menu item "%s" of menu 1 of menu bar item 1 of menu bar 1 of application process "SystemUIServer"
  delay 3
  set value of text field 1 of window 1 of application process "UserNotificationCenter" to "%s"
  click UI Element "OK" of window 1 of application process "UserNotificationCenter"
end tell
