function onLoad()
    self.createButton(
        {
            click_function = "work_macro",
            function_owner = self,
            label = "Activate Macro",
            position = {0, 0.5, 0.8},
            scale = {0.5, 0.5, 0.5},
            width = 3300,
            height = 600,
            font_size = 400,
            color = {0.2026, 0.4071, 0.9773, 1}
        }
    )
end

function none()
end

function onCollisionEnter(info)
    if info.collision_object.interactable then
        local id = info.collision_object.getGUID()
        local gm = self.getGMNotes()
        local macro = JSON.decode(gm)
        macro.obj = id
        self.setGMNotes(JSON.encode(macro))
    end
end

function onHover(player_color)
    if player_color == "Black" then
        local gm = self.getGMNotes()
        if gm == "" or gm == nil then
            self.setGMNotes(
                [[{
    "obj":"aaaaaa",
    "position":[999,999,999],
    "rotation":[999,999,999],
    "interact": true,
    "lock": true,
    "visible": true
}]]
            )
            self.highlightOn(Color.Green, 1)
        end
    end
end

function work_macro()
    -- position
    -- make interactable
    -- make visible
    --[[
        {
            "obj":"aaaaaa",
            "position":[1,1,1],
            "rotation":[1,1,1],
            "interact": true,
            "lock": true,
            "visible": true
        }
    ]]
    -- with position = 999 then the token will take relative position
    local gm = self.getGMNotes()
    if gm then
        local macro = JSON.decode(gm)

        local obj = getObjectFromGUID(macro.obj)
        local pos,
            rot,
            interact
        if exists(macro.position) ~= nil then
            pos = {
                x = correctPositionCoordinate("x", macro.position[1], obj),
                y = correctPositionCoordinate("y", macro.position[2], obj),
                z = correctPositionCoordinate("z", macro.position[3], obj)
            }
            obj.setPosition(pos)
        end
        if exists(macro.rotation) then
            rot = {
                x = correctRotationCoordinate("x", macro.rotation[1], obj),
                y = correctRotationCoordinate("y", macro.rotation[2], obj),
                z = correctRotationCoordinate("z", macro.rotation[3], obj)
            }
            obj.setRotation(rot)
        end
        if exists(macro.interact) then
            interact = macro.interact
            if exists(macro.lock) then
                toggle_interact(obj, interact, macro.lock)
            else
                toggle_interact(obj, interact, true)
            end
        end

        if exists(macro.visible) then
            if macro.visible then
                obj.setColorTint({r = 1, g = 1, b = 1, a = 1})
            else
                obj.setColorTint({r = 1, g = 1, b = 1, a = 0})
            end
        end
    end
end

function correctPositionCoordinate(xyz, coord, obj)
    if coord == 999 then
        return obj.getPosition()[xyz]
    else
        return coord
    end
end

function correctRotationCoordinate(xyz, coord, obj)
    if coord == 999 then
        return obj.getRotation()[xyz]
    else
        return coord
    end
end

function exists(variable)
    return variable ~= nil
end

function toggle_interact(o, interact, lock)
    o.interactable = interact
    o.setLock(lock)
    local code = "function onload() self.interactable = " .. tostring(interact) .. " end"
    o.setLuaScript(code)
end
