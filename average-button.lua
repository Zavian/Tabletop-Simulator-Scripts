local expanded = false
local _Black = Color.Black

function buttonPress()
    if lockout == false then
        --Call on any other function here. For example:
        --Global.call("Function Name", {table of parameters if needed})
        --You could also add your own scrting here. For example:
        --print("The button was pressed. Hoozah.")
        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        lockout = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout

        local notes = self.getGMNotes()
        local vars = JSON.decode(notes)
        -- send to open all things from seated players
        -- and send it back to a notepad
        if not notes then
            printError()
            return
        end
        local notecard = getObjectFromGUID(vars["note"])
        if not notecard then
            printError()
            return
        else
            notecard.setDescription("")
        end
        if not expanded then
            Global.call("showHuds", {notecard = vars["note"], players = createSeatedTable()})
            notecard.call("reset")
        else
            Global.call("showHuds", {notecard = vars["note"], players = createSelectedTable()})
            notecard.call("reset", {colors = createSelectedTable()})
        end
    end
end

function printError()
    printToColor("Error in the average, gotta setup the note in the GM Note", "Black", Color.White)
end

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

    local colors = getAllColors()

    local x = 1.9
    local z = -1.4
    for i = 1, #colors do
        x = x + 1.5
        if i == 5 or i == 9 then
            z = z + 1.6
            x = 3.4
        end
        local button = {
            label = colors[i],
            click_function = "Button_" .. colors[i],
            function_owner = self,
            position = {x, 0.2, z},
            font_size = 215,
            color = _Black,
            font_color = Color.White,
            width = 700,
            height = 700,
            scale = {0, 0, 0}
        }
        self.createButton(button)
    end
    self.createButton(
        {
            -- button for expanding extra buttons
            click_function = "toggleExtra",
            function_owner = self,
            label = "▶",
            position = {2.1, 0.2, 0},
            scale = {0.5, 0.5, 0.5},
            width = 950,
            height = 950,
            font_size = 900,
            color = _Black,
            font_color = Color.White
        }
    )
    lockout = false
end

function createSeatedTable()
    local returner = {}
    local colors = getAllColors()
    for i = 1, #colors do
        local seat = Seated(colors[i])
        if seat then
            table.insert(returner, seat)
        end
    end
    return returner
end

function createSelectedTable()
    returner = {}
    local buttons = self.getButtons()
    for i = 1, #getAllColors() do
        if buttons[i].font_color == Color.Red then
            log("Found color " .. buttons[i].label)
            table.insert(returner, buttons[i].label)
        end
    end
    return returner
end

function toggleExtra()
    local buttons = #self.getButtons()
    local button = self.getButtons()[buttons]
    if button.label == "▶" then
        self.editButton({index = buttons - 1, label = "◀"})
        enlargeExtras(true)
    else
        self.editButton({index = buttons - 1, label = "▶"})
        enlargeExtras(false)
    end
end

function enlargeExtras(doIt)
    local scale = doIt and {1, 1, 1} or {0, 0, 0}
    local colors = getAllColors()
    for i = 1, #colors do
        self.editButton({index = i, scale = scale})
        if not Seated(colors[i]) then
            self.editButton({index = i, font_color = _Black})
        else
            self.editButton({index = i, font_color = Color.White})
        end
    end
    expanded = doIt
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

function Seated(color)
    if Player[color].seated then
        return color
    else
        return nil
    end
end

function getColorIndex(color)
    local colors = getAllColors()
    for i = 1, #colors do
        if color == colors[i] then
            return i
        end
    end
    return -1
end

function toggleButton(color)
    local buttons = self.getButtons()
    for i = 1, #buttons do
        local label = buttons[i].label
        if label == color then
            local fc = buttons[i].font_color
            if fc.b ~= _Black.b then
                if fc ~= Color.White then
                    self.editButton({index = i - 1, font_color = Color.White})
                else
                    self.editButton({index = i - 1, font_color = Color.Red})
                end
            end
        end
    end
end

function Button_White()
    toggleButton("White")
end

function Button_Teal()
    toggleButton("Teal")
end

function Button_Brown()
    toggleButton("Brown")
end

function Button_Blue()
    toggleButton("Blue")
end

function Button_Red()
    toggleButton("Red")
end

function Button_Purple()
    toggleButton("Purple")
end

function Button_Orange()
    toggleButton("Orange")
end

function Button_Pink()
    toggleButton("Pink")
end

function Button_Yellow()
    toggleButton("Yellow")
end

function Button_Green()
    toggleButton("Green")
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
