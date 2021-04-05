--[[
    Codebase for exploding dice
    Workshop link: steam://url/CommunityFilePage/2446979212
]] --

urls = {
    [0] = "",
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = "",
    [5] = ""
}

function onload()
    local dice = {"d4", "d6", "d8", "d10", "d12", "d20"}

    local posX,
        posY,
        posZ,
        increment
    posY = -0.9
    posX = -2
    posZ = 7.4
    increment = -2

    for i = 1, #dice do
        local input = {}

        input.function_owner = self
        input.label = dice[i]
        input.tooltip = dice[i] .. " url"
        input.input_function = "none"
        input.position = {posX, posY, posZ}
        input.rotation = {0, 180, 180}
        input.scale = {2, 2, 2}
        input.width = 3200
        input.height = 400
        input.font_size = 150
        input.font_color = Color.Black
        input.tab = 2

        self.createInput(input)
        posZ = posZ + increment
    end

    posX = 6
    posZ = 7.4
    for i = 1, #dice do
        local button = {}

        button.function_owner = self
        button.click_function = "submit" .. dice[i]
        button.label = "Submit"
        button.tooltip = dice[i]
        button.position = {posX, posY, posZ}
        button.rotation = {0, 180, 180}
        button.scale = {2, 2, 2}
        button.width = 800
        button.height = 420
        button.font_size = 200
        button.color = {0.5921, 0.9764, 0.5725, 1}

        self.createButton(button)
        posZ = posZ + increment
    end

    self.createButton(
        {
            click_function = "bundle",
            function_owner = self,
            label = "Bundle",
            position = {0, -0.9, -6.6},
            rotation = {0, 180, 180},
            scale = {2, 2, 2},
            width = 800,
            height = 420,
            font_size = 200,
            color = {0.5921, 0.9764, 0.5725, 1},
            tooltip = "Bundle"
        }
    )
end

function onCollisionEnter(info)
    if info then
        local obj = info.collision_object
        if obj then
            if obj.type == "Dice" then
                local sides = #obj.getRotationValues()
                local customData = obj.getCustomObject()
                broadcastToAll("Found a new die of " .. sides .. " sides", Color.Green)
                local input = findSubmit(sides)
                if input >= 0 then
                    self.editInput({index = input - 1, value = customData.image})
                    urls[input - 1] = customData.image
                    broadcastToAll("Pasted image in d" .. sides, Color.Green)
                else
                    broadcastToAll("I don't recognize this item...", Color.Red)
                end
            end
        end
    end
end

function none()
end

function findSubmit(dice)
    if dice == 4 then
        return 1
    elseif dice == 6 then
        return 2
    elseif dice == 8 then
        return 3
    elseif dice == 10 then
        return 4
    elseif dice == 12 then
        return 5
    elseif dice == 20 then
        return 6
    else
        return -1
    end
end

function submitd4()
    local input = self.getInputs()[1].value
    input = input:gsub("\n", "")
    input = input:gsub(" ", "")
    broadcastToAll("Submitted d4", Color.Green)
    urls[0] = input
end

function submitd6()
    local input = self.getInputs()[2].value
    input = input:gsub("\n", "")
    input = input:gsub(" ", "")
    broadcastToAll("Submitted d6", Color.Green)
    urls[1] = input
end

function submitd8()
    local input = self.getInputs()[3].value
    input = input:gsub("\n", "")
    input = input:gsub(" ", "")
    broadcastToAll("Submitted d8", Color.Green)
    urls[2] = input
end

function submitd10()
    local input = self.getInputs()[4].value
    input = input:gsub("\n", "")
    input = input:gsub(" ", "")
    broadcastToAll("Submitted d10", Color.Green)
    urls[3] = input
end

function submitd12()
    local input = self.getInputs()[5].value
    input = input:gsub("\n", "")
    input = input:gsub(" ", "")
    broadcastToAll("Submitted d12", Color.Green)
    urls[4] = input
end

function submitd20()
    local input = self.getInputs()[6].value
    input = input:gsub("\n", "")
    input = input:gsub(" ", "")
    broadcastToAll("Submitted d20", Color.Green)
    urls[5] = input
end

function valid()
    return urls[0] ~= "" and urls[1] ~= "" and urls[2] ~= "" and urls[3] ~= "" and urls[4] ~= "" and urls[5] ~= ""
end

function bundle()
    if not valid() then
        broadcastToAll("You must submit all buttons!!!", Color.White)
    else
        local master = getObjectFromGUID("ff0e40")
        local script = master.getLuaScript()
        local spawnPos = {x = 11.00, y = 3, z = 5.00}
        local increment = -2

        local maker =
            "ref_diceCustom = {\n" ..
            '[4] = "' ..
                urls[0] ..
                    '",\n' ..
                        '[6] = "' ..
                            urls[1] ..
                                '",\n' ..
                                    '[8] = "' ..
                                        urls[2] ..
                                            '",\n' ..
                                                '[10] = "' ..
                                                    urls[3] ..
                                                        '",\n' ..
                                                            '[12] = "' ..
                                                                urls[4] ..
                                                                    '",\n' .. '[20] = "' .. urls[5] .. '"\n' .. "}\n"

        script = maker .. script

        local dice = {}
        for key, url in pairs(urls) do
            print(url)
            spawnObject(
                {
                    type = "Custom_Dice",
                    position = {spawnPos.x, spawnPos.y, spawnPos.z},
                    rotation = {0, 0, 0},
                    scale = {1, 1, 1},
                    callback_function = function(spawned)
                        spawned.setCustomObject(
                            {
                                image = url,
                                type = key
                            }
                        )
                        spawned.setLuaScript(script)
                        spawned.setGMNotes(master.getGMNotes())
                        table.insert(dice, spawned.guid)

                        spawned.reload()
                    end
                }
            )
            spawnPos.z = spawnPos.z + increment
        end

        local bagPos = {15.99, 3, -0.06}
        log(dice)
        Wait.time(
            function()
                spawnObject(
                    {
                        type = "Bag",
                        position = bagPos,
                        rotation = {0, 0, 0},
                        scale = {1, 1, 1},
                        callback_function = function(bag)
                            for i = 1, #dice do
                                local d = getObjectFromGUID(dice[i])
                                Wait.time(
                                    function()
                                        d.setPositionSmooth(
                                            {x = bagPos[1], y = bagPos[2] + 3, z = bagPos[3]},
                                            false,
                                            false
                                        )
                                    end,
                                    i - 0.5
                                )
                            end
                        end
                    }
                )
            end,
            2
        )
    end
end
