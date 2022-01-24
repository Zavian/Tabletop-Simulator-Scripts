--[[StartXML
<Defaults>
    <Button colors="#670007|#382e36|#085d65|#000000" />
    <Button class="todo" textColor="#e8dec5" />
    <Button class="done" textColor="#ff7f27" />
</Defaults>
<VerticalLayout id="PlayerList" childAlignment="UpperCenter" position="-90 -65 -20"  rotation="180 180 0" height="120" width="100" />
StopXML--xml]]


function loadXML()
    local script = self.getLuaScript()
    local xml = script:sub(script:find("StartXML")+8, script:find("StopXML")-1)
    self.UI.setXml(xml)
end

local _difference = 0.754
local _initiativeZone = "6befe7"
local _tokenName = {"player_token", "enemy_token", "ally_token", "neutral_token", "epic_token", "lair_token"}

function updateSave()
    saved_data = JSON.encode(ref_buttonData)
    if disableSave == true then
        saved_data = ""
    end
    self.script_state = saved_data
end

function onload(saved_data)
    loadXML()
    self.interactable = true
    self.createButton(
        {
            click_function = "order_initiative",
            function_owner = self,
            label = "Order",
            position = {x = 0.2, y = 0.1, z = -2.32},
            rotation = {0, 0, 0},
            width = 350,
            height = 100,
            font_size = 100,
            color = {112 / 255, 0, 8 / 255},
            font_color = {232 / 255, 222 / 255, 197 / 255},
            tooltip = "Order Initiative Tokens",
            scale = {x = 0.5, y = 0.1, z = 0.5}
        }
    )
    self.createButton(
        {
            click_function = "request_initiative",
            function_owner = self,
            label = "Take Initiative",
            position = {0.910000026226044, 0.100000001490116, -2.3},
            scale = {0.5, 0.100000001490116, 0.5},
            width = 1070,
            height = 190,
            color = {0.4392, 0, 0.0313, 1},
            font_color = {1, 0.498, 0.1529, 1},
            tooltip = "Take Initiative"
        }
    )

    local notes = self.getGMNotes()
    local vars = JSON.decode(notes)

    if vars["zone"] then
        _initiativeZone = vars["zone"]
    end
end
function click_textbox(i, value, selected)
    if selected == false then
        ref_buttonData.textbox[i].value = value
        updateSave()
    end
end
function click_none()
end
function createTextbox()
    -- for i, data in ipairs(ref_buttonData.textbox) do
    --     local funcName = "textbox" .. i
    --     local func = function(_, _, val, sel)
    --         click_textbox(i, val, sel)
    --     end
    --     self.setVar(funcName, func)
    --     self.createInput(
    --         {
    --             input_function = funcName,
    --             function_owner = self,
    --             label = data.label,
    --             alignment = data.alignment,
    --             position = data.pos,
    --             scale = buttonScale,
    --             width = data.width,
    --             height = (data.font_size * data.rows) + 24,
    --             font_size = data.font_size,
    --             color = buttonColor,
    --             font_color = buttonFontColor,
    --             value = data.value
    --         }
    --     )
    -- end
end

local _initiativeTokens = {}

function request_initiative(obj, color, alt)
    if color == "Black" then
        local zone = getObjectFromGUID(_initiativeZone)
        local objs = zone.getObjects()
        local xml = self.UI.getXmlTable()
        xml[2].children = {}

        local playerButtons = {}
        local players = {}
        for i = 1, #objs do
            local name = objs[i].getName()
            if name == "player_token" then
                local player = objs[i].getDescription()
                table.insert(players, player)
                Global.call("requestPlayer", {p = player, t = objs[i].getGUID(), call = self.getGUID()})
                table.insert(
                    playerButtons,
                    {
                        tag = "Button",
                        attributes = {
                            text = player:sub(1, 1):upper() .. player:sub(2),
                            id = player,
                            textColor = "#e8dec5",
                            active = "false"
                        }
                    }
                )
            -- vertical layout
            --  player : <green>done
            --  player : <green>done
            --  player : <red>waiting
            end
        end
        xml[2].children = playerButtons
        self.UI.setXmlTable(xml)
        Global.call("setSeated", {input = players})
    end
end

function order_initiative(obj, color, alt)
    _initiativeTokens = {}
    local zone = getObjectFromGUID(_initiativeZone)
    local objs = zone.getObjects()
    for i = 1, #objs do
        if objs[i] then
            local name = objs[i].getName()
            if isToken(name) then
                objs[i].call("checkUpdates")
            end
        end
    end

    for i = 1, #objs do
        local obj = objs[i]
        if obj then
            local name = obj.getName()
            if isToken(name) then
                local tt = getLines(obj.getInputs()[1].value)
                local ini = tonumber(tt[2])
                local nn = tt[1]
                table.insert(_initiativeTokens, {token = obj, initiative = ini, name = nn})
            --print(ini .. n)
            end
        end
    end

    table.sort(
        _initiativeTokens,
        function(k1, k2)
            return k1.initiative > k2.initiative
        end
    )
    --printTable(_initiativeTokens)

    local notes = self.getGMNotes()
    local vars = JSON.decode(notes)

    local pos = {x = 36.47, y = 0.69, z = -20.77}
    if vars["initial_pos"] then
        pos = {x = vars["initial_pos"][1], y = vars["initial_pos"][2], z = vars["initial_pos"][3]}
    end

    for i = 0, #_initiativeTokens do
        local t = _initiativeTokens[i]
        pos.y = math.random(3.1, 5)
        if t then
            t.token.setPositionSmooth(pos, false, false)
            t.token.setRotationSmooth({0, 90, 0}, false, true)
            pos.x = pos.x + _difference
        end
    end

    sendToGlobal(_initiativeTokens)
    if color == "Black" then
        sendPlayers(self.getGMNotes())
    end
end

function sendPlayers(playerTable)
    local json = JSON.decode(playerTable)
    if json.players then
        local sender = {}
        for i = 1, #json.players do
            table.insert(sender, json.players[i])
        end
        Global.call("setupPlayerColors", {players = sender})
    end
end

function sendToGlobal(objs)
    local elements = {}

    for i = 1, #objs do
        local element = {
            ini = nil,
            name = nil,
            side = nil,
            pawn = nil
        }
        local pawn = getLines(objs[i].token.getDescription())[4]
        if pawn then
            element.pawn = pawn
        else
            element.pawn = nil
        end

        element.ini = objs[i].initiative
        element.name = objs[i].name

        local color = objs[i].token.getColorTint()
        local side = mysplit(objs[i].token.getName(), "_")[1]
        element.side = side
        table.insert(elements, element)
    end
    --printTable(elements)
    Global.Call("setElements", {t = elements, mat = self.guid})
end

function isToken(name)
    for i = 0, #_tokenName do
        if name == _tokenName[i] then
            return true
        end
    end
    return false
end

function getLines(text)
    local returner = {}
    for s in text:gmatch("[^\r\n]+") do
        table.insert(returner, s)
    end
    return returner
end

function printTable(t)
    local printTable_cache = {}

    local function sub_printTable(t, indent)
        if (printTable_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            printTable_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_printTable(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_printTable(t, "  ")
        print("}")
    else
        sub_printTable(t, "  ")
    end
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
