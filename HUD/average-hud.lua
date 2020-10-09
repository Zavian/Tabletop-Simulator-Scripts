--#region average hud
local _average_notecard = nil
local averages = {}

function showHuds(params)
    -- i'll receive params which is all the colors that i have to show the huds of
    _average_notecard = params.notecard
    for i = 1, #params.players do
        self.UI.setAttribute(params.players[i]:lower() .. "_average_box", "active", "true")
        averages = {}
    end
end

function submitAverage(player, request)
    if not averages[player.color] or averages[player.color] == "" then
        broadcastToColor("You need to insert a number in the box!", player.color, Color.Red)
        return
    end
    -- i'll receive the info for the notecard to read
    self.UI.setAttribute(player.color:lower() .. "_average_box", "active", "false")
    self.UI.setAttribute(player.color:lower() .. "_average", "text", "")
    local notecard = getObjectFromGUID(_average_notecard)
    if notecard then
        local crit = nil
        if request ~= "-1" then
            crit = request == "crit" and 20 or 1
        end
        log(crit)
        notecard.call(
            "setData",
            {
                color = player.color,
                avg = averages[player.color],
                crit = crit
            }
        )
    end
end

function updateAverage(player, value, obj)
    averages[player.color] = value
end
--#endregion
