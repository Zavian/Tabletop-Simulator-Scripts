local sides = nil
local rolling = false
local refDie = nil
local note = ""

function onLoad()
    sides = self.getRotationValues()
    toRoll(self)
end

function onDestroy()
    if refDie ~= nil then
        refDie.destruct()
    end
end

function onRandomize()
    if not rolling then
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
        note = getObjectFromGUID(self.getGMNotes())

        if note.getGMNotes() == "" then
            note.setGMNotes(die.guid)
        else
            note.setGMNotes(note.getGMNotes() .. "," .. die.guid)
        end

        local desc = note.getDescription()
        if desc == "" then
            note.setDescription(die.getValue())
        else
            note.setDescription(desc .. "," .. die.getValue())
        end

        if die.getValue() == #sides then
            explode(die)
        end

        return 1
    end
    startLuaCoroutine(self, "monitorDie_coroutine")
end

function explode(die)
    if #sides ~= 4 then
        local s = ref_customDieSides[tostring(#sides)]
        explodeWith("Die_" .. ref_customDieSides_rev[s])
    end
end

function explodeWith(dieSides)
    local spawnPos = self.getPosition()
    spawnPos.x = spawnPos.x + math.random(-1.5, 1.5)
    spawnPos.z = spawnPos.z + math.random(-1.5, 1.5)

    local selfScale = self.getScale()

    spawnObject(
        {
            type = dieSides,
            position = spawnPos,
            rotation = randomRotation(),
            scale = {selfScale.x - 0.05, selfScale.y - 0.05, selfScale.z - 0.05},
            callback_function = function(obj)
                obj.setLuaScript(self.getLuaScript())
                obj.setGMNotes(self.getGMNotes())
                refDie = obj
            end
        }
    )
end

ref_customDieSides = {["4"] = 0, ["6"] = 1, ["8"] = 2, ["10"] = 3, ["12"] = 4, ["20"] = 5}

ref_customDieSides_rev = {4, 6, 8, 10, 12, 20}

ref_defaultDieSides = {"Die_4", "Die_6", "Die_8", "Die_10", "Die_12", "Die_20"}

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
