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
            local str = lines[i]
            local firstChar = string.sub(lines[i], 1, 1)
            if firstChar == "h" then
                -- there's no color detailed
                local sp = mysplit(str, " ")
                take_card(sp[1] .. "|" .. sp[2])

                --if not readingBack then
                --    card = str
                --    readingBack = true
                --else 
                --    card = card .. "|" .. str
                --    readingBack = false
                --    take_card(card)
                --end
            elseif firstChar == "-" then
                --color
                local sp = mysplit(str, " ")
                take_card(sp[2] .. "|" .. sp[3] .. "|" .. sp[1], true)
            end
            --if string.sub(lines[i], 1, 1) == "-" then
            --    card[1] = "" -- beginning of a new card
            --    card[2] = ""
            --end
            --if not readingBack then
            --    if string.sub(lines[i], 1, 1) == "h" then
            --        card[1] = lines[i]
            --        readingBack = true
            --    end
            --else
            --    if string.sub(lines[i], 1, 1) == "h" then
            --        card[2] = lines[i]
            --        readingBack = false
            --        take_card(card)
            --    end
            --end
        end

        local waiter = function()
            if #objs == 0 then return false end
            for i=1,#objs do
                local res = objs[i].o.resting
                if res == false then return false end
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

function take_card(c, hasColor)
    local returner = {}

    local splitted = mysplit(c,"|")
    
    if hasColor then 
        local colo = splitted[3]:gsub("-", "")
        returner.color = colorTranslate(colo)         
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

function setCards()
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

        if makeSmall() then objs[i].o.setScale({1.76, 1.00, 1.76}) end


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
    else r = "White" end

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
        {click_function = "changeSmall", function_owner = self, label = " ", position = {-1.5, 0.45, 1.5}, width = 400, height = 400, color = {0.856, 0.1, 0.094, 1}, tooltip = "big"}
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

function printTable(t)
    local printTable_cache = {}

    local function sub_printTable(t, indent)
        if (printTable_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            printTable_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_printTable(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_printTable(t, "  ")
        print("}")
    else
        sub_printTable(t, "  ")
    end
end