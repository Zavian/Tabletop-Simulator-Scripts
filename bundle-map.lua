local _map_bag = "6ca58b"
local _last_id = ""

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
            position = {0, 1.8, 0.4},
            scale = {0.5, 0.5, 0.5},
            width = 900,
            height = 800,
            font_size = 500,
            color = {0.2588, 0.8235, 0.4078, 1},
            tooltip = ""
        }
    }
    for i = 1, #buttons do
        self.createButton(buttons[i])
    end
end

function onCollisionEnter(info)
    local obj = info.collision_object
    if obj.interactable then
        if obj.getGUID() then
            _last_id = obj.getGUID()
            self.editButton({index = 1, tooltip = _last_id})
        end
    end
end

function add_id(owner, color, alt_click)
    if color == "Black" then
        local desc = self.getDescription()
        if _last_id then
            self.setDescription(desc .. "\n" .. _last_id)
            log("Added " .. _last_id)
        end
    end
end

function bundle(owner, color, alt_click)
    if color == "Black" then
        if not alt_click then
            local desc = owner.getDescription()
            local ids = strsplit(desc, "\n")
            for i = 1, #ids do
                local obj = getObjectFromGUID(ids[i])
                if obj then
                    processObj(obj)
                    obj.setScale({0.25, 0.25, 0.25})
                    obj.setLock(false)
                    owner.putObject(obj)
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
