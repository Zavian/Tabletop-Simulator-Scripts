local myData = {}
local initialized = false
local restored = false

local _tokenName = ""
local _tokenColor = nil
local _spawnedDie = nil
local _color = "Black"

local _vSize = "128"

local _token = nil
local _myAC = 0
local _myMod = 0

local _myMovement = ""
local _mySide = ""

--local _states = {
--    ["player"] = {color = {0, 0, 0.545098}, state = 1},
--    ["enemy"] = {color = {0.517647, 0, 0.098039}, state = 2},
--    ["ally"] = {color = {0.039216, 0.368627, 0.211765}, state = 3},
--    ["neutral"] = {color = {0.764706, 0.560784, 0}, state = 4}
--}

local _myID = -1

local _UIInput = ""

local _master = nil

local _diePosition = {x = 105.85, y = 4.8, z = -0.01}

local currentHP,
    maxHP = 0

function onLoad(save_state)
    local zpos = -1.7
    local ypos = 0.2
    local xpos = 0

    self.createButton(
        {
            click_function = "destroy_all",
            function_owner = self,
            label = "X",
            position = {x = 0.9, y = ypos, z = 0.9},
            rotation = {0, 180, 0},
            width = 500,
            height = 500,
            font_size = 323,
            color = {1, 0, 0},
            font_color = {1, 1, 1},
            tooltip = "Destroy Token",
            scale = {0.5, 0.5, 0.5}
        }
    )

    self.createButton(
        {
            click_function = "roll_die",
            function_owner = self,
            label = "R",
            position = {x = -0.9, y = ypos, z = 0.9},
            rotation = {0, 180, 0},
            width = 500,
            height = 500,
            font_size = 323,
            color = {1, 0, 0},
            font_color = {1, 1, 1},
            tooltip = "Roll Die",
            scale = {0.5, 0.5, 0.5}
        }
    )

    self.createInput(
        {
            input_function = "name",
            function_owner = self,
            label = "Name",
            alignment = 3,
            position = {x = xpos, y = ypos, z = -1.1},
            rotation = {0, 180, 0},
            width = 2200,
            height = 475,
            font_size = 380,
            validation = 1,
            scale = {0.5, 0.5, 0.5}
        }
    )

    myData = JSON.decode(save_state)
    if myData ~= nil then
        _restore(myData)
    end
end

function _starter(params)
    self.setCustomObject(
        {
            image = params.image
        }
    )
    self.reload()
end

function _init(params)
    initialized = true
    restored = false

    _master = params.master

    _token = params.obj
    currentHP = _token.hp
    maxHP = _token.maxhp
    _myID = _token.id
    _myAC = _token.ac
    _myMod = _token.atk
    _myMovement = _token.movement
    _mySide = _token.side

    updateName()
    create_die()

    setupUI()

    self.setScale({_token.size, _token.size, _token.size})
    updateSave()
end

function updateSave(value)
    myData = {
        name = _tokenName,
        cHP = currentHP,
        mHP = maxHP,
        AC = _myAC,
        MOD = _myMod,
        MOV = _myMovement,
        SIDE = _mySide,
        tCOLOR = _tokenColor
    }
    JSON.encode(myData)
    self.script_state = saved_data
end

function _restore(data)
    initialized = true
    restored = true
    currentHP = data.cHP
    maxHP = data.mHP
    _myAC = data.AC
    _myMod = data.MOD
    _myMovement = data.MOV
    _mySide = data.SIDE
    _tokenColor = data.tCOLOR

    self.editInput({index = 0, value = data.name})
    updateName()
    setupUI()

    updateSave()
end

function onSave()
    if initialized then
        return JSON.encode(myData)
    end
end

function setupUI()
    setHP()

    self.UI.setAttribute("ac", "text", "AC\n" .. _myAC)
    self.UI.setAttribute("movement", "text", _myMovement)

    toggleVisualize({input = false})
    setOperation()
end

function roll_die(obj, color)
    if not restored then
        if color == _color then
            toggleVisualize({input = false})
            if _spawnedDie then
                _spawnedDie.roll()
                local rollWatch = function()
                    return _spawnedDie.resting
                end
                local rollEnd = function()
                    local value = _spawnedDie.getRotationValue()
                    local modifier = _myMod
                    self.UI.setAttribute(
                        "rolled",
                        "text",
                        value .. "+" .. modifier .. "=" .. tonumber(value) + tonumber(modifier)
                    )
                    Wait.time(
                        function()
                            self.UI.setAttribute("rolled", "text", "")
                        end,
                        10
                    )
                end
                Wait.condition(rollEnd, rollWatch)
            end
        end
    end
end

