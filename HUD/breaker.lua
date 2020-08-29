-- #region breaker
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
-- #endregion
