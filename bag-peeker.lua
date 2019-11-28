local firstItem = ""

function onLoad()
    self.createButton(
        {
            click_function = "none",
            function_owner = self,
            label = firstItem,
            position = {0, 0.6, 2.9},
            scale = {0.7, 0.7, 0.7},
            width = 7200,
            height = 800,
            font_size = 600
        }
    )
    getFirstItem()
end

function none()
end

function onObjectEnterContainer(bag, obj)
    if bag == self then
        getFirstItem()
    end
end

function onObjectLeaveContainer(bag, obj)
    if bag == self then
        getFirstItem()
    end
end

function getFirstItem()
    local objs = self.getObjects()
    if objs then
        if objs[1] then
            firstItem = objs[#objs].name
        else
            firstItem = ""
        end
        self.editButton({index = 0, label = firstItem})
    end
end