function setOperation()
    self.UI.setAttribute("calculate", "onEndEdit", self.getGUID() .. "/UIUpdateInput(value)")
    self.UI.setAttribute("calculateButton", "onClick", self.getGUID() .. "/UICalculate()")
end

function UICalculate()
    currentHP = currentHP + tonumber(_UIInput)
    setHP()
    self.UI.setAttribute("oldValue", "text", _UIInput)

    if not restored then
        _master.UI.setAttribute("hp-" .. _myID, "text", currentHP .. " | " .. maxHP)
        _master.call("refreshHP", {input = currentHP, id = _myID})
    end

    Wait.time(
        function()
            self.UI.setAttribute("oldValue", "text", "")
        end,
        10
    )
    updateSave()
end

function GlobalCalculate(params)
    local i = params.input
    currentHP = currentHP + tonumber(i)
    setHP()
    self.UI.setAttribute("oldValue", "text", i)

    if not restored then
        _master.UI.setAttribute("hp-" .. _myID, "text", currentHP .. " | " .. maxHP)
    end

    Wait.time(
        function()
            self.UI.setAttribute("oldValue", "text", "")
        end,
        10
    )
    updateSave()
end

function UIUpdateInput(player, value)
    _UIInput = value
end

function setHP()
    self.UI.setAttribute("hp", "text", currentHP .. " / " .. maxHP)
    self.UI.setAttribute("hpBar", "percentage", (currentHP / maxHP) * 100)
    setMyPercentage()
    updateSave()
end

function setMyPercentage()
    local _rough = "#FFDC00FF"
    local _very_rough = "#FF4136FF"
    local _fine = "#2ECC40FF"

    local color = _fine
    local p = (currentHP / maxHP) * 100
    if p <= 25 then
        color = _very_rough
    elseif p <= 50 then
        color = _rough
    end

    self.UI.setAttribute("hpButton", "color", color)
    updateSave()
end

function updateTable(xmlTable)
    self.UI.setXmlTable(xmlTable)
    updateSave()
end

function destroy_all(obj, color, _, _skipUpdate)
    if color == _color or color == nil then
        if not restored then
            _master.call("destroy", {pawn = self, skipUpdate = _skipUpdate})
            _spawnedDie.destruct()
        end
        self.destruct()
    else
        printToColor("m8 don't u even dare", color)
    end
end

function destroy_all_from_ui()
    destroy_all(self, nil, nil, true)
end

ref_diceCustom = {
    {url = "Die_20", name = "", sides = 20} --Default: d20
}

function create_die()
    local tokenColor = self.getColorTint()
    local pos = _diePosition
    pos.x = math.random(101.90, 109.85)
    pos.z = math.random(-6.94, 6.95)

    _spawnedDie =
        spawnObject(
        {
            type = "Die_20",
            position = pos,
            rotation = randomRotation(),
            scale = {1, 1, 1},
            snap_to_grid = false,
            callback_function = function(obj)
                spawn_callback(obj, _tokenName, tokenColor)
            end
        }
    )
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

function spawn_callback(spawned, name, color)
    spawned.setName(name)
    spawned.setColorTint(color)
    spawned.setDescription(_myMod)
    spawned.use_grid = false
end

--function take_initiative(spawned, name)
--    local i = getInitiative()
--    spawned.editInput({index=0, value=name.."\n"..i.value})
--    spawned.setDescription(i.value.."\n"..i.initiative.."+"..i.modifier)
--    initiative.set = true
--    initiative.obj = spawned
--end

function take_hp(spawned, name, color)
    spawned.editInput({index = 2, value = name})
    spawned.setColorTint(color)
    hp.set = true
    hp.obj = spawned
    _hpPosition = {x = 45.00, y = 3, z = -3.69}

    local difference = 3
    local zone = getObjectFromGUID(_hpZone)
    local objs = zone.getObjects()
    for i = 0, #objs do
        local obj = objs[i]
        if obj then
            if obj.getName() == _hpname then
                obj.setPositionSmooth(_hpPosition, false, false)
                obj.setRotationSmooth({0, 270, 0}, false, true)
                _hpPosition.z = _hpPosition.z + difference
            end
        end
    end
    spawned.use_grid = false
end

function getInitiative()
    local modifier = tonumber(getObjectFromGUID(_notecard).getDescription())
    local initiative = math.random(1, 20)
    local v = initiative + modifier
    if v == 0 then
        v = 1
    end
    return {value = v, initiative = initiative, modifier = modifier}
end

function updateName()
    _tokenName = self.getInputs()[1].value
    self.setName(_tokenName)
    if not _tokenColor then
        _tokenColor = randomColor()
        self.setColorTint(_tokenColor)
    end
    updateSave()
end

