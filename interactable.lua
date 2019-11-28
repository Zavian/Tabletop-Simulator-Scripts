local func_f = "function onLoad()\r\n    self.interactable = false\r\n    -searchable\r\nend"
local func_t = "function onLoad()\r\n    self.interactable = true\r\n    -searchable\r\nend"

function onLoad(save_state)
    self.createButton(
        {
            click_function = "make_interact",
            function_owner = self,
            label = "Make Interactable",
            position = {0, 0.5, 0.8},
            scale = {0.5, 0.5, 0.5},
            width = 3300,
            height = 600,
            font_size = 400,
            color = {0.192, 0.701, 0.168, 1}
        }
    )

    self.createButton(
        {
            click_function = "make_not_interact",
            function_owner = self,
            label = "Make Non-Interactable",
            position = {0, 0.5, 1.6},
            scale = {0.5, 0.5, 0.5},
            width = 4200,
            height = 600,
            font_size = 400,
            color = {0.856, 0.1, 0.094, 1}
        }
    )
end



function isMe(id)
    return id == self.getGUID()
end

function make_interact(obj, player_clicker_color, alt_click)
    local id = self.getDescription()
    if player_clicker_color == "Black" and not isMe(id) then
        local id = self.getDescription()
        if id == "" then
            return
        end
        local obj = getObjectFromGUID(id)
        obj.interactable = true
        obj.setLuaScript(func_t)
        self.setDescription("")
        Player[player_clicker_color].pingTable(getObjectFromGUID(id).getPosition())
    end
end

function make_not_interact(obj, player_clicker_color, alt_click)
    if player_clicker_color == "Black" and not isMe(id) then
        local id = self.getDescription()
        if id == "" then
            return
        end
        local obj = getObjectFromGUID(id)
        obj.interactable = false
        obj.setLock(true)
        obj.setLuaScript(func_f)
        self.setDescription("")
        Player[player_clicker_color].pingTable(getObjectFromGUID(id).getPosition())
    end
end
