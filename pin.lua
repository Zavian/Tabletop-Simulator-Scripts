function onLoad(save_state)
    local desc = self.getDescription()
    local label = ""
    if desc ~= "" then
        label = desc
    end

    --self.createButton(
    --    {
    --        click_function = "none",
    --        function_owner = self,
    --        label = label,
    --        position = {0, 0, 1},
    --        rotation = {-90, 0, 0},
    --        scale = {0.5, 0.5, 0.5},
    --        width = 2000,
    --        height = 900,
    --        font_size = 250,
    --        alignment = 3
    --    }
    --)

    self.UI.setAttribute("txt", "text", label)
    if label == "" then
        self.UI.setAttribute("bg", "color", "#ffffff00")
    else
        self.UI.setAttribute("bg", "color", "#ffffffaa")
        if hasSecondLine(label) then
            self.UI.setAttribute("bg", "height", "60")
        else
            self.UI.setAttribute("bg", "height", "30")
        end
    end

    self.addContextMenuItem("Aquila", aquila)
    self.addContextMenuItem("Ekehm", ekehm)
    self.addContextMenuItem("Mourning Lands", ml)
    self.addContextMenuItem("Oshil", oshil)
    self.addContextMenuItem("Trisen", trisen)
    self.addContextMenuItem("Zunirth", zunirth)
end

function none()
end

function aquila()
    self.setColorTint({r = 27 / 255, g = 80 / 255, b = 140 / 255})
end

function trisen()
    self.setColorTint({r = 176 / 255, g = 58 / 255, b = 0 / 255})
end

function oshil()
    self.setColorTint({r = 155 / 255, g = 21 / 255, b = 19 / 255})
end

function zunirth()
    self.setColorTint({r = 138 / 255, g = 185 / 255, b = 14 / 255})
end

function ml()
    self.setColorTint({r = 130 / 255, g = 61 / 255, b = 163 / 255})
end

function ekehm()
    self.setColorTint({r = 119 / 255, g = 146 / 255, b = 44 / 255})
end

local lineHeight = 30
local offset = 10
function onObjectPickUp(player_color, picked_up_object)
    if picked_up_object.getGUID() == self.getGUID() then
        --self.editButton(
        --    {
        --        index = 0,
        --        label = self.getDescription()
        --    }
        --)
        local label = self.getDescription()
        self.UI.setAttribute("txt", "text", label)
        if label == "" then
            self.UI.setAttribute("bg", "color", "#ffffff00")
        else
            self.UI.setAttribute("bg", "color", "#ffffffaa")
            if hasSecondLine(label) then
                self.UI.setAttribute("bg", "height", tostring(lineHeight * 2))
            else
                self.UI.setAttribute("bg", "height", tostring(lineHeight))
            end
        end
    end
end

function hasSecondLine(txt)
    return string.find(txt, "\n") ~= nil
end
