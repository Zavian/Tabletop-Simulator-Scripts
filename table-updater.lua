--[[StartXML
<Defaults>
    <Panel color="#282828AA" />

    <Panel class="npc_commander" rectAlignment="MiddleLeft" color="#FFE162" />
    <Text class="npc_commander" color="#FFE162" />

    <Panel class="initiative_mat" rectAlignment="MiddleLeft" color="#9ACFFD" />
    <Text class="initiative_mat" color="#9ACFFD" />

    <Panel class="player" rectAlignment="MiddleLeft" color="#EEEEEE" />
    <Text class="player" color="#EEEEEE" />

    <Button rectAlignment="UpperLeft" width="200" height="38" colors="#282828|#c8329b|#ff9b38|#dddddd" textColor="White" />
    <Text fontSize="11" alignment="UpperLeft" rectAlignment="UpperLeft" />
    <Text class="title" fontSize="18" fontStyle="Bold" />
    <InputField rectAlignment="UpperLeft" onValueChanged="UI_UpdateInput" />
</Defaults>
StopXML--xml]]


function loadXML()
    local script = self.getLuaScript()
    local xml = script:sub(script:find("StartXML")+8, script:find("StopXML")-1)
    self.UI.setXml(xml)
end


-- TODO: Implement saving and loading of variables such as GUIDs and player data etc.


-- Global variables --------------------- DO NOT TOUCH --------------------------
local magic_word = "mr developer"
local _require_restart = false
local _accepting_players = false

-- Github urls for the various scripts -- DO NOT TOUCH --------------------------
local _URLs = {
    _v = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/VERSIONS",
    _self = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/table-updater.lua",
    npc_commander = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/NPC%20Commander.v2.lua",
    monster = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/Monster%20Token/monster.lua",
    initiative_mat = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/Initiative%20Stuff/initiative-mat.lua",
    player_manager = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/player_manager/player-manager.lua",
    initiative_token = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/Initiative%20Stuff/initiative-token.lua",
    note = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Clever%20Notecard/notecard.lua"
}

-- variable to store versions downloaded from github -----------------------------
local _versions = {
}

local _colors = {
    "Green", "Purple", "Red", "Blue", "Yellow", "Brown", "White", "Teal", "Orange", "Pink"
}


--[[
    Green, Purple, Red, Blue, Yellow, Brown, White, Teal, Orange, Pink
    What needs to be stored:
        - Each component with the following things:
            - Version
            - GUID
        - Each player
            - Color
            - Character Name
            - Manager GUID
            - Mini GUID
    An ideal _data should look like this:
    _data = {
        debug = false,
        components = {
            npc_commander = {
                version = "2.2.1",
                guid = "aa88ii"
            },
            monster = {
                version = "1.0.0",
                guid = "bb99ii"
            },
            initiative_mat = {
                version = "1.0.0",
                guid = "cc88ii"
            },
            player_manager = {
                version = "1.0.0",
                guid = "dd88ii"
            }
        },        
        players = {
            red = {
                name = "Zora",
                manager_guid = "aa88oo",
                mini_guid = "bb99oo"
            },
            blue = {
                name = "Frank",
                manager_guid = "aa88oo",
                mini_guid = "bb99oo"
            },
            yellow = nil,
            green = {
                name = "Zavian",
                manager_guid = "aa88oo",
                mini_guid = "bb99oo"
            },
            teal = nil,
            purple = nil,
            brown = {
                name = "Laura",
                manager_guid = "aa88oo",
                mini_guid = "bb99oo"
            },
            white = nil,
            orange = nil,
            pink = {
                name = "Deborah",
                manager_guid = "aa88oo",
                mini_guid = "bb99oo"
            }
        }
    }
--]]

local _data = {
    debug = false
}

-- event functions --------------------------------------------------------------
function none() end

function onLoad(saved_data)
    loadXML()

    if saved_data ~= "" then
        log("Found saved data.")
        _data = JSON.decode(saved_data)
        _debug(_data)
    end

    processVersions()

    self.createButton({
       click_function = 'start',
       function_owner = self,
       label = 'Start',
       color = {r = 0.498, g = 0.831, b = 0.988},
       position = {0, 0.1, 0},
       scale = {0.5, 0.5, 0.5},
       width = 950,
       height = 950,
       font_size = 400,
       tooltip = ' '
    })

    if _data.debug then 
        broadcastNotice("Debug mode is on.")
        start() 
    end
end

function onSave()
    updateSave()
    return self.script_state
end

function onCollisionEnter(collision_info)
    -- collision_info table:
    --   collision_object    Object
    --   contact_points      Table     {Vector, ...}
    --   relative_velocity   Vector
    if _accepting_players then
        if collision_info.collision_object.interactable then
            local t = collision_info.collision_object.type
            if t == "Tileset" then -- this is for the character mini
                self.UI.setAttribute("playerMiniGUID", "text", collision_info.collision_object.guid)
                self.UI.setAttribute("playerMiniGUID", "value", collision_info.collision_object.guid)
            elseif t == "Checker" then -- this is for the character manager
                self.UI.setAttribute("playerManagerGUID", "text", collision_info.collision_object.guid)
                self.UI.setAttribute("playerManagerGUID", "value", collision_info.collision_object.guid)
            end
        end
    end
end

