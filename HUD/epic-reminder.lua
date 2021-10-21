--#region epic-reminder
local _epicBoons = 0
local _initialized = false

function initEpicBoons()
    _epicBoons = 0
    ShowAllReminders()

    _initialized = true
end

function resetEpicBoons()
    local colors = {"White", "Teal", "Brown", "Blue", "Red", "Purple", "Orange", "Pink", "Yellow", "Green"}
    for _, color in ipairs(colors) do
        self.UI.setAttribute(color .. "_Epic_Reminder", "active", false)
        self.UI.setAttribute(color .. "_Epic_Boon_1", "active", false)
        self.UI.setAttribute(color .. "_Epic_Boon_2", "active", false)
        self.UI.setAttribute(color .. "_Epic_Boon_3", "active", false)
        self.UI.setAttribute(color .. "_Epic_Boon_4", "active", false)
        self.UI.setAttribute(color .. "_Epic_Boon_5", "active", false)
        self.UI.setAttribute(color .. "_Epic_Boon_6", "active", false)
    end
    self.UI.setAttribute("Epic_Glow", "active", false)

    _initialized = false
end

function UIEpicReminderOpen(player)
    EpicReminderBreaker(true, player.color)
end

function UIEpicReminderClose(player)
    EpicReminderBreaker(false, player.color)
end

function ShowAllReminders()
    local colors = {"White", "Teal", "Brown", "Blue", "Red", "Purple", "Orange", "Pink", "Yellow", "Green"}
    for _, color in ipairs(colors) do
        self.UI.setAttribute(color .. "_Epic_Reminder", "active", true)
        EpicReminderBreaker(false, color)
    end
    self.UI.setAttribute("Epic_Glow", "active", true)
end

function EpicReminderBreaker(open, color)
    if open then
        self.UI.setAttribute(color .. "_Closed_Reminder", "active", false)
        self.UI.setAttribute(color .. "_Opened_Reminder", "active", true)
    else
        self.UI.setAttribute(color .. "_Closed_Reminder", "active", true)
        self.UI.setAttribute(color .. "_Opened_Reminder", "active", false)
    end
end

function EpicReminderHighlight(color)
    for i = 1, 6, 1 do
        if i % 2 == 1 then
            Wait.time(
                function()
                    self.UI.setAttribute("Epic_Glow", "color", "#B349FD")
                end,
                0.1 * i
            )
        else
            Wait.time(
                function()
                    self.UI.setAttribute("Epic_Glow", "color", "#A52CFA")
                end,
                0.1 * i
            )
        end
    end
end

function AddBoon(params)
    if not _initialized then
        initEpicBoons()
    end

    local boon = params.boon
    local tooltip = params.tooltip

    _epicBoons = _epicBoons + 1
    if tooltip ~= nil and tooltip ~= "" then
        boon = boon .. " ⓘ"
    end
    local colors = {"White", "Teal", "Brown", "Blue", "Red", "Purple", "Orange", "Pink", "Yellow", "Green"}
    for _, color in ipairs(colors) do
        local height = 80 * _epicBoons
        if height > 320 then
            height = 320
        end
        self.UI.setAttribute(color .. "_Epic_Boons", "height", height)
        self.UI.setAttribute(color .. "_Epic_Boon_" .. _epicBoons, "active", true)

        if tooltip ~= nil then
            self.UI.setAttribute(color .. "_Epic_Boon_" .. _epicBoons, "tooltip", tooltip)
        end
        self.UI.setAttribute(color .. "_Epic_Boon_" .. _epicBoons, "text", boon)

        EpicReminderBreaker(true, color)
        EpicReminderHighlight(color)
    end
end

--#endregion