function name(obj, color, input, stillEditing)
    if not stillEditing then
        _tokenName = input
        self.setName(input)

        if not _tokenColor then
            _tokenColor = randomColor()
            obj.setColorTint(_tokenColor)
        end
        if _spawnedDie then
            _spawnedDie.setName(_tokenName)
            if not restored then
                _master.call("updateName", {pawn = self, name = input})
            end
        end
    end
end

function randomColor()
    local color = {r = 0, g = 0, b = 0}
    if _mySide == "ally" then
        local ally = {
            {r = 154, g = 205, b = 50},
            {r = 85, g = 107, b = 47},
            {r = 107, g = 142, b = 35},
            {r = 124, g = 252, b = 0},
            {r = 127, g = 255, b = 0},
            {r = 173, g = 255, b = 47},
            {r = 0, g = 100, b = 0},
            {r = 0, g = 128, b = 0},
            {r = 34, g = 139, b = 34},
            {r = 0, g = 255, b = 0},
            {r = 50, g = 205, b = 50},
            {r = 144, g = 238, b = 144},
            {r = 152, g = 251, b = 152},
            {r = 143, g = 188, b = 143}
        }
        color = ally[math.random(0, #ally)]
    elseif _mySide == "enemy" then
        local enemy = {
            {r = 128, g = 0, b = 0},
            {r = 139, g = 0, b = 0},
            {r = 165, g = 42, b = 42},
            {r = 178, g = 34, b = 34},
            {r = 220, g = 20, b = 60},
            {r = 255, g = 0, b = 0},
            {r = 255, g = 99, b = 71},
            {r = 255, g = 127, b = 80},
            {r = 205, g = 92, b = 92},
            {r = 240, g = 128, b = 128},
            {r = 233, g = 150, b = 122},
            {r = 250, g = 128, b = 114},
            {r = 255, g = 160, b = 122},
            {r = 255, g = 69, b = 0}
        }
        color = enemy[math.random(0, #enemy)]
    elseif _mySide == "neutral" then
        local neutral = {
            {r = 255, g = 215, b = 0},
            {r = 184, g = 134, b = 11},
            {r = 218, g = 165, b = 32},
            {r = 238, g = 232, b = 170},
            {r = 189, g = 183, b = 107},
            {r = 240, g = 230, b = 140},
            {r = 255, g = 255, b = 0}
        }
        color = neutral[math.random(0, #neutral)]
    end

    return {r = color.r / 255, g = color.g / 255, b = color.b / 255}
end

function randomRotation()
    --Credit for this function goes to Revinor (forums)
    --Get 3 random numbers
    local u1 = math.random()
    local u2 = math.random()
    local u3 = math.random()
    --Convert them into quats to avoid gimbal lock
    local u1sqrt = math.sqrt(u1)
    local u1m1sqrt = math.sqrt(1 - u1)
    local qx = u1m1sqrt * math.sin(2 * math.pi * u2)
    local qy = u1m1sqrt * math.cos(2 * math.pi * u2)
    local qz = u1sqrt * math.sin(2 * math.pi * u3)
    local qw = u1sqrt * math.cos(2 * math.pi * u3)
    --Apply rotation
    local ysqr = qy * qy
    local t0 = -2.0 * (ysqr + qz * qz) + 1.0
    local t1 = 2.0 * (qx * qy - qw * qz)
    local t2 = -2.0 * (qx * qz + qw * qy)
    local t3 = 2.0 * (qy * qz - qw * qx)
    local t4 = -2.0 * (qx * qx + ysqr) + 1.0
    --Correct
    if t2 > 1.0 then
        t2 = 1.0
    end
    if t2 < -1.0 then
        ts = -1.0
    end
    --Convert back to X/Y/Z
    local xr = math.asin(t2)
    local yr = math.atan2(t3, t4)
    local zr = math.atan2(t1, t0)
    --Return result
    return {math.deg(xr), math.deg(yr), math.deg(zr)}
end

function getLines(text)
    local returner = {}
    for s in text:gmatch("[^\r\n]+") do
        table.insert(returner, s)
    end
    return returner
end

function toggleVisualize(params)
    local t = params.input
    if t then
        self.UI.setAttribute("visualizeButton", "width", _vSize)
        self.UI.setAttribute("visualizeButton", "height", _vSize)
        self.UI.setAttribute("visualizeButton2", "width", _vSize)
        self.UI.setAttribute("visualizeButton2", "height", _vSize)
    else
        self.UI.setAttribute("visualizeButton", "width", "0")
        self.UI.setAttribute("visualizeButton", "height", "0")
        self.UI.setAttribute("visualizeButton2", "width", "0")
        self.UI.setAttribute("visualizeButton2", "height", "0")
    end
end