function onChat(message, player)
    if player.admin then
        _debug("onChat admin chat")
        if message:contains(magic_word) then
            _debug("onChat contains magic word")
            local command = message:replace(magic_word, ""):trim()
            local args = {}


            for word in command:gmatch("%S+") do
                table.insert(args, word)
            end
            command = args[1]
            if command == "update" then
                broadcastNotice("Updating...")
                updateAll()
            elseif command == "debug" then
                _data.debug = not _data.debug
                if _data.debug then
                    broadcastNotice("Debugging is now on.")
                else
                    broadcastNotice("Debugging is now off.")
                end
            elseif command == "help" then
                print("Commands:")
                print("\t[b]update[/b] - Updates all components and players.")
                print("\t[b]component[/b] - Sets up a component.")
                print("\t[b]player[/b] - Sets up a player.")
                print("\t[b]debug[/b] - Toggles debug mode.")
                print("\t[b]data[/b] - Prints the _data table.")
            elseif command == "data" then
                print("Printing _data table")
                printTable(_data)
            elseif command == "component" then
                if #args == 1 then
                    print("[7FDBFF][i]Adds a component[/i].[-] [3D9970]Arguments: <[b]component name[/b]> <[b]component guid[/b]>[-].")
                    return
                end

                if #args == 2 then 
                    broadcastError("You must specify a component and a GUID.") 
                    return 
                end
                local component = args[2]

                local guid = args[3]
                if not exists(guid) then
                    broadcastError("The GUID you specified does not exist.")
                    return
                end

                local possible_components = {
                    "npc_commander",
                    "monster",
                    "boss",
                    "initiative_token",
                    "note",
                    "initiative_mat"
                }

                if not tableContains(possible_components, component) then
                    broadcastError("The component you specified is not valid.")
                    return
                end

                _data.components[component] = {
                    version = "",
                    guid = guid
                }
                broadcastNotice("Added " .. component .. " with GUID " .. guid .. ".")
            elseif command == "player" then
                if #args == 1 then 
                    print("[7FDBFF][i]Adds a player[/i].[-] [3D9970]Arguments: <[b]color[/b]> <[b]name[/b]> <[b]manager_guid[/b]> <[b]mini_guid[/b]>[-].")
                    return
                end

                if args[2] == nil then
                    broadcastError("You must specify a player color.")
                    return
                end
                local color = capitalize(args[2])

                if not validColor(color) then
                    broadcastError("The color you specified is not valid.")
                    return
                end

                if args[3] == nil then
                    broadcastError("You must specify a character name.")
                    return
                end
                local name = args[3]


                if args[4] == nil then
                    broadcastError("You must specify a manager GUID.")
                    return
                end
                local manager_guid = args[4]
                if not exists(manager_guid) then
                    broadcastError("The manager GUID you specified does not exist.")
                    return
                end

                if args[5] == nil then
                    broadcastError("You must specify a mini GUID.")
                    return
                end
                local mini_guid = args[5]
                if not exists(mini_guid) then
                    broadcastError("The mini GUID you specified does not exist.")
                    return
                end


                _data.players[color] = {
                    name = name,
                    manager_guid = manager_guid,
                    mini_guid = mini_guid
                }
                broadcastNotice("Added " .. color .. " player with name " .. name .. " and manager GUID " .. manager_guid .. " and mini GUID " .. mini_guid .. ".")
            end
        end
    end
end

function start()        
    if not _data.debug then
        if needsUpdate("_self") then
            updateObj(
                self,
                "_self",
                function()
                    broadcastNotice("Updated self to latest version.")
                    self.memo = _versions["_self"]
                    Wait.time(function()
                        self.reload()
                    end, 0.3)
                end
            )
        end
    end
    startUI()
end

function processVersions()
    _debug("processVersions")
    WebRequest.get(
        _URLs._v,
        function(request)
            log("Versions check: " .. request.response_code)
            if request.is_error then
                broadcastError(link .. "\n" .. request.error)
            else
                local versions = request.text
                _debug("processVersions versions found")
                local lines = split(versions, "\n")
                lines = removeEmpty(lines)
                for i, line in ipairs(lines) do
                    local splitLine = split(line, " ")
                    if splitLine[1] and splitLine[2] then
                        _debug(string.format("processVersions %s %s", splitLine[1], splitLine[2]))
                        if splitLine[1] == "table_updater" then splitLine[1] = "_self" end
                        _versions[splitLine[1]] = splitLine[2]
                    end
                end
                checkForUpdates()
            end
        end
    )
end

function bump(component)
    _debug("bump " .. component and component or "all")
    processVersions()
    if not component then
        for c, v in pairs(_versions) do
            if _data[c] then _data[c].version = v
            else _data[c] = {version = v, guid = ""} end
        end
    else
        if _data[component] then _data[component].version = _versions[component]
        else _data[component] = {version = _versions[component], guid = ""} end
    end
end

function checkForUpdates()
    _debug("checkForUpdates")
    for component, version in pairs(_versions) do        
        if needsUpdate(component) then
            if component ~= "table_updater" then 
                broadcastNotice(component .. " needs an update.")
            end
        end
    end
end

