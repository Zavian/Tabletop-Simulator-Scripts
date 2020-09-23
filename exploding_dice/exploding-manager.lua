function onLoad()
    self.createButton(
        {
            click_function = "calculateTotal",
            function_owner = self,
            label = "TOT",
            position = {0, 2.5, -0.37},
            rotation = {0, 180, 0},
            scale = {0.3, 0.5, 0.5},
            width = 350,
            height = 300,
            color = {0, 0, 0, 1},
            font_color = {1, 1, 1, 1},
            tooltip = "Total"
        }
    )
    self.createButton(
        {
            click_function = "clearDice",
            function_owner = self,
            label = "X",
            position = {-0.46, 2.5, 0.44},
            rotation = {0.00, 180.00, 0.00},
            scale = {0.5, 0.5, 0.5},
            width = 65,
            height = 100,
            font_size = 50,
            color = {0, 0, 0, 1},
            font_color = {1, 0, 0, 1},
            tooltip = "Clear Dice"
        }
    )

    self.createButton(
        {
            click_function = "clearTotal",
            function_owner = self,
            label = "Clear Total",
            position = {-0.36, 2.5, 0.439999997615814},
            rotation = {0, 180, 0},
            scale = {0.2, 0.5, 0.3},
            width = 315,
            height = 185,
            font_size = 50,
            color = {0, 0, 0, 1},
            font_color = {1, 0, 0, 1},
            tooltip = ""
        }
    )
end

function calculateTotal()
    local desc = self.getDescription()
    if desc ~= "" then
        local numbers = mysplit(desc, ", ")
        local tot = 0
        for i = 1, #numbers do
            tot = tot + numbers[i]
        end
        self.editButton({index = 0, label = tot})
    end
end

function clearDice()
    local desc = self.getGMNotes()
    if desc ~= "" then
        local objs = mysplit(desc, ",")
        for i = 1, #objs do
            local o = getObjectFromGUID(objs[i])
            o.destruct()
        end
        self.setGMNotes("")
    end
end

function clearTotal()
    self.setDescription("")
    local oldTot = self.getButtons()[1].label

    self.editButton({index = 0, label = "TOT"})
    self.editButton({index = 2, tooltip = "Old Total: " .. oldTot})
end

function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
