-- 天气组件
local cityId = '130010'
local currentWeatherUrl = 'https://weather.tsukumijima.net/api/forecast/city/%s'
local weatherPageUrl = 'https://www.data.jma.go.jp/tokyo/'

local weaEmoji = {
    lei = '⚡️',
    qing = '☀️',
    shachen = '😷',
    wu = '🌫',
    xue = '❄️',
    yu = '🌧',
    yujiaxue = '🌨',
    yun = '⛅️',
    zhenyu = '🌧',
    yin = '☁️',
    qingyun = '☀️⛅️',
    yunyu = '⛅️🌧',
    default = '⌛'
}

-- 获取天气对应的 emoji
local function getWeaEmoji(weatherInfoCN)
    local weatherInfoPY = "default"
    if weatherInfoCN == "晴のち曇" then
        weatherInfoPY = 'qingyun'
    elseif weatherInfoCN == "曇時々雨" then
        weatherInfoPY = 'yunyu'
    elseif weatherInfoCN == "曇一時雨" then
        weatherInfoPY = 'yunyu'
    elseif weatherInfoCN == "晴時々曇" then
        weatherInfoPY = 'qing'
    elseif weatherInfoCN == "晴" then
        weatherInfoPY = 'qing'
    elseif weatherInfoCN == "沙尘" then
        weatherInfoPY = 'shachen'
    elseif weatherInfoCN == "雾" then
        weatherInfoPY = 'wu'
    elseif weatherInfoCN == "雨夹雪" then
        weatherInfoPY = 'yujiaxue'
    elseif weatherInfoCN == "多云" then
        weatherInfoPY = 'yun'
    elseif weatherInfoCN == "阵雨" then
        weatherInfoPY = 'zhenyu'
    elseif weatherInfoCN == "阴" then
        weatherInfoPY = 'yin'
    elseif string.find(weatherInfoCN, "雨") ~= nil then
        weatherInfoPY = 'yu'
    end
    return weaEmoji[weatherInfoPY]
end

WeatherMenubar = hs.menubar.new()
local menuData = {}

-- 获取天气信息
function GetWeather()
    print("更新天气")

    hs.http.doAsyncRequest(string.format(currentWeatherUrl, cityId), "GET", nil, nil, function(code, body, htable)
        if code ~= 200 then
            print('get weather error:'..code)
            return
        end
        local rawJson = hs.json.decode(body)
        local city = rawJson.location.prefecture
        local publish_time = rawJson.publicTime
        local weather = rawJson.forecasts
        local wind_all = weather[1].detail.wind

        print(wind_all)
        local wind_first_index = string.find(wind_all, "　")
        print(wind_first_index)
        local wind = string.sub(wind_all, 0, wind_first_index + 1)
        print(wind)
        menuData = {}

				if weather[1].temperature.max.celsius ~= nil then
		        WeatherMenubar:setTitle(getWeaEmoji(weather[1].telop)..(weather[1].temperature.max.celsius).." "..weather[1].telop)
			  else 
		        WeatherMenubar:setTitle(getWeaEmoji(weather[1].telop))
				end


        local dateTable = FormatTimeToDateTable(publish_time, "%Y-%m-%d %H:%M")

        local tipStr = string.format("更新于 %s-%s %s:%s", dateTable.month, dateTable.day, dateTable.hour, dateTable.minute)
        WeatherMenubar:setTooltip(tipStr)
        local titleStr = string.format("%s %s %s日（今天） 🌡️%s℃ 💧00時-06時:%s 💧06時-12時:%s 💧12時-18時:%s 💧18時-24時:%s %s", city, getWeaEmoji(weather[1].telop), dateTable.day, weather[1].temperature.max.celsius, weather[1].chanceOfRain.T00_06, weather[1].chanceOfRain.T06_12, weather[1].chanceOfRain.T12_18, weather[1].chanceOfRain.T18_24, weather[1].detail.weather)

        local firstLine = {
            title = titleStr,
            fn = function()
                hs.urlevent.openURL(weatherPageUrl)
            end
        }
        table.insert(menuData, firstLine)
        table.insert(menuData, {title = '-'})

        for k, v in ipairs(weather) do
            print(v)
            if k == 1 then
                -- donot do anything
            else
                titleStr = string.format("%s %s %s日  🌡️%s℃ 💧00時-06時:%s 💧06時-12時:%s 💧12時-18時:%s 💧18時-24時:%s %s", city, getWeaEmoji(weather[k].telop), weather[k].date, weather[k].temperature.max.celsius, weather[k].chanceOfRain.T00_06, weather[k].chanceOfRain.T06_12, weather[k].chanceOfRain.T12_18, weather[k].chanceOfRain.T18_24, weather[k].detail.weather)
                -- titleStr = string.format("%s %s 🌡️%s 🌬%s %s", weaEmoji[v.wea_img],v.day, v.tem, v.win_speed, v.wea)
                local item = { title = titleStr }
                table.insert(menuData, item)
            end
        end
        WeatherMenubar:setMenu(menuData)
    end)
end

-- 注册天气组件
function RegisterWeatherComponent()
    WeatherMenubar:setTitle('⌛')
    WeatherMenubar:setTooltip("Weather Info")

    GetWeather()

    local weatherTimer = hs.timer.new(600, GetWeather)
    return weatherTimer
end
