local FREEZE = false
local DEBUG = false
local MEMO_LOADED = false


local _RECTANGLE = {
    red = {
        {-0.4,  1.5, 0.4}, -- top left
        {-0.05, 1.5, 0.4}, -- middle top
        {-0.05, 1.5, -0.4}, -- middle bottom
        {-0.4,  1.5, -0.4} -- top left
    },
    blue = {
        {0.4,   1.5, 0.4}, -- top left
        {0.05,  1.5, 0.4}, -- middle top
        {0.05,  1.5, -0.4}, -- middle bottom
        {0.4,   1.5, -0.4} -- top left
    }    
}

local OBJECT_LIST = {}

local _CHECKERS = {}

local _PLAYER_COLORS = { }

local _TAG = "player_color"

local WHO_CAN_SEE_BLUE = {}
local WHO_CAN_SEE_RED = {}

function onLoad()
    self.createButton({
        click_function = 'spawn_colors',
        function_owner = self,
        label = 'Spawn Colors',
        position = {-0.35, 0.5, 0.45},
        rotation = {0, 180, 0},
        scale = {0.05,0.05,0.05},
        width = 2500,
        height = 500,
        font_size = 400,
        tooltip = 'Spawn Colors'
    })
    self.createButton({
        click_function = 'set_objects',
        function_owner = self,
        label = 'Set Objects',
        position = {-0.08, 0.5, 0.45},
        rotation = {0, 180, 0},
        scale = {0.05,0.05,0.05},
        width = 2500,
        height = 500,
        font_size = 400,
        tooltip = 'Set Objects',
        color = Color.Blue,
        font_color = Color.White
    })

    loadMemo()
    loadColorNames()

    -- spawn_colors()  
end


function loadColorNames()
    local gm = self.getGMNotes()
    if gm == nil or gm == "" then return end
    if not isValidJSON(gm) then return end
    
    local data = JSON.decode(gm)
    if not hasAnyColor(data) then return end

    broadcastToColor("Found some names!", "Black", "Teal")

    _PLAYER_COLORS = data
end

function hasAnyColor(jsonObject)
    local colors = {
        "blue",
        "white",
        "red",
        "cyan",
        "green",
        "orange",
        "yellow",
        "teal",
        "brown",
        "purple",
        "pink"
    }

    for _, color in ipairs(colors) do
        if jsonObject[color] then
            return true
        end
    end

    return false
end


function isValidJSON(jsonString)
    if jsonString == "" then
        return false
    end

    -- Check if the string starts with an opening brace
    if jsonString:sub(1, 1) ~= "{" then
        return false
    end

    -- Check if the string ends with a closing brace
    if jsonString:sub(-1) ~= "}" then
        return false
    end

    return true
end

function loadMemo()
    if DEBUG then
        local testjson = [[
{
    "blue": [
        "5825b1",
        "d7a074",
        "8b1c2f"
    ],
    "red": [
        "79bb8b",
        "a064b2",
        "ba32f6"
    ]
}
    ]]

        local testData = JSON.decode(testjson)
        OBJECT_LIST = testData
    else 
        local memo = self.memo


        if not isValidJSON(memo) then
            printError("There is something wrong with the JSON in memo")
        end
        
        local data = nil
        data = JSON.decode(memo)
        OBJECT_LIST = data
        print("[0074D9]Found some data[-]")
        MEMO_LOADED = true
        
    end

end

function onCollisionEnter(c)
    if not MEMO_LOADED then return end
    if FREEZE then return end
    local obj = c.collision_object
    if obj.hasTag(_TAG) then        
        if (isInBlue(obj)) then
            obj.highlightOn(Color.Blue)
            -- obj.setTags({_TAG, "blue"})

            local color = _CHECKERS[obj.getGUID()]

            WHO_CAN_SEE_RED, WHO_CAN_SEE_BLUE = moveArray(WHO_CAN_SEE_RED, WHO_CAN_SEE_BLUE, {color})
            
            toggleVisibilities()

        elseif (isInRed(obj)) then
            obj.highlightOn(Color.Red)
            -- obj.setTags({_TAG, "red"})

            local color = _CHECKERS[obj.getGUID()]

            WHO_CAN_SEE_BLUE, WHO_CAN_SEE_RED = moveArray(WHO_CAN_SEE_BLUE, WHO_CAN_SEE_RED, {color})
            
            toggleVisibilities()

        else
            obj.highlightOff()
            obj.setTags({_TAG})
        end
    end
end

function moveArray(startingArray, endingArray, values)
    for _, value in ipairs(values) do
        -- Check if the value exists in arrayA
        local index = nil
        for i, v in ipairs(startingArray) do
            if v == value then
                index = i
                break
            end
        end
        
        -- If the value is found in arrayA, move it to arrayB
        if index then
            table.insert(endingArray, value)
            table.remove(startingArray, index)
        end
    end

    return startingArray, endingArray