function updateAll()
    broadcastNotice("Updating all components...")
    for component, t in pairs(_data.components) do
        _debug("updating " .. component .. " " .. t.guid)
        if t then
            if t.guid then
                local obj = getObjectFromGUID(t.guid)
                if obj then
                    if isInfiniteBag(obj) then
                        local o = extractObject(obj)
                        Wait.time(function()
                            if component == "boss" then
                                component = {"monster", "boss"}
                            end
                            updateObj(
                                o, component,
                                function(updated)
                                    obj.reset()
                                    updated.setLock(false)
                                    if type(component) == "table" then
                                        setComponentGUID(component[2], obj.guid)
                                    else setComponentGUID(component, obj.guid) end
                                end
                            )                    
                        end, 1)
                    else
                        updateObj(obj, component, nil) 
                    end
                else broadcastError("Object not found: " .. t.guid .. " (" .. component ")") end
            end
        end
    end
    broadcastNotice("All components updated")
    broadcastNotice("Updating players...")

    local i = 0.5
    for color, player in pairs(_data.players) do
        Wait.time(function()
            local obj = getObjectFromGUID(player.manager_guid)
            if obj then
                updateObj(obj, "player_manager", nil)
            end
        end, i)
        i = i + 0.5
    end
    Wait.time(function()
        broadcastNotice("Players updated")
    end, i+0.2)
end

-- UI mod functions -------------------------------------------------------------

local _defaultHeight = 114
local _defaultWidth = 500
function startUI()
    _debug("startUI")
    
    local xml = self.UI.getXmlTable()

    local panel = {
        tag = "Panel",
        attributes = {
            id = "main",
            position = "0 150 -10",
            rotation = "180 180 0",
            width = _defaultWidth,
            height = _defaultHeight,
        },
        children = {
            createButton("New Table", "34 38", "200", "38", "UI_NewTable", nil),
            createButton("Update Table", "274 38", "200", "38", "UI_UpdateTable", nil)
        }
    }
    xml = table.insert(xml, panel)
    self.UI.setXmlTable(xml)
end

function negatePos(position)
    local x = tonumber(split(position, " ")[1])
    local y = tonumber(split(position, " ")[2])

    y = y * -1

    return x .. " " .. y
end

function createInput(placeholder, position, id, width, height, linetype, text, readonly)
    position = negatePos(position)
    return {
        tag = "InputField",
        attributes = {
            id = id,
            offsetXY = position,
            rotation = "0 0 0",
            width = width,
            height = height,
            placeholder = placeholder,
            lineType = linetype,
            text = text or "",
            value = text or "",
            readOnly = readonly or false
        }
    }
end

function createText(text, position, class, width, alignment)    
    position = negatePos(position)
    return {
        tag = "Text",
        attributes = {
            offsetXY = position,
            rotation = "0 0 0",
            text = text,
            class = class,
            width = width or "100%",
            alignment = alignment or "UpperLeft"
        }
    }
end

function createButton(text, position, width, height, click_function, id, color)
    position = negatePos(position)
    if not color then color = "#282828|#c8329b|#ff9b38|#dddddd"
    else color = color .. "|#c8329b|#ff9b38|#dddddd" end
    return {
        tag = "Button",
        attributes = {
            id = id,
            offsetXY = position,
            text = text,
            width = width,
            height = height,
            onClick = click_function,
            colors = color
        }
    }
end

function createColorBand(class, height)
    return {
        tag = "Panel",
        attributes = {
            id = class,
            width = "19",
            height = height,
            class  = class
        }
    }
end

function getPanel()
    local xml = self.UI.getXmlTable()
    return xml, xml[2]
end

function setUI(xml)
    self.UI.setXmlTable(xml)
end

function emptyUI()
    local xml, panel = getPanel()
    panel.children = {}
    setUI(xml)
end

function readInputs(IDs)
    _debug("readInputs")
    local values = {}
    for i, id in ipairs(IDs) do
        local input = self.UI.getAttribute(id, "value")
        values[id] = input
    end
    _debug(values)
    return values
end

function setPanel(width, height)
    self.UI.setAttribute("main", "width", width)
    self.UI.setAttribute("main", "height", height)

    local offsetY = 0
    local offsetX = 0
    if height > _defaultHeight then
        offsetY = (height - _defaultHeight)/2
    end

    if width > _defaultWidth then
        offsetX = (width - _defaultWidth)/2
    end

    self.UI.setAttribute("main", "offsetXY", offsetX .. " " .. offsetY)
end

local _color_index = 0
local _current_player_index = 0
function createPlayerPage()
    _accepting_players = true
    local index = getNextPlayerIndex(_color_index)
    if _color_index > #_colors then
        broadcastNotice("No more players to create.")
        _color_index = 0
        _current_player_index = 0
        createFinish()
        return
    end
    
    local playerLen = getPlayerCount()
    local player = _data.players[_colors[index]]

    emptyUI()
    setPanel(429, 103)

    if player then
        _debug(_color_index .. " " .. playerLen .. " " .. player.name)
    end

    local xml, panel = getPanel()
    panel.children = {
        createColorBand("player", 103),
        createText(
            string.format("Character Mini - %s - %d/%d", player.name, _current_player_index, playerLen), 
            "22 3",
            "title player"
        ),
        createInput("Character mini GUID...", "22 27", "playerMiniGUID", 199, 30),
        createInput("Character manager GUID...", "224 27", "playerManagerGUID", 199, 30),
        createButton("Confirm", "22 58", 401, 38, "UI_ConfirmPlayerTokens(" .. _colors[index] .. ")", nil)
    }
    setUI(xml)
end

function getNextPlayerIndex(index)
    if index == nil then index = 0 end

    _debug("getNextPlayerIndex " .. index)

    index = index + 1
    for i = index, #_colors do
        local color = _colors[i]
        if _data.players[color] then
            _debug("Found player " .. color)
            _debug("Index " .. i)
            _debug(_current_player_index)
            _color_index = i
            _current_player_index = _current_player_index + 1
            return _color_index
        end
    end

    -- +1 needed for ending the whole process
    -- this only happens when there is no player found
    _color_index = index + 1
    return _color_index
