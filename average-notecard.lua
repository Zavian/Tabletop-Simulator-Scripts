local _buttons = {}
local _startIndex = 0

local _setup = false

local _critColor = {r = 0.0667, g = 0.3019, b = 0.0667, a = 1}
local _failColor = {r = 0.3019, g = 0.0667, b = 0.0667, a = 1}

function onLoad()
    self.createButton(
        {
            click_function = "setup",
            function_owner = self,
            label = "Setup",
            position = {0, 2.6, 0.42},
            rotation = {180, 0, 180},
            scale = {0.15, 0.2, 0.2},
            width = 1010,
            height = 330,
            font_size = 200,
            color = Color.Black,
            font_color = Color.White
        }
    )
    self.createButton(
        {
            click_function = "average",
            function_owner = self,
            label = "AVG",
            position = {0, 2.6, -0.58},
            rotation = {180, 0, 180},
            scale = {0.15, 0.2, 0.2},
            width = 1010,
            height = 330,
            font_size = 200,
            color = Color.Red,
            font_color = Color.White
        }
    )
    _startIndex = 2

    --Wait.Time(
    --    function()
    --        setup()
    --        randomizeDebug()
    --    end,
    --    2
    --)
end

function randomizeDebug()
    local colors = getAllColors()
    for i = 1, #colors do
        Wait.Time(
            function()
                local avg = math.random(1, 22)
                local crit = nil
                if avg == 1 then
                    crit = 1
                elseif avg >= 20 then
                    crit = 20
                end
                setData({avg = avg, color = colors[i], crit = crit})
            end,
            0.5
        )
    end
end

function setData(params)
    if not _setup then
        setup()
    end
    local buttonIndex = findButtonByColor(params.color) - 1
    self.editButton({index = buttonIndex, label = params.avg})
    if params.crit ~= nil then
        local desc = self.getDescription()
        if params.crit == 20 then
            self.editButton({index = buttonIndex, color = _critColor})
            self.setDescription(desc == "" and params.avg or desc .. " " .. params.avg)
        else
            self.editButton({index = buttonIndex, color = _failColor})
            self.setDescription(desc == "" and "1" or desc .. " 1")
        end
    else
        self.editButton({index = buttonIndex, color = Color.Black})
    end
end

function findButtonByColor(color)
    local buttons = self.getButtons()
    for i = 1, #buttons do
        local button = buttons[i]
        if button.tooltip == color then
            return i
        end
    end
end

function reset(params)
    setup()
    if params then
        Wait.Time(
            function()
                local buttons = self.getButtons()
                for i = 1, #buttons do
                    if notInList(params.colors, buttons[i].tooltip) and i - 1 >= _startIndex then
                        self.editButton({index = i - 1, font_color = Color.Black})
                    end
                end
            end,
            0.5
        )
    end
end

function notInList(list, color)
    for i = 1, #list do
        if list[i] == color then
            return false
        end
    end
    return true
end

function setup()
    if #_buttons > 0 then
        resetButtons()
    end

    local colors = getAllColors()

    local x = 0.39
    local z = -0.36
    for i = 1, #colors do
        if Seated(colors[i]) then
            local button = {
                label = colors[i],
                click_function = "none",
                function_owner = self,
                position = {x, 2.6, z},
                font_size = 215,
                color = Color.Black,
                font_color = Color[colors[i]],
                tooltip = colors[i],
                width = 700,
                height = 700,
                scale = {0.13, 0.15, 0.15},
                rotation = {180, 0, 180}
            }
            self.createButton(button)
            table.insert(_buttons, button)
            x = x - 0.19
            if i == 5 or i == 10 then
                z = z + 0.23
                x = 0.39
            end
        end
    end
    _setup = true
end

function resetButtons()
    for i = 1, #self.getButtons() do
        if i - 1 >= _startIndex then
            self.removeButton(i - 1)
            _buttons = {}
            _setup = false
        end
    end
end

function none()
end

function average()
    local numbers = 0
    local tot = 0
    -- get all buttons
    local buttons = self.getButtons()
    for i = _startIndex + 1, #buttons do
        if buttons[i].font_color ~= Color.Black then
            log(buttons[i].tooltip .. " " .. buttons[i].label)
            tot = tot + tonumber(buttons[i].label)
            numbers = numbers + 1
        end
    end

    if self.getDescription() ~= "" then
        local extras = split(self.getDescription(), " ")
        for i = 1, #extras do
            tot = tot + tonumber(extras[i])
            numbers = numbers + 1
        end
    end
    self.setName("[00000000]" .. tot / numbers .. "[-]")
    self.editButton({index = 1, label = math.floor(tot / numbers)})
end

function Seated(color)
    if Player[color].seated then
        return color
    else
        return nil
    end
end

function getAllColors()
    return {
        "White",
        "Teal",
        "Brown",
        "Blue",
        "Red",
        "Purple",
        "Orange",
        "Pink",
        "Yellow",
        "Green"
    }
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