end

function getBlueCheckers()
    local returner = {}
    for guid, color in pairs(_CHECKERS) do
        local obj = getObjectFromGUID(guid)
        if obj.hasTag("blue") then table.insert(returner, guid) end
    end
    return returner
end

function getRedCheckers()
    local returner = {}
    for guid, color in pairs(_CHECKERS) do
        local obj = getObjectFromGUID(guid)
        if obj.hasTag("red") then table.insert(returner, guid) end
    end
    return returner
end


function toggleVisibilities()
    for _, guid in ipairs(OBJECT_LIST.blue) do
        local object = getObjectFromGUID(guid)
        if object then
            object.setInvisibleTo(WHO_CAN_SEE_RED)
        end
    end

    for _, guid in ipairs(OBJECT_LIST.red) do
        local object = getObjectFromGUID(guid)
        if object then
            object.setInvisibleTo(WHO_CAN_SEE_BLUE)
        end
    end

    if DEBUG then
        log("================")
        log(OBJECT_LIST)
        log(WHO_CAN_SEE_RED, "Red")
        log(WHO_CAN_SEE_BLUE, "Blue")
        log("================")
    end
end

function spawn_colors()
    if not MEMO_LOADED then
        printError("I have no data, please insert some!")
        return
    end

    FREEZE = true
    local seated = getSeatedPlayers()

    if DEBUG then seated = {"Red", "Green", "Blue", "Yellow", "Purple", "Orange"} end
    table.insert(seated, "Grey")

    WHO_CAN_SEE_BLUE = {}
    WHO_CAN_SEE_RED = seated
    
    local pos = self.positionToWorld({-0.35, 1.5, 0.35})

    for i, color in ipairs(seated) do

        local object = spawnObject({
            type = "Checker_white",
            position = color == "Grey" and self.positionToWorld({-0.45, 1.5, 0.45}) or pos,
            scale = {0.7, 0.7, 0.7},
            sound = false,
            snap_to_grid = false,
            callback_function = function(spawned)
                if _PLAYER_COLORS[color] then
                    spawned.setName(_PLAYER_COLORS[color])
                end
                spawned.setColorTint(color)
                spawned.addTag(_TAG)
                Wait.time(function() 
                        _CHECKERS[spawned.getGUID()] = color
                        
                    end, 
                1)
                -- _CHECKERS[spawned.getGUID()] = color
            end
        })
        pos = pos + vector(1.1, 0, 0)

        if i % 4 == 0 then 
            pos = self.positionToWorld({-0.35, 1.5, 0.35}) + vector(0, 0, -1.5) 
        end

    end
    
    toggleVisibilities()
    
    FREEZE = false
end

function set_objects()
    local default_text = [[
{
    "blue": [
        -- replace me with GUIDs
        -- Example: "aaaaaa"
    },
    "red": [
        -- replace me with GUIDs
        -- Example: "aaaaaa"
    ]
}
    ]]

    if self.memo ~= nil and self.memo ~= "" then default_text = self.memo end

    Player["Black"].showMemoDialog("Objects", default_text,
    function (text, player_color)
        self.memo = text
        
        local data = JSON.decode(text)
        OBJECT_LIST = data
    end
)
end

function drawRectangle(color)
    if color == "red" then
        for i, v in ipairs(_RECTANGLE.red) do
            local object = spawnObject({
                type = "BlockSquare",
                position = self.positionToWorld(v),
                scale = {0.1, 0.1, 0.1},
                sound = false,
                callback_function = function(spawned_object)
                    log(spawned_object.getBounds())
                end
            })
        end
    elseif color == "blue" then
        for i, v in ipairs(_RECTANGLE.blue) do
            local object = spawnObject({
                type = "BlockSquare",
                position = self.positionToWorld(v),
                scale = {0.1, 0.1, 0.1},
                sound = false,
                callback_function = function(spawned_object)
                    log(spawned_object.getBounds())
                end
            })
        end
    end
end

function isInRed(obj)
    local position = self.positionToLocal(obj.getPosition())
    return isPositionWithinRectangle(position, _RECTANGLE.red)
end
function isInBlue(obj)
    local position = self.positionToLocal(obj.getPosition())
    return isPositionWithinRectangle(position, _RECTANGLE.blue)
end

function isPositionWithinRectangle(position, rectangleVertices)
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge

    for _, vertex in ipairs(rectangleVertices) do
        minX = math.min(minX, vertex[1])
        maxX = math.max(maxX, vertex[1])
        minZ = math.min(minZ, vertex[3])
        maxZ = math.max(maxZ, vertex[3])
    end

    return position[1] >= minX and position[1] <= maxX and
           position[3] >= minZ and position[3] <= maxZ
end

function printError(text) 
    broadcastToColor(text, "Black", "Red")
end