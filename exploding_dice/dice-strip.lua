local dice = {}
local note = ""
local dice_number = 0

function onLoad()
    local gm = self.getGMNotes()
    local json = JSON.decode(gm)

    dice["d4"] = json["d4"]
    dice["d6"] = json["d6"]
    dice["d8"] = json["d8"]
    dice["d10"] = json["d10"]
    dice["d12"] = json["d12"]
    dice["d20"] = json["d20"]
    note = json["note"]

    local lbl = json["label"] == "true"

    for i = 1, #ref_defaultDieSides do
        local funcName = "Button_Die_" .. ref_customDieSides_rev[i]
        self.createButton(
            {
                click_function = funcName,
                function_owner = self,
                color = {1, 1, 1, 0},
                position = {-2.5 + (i - 1) * 1, 0.05, 0},
                height = 330,
                width = 330,
                tooltip = lbl and "d" .. ref_customDieSides_rev[i] or ""
            }
        )
    end
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
        position = getDiePos(coBossId),
        rotation = randomRotation(),
        callback_function = function(spawned)
            spawned.setGMNotes(note)
            toRoll(spawned)
            scaleDown(spawned)
            spawned.setLock(true)
            Wait.time(
                function()
                    spawned.setLock(false)
                end,
                0.5
            )
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

function Button_Die_4()
    local bag = getObjectFromGUID(dice["d4"])
    getDie(bag)
end

function Button_Die_6()
    local bag = getObjectFromGUID(dice["d6"])
    getDie(bag)
end

function Button_Die_8()
    local bag = getObjectFromGUID(dice["d8"])
    getDie(bag)
end

function Button_Die_10()
    local bag = getObjectFromGUID(dice["d10"])
    getDie(bag)
end

function Button_Die_12()
    local bag = getObjectFromGUID(dice["d12"])
    getDie(bag)
end

function Button_Die_20()
    local bag = getObjectFromGUID(dice["d20"])
    getDie(bag)
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
