disableSave = false
buttonFontColor = {0, 0, 0}
buttonColor = {0.97, 0.72, 0.68}
buttonScale = {1, 1, 1}

--local _seeingToken = false

local myToken = nil

defaultButtonData = {
    textbox = {
        {
            pos = {-0.85, 0.1, 0.0},
            rows = 2,
            width = 2600,
            font_size = 330,
            label = "Enemy",
            value = "",
            alignment = 3
        }
    }
}
function updateSave()
    saved_data = JSON.encode(ref_buttonData)
    if disableSave == true then
        saved_data = ""
    end
    self.script_state = saved_data
end
function onload(saved_data)
    if disableSave == true then
        saved_data = ""
    end
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        ref_buttonData = loaded_data
    else
        ref_buttonData = defaultButtonData
    end

    self.createButton(
        {
            click_function = "find_token",
            function_owner = self,
            label = " ",
            position = {2.5, 0.1, 0},
            scale = {0.6, 0.6, 0.6},
            width = 600,
            height = 600,
            font_size = 0,
            color = {0.25, 0.25, 0.25, 1},
            tooltip = "Find Token",
            alignment = 3
        }
    )

    spawnedButtonCount = 0
    createTextbox()
end
function click_textbox(i, value, selected)
    if selected == false then
        ref_buttonData.textbox[i].value = value
        updateSave()
    end
end
function click_none()
end
function createTextbox()
    for i, data in ipairs(ref_buttonData.textbox) do
        local funcName = "textbox" .. i
        local func = function(_, _, val, sel)
            click_textbox(i, val, sel)
        end
        self.setVar(funcName, func)

        self.createInput(
            {
                input_function = funcName,
                function_owner = self,
                label = data.label,
                alignment = data.alignment,
                position = data.pos,
                scale = buttonScale,
                width = data.width,
                height = (data.font_size * data.rows) + 24,
                font_size = data.font_size,
                color = buttonColor,
                font_color = buttonFontColor,
                value = data.value
            }
        )
    end
end

function find_token(obj, color)
    if not myToken then
        return
    end
    Player[color].pingTable(myToken.getPosition())

    myToken.call("toggleVisualize", {input = true})
end

function setToken(params)
    myToken = getObjectFromGUID(params.input)
end
