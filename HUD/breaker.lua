-- #region breaker
function UI_SideToggle()
    local offset = self.UI.getAttribute("TopButton", "offsetXY")
    local closed = offset == "75 5"

    if closed then
        -- to open
        -- button stuff
        self.UI.setAttribute("TopButton", "offsetXY", "75 -182")
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
    local half = string.find(id, "Half") ~= nil

    local text = tonumber(_MassField)
    if half then
        text = math.floor(text / 2)
    end

    local objs = Player[player.color].getSelectedObjects()
    for i = 1, #objs do
        local gm = objs[i].getGMNotes()
        if gm == "monster_token" or gm == "boss_token" then
            local val = (id == "MassDamage" or id == "MassDamageHalf") and text * -1 or text

            local t = string.gsub(id, "Mass", "")
            t = string.gsub(t, "Half", "")
            objs[i].call(
                "GlobalCalculate",
                {
                    input = val,
                    t = t
                }
            )
        end
    end
end

function UI_UpdateMassHp(player, value)
    _MassField = value
end

local _MassModifier = ""
function UI_MassRoll(player, request, id)
    local mode = ""
    if id == "MassRollAdv" then
        mode = "adv"
    elseif id == "MassRollDis" then
        mode = "dis"
    else
        mode = nil
    end

    local text = tonumber(_MassModifier)
    if not text then
        text = 0
    end

    local objs = Player[player.color].getSelectedObjects()
    for i = 1, #objs do
        local gm = objs[i].getGMNotes()
        if gm == "monster_token" or gm == "boss_token" then
            Wait.time(
                function()
                    objs[i].call("GlobalRoll", {input = text, mode = mode})
                end,
                math.random(0.2, 0.8)
            )
        end
    end
end

function UI_UpdateMassMod(player, value)
    _MassModifier = value
end
-- #endregion
