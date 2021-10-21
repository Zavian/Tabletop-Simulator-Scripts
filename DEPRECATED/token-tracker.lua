-- textbox = {
--             --[[
--             pos       = the position (pasted from the helper tool)
--             rows      = how many lines of text you want for this box
--             width     = how wide the text box is
--             font_size = size of text. This and "rows" effect overall height
--             label     = what is shown when there is no text. "" = nothing
--             value     = text entered into box. "" = nothing
--             alignment = Number to indicate how you want text aligned
--                         (1=Automatic, 2=Left, 3=Center, 4=Right, 5=Justified)
--             ]]
local _color = {1, 1, 1, 0.3}
local _tracker_name = "npc_tracker"

function onLoad()
    -- name
    self.createInput(
        {
            input_function = "none",
            function_owner = self,
            label = "Name",
            position = {0.6, 0.1, -0.6},
            scale = {0.6, 0.6, 0.7},
            width = 3000,
            height = 470,
            font_size = 400,
            color = {1, 1, 1, 0},
            font_color = {1, 1, 1, 100},
            alignment = 3,
            value = ""
        }
    )

    -- hp
    self.createInput(
        {
            input_function = "hp",
            function_owner = self,
            label = "HP",
            position = {-1.63, 0.1, 0.7},
            scale = {0.8, 0.5, 0.9},
            width = 500,
            height = 440,
            font_size = 400,
            color = _color,
            font_color = {0, 0, 0, 100},
            alignment = 3,
            value = ""
        }
    )

    -- ac
    self.createInput(
        {
            input_function = "ac",
            function_owner = self,
            label = "AC",
            position = {-0.43, 0.1, 0.7},
            scale = {0.8, 0.5, 0.9},
            width = 500,
            height = 440,
            font_size = 400,
            color = _color,
            font_color = {0, 0, 0, 100},
            alignment = 3,
            value = ""
        }
    )

    -- atk
    self.createInput(
        {
            input_function = "atk",
            function_owner = self,
            label = "ATK",
            position = {0.77, 0.1, 0.7},
            scale = {0.8, 0.5, 0.9},
            width = 500,
            height = 440,
            font_size = 150,
            color = _color,
            font_color = {0, 0, 0, 100},
            alignment = 3,
            value = ""
        }
    )

    self.createInput(
        {
            input_function = "dmg",
            function_owner = self,
            label = "DMG",
            position = {1.97, 0.1, 0.7},
            scale = {0.8, 0.5, 0.9},
            width = 500,
            height = 440,
            font_size = 150,
            color = _color,
            font_color = {0, 0, 0, 100},
            alignment = 3,
            value = ""
        }
    )

    self.createButton(
        {
            click_function = "none",
            function_owner = self,
            label = " ",
            position = {-1.9, 0.1, -0.62},
            scale = {0.5, 0.5, 0.5},
            width = 600,
            height = 600,
            font_size = 400
        }
    )
end

function none()
end

function hp(self, color, text, stillEditing)
    if not stillEditing then
        local size = convertSize(text)
        self.editInput({index = 1, font_size = size})
    end
end

function ac(self, color, text, stillEditing)
    if not stillEditing then
        local size = convertSize(text)
        self.editInput({index = 2, font_size = size})
    end
end

function atk(self, color, text, stillEditing)
    if not stillEditing then
        local size = convertSize(text)
        self.editInput({index = 3, font_size = size})
    end
end

function dmg(self, color, text, stillEditing)
    if not stillEditing then
        local size = convertSize(text)
        self.editInput({index = 4, font_size = size})
    end
end

function convertSize(input)
    if string.len(input) <= 2 then
        return 400
    elseif string.len(input) == 3 then
        return 300
    else
        return 150
    end
end

function setName(params)
    self.editInput({index = 0, value = params.input})
end

function setHP(params)
    self.editInput({index = 1, value = params.input})
    local size = convertSize(params.input)
    self.editInput({index = 1, font_size = size})
end
function setAC(params)
    self.editInput({index = 2, value = params.input})
    local size = convertSize(params.input)
    self.editInput({index = 2, font_size = size})
end
function setATK(params)
    self.editInput({index = 3, value = params.input})
    local size = convertSize(params.input)
    self.editInput({index = 3, font_size = size})
end
function setDMG(params)
    self.editInput({index = 4, value = params.input})
    local size = convertSize(params.input)
    self.editInput({index = 4, font_size = size})
end

function setColor(params)
    self.editButton({index = 0, color = params.input})
end

function order(params)
    local blockPosition = {x = 42.83, y = 1.5, z = -2.77}
    local zone = getObjectFromGUID(params.input)
    local objs = zone.getObjects()
    local x_diffence = 2.16
    local z_difference = 4.87
    local row = 1
    for i = 0, #objs do
        local obj = objs[i]
        if obj then
            if obj.getName() == _tracker_name then
                obj.setPositionSmooth(blockPosition, false, true)
                obj.setRotationSmooth({0, 90, 0}, false, true)
                if row == 1 then
                    blockPosition.x = blockPosition.x + x_diffence
                    row = row + 1
                elseif row == 2 then
                    row = 1
                    blockPosition.x = 42.83
                    blockPosition.z = blockPosition.z + z_difference
                end
            end
        end
    end
end

--function mysplit(inputstr, sep)
--    if sep == nil then
--            sep = "%s"
--    end
--    local t={} ; i=1
--    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--            t[i] = str
--            i = i + 1
--    end
--    return t
--end
--
--function getHP(text)
--    local spl = mysplit(text, "\n")[1]
--    return mysplit(spl, " ")[2]
--end
--
--function getAC(text)
--    local spl = mysplit(text, "\n")[2]
--    return mysplit(spl, " ")[2]
--end
--function getATK(text)
--    local spl = mysplit(text, "\n")[3]
--    return mysplit(spl, " ")[2]
--end
--function getDMG(text)
--    local spl = mysplit(text, "\n")[4]
--    return mysplit(spl, " ")[2]
--end
