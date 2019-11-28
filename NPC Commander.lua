--local _button = "Small"

local id_number = 0

local debug = true

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

local _initiative_pos = {45.06, 3, -18.70}
--local _initiative_pos = {45.06, 3, -18.70}
local _initiative_bag = "de97c2"

local _initiative_box = "053ead"

local _pawn_pos = {x = 78.08, y = 3, z = 28.09}
--_pawn_pos = {x = 78.08, y = 3, z = 28.09}
local _pawn_bag = "e1e28a"
local _hand_pos = {86.19, 4, -0.39}

local _tracker_pos = {x = 42.83, y = 1.5, z = -2.77}
--local _tracker_pos = {x = 42.83, y = 1.5, z = -2.77}
local _tracker_bag = "d2f618"
local _tracker_zone = "84f009"

local _bag_pos = {x = 17.50, y = 2.00, z = 6.12}
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
            validation = 2,
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
            click_function = "INSERT_FUNCTION",
            function_owner = self,
            label = "Small",
            position = {-6.3, 0.699999988079071, 6.69999980926514},
            rotation = {0, 180, 0},
            scale = {0.899999976158142, 1.20000004768372, 0.899999976158142},
            width = 1600,
            height = 380,
            font_size = 320,
            color = {0.7961, 0.2732, 0.2732, 1},
            tooltip = "Small"
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
                position = {-5, 0.7, 6.7},
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

--function switch_size()
--    local newSize = _button == "Small" and "Big" or "Small"
--    _button = newSize
--    self.editButton({index=0, label=newSize})
--end

function create_npc()
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
        --full_tracker = nil,
        pawn = nil,
        ini_tracker = nil,
        movement = getMovement(),
        side = _side
    }

    object.maxhp = object.hp
    table.insert(_objects, object)

    _pawn_pos.z = 28.09 + math.random(-4.66, 4.66)
    takeParams = {
        position = _pawn_pos,
        rotation = {0, 0, 0},
        callback_function = function(obj)
            take_pawn(obj, object.name, object.id, tonumber(getNumber()) > 1 and true)
        end
    }
    getObjectFromGUID(_pawn_bag).takeObject(takeParams)

    --takeParams = {
    --    position = _initiative_pos,
    --    rotation = {0.00, 90.00, 0.00},
    --    callback_function = function(obj)
    --        take_initiative(obj, object.name, object.id)
    --    end
    --}
    --getObjectFromGUID(_initiative_bag).takeObject(takeParams)
    local waiter = function()
        return object.pawn ~= nil
    end
    local waited = function()
        local initiative_payload = {
            id = object.id,
            owner = object.pawn.getGUID(),
            color = _side,
            data = {
                initiative = object.initiative,
                name = object.name
            }
        }
        local box = getObjectFromGUID(_initiative_box)
        box.call("initiative", initiative_payload)
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

    addToCommander(object)
    if tonumber(getNumber()) > 1 then
        _processing = true
    end
    Wait.time(
        function()
            checkLoop()
        end,
        1.5
    )
end

function checkLoop()
    local number = tonumber(getNumber())
    if number > 1 then
        number = number - 1
        setNumber(number)
        create_npc()
    end
    if number == 1 and _processing then
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
        --spawned.deal(1, "Black")

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
    if _side ~= "enemy" then
        initiative = spawned.setState(_states[_side].state)
    end
    local waiter = function()
        return spawned.resting
    end
    local waited = function()
        if not initiative then
            initiative = spawned
        end
        local i = getInitiative()

        initiative.editInput({index = 0, value = name .. "\n" .. i.value})
        initiative.setDescription(i.value .. "\n" .. i.initiative .. "+" .. i.modifier)

        if _side == "enemy" then
            initiative.call("setToken", {input = getObjectByID(id).obj.pawn.getGUID()})
        end

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
    local obj = getObjectByID(params.id).obj
    obj.full_tracker.call("setHP", {input = params.input})
end

function getInitiative()
    local modifier = tonumber(getINI())
    local initiative = math.random(1, 20)
    local v = initiative + modifier
    if v == 0 then
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