end

function getPlayerCount()
    local count = 0
    for i = 1, #_colors do
        local color = _colors[i]
        if _data.players[color] ~= nil then count = count + 1 end
    end
    return count
end

--function getNextExistingColor(index)
--    if index == nil then index = 0 end
--
--    index = index + 1
--    for i = index, #_colors do
--        local color = _colors[i]
--        local player = _data.players[color]
--        if player ~= nil then
--            _player_index = i
--            return color
--        end
--    end
--end

function createFinish()
    emptyUI()
    setPanel(500, 189)

    local xml, panel = getPanel()
    panel.children = {
        createText(
            "Setup process completed, however there are a few things that you’ll need to do:\n" ..
            "- Link all of the player minis to make sure that they are ready for play.\n" ..
            "- Check the initiative mat and select one player token with the GIZMO tool:\n" ..
            "- > Move it up and down the initiative count. If it moves something that isn’t the X coordinate or it goes towards below 0 then add the following variables to the GM notres of the mat: “go_by” should be either “x” or “z”, “make_negative” should be either true or false.\n" ..
            "- Save the table and restart it. There should be no errors.",
            "10 5",
            "player",
            500 - 10
        ),
        createButton("Close", "150 130", 200, 38, "UI_Close", nil)
    }
    setUI(xml)
end

function extractObject(bag)
    local newPos = bag.getPosition()
    newPos.y = newPos.y + 3
    return bag.takeObject({
        position = newPos,
        callback_function = function(spawned)
            spawned.setLock(true)
        end
    })
end

-- UI functions -----------------------------------------------------------------
function UI_UpdateInput(player, value, id)
    self.UI.setAttribute(id, "value", value)
end

function UI_Close()
    loadXML()
end

function UI_FindToken(player, id)
    local obj = getObjectFromGUID(id)
    player.pingTable(obj.getPosition())
    obj.highlightOn(Color.Green, 2)
end

function UI_NewTable(player, mouse)
    emptyUI()
    setPanel(500, 181)

    local xml, panel = getPanel()
    panel.children = {
        createColorBand("player", 181),
        createText("Players", "22 3", "title player"),
        createText(
            "Insert the player characters and their colors by inserting character name=player color\nPossible colors: Green, Purple, Red, Blue, Yellow, Brown, White, Teal, Orange, Pink"
            , "22 27", "player"
        ),
        createInput(
            "Player1=Blue\nPlayer2=Green\nPlayer3=Purple", 
            "22 58", "playerInput", "364", "120", "MultiLineNewLine", 
            getPlayers()
        ),
        createButton("Confirm", "390 140", 105, 38, "UI_ConfirmPlayers", nil)
    }
    setUI(xml)
end

function UI_UpdateTable(player, mouse)
    emptyUI()
    setPanel(503, 495)

    local xml, panel = getPanel()

    local components = {
        "npc_commander",
        "monster",
        "boss",
        "initiative_token",
        "initiative_mat",
        "note"
    }
    --NPC Commander
    --Monster Token
    --Boss Token
    --Initiative Token
    --Notes
    panel.children = {
        createText("NPC Commander", "18 15", "title player", 156, "UpperRight"),
        createInput(" ", "186 15", "npc_commander_guid", 103, 30, nil, getComponentGUID("npc_commander"), true),
        createText("Monster Token", "18 45", "title player", 156, "UpperRight"),
        createInput(" ", "186 45", "monster_token_guid", 103, 30, nil, getComponentGUID("monster"), true),
        createText("Boss Token", "18 74", "title player", 156, "UpperRight"),
        createInput(" ", "186 74", "boss_token_guid", 103, 30, nil, getComponentGUID("boss"), true),
        createText("Initiative Token", "18 103", "title player", 156, "UpperRight"),
        createInput(" ", "186 103", "initiative_token_guid", 103, 30, nil, getComponentGUID("initiative_token"), true),
        createText("Initiative Mat", "18 132", "title player", 156, "UpperRight"),
        createInput(" ", "186 132", "initiative_mat_guid", 103, 30, nil, getComponentGUID("initiative_mat"), true),
        createText("Notes", "18 163", "title player", 156, "UpperRight"),
        createInput(" ", "186 163", "note_guid", 103, 30, nil, getComponentGUID("note"), true),
    }

    for i,component in ipairs(components) do
        local guid = getComponentGUID(component)
        local pos = "292 " .. ((i-1)*29 + 15)
        if guid then
            local obj = getObjectFromGUID(guid)
            if obj then
                local isInBag = isInfiniteBag(obj)
                table.insert(panel.children, createButton(
                    isInBag and "In Bag" or "Not In Bag",
                    pos,
                    90,
                    30,
                    "UI_FindToken(" .. guid .. ")",
                    "",
                    isInBag and "#0074D9" or "#2ECC40"
                ))
            else
                table.insert(panel.children, createButton(
                    "Error",
                    pos,
                    90,
                    30,
                    "none",
                    "",
                    "#FF4136"
                ))
            end
        else 
            table.insert(panel.children, createButton(
                "Not Found",
                pos,
                90,
                30,
                "none",
                ""
            ))
        end
    end

    table.insert(panel.children, createText(
        "Players",
        "18 190",
        "title player",
        nil,
        nil
    ))


    local i = 1
    for color, player in pairs(_data.players) do
        table.insert(panel.children, createButton(
            player.name,
            18 + (78*(i-1)) .. " 217",
            75,
            50,
            "UI_FindToken(" .. player.manager_guid .. ")",
            player.manager_guid,
            color
        ))
        i = i + 1
    end

    table.insert(panel.children, createButton(
        "Update",
        "292 442",
        200,
        38,
        "UI_UpdateAll",
        nil,
        "#2ECC40"
    ))

    table.insert(panel.children, createButton(
        "Cancel",
        "146 442",
        135,
        38,
        "UI_CancelUpdate"
    ))

    setUI(xml)
