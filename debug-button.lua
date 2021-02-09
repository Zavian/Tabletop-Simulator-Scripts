local _stuffs = {
    {obj = "28f96e", bag = "e1e28a"},
    {obj = "1d7e9d", bag = "627199"},
    {obj = "b81df8", bag = "de97c2"}
}

local _snap = nil
local _color = nil

function onLoad()
    self.setRotation({0.00, 0.00, 0.00})
    self.createButton(
        {
            click_function = "store_stuff",
            function_owner = self,
            label = "Store Stuff",
            position = {0, 0.5, 0},
            rotation = {0, 180, 0},
            scale = {0.4, 0.7, 0.4},
            width = 1600,
            height = 450,
            font_size = 320
        }
    )

    local notes = self.getGMNotes()
    local vars = JSON.decode(notes)

    if vars.stuff then
        _stuffs = vars.stuff
    end

    if vars.snap ~= nil then
        _snap = vars.snap
    end

    if vars.color ~= nil then
        _color = hexToRgb(vars.color)
    end

    store_stuff()
end

function store_stuff()
    for i = 1, #_stuffs do
        local o = getObjectFromGUID(_stuffs[i].obj)
        local put =
            o.clone(
            {
                position = {
                    x = o.getPosition().x,
                    y = o.getPosition().y + 3,
                    z = o.getPosition().z
                }
            }
        )
        put.setLock(true)

        local b = getObjectFromGUID(_stuffs[i].bag)

        if _color ~= nil then
            b.setColorTint(_color)
        end

        if _snap ~= nil then
            put.use_grid = _snap
            put.use_snap_points = _snap
        end

        Wait.time(
            function()
                b.reset()
                local waiter = function()
                    return put.resting
                end
                local waited = function()
                    local pos = b.getPosition()
                    pos.y = pos.y + 2
                    put.setLock(false)

                    put.setPositionSmooth(pos, false, true)
                end
                Wait.condition(waited, waiter)
            end,
            1.2
        )
    end
end

function hexToRgb(hex)
    hex = hex:gsub("#", "")
    if #hex < 8 then
        hex = hex .. "ff"
    end
    return color(
        tonumber("0x" .. hex:sub(1, 2), 16) / 255,
        tonumber("0x" .. hex:sub(3, 4), 16) / 255,
        tonumber("0x" .. hex:sub(5, 6), 16) / 255,
        tonumber("0x" .. hex:sub(7, 8), 16) / 255
    )
end
