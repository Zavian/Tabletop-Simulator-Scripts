local dice = {}
local area = ""
local dice_number = 0
local crit = nil

function onload()
    local gm = self.getGMNotes()
    local json = JSON.decode(gm)

    dice["d4"] = json["d4"]
    dice["d6"] = json["d6"]
    dice["d8"] = json["d8"]
    dice["d10"] = json["d10"]
    dice["d12"] = json["d12"]
    dice["d20"] = json["d20"]
    area = json["area"]

    self.createButton(
        {
            click_function = "calcTotal",
            function_owner = self,
            label = "TOTAL",
            position = {-0.7, 0.4, 1.9},
            scale = {0.4, 0.4, 0.4},
            width = 2000,
            height = 600,
            font_size = 400,
            color = {0, 0, 0, 1},
            font_color = {1, 1, 1, 1}
        }
    )
    self.createButton(
        {
            click_function = "clearDice",
            function_owner = self,
            label = "Clear Dice",
            position = {0.53, 0.4, 1.9},
            scale = {0.4, 0.4, 0.4},
            width = 1800,
            height = 600,
            font_size = 400,
            color = {1, 0.2549, 0.2117, 1},
            font_color = {1, 1, 1, 1},
            tooltip = "Clear all dice"
        }
    )

    local buttons_dice = {
        {
            function_owner = self,
            label = "d4",
            position = {-3.03, 0.4, 3.26},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 900,
            font_size = 500
        },
        {
            function_owner = self,
            label = "d6",
            position = {-1.88, 0.4, 3.26},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 900,
            font_size = 500
        },
        {
            function_owner = self,
            label = "d8",
            position = {-0.78, 0.4, 3.26},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 900,
            font_size = 500
        },
        {
            function_owner = self,
            label = "d10",
            position = {0.42, 0.4, 3.26},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 900,
            font_size = 500
        },
        {
            function_owner = self,
            label = "d12",
            position = {1.52, 0.4, 3.26},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 900,
            font_size = 500
        },
        {
            function_owner = self,
            label = "d20",
            position = {2.84, 0.4, 3.26},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 900,
            font_size = 500
        }
    }
    for i = 1, #buttons_dice do
        self.createButton(
            {
                click_function = buttons_dice[i].label,
                function_owner = buttons_dice[i].function_owner,
                label = buttons_dice[i].label,
                position = buttons_dice[i].position,
                scale = buttons_dice[i].scale,
                width = buttons_dice[i].width,
                height = buttons_dice[i].height,
                font_size = buttons_dice[i].font_size,
                color = {0, 0, 0, 0},
                tooltip = buttons_dice[i].label
            }
        )
    end

    self.createButton(
        {
            click_function = "inc0",
            function_owner = self,
            label = "+0",
            position = {-0.45, 0.4, 2.42},
            scale = {0.4, 0.4, 0.4},
            width = 460,
            height = 460,
            font_size = 200,
            color = {0.6, 0.6, 0.6, 1},
            font_color = {0.7648, 0, 0, 1},
            tooltip = "+0"
        }
    )
    self.createButton(
        {
            click_function = "inc1",
            function_owner = self,
            label = "+1",
            position = {-0.05, 0.4, 2.42},
            scale = {0.4, 0.4, 0.4},
            width = 460,
            height = 460,
            font_size = 200,
            color = {0.6313, 0.949, 0.6666, 1},
            font_color = {0, 0, 0, 1},
            tooltip = "+1"
        }
    )
    self.createButton(
        {
            click_function = "inc2",
            function_owner = self,
            label = "+2",
            position = {0.35, 0.4, 2.42},
            scale = {0.4, 0.4, 0.4},
            width = 460,
            height = 460,
            font_size = 200,
            color = {0.5019, 0.8823, 0.5451, 1},
            font_color = {0, 0, 0, 1},
            tooltip = "+2"
        }
    )
    self.createButton(
        {
            click_function = "inc3",
            function_owner = self,
            label = "+3",
            position = {0.75, 0.4, 2.42},
            scale = {0.4, 0.4, 0.4},
            width = 460,
            height = 460,
            font_size = 200,
            color = {0.3607, 0.8431, 0.4156, 1},
            font_color = {0, 0, 0, 1},
            tooltip = "+3"
        }
    )
    self.createButton(
        {
            click_function = "incAll",
            function_owner = self,
            label = "ALL",
            position = {1.49, 0.4, 2.42},
            scale = {0.4, 0.4, 0.4},
            width = 1250,
            height = 460,
            font_size = 200,
            color = {0.1804, 0.8, 0.2509, 1},
            font_color = {0, 0, 0, 1},
            tooltip = "ALL"
        }
    )
