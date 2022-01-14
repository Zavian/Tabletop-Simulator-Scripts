local bag = self.getDescription()

local objs = {}

local processing = false
local index = 1

function mysplit(inputstr, sep)
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

--Runs when the scripted button inside the button is clicked
function buttonPress()
    if lockout == false then
        --Call on any other function here. For example:
        --Global.call("Function Name", {table of parameters if needed})
        --You could also add your own scrting here. For example:
        --print("The button was pressed. Hoozah.")

        text = self.UI.getAttribute("text", "value")
        local lines = mysplit(text, "\n")

        local readingBack = false
        local card = ""

        for i = 1, #lines do
            local line = lines[i]
            local isSmall = #mysplit(line, "|") > 1

            local card = line
            if isSmall then
                card = mysplit(line, "|")[1]
            end

            local elements = mysplit(card, " ")
            local result = ""
            if #elements == 1 then -- in the case that i only put the link
                result = elements[1] .. "|" .. elements[1]
                take_card(result)
            elseif #elements == 2 then -- in the case that i two links
                result = elements[1] .. "|" .. elements[2]
                take_card(result)
            elseif #elements == 3 then -- in the case that i have also the color
                local isHex = elements[1]:sub(1, 1) == "#"
                result = elements[2] .. "|" .. elements[3]
                take_card(result, true, isHex)
            end
        end

        local waiter = function()
            if #objs == 0 then
                return false
            end
            for i = 1, #objs do
                local res = objs[i].o.resting
                if res == false then
                    return false
                end
            end
            return true
        end

        local waited = function()
            setCards()
        end

        Wait.condition(waited, waiter)

        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        lockout = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout
    end
end

function take_card(c, hasColor, isHex)
    local returner = {}

    local splitted = mysplit(c, "|")

    if hasColor then
        if not isHex then
            local colo = splitted[3]:gsub("-", "")
            returner.color = colorTranslate(colo)
        else
            local colo = hexToRgb(splitted[3])
            returner.color = colo
        end
    else
        returner.color {r = 0, g = 0, b = 0}
    end

    returner.card = {splitted[1], splitted[2]}
    takeParams = {
        position = {119.49, 2.80, 13.54},
        rotation = {0, 0, 0},
        callback_function = function(obj)
            returner.o = obj
            table.insert(objs, returner)
        end
    }
    --printTable(objs)

    getObjectFromGUID(bag).takeObject(takeParams)
end

function setCards(small)
    for i = 1, #objs do
        objs[i].o.setCustomObject(
            {
                image = objs[i].card[1],
                image_secondary = objs[i].card[2]
            }
        )
        if objs[i].color ~= nil then
            objs[i].o.setColorTint(objs[i].color)
        end

        if small ~= nil then
            if small then
                objs[i].o.setScale({1.76, 1.00, 1.76})
            end
        elseif makeSmall() then
            objs[i].o.setScale({1.76, 1.00, 1.76})
        end

        objs[i].o.reload()
    end

    objs = {}
end

function colorTranslate(color)
    --[[
        arr["Green"] = "u";
        arr["Navy"] = "r";
        arr["BlueViolet"] = "e";
        arr["#c46709"] = "l";
    --]]
    local r = ""
    if color == "u" then
        r = "Green"
    elseif color == "r" then
        r = "Blue"
    elseif color == "e" then
        r = "Purple"
    elseif color == "l" then
        r = {r = 0.768627, g = 0.403922, b = 0.035294}
    else
        r = {r = 0, g = 0, b = 0}
    end

    return r
end

--Runs on load, creates button and makes sure the lockout is off
function onload()
    self.createButton(
        {
            label = "Big Red Button\n\nBy: MrStump",
            click_function = "buttonPress",
            function_owner = self,
            position = {0, 0.25, 0},
            height = 1400,
            width = 1400
        }
    )
    self.createButton(
        {
            click_function = "changeSmall",
            function_owner = self,
            label = " ",
            position = {-1.5, 0.45, 1.5},
            width = 400,
            height = 400,
            color = {0.856, 0.1, 0.094, 1},
            tooltip = "big"
        }
    )
    lockout = false

    local desc = self.getDescription()
    if desc ~= "" then
        bag = desc
    end
    self.UI.setAttribute("text", "onValueChanged", self.getGUID() .. "/UIUpdateValue(value)")
end

function changeSmall()
    local btn = self.getButtons()[2]
    local isBig = btn.tooltip == "big"
    local color = {
        red = {0.856, 0.1, 0.094, 1},
        green = {0.4418, 0.8101, 0.4248, 1}
    }
    if isBig then
        self.editButton({index = 1, color = color.green})
        self.editButton({index = 1, tooltip = "small"})
    else
        self.editButton({index = 1, color = color.red})
        self.editButton({index = 1, tooltip = "big"})
    end
end

function makeSmall()
    local btn = self.getButtons()[2]
    return btn.tooltip == "small"
end

function UIUpdateValue(player, text, id)
    self.UI.setAttribute("text", "value", text)
end

--Starts a timer that, when it ends, will unlock the button
function startLockoutTimer()
    Timer.create({identifier = self.getGUID(), function_name = "unlockLockout", delay = 0.5})
end

--Unlocks button
function unlockLockout()
    lockout = false
end

--Ends the timer if the object is destroyed before the timer ends, to prevent an error
function onDestroy()
    Timer.destroy(self.getGUID())
end

function hexToRgb(hex)
    hex = hex:gsub("#", "")
    if #hex < 8 then
        hex = hex .. "ff"
    end
    return color(
        tonumber("0x" .. hex:sub(1, 2), 16) / 255,
        tonumber("0x" .. hex:sub(3, 4), 16) / 255,
        tonumber("0x" .. hex:sub(5, 6), 16) / 255,
        tonumber("0x" .. hex:sub(7, 8), 16) / 255
    )
end
