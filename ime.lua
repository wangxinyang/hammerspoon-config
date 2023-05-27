local function Chinese()
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.inputmethod.Kotoeri.RomajiTyping.Roman")
end

local function Japnese()
    hs.keycodes.currentSourceID("com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese")
end

-- app to expected ime config
local app2Ime = {
    {'/Applications/iTerm.app', 'English'},
    {'/Applications/Hyper.app', 'English'},
    {'/Applications/Visual Paradigm.app', 'English'},
    {'/Applications/Visual Studio Code.app', 'English'},
    {'/Applications/Goland.app', 'English'},
    {'/Applications/IntelliJ IDEA.app', 'English'},
    {'/Applications/Notion.app', 'Chinese'},
    {'/Applications/Microsoft Excel.app', 'Japnese'},
    {'/Applications/Navicat Premium.app', 'English'},
    {'/Applications/Dash.app', 'English'},
    {'/Applications/Docker.app', 'English'},
    {'/Applications/Google Chrome.app', 'Chinese'},
    {'/System/Library/CoreServices/Finder.app', 'English'},
    {'/Applications/印象笔记.app', 'Chinese'},
    {'/Applications/QQ.app', 'Chinese'},
    {'/Applications/Chatwork.app', 'Japnese'},
    {'/Applications/WeChat.app', 'Chinese'},
    {'/Applications/System Preferences.app', 'English'},
    {'/Applications/Sublime Text.app', 'English'},
    {'/Applications/SQLPro Studio.app', 'English'},
    {'/Applications/wpsoffice.app', 'Japnese'},
    {'/Applications/wechatwebdevtools.app', 'English'},
    {'/Applications/FileZilla.app', 'English'},
    {'/Applications/Axure RP 9.app', 'English'},
    {'/Applications/PyCharm CE.app', 'English'},
    {'/Applications/iThoughtsX.app', 'English'},
    {'/Applications/LINE.app', 'Japnese'},
    {'/Applications/Slack.app', 'Japnese'},
    {'/Applications/Sublime Text.app', 'Japnese'},
    {'/Applications/Altair GraphQL Client.app', 'English'},
    {'/Applications/Postman.app', 'English'},
    {'/Applications/Termius.app', 'English'},
    {'/Applications/Transmit.app', 'English'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'English' then
                English()
            elseif expectedIme == 'Chinese' then
                Chinese()
            else
                Japnese()
            end
            break
        end
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- 输入法切换提示
hs.keycodes.inputSourceChanged(function()
    -- 用于保存当前输入法
    local currentSourceID = hs.keycodes.currentSourceID()

    -- 如果当前输入法和上一个输入法相同，则直接返回
    if currentSourceID == lastSourceID then
        return
    end

    if (currentSourceID == "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman") then
        hs.alert.show("ABC", hs.alert.defaultStyle, hs.screen.mainScreen(), 2)
    elseif (currentSourceID == "im.rime.inputmethod.Squirrel.Hans") then
        hs.alert.show("拼音", hs.alert.defaultStyle, hs.screen.mainScreen(), 2)
    elseif (currentSourceID == "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese") then
        hs.alert.show("日语", hs.alert.defaultStyle, hs.screen.mainScreen(), 2)
    end

     -- 保存最后一个输入法源名称
    lastSourceID = currentSourceID
end)
