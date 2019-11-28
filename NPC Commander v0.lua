--local _button = "Small"

local id_number = 0

local debug = false

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
    "Lashon"
}

local _side = "enemy"
local _states = {
    ["player"] = {color = {0, 0, 0.545098}, state = 1},
    ["enemy"] = {color = {0.517647, 0, 0.098039}, state = 2},
    ["ally"] = {color = {0.039216, 0.368627, 0.211765}, state = 3},
    ["neutral"] = {color = {0.764706, 0.560784, 0}, state = 4}
}

local _initiative_pos = {117.97, 4, -29.30}
--local _initiative_pos = {45.06, 3, -18.70}
local _initiative_bag = "de97c2"

local _pawn_pos = {x = 121.44, y = 3.2, z = 27.69}
--_pawn_pos = {x = 78.08, y = 3, z = 28.09}
local _pawn_bag = "e1e28a"
local _hand_pos = {141.53, 17.80, -1.09}

local _boss_bag = "627199"

--local _tracker_pos = {x = 42.83, y = 1.5, z = -2.77}
----local _tracker_pos = {x = 42.83, y = 1.5, z = -2.77}
--local _tracker_bag = "d2f618"
--local _tracker_zone = "84f009"

--local _bag_pos = {x = 17.50, y = 2.00, z = 6.12}
local _processing = false

local _global_calc = 0

local _objects = {}

