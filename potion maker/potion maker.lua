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

        local text = self.UI.getAttribute("text", "value")
        local desc = self.getDescription()

        local data = JSON.decode(text)

        local obj = getObjectFromGUID(desc)

        obj.setName(data.title .. data.description)
        obj.setDescription(data.lore)
        obj.highlightOn(Color.Green, 1)

        obj.setColorTint(hexToRgb(data.color))

        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        lockout = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout
    end
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
        r = "White"
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
    lockout = false

    self.UI.setAttribute("text", "onValueChanged", self.getGUID() .. "/UIUpdateValue(value)")
end

function onCollisionEnter(info)
    local guid = info.collision_object.guid
    if info.collision_object.interactable then
        self.setDescription(guid)
        info.collision_object.guid.highlightOn(Color.Yellow, 1)
    else
        self.setDescription("")
    end
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
