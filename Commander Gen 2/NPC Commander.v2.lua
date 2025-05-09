_side = "enemy"
local _states = {
    ["player"] = {color = {0, 0, 0.545098}, state = 1},
    ["enemy"] = {color = {0.517647, 0, 0.098039}, bright = {0.94902, 0.184314, 0.32549}, state = 2},
    ["ally"] = {color = {0.039216, 0.368627, 0.211765}, bright = {0.352941, 0.823529, 0.603922}, state = 3},
    ["neutral"] = {color = {0.764706, 0.560784, 0}, bright = {0.933333, 0.741176, 0.219608}, state = 4}
}

local _extraParams = {
    epic = false,
    lair = false,
    epicBoons = nil,
    done = false
}

local names = {
    "Kyle",
    "Preston",
    "Pedro",
    "Jean",
    "Willis",
    "Eric",
    "Alan",
    "Jeremiah",
    "Troy",
    "Warner",
    "Guadalupe",
    "Emanuel",
    "Parker",
    "Willie",
    "Mauricio",
    "Tommie",
    "Buck",
    "Marlon",
    "Deshawn",
    "Fritz",
    "Sam",
    "Chung",
    "Chungus",
    "Jim",
    "Whitney",
    "Barton",
    "Alec",
    "Antione",
    "Micah",
    "Rhett",
    "Clint",
    "Raphael",
    "Sammy",
    "Dale",
    "Pat",
    "Lazarus",
    "Milton",
    "Vaughn",
    "Walton",
    "Lorenzo",
    "Robby",
    "Stanley",
    "Marvin",
    "Arnold",
    "Chester",
    "Wilmer",
    "Zane",
    "Cornelius",
    "Ivan",
    "Javier",
    "Jesse",
    "Rhea",
    "Karla",
    "Maybelle",
    "Salley",
    "Temple",
    "Ronna",
    "Lilli",
    "Stella",
    "Lorine",
    "Denna",
    "Bernice",
    "Lorina",
    "Rhona",
    "Kasie",
    "Earline",
    "Felisha",
    "Jeni",
    "Stormy",
    "Akiko",
    "Beverlee",
    "Chia",
    "Ethelene",
    "Lakisha",
    "Hsiu",
    "Dawna",
    "Demetra",
    "Junita",
    "June",
    "Lyndia",
    "Otelia",
    "Joanie",
    "Jenell",
    "Johana",
    "Corina",
    "Hannelore",
    "Deandra",
    "Florida",
    "Matilde",
    "Maragret",
    "Luana",
    "Neva",
    "Rachal",
    "Rona",
    "Shirl",
    "Maudie",
    "Rosalyn",
    "Rosaura",
    "Jesusita",
    "Adela",
    "Lashon",
    "Barry",
    "Cade",
    "Stu",
    "Pid",
    "Moe",
    "Lester",
    "Piss",
    "Stachio",
    "Ray",
    "Diation",
    "Stan",
    "Still",
    "Earl",
    "Lee Bird",
    "Ward",
    "Robe",
    "Doug",
    "Hole",
    "Ollie",
    "Garchy"
}

debug = false

