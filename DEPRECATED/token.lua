local myData = {}

local initialized = false

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

local restored = false

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
            position = {x = 1.6, y = ypos, z = 1.6},
            rotation = {0, 180, 0},
            width = 500,
            height = 500,
            font_size = 323,
            color = {1, 0, 0},
            font_color = {1, 1, 1},
            tooltip = "Destroy Token"
        }
    )

    self.createButton(
        {
            click_function = "roll_die",
            function_owner = self,
            label = "R",
            position = {x = -1.61, y = ypos, z = 1.6},
            rotation = {0, 180, 0},
            width = 500,
            height = 500,
            font_size = 323,
            color = {1, 0, 0},
            font_color = {1, 1, 1},
            tooltip = "Roll Die"
        }
    )

    self.createInput(
        {
            input_function = "name",
            function_owner = self,
            label = "Name",
            alignment = 3,
            position = {x = xpos, y = ypos, z = zpos},
            rotation = {0, 180, 0},
            width = 2200,
            height = 475,
            font_size = 380,
            validation = 1
        }
    )

    myData = JSON.decode(save_state)
    if myData ~= nil then
        _restore(myData)
    end
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
    updateSave()
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
        Player[params.color].pingTable(self.getPosition())
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

function UI_ConditionMenu(params)
    local v = self.UI.getAttribute("ConditionMenu", "active")
    if v == "true" then
        self.UI.setAttribute("ConditionMenu", "active", "false")
    elseif v == "false" then
        self.UI.setAttribute("ConditionMenu", "active", "true")
    end
end

local _conditions = {
    blinded = {
        desc = "A blinded creature can't see and automatically fails any ability check that requires sight.\nAttack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275757198/B9460859AEC458C86D9657C1E2B1580623F8B5BC/"
    },
    charmed = {
        desc = "A charmed creature can't attack the charmer or target the charmer with harmful abilities or magical effects.\nThe charmer has advantage on any ability check to interact socially with the creature.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275760191/6D2618C57A6A8D5752E50125742B960D0D414D6D/"
    },
    concentration = {
        desc = "Whenever you take damage while you are concentrating on a spell, you must make a Constitution saving throw to maintain your Concentration. The DC equals 10 or half the damage you take, whichever number is higher. If you take damage from multiple sources, such as an arrow and a dragon’s breath, you make a separate saving throw for each source of damage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275760557/8157E260CED63CE99037D31D371B2F5A132CAA11/"
    },
    deafened = {
        desc = "A deafened creature can't hear and automatically fails any ability check that requires hearing.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275760974/AC8120DF8234240B586A9BD4DA9CD35C52DFF29D/"
    },
    frightened = {
        desc = "A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.\nThe creature can't willingly move closer to the source of its fear.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275761396/8C91C898822015B04A84DF5D906C1D168775BF1E/"
    },
    grappled = {
        desc = "A grappled creature's speed becomes 0, and it can't benefit from any bonus to its speed.\nThe condition ends if the grappler is incapacitated.\nThe condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect, such as when a creature is hurled away by the thunderwave spell.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275761896/5F051E43B6A18D016B30EA7743A55FE4F9A09B8F/"
    },
    incapacitated = {
        desc = "An incapacitated creature can't take actions or reactions.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275762313/53D74876998BEE4A165CEBFF9B368731F71E5BCD/"
    },
    invisible = {
        desc = "An invisible creature is impossible to see without the aid of magic or a special sense. For the purpose of hiding, the creature is heavily obscured. The creature's location can be detected by any noise it makes or any tracks it leaves.\nAttack rolls against the creature have disadvantage, and the creature's attack rolls have advantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275762789/7E623448A878DC2413455BEF0F9424636CB684B6/"
    },
    on_fire = {
        desc = "A creature who is on fire takes 2d6 damage at the start of each of their turns.\nThe creature sheds bright light in a 20-foot radius and dim light for an additional 20 feet.\nThe effect can be ended early with the Extinguish action.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275763230/067BB26B3F9F76BD16053956D7617A25697F9B44/"
    },
    paralyzed = {
        desc = "A paralyzed creature is incapacitated and can't move or speak.\nThe creature automatically fails Strength and Dexterity saving throws.\nAttack rolls against the creature have advantage.\nAny attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275763685/0015B9C114E51C9FDDA0BB646DEE5C2D33BA3996/"
    },
    petrified = {
        desc = "A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone). Its weight increases by a factor of ten, and it ceases aging.\nThe creature is incapacitated, can't move or speak, and is unaware of its surroundings.\nAttack rolls against the creature have advantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275764185/EECDE8DEC9F8652B7C039D25465E8005F27EADD6/"
    },
    poisoned = {
        desc = "A poisoned creature has disadvantage on attack rolls and ability checks.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275764643/52B35B1737B0E3B7CF037E15F4BEED36FB72385B/"
    },
    restrained = {
        desc = "A restrained creature's speed becomes 0, and it can't benefit from any bonus to its speed.\nAttack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.\nThe creature has disadvantage on Dexterity saving throws.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275765227/4AC985009CE1EE4CB2D3797194FD6E57567C3951/"
    },
    stunned = {
        desc = "A stunned creature is incapacitated, can't move, and can speak only falteringly.\nThe creature automatically fails Strength and Dexterity saving throws.\nAttack rolls against the creature have advantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275765722/2700DCCA22E84BA5297581E0B5C75581616D92E8/"
    }
}