end

function UI_CancelUpdate()
    loadXML()
end

function UI_UpdateAll()
    updateAll()
end

function UI_UpdateComponent(player, component)
    local url = _URLs[component]
    if url == nil then
        broadcastNotice("Component " .. component .. " not found.")
        return
    end    
    if _data.components[component] == nil then
        broadcastNotice("Component " .. component .. " not found.")
        return
    end

    _debug("updating " .. component)
end

function UI_ConfirmPlayers(player, mouse)
    local input = readInputs({"playerInput"})["playerInput"]
    if not validInput(input) then
        broadcastError("Invalid input. Please try again.")
        return
    end
    local lines = split(input, "\n")
    lines = removeEmpty(lines)
    local players = {}

    _data.players = emptyPlayers()
    for i, line in ipairs(lines) do
        local splitLine = split(line, "=")
        if splitLine[1] and splitLine[2] then
            local name = capitalize(splitLine[1])
            local color = capitalize(splitLine[2])
            if not validInput(name) or not validInput(color) then
                broadcastError("Invalid input. Please try again.")
                return
            end

            if not validColor(color) then
                broadcastError("Error in color parsing. Please try again.")
                return
            end

            addPlayer(color, name)
        else
            broadcastError("Invalid input. Please try again.")
            return
        end
    end

    broadcastNotice("Players have been setup.")

    emptyUI()
    setPanel(500, 181)

    local xml, panel = getPanel()
    panel.children = {
        createColorBand("npc_commander", 181),
        createText("NPC Commander", "22 3", "title npc_commander"),
        createInput("Insert NPC Commander's GUID...", "124 68", "commanderGUIDInput", 253, 30, "SingleLine", getComponentGUID("npc_commander") or ""),
        createButton("Confirm GUID", "124 96", 253, 38, "UI_ConfirmCommanderGUID", nil)
    }
    setUI(xml)
end

function UI_ConfirmCommanderGUID(player, mouse)
    local input = readInputs({"commanderGUIDInput"})["commanderGUIDInput"]:trim()
    if not validInput(input) then
        broadcastError("Invalid input. Please try again.")
        return
    end
    if not exists(input) then
        broadcastError("Invalid GUID. Please try again.")
        return
    end

    updateObj(
        getObjectFromGUID(input),
        "npc_commander",
        function()
            setComponentGUID("npc_commander", input)
            broadcastNotice("NPC Commander GUID has been set and it has been updated.")
        end
    )

    

    emptyUI()
    setPanel(456, 366)

    local xml, panel = getPanel()
    panel.children = {
        createColorBand("npc_commander", 366),
        createText("NPC Commander", "22 3", "title npc_commander"),
        -----------------------------------------------------------
        createText("Monster tokens are the monsters that do not have an image (generic monsters)", "22 24", "npc_commander"),
        createInput("Monster token GUID...", "22 44", "monsterTokenGUIDInput", 210, 30),
        createInput("Monster bag GUID...", "235 44", "monsterBagGUIDInput", 210, 30),
        createButton("Confirm GUIDs", "22 72", 424, 23, "UI_ConfirmGenericToken(monster)", "confirmMonsterTokensBtn"),
        -----------------------------------------------------------
        createText("Boss tokens are the monsters that have an image (such as bosses)", "22 95", "npc_commander"),
        createInput("Boss token GUID...", "22 115", "bossTokenGUIDInput", 210, 30),
        createInput("Boss bag GUID...", "235 115", "bossBagGUIDInput", 210, 30),
        createButton("Confirm GUIDs", "22 143", 424, 23, "UI_ConfirmGenericToken(boss)", "confirmBossTokensBtn"),
        -----------------------------------------------------------
        createText("Initiative tokens are the items that allow to track initiative in combat", "22 166", "npc_commander"),
        createInput("Initiative token GUID...", "22 186", "initiative_tokenTokenGUIDInput", 210, 30),
        createInput("Initiative bag GUID...", "235 186", "initiative_tokenBagGUIDInput", 210, 30),
        createButton("Confirm GUIDs", "22 214", 424, 23, "UI_ConfirmGenericToken(initiative_token)", "confirmInitiativeTokensBtn"),
        -----------------------------------------------------------
        createText("Notes are used to store monster information (optional element)", "22 242", "npc_commander"),
        createInput("Parsing note GUID...", "22 262", "noteTokenGUIDInput", 210, 30),
        createInput("Parsing note bag GUID...", "235 262", "noteBagGUIDInput", 210, 30),
        createButton("Confirm GUIDs", "22 290", 424, 23, "UI_ConfirmGenericToken(note)", "confirmNoteTokensBtn"),
        -----------------------------------------------------------
        createButton("Continue", "131 318", 195, 38, "UI_ConfirmTokens", nil)
    }
    setUI(xml)
