


-- TODO: Implement saving and loading of variables such as GUIDs and player data etc.


-- Global variables --------------------- DO NOT TOUCH --------------------------
local magic_word = " mr developer "
local _require_restart = false

-- Github urls for the various scripts -- DO NOT TOUCH --------------------------
local _URLs = {
    _v = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/VERSIONS",
    _self = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/.table-updater.lua",
    npc_commander = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/NPC%20Commander.v2.lua",
    monster = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/Monster%20Token/monster.lua",
    initiative_mat = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/Commander%20Gen%202/Initiative%20Stuff/initiative-mat.lua",
    player_manager = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/player_manager/.player-manager.lua",
    initiative_token = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/9ef1586aa51064d1090a6c1e2ddbbda5fa65aabf/Commander%20Gen%202/Initiative%20Stuff/initiative-token.lua",
    note = "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/c58310c81c1a4b08bbd8483360b789a01861b07b/Clever%20Notecard/notecard.lua"
}

-- variable to store versions downloaded from github -----------------------------
local _versions = {
    _self = "0",
    npc_commander = "0",
    monster = "0",
    initiative_mat = "0",
    player_manager = "0"
}

local colors = {
    npc_commander = {
        hex = "#ffe162", 
        rgb = {r = 1, g = 0.882, b = 0.384}
    },
    initiative_mat = {
        hex = "#9acffd" , 
        rgb = {r = 0.603, g = 0.811, b = 0.992}
    },
}

--[[
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
            {
                color = "Red",
                name = "Zora",
                manager_guid = "aa88ii",
                mini_guid = "bb99ii"
            },
            {
                color = "Blue",
                name = "Amber",
                manager_guid = "aa88ii",
                mini_guid = "bb99ii"
            },
            {
                color = "Green",
                name = "Paulo",
                manager_guid = "aa88ii",
                mini_guid = "bb99ii"
            },
            {
                color = "Yellow",
                name = "Gilkan",
                manager_guid = "aa88ii",
                mini_guid = "bb99ii"
            }
        }
    }
--]]

local _data = {
    debug = true
}

-- event functions --------------------------------------------------------------
function onLoad(saved_data)
    if saved_data ~= "" then
        log("Found saved data.")
        _data = JSON.decode(saved_data)
        _debug(_data)
    end
    checkForUpdates()
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
            elseif command == "bump" then                
                if args[2] then
                    broadcastNotice("Bumping " .. args[2] .. " to latest version...")
                    bump(args[2])
                else
                    broadcastNotice("Bumping all to latest version...")
                    bump()
                end
            elseif command == "debug" then
                _data.debug = not _data.debug
                if _data.debug then
                    broadcastNotice("Debugging is now on.")
                else
                    broadcastNotice("Debugging is now off.")
                end
            end

        end
    end
end

function start()    
    processVersions()
    startUI()
end

function processVersions()
    _debug("processVersions")
    WebRequest.get(
        _URLs._v,
        function(request)
            print(request.response_code)
            if request.is_error then
                broadcastError(link .. "\n" .. request.error)
            else
                local versions = request.text
                _debug("processVersions versions found")
                _debug(versions)
                local lines = strsplit(versions, "\n")
                lines = removeEmpty(lines)
                for i, line in ipairs(lines) do
                    local splitLine = strsplit(line, " ")
                    if splitLine[1] and splitLine[2] then
                        _versions[splitLine[1]] = splitLine[2]
                    end
                end
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
            broadcastNotice(component .. " needs an update.")
        end
    end
end

function updateAll()
    _debug("updateAll")
    -- TODO: Implement function
    
    broadcastRestart()
end

-- UI mod functions -------------------------------------------------------------

local _defaultHeight = 114
local _defaultWidth = 500
function startUI()
    _debug("startUI")
    
    local _, p = getPanel()
    if p ~= nil then return end

    local panel = {
        tag = "Panel",
        attributes = {
            id = "main",
            position = "0 150 -10",
            rotation = "180 180 0",
            width = _defaultWidth,
            height = _defaultHeight
        },
        children = {
            createButton("New Table", "34 38", "200", "38", "UI_NewTable", nil),
            createButton("Update Table", "274 38", "200", "38", "UI_UpdateTable", nil),
        }
    }
    local xml = self.UI.getXmlTable()
    xml = table.insert(xml, panel)
    self.UI.setXmlTable(xml)
end

function negatePos(position)
    local x = tonumber(split(position, " ")[1])
    local y = tonumber(split(position, " ")[2])

    y = y * -1

    return x .. " " .. y
end

function createInput(placeholder, position, id, width, height, linetype, text)
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
            value = text or ""
        }
    }
