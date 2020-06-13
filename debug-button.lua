local _stuffs = {
    {obj = "28f96e", bag = "e1e28a"},
    {obj = "1d7e9d", bag = "627199"},
    {obj = "b81df8", bag = "de97c2"}
}

function onLoad()
    self.setRotation({0.00, 0.00, 0.00})
    self.createButton(
        {
            click_function = "store_stuff",
            function_owner = self,
            label = "Store Stuff",
            position = {0, 3, 0},
            rotation = {0, 180, 0},
            scale = {0.9, 1.2, 0.9},
            width = 1600,
            height = 450,
            font_size = 320
        }
    )
    store_stuff()
end

function store_stuff()
    for i = 1, #_stuffs do
        local o = getObjectFromGUID(_stuffs[i].obj)
        local put = o.clone()
        local b = getObjectFromGUID(_stuffs[i].bag)
        b.reset()
        local waiter = function()
            return put.resting
        end
        local waited = function()
            local pos = b.getPosition()
            pos.y = pos.y + 2
            put.setPositionSmooth(pos, false, true)
        end
        Wait.condition(waited, waiter)
    end
end
