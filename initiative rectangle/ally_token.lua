disableSave = false
buttonFontColor = {0, 0, 0}
buttonColor = {0.72, 0.92, 0.58}
buttonScale = {1, 1, 1}
defaultButtonData = {
    textbox = {
        {
            pos = {-0.85, 0.1, 0.0},
            rows = 2,
            width = 2600,
            font_size = 330,
            label = "Ally",
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