end

function UI_ConfirmGenericToken(player, t, id)
    _debug("UI_ConfirmGenericToken " .. t .. " " .. id)
    local tokenInput = t .. "TokenGUIDInput"
    local bagInput = t .. "BagGUIDInput"
    local input = readInputs({tokenInput, bagInput})
    if not validInput(input[tokenInput]) or not validInput(input[bagInput]) then
        broadcastError("Invalid input. Please try again.")
        return
    end
    if not exists(input[tokenInput]) or not exists(input[bagInput]) then
        broadcastError("Invalid GUID. Please try again.")
        return
    end


    local component = t
    if t == "boss" then component = {"monster", "boss"} end
    updateObj(
        getObjectFromGUID(input[tokenInput]),
        component,
        function()
            setComponentGUID(t, input[bagInput])
            placeInBag(input[tokenInput], input[bagInput], _data.debug)
            self.UI.setAttribute(id, "textColor", "Green")
            broadcastNotice(capitalize(t) .. " has been setup.")
        end
    )

    
end

function UI_ConfirmTokens(player, mouse)
    emptyUI()
    setPanel(500, 181)

    local xml, panel = getPanel()
    panel.children = {
        createColorBand("initiative_mat", 181),
        createText("Initiative Mat", "22 3", "title initiative_mat"),
        createInput("Initiative mat GUID...", "124 68", "initiativeMatGUIDInput", 253, 30),
        createButton("Confirm", "124 96", 253, 38, "UI_ConfirmInitiativeMat", nil)
    }
    setUI(xml)
end

function UI_ConfirmInitiativeMat(player, mouse)
    local input = readInputs({
        "initiativeMatGUIDInput"
    })["initiativeMatGUIDInput"]:trim()
    
    if not validInput(input) then
        broadcastError("Invalid initiative mat GUID. Please try again.")
        return
    end

    if not exists(input) then
        broadcastError("Invalid initiative mat GUID. Please try again.")
        return
    end

    setComponentGUID("initiative_mat", input)
    broadcastNotice("Initiative mat has been setup.")



    emptyUI()
    setPanel(331, 246)


    local xml, panel = getPanel()
    panel.children = {
        createColorBand("initiative_mat", 246),
        createText("Initiative Mat", "22 3", "title initiative_mat"),
        createText("When pressing the zone button a new scripting zone will be created. Select it with the GIZMO tool (F8) and make it as big as the initiative mat, then click the button again", "22 25", "initiative_mat", 331-22),
        createButton("Setup Initiative Zone", "22 71", 301, 27, "UI_SetupInitiativeZone", "iniZoneBtn"),
        createText("Place the spawned token in the first place of initiative\nAfterwards press the button again", "22 101", "initiative_mat"),
        createButton("Setup Position 0", "22 133", 301, 27, "UI_SetupPositionZero", "iniPosZeroBtn"),
        createButton("Setup Player Initiative Tokens", "22 164", 301, 27, "UI_SetupPlayerInitiativeTokens", nil),
        createButton("Confirm", "68 200", 195, 38, "UI_ConfirmInitiativeMat2", nil)
    }
    setUI(xml)
end

function UI_SetupInitiativeZone(player, mouse)
    local iniMat = getObjectFromGUID(getComponentGUID("initiative_mat"))
    local secondPress = self.UI.getAttribute("iniZoneBtn", "text"):contains("Confirm")
    if not secondPress then
        self.UI.setAttribute("iniZoneBtn", "text", "Confirm Initiative Zone")
        self.UI.setAttribute("iniZoneBtn", "textColor", "Blue")
        
        local positionToZone = iniMat.getPosition()
        spawnParams = {
            type = "ScriptingTrigger",
            position = positionToZone,
            rotation = {x = 0, y = 90, z = 0},
            scale = {x = 4, y = 4, z = 4},
            sound = false,
            snap_to_grid = true
        }
        local area = spawnObject(spawnParams)

        _data.components.initiative_mat.area = area.guid

        broadcastNotice("You should now select the initiative mat with the GIZMO tool (F8) and make it as big as the initiative mat, then click the button again.")
    else
        local area = getObjectFromGUID(_data.components.initiative_mat.area)
        if not area then
            broadcastError("Invalid initiative mat area. You should not delete the area that I create.")
            self.UI.setAttribute("iniZoneBtn", "text", "Setup Initiative Zone")
            self.UI.setAttribute("iniZoneBtn", "textColor", "White")
            return
        end

        self.UI.setAttribute("iniZoneBtn", "text", "Setup Initiative Zone")
        self.UI.setAttribute("iniZoneBtn", "textColor", "Green")

        updateObj(
            iniMat, 
            "initiative_mat", 
            function(o)
                broadcastNotice("Initiative zone has been setup.")

                local gm = ""
                local encoded = ""
                local currentGM = o.getGMNotes()
                if currentGM == "" then
                    gm = { zone = area.guid }
                    encoded = JSON.encode_pretty(gm)
                else
                    gm = JSON.decode(currentGM)
                    gm.zone = area.guid
                    encoded = JSON.encode_pretty(gm)
                end

                _debug(gm)
                _debug(encoded)

                Wait.time(function()
                    o.setGMNotes(encoded)
                end, 1)
            end
        )
    end
end