function onload()
    debug = shouldIDebug()

    local inputs = {
        {
            -- name input							[0]
            input_function = "none",
            function_owner = self,
            label = " ",
            position = {-2.94, 0.4, -0.27},
            scale = {0.5, 0.5, 0.5},
            width = 2900,
            height = 424,
            font_size = 350,
            tooltip = "Name",
            value = debug and "/" or "",
            alignment = 2,
            tab = 2
        },
        {
            -- initiative input						[1]
            input_function = "none",
            function_owner = self,
            label = " ",
            position = {-4.18, 0.4, 0.55},
            scale = {0.5, 0.5, 0.5},
            width = 550,
            height = 385,
            font_size = 350,
            tooltip = "Initiative Modifier",
            value = debug and "5" or "",
            alignment = 3,
            validation = 2,
            tab = 2
        },
        {
            -- hp input								[2]
            input_function = "none",
            function_owner = self,
            label = " ",
            position = {-3, 0.4, 0.55},
            scale = {0.5, 0.5, 0.5},
            width = 1540,
            height = 385,
            font_size = 350,
            tooltip = "Hit Points\nIf you want random hp start with r followed by the lower value and the upper value.\n" ..
                "[i][AAAAAA]Example:[-] [0074D9]r[-][2ECC40]25[-]-[2ECC40]182[-][/i]",
            value = debug and "r25-182" or "",
            alignment = 3,
            tab = 2
        },
        {
            --ac input								[3]
            input_function = "none",
            function_owner = self,
            label = " ",
            position = {-1.76, 0.4, 0.55},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 385,
            font_size = 350,
            tooltip = " ",
            alignment = 3,
            validation = 2,
            tab = 2,
            value = debug and "15" or ""
        },
        {
            -- movement input						[4]
            input_function = "none",
            function_owner = self,
            label = " ",
            position = {-2.94, 0.4, 1.35},
            scale = {0.5, 0.5, 0.5},
            width = 2900,
            height = 424,
            font_size = 350,
            tooltip = " ",
            alignment = 3,
            tab = 2,
            value = debug and "30ft" or ""
        },
        {
            -- numberToCreate input					[5]
            input_function = "none",
            function_owner = self,
            label = "NMB",
            position = {0.03, 0.4, 0.73},
            scale = {0.5, 0.5, 0.5},
            width = 870,
            height = 495,
            font_size = 320,
            color = {0.4941, 0.4941, 0.4941, 1},
            tooltip = "Number to Create",
            alignment = 3,
            validation = 2,
            tab = 2
        },
        {
            -- jsonImport input                     [6]
            input_function = "none",
            function_owner = self,
            label = "JSON IMPORT",
            position = {2.48, 0.4, 1.12},
            scale = {0.5, 0.5, 0.5},
            color = {0.4941, 0.4941, 0.4941, 1},
            width = 2730,
            height = 425,
            font_size = 320,
            tooltip = "Import JSON stuff",
            alignment = 2
        },
        {
            -- boss token size bossSize              [7]
            input_function = "none",
            function_owner = self,
            label = "Boss Size",
            position = {3.48, 0.4, -1.08},
            scale = {0.5, 0.5, 0.5},
            width = 1830,
            height = 425,
            font_size = 300,
            color = {0.4941, 0.4941, 0.4941, 1},
            tooltip = "Boss Size",
            alignment = 3,
            value = "Boss token size",
            validation = 3
        }
    }
    local buttons = {
        {
            -- size button							[0]
            click_function = "switch_size",
            function_owner = self,
            label = "Medium",
            tooltip = "Size",
            position = {3.64, 0.4, 0.62},
            scale = {0.5, 0.5, 0.5},
            width = 1630,
            height = 425,
            font_size = 320,
            color = {0.1921, 0.4431, 0.1921, 1},
            alignment = 2
        },
        {
            -- note button							[1]
            click_function = "create_json_note",
            function_owner = self,
            label = "Make Note",
            position = {1.95, 0.4, -0.24},
            scale = {0.5, 0.5, 0.5},
            width = 1730,
            height = 425,
            font_size = 320,
            color = {0.1921, 0.4431, 0.1921, 1},
            font_color = {0.6353, 0.8902, 0.6353, 1},
            alignment = 2
        },
        {
            -- create button						[2]
            click_function = "create_npc",
            function_owner = self,
            label = "CREATE",
            position = {0.03, 0.4, 0.23},
            scale = {0.5, 0.5, 0.5},
            width = 1620,
            height = 495,
            font_size = 320,
            color = {0.2823, 0.4039, 0.7686, 1},
            font_color = {0.8, 0.8196, 0.8862, 1},
            alignment = 2
        },
        {
            -- isBoss button						[3]
            click_function = "boss_checkbox",
            function_owner = self,
            label = "",
            position = {3.19, 0.4, -0.24},
            scale = {0.5, 0.5, 0.5},
            width = 425,
            height = 425,
            font_size = 320,
            color = {0.6196, 0.2431, 0.2431, 1},
            font_color = {0.6353, 0.8902, 0.6353, 1},
            tooltip = "false",
            alignment = 2
        },
        {
            -- allegiance button					[4]
            click_function = "switch_sides",
            function_owner = self,
            label = "Enemy",
            position = {1.88, 0.4, 0.62},
            scale = {0.5, 0.5, 0.5},
            width = 1630,
            height = 425,
            font_size = 320,
            color = _states["enemy"].color,
            alignment = 2
        },
        {
            -- name question button                      [5]
            click_function = "none",
            function_owner = self,
            label = "?",
            tooltip = "The names of monsters can be variegated, remember of these escape characters:" ..
                "\n- [FF4136]/[-] is for [b][FF4136]r[-][FF851B]a[-][FFDC00]n[-][2ECC40]d[-][0074D9]o[-][B10DC9]m[-] names[/b]" ..
                    "\n- [FF4136]%[-] is for [b]numbered creatures[/b] (only works for a set of monsters)\n\n" ..
                        "[AAAAAA]You may put things in parenthesis [FF4136]()[-] and they will be removed and put in a black only visible label, useful for " ..
                            "reminders that you may need from time to time in combat![-]",
            position = {-3.42, 0.4, -0.63},
            scale = {0.5, 0.5, 0.5},
            width = 290,
            height = 290,
            font_size = 270,
            color = {0.8972, 0.8915, 0.3673, 1},
            alignment = 2
        },
        {
            -- boss question button                     [6]
            click_function = "none",
            function_owner = self,
            label = "?",
            tooltip = "A boss is defined by its image, if it has one then it needs to be a boss." ..
                "To have a creature with image simply put the link to the image (hosted wherever, I suggest imgur)" ..
                    "in the [b][FF4136]description of the commander[-][/b] and click the button button to the immediate left" ..
                        "of this tutorial: \n[2ECC40]green[-] = boss\n[FF4136]red[-] = not boss",
            position = {4.25, 0.400000005960464, -0.12},
            scale = {0.5, 0.5, 0.5},
            width = 290,
            height = 290,
            font_size = 270,
            color = {0.8972, 0.8915, 0.3673, 1},
            alignment = 2
        },
        {
            -- clear button                            [7]
            click_function = "clear",
            function_owner = self,
            label = "↺",
            position = {-4, 0.400000005960464, -1.13},
            scale = {0.5, 0.5, 0.5},
            width = 490,
            height = 490,
            font_size = 470,
            color = {0.2823, 0.4039, 0.7686, 1},
            tooltip = "Clear",
            alignment = 2
        },
        {
            -- randomize button                     [8]
            click_function = "randomize",
            function_owner = self,
            label = "↝",
            position = {-3.5, 0.400000005960464, -1.13},
            scale = {0.5, 0.5, 0.5},
            width = 490,
            height = 490,
            font_size = 470,
            color = {0.2823, 0.4039, 0.7686, 1},
            tooltip = "Randomize\nPlease don't use this as an encounter builder",
            alignment = 2
        },
        {
            click_function = "parseJson",
            function_owner = self,
            label = "P",
            tooltip = "Parse JSON",
            position = {4.13, 0.400000005960464, 1.12},
            scale = {0.5, 0.5, 0.5},
            width = 640,
            height = 460,
            font_size = 270,
            color = {0.3764, 0.3764, 0.3764, 1},
            alignment = 2
        }
    }

    for i = 1, #inputs do
        self.createInput(inputs[i])
    end
    for i = 1, #buttons do
        self.createButton(buttons[i])
    end
