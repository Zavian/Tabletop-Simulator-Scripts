--local commander = "9d42ad"
local commander = "878b50"

function onLoad()
    local data = {
        click_function = "parse",
        function_owner = self,
        label = "Parse",
        position = {-0.39, 2.4, -0.43},
        rotation = {0, 180, 0},
        scale = {0.1, 1, 0.18},
        width = 1100,
        height = 400,
        font_size = 400,
        color = {0.1341, 0.1341, 0.1341, 1},
        font_color = {1, 1, 1, 1}
    }
    self.createButton(data)
end

--/|2|r50-68|12|6|2d6+4

function parse()
    if self.getDescription() ~= "" and self.getName() ~= "" then
        local stuff = mysplit(mysplit(self.getDescription(), "\n")[1], "|")
        local npc_commander = getObjectFromGUID(commander)
        npc_commander.call("setName", {input = stuff[1]})
        npc_commander.call("setINI", {input = stuff[2]})
        npc_commander.call("setHP", {input = stuff[3]})
        npc_commander.call("setAC", {input = stuff[4]})
        npc_commander.call("setATK", {input = stuff[5]})
        npc_commander.call("setDMG", {input = stuff[6]})

        if stuff[7] then
            npc_commander.call("setMovement", {input = stuff[7]})
        end

        if stuff[8] then
            npc_commander.call("setSize", {input = stuff[8]})
        end

        local second_line = mysplit(self.getDescription(), "\n")[2]
        if second_line ~= nil and second_line ~= "" then
            -- this means it is a boss
            npc_commander.setDescription(second_line)
            npc_commander.call("toggleIsBoss", {input = true})
        else
            npc_commander.call("toggleIsBoss", {input = false})
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
