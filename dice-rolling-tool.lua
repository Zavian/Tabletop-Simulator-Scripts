local _dice = {
    diceSets = {
        [4] = 0,
        [6] = 0,
        [8] = 0,
        [10] = 0,
        [12] = 0,
        [20] = 0
    },
    modifier = 0
}

local registeredDice = {}

function onload()
    self.createButton(
        {
            click_function = "calculate",
            function_owner = self,
            label = "Calculate",
            position = {0, 0.25, -1.18},
            scale = {0.5, 0.5, 0.5},
            width = 3075,
            height = 600,
            font_size = 400
        }
    )
    self.createButton(
        {
            click_function = "setDiceVal",
            function_owner = self,
            label = "Dice",
            position = {-1, 0.25, -1.75},
            scale = {0.5, 0.5, 0.5},
            width = 1175,
            height = 450,
            font_size = 150,
            tooltip = "Dice",
            alignment = 3
        }
    )

    self.createButton(
        {
            click_function = "reset",
            function_owner = self,
            label = "X",
            position = {0, 0.27, -1.75},
            scale = {0.5, 0.5, 0.5},
            width = 575,
            height = 450,
            font_size = 250,
            color = {0.098, 0.098, 0.098, 1},
            font_color = {1, 1, 1, 1},
            tooltip = "Reset",
            alignment = 3
        }
    )

    self.createInput(
        {
            input_function = "setModVal",
            function_owner = self,
            label = "Mod",
            position = {1, 0.25, -1.75},
            scale = {0.5, 0.5, 0.5},
            width = 1175,
            height = 450,
            font_size = 400,
            tooltip = "Mod",
            alignment = 3
        }
    )
end

function onCollisionEnter(info)
    if info then
        local obj = info.collision_object
        if obj then
            if obj.type == "Dice" and not registered(obj.guid) then
                local sides = #obj.getRotationValues()
                _dice.diceSets[sides] = _dice.diceSets[sides] + 1
                table.insert(registeredDice, obj.guid)
                updateDiceVal()
            end
        end
    end
end

function registered(guid)
    for i, v in ipairs(registeredDice) do
        if v == guid then
            return true
        end
    end
    return false
end

function setDiceVal(obj, player_color)
    updateDiceVal()
end

function updateDiceVal()
    local str = ""
    for k, v in pairs(_dice.diceSets) do
        if v > 0 then
            if string.len(str) > 0 then
                str = str .. "+" .. v .. "d" .. k
            else
                str = v .. "d" .. k
            end
        end
    end
    self.editButton({index = 1, label = str})
end

function setModVal()
    _dice.modifier = tonumber(self.getInputs()[1].value)
end

function reset()
    _dice.diceSets = {
        [4] = 0,
        [6] = 0,
        [8] = 0,
        [10] = 0,
        [12] = 0,
        [20] = 0
    }
    _dice.modifier = 0
    self.editButton({index = 1, label = ""})
    self.editInput({index = 0, value = ""})
    self.editButton({index = 0, label = "Calculate"})
    self.setDescription("")
    registeredDice = {}
end

function calculate(obj, player_clicker_color, alt_click)
    local green = "2ECC40"
    local red = "AAAAAAaa"

    self.setDescription("")
    local log = ""
    local result = 0

    for k, v in pairs(_dice.diceSets) do
        if v > 0 then
            local subset = calcSet({sides = k, dice = v})
            log = log .. "Rolling " .. v .. "d" .. k .. ": (" .. subset.result .. ")\n "
            for i = 1, #subset.rolls do
                log =
                    log ..
                    string.format("([%s]%s[-] [%s]%s[-])", green, subset.rolls[i].roll, red, subset.rolls[i].scrap)
            end
            log = log .. "\n"
            result = result + subset.result
        end
    end
    log =
        log ..
        string.format("\n[%s][b]Total: %s + %s = %s[/b][-]", green, result, _dice.modifier, result + _dice.modifier)
    result = result + _dice.modifier
    self.setDescription(log)
    self.editButton({index = 0, label = result})
end

function calcSet(set)
    log(set)
    local result = 0
    local rolls = {}
    for i = 1, set.dice do
        math.randomseed(math.random(250, 12456))
        local roll1 = math.random(1, set.sides)
        math.randomseed(math.random(roll1 * math.random(750, 98723)))
        local roll2 = math.random(1, set.sides)

        local roll = math.max(roll1, roll2)
        log(roll)
        table.insert(rolls, {roll = roll, scrap = math.min(roll1, roll2)})
        result = result + roll
    end
    return {result = result, rolls = rolls}
end

function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s,
        e,
        cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
        s,
            e,
            cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end