end

function none()
end

function clear()
    for i = 1, #self.getInputs() do
        self.editInput({index = i - 1, value = ""})
    end
end

function randomize()
    -- name input							[0]
    -- initiative input						[1]
    -- hp input								[2]
    -- ac input								[3]
    -- movement input						[4]
    -- numberToCreate input					[5]
    self.editInput({index = 0, value = "/"})
    self.editInput({index = 1, value = math.random(-2, 5)})
    self.editInput({index = 2, value = "r" .. math.random(1, 50) .. "-" .. math.random(51, 175)})
    self.editInput({index = 3, value = math.random(8, 17)})
    self.editInput({index = 4, value = math.random(1, 5) .. "0 ft"})
    self.editInput({index = 5, value = math.random(1, 9)})
end

function shouldIDebug()
    local notes = self.getGMNotes()
    local vars = JSON.decode(notes)

    return vars.debug
end

------------------------------------------------------
-- Get Baggies
------------------------------------------------------
function getBag(name)
    -- vars ------------
    -- token
    -- boss
    -- notes
    -- initiative
    --------------------
    local notes = self.getGMNotes()
    local vars = JSON.decode(notes)
    return vars[name]
end

function getNewPos(id)
    local obj = getObjectFromGUID(id)
    local notes = obj.getGMNotes()
    local pos = obj.getPosition()

    if notes ~= nil then
        local var = JSON.decode(notes)
        if var then
            -- new parsing system
            -- eventually will need to DEPRECATE the old system
            -- TODO: create translation system
            local varianceX = var.varx and var.varx or 0
            local varianceY = var.vary and var.vary or 0
            local varianceZ = var.varz and var.varz or 0

            if var.newPos then
                pos = var.newPos
                pos.x = var.newPos[1] + math.random(-varianceX, varianceX)
                pos.y = var.newPos[2] + math.random(-varianceY, varianceY) 
                pos.z = var.newPos[3] + math.random(-varianceZ, varianceZ)
                return pos
            end

            if var.diffx then
                pos.x = pos.x + var.diffx + math.random(-varianceX, varianceX)
            end
            if var.diffy then
                pos.y = pos.y + var.diffy + math.random(-varianceY, varianceY)
            end
            if var.diffz then
                pos.z = pos.z + var.diffz + math.random(-varianceZ, varianceZ)
            end
            return pos
        end
    end

    pos.x = pos.x + 3
    pos.y = pos.y + 3
    return pos
