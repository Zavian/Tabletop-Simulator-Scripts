function onLoad()
    local zloc = 0.1

    self.createButton(
        {
            click_function = "get_code",
            function_owner = self,
            label = "Get Code",
            position = {1.46, zloc, -0.5},
            scale = {0.5, 0.5, 0.5},
            width = 2000,
            height = 400,
            font_size = 400,
            color = Color.Teal,
            tooltip = "[b][75bfff]Get[-][/b] the code of the object which ID is in the description."
        }
    )

    self.createButton(
        {
            click_function = "set_singular_code",
            function_owner = self,
            label = "Set Code",
            position = {1.3, zloc, -0.05},
            scale = {0.5, 0.5, 0.5},
            width = 1400,
            height = 400,
            font_size = 300,
            tooltip = "[b][75bfff]Set[-][/b] the code of the object which ID is in the description."
        }
    )

    self.createButton(
        {
            click_function = "create_area",
            function_owner = self,
            label = "Bulk Set",
            position = {1.2, zloc, 0.4},
            scale = {0.5, 0.5, 0.5},
            width = 1500,
            height = 400,
            font_size = 300,
            color = {0.956, 0.392, 0.113, 1},
            tooltip = "Be careful with this. Follow these instructions:\n" ..
                "[969696]1.[-] Click this button with your left click. This will create an area over this object, place it over the objects you want to bulk modify.\n" ..
                    "[969696]2.[-] Click this button with your right click and confirm that the objects found are the ones you want to bulk modify.\n" ..
                        "[969696]3.[-] Click this button with your right click again and everything will be set."
        }
    )

    self.createButton(
        {
            click_function = "get_online_code",
            function_owner = self,
            label = "Download\nOnline",
            position = {-1.2, zloc, 0},
            scale = {0.5, 0.5, 0.5},
            width = 1500,
            height = 600,
            font_size = 200,
            color = {0.4313, 0.3294, 0.5804, 1},
            font_color = {1, 1, 1, 1},
            tooltip = "Insert a link in the name of the object and I'll store that code."
        }
    )
end

function onCollisionEnter(info)
    local obj = info.collision_object
    if obj.interactable then
        if obj.getGUID() then
            self.setDescription(obj.getGUID())

            printc("I have found a new object! Check its ID: " .. self.getDescription())
            obj.highlightOn(Color.Teal, 1)
        end
    end
end

local _storedScript = ""
local _oldObj = nil
function get_code(obj, player_clicker_color)
    local desc = self.getDescription()
    local obj = getObject()
    if obj then
        _storedScript = obj.getLuaScript()
        local name = obj.getName() ~= "" and obj.getName() or obj.getGUID()
        printc("I got " .. name .. "'s code. You can paste it somewhere now.", player_clicker_color)

        if _oldObj then
            _oldObj.highlightOff(Color.Teal)
        end
        obj.highlightOn(Color.Teal)
        _oldObj = obj
    end
end

local _area = nil
local _objectList = nil
local _waitingForConfirmation = false
function create_area(owner, color, alt_click)
    if _storedScript == "" then
        printc("Can't do this if you don't have a script!", color)
        return
    end
    if not alt_click then
        -- RESETTING STUFF -----------------------
        if _area then
            destroyObject(_area)
            _area = nil
        end
        if _waitingForConfirmation then
            _waitingForConfirmation = false
        end
        if _objectList ~= nil then
            resetHighlight(_objectList)
            _objectList = nil
        end
        ------------------------------------------

        positionToZone = self.getPosition()
        spawnParams = {
            type = "ScriptingTrigger",
            position = positionToZone,
            rotation = {x = 0, y = 90, z = 0},
            scale = {x = 4, y = 4, z = 4},
            sound = false,
            snap_to_grid = true
        }
        _area = spawnObject(spawnParams)
    else
        if not _waitingForConfirmation then
            if _area then
                local objs = _area.getObjects()
                local found = 0
                local array = {}
                for i = 1, #objs do
                    obj = objs[i]
                    if obj.interactable and obj ~= self and obj ~= _oldObj then
                        table.insert(array, obj)
                        found = found + 1

                        obj.highlightOn(Color.Red)
                    end
                end

                print(
                    "Found " ..
                        found ..
                            " objects. [b98cf2][b]Right click again to confirm[/b][-], [4eb1ff][b]else left click again[/b][-]."
                )
                _waitingForConfirmation = true
                _objectList = array
            end
        else
            for i = 1, #_objectList do
                setCode(_objectList[i])
            end
            reset()
        end
    end
