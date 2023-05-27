hyper = {"cmd", "ctrl", "alt"}
hyperShift = {"alt", "shift"}
hyperCtrl = {"alt", "ctrl"}
hyperAlt = {"ctrl", "alt", "shift"}
hyperCmd = {"cmd"}
-- lock screen shortcut
hs.hotkey.bind({'cmd'}, 'L', function() hs.caffeinate.startScreensaver() end)
-- open app
hs.hotkey.bind(hyperShift, 'F', function () hs.application.launchOrFocus("Finder") end)
hs.hotkey.bind(hyperShift, 'V', function () hs.application.launchOrFocus("Visual Studio Code") end)
hs.hotkey.bind(hyperShift, 'T', function () hs.application.launchOrFocus("Hyper") end)
hs.hotkey.bind(hyperShift, 'G', function () hs.application.launchOrFocus("Google Chrome") end)
hs.hotkey.bind(hyperShift, 'N', function () hs.application.launchOrFocus("Notion") end)
hs.hotkey.bind(hyperShift, 'S', function () hs.application.launchOrFocus("Sublime Text") end)
hs.hotkey.bind(hyperShift, 'A', function () hs.application.launchOrFocus("Altair GraphQL Client") end)
hs.hotkey.bind(hyperShift, 'M', function () hs.application.launchOrFocus("Navicat Premium") end)
hs.hotkey.bind(hyperShift, 'E', function () hs.application.launchOrFocus("Microsoft Excel") end)
