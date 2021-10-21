local _sz = "876993"
local reference = nil

self.createInput({
    input_function = "name",
    function_owner = self,
    label          = "Name",
    alignment      = 3,
    position       = {x=0, y=0.5, z=-0.3},
    rotation       = {0, 0, 0},
    width          = 1600,
    height         = 400,
    font_size      = 200,
    validation     = 1,
    scale          = {0.3, 0.5, 0.4},
})

self.createInput({
    input_function = "value",
    function_owner = self,
    label          = "V",
    alignment      = 3,
    position       = {x=-0.4, y=0.5, z=0.15},
    rotation       = {0, 0, 0},
    width          = 300,
    height         = 300,
    font_size      = 260,
    validation     = 2,
    scale          = {0.3, 0.3, 0.6},
})

self.createInput({
    input_function = "modifier",
    function_owner = self,
    label          = "M",
    alignment      = 3,
    position       = {x=-0.2, y=0.5, z=0.15},
    rotation       = {0, 0, 0},
    width          = 300,
    height         = 300,
    font_size      = 260,
    validation     = 2,
    scale          = {0.3, 0.3, 0.6},
})

self.createInput({
    input_function = "name",
    function_owner = self,
    label          = "R",
    alignment      = 3,
    position       = {x=0.1, y=0.5, z=0.15},
    rotation       = {0, 0, 0},
    width          = 580,
    height         = 300,
    font_size      = 260,
    validation     = 1,
    scale          = {0.3, 0.3, 0.6},
})

self.createButton({
    click_function = "roll_die", 
    function_owner = self, 
    label = "R", 
    position = {0.4, 0.5, 0.15}, 
    scale = {0.3, 0.3, 0.6}, 
    width = 380, 
    height = 300, 
    font_size = 260, 
    tooltip = "R", 
    alignment = 3
})

function modifier(obj, color, input, stillEditing)  
    if not stillEditing then
        local die = findDie()
        if die then
            die.setDescription(input)
        else
            broadcastToColor("delete me pls", "Black", {1,1,1})
        end
        updateResult()
    end
end

function findDie()
    if not reference then
        local name = getTop()
        local zone = getObjectFromGUID(_sz)
        local dices = zone.getObjects()
        for i=0, #dices do
            local die = dices[i]
            if die then
                if die.getName() == name then
                reference = die
                return reference
                end
            end
        end
    end
    return reference
end

function value(obj, color, input, stillEditing)  
    if not stillEditing then
        updateResult()
    end
end

function updateModifier(params)
    self.editInput({index=2, value=params.input})
    updateResult()
end

function updateResult()
    self.editInput({index=3, value="= "..getValue() + getModifier()})
end

function getTop()
    return self.getInputs()[1].value
end
function getValue()
    return tonumber(self.getInputs()[2].value)
end
function getModifier()
    return tonumber(self.getInputs()[3].value)
end
function getResult()
    return tonumber(self.getInputs()[4].value)
end

function name()
end

function roll_die()
    local obj = findDie()
    obj.roll()
    local rollWatch = function() return obj.resting end
    local rollEnd = function() 
        self.editInput({index=1, value = obj.getRotationValue()})
        updateResult() 
    end
    Wait.condition(rollEnd, rollWatch)
end