function manage_state(player, request, v)
    -- request is the requested variable (in this case ID)
    -- v is the value of said variable. in this case we are in the button
    if player.color == "Black" then
        self.UI.setAttribute(v, "active", "false")
        self.UI.setAttribute("btn_" .. v:gsub(" ", "_"), "color", "#ffffff")
    else
        printToColor(v .. ": " .. _conditions[(v:gsub(" ", "_"))].desc, player.color, {r = 1, g = 1, b = 1})
    end
end

function onCollisionEnter(info)
    --{
    --    collision_object = objectReference
    --    contact_points = {
    --        {x=5, y=0, z=-2, 5, 0, -2},
    --    }
    --    relative_velocity = {x=0, y=20, z=0, 0, 20, 0}
    --}
    local obj = info.collision_object
    local name = obj.getName()
    if name ~= "" and name ~= nil then
        if isCondition((name:gsub(" ", "_"))) then
            if obj.tag == "Tile" or obj.tag == "GoPiece" then
                self.UI.setAttribute(string.lower(obj.getName()), "active", "true")
                obj.destruct()
            end
        end
    end
end

function UI_AddCondition(player, request, id)
    local condition = string.lower(string.gsub(id, "btn_", ""))

    local color = self.UI.getAttribute(id, "color")
    if color == "#00ff00" then -- is selected
        -- need to remove condition
        color = "#ffffff"
        self.UI.setAttribute(condition:gsub("_", " "), "active", "false")
    else
        -- add condition
        local newPos = self.getPosition()
        newPos.y = newPos.y + 4
        local custom_object = {
            type = "go_game_piece_black",
            position = newPos,
            callback_function = function(obj)
                obj.setName(condition:gsub("_", " "))
            end
        }
        spawnObject(custom_object)

        color = "#00ff00"
    end

    self.UI.setAttribute(id, "color", color)

    self.UI.setAttribute("ConditionMenu", "active", "false")
end

function UI_ShowCondition(player, request, id)
    local condition = string.lower(string.gsub(id, "btn_", ""))
    condition = condition:gsub("_", " ")
    condition = condition:gsub("^%l", string.upper)
    self.UI.setAttribute("ConditionType", "text", condition)
end

function UI_DefaultCondition()
    self.UI.setAttribute("ConditionType", "text", "Condition")
end

function isCondition(condition)
    if condition ~= nil then
        condition = string.lower(condition)
        if _conditions[condition] ~= nil then
            return _conditions[condition].desc ~= nil
        else
            return nil
        end
    end
end
