--#region initiative-hud
local _defaults = {
    color = {
        ally = "#66ba6b",
        neutral = "#d5d165",
        player = "#7e7dbb",
        enemy = "#BD5365"
    },
    players = {
        "Sai",
        "Erik",
        "Erreus",
        "Varan",
        "Chance",
        "Raymon"
    },
    playersColors = {
        sai = "Red",
        erik = "Teal",
        erreus = "Blue",
        varan = "Green",
        chance = "Yellow",
        raymon = "Purple"
    },
    offsets = {
        nr = "-35 255",
        toggle = "0 255"
    },
    insets = {
        nr = "-35 0",
        toggle = "0 0"
    },
    xt = 5,
    xc = 1,
    timeToken = {
        tToken = "2f363b",
        turnPos = {x = 101.87, y = 4.00, z = -33.55},
        turnOffset = 0.77,
        rToken = "0e4e22",
        roundPos = {x = 101.65, y = 4.00, z = -28.57},
        roundOffset = 0.38
    },
    textColor = "#f0f0f0ff"
}

-- ITEMS LEGEND:
--  id .. a = button, aka Activator for the overlay
--  id .. c = Closing button, aka while panel is open
--  id .. i = text, aka Initiative
--  id .. n = text, aka the Name of the initiative
--  id .. o = Opening button, aka while panel is close
--  id .. p = Panel, aka the panel that comes while open
--  id .. r = Toggle, aka Reaction used
--  id .. t = button, aka iniTiative button
--  id .. x = Toggle, aka Concentration used
--  id .. y = image, aka overlaY for the item to be active

local debug = false

local activated = ""
local id = 1
local elements = {}
local xmlElements = {}

local statusCache = {}

local initiatives = {}

local sound = nil