end

function inc0()
    crit = nil
    editGroup(8)
end
function inc1()
    crit = 1
    editGroup(9)
end
function inc2()
    crit = 2
    editGroup(10)
end
function inc3()
    crit = 3
    editGroup(11)
end
function incAll()
    crit = 0
    editGroup(12)
end

function editGroup(index)
    for i = 7, 11 do
        if (index == i) then
            self.editButton({index = index, font_color = {0.7648, 0, 0, 1}})
        else
            self.editButton({index = i, font_color = {0, 0, 0, 1}})
        end
    end
end

function clearDice()
    local zone = getObjectFromGUID(area)
    local objs = zone.getObjects()

    if #objs > 0 then
        self.editButton({index = 0, tooltip = self.getButtons()[1].label})
        self.editButton({index = 0, label = "0"})
    else
        return 0
    end

    for i = 1, #objs do
        local obj = objs[i]
        local gm = obj.getGMNotes()

        if gm ~= nil and gm ~= "" then
            local json = JSON.decode(gm)
            if json["dice"] == "exploding" then
                destroyObject(obj)
            end
        end
    end
end

function calcTotal()
    local zone = getObjectFromGUID(area)
    local objs = zone.getObjects()

    local total = 0

    if #objs > 0 then
        self.editButton({index = 0, tooltip = self.getButtons()[1].label})
        self.editButton({index = 0, label = "0"})
    else
        return 0
    end

    for i = 1, #objs do
        local obj = objs[i]
        local gm = obj.getGMNotes()

        if gm ~= nil and gm ~= "" then
            local json = JSON.decode(gm)
            if json["dice"] == "exploding" then
                if obj.getLock() == true then
                    local v = obj.getRotationValue()
                    total = total + v
                end
            end
        end
    end

    self.editButton({index = 0, label = total})
end

function d4()
    make_die("d4")
end
function d6()
    make_die("d6")
end
function d8()
    make_die("d8")
end
function d10()
    make_die("d10")
end
function d12()
    make_die("d12")
end
function d20()
    make_die("d20")
end

function make_die(die)
    local bag = getObjectFromGUID(dice[die])
    getDie(bag)
end

function scaleDown(die)
    die.setScale({0.8, 0.8, 0.8})
end

function toRoll(die)
    die.setColorTint(Color.Green)
end

function didRoll(die)
    die.setColorTint(Color.Red)
end

function getDie(bag)
    local takeParams = {
        position = getDiePos(),
        rotation = randomRotation(),
        callback_function = function(spawned)
            if crit ~= nil then
                note = {dice = "exploding", crit = crit}
                spawned.setGMNotes(JSON.encode(note))
            end

            toRoll(spawned)
            scaleDown(spawned)

            -- fancy stuff
            spawned.setLock(true)
            Wait.time(
                function()
                    spawned.setLock(false)
                end,
                0.5
            )
            -----------------
        end
    }
    bag.takeObject(takeParams)
end

function getDiePos()
    local gm = self.getGMNotes()
    local json = JSON.decode(gm)
    local pos = {x = json["startingPos"][1], y = json["startingPos"][2], z = json["startingPos"][3]}
    local padding = json["padding"]

    dice_number = dice_number + 1
    if dice_number > 6 then
        pos.z = pos.z + 1.2
        dice_number = 1
    end
    pos.x = pos.x + (padding * dice_number)
    return pos
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

ref_customDieSides = {["4"] = 0, ["6"] = 1, ["8"] = 2, ["10"] = 3, ["12"] = 4, ["20"] = 5}

ref_customDieSides_rev = {4, 6, 8, 10, 12, 20}

ref_defaultDieSides = {"Die_4", "Die_6", "Die_8", "Die_10", "Die_12", "Die_20"}
