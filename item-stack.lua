function onLoad()
    self.createButton(
        {
            click_function = "stack",
            function_owner = self,
            label = " ",
            position = {0, 0.1, 0},
            scale = {0.5, 0.5, 0.5},
            width = 750,
            height = 750,
            font_size = 400,
            color = {0.5, 0.5, 0.5, 1},
            tooltip = "Stack buttons"
        }
    )

    self.setGMNotes("")
end

function onCollisionEnter(info)
    if info then
        local obj = info.collision_object
        if obj then
            if obj.interactable then
                if obj.getGUID() then
                    local returner = {}
                    local gm = self.getGMNotes()
                    local json = JSON.decode(gm)
                    if json then
                        returner = json
                    end

                    table.insert(returner, obj.getGUID())
                    self.setGMNotes(JSON.encode(returner))
                end
            end
        end
    end
end

-- function onObjectCollisionEnter(hit_object, collision_info)
--     -- collision_info table:
--     --   collision_object    Object
--     --   contact_points      Table     {Vector, ...}
--     --   relative_velocity   Vector

--     local returner = {}
--     local gm = self.getGMNotes()
--     local json = JSON.decode(gm)
--     if #json > 0 then
--         returner = json
--     end

--     if hit_object.interactable then
--         local id = hit_object.getGUID()
--         table.insert(returner, id)
--         self.setGMNotes(JSON.encode(returner))
--     end
-- end

function stack()
    local gm = self.getGMNotes()
    local objs = JSON.decode(gm)

    local pos = self.getPosition()
    local rot = self.getRotation()

    pos.x = pos.x - 7
    pos.y = pos.y + 10

    for i, obj in ipairs(objs) do
        local o = getObjectFromGUID(obj)
        if o then
            Wait.time(
                function()
                    o.setPosition(pos)
                    o.setRotation({0, 0, 0})
                end,
                0.2 * i
            )
        end
    end
    self.setGMNotes("")
end
