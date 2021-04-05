ref_customDieSides = {["4"] = 0, ["6"] = 1, ["8"] = 2, ["10"] = 3, ["12"] = 4, ["20"] = 5}
ref_customDieSides_rev = {4, 6, 8, 10, 12, 20}
ref_defaultDieSides = {"Die_4", "Die_6", "Die_8", "Die_10", "Die_12", "Die_20"}

local sides = nil
local rolling = false
local refDie = nil
local crit = nil
local custom_dice = false

function onLoad()
    sides = self.getRotationValues()
    custom_dice = self.getCustomObject() ~= nil

    self.addContextMenuItem("Reroll dice", reroll)

    toRoll(self)
end

function setCustom(params)
    ref_diceCustom[params.side] = params.url
end

function selfReroll(params)
    if self.getLock() then
        self.setLock(false)
        self.setColorTint(Color.Green)
    end
end

function reroll(player_color)
    local objs = Player[player_color].getSelectedObjects()

    if #objs > 1 then
        for i = 1, #objs do
            callIfCallable(objs[i].call("selfReroll"))
            --objs[i].call("selfReroll")
        end
    elseif self.getLock() then
        self.setLock(false)
        self.setColorTint(Color.Green)
    end
end

function onDestroy()
    if refDie ~= nil then
        refDie.destruct()
    end
end

function onRandomize()
    if not rolling and not self.getLock() then
        monitorDie(self)
    end
end

function monitorDie(die)
    rolling = true
    function monitorDie_coroutine()
        repeat
            coroutine.yield(0)
        until die.resting == true
        rolling = false
        die.setLock(true)
        didRoll(die)

        local gm = self.getGMNotes()
        if gm ~= nil and gm ~= "" then
            local json = JSON.decode(gm)
            if json["crit"] then
                crit = json["crit"]
            end
        end

        if crit then
            local value = die.getValue()
            if crit == 0 then
                explode(die)
            elseif value >= #sides - crit then
                explode(die)
            end
        elseif die.getValue() == #sides then
            explode(die)
        end

        return 1
    end
    startLuaCoroutine(self, "monitorDie_coroutine")
end

function explode(die)
    if #sides ~= 4 then
        local s = ref_customDieSides[tostring(#sides)]
        explodeWith(ref_customDieSides_rev[s])
    end
end

function explodeWith(dieSides)
    local spawnPos = self.getPosition()
    spawnPos.x = spawnPos.x + math.random(-1.5, 1.5)
    spawnPos.z = spawnPos.z + math.random(-1.5, 1.5)

    local selfScale = self.getScale()

    if not custom_dice then
        dieSides = "Die" .. dieSides
    end

    spawnObject(
        {
            type = custom_dice ~= nil and "Custom_Dice" or dieSides,
            position = spawnPos,
            rotation = randomRotation(),
            scale = {selfScale.x - 0.05, selfScale.y - 0.05, selfScale.z - 0.05},
            callback_function = function(obj)
                obj.setLuaScript(self.getLuaScript())
                obj.setGMNotes(self.getGMNotes())
                refDie = obj
                if custom_dice ~= nil then
                    obj.setCustomObject(
                        {
                            image = ref_diceCustom[dieSides],
                            type = ref_customDieSides[tostring(dieSides)]
                        }
                    )
                    obj.reload()
                end
            end
        }
    )
end

function toRoll(die)
    die.setColorTint(Color.Green)
end

function didRoll(die)
    die.setColorTint(Color.Red)
end

--Gets a random rotation vector
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

function callIfCallable(f)
    return function(...)
        error,
            result = pcall(f, ...)
        if error then -- f exists and is callable
            print("ok")
            return result
        end
        -- nothing to do, as though not called, or print('error', result)
    end
end