function onLoad()
    local inputs = {
        -- name
        {
            input_function = "none",
            function_owner = self,
            label = "Name",
            position = {6.2, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 2000,
            height = 350,
            font_size = 320,
            tab = 2,
            value = debug and "/" or "",
            tooltip = "Name (/ for random)"
        },
        -- initiative
        {
            input_function = "none",
            function_owner = self,
            label = "INI",
            position = {3.4, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 800,
            height = 350,
            font_size = 320,
            tab = 2,
            validation = 1,
            value = debug and "5" or "",
            tooltip = "Initiative Mod"
        },
        -- hp
        {
            input_function = "hp",
            function_owner = self,
            label = "HP",
            position = {1.5, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1000,
            height = 350,
            font_size = 320,
            tab = 2,
            value = debug and "r25-182" or "",
            tooltip = "Hit Points (rLW-UP)"
        },
        -- ac
        {
            input_function = "none",
            function_owner = self,
            label = "AC",
            position = {-0.4, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 800,
            height = 350,
            font_size = 320,
            tab = 2,
            validation = 2,
            value = debug and "15" or "",
            tooltip = "Armor Class"
        },
        -- attack
        {
            input_function = "none",
            function_owner = self,
            label = "ATK",
            position = {-2.1, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 800,
            height = 350,
            font_size = 320,
            tab = 2,
            validation = 2,
            value = debug and "7" or "",
            tooltip = "Attack Bonus"
        },
        -- damage die
        {
            input_function = "d_die",
            function_owner = self,
            label = "DIE",
            position = {-3.8, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 800,
            height = 350,
            font_size = 200,
            value = debug and "2d8" or "",
            tooltip = "Damage Die"
        },
        -- movement
        {
            input_function = "none",
            function_owner = self,
            label = "Movement",
            position = {-6.3, 0.7, 7.6},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1600,
            height = 350,
            font_size = 280,
            tooltip = "Movement speed",
            value = debug and "10ft" or ""
        },
        -- number
        {
            input_function = "none",
            function_owner = self,
            label = "Number",
            position = {6.57, 0.7, 6.7},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1600,
            height = 350,
            font_size = 320,
            tooltip = "Number to Create",
            alignment = 3,
            value = "1",
            validation = 2
        }
    }

    local buttons = {
        --{
        --    click_function = "switch_size",
        --    function_owner = self,
        --    label = _button,
        --    position = {-6.4, 0.7, 7.6},
        --    rotation = {0, 180, 0},
        --    scale = {0.9, 1.2, 0.9},
        --    width = 1600, height = 450,
        --    font_size = 320
        --},
        {
            click_function = "create_npc",
            function_owner = self,
            label = "Create",
            position = {0.2, 0.7, 6.7},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1600,
            height = 380,
            font_size = 320,
            color = {0.7961, 0.2732, 0.2732, 1}
        },
        {
            click_function = "switch_sides",
            function_owner = self,
            label = "Enemy",
            position = {3.4, 0.7, 6.7},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1600,
            height = 380,
            font_size = 320,
            color = {0.517647, 0, 0.098039, 1}
        },
        {
            click_function = "create_note",
            function_owner = self,
            label = "Note",
            position = {-2.5, 0.7, 6.7},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1100,
            height = 380,
            font_size = 320,
            color = {0.192, 0.701, 0.168, 1},
            tooltip = "Right click for named."
        },
        {
            click_function = "update_checkbox",
            function_owner = self,
            label = " ",
            position = {-4.1, 0.7, 6.7},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 380,
            height = 380,
            font_size = 320,
            color = {0.856, 0.1, 0.094, 1},
            tooltip = "false"
        },
        {
            click_function = "switch_size",
            function_owner = self,
            label = "Medium",
            position = {-6.3, 0.7, 6.7},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1600,
            height = 380,
            font_size = 320,
            color = {0.976471, 0.427451, 0.003922, 1},
            tooltip = "Size"
        }
    }

    for i = 1, #inputs do
        self.createInput(inputs[i])
    end

    for i = 1, #buttons do
        self.createButton(buttons[i])
    end

    if debug then
        self.createButton(
            {
                click_function = "printme",
                function_owner = self,
                label = "Kek",
                position = {-7, 0.7, 6.7},
                rotation = {0, 180, 0},
                scale = {0.9, 1.2, 0.9},
                width = 1600,
                height = 380,
                font_size = 320,
                color = {0, 0, 0, 1},
                font_color = {1, 1, 1, 1}
            }
        )
    end

    self.UI.setAttribute("calculateAll", "onClick", self.getGUID() .. "/UI_CalculateAll")
    self.UI.setAttribute("destroyAll", "onClick", self.getGUID() .. "/UI_DestroyAll")
    self.UI.setAttribute("calculateAllText", "onEndEdit", self.getGUID() .. "/UI_UpdateInput(value)")
end

function none()
end

function hp()
    --should be able to do random
end

function d_die()
    -- validate dies
end

function setNumber(number)
    self.editInput({index = 7, value = number})
end

function getName()
    local inputs = self.getInputs()[1]
    local returner = inputs.value
    if string.sub(returner, 1, 1) == "/" then
        if #returner > 1 then
            returner = string.sub(returner, 2) .. names[math.random(1, #names)]
        else
            returner = names[math.random(1, #names)]
        end
    end
    if debug then
        returner = returner .. id_number
    end
    return returner
end
function getINI()
    local ini = self.getInputs()[2].value
    if string.sub(ini, 1, 1) == "r" then
        ini = string.gsub(ini, "r", "")
        local range = mysplit(ini, "-")
        ini = math.random(range[1], range[2])
    elseif string.sub(ini, 1, 1) == "a" then
        ini = string.gsub(ini, "a", "") + 3
    end
    return ini
end
function getHP()
    local hp = self.getInputs()[3].value
    if string.sub(hp, 1, 1) == "r" then
        hp = string.gsub(hp, "r", "")
        local range = mysplit(hp, "-")
        hp = math.random(range[1], range[2])
    end

    return hp
end
function getAC()
    local inputs = self.getInputs()[4]
    return inputs.value
end
function getATK()
    local inputs = self.getInputs()[5]
    return inputs.value
end
function getDMG()
    local inputs = self.getInputs()[6]
    return inputs.value
end
function getMovement()
    local inputs = self.getInputs()[7]
    return inputs.value
end

function getNumber()
    local inputs = self.getInputs()[8]
    return inputs.value
end

function getSize(getData)
    local buttons = self.getButtons()[5]
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

function setName(params)
    self.editInput({index = 0, value = params.input})
end
function setINI(params)
    self.editInput({index = 1, value = params.input})
end
function setHP(params)
    self.editInput({index = 2, value = params.input})
end
function setAC(params)
    self.editInput({index = 3, value = params.input})
end
function setATK(params)
    self.editInput({index = 4, value = params.input})
end
function setDMG(params)
    self.editInput({index = 5, value = params.input})
end
function setMovement(params)
    self.editInput({index = 6, value = params.input})
end

function setSize(params) 
    self.editButton({index=4, label=params.input})
end

function create_note(obj, color, alt_click)
    local card_pos = {107.95, 3.1, 18.37}
    local card_bag = getObjectFromGUID("15a6b7")
    if not card_bag then
        print("Where's the card bag?")
        return
    end

    if color == "Black" then
        local inputs = self.getInputs()
        local entityName = ""
        local data = {}
        for i = 1, #inputs do
            if inputs[i].label ~= "Number" then
                local val = ""
                if inputs[i].label == "Name" then
                    entityName = inputs[i].value
                    val = getBossCheckbox() and entityName or "/"
                else
                    val = inputs[i].value
                end

                table.insert(data, val)
                if data[i] == "" then
                    print("Error in data")
                    return nil
                end
            end
        end

        table.insert(data, getSize())

        -- create the note with the name as "/"
        local str = ""
        for i = 1, #data do
            if data[i] ~= data[#data] then
                str = str .. data[i] .. "|"
            else
                str = str .. data[i]
            end
        end

        if getBossCheckbox() then
            local desc = self.getDescription()
            if desc ~= "" then
                str = str .. "\n" .. desc
            end
        end

        takeParams = {
            position = card_pos,
            rotation = {0, 270, 0},
            callback_function = function(spawned)
                local waiter = function()
                    return spawned.resting
                end
                local waited = function()
                    spawned.setName(entityName)
                    spawned.setDescription(str)
                end
                Wait.condition(waited, waiter)
            end
        }
        card_bag.takeObject(takeParams)
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
            index = 4,
            label = sizes[c]
        }
    )
end

function create_npc(owner, color, alt_click)
    id_number = id_number + 1
    local object = {
        id = id_number,
        name = getName(),
        initiative = getINI(),
        hp = getHP(),
        ac = getAC(),
        atk = getATK(),
        dmg = getDMG(),
        dice = nil,
        size = getSize(true),
        pawn = nil,
        ini_tracker = nil,
        movement = getMovement(),
        side = _side
    }

    object.maxhp = object.hp
    table.insert(_objects, object)

    local bagToUse = _pawn_bag
    if getBossCheckbox() == true then
        bagToUse = _boss_bag
    end

    _pawn_pos.z = 28.09 + math.random(-4.66, 4.66)
    takeParams = {
        position = _pawn_pos,
        rotation = {0, 0, 0},
        callback_function = function(obj)
            if not getBossCheckbox() then
                take_pawn(obj, object.name, object.id, tonumber(getNumber()) > 1 and true)
            else
                take_boss(obj, object.name, object.id, tonumber(getNumber()) > 1 and true)
            end
        end
    }
    getObjectFromGUID(bagToUse).takeObject(takeParams)

    local waiter = function()
        return object.pawn ~= nil
    end
    local waited = function()
        takeParams = {
            position = _initiative_pos,
            rotation = {0.00, 90.00, 0.00},
            callback_function = function(obj)
                take_initiative(obj, object.name, object.id)
            end
        }
        getObjectFromGUID(_initiative_bag).takeObject(takeParams)
    end
    Wait.condition(waited, waiter)

    --takeParams = {
    --    position = _tracker_pos,
    --    rotation = {0, 90, 0},
    --    callback_function = function(obj)
    --        take_tracker(obj, object)
    --    end
    --}
    --getObjectFromGUID(_tracker_bag).takeObject(takeParams)

    local waiter = function()
        local i = object.ini_tracker ~= nil
        local p = object.pawn ~= nil
        return i and p
    end
    local waited = function()
        addToCommander(object)
        if tonumber(getNumber()) > 1 then
            _processing = true
        end
        checkLoop(id_number + 1)
    end
    Wait.condition(waited, waiter)

    --Wait.time(
    --    function()
    --
    --    end,
    --    1.5
    --)
end

function getBossCheckbox()
    local btn = self.getButtons()[4]
    return btn.tooltip == "true"
end

function update_checkbox()
    --broadcastToColor("Disabled for now, sorry", "Black", {r = 1, g = 1, b = 1})
    --if debug then
    local btn = self.getButtons()[4]
    --printTable(btn)
    local isBoss = btn.tooltip == "true"
    local color = {
        red = {0.856, 0.1, 0.094, 1},
        green = {0.4418, 0.8101, 0.4248, 1}
    }
    if not isBoss then
        --print("it is boss")
        --btn.color = color.green
        --btn.tooltip = "true"
        self.editButton({index = 3, color = color.green})
        self.editButton({index = 3, tooltip = "true"})
    else
        --print("it is not boss")
        --btn.color = color.red
        --btn.tooltip = "false"
        self.editButton({index = 3, color = color.red})
        self.editButton({index = 3, tooltip = "false"})
    end
    --end
end

function toggleIsBoss(params)
    local btn = self.getButtons()[4]
    local color = {
        red = {0.856, 0.1, 0.094, 1},
        green = {0.4418, 0.8101, 0.4248, 1}
    }

    if params.input then
        self.editButton({index = 3, color = color.green})
        self.editButton({index = 3, tooltip = "true"})
    else
        self.editButton({index = 3, color = color.red})
        self.editButton({index = 3, tooltip = "false"})
    end
end

function checkLoop(id)
    local number = tonumber(getNumber())
    if number > 1 then
        number = number - 1
        setNumber(number)
        create_npc()
    end
    if number == 1 and _processing then
        --print(id)
        if id then
            local waiter = function()
                local object = getObjectByID(id)
                --print(id)
                --printTable(object)
                if object then
                    object = object.obj
                    local i = object.ini_tracker ~= nil
                    local p = object.pawn ~= nil
                    return i and p
                else
                    return false
                end
            end
            local waited = function()
                --print("waited")
                _processing = false
                for i = 0, 5 do
                    self.editInput({index = i, value = ""})
                end
            end
            Wait.condition(waited, waiter, 5)
        else
            Wait.time(
                function()
                    _processing = false
                    for i = 0, 5 do
                        self.editInput({index = i, value = ""})
                    end
                end,
                3
            )
        end
    end
end

function addToCommander(payload)
    -- <HorizontalLayout>
    -- <Text class="name" text="Zwerg"></Text>
    -- <Text text="+2"></Text>
    -- <Text class="hp">10 <textcolor color="#FFFFFF">|</textcolor>10</Text>
    -- <Text text="13"></Text>
    -- <Text text="+4"></Text>
    -- <Text text="2d6"></Text>
    -- <Button>-</Button>
    -- <Button id="omegalul" onClick="UI_ButtonClick(omegalul)">+</Button>
    -- <Button class="destroy">X</Button>
    if tonumber(payload.initiative) > 0 then
        payload.initiative = "+" .. payload.initiative
    end

    local xmlTable = self.UI.getXmlTable()
    if not xmlTable[4].children[1].children then
        xmlTable[4].children[1].children = {}
    end
    local toAdd = {
        tag = "HorizontalLayout",
        attributes = {
            id = payload.id,
            color = (payload.id % 2 ~= 0) and "#00000080" or "#00000000"
        },
        children = {
            -- name
            {
                tag = "Text",
                attributes = {
                    class = "name",
                    text = payload.name,
                    id = "name-" .. payload.id
                }
            },
            -- initiative
            {
                tag = "Text",
                attributes = {
                    text = payload.initiative,
                    id = "initiative-" .. payload.id
                }
            },
            -- hp
            {
                tag = "Text",
                attributes = {
                    class = "hp",
                    text = payload.hp .. " | " .. payload.maxhp,
                    id = "hp-" .. payload.id
                }
            },
            -- ac
            {
                tag = "Text",
                attributes = {
                    text = payload.ac,
                    id = "ac-" .. payload.id
                }
            },
            -- dmg
            {
                tag = "Text",
                attributes = {
                    text = payload.dmg,
                    id = "dmg-" .. payload.id
                }
            },
            -- atk
            {
                tag = "Text",
                attributes = {
                    text = payload.atk,
                    id = "atk-" .. payload.id
                }
            },
            -- calculate
            {
                tag = "InputField",
                attributes = {
                    id = "calcText-" .. payload.id,
                    class = "calculate",
                    onEndEdit = self.getGUID() .. "/UI_InputEdit(value)"
                }
            },
            -- calculateButton
            {
                tag = "Button",
                attributes = {
                    id = "calcButton-" .. payload.id,
                    onClick = self.getGUID() .. "/UI_Calculate(" .. payload.id .. ")"
                },
                value = "C"
            },
            -- destroy
            {
                tag = "Button",
                attributes = {
                    class = "destroy",
                    id = "destroy-" .. payload.id,
                    onClick = self.getGUID() .. "/UI_Destroy(" .. payload.id .. ")"
                },
                value = "X"
            }
        }
    }
    table.insert(xmlTable[4].children[1].children, toAdd)
    updateTable(xmlTable)
end

function destroy(caller)
    local object = nil
    if caller.pawn then
        object = getObjectByPawn(caller.pawn)
    elseif caller.object then
        object = caller.object
    end
    if object then
        object.obj.ini_tracker.destruct()
        --object.obj.full_tracker.destruct()

        --printTable(self.UI.getValue(object.obj.id))
        --table.remove(_objects, object.index)

        --printTable(self.UI.getXmlTable())

        if not caller.skipUpdate then
            local xmlTable = self.UI.getXmlTable()
            local rows = xmlTable[4].children[1].children
            local i = 1
            local done = false
            while (i <= #rows and not done) do
                local id = tonumber(rows[i].attributes.id)
                if id == object.obj.id then
                    table.remove(xmlTable[4].children[1].children, i)
                    done = true
                end
                i = i + 1
            end
            updateTable(xmlTable)
        end
        table.remove(_objects, object.index)
    end
end

function take_boss(spawned, name, id, moveIt)
    local waiter = function()
        return spawned.resting
    end
    local waited = function()
        local object = getObjectByID(id).obj

        local image = self.getDescription()

        local gid = spawned.getGUID()

        --spawned.editInput({index = 0, value = name})
        spawned.call("_starter", {image = image})

        Wait.time(
            function()
                spawned = getObjectFromGUID(gid)
                spawned.call(
                    "_init",
                    {
                        master = self,
                        obj = object
                    }
                )
                object.pawn = spawned
                spawned.editInput({index = 0, value = name})

                spawned.use_hands = true
                --spawned.deal(1, "Black", 7)
                spawned.setPositionSmooth(_hand_pos, false, false)
                spawned.setRotationSmooth({0, 270, 0}, false, true)
            end,
            0.5
        )

        --object.pawn = spawned
        --print("-----")
        --print(spawned.getGUID())

        --local desc = self.getDescription()
        --spawned.setCustomObject(
        --    {
        --        image = desc,
        --        image_secondary = desc
        --    }
        --)
        --broadcastToColor("Remember to reimport the image now.", "Black", {r = 1, g = 1, b = 1})

        if debug then
            object.pawn__id = spawned.getGUID()
        end
    end
    Wait.condition(waited, waiter)
end

function take_pawn(spawned, name, id, moveIt)
    local waiter = function()
        return spawned.resting
    end
    local waited = function()
        local object = getObjectByID(id).obj

        spawned.editInput({index = 0, value = name})
        spawned.call(
            "_init",
            {
                master = self,
                obj = object
            }
        )
        --attributeTable = {
        --    value = "kek"
        --    fontSize = 300,
        --    color = "#000000"
        --}
        --spawned.UI.setAttribute("exampleText", attributeTable)
        --spawned.setPositionSmooth(_bag_pos, false, false)
        spawned.use_hands = true
        spawned.setPositionSmooth(_hand_pos, false, false)
        spawned.setRotationSmooth({0, 270, 0}, false, true)
        --spawned.deal(1, "Black", 7)

        object.pawn = spawned
        if debug then
            object.pawn__id = spawned.getGUID()
        end
    end
    Wait.condition(waited, waiter)
end

function take_initiative(spawned, name, id)
    --PrintTable(spawned.getStates())
    local initiative = nil
    --initiative = spawned.call("setSide", {side = _side})

    local waiter = function()
        return spawned.resting
    end
    local waited = function()
        if not initiative then
            initiative = spawned
        end
        local i = getInitiative()

        initiative.call(
            "_init",
            {input = {name = name, i = i, pawn = getObjectByID(id).obj.pawn.getGUID(), side = _side}}
        )
        --initiative.editInput({index = 0, value = name .. "\n" .. i.value})
        --initiative.setDescription(i.value .. "\n" .. i.initiative .. "+" .. i.modifier)

        --if _side == "enemy" then
        --    initiative.call("setToken", {input = getObjectByID(id).obj.pawn.getGUID()})
        --end

        getObjectByID(id).obj.ini_tracker = initiative
        if debug then
            getObjectByID(id).obj.ini_tracker__id = initiative.getGUID()
        end
    end
    Wait.condition(waited, waiter)
end

function take_tracker(spawned, object)
    local waiter = function()
        return spawned.resting
    end
    local waited = function()
        Wait.time(
            function()
                spawned.call("setName", {input = object.name})
                spawned.call("setHP", {input = object.hp})
                spawned.call("setAC", {input = object.ac})
                spawned.call("setATK", {input = object.atk})
                spawned.call("setDMG", {input = object.dmg})
                spawned.call("setColor", {input = object.pawn.getColorTint()})
                spawned.call("order", {input = _tracker_zone})
                object.full_tracker = spawned

                if debug then
                    object.full_tracker__id = spawned.getGUID()
                end
            end,
            2
        )
    end
    Wait.condition(waited, waiter)
end

function switch_sides()
    if _side == "enemy" then
        _side = "ally"
    elseif _side == "ally" then
        _side = "neutral"
    elseif _side == "neutral" then
        _side = "enemy"
    end
    self.editButton({index = 1, color = _states[_side].color})
    self.editButton({index = 1, label = _side:gsub("^%l", string.upper)})
end

function refreshHP(params)
    --local obj = getObjectByID(params.id).obj
    --obj.full_tracker.call("setHP", {input = params.input})
end

function getInitiative()
    local modifier = tonumber(getINI())

    local initiative = math.random(1, 20)
    local v = initiative + modifier
    if v <= 0 then
        v = 1
    end
    return {value = v, initiative = initiative, modifier = modifier}
end

function getObjectByID(id)
    for i = 1, #_objects do
        if _objects[i].id == tonumber(id) then
            return {obj = _objects[i], index = i}
        end
    end
    if debug then
        print("found no object with id " .. id)
    end
    return nil
end

function getObjectByPawn(pawn)
    for i = 1, #_objects do
        if _objects[i].pawn == pawn then
            return {obj = _objects[i], index = i}
        end
    end
    return nil
end

function printme()
    printTable(_objects)
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

function updateName(params)
    local object = getObjectByPawn(params.pawn).obj
    object.name = params.name
    local desc = object.ini_tracker.getDescription()
    local initiative = mysplit(desc, "\n")[1]
    object.ini_tracker.editInput({index = 0, value = params.name .. "\n" .. initiative})
    local xmlTable = self.UI.getXmlTable()
    local row = getRowById(object.id, xmlTable)
    row.children[1].attributes.text = params.name
    updateTable(xmlTable)
end

function getRowById(payload, xmlTable)
    local rows = xmlTable[4].children[1].children
    for i = 1, #rows do
        local id = tonumber(rows[i].attributes.id)
        if id == payload then
            return rows[i]
        end
    end
    return nil
end

function updateTable(xmlTable)
    xmlTable[4].children[1].attributes.height = #_objects and 100 * #_objects or 100
    self.UI.setXmlTable(xmlTable)
end

function UI_Destroy(player, payload, id)
    getObjectByID(tonumber(payload)).obj.pawn.call("destroy_all", nil)
end

function UI_DestroyAll()
    while (_objects[1]) do
        _objects[1].pawn.call("destroy_all_from_ui")
    end
    local xml = self.UI.getXmlTable()
    xml[4].children[1].children = {}

    updateTable(xml)
end

function UI_UpdateInput(player, value)
    _global_calc = value
end

function UI_InputEdit(player, v, id)
    id = tonumber(string.sub(id, -1))
    local obj = getObjectByID(id).obj

    obj.calc = tonumber(v)
end

function UI_CalculateAll()
    for i = 1, #_objects do
        _objects[i].pawn.call("GlobalCalculate", {input = _global_calc})
    end
end

function UI_Calculate(player, v)
    local obj = getObjectByID(tonumber(v)).obj
    obj.pawn.call("GlobalCalculate", {input = obj.calc})
end

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

function convertSize(input)
    if string.len(input) < 6 then
        return 320
    else
        return 180
    end
end
