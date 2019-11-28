--[[
| Number | Name                            |    |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |
| x      | _______________________________ | 🖊 |

legend size:
w410 h30
y140 z-15
scale 1 1 1

    API REQUIRED
    - CREATE NEW INITIATIVE
        PARAMS:
            ID > SAME AS FROM THE MASTER
            TOKEN
            COLOR
            DATA
                NAME
                INITIATIVE
            
    - DELETE INITIATIVE (BASED ON ID)
    - EDIT CONTENTS OF ANY INITIATIVE
    - CHANGE COLORS OF THE INITIATIVE
        RED     > ENEMY
        BLUE    > PLAYER
        GREEN   > ALLY
        YELLOW > NEUTRAL
    ???

    TIPS
    Make all player initiative tokens different color
]] --

local _debug = true

local _objects = 0

local const = {
    ini_size = 37.5,
    colors = {
        PLAYER = {bg = "#0000b5", fg = "#c1dffc"},
        ENEMY = {bg = "#b70126", fg = "#FECACA"},
        ALLY = {bg = "#009348", fg = "#ecfdca"},
        NEUTRAL = {bg = "#fdd000", fg = "#FFFFAE"}
    }
}

function onLoad()
    if _debug then
        self.createButton(
            {
                click_function = "kek",
                function_owner = self,
                label = "Create",
                position = {0.2, 0.7, 6.7},
                rotation = {0, 180, 0},
                scale = {0.9, 1.2, 0.9},
                width = 1600,
                height = 380,
                font_size = 320,
                color = {0.7961, 0.2732, 0.2732, 1}
            }
        )
    end
end

function kek()
    local xmlTable = self.UI.getXmlTable()
    printTable(xmlTable)
end

function initiative(payload) --
    --[[
        params:
            id
            owner token
            color
            data {initiative, name}
        <HorizontalLayout class="even-enemy">
            <Toggle />
            <InputField text="17" />
            <Text class="name" text="Paul" />
            <Button>↓</Button>
        </HorizontalLayout>
    ]]
    if _debug then
        printTable(payload)
    end

    local xmlTable = self.UI.getXmlTable()
    --printTable(xmlTable)
    --printTable(xmlTable[3].children[1])
    if not xmlTable[3].children[1].children[1].children then
        xmlTable[3].children[1].children[1].children = {}
    end

    if not payload.forceInitiative then
        payload.data.initiative_rolled = calculateInitiative(payload.data.initiative)
    end

    local row_color = findColor(payload.color, payload.id % 2)
    --local tokenId = payload.owner.getGUID()
    local toAdd = {
        tag = "HorizontalLayout",
        attributes = {
            id = payload.id,
            class = row_color
        },
        children = {
            -- toggle
            {
                tag = "Toggle",
                attributes = {
                    id = "toggle-" .. payload.id
                }
            },
            -- initiative
            {
                tag = "InputField",
                attributes = {
                    text = payload.data.initiative_rolled,
                    id = "initiative-" .. payload.data.name
                }
            },
            -- name
            {
                tag = "Text",
                attributes = {
                    class = "name",
                    text = payload.data.name,
                    id = "name-" .. payload.id
                }
            },
            {
                tag = "Button",
                attributes = {
                    id = "locate-" .. payload.id,
                    onClick = self.getGUID() .. "/UI_Locate(" .. payload.owner .. ")"
                },
                value = "↓"
            }
        }
    }
    table.insert(xmlTable[3].children[1].children[1].children, toAdd)
    _objects = _objects + 1
    updateTable(xmlTable)
end

function findColor(color, excess)
    local number_type = excess == 0 and "odd" or "even"
    color = string.lower(color)
    if _debug then
        print(number_type)
        print(color)
    end

    return number_type .. "-" .. color
end

function calculateInitiative(modifier)
    local roll = math.random(1, 20)
    if _debug then
        print(roll)
        print(modifier)
    end
    return roll + modifier
end

function UI_Locate(player, payload, sender_id)
    local token = getObjectFromGUID(payload)
    --if _debug then
    --    print(player)
    --    print(payload)
    --    print("trying to find " .. tokenId)
    --end
    if token then
        player.pingTable(token.getPosition())
        token.call("toggleVisualize", {input = true})
    end
end

function updateTable(xmlTable)
    xmlTable[3].children[1].attributes.height = _objects and const.ini_size * _objects or const.ini_size
    self.UI.setXmlTable(xmlTable)
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
