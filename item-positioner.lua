local _objs = {
    ["d645e1"] = {pos = {5.52, 10.47, 8.68}, start = {}, moved = false},
    ["3d7a9b"] = {pos = {9.84, 10.47, 14.15}, start = {}, moved = false},
    ["62b14e"] = {pos = {11.66, 10.47, 6.45}, start = {}, moved = false},
    ["989b93"] = {pos = {5.49, 10.47, -3.39}, start = {}, moved = false},
    ["53caf9"] = {pos = {9.90, 10.47, -8.87}, start = {}, moved = false},
    ["2c0d91"] = {pos = {11.68, 10.47, -1.18}, start = {}, moved = false},
    ["9462fd"] = {pos = {14.96, 10.47, 2.68}, start = {}, moved = false},
    ["016301"] = {pos = {1.95, 10.47, 12.58}, start = {}, moved = false},
    ["7b3148"] = {pos = {1.91, 10.47, -7.35}, start = {}, moved = false},
    ["cb43e0"] = {pos = {0.66, 8.61, 5.34}, start = {}, moved = false},
    ["c9d7ee"] = {pos = {0.70, 8.61, -0.09}, start = {}, moved = false},
    ["76e7e6"] = {pos = {-2.44, 7.12, 3.72}, start = {}, moved = false},
    ["4b84cd"] = {pos = {-2.44, 7.12, 1.32}, start = {}, moved = false},
    ["5cd489"] = {pos = {-4.96, 7.12, 0.46}, start = {}, moved = false},
    ["e30a6a"] = {pos = {-4.96, 7.12, 4.55}, start = {}, moved = false}
}

local set = false

function onLoad()
    local buttons = {
        {
            label = "d645e1",
            position = {1.2, 0.2, 0},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "3d7a9b",
            position = {1.5, 0.2, 0.4},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "62b14e",
            position = {0.9, 0.2, 0.8},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "989b93",
            position = {-1.2, 0.2, 0},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "53caf9",
            position = {-1.5, 0.2, 0.4},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "2c0d91",
            position = {-0.9, 0.2, 0.8},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "9462fd",
            position = {0, 0.2, 1.2},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "016301",
            position = {1.4, 0.2, -0.4},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "7b3148",
            position = {-1.4, 0.2, -0.4},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 200
        },
        {
            label = "cb43e0",
            position = {0.25, 0.2, -0.7},
            scale = {0.5, 0.5, 0.5},
            width = 450,
            height = 200
        },
        {
            label = "c9d7ee",
            position = {-0.25, 0.2, -0.7},
            scale = {0.5, 0.5, 0.5},
            width = 450,
            height = 200
        },
        {
            label = "76e7e6",
            position = {0.35, 0.2, -1.1},
            scale = {0.5, 0.5, 0.5},
            width = 450,
            height = 200
        },
        {
            label = "4b84cd",
            position = {-0.35, 0.2, -1.1},
            scale = {0.5, 0.5, 0.5},
            width = 450,
            height = 200
        },
        {
            label = "5cd489",
            position = {-0.4, 0.2, -1.3},
            scale = {0.5, 0.5, 0.5},
            width = 450,
            height = 200
        },
        {
            label = "e30a6a",
            position = {0.4, 0.2, -1.3},
            scale = {0.5, 0.5, 0.5},
            width = 450,
            height = 200
        }
    }
    for i = 1, #buttons do
        local funcName = "button_" .. i
        local func = function(_, c)
            button_click(c, buttons[i].label)
        end
        self.setVar(funcName, func)
        self.createButton(
            {
                click_function = funcName,
                function_owner = self,
                label = buttons[i].label,
                position = buttons[i].position,
                scale = {0.5, 0.5, 0.5},
                width = buttons[i].width,
                height = buttons[i].height
            }
        )
    end

    self.createButton(
        {
            click_function = "interactable",
            function_owner = self,
            label = "Interactable",
            position = {0, 0.2, -0.2},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 300
        }
    )
    self.createButton(
        {
            click_function = "setup",
            function_owner = self,
            label = "Setup",
            position = {0, 0.2, 0.1},
            scale = {0.5, 0.5, 0.5},
            width = 650,
            height = 300
        }
    )
end

function button_click(color, guid)
    if not set then
        notSet()
        return
    end

    local o = getObjectFromGUID(guid)
    local obj = _objs[guid]
    if (obj) then
        if not obj.moved then
            o.setPositionSmooth(obj.pos, false, false)
            obj.moved = true
        else
            o.setPositionSmooth(obj.start, false, false)
            obj.moved = false
        end
    end
end

function notSet()
    broadcastToColor("Need to set the thing", "Black", {r = 1, g = 1, b = 1})
end

function setup()
    for guid, a in pairs(_objs) do
        local obj = getObjectFromGUID(guid)
        _objs[guid].start = obj.getPosition()
    end

    set = true
end

function interactable()
    if not set then
        notSet()
        return
    end
    for guid, a in pairs(_objs) do
        local obj = getObjectFromGUID(guid)
        obj.interactable = not obj.interactable
    end
end
