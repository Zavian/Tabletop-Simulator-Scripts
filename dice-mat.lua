local _sz = "876993"
local _blockBag = "012999"

local _blockPosition = {x=-1.21, y=2.30, z=8.34}
local _blockName = "block"
local _color = "Black"

local dices = {}

function getSides(dice) 
    local values = dice.getRotationValues(dice)
    value = values[#values].value
    return value
end

self.createButton({
    click_function = "roll_all", 
    function_owner = self, 
    label = "Roll All", 
    position = {0.8, 0.33, 1.15}, 
    rotation = {0, 90, 0}, 
    scale = {0.3, 0.6, 0.5}, 
    width = 600, 
    height = 200, 
    font_size = 150, 
    color = {0.113725, 0.117647, 0.066667, 1}, font_color = {1, 1, 1, 1}, 
    alignment = 3
})

self.createInput({
    input_function = "edit_mods", 
    function_owner = self,
    label = "v", 
    position = {0.8, 0.35, 0.956}, 
    rotation = {0, 90, 0}, 
    scale = {0.2, 0.4, 0.4},
    width = 200, 
    height = 200, 
    font_size = 150, 
    color = {0.1137, 0.1176, 0.0666, 1},
     font_color = {1, 1, 1, 1}, 
     tooltip = "Edit All Mods", 
     alignment = 3
})

function takeBlock(spawned, name, color, reference)
    spawned.setColorTint(color)
    spawned.editInput({index=0, value=name})
    spawned.editInput({index=1, value=reference.getRotationValue()})
    spawned.editInput({index=2, value=reference.getDescription()})
    spawned.editInput({index=3, value="= " .. reference.getRotationValue()+reference.getDescription()})

    spawned.setScale({2.29,0.2,1.17})
    spawned.tooltip = false
    spawned.setName(_blockName)
    spawned.setLock(true)

    dices[reference.getGUID()] = spawned.getGUID()
    orderBlocks()
end

function orderBlocks()
    local blockPosition = {x=-1.21, y=2.30, z=8.34}
    local zone = getObjectFromGUID(_sz)
    local objs = zone.getObjects()
    local difference = 1.29
    for i=0, #objs do
        local obj = objs[i]
        if obj then
            if obj.getName() == _blockName then
                obj.setPositionSmooth(blockPosition, false, true)
                obj.setRotationSmooth({0,90,0},false,true)
                blockPosition.x = blockPosition.x+difference
            end
        end
    end
end

function onObjectEnterScriptingZone(zone, obj)
    if zone.getGUID() == _sz then
        if obj.tag == "Dice" then
            if obj.getDescription() == "" then
                obj.setDescription("0")
                
            end
            
            color = obj.getColorTint()
            if getSides(obj) == 20 then
                local takeParams = {
                    position = _blockPosition,
                    rotation = {0.00, 90.00, 0.00},
                    callback_function = function(block) takeBlock(block, obj.getName(), color, obj) end,
                }
                getObjectFromGUID(_blockBag).takeObject(takeParams)
                
            end            
        end
        
    end
end

function onObjectLeaveScriptingZone(zone, obj)
    if zone.getGUID() == _sz then        
        if dices[obj.getGUID()] then
            getObjectFromGUID(dices[obj.getGUID()]).destruct()
            dices[obj.getGUID()] = nil
            orderBlocks()
        end
    end
    
end

function onObjectRandomize(obj, color)
    if color == _color then
        if dices[obj.getGUID()] then
            --getObjectFromGUID(dices[obj.getGUID()]).call("updateValue")
            local block = getObjectFromGUID(dices[obj.getGUID()])
            local rollWatch = function() return obj.resting end
            local rollEnd = function() 
                block.editInput({index=1, value = obj.getRotationValue()})
                block.call("updateResult", nil)
            end
            Wait.condition(rollEnd, rollWatch)
        end
    end
end

function roll_all()
    local zone = getObjectFromGUID(_sz)
    local objs = zone.getObjects()
    for i=0, #objs do
        local obj = objs[i]
        if obj then
            if obj.getName() == _blockName then
                obj.call("roll_die")
            end
        end
    end
end

function edit_mods(obj, color, _input, stillEditing)
    if not stillEditing then
        local zone = getObjectFromGUID(_sz)
        local objs = zone.getObjects()
        for i=0, #objs do
            local obj = objs[i]
            if obj then
                if obj.getName() == _blockName then
                    obj.call("updateModifier", {input=_input})
                end
            end
        end
    end
end