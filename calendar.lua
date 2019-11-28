local _UI = {
    year = "yearValue",
    month = {
        v = "monthValue",
        f = "monthForward",
        b = "monthBackward",
        t = "monthText"
    }
}

local months = {
    {m = "january", c = "white"},
    {m = "february", c = "white"},
    {m = "march", c = "black"},
    {m = "april", c = "black"},
    {m = "may", c = "white"},
    {m = "june", c = "black"},
    {m = "july", c = "white"},
    {m = "august", c = "black"},
    {m = "september", c = "white"},
    {m = "october", c = "black"},
    {m = "november", c = "black"},
    {m = "december", c = "white"}
}

function parseMonth(month)
    month = month:lower()
    for i = 1, #months do
        if month == months[i].m then
            return i
        end
    end
    return -1
end

function UIYearBackward(key, value)
    local year = self.UI.getAttribute(_UI.year)
    year = year - 1
    self.UI.setAttribute(_UI.year, "text", year)
end

function UIYearForward(key, value)
    print("kek")
    local year = self.UI.getAttribute(_UI.year)
    year = year + 1
    self.UI.setAttribute(_UI.year, "text", year)
end

function UIMonthForward(key, value)
    local month = self.UI.getAttribute(_UI.month.v)
    local n = parseMonth(month)
    if n ~= -1 then
        n = n + 1
        self.UI.setAttribute(_UI.month.v, "class", months[n].m)
        self.UI.setAttribute(_UI.month.v, "text", months[n].m)
        self.UI.setAttribute(_UI.month.t, "class", months[n].m)
        self.UI.setAttribute(_UI.month.f, "class", "main " .. months[n].m)
        self.UI.setAttribute(_UI.month.b, "class", "main " .. months[n].m)
    end
    self.UI.setAttribute(_UI.year, "text", year)
end

function UIMonthBackward(key, value)
    local month = self.UI.getAttribute(_UI.month.v)
    local n = parseMonth(month)
    if n ~= -1 then
        n = n - 1
        if n == 0 then
            n = 12
        end
        self.UI.setAttribute(_UI.month.v, "class", months[n].m)
        self.UI.setAttribute(_UI.month.v, "text", months[n].m)
        self.UI.setAttribute(_UI.month.t, "class", months[n].m)
        self.UI.setAttribute(_UI.month.f, "class", "main " .. months[n].m)
        self.UI.setAttribute(_UI.month.b, "class", "main " .. months[n].m)
    end
    self.UI.setAttribute(_UI.year, "text", year)
end

function onload()
    --self.UI.setAttribute("yearForward", "onClick", self.getGUID() .. "/UIYearForward(value)")
    --print(self.getGUID() .. "/UIYearForward()")
    --self.UI.setAttribute("yearBackward", "onClick", self.getGUID() .. "/UIYearBackward(value)")
    --print(self.getGUID() .. "/UIYearBackward()")
    --
    --self.UI.setAttribute("monthForward", "onClick", self.getGUID() .. "/UIMonthForward(value)")
    --print(self.getGUID() .. "/UIMonthForward()")
    --self.UI.setAttribute("monthBackward", "onClick", self.getGUID() .. "/UIMonthBackward(value)")
    --print(self.getGUID() .. "/UIMonthBackward()")
end
