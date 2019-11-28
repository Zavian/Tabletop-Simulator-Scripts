local bag = self.getDescription()
local text

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
        local card = {}

        --for i = 1, #lines do
            if string.sub(lines[], 1, 1) == "-" then
                card[1] = "" -- beginning of a new card
                card[2] = ""
            end
            if not readingBack then
                if string.sub(lines[], 1, 1) == "h" then
                    card[1] = lines[]
                    readingBack = true
                end
            else
                if string.sub(lines[], 1, 1) == "h" then
                    card[2] = lines[]
                    readingBack = false
                    take_card(card)
                end
            end
        --end

        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        lockout = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout
    end
end

function take_card(c)
    takeParams = {
        position = {86.23, 3, 37.03},
        rotation = {0, 0, 0},
        callback_function = function(obj)
            local o = getObjectFromGUID(obj.getGUID())
            o.setCustomObject(
                {
                    image = c[1],
                    image_secondary = c[2]
                }
            )
            Wait.condition(
                function()
                    o.reload()
                end,
                function()
                    return o.resting
                end
            )
        end
    }
    getObjectFromGUID(bag).takeObject(takeParams)
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
    lockout = false

    local desc = self.getDescription()
    if desc ~= "" then
        bag = desc
    end
    self.UI.setAttribute("text", "onValueChanged", self.getGUID() .. "/UIUpdateValue(value)")
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