function UI_SetupPositionZero(player, mouse)
    local iniMat = getObjectFromGUID(getComponentGUID("initiative_mat"))
    local secondPress = self.UI.getAttribute("iniPosZeroBtn", "text"):contains("Confirm")
    if not secondPress then
        self.UI.setAttribute("iniPosZeroBtn", "text", "Confirm Position Zero")
        

        local iniTokenBag = getObjectFromGUID(getComponentGUID("initiative_token"))
        local newPos = iniMat.getPosition()
        newPos.y = newPos.y + 5

        local iniMatRotation = iniMat.getRotation()
        
        iniTokenBag.takeObject({
            position = newPos,
            rotation = iniMatRotation,
            callback_function = function(spawned)
                Wait.frames(
                    function() 
                        spawned.call(
                            "_init",
                            {
                                input = {
                                    name = "Place me as\nfirst initiative",
                                    modifier = 1,
                                    pawn = "",
                                    side = "player",
                                    static = true
                                }
                            }
                        )
                        spawned.use_snap_points = true
                        self.UI.setAttribute("iniPosZeroBtn", "tooltip", spawned.guid)
                        self.UI.setAttribute("iniPosZeroBtn", "textColor", "Blue")
                    end
                )
                
            end
        })

        broadcastNotice("Place the spawned token in the first place of initiative then press the button again.")
    else
        local token = getObjectFromGUID(self.UI.getAttribute("iniPosZeroBtn", "tooltip"))
        if not token then
            broadcastError("Initiative token not found. Don't delete the one I spawn.")
            self.UI.setAttribute("iniPosZeroBtn", "text", "Setup Position Zero")
            self.UI.setAttribute("iniPosZeroBtn", "textColor", "White")
            return
        end

        self.UI.setAttribute("iniPosZeroBtn", "text", "Setup Position Zero")
        self.UI.setAttribute("iniPosZeroBtn", "textColor", "Green")

        local pos = token.getPosition()
        local gm = ""
        local encoded = ""
        local currentGM = iniMat.getGMNotes()
        local initialPos = {
            tonumber(string.format("%.2f", pos.x)),  
            tonumber(string.format("%.2f", pos.y)),  
            tonumber(string.format("%.2f", pos.z))
        }
        if currentGM == "" then
            gm = { initial_pos = initialPos
            }
            encoded = JSON.encode_pretty(gm)
        else
            gm = JSON.decode(currentGM)
            gm.initial_pos = initialPos
            encoded = JSON.encode_pretty(gm)
        end

        _debug(gm)
        _debug(encoded)
        iniMat.setGMNotes(encoded)


        token.destruct()
    end
end

function UI_SetupPlayerInitiativeTokens(player, mouse)
    local iniMat = getObjectFromGUID(_data.components.initiative_mat.guid)
    local iniMatPosition = iniMat.getPosition()
    local iniMatRotation = iniMat.getRotation()
    
    local iniTokenBag = getObjectFromGUID(_data.components.initiative_token.guid)

    local i = 1
    for color, player in pairs(_data.players) do
        local newPos = {x = iniMatPosition.x, y = iniMatPosition.y + 1 + i, z = iniMatPosition.z}
        Wait.time(function()
            iniTokenBag.takeObject({
                position = newPos,
                rotation = iniMatRotation,
                callback_function = function(spawned)
                    Wait.frames(
                        function() 
                            spawned.call(
                                "_init",
                                {
                                    input = {
                                        name = player.name,
                                        modifier = i,
                                        pawn = "",
                                        side = "player",
                                        static = true
                                    }
                                }
                            )
                            spawned.setName("player_token")
                            spawned.setDescription(player.name:lower())
                        end
                    )
                    
                end
            })
            i = i + 1
        end, i * 0.3)
        
    end    
end

function UI_ConfirmInitiativeMat2(player, mouse)
    if getPlayerCount() == 0 then
        broadcastError("No players found. You should add players first.")
        return
    end
    createPlayerPage()
end


function UI_ConfirmPlayerTokens(player, color)
    local input = readInputs({ "playerMiniGUID", "playerManagerGUID"})
    local mini = input["playerMiniGUID"]
    local manager = input["playerManagerGUID"]

    if not exists(mini) or not exists(manager) then
        broadcastError("Invalid input. You should enter a valid GUID.")
        return
    end

    _data.players[color].mini_guid = mini
    _data.players[color].manager_guid = manager

    updateObj(
        getObjectFromGUID(manager),
        "player_manager",
        function(o)
            o.setName(_data.players[color].name)
            o.setDescription(mini)
        end
    )

    Wait.time(function()
        broadcastNotice("Player " .. _data.players[color].name .. " added.")
        createPlayerPage()
    end, 1)

end



-- set and get functions --------------------------------------------------------
function setVersion(component, value)
    _debug("setVersion " .. component .. " " .. value)
    if not _data.components then _data.components = {} end
    if not _data.components[component] then _data.components[component] = { guid = nil, version = nil} end
    _data.components[component].version = value
end

function setComponentGUID(component, guid)
    _debug("setComponentGUID " .. component .. " " .. guid)
    if not _data.components then _data.components = {} end
    if not _data.components[component] then _data.components[component] = { guid = nil, version = nil } end
    _data.components[component].guid = guid
end

function getComponentGUID(component)
    _debug("getComponentGUID " .. component)
    if not _data.components then return nil end
    if not _data.components[component] then return nil end
    return _data.components[component].guid
end

-- string functions ------------------------------------------------------------
function string:trim()
    return (self:gsub("^%s*(.-)%s*$", "%1"))
