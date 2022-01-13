function onLoad()
    local button = {
        click_function = "emptyContainer",
        function_owner = self,
        label = "Click",
        position = {0, 0.6, 0},
        scale = {0.5, 0.5, 0.5},
        width = 2000,
        height = 400,
        font_size = 400
    }
end

function emptyContainer()
    local gm = self.getGMNotes()

    local obj = getObjectFromGUID(gm)
    print(obj)
    if not obj then
        print("Could not find object with GUID: " .. gm)
        return
    end

    local objects = obj.getObjects()
    print("Found " .. #objects .. " objects in container")

    --for _, v in ipairs(objects) do
    --    v.destruct()
    --end
end
