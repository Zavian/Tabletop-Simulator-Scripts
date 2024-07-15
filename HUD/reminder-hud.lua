-- #region reminder-hud
function UI_ReminderSave()
    local pattern = "%(([^)]+)%)"
    local textToMatch = self.UI.getAttribute("reminder_details", "text")

    local guid = string.match(textToMatch, pattern)

    if guid then
        local reminder_start = self.UI.getAttribute("reminder_input_start", "value")
        local reminder_end = self.UI.getAttribute("reminder_input_end", "value")


        -- Why the _start and _end? because that's how it's written in monster.lua
        local pawn = getObjectFromGUID(guid)
        if reminder_start ~= "" then
            pawn.call("setReminder", {time = "_start", message = reminder_start})
        end

        if reminder_end ~= "" then
            pawn.call("setReminder", {time = "_end", message = reminder_end})
        end

    else
        broadcastToColor("Invalid GUID", "Black", "White")
    end
    self.UI.hdie("reminder_dialogue")
end

function UI_ReminderClose()
    self.UI.hide("reminder_dialogue")
end

-- #endregion