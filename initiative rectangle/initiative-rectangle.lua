local myToken = nil
local myData = nil
local mySide = nil
local initialized = false
local restored = false

local _states = {
    ["player"] = {color = {0, 0, 0.545098}},
    ["enemy"] = {color = {0.517647, 0, 0.098039}},
    ["ally"] = {color = {0.039216, 0.368627, 0.211765}},
    ["neutral"] = {color = {0.764706, 0.560784, 0}}
}

function click_textbox(obj, color, input, stillEditing)
    if stillEditing == false then
        updateSave(input)
    end
end

function find_token(obj, color)
    if not myToken then
        return
    end
    --Player[color].pingTable(myToken.getPosition())
    myToken.call("toggleVisualize", {input = true, color = color})
end

local textbox = {
    input_function = "click_textbox",
    function_owner = self,
    label = "Name",
    position = {-1.2, 0.1, 0},
    scale = {1.4, 0.5, 1.4},
    width = 2300,
    height = 700,
    font_size = 300,
    alignment = 3,
    custom = {
        color = 0,
        0,
        0.545098
    }
}

function onLoad(save_state)
    local value = ""
    myData = JSON.decode(save_state)
    if myData ~= nil then
        value = myData.v
        myToken = getObjectFromGUID(myData.t)
        if myData.c == nil then
            myData.c = {0, 0, 0.545098}
        end
        textbox.custom.color = myData.c
    end
    self.createInput(
        {
            input_function = "click_textbox",
            function_owner = textbox.function_owner,
            label = textbox.label,
            position = textbox.position,
            scale = textbox.scale,
            width = textbox.width,
            height = textbox.height,
            font_size = textbox.font_size,
            alignment = textbox.alignment,
            value = value
        }
    )

    self.createButton(
        {
            click_function = "find_token",
            function_owner = self,
            label = " ",
            position = {3.3, 0.2, 0},
            scale = {0.6, 0.6, 0.6},
            width = 680,
            height = 680,
            font_size = 0,
            color = {0.25, 0.25, 0.25, 1},
            tooltip = " ",
            alignment = 3
        }
    )

    self.setColorTint(textbox.custom.color)
end

function onObjectDestroy(destroyedObj)
    if myToken then
        local gid = destroyedObj.getGUID()
        local mgid = myToken.getGUID()
        if destroyedObj == myToken then
            self.destruct()
        end
    end
end

function _init(params)
    --initiative.call("_init", {input = {name = name, i = i, pawn = getObjectByID(id).obj.pawn.getGUID(), side = _side}})
    local name = params.input.name
    local i = params.input.i
    local pawn = params.input.pawn
    local side = params.input.side

    self.editInput({index = 0, value = name .. "\n" .. i.value})

    self.setDescription(name .. "\n" .. i.value .. "\n" .. i.initiative .. "+" .. i.modifier .. "\n" .. pawn)
    setToken({input = pawn})
    setSide({side = side})

    updateSave(name .. "\n" .. i.value)
end

function setToken(params)
    myToken = getObjectFromGUID(params.input)
end

function updateSave(value)
    local color = self.getColorTint()
    guid = nil
    if myToken then
        guid = myToken.getGUID()
    end
    myData = {
        v = value,
        t = guid,
        c = {color.r, color.g, color.b}
    }
    JSON.encode(myData)
    self.script_state = saved_data
end

function onSave()
    return JSON.encode(myData)
end

function setSide(params)
    self.setColorTint(_states[params.side].color)
    self.setName(params.side .. "_token")
    self.tooltip = false
end