end

function createText(text, position, class)    
    position = negatePos(position)
    return {
        tag = "Text",
        attributes = {
            offsetXY = position,
            rotation = "0 0 0",
            text = text,
            class = class
        }
    }
end

function createButton(text, position, width, height, click_function, id)
    position = negatePos(position)
    return {
        tag = "Button",
        attributes = {
            id = id,
            offsetXY = position,
            text = text,
            width = width,
            height = height,
            onClick = click_function
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

-- UI functions -----------------------------------------------------------------
function UI_UpdateInput(player, value, id)
    self.UI.setAttribute(id, "value", value)
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

    _data.players = {}
    for i, line in ipairs(lines) do
        local splitLine = split(line, "=")
        if splitLine[1] and splitLine[2] then
            local name = splitLine[1]
            local color = splitLine[2]
            color = capitalize(color)
            if not validInput(name) or not validInput(color) then
                broadcastError("Invalid input. Please try again.")
                return
            end

            if not validColor(color) then
                broadcastError("Error in color parsing. Please try again.")
                return
            end

            addPlayer(name, color)
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
    
    --local script = getLink(_URLs["npc_commander"])
    --Wait.time(
    --    function()
    --        updateObj(
    --            getObjectFromGUID(input),
    --            "npc_commander",
    --            script,
    --            function()
    --                setComponentGUID("npc_commander", input)
    --                broadcastNotice("NPC Commander GUID has been set and it has been updated.")
    --            end
    --        )
    --    end
    --, 3)
    updateObj(
        getObjectFromGUID(input),
        "npc_commander",
        function()
            setComponentGUID("npc_commander", input)
            broadcastNotice("NPC Commander GUID has been set and it has been updated.")
        end
    )

    

    emptyUI()
    setPanel(456, 298)

    local xml, panel = getPanel()
    panel.children = {
        createColorBand("npc_commander", 298),
        createText("NPC Commander", "22 3", "title npc_commander"),
        -----------------------------------------------------------
        createText("Monster tokens are the monsters that do not have an image (generic monsters)", "22 24", "npc_commander"),
        createInput("Monster token GUID...", "22 44", "monsterTokenGUIDInput", 210, 30),
        createInput("Monster bag GUID...", "235 44", "monsterBagGUIDInput", 210, 30),
        -----------------------------------------------------------
        createText("Boss tokens are the monsters that have an image (such as bosses)", "22 79", "npc_commander"),
        createInput("Boss token GUID...", "22 99", "bossTokenGUIDInput", 210, 30),
        createInput("Boss bag GUID...", "235 99", "bossBagGUIDInput", 210, 30),
        -----------------------------------------------------------
        createText("Initiative tokens are the items that allow to track initiative in combat", "22 134", "npc_commander"),
        createInput("Initiative token GUID...", "22 154", "initiativeTokenGUIDInput", 210, 30),
        createInput("Initiative bag GUID...", "235 154", "initiativeBagGUIDInput", 210, 30),
        -----------------------------------------------------------
        createText("Notes are used to store monster information (optional element)", "22 189", "npc_commander"),
        createInput("Parsing note GUID...", "22 209", "noteTokenGUIDInput", 210, 30),
        createInput("Parsing note bag GUID...", "235 209", "noteBagGUIDInput", 210, 30),
        -----------------------------------------------------------
        createButton("Confirm", "131 250", 195, 38, "UI_ConfirmTokens", nil)
    }
    setUI(xml)
end

function UI_ConfirmTokens(player, mouse)
    local input = readInputs({
        "monsterTokenGUIDInput", "monsterBagGUIDInput", 
        "bossTokenGUIDInput", "bossBagGUIDInput", 
        "initiativeTokenGUIDInput", "initiativeBagGUIDInput", 
        "noteTokenGUIDInput", "noteBagGUIDInput"
    })
    
    -- processing monsterTokenGUIDInput and monsterBagGUIDInput
    local monsterTokenGUID = input["monsterTokenGUIDInput"]:trim()
    local monsterBagGUID = input["monsterBagGUIDInput"]:trim()
    if not validInput(monsterTokenGUID) or not validInput(monsterBagGUID) then
        broadcastError("Invalid monster token input. Please try again.")
        return
    end
    if not exists(monsterTokenGUID) or not exists(monsterBagGUID) then
        broadcastError("Invalid monster token GUID. Please try again.")
        return
    end

    updateObj(
        getObjectFromGUID(monsterTokenGUID), 
        "monster", 
        function()
            placeInBag(monsterTokenGUID, monsterBagGUID)
            setComponentGUID("monster", monsterBagGUID) 
        end
    )    
    

    -- processing bossTokenGUIDInput and bossBagGUIDInput
    local bossTokenGUID = input["bossTokenGUIDInput"]:trim()
    local bossBagGUID = input["bossBagGUIDInput"]:trim()
    if not validInput(bossTokenGUID) or not validInput(bossBagGUID) then
        broadcastError("Invalid boss token input. Please try again.")
        return
    end
    if not exists(bossTokenGUID) or not exists(bossBagGUID) then
        broadcastError("Invalid boss token GUID. Please try again.")
        return
    end
    updateObj(
        getObjectFromGUID(bossTokenGUID), 
        {"monster", "boss"}, 
        function()
            placeInBag(bossTokenGUID, bossBagGUID)
            setComponentGUID("boss", bossBagGUID) 
        end
    )        

    -- processing initiativeTokenGUIDInput and initiativeBagGUIDInput
    local initiativeTokenGUID = input["initiativeTokenGUIDInput"]:trim()
    local initiativeBagGUID = input["initiativeBagGUIDInput"]:trim()
    if not validInput(initiativeTokenGUID) or not validInput(initiativeBagGUID) then
        broadcastError("Invalid initiative token input. Please try again.")
        return
    end
    if not exists(initiativeTokenGUID) or not exists(initiativeBagGUID) then
        broadcastError("Invalid initiative token GUID. Please try again.")
        return
    end
    updateObj(
        getObjectFromGUID(initiativeTokenGUID), 
        "initiative_token", 
        function()
            placeInBag(initiativeTokenGUID, initiativeBagGUID)
            setComponentGUID("initiative_token", initiativeBagGUID) 
        end
    )
    

    -- processing noteTokenGUIDInput and noteBagGUIDInput
    -- this set of inputs are optional
    local noteTokenGUID = input["noteTokenGUIDInput"]:trim()
    local noteBagGUID = input["noteBagGUIDInput"]:trim()
    if validInput(noteTokenGUID) and validInput(noteBagGUID) then
        if not exists(noteTokenGUID) or not exists(noteBagGUID) then
            broadcastError("Invalid note token GUID. Please try again.")
            return
        end
        updateObj(
            getObjectFromGUID(noteTokenGUID), 
            "note", 
            function()
                placeInBag(noteTokenGUID, noteBagGUID)
                setComponentGUID("note", noteBagGUID) 
            end
        )
        
    end

    broadcastNotice("Tokens have been setup.")

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
    setPanel(375, 181)


    local xml, panel = getPanel()
    panel.children = {
        createColorBand("initiative_mat", 181),
        createText("Initiative Mat", "22 3", "title initiative_mat"),
        createText("When pressing the zone button a new scripting zone will be created. Select it with the GIZMO tool (F8) and make it as big as the initiative mat, then click the button again", "22 25", "initiative_mat"),
        createButton("Setup Initiative Zone", "22 71", 301, 27, "UI_SetupInitiativeZone", "iniZoneBtn"),
        createButton("Setup Player Initiative Tokens", "22 100", 301, 27, "UI_SetupPlayerInitiativeTokens", nil),
        createButton("Confirm", "68 135", 195, 38, "UI_ConfirmInitiativeMat2", nil)
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
            function()
                broadcastNotice("Initiative zone has been setup.")
                -- TODO: Add way to make starting zone
                local gm = { zone = area.guid }
                iniMat.setGMNotes(JSON.encode_pretty(gm))
            end
        )
    end
end

function UI_SetupPlayerInitiativeTokens(player, mouse)
    local iniMat = getObjectFromGUID(_data.components.initiative_mat.guid)
    local iniMatPosition = iniMat.getPosition()
    local iniMatRotation = iniMat.getRotation()
    
    local iniTokenBag = getObjectFromGUID(_data.components.initiative.guid)
    for i, player in ipairs(_data.players) do
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
        end, i * 0.1)
    end    
end


function UI_ConfirmInitiativeMat2(player, mouse)
    -- TODO: Implement rest of the form
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
    broadcastToAll(msg, {0.49,0.85,1})
end

function broadcastRestart(prepend)
    if not prepend then prepend = ""
    else
        -- if last character isn't '.' then add one
        if prepend:sub(-1) ~= "." then prepend = prepend .. "." end
        prepend = prepend .. "\n" 
    end
    if not _require_restart then
        _require_restart = true
        broadcastNotice(prepend .. "After finishing your work a restart of the table is required.\nRemember to save!")
    end
end

function _debug(msg)
    if _data.debug then
        log(msg)
    end
end

function needsUpdate(component)
    if _data[component] then
        local version = _data[component].version
        if version and _versions[component] then
            if version ~= _versions[component] then
                return true
            end
        end
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
            -- TODO: Implement way to extract item from bag, update it and drop it back in the bag
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
    log(type(component))
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
            print(request.response_code)
            if request.is_error then
                broadcastError(link .. "\n" .. request.error)
            else
                local script = request.text
                obj.setLuaScript(script)
                obj.reload()
                
                Wait.frames(function() 
    
    
                    if component == "player_manager" or component == "initiative_mat" then 
                        broadcastRestart("Please link the mini.") 
                    end

                    if not _data.debug then
                        setVersion(component, _versions[component])
                    end
                    if callback_function then callback_function() end
                end,20)
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

function getPlayerByColor(color)
    for i=1, #_data.players do
        if _data.players[i].color == color then
            return _data.players[i]
        end
    end
    return nil
end

function getPlayerByName(name)
    for i=1, #_data.players do
        if _data.players[i].name == name then
            return _data.players[i]
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
    local colors = {"Green", "Purple", "Red", "Blue", "Yellow", "Brown", "White", "Teal", "Orange", "Pink"}
    for i, c in ipairs(colors) do
        if c == color then return true end
    end
    return false
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

function addPlayer(name, color)
    local player = {name = name, color = color}
    table.insert(_data.players, player)
end

function placeInBag(objID, bagID)
    local obj = getObjectFromGUID(objID)
    local bag = getObjectFromGUID(bagID)
    if not obj then return end
    if not bag then return end

    bag.reset()
    Wait.frames(function() bag.putObject(obj) end, 15)

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