end

function set_singular_code(owner, color, alt_click)
    if _storedScript == "" then
        printc("Can't do this if you don't have a script!", color)
        return
    end
    if not _waitingForConfirmation then
        local obj = getObject()
        if obj and obj ~= _oldObj and obj ~= self then
            setCode(obj)
        else
            if obj == self then
                local gm = self.getGMNotes()
                if gm == "debug" then
                    setCode(obj)
                end
            else
                printc("You gotta select an object that is not me or the old object!", color)
            end
            return
        end
        reset()
    else
        printc("Use the other button and right click it!", color)
    end
end

function get_online_code(obj, player_clicker_color, alt_click)
    local name = self.getName()
    if not validDomain(name) then
        printc("Invalid link.", player_clicker_color, Color.Red)
        return
    end

    if name:find("hastebin", 1, true) then
        name = hastebinParser(name)
    end
    
    if name:find("pastebin", 1, true) then
       name = pastebinParser(name) 
    end

    if name:find("pastery", 1, true) then
        name = pasteryParser(name)
    end
    WebRequest.get(
        name,
        function(request)
            if request.is_error then
                printc(request.error, player_clicker_color, Color.Red)
            else
                _storedScript = request.text
                if _storedScript == '{"message":"Document not found."}' then
                    printc(
                        "[FF4136]The code doesn't seem to be existing...\nRequest url: " .. name .. "[-]",
                        player_clicker_color,
                        Color.White
                    )
                else
                    printc("[4eb1ff]Code found! You can now paste it somewhere.[-]", player_clicker_color, Color.White)
                end
            end
        end
    )
end

function hastebinParser(url)
    local rawPattern = "^.+/raw/.+$"

    log(url)

    if not url:find(".lua") then
        url = url .. ".lua"
    end

    if not url:find(rawPattern) then
        local pageNamePattern = "^.+/(.+)%..+$"
        local _,
            _,
            pageName = url:find(pageNamePattern)
        url = "https://hastebin.com/raw/" .. pageName
    end

    log(url)

    return url
end

function pasteryParser(url) 
    -- find if there is /raw/ at the end
    -- if so, simply return the url
    if url:find("/raw/") then
        return url
    end
    -- if url ends with / then add raw/ else add /raw/
    if url:sub(-1) == "/" then
        url = url .. "raw/"
    else
        url = url .. "/raw/"
    end
    return url

end

function pastebinParser(url)
    if url:find("https://pastebin.com/raw/") then
        return url
    end



    local rawPattern = "^.+/raw/.+$"

    log(url)

    -- if not url:find(".lua") then
    --     url = url .. ".lua"
    -- end

    if not url:find(rawPattern) then
        local pageNamePattern = "^.+/(.+)$"
        local _,
            _,
            pageName = url:find(pageNamePattern)
        url = "https://pastebin.com/raw/" .. pageName
    end

    log(url)

    return url
end

function validDomain(name)
    local domains = {
        "https://raw.githubusercontent.com/Zavian/Tabletop-Simulator-Scripts/master/",
        "https://hastebin.com/",
        "https://pastebin.com/raw/",
        "https://pastebin.com/",
        "https://www.pastery.net/"
    }

    local valid = false

    for i = 1, #domains do
        if name:find(domains[i], 1, true) then
            valid = true
        end
    end
    return valid
end

function setCode(obj)
    obj.setLuaScript(_storedScript)
    obj.highlightOn(Color.Green, 1)
    Wait.time(
        function()
            obj.reload()
        end,
        1
    )
end

function resetHighlight(objs)
    for i = 1, #objs do
        objs[i].highlightOff(Color.Red)
    end
end

function printc(text, playerColor, color)
    if not color then
        color = Color.White
    end
    if not playerColor then
        playerColor = "Black"
    end

    printToColor(text, playerColor, color)
end

function reset()
    _waitingForConfirmation = false
    _objectList = nil

    if _oldObj then
        _oldObj.highlightOff(Color.Teal)
        _oldObj = nil
    end

    _storedScript = nil
end

function getObject()
    local desc = self.getDescription()
    if desc ~= "" then
        local obj = getObjectFromGUID(desc)
        return obj
    end
end