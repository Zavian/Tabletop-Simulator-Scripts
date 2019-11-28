local _map_bag = "6ca58b"
--local _map_bag = "efc1f7"

local _center_pos = {x = 54.26, y = 5.70, z = -3.65}
--local _center_pos = {x = 88.40, y = -1.74, z = 22.10}

local _bag_pos = {x = 84.13, y = 6.00, z = -3.65}
--local _bag_pos = {x = 38.25, y = 1.00, z = 38.25}

local _piece_pos = {x = 84.13, y = 6.00, z = 18.17}
--local _piece_pos = {x = 55.25, y = -1.74, z = 38.25}

--Runs when the scripted button inside the button is clicked
function buttonPress()
    if lockout == false then
        --Call on any other function here. For example:
        --Global.call("Function Name", {table of parameters if needed})
        --You could also add your own scrting here. For example:
        --print("The button was pressed. Hoozah.")
        positionMap()

        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        lockout = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout
    end
end

--Runs on load, creates button and makes sure the lockout is off
function onload()
    self.createButton(
        {
            label = "Big Red Button\n\nBy: MrStump",
            click_function = "buttonPress",
            function_owner = self,
            position = {0, 0.25, 0},
            height = 1400,
            width = 1400
        }
    )
    lockout = false
end

--Starts a timer that, when it ends, will unlock the button
function startLockoutTimer()
    Timer.create({identifier = self.getGUID(), function_name = "unlockLockout", delay = 0.5})
end

--Unlocks button
function unlockLockout()
    lockout = false
end

--Ends the timer if the object is destroyed before the timer ends, to prevent an error
function onDestroy()
    Timer.destroy(self.getGUID())
end

function positionMap()
    local new_pos = _center_pos
    new_pos.y = 0
    takeParams = {
        position = new_pos,
        rotation = {0, 0, 0}, --to read from desc
        callback_function = function(obj)
            take_item(obj)
        end
    }
    getObjectFromGUID(_map_bag).takeObject(takeParams)
end

function take_item(obj)
    -- processing wether this item is a bag or not
    local t = obj.tag
    if t == "Board" then -- this means this is a map
        take_map(obj)
    elseif t == "Bag" then
        obj.setPositionSmooth(_bag_pos)
        obj.setRotationSmooth({0.00, 90.00, 0.00})

        local waiter = function()
            return obj.resting
        end
        local waited = function()
            process_bag(obj)
        end

        Wait.condition(waited, waiter)
    --process_bag(obj)
    end
end

function process_bag(obj)
    if obj.tag ~= "Bag" then
        return
    end

    local contained = obj.getObjects()
    local taken_objects = {}

    local piece_pos = _piece_pos
    piece_pos.y = math.random(_piece_pos.y, _piece_pos.y + 5)

    for i = 1, #contained do
        takeParams = {
            position = piece_pos,
            callback_function = function(obj)
                take_piece(obj)
            end
        }
        local taken = obj.takeObject(takeParams)
        table.insert(taken_objects, taken)
    end
    local waiter = function()
        return all_resting(taken_objects)
    end
    local waited = function()
        process_pieces(taken_objects)
    end
    Wait.condition(waited, waiter)
end

function all_resting(objs)
    for i = 1, #objs do
        if not objs[i].resting then
            return false
        end
    end
    return true
end

function process_pieces(pieces)
    for i = 1, #pieces do
        Wait.time(
            function()
                local tar_params = process_params(pieces[i])
                if pieces[i].tag ~= board then
                    place_object(pieces[i], tar_params, 0)
                else
                    place_object(pieces[i], tar_params)
                end
                pieces[i].tooltip = false
            end,
            1
        )
    end
end

-- position
-- rotation
-- scale
function process_params(object)
    local desc = object.getDescription()
    local s = mysplit(desc, "\n")

    local tar_rotation = nil
    local tar_position = nil
    local tar_scale = nil

    if #s == 2 then -- rotation, scale
        local s_tar_rotation = mysplit(s[1], ",")
        tar_rotation = {x = s_tar_rotation[1], y = s_tar_rotation[2], z = s_tar_rotation[3]}

        local s_tar_scale = mysplit(s[2], ",")
        tar_scale = {x = s_tar_scale[1], y = s_tar_scale[2], z = s_tar_scale[3]}
    elseif #s == 3 then -- position, rotation, scale
        local s_tar_position = mysplit(s[1], ",")
        tar_position = {x = s_tar_position[1], y = s_tar_position[2], z = s_tar_position[3]}

        local s_tar_rotation = mysplit(s[2], ",")
        tar_rotation = {x = s_tar_rotation[1], y = s_tar_rotation[2], z = s_tar_rotation[3]}

        local s_tar_scale = mysplit(s[3], ",")
        tar_scale = {x = s_tar_scale[1], y = s_tar_scale[2], z = s_tar_scale[3]}
    end

    return {tar_position, tar_rotation, tar_scale}
end

function place_object(obj, tar_params, offset)
    if not offset then
        offset = 0
    end
    if tar_params[1] then
        tar_params[1].y = tar_params[1].y + offset
        obj.setPositionSmooth(tar_params[1], false, false)
    else
        obj.setPositionSmooth({_center_pos.x, _center_pos.y + offset, _center_pos.z}, false, false)
    end

    if tar_params[2] then
        obj.setRotationSmooth(tar_params[2], false, true)
    else
        obj.setRotationSmooth({0, 0, 0}, false, true)
    end

    if tar_params[3] then
        obj.setScale(tar_params[3])
    end
end

function take_piece(obj)
    obj.setLock(true)
end

function take_map(obj)
    local tar_params = process_params(obj)
    place_object(obj, tar_params)
    obj.setLock(true)
    obj.tooltip = false
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
