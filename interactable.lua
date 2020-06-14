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

function onCollisionEnter(info)
    local id = info.collision_object.getGUID()
    self.setDescription("Found: " .. id)
end

function make_interact(obj, player_clicker_color, alt_click)
    local id = self.getDescription()
    if Player[player_clicker_color].admin and not isMe(id) then
        local id = self.getDescription()
        if id == "" then
            return
        end
        local o = getObjectFromGUID(id)

        o.interactable = true
        self.setDescription("")
        Player[player_clicker_color].pingTable(getObjectFromGUID(id).getPosition())

        local code = "function onload() self.interactable = true end"
        o.setLuaScript(code)
    end
end

function make_not_interact(obj, player_clicker_color, alt_click)
    if Player[player_clicker_color].admin and not isMe(id) then
        local id = self.getDescription()
        if id == "" then
            return
        end
        local o = getObjectFromGUID(id)
        o.interactable = false
        o.setLock(true)
        self.setDescription("")
        Player[player_clicker_color].pingTable(getObjectFromGUID(id).getPosition())

        local code = "function onload() self.interactable = false end"
        o.setLuaScript(code)
    end
end
