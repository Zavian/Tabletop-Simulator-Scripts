local _map_bag = "6ca58b"
local _last_id = ""
local loading = true

function onLoad()
    local buttons = {
        {
            click_function = "bundle",
            function_owner = self,
            label = "Bundle",
            position = {0, 1.8, -0.6},
            scale = {0.5, 0.5, 0.5},
            width = 1600,
            height = 800,
            font_size = 500,
            color = {0.118, 0.53, 1, 1}
        },
        {
            click_function = "add_id",
            function_owner = self,
            label = "+",
            position = {-0.4, 1.79999995231628, 0.400000005960464},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 800,
            font_size = 500,
            color = {0.2588, 0.8235, 0.4078, 1},
            tooltip = "Add item below bag"
        },
        {
            click_function = "create_area",
            function_owner = self,
            label = "A",
            position = {0.4, 1.79999995231628, 0.400000005960464},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 800,
            font_size = 500,
            color = {1, 0.2549, 0.2117, 1},
            tooltip = "Create area to envelop all items\nSet area by right clicking"
        }
    }
    for i = 1, #buttons do
        self.createButton(buttons[i])
    end

    loading = false
end

function onCollisionEnter(info)
    if not loading then
        if info then
            local obj = info.collision_object
            if obj then
                if obj.interactable then
                    if obj.getGUID() then
                        _last_id = obj.getGUID()
                        self.editButton({index = 1, tooltip = _last_id})
                    end
                end
            end
        end
    end
end

function add_id(owner, color, alt_click)
    if color == "Black" then
        local desc = self.getDescription()
        if _last_id then
            self.setDescription(desc .. _last_id .. "\n")
            log("Added " .. _last_id)
            self.editButton({index = 1, label = countIDs()})
        end
    end
end

local _area = nil
function create_area(owner, color, alt_click)
    if color == "Black" then
        if alt_click then
            if _area then
                local objs = _area.getObjects()
                local found = 0
                local array = {}
                for i = 1, #objs do
                    obj = objs[i]
                    if obj.interactable and obj ~= self then
                        table.insert(array, obj.getGUID())
                        found = found + 1
                    end
                end
                local encoded = JSON.encode(array)
                self.setGMNotes(encoded)
                destroyObject(_area)
                _area = nil

                print("Found " .. found .. " objects.")
                found = 0
            end
        else
            if _area then
                destroyObject(_area)
                _area = nil
            end
            positionToZone = self.getPosition()
            spawnParams = {
                type = "ScriptingTrigger",
                position = positionToZone,
                rotation = {x = 0, y = 90, z = 0},
                scale = {x = 4, y = 4, z = 4},
                sound = false,
                snap_to_grid = true
            }
            _area = spawnObject(spawnParams)
        end
    end
end

function countIDs()
    local desc = self.getDescription()
    local counter = 0
    local arr = strsplit(desc, "\n")
    if #arr > 0 then
        for i = 1, #arr do
            if arr[i]:len() == 6 then
                counter = counter + 1
            end
        end
    end

    local gm = self.getGMNotes()
    if gm ~= nil and gm ~= "" then
        counter = counter + #JSON.decode(gm)
    end

    return counter
end

function bundle(owner, color, alt_click)
    if color == "Black" then
        if not alt_click then
            local desc = self.getDescription()
            local ids = strsplit(desc, "\n")
            if #ids > 0 then
                for i = 1, #ids do
                    local obj = getObjectFromGUID(ids[i])
                    if obj then
                        processObj(obj)
                        obj.setScale({0.25, 0.25, 0.25})
                        obj.setLock(false)
                        obj.setFogOfWarReveal(
                            {
                                reveal = false
                            }
                        )
                        self.putObject(obj)
                    end
                end
            end

            local gm = self.getGMNotes()
            if gm ~= nil and gm ~= "" then
                local decoded = JSON.decode(gm)
                for i = 1, #decoded do
                    local obj = getObjectFromGUID(decoded[i])
                    if obj then
                        processObj(obj)
                        obj.setScale({0.25, 0.25, 0.25})
                        obj.setLock(false)
                        obj.setFogOfWarReveal(
                            {
                                reveal = false
                            }
                        )
                        self.putObject(obj)
                    end
                end
            end
        else
            goHome()
        end
    end
end

function goHome()
    local home_bag = getObjectFromGUID(_map_bag)
    home_bag.putObject(self)
end

function processObj(obj)
    local desc = obj.getDescription()
    if desc == "" then
        local str = ""
        local pos = obj.getPosition()
        local rotation = obj.getRotation()
        local scale = obj.getScale()

        str = round(pos.x, 2) .. "," .. round(pos.y, 2) .. "," .. round(pos.z, 2) .. "\n"
        str = str .. round(rotation.x, 0) .. "," .. round(rotation.y, 0) .. "," .. round(rotation.z, 0) .. "\n"
        str = str .. round(scale.x, 3) .. "," .. round(scale.y, 3) .. "," .. round(scale.z, 3)
        obj.setDescription(str)
        obj.tooltip = false
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function strsplit(inputstr, sep)
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
