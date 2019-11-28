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
end

function none()
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