end

function getNewRot(id)
    local obj = getObjectFromGUID(id)
    local notes = obj.getGMNotes()
    local rot = {x = 0, y = 0, z = 0}

    if notes ~= nil then
        local var = JSON.decode(notes)
        if var then
            if var.rotx then
                rot.x = var.rotx
            end
            if var.roty then
                rot.y = var.roty
            end
            if var.rotz then
                rot.z = var.rotz
            end
            return rot
        end
    end
    return rot
end

function getDestination()
    -- calculates wether an item should go to the hand or not
    local notes = self.getGMNotes()
    local masterPos = self.getPosition()
    local masterBounds = self.getBounds()
    local variance = 3

    local pos = {
        x = masterPos.x + math.random(-variance, variance),
        y = masterPos.y + 3,
        z = masterPos.z - 3 - (masterBounds.size.z / 2)
    }
    if notes ~= nil then
        local var = JSON.decode(notes)
        if var then
            if var.hand ~= nil then
                pos = {x = var.hand.x, y = var.hand.y, z = var.hand.z}
            end
        end
    end
    return pos
end

------------------------------------------------------
-- Get/Set Input Functions
------------------------------------------------------

-- name ----------------------------------------------
function getName(number, literal)
    local inputs = self.getInputs()[1]
    local name = inputs.value
    if literal then
        return name
    end

    name = name:gsub("/", names[math.random(1, #names)])
    if number then
        name = name:gsub("%%", number)
    end

    --if string.sub(returner, 1, 1) == "/" then
    --    if #returner > 1 then
    --        returner = string.sub(returner, 2) .. names[math.random(1, #names)]
    --    else
    --        returner = names[math.random(1, #names)]
    --    end
    --else if number ~= nil then
    --
    --end
    return name
end

function setName(params)
    self.editInput({index = 0, value = params.input})
end

function findBlackName(name)
    if debug then
        log(name, "Finding black name")
    end

    local pattern = ".+%((.+)%)"
    local _,
        _,
        found = string.find(name, pattern)
    if found ~= nil then
        return {name = name:gsub("%(" .. found .. "%)", ""), black = found}
    end

    return nil
end
------------------------------------------------------

-- initiative ----------------------------------------
function getInitiative()
    local input = self.getInputs()[2].value
    return input
end
function setInitiative(params)
    self.editInput({index = 1, value = params.input})
end

-- deprecated method
function setINI(params)
    setInitiative(params)
end
------------------------------------------------------

-- hp ------------------------------------------------
function getHP(literal)
    local hp = self.getInputs()[3].value
    if literal then
        return hp
    end

    if string.sub(hp, 1, 1) == "r" then
        hp = string.gsub(hp, "r", "")
        local range = mysplit(hp, "-")
        hp = math.random(range[1], range[2])
    end

    return tonumber(hp)
end
function setHP(params)
    self.editInput({index = 2, value = params.input})
end
------------------------------------------------------

-- ac ------------------------------------------------
function getAC()
    local input = self.getInputs()[4].value
    return input
end
function setAC(params)
    self.editInput({index = 3, value = params.input})
end
------------------------------------------------------

-- movement ------------------------------------------
function getMovement()
    local input = self.getInputs()[5].value
    return input
end
function setMovement(params)
    self.editInput({index = 4, value = params.input})
end
------------------------------------------------------

-- size ----------------------------------------------
function getSize(getData)
    local buttons = self.getButtons()[1]
    if not getData then
        return buttons.label
    else
        if not getBossCheckbox() then
            local scale = {}
            scale["Small"] = 0.17
            scale["Medium"] = 0.30
            scale["Large"] = 0.55
            scale["Huge"] = 0.90
            scale["Gargantuan"] = 1.20
            return scale[buttons.label]
        else
            local scale = {}
            scale["Small"] = 0.53
            scale["Medium"] = 0.78
            scale["Large"] = 1.45
            scale["Huge"] = 2.40
            scale["Gargantuan"] = 3.30
            return scale[buttons.label]
        end
    end
end

function setSize(params)
    self.editButton({index = 0, label = params.input})
end
------------------------------------------------------

-- boss checkbox -------------------------------------
function boss_checkbox()
    local btn = self.getButtons()[4]
    local isBoss = btn.tooltip == "true"
    local color = {
        red = {0.6196, 0.2431, 0.2431, 1},
        green = {0.1921, 0.4431, 0.1921, 1}
    }
    if not isBoss then
        self.editButton({index = 3, color = color.green})
        self.editButton({index = 3, tooltip = "true"})
    else
        self.editButton({index = 3, color = color.red})
        self.editButton({index = 3, tooltip = "false"})
    end
end

function getBossCheckbox()
    local btn = self.getButtons()[4]
    return btn.tooltip == "true"
end

function toggleIsBoss(params)
    local btn = self.getButtons()[4]
    local color = {
        red = {0.6196, 0.2431, 0.2431, 1},
        green = {0.1921, 0.4431, 0.1921, 1}
    }

    if params.input then
        self.editButton({index = 3, color = color.green})
        self.editButton({index = 3, tooltip = "true"})
    else
        self.editButton({index = 3, color = color.red})
        self.editButton({index = 3, tooltip = "false"})
    end
end

-- numberToCreate -------------------------------------
function setNumberToCreate(params)
    self.editInput({index = 5, value = params.input})
end

function getNumberToCreate()
    local input = self.getInputs()[6]
    if input.value == "" then
        return 1
    else
        return tonumber(input.value)
    end
end
------------------------------------------------------

-- jsonImport ----------------------------------------
function getJsonImport()
    local input = self.getInputs()[7]
    return input.value
end
------------------------------------------------------

-- dmg [deprecated] ----------------------------------
function getDMG()
    log("Called getDMG(), deprecated")
    return "d"
end
function setDMG(params)
    log("Called setDMG() " .. params.input)
end
function getATK()
    log("Called getATK(), deprecated")
    return "d"
end
function setATK(params)
    log("Called setATK() " .. params.input)
end
------------------------------------------------------

function lockInputs(toggle)
    for i = 1, #self.getButtons() do
        self.editButton({index = i - 1, enabled = toggle})
    end

    for i = 1, #self.getInputs() do
        self.editInput({index = i - 1, enabled = toggle})
    end
end

function switch_size(obj, player_clicker_color, alt_click)
    local sizes = {}
    sizes[1] = "Small"
    sizes[2] = "Medium"
    sizes[3] = "Large"
    sizes[4] = "Huge"
    sizes[5] = "Gargantuan"

    local currentSize = getSize()
    local c = 1
    for i = 1, #sizes do
        if sizes[i] == currentSize then
            c = alt_click and i - 1 or i + 1
        end
    end
    if c > #sizes then
        c = 1
    elseif c <= 0 then
        c = #sizes
    end
    self.editButton(
        {
            index = 0,
            label = sizes[c]
        }
    )
end

function boss_checkbox()
    local btn = self.getButtons()[4]
    local isBoss = btn.tooltip == "true"
    local color = {
        red = {0.6196, 0.2431, 0.2431, 1},
        green = {0.1921, 0.4431, 0.1921, 1}
    }
    if not isBoss then
        self.editButton({index = 3, color = color.green})
        self.editButton({index = 3, tooltip = "true"})
    else
        self.editButton({index = 3, color = color.red})
        self.editButton({index = 3, tooltip = "false"})
    end
end

function create_json_note(obj, player_clicker_color, alt_click)
    local vars = {
        name = getName(nil, true),
        ini = getInitiative(),
        hp = getHP(true),
        ac = getAC(),
        mov = getMovement(),
        size = getSize(),
        image = getBossCheckbox() and self.getDescription() or nil,
        side = _side,
        boss_size = getBossSize()
    }

    if (getBag("note") ~= nil) then
        local numberToCreate = getNumberToCreate()
        local id = getBag("note")
        local bag = getObjectFromGUID(id)

        local takeParams = {
            position = getNewPos(id),
            rotation = getNewRot(id),
            callback_function = function(obj)
                obj.setName(vars.name)
                obj.setDescription(JSON.encode(vars))
                if numberToCreate > 1 then
                    obj.setGMNotes(numberToCreate)
                end
                obj.setColorTint(_states[vars.side].bright)
                obj.call("setData")
            end
        }
        bag.takeObject(takeParams)
    end
    --local name = getName(nil, true)
    --local initiative = getInitiative()
    --local hp = getHP(true)
    --local ac = getAC()
    --local movement = getMovement()
    --local size = getSize()
    --local image = getBossCheckbox() and self.getDescription() or nil
    --local numberToCreate = getNumberToCreate()
    --local side = _side
end

-- boss size -----------------------------------------
function getBossSize()
    local input = self.getInputs()[8]
    if input.value == "" or input.value == nil then
        return 1.0
    end
    return input.value
end

function setBossSize(params)
    self.editInput({index = 7, value = params.input})
end
------------------------------------------------------

-- deprecated function, check create_json_note
function create_note(obj, player_clicker_color, alt_click)
    --- create note stuff
    local name = getName(nil, true)
    local initiative = getInitiative()
    local hp = getHP(true)
    local ac = getAC()
    local modi = "0" -- deprecated
    local dice = "d" -- deprecated
    local movement = getMovement()
    local size = getSize()
    local image = getBossCheckbox() and self.getDescription() or nil
    --local boss_size = getBossSize()
    local numberToCreate = getNumberToCreate()

    local str =
        name ..
        "|" .. initiative .. "|" .. hp .. "|" .. ac .. "|" .. modi .. "|" .. dice .. "|" .. movement .. "|" .. size
    if image then
        str = str .. "\n" .. image
    end
    if debug then
        log(str, "Creating note:")
    end
    if getBag("note") ~= nil then
        local id = getBag("note")
        local bag = getObjectFromGUID(id)

        local takeParams = {
            position = getNewPos(id),
            rotation = getNewRot(id),
            callback_function = function(obj)
                obj.setName(name)
                obj.setDescription(str)
                if numberToCreate > 1 then
                    obj.setGMNotes(numberToCreate)
                end
            end
        }
        bag.takeObject(takeParams)
    end

    return str
end

function parseJson()
    -- local stuff = mysplit(mysplit(self.getDescription(), "\n")[1], "|")
    -- local npc_commander = getObjectFromGUID(commander)
    -- npc_commander.call("setName", {input = stuff[1]})
    -- npc_commander.call("setINI", {input = stuff[2]})
    -- npc_commander.call("setHP", {input = stuff[3]})
    -- npc_commander.call("setAC", {input = stuff[4]})
    -- npc_commander.call("setATK", {input = stuff[5]})
    -- npc_commander.call("setDMG", {input = stuff[6]})

    -- if stuff[7] then
    --     npc_commander.call("setMovement", {input = stuff[7]})
    -- end

    -- if stuff[8] then
    --     npc_commander.call("setSize", {input = stuff[8]})
    -- end

    -- local second_line = mysplit(self.getDescription(), "\n")[2]
    -- if second_line ~= nil and second_line ~= "" then
    --     -- this means it is a boss
    --     npc_commander.setDescription(second_line)
    --     npc_commander.call("toggleIsBoss", {input = true})
    -- else
    --     npc_commander.call("toggleIsBoss", {input = false})
    -- end

    -- if self.getGMNotes() ~= "" then
    --     -- this means i have multiple that i want to make
    --     local number = tonumber(self.getGMNotes())
    --     npc_commander.call("setNumberToCreate", {input = number})
    -- end

    local json = getJsonImport()
    local data = JSON.decode(json)

    setName({input = data.name})
    setINI(({input = data.ini}))
    setHP(({input = data.hp}))
    setAC(({input = data.ac}))
    setMovement(({input = data.mov}))
    setSize({input = data.size})
    setSide({input = data.side})
    if data.image then
        toggleIsBoss({input = true})
        self.setDescription(data.image)
    else
        toggleIsBoss({input = false})
    end
end
---------------------------------------

function switch_sides()
    if _side == "enemy" then
        _side = "ally"
    elseif _side == "ally" then
        _side = "neutral"
    elseif _side == "neutral" then
        _side = "enemy"
    end
    self.editButton({index = 4, color = _states[_side].color})
    self.editButton({index = 4, label = _side:gsub("^%l", string.upper)})
end

function setSide(params)
    local side = string.lower(params.input)

    _side = side
    self.editButton({index = 4, color = _states[_side].color})
    self.editButton({index = 4, label = _side:gsub("^%l", string.upper)})
end

-- coroutine based variables
local coInitiativeId,
    coBossId,
    coTokenId,
    coBoonsId

function create_npc(obj, player_clicker_color, alt_click)
    -- go and move to NPCs or to Boss

    local notes = self.getGMNotes()
    local vars = JSON.decode(notes)

    coBoonsId = vars.boons
    coInitiativeId = vars.initiative
    if getBossCheckbox() then
        coBossId = vars["boss"]
        create_thing("boss")
    else
        coTokenId = vars["token"]
        create_thing("token")
    end
end

function create_thing(thing)
    local result = startLuaCoroutine(self, thing .. "_coroutine")
end

function boss_coroutine()
    local boss = getObjectFromGUID(coBossId)
    local numberToCreate = getNumberToCreate()

    for i = 1, numberToCreate do
        local takeParams = {
            position = getNewPos(coBossId),
            rotation = getNewRot(coBossId),
            callback_function = function(spawned)
                local image = self.getDescription()
                local sID = spawned.getGUID()
                spawned.use_hands = true

                spawned.call("_starter", {image = image, boss_size = getBossSize()})

                -- gotta wait else the game freaks out
                -- if you don't save the guid the game gets confused
                Wait.time(
                    function()
                        local me = getObjectFromGUID(sID)
                        local details = create_details(i)
                        details.pawn = me.getGUID()
                        me.call("_init", {master = self, obj = details})
                        me.setPositionSmooth(getDestination(), false, false)

                        create_initiative(details)
                        create_epics()
                    end,
                    0.5
                )
            end
        }
        boss.takeObject(takeParams)
        coroutine.yield(0)
    end

    return 1
end

function token_coroutine()
    local token = getObjectFromGUID(coTokenId)
    local numberToCreate = getNumberToCreate()

    for i = 1, numberToCreate do
        local takeParams = {
            position = getNewPos(coTokenId),
            rotation = getNewRot(coTokenId),
            callback_function = function(spawned)
                spawned.use_hands = true
                Wait.time(
                    function()
                        local details = create_details(i)
                        details.pawn = spawned.getGUID()
                        spawned.call("_init", {master = self, obj = details})
                        spawned.setPositionSmooth(getDestination(), false, false)

                        create_initiative(details)
                        create_epics()
                    end,
                    0.5
                )
            end
        }
        token.takeObject(takeParams)
        coroutine.yield(0)
    end
    return 1
end

function create_details(nameIdentifier)
    local details = {
        name = getName(nameIdentifier),
        hp = getHP(),
        ac = getAC(),
        size = getSize(true),
        initiative = getInitiative(),
        ini_tracker = nil,
        movement = getMovement(),
        side = _side,
        bossSize = getBossSize()
    }
    local blackName = findBlackName(details.name)
    if blackName ~= nil then
        details.name = blackName.name
        blackName = blackName.black
    end

    details.maxhp = details.hp
    details.blackName = blackName
    return details
end

function create_initiative(details)
    local initiative = details.initiative
    local roll = math.random(1.0, 20.0)
    local final = roll + initiative
    if final <= 0 then
        final = 1
    end

    local ini = getObjectFromGUID(coInitiativeId)

    local takeParams = {
        position = getNewPos(coInitiativeId),
        rotation = getNewRot(coInitiativeId),
        callback_function = function(spawned)
            Wait.time(
                function()
                    spawned.call(
                        "_init",
                        {
                            input = {
                                name = details.name,
                                modifier = details.initiative,
                                pawn = details.pawn,
                                side = details.side
                            }
                        }
                    )
                end,
                1
            )
        end
    }
    ini.takeObject(takeParams)

    if _extraParams.lair then
        takeParams.callback_function = function(spawned)
            Wait.time(
                function()
                    spawned.call(
                        "_init",
                        {
                            input = {
                                name = "Lair",
                                modifier = 20,
                                pawn = "",
                                side = "lair",
                                static = true
                            }
                        }
                    )
                end,
                1
            )
        end
        takeParams.position.y = takeParams.position.y + 1.5
        ini.takeObject(takeParams)
    end

    if _extraParams.epic then
        takeParams.callback_function = function(spawned)
            Wait.time(
                function()
                    spawned.call(
                        "_init",
                        {
                            input = {
                                name = "Epic Die",
                                modifier = 50,
                                pawn = "",
                                side = "epic",
                                static = true
                            }
                        }
                    )
                end,
                1
            )
        end
        takeParams.position.y = takeParams.position.y + 1.5
        ini.takeObject(takeParams)
    end
end

function create_epics()
    if _extraParams.epicBoons == nil then
        return
    end
    if coBoonsId == nil then
        printToColor(
            "It seems you have some boons in the data but you didn't setup the boon bag.\nTo use this feature you must have a 'boons' variable in the commander.",
            "Black",
            Color.Red
        )
        return
    end

    local boonBag = getObjectFromGUID(coBoonsId)
    local takeParams = {
        position = getNewPos(coBoonsId),
        rotation = getNewRot(coBoonsId)
    }
    for i = #_extraParams.epicBoons, 1, -1 do
        local boon = _extraParams.epicBoons[i]
        takeParams.callback_function = function(spawned)
            Wait.time(
                function()
                    if type(boon) == "string" then
                        spawned.setDescription(boon)
                    else
                        spawned.setDescription(boon[1])
                        spawned.setName(boon[2])
                    end
                    spawned.setColorTint({0, 0.454902, 0.85098})
                    spawned.call("setData")
                end,
                1
            )
        end
        boonBag.takeObject(takeParams)
        takeParams.position.y = takeParams.position.y + 1.5
    end
end

-- set _extraParams --------------------------
function setExtraParams(params)
    if params == nil then
        _extraParams.epic = false
        _extraParams.lair = false
        _extraParams.epicBoons = nil
        return
    end

    printToColor("Found extra params!", "Black", Color.Blue)
    if params.epic ~= nil then
        _extraParams.epic = params.epic
        printToColor("    epic: [0074D9]" .. tostring(params.epic) .. "[-]", "Black", Color.White)
    else
        _extraParams.epic = false
    end
    if params.lair ~= nil then
        _extraParams.lair = params.lair
        printToColor("    lair: [0074D9]" .. tostring(params.lair) .. "[-]", "Black", Color.White)
    else
        _extraParams.lair = false
    end
    if params.epicBoons ~= nil then
        _extraParams.epicBoons = params.epicBoons
        printToColor("    epicBoons: [0074D9]" .. #params.epicBoons .. "[-]", "Black", Color.White)
    else
        _extraParams.epicBoons = nil
    end

    log(_extraParams)
end
----------------------------------------------

-- utils -------------------------------------
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
----------------------------------------------

-- called functions --------------------------
function destroy(params)
    destroyObject(params.pawn)
end
----------------------------------------------