function onFixedUpdate()
    local h = #xmlElements * 50
    self.UI.setAttribute("layout", "height", h)
    self.UI.setAttribute("nm", "text", #xmlElements)
    if #xmlElements <= 5 then
        self.UI.setAttribute("widget", "noScrollbars", "true")
    else
        self.UI.setAttribute("widget", "noScrollbars", "false")
    end
end

function onLoad()
    if debug then
        elementsToSend = {}
        local toCreate = math.random(4, 20)
        local str = {"ally", "neutral", "player", "enemy"}
        for i = 1, toCreate do
            local ini = math.random(1, 24)
            local name = tostring(math.random(50, 1000))
            local side = str[math.random(1, #str)]
            local params = {
                ini = ini,
                name = name,
                pawn = self,
                side = side
            }
            --addElement(params)
            table.insert(elementsToSend, params)
        end
        printTable(UI)
        setElements({t = elementsToSend})
    end
    HideHud()
end

function setElements(params)
    local t = params.t
    resetTable()
    xmlElements = {}
    elements = {}

    if t ~= nil then
        ShowHud()
        for i = 1, #t do
            local tempE = {
                id = id,
                initiative = t[i].ini,
                name = t[i].name,
                side = t[i].side,
                pawn = t[i].pawn
            }
            table.insert(elements, tempE)
            id = id + 1
        end

        xmlElements = {}
        startLuaCoroutine(self, "BuildElements")
        Wait.condition(
            function()
                BuildWidget(xmlElements)
                ShowHud()
            end,
            function()
                if xmlElements and elements then
                    return #xmlElements == #elements and #xmlElements > 0 and #elements > 0
                else
                    return false
                end
            end
        )
    end
end

function BuildElements()
    table.sort(
        elements,
        function(k1, k2)
            return k1.initiative > k2.initiative
        end
    )
    if elements then
        if debug then
            elements[math.random(1, #elements)].name = "Zerrik"
        end
        for i = 1, #elements do
            local xmlElement = ElementBuilder(elements[i])
            table.insert(xmlElements, xmlElement)
            coroutine.yield(0)
        end
    end

    return 1
end

function ElementBuilder(element)
    if debug and false then
        print("-------------------")
        print("To Add:")
        print("\t" .. element.initiative)
        print("\t" .. element.name)
        print("color = " .. parseColor(element.side))
        element.name = element.name .. "." .. element.id
    end
    local toAdd = {
        tag = "Image",
        attributes = {
            id = element.id,
            image = "Widget",
            class = "closed",
            color = parseColor(element.side)
        },
        children = {
            {
                tag = "Image",
                attributes = {
                    id = element.id .. "y",
                    image = "Widget-overlay",
                    active = false
                }
            },
            {
                tag = "Panel",
                children = {
                    {
                        tag = "Button",
                        attributes = {
                            id = element.id .. "o",
                            class = "closed",
                            onClick = "widgetExpand(id)"
                        }
                    },
                    {
                        tag = "Text",
                        attributes = {
                            id = element.id .. "i",
                            class = "initiative",
                            text = element.initiative
                        }
                    },
                    {
                        tag = "Button",
                        attributes = {
                            id = element.id .. "t",
                            class = "finder",
                            onclick = "findPawn(id)",
                            pawn = element.pawn,
                            active = element.pawn ~= nil and "true" or "false"
                        }
                    },
                    {
                        tag = "Text",
                        attributes = {
                            id = element.id .. "n",
                            class = "name",
                            text = element.name
                        }
                    },
                    {
                        tag = "Button",
                        attributes = {
                            id = element.id .. "a",
                            class = "activator",
                            onClick = "widgetActivate(id)"
                        }
                    },
                    {
                        tag = "Panel",
                        attributes = {
                            id = element.id .. "p",
                            active = "false"
                        },
                        children = {
                            {
                                tag = "Toggle",
                                attributes = {
                                    id = element.id .. "r",
                                    class = "react",
                                    isOn = seeCache(element.name, element.initiative, element.pawn, "react"),
                                    onValueChanged = "toggleChange"
                                }
                            },
                            {
                                tag = "Toggle",
                                attributes = {
                                    id = element.id .. "x",
                                    class = "conc",
                                    isOn = seeCache(element.name, element.initiative, element.pawn, "conc"),
                                    onValueChanged = "toggleChange"
                                }
                            },
                            {
                                tag = "Button",
                                attributes = {
                                    id = element.id .. "c",
                                    class = "opened",
                                    onClick = "widgetReduce(id)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return toAdd
end

function BuildWidget(xmlEle)
    local xmlTable = UI.getXmlTable()

    local t = xmlTable[_defaults.xt].children[_defaults.xc].children
    for i = 1, #xmlEle do
        table.insert(t, xmlEle[i])
    end
    --xmlTable[3].children[1].children = panel
    updateTable(xmlTable)
end

function NextTurn()
    if activated == "" then
        UI.setAttribute(elements[1].id .. "y", "active", "true")
        activated = elements[1].name .. "|" .. elements[1].id
    else
        local myId = mysplit(activated, "|")[2]
        local myPos = findMe(myId)
        local nextPos = myPos + 1 > #elements and 1 or myPos + 1

        if nextPos == 1 then
            NextRound()
        end

        UI.setAttribute(myId .. "y", "active", "false")
        UI.setAttribute(elements[nextPos].id .. "y", "active", "true")
        activated = elements[nextPos].name .. "|" .. elements[nextPos].id
        notify()
    end
end

function ToggleHud()
    if UI.getAttribute("widget", "active") == "true" then
        HideHud()
        roundCPos = nil

        roundToken = getObjectFromGUID(_defaults.timeToken.rToken)
        turnToken = getObjectFromGUID(_defaults.timeToken.tToken)
        roundToken.setPositionSmooth(_defaults.timeToken.roundPos)
        turnToken.setPositionSmooth(_defaults.timeToken.turnPos)
        statusCache = {}
    else
        ShowHud()
    end
end

local roundCPos = nil
function NextRound()
    if roundCPos == nil then
        roundCPos = {x = 101.65, y = 4.00, z = -28.57}
    end
    roundToken = getObjectFromGUID(_defaults.timeToken.rToken)
    roundCPos.x = roundCPos.x + _defaults.timeToken.roundOffset
    roundToken.setPositionSmooth(roundCPos, false, false)
    roundToken.setRotationSmooth({0, 90, 0}, false, false)

    for i = 1, #elements do
        if not isPlayer(elements[i].name) then
            UI.setAttribute(elements[i].id .. "r", "isOn", "False")
            if statusCache[elements[i].name .. "." .. elements[i].initiative .. "." .. elements[i].pawn] then
                statusCache[name .. "." .. initiative .. "." .. pawn]["react"] = false
            end
        end
    end
end

function ShowHud()
    UI.setAttribute("widget", "active", "true")
    UI.setAttribute("nt", "offsetXY", _defaults.offsets.nr)
    UI.setAttribute("toggle", "offsetXY", _defaults.offsets.toggle)
    UI.setAttribute("nr", "active", "true")

    UI.setAttribute("nt", "textColor", _defaults.textColor)
    UI.setAttribute("toggle", "textColor", _defaults.textColor)
    UI.setAttribute("nr", "textColor", _defaults.textColor)

    textColor = ""
    TogglePlayer(true)
end

function HideHud()
    UI.setAttribute("widget", "active", "false")
    UI.setAttribute("nt", "offsetXY", _defaults.insets.nr)
    UI.setAttribute("toggle", "offsetXY", _defaults.insets.toggle)
    UI.setAttribute("nr", "active", "false")

    UI.setAttribute("nt", "textColor", _defaults.textColor)
    UI.setAttribute("toggle", "textColor", _defaults.textColor)
    UI.setAttribute("nr", "textColor", _defaults.textColor)

    TogglePlayer(false)
end

function TogglePlayer(toggle)
    UI.setAttribute("green", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("purple", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("red", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("blue", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("yellow", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("brown", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("white", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("teal", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("orange", "color", toggle and "#ffffffff" or "#ffffff00")
    UI.setAttribute("pink", "color", toggle and "#ffffffff" or "#ffffff00")
end

function toggleChange(player, option, v)
    UI.setAttribute(v, "isOn", option)

    local id = tonumber(string.sub(v, 1, -2))
    local name = UI.getAttribute(id .. "n", "text")
    local initiative = UI.getAttribute(id .. "i", "text")
    local pawn = UI.getAttribute(id .. "t", "pawn")
    local thing = UI.getAttribute(v, "class")
    local status = option == "True" and true or false

    if not isPlayer(name) then
        if not statusCache[name .. "." .. initiative .. "." .. pawn] then
            statusCache[name .. "." .. initiative .. "." .. pawn] = {
                conc = false,
                react = false
            }
        end
        statusCache[name .. "." .. initiative .. "." .. pawn][thing] = status
    end
end

function findPawn(player, request, v)
    local guid = UI.getAttribute(v, "pawn")
    local pawn = getObjectFromGUID(guid)
    pawn.call("toggleVisualize", {input = "true", color = "Black"})
    Player["Black"].lookAt(
        {
            position = pawn.getPosition(),
            distance = 60,
            pitch = 60,
            yaw = 270
        }
    )
end

function seeCache(name, initiative, pawn, thing)
    if not isPlayer(name) then
        if statusCache[name .. "." .. initiative .. "." .. pawn] then
            status = statusCache[name .. "." .. initiative .. "." .. pawn][thing]
            return status and "True" or "False"
        end
    end
    return false
end

function widgetExpand(player, request, v)
    -- request is the requested variable (in this case ID)
    -- v is the value of said variable. in this case we are in the button
    -- meaning that the id will be id + o (to signify opening button)
    -- this will be removed
    local id = tonumber(string.sub(v, 1, -2))
    UI.setAttribute(id, "image", "Widget-open")
    UI.setAttribute(id .. "p", "active", "true")
    UI.setAttribute(v, "active", "false")
end

function widgetReduce(player, request, v)
    local id = tonumber(string.sub(v, 1, -2))
    UI.setAttribute(id, "image", "Widget")
    UI.setAttribute(id .. "p", "active", "false")
    UI.setAttribute(id .. "o", "active", "true")
end

function widgetActivate(player, request, v)
    local id = tonumber(string.sub(v, 1, -2))
    if activated ~= "" then
        local currentId = mysplit(activated, "|")[2]
        UI.setAttribute(currentId .. "y", "active", "false")
    end
    local name = UI.getAttribute(id .. "n", "text")
    activated = name .. "|" .. id
    notify()
    UI.setAttribute(id .. "y", "active", "true")
end

function notify()
    local myId = mysplit(activated, "|")[2]
    local myPos = findMe(myId)
    if myPos then
        local nextPos = myPos + 1
        if nextPos > #elements then
            nextPos = 1
        end

        -- this will manage the card notification for the next
        -- in the initiative counter
        if isPlayer(elements[nextPos].name) then
            local name = string.lower(elements[nextPos].name)
            broadcastToColor("You're next in initiative! Prepare yourself.", _defaults.playersColors[name], {1, 1, 1})
            UI.setAttribute(_defaults.playersColors[name], "active", "true")
        end
        if isPlayer(elements[myPos].name) then
            local name = string.lower(elements[myPos].name)
            broadcastToColor("It's your turn!", _defaults.playersColors[name], {1, 1, 1})
            UI.setAttribute(_defaults.playersColors[name], "active", "false")
        end
    end
end

function isPlayer(name)
    for i = 1, #_defaults.players do
        if string.lower(name) == string.lower(_defaults.players[i]) then
            return true
        end
    end
end

function findMe(tofind)
    for i = 1, #elements do
        if tonumber(tofind) == tonumber(elements[i].id) then
            return i
        end
    end
    return nil
end

function nextTurn()
    -- here goes the movement of the turn counter
    if activated == "" then
    end
end

function addElement(params)
    -- params is from someone else
    -- params will be:
    --  ini     :   int
    --  name    :   string
    --  side    :   string
    --  owner   :   guid
    ---------------------------------
    --  the add element will create a new
    --  element in the HUD
    --if params then
    --    local element = {
    --        id = id,
    --        initiative = params.ini,
    --        name = params.name,
    --        side = params.side,
    --        owner = getObjectFromGUID(params.owner),
    --        visible = true
    --    }
    --    table.insert(elements, element)
    --    id = id + 1
    --    RenderElements()
    --end
end

function SyncTable()
    RenderElements()
end

function RenderElements()
    table.sort(
        elements,
        function(k1, k2)
            return k1.initiative > k2.initiative
        end
    )

    local xmlTable = self.UI.getXmlTable()
    resetTable()

    local t = xmlTable[3].children[1].children

    for i = 1, #elements do
        if debug then
            print("-------------------")
            print("To Add:")
            print("\t" .. elements[i].initiative)
            print("\t" .. elements[i].name)
            print("color = " .. parseColor(elements[i].side))
            elements[i].name = elements[i].name .. "." .. elements[i].id
        end
        local toAdd = {
            tag = "Image",
            attributes = {
                id = elements[i].id,
                image = "Widget",
                class = "closed",
                color = parseColor(elements[i].side)
            },
            children = {
                {
                    tag = "Panel",
                    children = {
                        {
                            tag = "Button",
                            attributes = {
                                id = elements[i].id .. "o",
                                class = "closed",
                                onClick = "widgetExpand(id)"
                            }
                        },
                        {
                            tag = "Text",
                            attributes = {
                                class = "initiative",
                                text = elements[i].initiative
                            }
                        },
                        {
                            tag = "Text",
                            attributes = {
                                class = "name",
                                text = elements[i].name
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                id = elements[i].id .. "p",
                                active = "false"
                            },
                            children = {
                                {
                                    tag = "Toggle",
                                    attributes = {
                                        class = "react"
                                    }
                                },
                                {
                                    tag = "Toggle",
                                    attributes = {
                                        class = "conc"
                                    }
                                },
                                {
                                    tag = "Button",
                                    attributes = {
                                        id = elements[i].id .. "c",
                                        class = "opened",
                                        onClick = "widgetReduce(id)"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        --printTable(toAdd)

        table.insert(t, toAdd)
        toAdd = nil
    end
    updateTable(xmlTable)
end

function parseColor(side)
    return _defaults.color[side]
end

function updateTable(xmlTable)
    local h = getHeightMultiplier()
    UI.setXmlTable(xmlTable)
    UI.setAttribute("layout", "height", h)
end

function resetTable()
    local xmlTable = UI.getXmlTable()
    xmlTable[_defaults.xt].children[_defaults.xc].children = {}
    UI.setXmlTable(xmlTable)
    --printTable(xmlTable)
end

function getHeightMultiplier()
    local counter = 0
    for i = 1, #elements do
        if elements[i].visible then
            counter = counter + 1
        end
    end
    return counter * 50
end

function requestPlayer(player)
    UI.setAttribute(_defaults.playersColors[player.p] .. "_box", "active", "true")
    initiatives[_defaults.playersColors[player.p]] = {t = player.t, i = ""}
end

function submitRequest(player)
    -- this activates on the submit button
    if initiatives[player.color].i ~= "" then
        UI.setAttribute(player.color .. "_box", "active", "false")
        local playerName = getPlayerByColor(player.color)
        playerName = playerName:sub(1, 1):upper() .. playerName:sub(2) -- capitalize name
        printToAll(
            "[" .. Color[player.color]:toHex(false) .. "]" .. playerName .. ":[-] " .. initiatives[player.color].i,
            "White"
        ) -- print initiative in the chat

        local obj = getObjectFromGUID(initiatives[player.color].t)
        obj.editInput({index = 0, value = playerName .. "\n" .. initiatives[player.color].i})
    end
end

function submitChange(player, value, obj)
    -- this activates while the player is writing on its little box
    initiatives[player.color].i = value
end

function getPlayerByColor(color)
    for k, v in pairs(_defaults.playersColors) do
        if v == color then
            return k
        end
    end
    return nil
end

--#endregion

--#region breaker
function UI_SideToggle()
    local offset = self.UI.getAttribute("TopButton", "offsetXY")
    local closed = offset == "75 5"

    if closed then
        -- to open
        -- button stuff
        self.UI.setAttribute("TopButton", "offsetXY", "75 -100")
        self.UI.setAttribute("TopButton", "text", "▲")
        self.UI.setAttribute("TopButton", "textColor", "#f0f0f0") -- dno why i gotta do this, but alas, shitty program

        -- panel stuff
        self.UI.setAttribute("TopPanel", "active", "true")
    else
        -- to close
        -- button stuff
        self.UI.setAttribute("TopButton", "offsetXY", "75 5")
        self.UI.setAttribute("TopButton", "text", "▼")
        self.UI.setAttribute("TopButton", "textColor", "#f0f0f0") -- dno why i gotta do this, but alas, shitty program

        -- panel stuff
        self.UI.setAttribute("TopPanel", "active", "false")
    end
end

local _MassField = ""
function UI_MassCalculate(player, request, id)
    local text = tonumber(_MassField)
    local objs = Player[player.color].getSelectedObjects()
    for i = 1, #objs do
        local gm = objs[i].getGMNotes()
        if gm == "monster_token" or gm == "boss_token" then
            objs[i].call(
                "GlobalCalculate",
                {input = id == "MassDamage" and text * -1 or text, t = string.gsub(id, "Mass", "")}
            )
        end
    end
end

function UI_UpdateValue(player, value)
    _MassField = value
end
--#endregion

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
