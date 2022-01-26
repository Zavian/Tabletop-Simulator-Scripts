--[[StartXML
<Defaults>
    <Text class="title" fontSize="25" alignment="MiddleCenter" />
    <Text class="description" fontSize="14" alignment="UpperLeft" />

</Defaults>
<Text id="title" class="title" rotation="180 180 0" position="0 -110 -10" width="400" height="50">Title</Text>
<Text id="description" class="description" rotation="180 180 0" position="0 30 -10" width="400" height="220">Description</Text>
StopXML--xml]]


function loadXML()
    local script = self.getLuaScript()
    local xml = script:sub(script:find("StartXML")+8, script:find("StopXML")-1)
    self.UI.setXml(xml)
    Wait.frames(function() setData() end, 20)
end

local commander = "878b50"

function onload()
    loadXML()
    
    local data = {
        click_function = "parse",
        function_owner = self,
        label = "Parse",
        position = {1.92, 0.1, 1.33},
        scale = {0.3, 0.3, 0.3},
        width = 1200,
        height = 500,
        font_size = 400,
        color = {0.1341, 0.1341, 0.1341, 1},
        font_color = {1, 1, 1, 1},
        tooltip = "Parse"
    }

    self.addContextMenuItem("Set Commander", function(player)
        if Player[player].admin then
            local guid = self.getName()
            local obj = getObjectFromGUID(guid)
            if not obj then
                broadcastToColor("You must write the NPC Commander ID as the name of the notecard.", "Black", Color.White)
            else
                self.memo = guid
            end
        end
    end, false)
    self.createButton(data)
end

function onHover()
    setData()
end

function setData()
    self.UI.setAttribute("title", "text", self.getName())
    self.UI.setAttribute("description", "text", self.getDescription())
end

function parse()
    if self.getDescription() ~= "" and self.getName() ~= "" then
        local vars = JSON.decode(self.getDescription())
        local npc_commander = getObjectFromGUID(self.memo or commander)

        if vars.name then
            npc_commander.call("setName", {input = vars.name})
        end

        if vars.ini then
            npc_commander.call("setINI", {input = vars.ini})
        end

        if vars.hp then
            npc_commander.call("setHP", {input = vars.hp})
        end

        if vars.ac then
            npc_commander.call("setAC", {input = vars.ac})
        end

        if vars.mov then
            npc_commander.call("setMovement", {input = vars.mov})
        end

        if vars.size then
            npc_commander.call("setSize", {input = vars.size})
        end

        if vars.image then
            npc_commander.setDescription(vars.image)
            npc_commander.call("toggleIsBoss", {input = true})
        else
            npc_commander.call("toggleIsBoss", {input = false})
        end

        if vars.side then
            npc_commander.call("setSide", {input = vars.side})
        else
            npc_commander.call("setSide", {input = "enemy"})
        end

        if vars.extra then
            npc_commander.call("setExtraParams", vars.extra)
        else
            npc_commander.call("setExtraParams", nil)
        end

        if self.getGMNotes() ~= "" then
            -- this means i have multiple that i want to make
            local number = tonumber(self.getGMNotes())
            npc_commander.call("setNumberToCreate", {input = number})
        else
            npc_commander.call("setNumberToCreate", {input = 1})
        end
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