end

function string:replace(pattern, repl)
    local s = self:gsub(pattern, repl)
    return s
end

function string:contains(str)
    return string.find(self, str) and true or false
end

-- utility functions -----------------------------------------------------------
function broadcastError(msg)
    broadcastToAll(msg, {0.9,0.1,0.1})
end

function broadcastNotice(msg)
    broadcastToAll("[111111](Table Updater)[-]" .. msg, {0.49,0.85,1})
end

function broadcastRestart(prepend)
    if not prepend then prepend = ""
    else
        -- if last character isn't '.' then add one
        if prepend:sub(-1) ~= "." then prepend = prepend .. "." end
        prepend = prepend .. " "
    end
    if not _require_restart then
        _require_restart = true
        broadcastNotice(prepend .. "After finishing your work a restart of the table is required. [FF4136]Remember to save![-]")
    end
end

function _debug(msg)
    if _data.debug then
        log(msg)
    end
end

function needsUpdate(component)
    if component == "_self" then
        if self.memo ~= nil then
            if self.memo ~= _versions[component] then
                return true
            else
                return false
            end
        end
    end

    if not _data.components then _data.components = {} end
    if _data.components[component] then
        local version = _data.components[component].version
        if version and _versions[component] then
            if version ~= _versions[component] then
                _debug(string.format("%s needs update from %s to %s", component, version, _versions[component]))
                return true
            else
                return false
            end
        end
    else
        return true
    end
end

function isInfiniteBag(obj)
    return obj.type == "Infinite"
end

function exists(GUID)
    return getObjectFromGUID(GUID) ~= nil
end

function getObj(GUID)
    local obj = getObjectFromGUID(GUID)
    
    _debug("getObj " .. GUID)
    if obj then
        if isInfiniteBag(obj) then
            _debug("obj is infinite bag")
        else
            _debug("obj is not infinite bag")
            return obj
        end
    end
end

--function getLink(link)
--    _debug("getLink " .. link)
--    local returner = nil
--    WebRequest.get(
--        link,
--        function(request)
--            print(request.response_code)
--            if request.is_error then
--                broadcastError(link .. "\n" .. request.error)
--            else
--                --print(request.text)
--                returner = request.text 
--            end
--        end
--    )
--    printTable(webRequest)
--    return returner
--end

function updateObj(obj, component, callback_function)
    if type(component) ~= "table" then
        _debug("updateObj " .. obj.guid .. " " .. component)
    else
        _debug("updateObj " .. obj.guid .. " " .. component[2])
    end
    
    local link = ""

    if type(component) == "table" then
        link = _URLs[component[1]]
    else link = _URLs[component] end

    if not link then
        broadcastError("No URL found for " .. component)
        return
    end



    if not obj then return end
    
    WebRequest.get(
        link,
        function(request)
            if request.is_error then
                broadcastError(link .. "\n" .. request.error)
            else
                local script = request.text
                obj.setLuaScript(script)
                if obj ~= self then obj = obj.reload() end
                if type(component) == "table" then
                    setComponentGUID(component[2], obj.guid)
                else setComponentGUID(component, obj.guid) end
                
                
                Wait.frames(function() 
                    if component == "player_manager" or component == "initiative_mat" then 
                        broadcastRestart(component == "player_manager" and "Please link the mini." or nil) 
                    end

                    if type(component) == "table" then
                        setVersion(component[1], _versions[component[1]])
                    else setVersion(component, _versions[component]) end
                    
                    if callback_function then callback_function(obj) end
                end,30)
            end
        end
    )
    
end


function capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function split(inputstr, sep)
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

-- function to check if table contains key
function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function removeEmpty(array)
    local newArray = {}
    for i, v in ipairs(array) do
        if v ~= "" then
            table.insert(newArray, v)
        end
    end
    return newArray
end

function updateSave()
    local saved_data = JSON.encode(_data)
    self.script_state = saved_data
end

function getPlayerByName(name)
    for i=1, #_colors do
        local color = _colors[i]
        local player = _data.players[color]
        if player.name == name then
            return player
        end
    end
    return nil
end

function validInput(input)
    if input == nil then return false end
    if input == "" then return false end
    return true
end

function validColor(color)
    for i, c in ipairs(_colors) do
        if c == color then return true end
    end
    return false
end

function emptyPlayers()
    local returner = {}
    for i=1, #_colors do
        returner[_colors[i]] = nil
    end
    return returner
end

function getPlayers()
    _debug("getPlayers")
    if not _data.players then return "" end
    local returner = ""
    for i, player in ipairs(_data.players) do
        returner = returner .. player.name .. "=" .. player.color .. "\n"
    end
    -- remove last \n
    returner = returner:sub(1, -2)
    return returner
end

function addPlayer(color, name)
    _data.players[color] = {
        name = name,
        manager_guid = nil,
        mini_guid = nil
    }
end

function placeInBag(objID, bagID, duplicate)
    _debug("placeInBag " .. objID .. " " .. bagID)

    local obj = getObjectFromGUID(objID)
    local bag = getObjectFromGUID(bagID)
    if not obj then return end
    if not bag then return end

    bag.reset()
    Wait.frames(function()
        if duplicate then
           local clonePos = bag.getPosition()
           clonePos.y = clonePos.y + 5
           obj.clone({
               position = clonePos
           }) 
        else
            bag.putObject(obj)
        end
    end, 15)

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

function len(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end